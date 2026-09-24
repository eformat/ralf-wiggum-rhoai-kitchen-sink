# RUN-PLAN: Execute all 54 labs on the CPU cluster + overlays + screenshots

> Persistent execution runbook. Multi-session: resume by checking
> `qa/status.yml` (per-lab state) and this file's checkpoints.

## Cluster facts

| | |
|---|---|
| KUBECONFIG | `~/.kube/config` |
| Server | `https://api.<cluster>.dyn.redhatworkshops.io:6443` |
| User | `admin` (cluster-admin) |
| OpenShift | 4.22.13 |
| Nodes | control-plane + 1 worker, amd64 — **no GPU** |
| Pre-installed | cert-manager v1.20.0 (OperatorGroup `cert-manager-operator-og` exists — do NOT create a second), RHBoK Keycloak (running, `sso.apps.<cluster>.dyn.redhatworkshops.io`), ODF, Quay, GitOps |
| RHOAI | NOT installed — `cluster/base` applies it |

## Step 0 — Runbook (this file) ✅

## Phase 0 — Harness + bootstrap

1. `qa/` tooling (modeled on `~/git/ph-deploy-configure-rhoai/qa-automation/e2e.yml`):
   - `qa/tools/extract-exec-blocks.py` — parse each lab's `.adoc` pages in order,
     extract `[source,bash,role="execute"]` blocks, substitute antora attributes
     (`{guid}`=abc123, `{user}`=user1, `{rhoai_version}`=3.5, `{openshift_*}` from cluster),
     emit per-lab playbooks to `qa/generated/<slug>.yml`
   - Skip rules (same as e2e.yml): disconnected module 2, "(Optional)"/"Cleanup"
     exercises, `cat`/`ls`/read-only, watch commands (`-w`, `-f`) → replaced with
     `oc wait`/`until`+`retries` polling (`oc wait` fails on not-found)
   - `qa/run-lab.sh <slug>` — run one lab, per-block logs `qa/runs/<slug>/NN.log`,
     stop-on-fail with block ID, `--from NN` resume
   - `qa/status.yml` — per-lab state: pending/pass/fail/observe-only
2. Bootstrap per `cluster/README.md`, adjusted for this cluster:
   base → `dashboard-flags` → **cpu-config (no GPU)** → serving → llmd +activation →
   gateway (**skip cert-manager sub**) + Kuadrant activation → monitoring →
   `maas-secrets` + envsubst MaaS → trustyai/ogx/mcp/registry/mlflow/feature-store/distributed
   → `cluster-verify` green

## Phase B–K — Labs in dependency order

| Phase | Labs | Gate |
|---|---|---|
| B | vllm-serving-runtime-kserve, rhai-fast-release-images, vllm-cpu-ibm-z-power (x86 — expect observe-only) | served models |
| C | llmd-core → llminferenceservice-config → kv-cache/latency/lora-routing → priority-flow-control | llmd-core first |
| D | maas-core → maas-vllm → maas-llmd → multi-tenancy → multi-provider → oidc-auth (Keycloak) → loki-showback → external-metering ×2 | MaaS Ready |
| E | kueue (CPU by design), kuberay + kubeflow-trainer-v2 + text-mode (observe-only) | Kueue substrate from labs |
| F | nemo-guardrails, nemo-guardrails-mcp-gateway (Istio — evaluate), evalhub, garak, tool-calling-eval | trustyai |
| G | llama-stack-ogx-core, ogx-agentic-api, ogx-file-processors, ogx-remote-providers | OGX up |
| H | mcp-lifecycle, mcp-catalog ×2, mcp-gateway-operator | mcplifecycleoperator |
| I | model-registry-catalog, mlflow, feature-store-feast, automl | components Managed |
| J | agent/dashboard/flag labs (ai-available-assets, genai-studio, agent-catalog, view-agent, csv-export, starter kits, kale, openshell, midojo, opencode, validated-tool-calling) | flags in base |
| K | gateway-api-rhcl, platform-oidc-auth (Keycloak live; OCP 4.22 ✓) | RHCL |

Per lab: run blocks → `=== Verify` sections as acceptance gates → screenshots
(playwright-cli + workshop-screenshot skill; shot list from `image::` refs + RAC
criteria; deterministic filenames into each lab's
`features/<cat>/<slug>/content/modules/ROOT/assets/images/`; evidence to
`rac/<slug>/assets/screenshot-evidence-<slug>.md`) → rebuild site per batch.

