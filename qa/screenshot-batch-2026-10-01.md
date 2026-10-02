# Screenshot batch — 2026-10-01

Closed out the 20 no-image workshops from the 2026-09-30 scan (`qa/remaining-work.md` S1–S4 plan).
8 workshops gained valid topical captures; 4 are by-design (no screenshots by design); 3 blocked
upstream; the rest already clean. Live captures from cluster-44gxc (RHOAI 3.5.1) via playwright-cli,
console auth through the workshop Keycloak (rhbk realm `admin` — the realm import Secret's password
did NOT match the live realm; interactive login with the workshop creds works).

## Batch result

| # | Workshop | Capture | Embed point | S |
|---|----------|---------|-------------|---|
| 1 | maas-oidc-auth | `01-aitenant-oidc-yaml.png` (recaptured 2026-09-30, was orphaned on disk) | module-01 Ex 2 step 4 (AITenant YAML tab) | S1 |
| 2 | validated-tool-calling-config | `01-validated-arguments-filter.png` — AI hub Models catalog with the *Validated arguments > Tool calling* filter checked, tool-calling validated models listed | module-01 Ex 2 step 3 | S2 |
| 3 | mcp-gateway-operator | `01-mcpgatewayextension-ready.png` — MCPGatewayExtensions tab, `mcp-gateway-one` Condition: Ready | module-01 Ex 3 (wait-for-Ready step) | S2 |
| 4 | kueue | `01-localqueue-yaml.png` — `workshop-lq` LocalQueue YAML with the `kueue.x-k8s.io/default-queue: 'true'` annotation visible | module-01 console step 3 | S2 |
| 5 | kubeflow-trainer-v2 | `01-trainjob-dashboard.png` — dashboard Jobs page listing `pytorch-minimal-example` (TrainJob, 2 nodes) | module-03 Ex 2 (dashboard TrainingJobs step) | S3 |
| 6 | view-agent-deployments | `01-sandbox-crs.png` — console Sandboxes tab, both Sandboxes Condition: Ready | module-01 Ex 3 (Trace the Sandbox CRs) | S3 |
| 7 | openshell-agent-sandboxing | `02-sandbox-pods.png` — workshop-namespace pods including both sandboxed agent pods Running | module-02 Ex 3 (pod observation step) | S3 |
| 8 | mlflow-experiment-tracking | `02-experiment-overview.png` — MLflow demo-run overview: accuracy/loss metrics, Status Finished, run stats | module-02 Verify (after the experiments-list image) | S4 |

All captures verified per the skill rules (final URL/title + content check, no 404/error/modal/empty
states, populated, topical). `make build` clean (0 errors); every embed renders in the built site.
No execute-block content changed → no playbook regen needed.

## No action (documented)

- **By-design (4):** midojo-adversarial-testing, text-mode-multimodal-training,
  external-metering-maas, external-metering-per-user — CLI-driven, no screenshots by design.
- **kale-jupyterlab** — Kale toggle broken on the 3.5 runtime image (C4 finding): content
  correction, not a screenshot task.
- **mcp-catalog-admin** — the settings page 404s in the 3.5.1 build; not capturable.
- **evalhub** — CLI-driven, no visual criteria; env GC'd deliberately. No action.
- **Blocked upstream (3):** garak (garai CLI + GPU), claude-code-starter-kit +
  maas-multi-provider-passthrough (Anthropic creds), autorag (driver-image bug).

## Environment findings (for content / platform review)

1. **Agent Ops view does not exist in the 3.5.1 dashboard** (view-agent-deployments,
   openshell-agent-sandboxing): despite `agentOps: true` in the OdhDashboardConfig, the
   agent-ops module deployed by the dashboard operator, the agent-ops-ui backend Running, and a
   dashboard rollout restart — the Gen AI studio nav has no Agent ops entry and
   `/gen-ai-studio/agent-ops` + `/agent-ops` both 404 ("We can't find that page"). The dashboard
   surface must ship before the original capture is possible. The operator gap IS closed: the Red
   Hat build of Agent Sandbox operator (v0.9.0, preview-0.9) is installed and two Sandboxes are
   Running — each workshop got an honest capture of the CRs/pods behind the list, and both stale
   TODOs were rewritten with the current state.
