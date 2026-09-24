# RHOAI 3.5 Workshop Cluster Configuration

Kustomize configuration for the base RHOAI setup every feature workshop in this
repo assumes: `base` + fine-grained overlays. OpenShift itself is a
prerequisite — this configures **RHOAI only**.

Derived from the manifests and deploy flow of `~/git/ph-deploy-configure-rhoai`
(numbered kustomize phases, two-tier versioning with `-35` suffixes,
wait-for-ready verification). Requirements were audited against all 54 feature
workshops (`rac/` corpora): every DSC patch, OLM subscription, dashboard flag,
namespace label, and cluster-side assumption.

## Layout

```
cluster/
  README.md              # this file
  Makefile               # dashboard-flags, maas-secrets, enable-cpu-runtime, cluster-verify, build-check
  feature-overlays.yml   # machine-readable feature → overlay map (skill + home hub consume)
  base/                  # operator + core DSC/DSCI + dashboard-flags patch (make dashboard-flags)
  overlays/
    gpu-config/          # NFD operator + sample NVIDIA AcceleratorProfile          [two-step]
    cpu-config/          # CPU-only variant (vLLM CPU ServingRuntime enablement)
    serving/             # KServe model-serving platform (RawDeployment, no Service Mesh)
    llmd/                # openshift-ai-inference Gateway + JobSet/LWS operators     [two-step]
    gateway/             # cert-manager + RHCL/Kuadrant                              [two-step]
    monitoring/          # UWM + Cluster Observability Operator + OpenTelemetry
    maas/                # aigateway.modelsAsAService flip + PostgreSQL + maas-default-gateway
    trustyai/ ogx/ mcp/ registry/ mlflow/ feature-store/   # single-component DSC patches
    distributed/         # Ray + Kueue (RHBoK <=1.3) + Trainer + Training Operator
    oidc/                # base-only no-op (OCP direct-OIDC is install-time config)
  verify/cluster-verify.sh   # wait-for-ready checks per overlay
```

Every overlay's `kustomization.yaml` includes `../../base`, so
`oc apply -k overlays/<x>` applies base + that overlay in one shot and stacking
overlays is cumulative and idempotent.

## Prerequisites (documented, not scaffolded)

- GPU worker nodes / supported accelerators (for the `gpu-config` labs; the
  kueue lab runs CPU-only by design, and vllm-cpu-ibm-z-power needs IBM Z/Power)
- External OIDC IdP (Keycloak) for the `platform-oidc-auth` / `maas-oidc-auth`
  labs — OCP direct-OIDC is install-time configuration
- `registry.redhat.io` pull secrets (training images, RHEL postgres)
- S3-compatible storage for model/data connections (per-lab)
- Keycloak realms/clients for OGX and gateway auth demos (per-lab)

## Apply flow

> **IMPORTANT (3.5 ground truth, learned by testing):** apply with
> `--server-side --force-conflicts --field-manager=kustomize-<overlay>` for any
> overlay that patches the DataScienceCluster. Client-side `oc apply` PRUNES
> components set by previously-applied overlays (last-write-wins on
> `spec.components`), and a shared field-manager does the same. Distinct
> field-managers make each overlay own only its component keys.
>
> The 3.5 operator stores the DSC as the **v2 API** — DSC manifests here use
> `datasciencecluster.opendatahub.io/v2`. In v2: `datasciencepipelines` is
> removed (superseded by `aipipelines`), and the `kueue` component is
> deprecated (Kueue/RHBoK ships with the rhods-operator; setting
> `kueue: Managed` is rejected).

Full kitchen-sink cluster (all 54 labs runnable):

```bash
oc apply --server-side --force-conflicts --field-manager=kustomize-base -k cluster/base
make wait-csv NS=redhat-ods-operator PREFIX=rhods-operator
make -C cluster dashboard-flags                 # OdhDashboardConfig: all workshop flags

oc apply --server-side --force-conflicts --field-manager=kustomize-serving -k cluster/overlays/serving

# no LoadBalancer provider (RHDP/bare-metal): clusterip gateways + Routes,
# applied with envsubst (routes carry ${CLUSTER_DOMAIN}); the llmd overlay
# includes the gpu-config prerequisite NFD only in gpu-config (skip w/o GPU):
export CLUSTER_DOMAIN=$(oc get ingress.config cluster -o jsonpath='{.spec.domain}')
oc apply --server-side --force-conflicts --field-manager=kustomize-llmd -k cluster/overlays/llmd   # fails on route ${CLUSTER_DOMAIN}
# -> use the envsubst form for llmd AND maas:
oc kustomize cluster/overlays/llmd | envsubst '${CLUSTER_DOMAIN}' | \
  oc apply --server-side --force-conflicts --field-manager=kustomize-llmd -f -
make wait-csv NS=openshift-lws-operator PREFIX=leader-worker-set
make wait-csv NS=openshift-jobset-operator PREFIX=jobset
oc apply -k cluster/overlays/llmd/activation

oc apply --server-side --force-conflicts --field-manager=kustomize-gateway -k cluster/overlays/gateway
make wait-csv NS=openshift-operators PREFIX=rhcl
oc apply -k cluster/overlays/gateway/activation

oc apply --server-side --force-conflicts --field-manager=kustomize-monitoring -k cluster/overlays/monitoring

# MaaS: flip depends on gateway + monitoring + serving, needs the DB secrets
# and the cluster domain rendered:
make maas-secrets
oc kustomize cluster/overlays/maas | envsubst '${CLUSTER_DOMAIN}' | \
  oc apply --server-side --force-conflicts --field-manager=kustomize-maas -f -

for o in trustyai ogx mcp registry mlflow feature-store distributed; do
  oc apply --server-side --force-conflicts --field-manager=kustomize-$o -k cluster/overlays/$o
done

# no-LB clusters: feed the Route hostnames into the gateway Service status so
# the Gateways report PROGRAMMED=True (run after the maas overlay):
make -C cluster gateway-status

make cluster-verify                           # wait-for-ready checks
```

