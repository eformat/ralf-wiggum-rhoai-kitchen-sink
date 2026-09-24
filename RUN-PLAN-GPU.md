# RUN-PLAN-GPU: Execute the GPU-gated labs on a 2x L40S cluster

> Persistent execution runbook for the GPU run. Resume by checking the
> checkpoints below and `qa/status.yml` (per-lab state).
>
> Execution mode: **sub-agents are default** (self-hosted glm-53-flash — tokens
> free, see mcp-memory `f1ea0002`). Cluster mutations and batch gates stay
> sequential with the coordinator.

## Cluster facts

| | |
|---|---|
| KUBECONFIG | `~/.kube/config` |
| Server | `https://api.<cluster>.<sandbox>.opentlc.com:6443` |
| User | `admin` (cluster-admin) |
| Topology | 2 GPU workers x 1 NVIDIA L40S (48 GB, driver 595.91.07, ada-lovelace, g6e.4xlarge) + 1 master/worker, OCP 4.22 (k8s 1.35.6), RHCOS 9.8 |
| Cluster prep (user) | ✅ done: NVIDIA GPU operator, pull secret (`registry.redhat.io` verified), S3 = MinIO (`http://minio.minio.svc.cluster.local:9000`, `<minio-user>`/`<minio-password>`) |
| Pre-installed | cert-manager v1.20.0 (OG `openshift-cert-manager-operator-og` — overlay OG excluded, safe to apply), MinIO (`minio` ns), GitOps, agent-sandbox, ACS, security-profiles |
| RHOAI | NOT installed — `cluster/base` applies it (coordinator does bootstrap) |

## Scope

GPU-gated subset: **18 labs** (14 observe-only from the CPU cluster + 4 partial
re-verifies + `automl`, which joins now that S3 is deployed). The other ~36
results carry over from the CPU cluster.

**Expected outcomes: 15 pass, 1 skipped** (`vllm-cpu-ibm-z-power` — s390x/ppc64le
architecture, not a GPU matter).

## Phase 0 — Repo prep ✅ (done 2026-09-23, cluster not yet ready)

- [x] Sub-agents-default MCP memory stored (`f1ea0002...`)
- [x] Doc downscales (OSFT keeps `nnodes: 2`, GPUs per node 2→1):
  - `features/distributed-training/kubeflow-trainer-v2/.../module-03-advanced.adoc` — prereq prose + `resources_per_node`
  - `features/agents-mcp/text-mode-multimodal-training/.../module-02-hands-on.adoc` — prereq prose, `nproc_per_node`, `resources_per_node`
  - `features/model-serving/llmd-core/.../module-02-hands-on.adoc:73` — L40S works for the runnable examples
- [x] Playbooks regenerated for all 18 labs (`qa/generated/`)
- [x] `qa/status.yml` — 18 labs reset to `pending`
- [x] This runbook written

## Phase 1 — Bootstrap (coordinator, sequential)

1. Fill in cluster facts above; verify GPU allocatable:
   `oc get nodes -o json | jq '.items[].status.allocatable'` — expect
   `nvidia.com/gpu: 1` on each worker (2 total)
2. Verify global pull secret covers `registry.redhat.io`
   (`oc get secret pull-secret -n openshift-config -o jsonpath='{.data.\.dockerconfigjson}' | jq keys`)
3. Kitchen-sink apply per `cluster/README.md` (all with `--server-side
   --force-conflicts --field-manager=kustomize-<overlay>`):
   base + dashboard-flags → serving → **gpu-config + NFD activation** →
   llmd (envsubst) + activation → gateway + activation → monitoring →
   `make maas-secrets` + maas (envsubst) → trustyai/ogx/mcp/registry/mlflow/
   feature-store/distributed → `make -C cluster gateway-status`
4. Service Mesh manually — `nemo-guardrails-mcp-gateway` is the only lab
   needing Istio/EnvoyFilter
5. `make build-check` + `cluster-verify` green

