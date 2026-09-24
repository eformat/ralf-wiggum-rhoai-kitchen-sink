---
schema_version: 1
id: RHAIBU-M33F7MZ9H8NN
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must work the core MLflow workflow end to end: enable the MLflow
Operator component, deploy the tracking server with an `MLflow` custom
resource, enable automatic MLflow SDK configuration in a workbench, and track
an experiment from a notebook. This is the core deliverable of the workshop: a
working tracking server with a verified experiment run visible in the
dashboard.

## Requirements

- [REQ-021] Learner MUST be able to enable the `mlflowoperator` component by patching the DSC and apply an `MLflow` CR (cluster-scoped, named `mlflow`) with `oc apply`
- [REQ-022] Learner MUST be able to verify the operator pods are `Running` and the component reports installed (`status.installedComponents.mlflowoperator` is `true`)
- [REQ-023] Learner MUST be able to enable workbench integration with the `opendatahub.io/mlflow-instance` annotation and verify the three injected variables (`MLFLOW_TRACKING_URI`, `MLFLOW_K8S_INTEGRATION`, `MLFLOW_TRACKING_AUTH`) and the `<notebook_name>-mlflow` RoleBinding after restart
- [REQ-024] Learner MUST be able to log parameters and metrics with the MLflow SDK (`mlflow.set_experiment`, `mlflow.start_run`) and review the run in the dashboard's *Experiments (MLflow)* page

## Success Metrics

Operator pods are `Running` and installedComponents reports `true`; the
workbench pod exposes the three injected variables and the integration
RoleBinding; `demo-experiment` / `demo-run` appears in the dashboard with the
logged parameters and metric charts.

## Risks

- The install steps require cluster administrator privileges
- Deployment needs the Dashboard, MLflow, and Workbenches components for the dashboard-annotation shortcut; manual annotation is used otherwise
- The SDK must be version 3.11 or later (`pip install "mlflow[kubernetes]>=3.11"`) in older or custom images

## Assumptions

- Learner has completed Module 01 (platform verified) and has a workbench in their project

## Related Requirements

- RHAIBU-M33F7MYEAZF9

## Verified By

- features/mlops/mlflow-experiment-tracking/content/modules/ROOT/pages/module-02-hands-on.adoc