2. **Console Search does not render results for Sandboxes/TrainJob kinds** — the filter bar lists
   the resource but the results table stays empty (same behavior for both CRDs). TrainJob is
   captured from the dashboard Jobs page instead (which works).
3. **Kubeflow Trainer v2 unblock chain (3.5 ground truth):** TrainJob CRD absent → apply the
   documented JobSet install (`cluster/overlays/llmd/serving-operators/`: namespace + OperatorGroup
   + subscription, stable-v1.0) → CSV Succeeded → DSC `TrainerReady` still False with
   "JobSetOperator CR with name 'cluster' not found" → create the `JobSetOperator cluster` CR
   (Managed) → TrainJob/TrainingRuntime CRDs install and DSC Ready. The JobSetOperator CR
   activation step is NOT in the cluster README — worth adding.
4. **mcp-gateway-operator gatewayClassName drift:** the workshop's Ex 2 uses
   `gatewayClassName: openshift-default`, but on this cluster that class never provisions a router
   deployment → the extension stuck at "broker-router deployment is not ready". Patching the
   Gateway to `data-science-gateway-class` (the class the working mcp-system setup uses)
   provisions `mcp-gateway-data-science-gateway-class` and the extension goes Ready. TODO: the
   workshop's Ex 2 gatewayClassName may need a content correction or a note for RHDP clusters.
5. **automated-tool-calling-eval stays blocked upstream** — evalhub model-proxy never injects the
   secret's token into proxied model requests (all garak submissions 401; token verified correct
   when curled directly). No completed results → the `evalhub eval results` table capture is
   impossible until the upstream fix. Same class as the autorag driver-image bug.
6. **Keycloak realm import Secret ≠ live password:** the `keycloak-keycloak-realm` Secret's
   `admin` password does not match the live realm (provisioning randomizes it). Console login
   requires the workshop-issued credentials.

## Cluster changes made (for Mike's review — additive/deletable unless noted)

- `openshift-operators`: Subscription `agent-sandbox-operator` (preview-0.9) — AllNamespaces.
- `abc123-user1`: Sandbox CRs `tool-calling-agent` + `openshell-agent` (Running, ubi9-minimal
  sleep — test fixtures, deletable).
- `abc123-mcp-system` (new namespace): Subscription + OperatorGroup `mcp-gateway` (CSV v0.7.1
  Succeeded, pulls authorino/cluster-observability deps); MCPGatewayExtension `mcp-gateway-one`
  (Ready).
- `abc123-gateway`: Gateway `mcp-gateway` (data-science-gateway-class, http+mcp listeners,
  router deployment Running) + ReferenceGrant `allow-mcp-extension`.
- `openshift-jobset-operator` (new namespace): JobSet operator per the documented llmd overlay
  (CSV v1.0.1 Succeeded) + `JobSetOperator cluster` CR (Managed).
- `abc123-user1`: ConfigMap `minimal-train-script` + TrainJob `pytorch-minimal-example`
  (Created; stays Pending on GPU — CPU-only cluster, matches the lab's exact manifest).
- `redhat-ods-applications`: MLflow CR pre-existing (v3.14.0, untouched).
- `abc123-user1`: Notebook `my-workbench` (runtime-datascience) annotated
  `opendatahub.io/mlflow-instance=mlflow`; demo-experiment/demo-run logged through it
  (deletable: the notebook + experiment).
- `redhat-ods-applications`: rhods-dashboard rollout restart (transient — nav re-read).
- Earlier in session: `~/.kube/config` token refreshed from `config.fde` (auth housekeeping).