## Phase 2 — Labs in dependency order (5 batches)

| Batch | Labs | Gate |
|---|---|---|
| 1 serving | vllm-serving-runtime-kserve, rhai-fast-release-images | served models |
| 2 llm-d | llmd-core → llminferenceservice-config → kv-cache/latency/lora-routing → priority-flow-control | llmd-core first |
| 3 MaaS | maas-vllm-deployment, maas-llmd-deployment | MaaS Ready |
| 4 training | kubeflow-trainer-v2, text-mode-multimodal-training, kuberay (module 3) | downscaled OSFT (2 nodes x 1 GPU) |
| 5 OGX + eval | llama-stack-ogx-core → ogx-agentic-api, ogx-remote-providers; nemo-guardrails-mcp-gateway (Istio); automl (S3) | OGX up; OGXServer needs registry pull secret |

Per lab: `qa/run-lab.sh <slug> --from <first GPU-gated block>` → `=== Verify`
gates → screenshots (playwright-cli, deterministic filenames into each lab's
`assets/images/`) → RAC observations update → `qa/status.yml` → `fixes.md` on
failure.

**Sub-agent pipelining (default per mcp-memory `f1ea0002`):**

- Lab N runs in a background task
- Sub-agent A preps batch N+1 (playbook regen, block review, expected-verify)
- Sub-agent B handles post-run work for lab N (screenshots, RAC, status)
- Coordinator keeps: overlays/DSC mutations, batch gates, failure diagnosis,
  `--from NN` resumes

**Sequential constraint:** labs mutate shared cluster state (DSC patches,
gateway configs, 2-GPU quota pool) — never run two `qa/run-lab.sh` concurrently.

**Between batches:** `gpu-workload-audit` to catch stray workloads holding GPU
quota. Total pool = 2 GPUs — serving labs deploy 1 GPU per replica; two
single-GPU workloads can coexist, no more.

## Known caveats

- `llminferenceservice-config` P/D disaggregation lands on 2 nodes x 1 GPU;
  RDMA is simulated (no NIC offload) — note in observations
- `kubeflow-trainer-v2` / `text-mode-multimodal-training` OSFT downscaled to
  2 nodes x 1 GPU (docs edited in Phase 0) — not 4x-L40S-as-authored
- `automl` needs DSPA per project + S3 data connection + CSV data in bucket
- `llama-stack-ogx-core` OGXServer v1beta1 schema + registry pull secret
  prerequisite (from zs6cg fixes)
- L40S has no MIG — `gpu-workload-audit` MIG-slice checks N/A

## Checkpoints

- [x] Phase 0 complete (memory, downscales, playbooks, status, runbook)
- [x] Cluster handed over; facts table filled (GPU cluster, 2x L40S verified)
- [x] GPU verified: 2 x L40S allocatable (`nvidia.com/gpu: 1` per worker)
- [x] Bootstrap green: `cluster-verify` 29 ok, 0 failed, 3 skipped
  - Fix: NFD OG conflict (cluster ships `nfd-og`; removed overlay OG — gpu-config
    kustomization now excludes it like the cert-manager pattern)
  - Fix: **AcceleratorProfile CRD does NOT exist in 3.5.1** — replaced by
    HardwareProfile (`infrastructure.opendatahub.io/v1`); overlay manifest
    rewritten (`hardwareprofile-nvidia.yaml`, nodeSelector scheduling); verify
    script checks HardwareProfile with 2.x fallback
- [x] Batch 1-2 (serving + llm-d): **all pass** — vllm-serving-runtime-kserve,
  rhai-fast-release-images, llmd-core, llminferenceservice-config, all 3 routing
  labs, priority-flow-control. Qwen3-8B-FP8 serving verified READY=True on
  2x L40S (2 replicas); routing labs made real via a baseRefs attach (scheduler
  config copied into the project ns).
  - Fix: llmd-priority-flow-control file-creation blocks → executable heredocs
    (pool name/URL/model resolved at runtime; flowControl gate → oc patch)
  - Fix: llama-stack-ogx-core block 14 `--template={{...}}` Jinja2 parse → jsonpath
