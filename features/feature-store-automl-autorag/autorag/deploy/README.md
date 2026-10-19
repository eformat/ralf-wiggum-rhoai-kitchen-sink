# OGX side of the AutoRAG stack — deployment code (batch p2w14, cluster-qn8tx)

Deployment code for the OGX-centric AutoRAG wizard prerequisites on
cluster-qn8tx (KUBECONFIG=/home/mike/.kube/config.fde, OpenShift 4.22.18,
RHOAI 3.5.1, CPU-only). Project: **p2w13-autorag** (reused — DSPA p2w13-autorag
READY lives here). Collision-free names prefixed `p2w14-`.

## Run order

Anyone can re-run the setup from this tree, in this order:

1. **DSC component patches** — `deploy/dsc-ogx-activation.yaml` (APPLIED via
   `oc patch --type=merge` per component; never `oc apply` a
   DataScienceCluster manifest). Applied:
   - `ogx: Managed` (by the parent batch session)
   - `llamastackoperator: Removed` — REQUIRED before OGX can be enabled: the
     operator refuses to build the ogx module CR while the deprecated Llama
     Stack operator is Managed ("BuildModuleCR failed ... LlamaStackOperator is
     set to Managed; it has been deprecated, set it to Removed before enabling
     OGX" — the two are mutually exclusive, OGX supersedes Llama Stack).
2. **pgvector** — `deploy/pgvector.yaml`. PostgreSQL 16 with the pgvector
   extension (image pgvector/pgvector:pg16), collision-free `p2w14-pgvector`,
   databases `ogx` (vector store) + `ogx_metadata` (OGXServer metadata store).
   GOTCHA: the Ceph-backed PVC mount root has `lost+found` — initdb needs a
   subdirectory (PGDATA=/var/lib/postgresql/data/pgdata with the PVC mounted at
   /var/lib/postgresql; otherwise CrashLoopBackOff).
3. **ServingRuntime** — `deploy/setup-runtime.sh <project>`. Instantiates the
   pre-installed vllm-cpu-x86-runtime template into the project + stamps the
   template-origin annotations.
4. **Models** — `deploy/models-toolcalling.yaml` (tool-calling foundation
   models) + `deploy/embedding-model.yaml` (embedding model), THEN
   `deploy/model-conn-services.yaml` (ClusterIP connection services).
   GOTCHA (vLLM v0.24.0+rhaiv.13 in vllm-cpu-rhel9): the CPU backend startup
   check fails with a small container memory limit — set
   `--gpu-memory-utilization` explicitly (0.7) or raise the limit.
   GOTCHA: headless predictor services do not translate ports — podIP:80 is
   REFUSED (the runtime listens on 8080); the ClusterIP connection services
   translate 8080 -> pod 8080.
5. **OGXServer** — `deploy/ogxserver.yaml`. apiVersion/kind verified from the
   live CRD (ogxservers.ogx.io, v1beta1). Wires the model endpoints + pgvector
   into the OGX runtime.
   GOTCHA: this build CANNOT fetch the base OGX config from
   registry.redhat.io/rhoai/odh-ogx-core-rhel9 (the operator's config
   generation fails with "failed to fetch OCI labels ... HTTP 401" — the same
   registry auth gap the sibling ogx demo hit). `spec.baseConfig` is the
   documented escape hatch: it references a ConfigMap key with a base
   config.yaml and TAKES PRECEDENCE over OCI label resolution.
   GOTCHA: the operator only watches LABELED ConfigMaps/Secrets — referenced
   ConfigMaps and Secrets must carry `ogx.io/watch: "true"`.
   GOTCHA: the base-config merge DROPS the operator's built-in inline
   providers — only APIs with explicit providers can be enabled
   (inference/models/vector_io here); enabling batches/responses/files/
   tool_runtime KeyErrors the lifespan. The pgvector provider must be fully
   declared in the base config (the CRD pgvector item has no persistence field;
   the provider's initialize needs persistence.reference.backend).
   GOTCHA: the StackConfig requires structured fields on the sql backend —
   {connection_string, type, user} minimum; with user set the structured path
   is taken, so host/port/db/password must be set explicitly (otherwise
   asyncpg defaults to localhost:5432).
6. **OGX connection** — `deploy/ogx-connection.yaml`. The project connection
   (Secret with opendatahub.io/dashboard: "true") pointing at
   http://p2w14-ogx-service:8321/v1. Kind note: this build has NO
   DataScienceConnection/DataConnection CRD — RHOAI project connections are
   Secrets; the connection-type-ref value `ogx` follows the dashboard's OGX
   connection type (verify in the wizard dropdown).
   GOTCHA (found live, batch p2w14): the base template alone does NOT appear in
   the AutoRAG wizard dropdown — the typeahead renders "There are no secrets in
   the selected namespace". Apply `deploy/ogx-connection-wizard-keys.yaml` on
   top: the wizard queries `/autorag/api/v1/secrets?type=ogx` and matches on
   annotation `opendatahub.io/connection-type: ogx` (NOT connection-type-ref)
   + data key `OGX_CLIENT_API_KEY` (with only OGX_API_KEY the BFF excludes the
   secret — "missing for required key: ogx_client_api_key").
7. **OLM fallback** — `deploy/ogx-subscription.yaml` (NOT APPLIED — see
   "OGX operator install path" below).

## OGX operator install path (honest report)

The parent session's assumption — "the OGX operator needs an OLM subscription"
(package ogx, channel preview) — turned out WRONG on this build:

- Catalog checked: `oc get catsrc -A` -> redhat-operators IS available in
  openshift-marketplace (grpc, 15h, 630 catalog packages loaded).
- `oc get packagemanifest ogx -n openshift-marketplace` -> NotFound out of 630
  catalog packages — there is NO ogx OLM package in the redhat-operators
  catalog on this build, so a Subscription could never resolve (the file is
  provided as the fallback path if a future build ships one).
- Live evidence of the REAL path: the operator logs show the platform module
  machinery provisioning ogx gated on llamastackoperator=Removed:
  "BuildModuleCR failed ... module ogx ... LlamaStackOperator is set to
  Managed; it has been deprecated, set it to Removed before enabling OGX".
  After the patch, the operator registered ogxservers.ogx.io +
  ogxs.components.platform.opendatahub.io CRDs and started the OGX operator
  pods (ogx-k8s-operator-controller-manager + opendatahub-ogx-operator) in
  redhat-ods-applications. No OGX CSV appears — the ogx module CR (kind OGX in
  components.platform.opendatahub.io/v1alpha1, instance default-ogx) is the
  unit that reports READY.

## Verification steps

```bash
export KUBECONFIG=/home/mike/.kube/config.fde

# DSC platform + ogx module
oc get dsc default-dsc -o jsonpath='{.status.conditions[?(@.type=="OGXReady")]}' && echo
oc get ogx -A

# OGXServer
oc get ogxserver p2w14-ogx -n p2w13-autorag -o jsonpath='{.status.phase}'   # Ready
oc get svc -n p2w13-autorag | grep p2w14-ogx-service                        # :8321

# Models (deployed, READY, tool-calling args)
oc get isvc -n p2w13-autorag
oc get isvc p2w14-llama32-3b -n p2w13-autorag \
  -o jsonpath='{range .spec.predictor.model.args[*]}{.}{"\n"}{end}'         # --enable-auto-tool-choice --tool-call-parser=llama3_json
oc get isvc p2w14-qwen3-4b -n p2w13-autorag \
  -o jsonpath='{range .spec.predictor.model.args[*]}{.}{"\n"}{end}'         # --enable-auto-tool-choice --tool-call-parser=hermes

# pgvector + extension + databases
oc wait sts/p2w14-pgvector -n p2w13-autorag --for=condition=Ready --timeout=300s
oc exec -n p2w13-autorag sts/p2w14-pgvector -- \
  psql -U ogx -d ogx -tAc "CREATE EXTENSION IF NOT EXISTS vector; SELECT extname FROM pg_extension"

# Models DISCOVERED FROM OGX (the wizard lists foundation + embedding models here)
oc port-forward svc/p2w14-ogx-service 18765:8321 -n p2w13-autorag &
sleep 8
curl -s http://127.0.0.1:18765/v1/models | jq -r '.data[].id'
#   vllm-inference/p2w14-llama32-3b        type: llm
#   vllm-inference-2/p2w14-qwen3-4b        type: llm
#   vllm-embedding/p2w14-granite-embedding type: embedding

# Inference sanity check through OGX
curl -s -X POST http://127.0.0.1:18765/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"vllm-inference/p2w14-llama32-3b","messages":[{"role":"user","content":"What is the capital of France?"}],"temperature":0}' \
  | jq -r '.choices[0].message.content'
kill %1

# Connection in the project (the wizard's OGX-connection dropdown)
oc get secret p2w14-ogx-connection -n p2w13-autorag
```

## Live verdicts (2026-10-19)

- DSC default-dsc: 17/17 component keys intact, Ready True, OGXReady True;
  ogx module CR default-ogx READY True (AllDependentsHealthy).
- OGXServer p2w14-ogx: phase Ready — ConfigGenerated True (ConfigGenerationSucceeded,
  4 providers), DeploymentReady True, StorageReady True, ServiceReady True
  (p2w14-ogx-service:8321), HealthCheck True (Passed).
- Models: p2w14-llama32-3b + p2w14-qwen3-4b READY with --enable-auto-tool-choice
  + --tool-call-parser (llama3_json / hermes); p2w14-granite-embedding READY
  (--runner pooling). All DISCOVERED FROM OGX (/v1/models).
- pgvector: p2w14-pgvector Running 1/1, pgvector extension installed, databases
  ogx + ogx_metadata; registered as the vector I/O provider in the OGXServer
  stack config (vector_io pgvector, remote).
  WIZARD-CRITICAL (batch p2w14, session arcade-p2w14-wizard): the base config
  must declare the provider under `providers.vector_io` (a top-level
  `vector_io:` key is IGNORED — the AutoRAG wizard's Vector I/O provider
  dropdown was empty) AND the persistence must be FLAT {backend, namespace}
  (nested persistence.reference fails OGX startup). After the fix:
  "Initializing PGVector memory adapter" + /v1/providers lists
  vector_io pgvector remote::pgvector + the wizard dropdown populates.
- OGX connection: p2w14-ogx-connection exists (OGX_CLIENT_BASE_URL
  http://p2w14-ogx-service:8321/v1 + demo placeholder OGX_API_KEY).
  WIZARD KEYS (batch p2w14, session arcade-p2w14-wizard): the base template
  alone did NOT match the wizard's OGX-connection filter (typeahead empty).
  Applied `deploy/ogx-connection-wizard-keys.yaml` on top — annotation
  `opendatahub.io/connection-type: ogx` + data key `OGX_CLIENT_API_KEY`
  (additive patch on the existing Secret, both verified live). After the fix
  the BFF returns the connection for type=ogx and the wizard dropdown lists
  "p2w14-ogx-connection" for selection.
- Inference sanity check through OGX chat completions: "The capital of France
  is Paris."

## Honest-state notes

- CPU-only: all models are bf16 CPU deployments (7-26 tok/s per section 7.6
  without quantization), not GPU-backed.
- Model substitution (catalog checked first): the official 3.5 section 7.6 CPU
  candidates Phi-4-mini-instruct, Qwen3.5-4B-Instruct, and Qwen2.5-3B-Instruct
  have NO modelcar tags in quay.io/redhat-ai-services/modelcar-catalog; the
  deployed pair is llama-3.2-3b-instruct (officially listed in 7.6,
  llama3_json parser) + qwen3-4b (Qwen family stand-in, hermes parser). The
  7.6 embedding candidates nomic-embed-text-v1.5 and BAAI/bge-m3 have NO
  modelcar tags; granite-embedding-english-r2 is deployed instead (768-dim).
  These are bf16 modelcars, not the Q4_K_M quantizations named in the docs.
- Base-config path: this build's registry auth gap (HTTP 401 on
  odh-ogx-core-rhel9) blocks the operator's built-in config generation, so the
  stack runs on spec.baseConfig — the merge drops the built-in inline
  providers, so batches/responses/files/tool_runtime APIs are NOT enabled
  (lifespan KeyError). Model discovery (inference/models) + vector_io (pgvector)
  — the AutoRAG wizard contract — are enabled and verified; the agentic surface
  (Responses/Conversations APIs) is not available in this path (honest, TP
  surface blocked by the same merge).
- The rh-dev distribution value is deprecated (operator note: use "rh" instead);
  kept for consistency with the documented sibling precedent, switch to "rh" if
  it stops resolving.
- OGX_API_KEY in the connection is a demo placeholder (no OGX auth configured on
  this stack); no real credentials are committed.
- Out of scope here (done by other sessions/remaining): S3 connection + FED-AURA
  documents + prepared eval dataset; the dashboardConfig automl+autorag flags
  (already true on qn8tx).