## Iteration rules

- Failure → diagnose → fix at the right layer: genuine doc bug → edit `.adoc`;
  cluster-config gap → patch the overlay (+ `feature-overlays.yml` if the mapping
  was wrong); cluster issue → note it. Re-run `qa/run-lab.sh <slug> --from NN`.
- Every fix logged in `qa/runs/<slug>/fixes.md`.
- TODO screenshot placeholders → real captures; observe-only labs get
  "requires GPU node" notes.

## GPU tracking

See `cluster/GPU-TRACKING.md` — labs needing a GPU node are run observe-only
this pass; revisit when the GPU cluster lands.

## Checkpoints

- [x] RUN-PLAN.md written
- [x] qa/ harness builds + extraction runs clean (54 playbooks generated)
- [x] cluster-verify green after bootstrap (28 ok, 0 failed, 3 skipped)
- [x] All 54 labs executed: **40 pass, 14 observe-only, 0 fail** (`qa/status.yml`)
- [x] Screenshots: 19 captures across 17 labs (`qa/rac-evidence/screenshot-evidence.md`)
- [x] End-of-run report (below)

## End-of-run summary (2026-09-23)

**Cluster:** CPU cluster (OCP 4.22.13, amd64, no GPU, RHOAI 3.5.1)

**Executed:** all 54 workshops via the qa/ harness (extract → run → verify →
screenshots → fix → iterate). Every failure was diagnosed and fixed at the
right layer; docs improved as I go.

**Pass (40):** all serving, llm-d platform, maaS governance, mcp, registry,
kueue, kuberay (1-2), agents/dashboard, and platform-gateway labs.

**Observe-only (14)** — need a GPU node (see cluster/GPU-TRACKING.md):
kubeflow-trainer-v2, text-mode-multimodal-training, kuberay (module 3),
llmd-kv-cache-tiering, llmd-latency-routing, llmd-lora-routing,
llmd-priority-flow-control, maas-llmd-deployment, maas-vllm-deployment,
llama-stack-ogx-core, ogx-agentic-api, ogx-remote-providers, automl,
nemo-guardrails-mcp-gateway (the only Service-Mesh lab).

**Bootstrap learnings (fixed in cluster/ docs):** DSC v2 manifests; SSA +
distinct field-managers; clusterip gateways for no-LB clusters; RHBoK is a
separate operator (stable-v1.3 pin) + activation CR; cert-manager skipped.

**Key ground-truth findings fixed in lab docs:**
1. ServingRuntimes are NOT pre-installed on 3.5.1 — created from templates
2. kserve resolves `spec.predictor.runtime` from the ISVC's own namespace
3. MaaS flip is `aigateway.modelsAsAService` (3.5 pattern)
4. Project pages need `opendatahub.io/dashboard=true` for dashboard visibility
5. KGServer/OGXServer v1beta1 schemas; Prometheus queries vs shell commands
6. Repo-wide pattern: file-creation blocks converted to executable heredocs

**Screenshot backlog:** authenticated wizard/dialog shots listed in
`qa/rac-evidence/screenshot-evidence.md`.

## Bootstrap learnings (fixed in cluster/ docs)

1. **DSC v2 (3.5)**: manifests migrated to `datasciencecluster.opendatahub.io/v2`;
   `datasciencepipelines` removed in v2 (superseded by aipipelines); `kueue`
   component deprecated (Managed rejected — Kueue ships with the operator)
2. **SSA + distinct field-managers required**: client-side apply (and SSA with a
   shared manager) PRUNES components set by previously-applied overlays; use
   `--server-side --force-conflicts --field-manager=kustomize-<overlay>`
3. **No LoadBalancer provider on this cluster**: both gateways moved to the
   clusterip pattern (data-science-gateway-class + service-params ConfigMap +
   Route); `make gateway-status` feeds Route hostnames into the Service status
   so Gateways report PROGRAMMED
4. **cert-manager skipped** (pre-installed, OG exists); RHCL 1.4.3 / COO / OTel
   subscriptions applied
5. `disableEvalHub` unknown field removed from the dashboard flags patch