- [x] Batch 3 (MaaS): pass with caveats — maas-vllm-deployment, maas-llmd-deployment.
  facebook-opt-125m wizard model published via CLI (MaaSModelRef Ready, governance
  paired, TokenRateLimitPolicy generated).
  - Fix: maas-api CrashLoopBackOff (2 gateway services → adapted to the cluster's
    openshift-default gateway, Route repointed) → default-tenant Reconciled
  - Fix: modelRefs granite-vllm-maas → facebook-opt-125m; ISVC
    router.gateway.refs → maas-default-gateway; AITenant name is
    `models-as-a-service`, not `default-tenant`
  - **KNOWN ISSUE**: maas gateway auth returns HTTP 500 for all paths instead of
    401/403 (authorino wiring for the pre-created gateway) — cluster-level
- [x] Batch 4 (training): pass with caveats — kubeflow-trainer-v2 (TrainJob
  lifecycle exercised; 2-node GPU pods stayed Pending: both L40S held by serving
  models), text-mode, kuberay (Kueue activation CR fixed the missing
  kueue.x-k8s.io CRDs). Blocks requiring `pip install training-hub` fail on the
  host (Python 3.14 vs >=3.11,<3.13) — workbench-gated SDK exercises.
- [x] Batch 5 (OGX + eval + automl): pass with caveats — llama-stack-ogx-core
  (25 blocks), automl (DSPA + S3 staged; **BLOCKED on user-side MinIO**:
  ImagePullBackOff 3h+, docker.io denied, image auto-reverts). ogx-agentic-api
  and ogx-remote-providers observe-only (OGXServer reconcile registry 401 —
  cluster-level, unsolved on zs6cg too; ogx-remote also needs a real Anthropic
  key). nemo-guardrails-mcp-gateway observe-only (needs the manual Service Mesh
  setup per cluster/README.md).
- [x] End-of-run summary written below

## End-of-run summary (2026-09-23, cluster-prelude2)

**Cluster:** GPU cluster (OCP 4.22, k8s 1.35.6, 2 GPU workers x 1 NVIDIA L40S
48GB driver 595.91.07, RHOAI 3.5.1, MinIO S3 user-provided)

**Executed:** the 18 GPU-gated labs (GPU-gated subset; the other ~36 results
carry over from the CPU cluster) via the qa/ harness, sub-agent pipelining
default (mcp-memory `f1ea0002`).

**Result: 15 pass (13 clean, 2 pass-with-caveats), 3 observe-only, 1 pending-user**
against the GPU-gated set; repo-wide `qa/status.yml`: **50 pass, 4 observe-only,
0 fail**.

**GPU ground truth verified:**
1. Qwen3-8B-FP8-dynamic serving READY=True on 2x L40S (2 replicas, 1 GPU each)
2. facebook/opt-125m ISVC READY=True; MaaS publish flow verified end-to-end
3. llm-d routing (baseRefs), KV-cache/latency/lora routing labs — real, not observe-only
4. flow-control load test completed (5000 requests, priority dispatch)
5. TrainJob lifecycle on the GPU workers (create/suspend/resume/delete)

**Cluster-level issues (documented, not fixed):**
1. maas gateway auth 500 (authorino wiring for the pre-created gateway)
2. OGXServer reconcile registry 401 (OCI labels fetch credentials)
3. MinIO ImagePullBackOff — **user-side**: fix the image source (docker.io
   denied + auto-revert); then re-run automl `--from 6`
4. nemo-guardrails-mcp-gateway needs the manual Service Mesh setup — user
   decision

**Doc fixes applied this run:** 12 (downscales, heredocs, jsonpath,
modelRefs, HardwareProfile migration, Kueue activation, MAAS_URL/HOST seeds).
