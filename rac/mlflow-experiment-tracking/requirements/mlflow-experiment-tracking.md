---
schema_version: 1
id: RHAIBU-M33F7MYEAZF9
type: requirement
---
# MLflow Experiment Tracking / MLOps Integration Workshop

## Problem

Data scientists and platform engineers evaluating RHOAI 3.5 need hands-on
experience with MLflow experiment tracking — the GA path for tracking
experiments and managing models on the platform — before they can operate it
in production. Without a structured workshop, learners must reverse-engineer
the operator deployment model, the project-to-workspace mapping, the
Kubernetes RBAC behind the MLflow API, and the per-project artifact and trace
archival configuration from product documentation alone. This workshop targets
RHOAI users with working knowledge of OpenShift and `oc` CLI basics.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify the `mlflowoperator` component is `Managed` in the DataScienceCluster and the cluster-scoped `MLflow` instance exists in `redhat-ods-applications`
- [REQ-003] Learner MUST be able to enable the MLflow Operator by patching the DSC and deploy the tracking server with an `MLflow` custom resource
- [REQ-004] Learner MUST be able to enable MLflow integration for a workbench with the `opendatahub.io/mlflow-instance` annotation and verify the injected environment variables and RoleBinding
- [REQ-005] Learner MUST be able to log parameters and metrics with the MLflow SDK from a workbench notebook and review the run in the dashboard's *Experiments (MLflow)* page
- [REQ-006] Learner SHOULD be able to override default artifact storage for a project with `MLflowConfig` and an S3 connection
- [REQ-007] Learner SHOULD be able to enable trace archival with retention control at the server and experiment level

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the `MLflow` CR reaches a ready state in module 02, the SDK run
(`demo-experiment` / `demo-run`) is visible in the dashboard, and the disabled
workbench leaves no stale RoleBinding or environment variables behind.

## Risks

- The `mlflowoperator` component defaults to `Removed`, and the install steps in module 02 require cluster administrator privileges
- The `MLflow` resource is cluster-scoped and must be named `mlflow` — a cluster can have exactly one instance
- Artifact serving is not supported when `artifactsDestination` uses a `file://` path together with `spec.storage`, which limits what module 02 can demonstrate without object storage

## Assumptions

- RHOAI 3.5 is installed and the learner is logged in with `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- Cluster administrator privileges are available for the module 02 install steps
- A workbench exists in the learner's project for the notebook exercises in modules 02 and 03

## Related Designs

- RHAIBU-M33F7N0Y9M0M

## Related Decisions

- RHAIBU-M33F7N022329
- RHAIBU-M33F7N0J4QG5

## Related Requirements

- RHAIBU-M33F7MYVCWJ3
- RHAIBU-M33F7MZ9H8NN
- RHAIBU-M33F7MZNSFEG