Single-lab setup: apply only the overlays its row lists, in the order they
appear in `cluster/feature-overlays.yml` (base is always included by each
overlay). Example — the `llmd-core` lab: `serving` → `llmd` → `gpu-config`.

## Two-step overlays

| Overlay | Activation step | Applied after |
|---|---|---|
| `gpu-config` | `activation/` (NodeFeatureDiscovery) | NFD CSV Succeeded |
| `llmd` | `activation/` (LWS + JobSet `cluster` CRs) | LWS + JobSet CSVs Succeeded |
| `gateway` | `activation/` (Kuadrant CR) | RHCL CSV Succeeded |

## Ordering constraints baked in

- **MaaS flip last**: `aigateway.modelsAsAService` stays Removed at install;
  the `maas` overlay flips it only after RHCL + Kuadrant + maas-default-gateway
  (prevents `AIGatewayReady=False` at install).
- **llamastackoperator Removed before ogx Managed** (mutually exclusive — OGX
  supersedes LlamaStack); enforced in base and re-asserted in `ogx`.
- **RHBoK <= 1.3**: Kubeflow Trainer v2 is not compatible with RHBoK 1.4+ —
  keep `rhods-operator` on `stable-3.5` (see `overlays/distributed/dsc-patch.yaml`).
- **No Service Mesh v2**: kserve uses RawDeployment (`Headless`); llm-d labs
  explicitly assume Service Mesh is ABSENT. Exception: `nemo-guardrails-mcp-gateway`
  needs Istio/EnvoyFilter — apply Service Mesh manually for that lab only.
- **OCP >= 4.19.9** for Gateway API / direct-OIDC labs; **OCP 4.22+** for the
  MCP catalog labs.
- **Kuadrant >= 1.4.2** for `maas-multi-tenancy`; RHCL >= 1.4.1 elsewhere.

## Feature → overlay mapping

The full 54-lab mapping lives in `cluster/feature-overlays.yml` (machine-readable,
consumed by the ralf-wiggum-loop skill and rendered on the home hub "Cluster
setup" page). Highlights:

| Lab group | Overlays beyond base |
|---|---|
| kale, midojo, starter kits, openshell, view-agent, agent-catalog | *(base-only)* |
| mcp-lifecycle / catalog / gateway-operator | `mcp` (+ `gateway`) |
| ogx-agentic-api, ogx-file-processors, ogx-remote-providers | `ogx` |
| registry / automl / csv-export | `registry` |
| mlflow (+ opencode, genai-studio tracing) | `mlflow`, `serving` |
| feature-store-feast | `feature-store` |
| guardrails, evalhub, garak, tool-calling-eval | `serving`, `trustyai` (+ `distributed` for evalhub) |
| kueue | `distributed`, `monitoring` |
| kuberay, kubeflow-trainer-v2, text-mode-multimodal | `distributed`, `llmd`, `gpu-config` |
| vllm-kserve, rhai-fast-release-images | `serving`, `gpu-config` |
| vllm-cpu-ibm-z-power | `serving`, `cpu-config` |
| llmd-* (core, routing, priority, config) | `serving`, `llmd` (+ `monitoring`, `gpu-config`) |
| gateway-api-rhcl | `gateway` |
| platform-oidc-auth | `oidc` (base-only no-op) |
| maas-* | `gateway`, `maas` (+ `monitoring`, `serving`, `llmd`, `gpu-config` per lab) |

## Verification

- `make build-check` — `kustomize build` every overlay (catches YAML/patch errors)
- `make cluster-verify` — wait-for-ready checks: operator CSV Succeeded, DSC/DSCI
  Ready, dashboard flags, Gateways `PROGRAMMED`, tenant `READY`, component states.
  Checks auto-SKIP for overlays that were not applied.
- Re-running `oc apply -k` on any overlay makes no changes (idempotent).

## Deliberately NOT scaffolded (labs do their own exercises)

Per-lab CRs stay exercises: EvalHub instances, MCP servers/gateway operator,
MaaS tenants + subscriptions + model refs, Guardrails CRs, LLMInferenceServices,
model deployments, Kueue ResourceFlavor/ClusterQueue/LocalQueue (the kueue lab
creates them), MLflow instance, FeatureStore, GatewayConfig OIDC patch
(`platform-oidc-auth` REQ-003), MCP gateway Operator (installs in-lab via OLM).
