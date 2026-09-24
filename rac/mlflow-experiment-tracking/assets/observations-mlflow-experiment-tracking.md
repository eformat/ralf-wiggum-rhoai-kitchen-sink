# Observations: MLflow experiment tracking / MLOps integration (doc-derived)

## Summary

MLflow experiment tracking is RHOAI 3.5's GA path for tracking experiments and
managing models with MLflow: a single shared, cluster-scoped `MLflow` instance
deployed through the MLflow Operator, where each OpenShift project maps to an
MLflow workspace and every API request is authorized with Kubernetes RBAC.
This observation document was produced from the official RHOAI 3.5 product
documentation (Working with MLflow) because no live demo cluster was available
at authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | mlflow-working-with-mlflow.txt | §1 MLflow for experiment tracking | Single shared MLflow instance via the MLflow Operator; one-to-one project-to-workspace mapping; logical isolation of experiments, runs, registered models, prompts, datasets, and traces per workspace; workspaces managed outside the MLflow API via dashboard or `oc` |
| 2 | mlflow-working-with-mlflow.txt | §2.1–2.3 Configuration, cluster roles, RBAC | `MLflow` CR is cluster-scoped (exactly one instance, named `mlflow`, in `redhat-ods-applications`); `backendStoreUri` sqlite:// (dev) vs postgresql:// (prod); `MLflowConfig` namespace-scoped for per-project artifact overrides; server authorizes every request with `SelfSubjectAccessReview` against `mlflow.kubeflow.org` pseudo-resources (`experiments`, `registeredmodels`, `datasets`); `mlflow-view`, `mlflow-edit`, `mlflow-integration` aggregate ClusterRoles carry over OpenShift `view`/`edit`/`admin` |
| 3 | mlflow-working-with-mlflow.txt | §3 SDK install, auth, storage | `pip install "mlflow[kubernetes]>=3.11"`; automated auth via `MLFLOW_TRACKING_URI` + `MLFLOW_TRACKING_AUTH=kubernetes-namespaced` or manual `MLFLOW_TRACKING_TOKEN` + `MLFLOW_WORKSPACE`; SQLite/PVC dev vs PostgreSQL/S3 production; artifact serving unsupported with `file://` + `spec.storage` |
| 4 | mlflow-working-with-mlflow.txt | §4 Workbench integration | `opendatahub.io/mlflow-instance` annotation drives env-var injection (mutating webhook) + RoleBinding provisioning (`<notebook>-mlflow` → `mlflow-operator-mlflow-integration` ClusterRole, reconciler with owner reference); dashboard-managed annotation when Dashboard/MLflow/Workbenches all `Managed`; stop-first requirement with validating webhook checking `kubeflow-resource-stopped`; non-blocking admission on missing GatewayAPI hostname |
| 5 | mlflow-working-with-mlflow.txt | §5 Track and compare experiments | Dashboard page under `Develop & train > Experiments (MLflow)` after operator enabled + CR created; same data as standalone MLflow UI; browse/compare runs with parallel coordinates, scatter, box, contour plots; `Show differences only` toggle; experiment names unique per project; GenAI vs Model training workflow toggle |
| 6 | mlflow-working-with-mlflow.txt | §6 Trace archival | `traceArchival` section (disabled by default); archival CronJob with `concurrencyPolicy: Forbid`, single replica per namespace; retention at server (`spec.traceArchival.retention`) and experiment level (longer requires `longRetentionAllowlist`, up to 64 IDs); payloads moved to object storage, metadata stays; archival irreversible; span-payload search filters no longer match archived traces |

## User Flows

### Flow 1: Install and configure MLflow (admin)

1. **Patch the DSC** — enable `mlflowoperator` via `oc patch datasciencecluster` (§2)
2. **Create storage secrets** — S3 credentials for production artifact storage (§2)
3. **Create the `MLflow` CR** — cluster-scoped, named `mlflow`; SQLite/PVC dev or PostgreSQL/S3 production variant (§2)
4. **Verify** — operator pods Running, installedComponents reports `true`, dashboard lists *MLflow UI*

### Flow 2: Track an experiment from a workbench

1. **Annotate the notebook** — `opendatahub.io/mlflow-instance=mlflow`, restart pod (§4)
2. **Verify injection** — `MLFLOW_TRACKING_URI`, `MLFLOW_K8S_INTEGRATION`, `MLFLOW_TRACKING_AUTH` + RoleBinding (§4)
3. **Log with the SDK** — `mlflow.set_experiment`, `mlflow.start_run`, `log_param`, `log_metric` (§3.7)
4. **Verify in dashboard** — project → *Develop & train → Experiments (MLflow)* → runs table, parameters, metric charts, system metrics (§5)

### Flow 3: Configure per-project storage and trace archival

1. **Create S3 connection + `MLflowConfig`** — namespace-scoped, named `mlflow`, `artifactRootSecret: mlflow-artifact-connection` (§3.8)
2. **Verify** — new experiments resolve artifact URIs under the overridden bucket; MLflow does not serve per-project override artifacts (§3.8)
3. **Enable trace archival** — `traceArchival` in the `MLflow` CR; CronJob created; per-experiment retention via dashboard *Edit Experiment* (§6)
4. **Teardown** — stop workbench, remove annotation, RoleBinding deleted immediately (§4)

## Features and Concepts

### OpenShift Platform
- DataScienceCluster component management (`mlflowoperator`), RBAC (ServiceAccount, RoleBinding, aggregate ClusterRoles, SelfSubjectAccessReview), Secrets for connections

### RHOAI / AI Platform
- MLflow Operator, cluster-scoped `MLflow` CR, namespace-scoped `MLflowConfig` CR, workbench integration (annotation → env vars + RoleBinding), dashboard *Experiments (MLflow)* page, connections API (`opendatahub.io/connection-type-protocol: "s3"`)

### AI/ML Fundamentals
- Experiment/run model (parameters, metrics, artifacts, tags), model registry, LLM traces and span payload archival, retention policies

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: data scientists and platform engineers with OpenShift working knowledge
- **Prerequisite knowledge**: OpenShift basics, `oc` CLI, cluster administrator access for install steps
- **Estimated duration**: about 2 hours
- **Cluster requirements**: RHOAI 3.5 with `mlflowoperator` enabled in the DSC; S3-compatible storage for advanced exercises

## Open Questions

- Exact dashboard rendering of *Experiments (MLflow)*, *Edit Experiment*, and *Archive after* badge on a live console (doc-derived paths)
- S3-compatible bucket availability in workshop clusters (module 03 prerequisite)
