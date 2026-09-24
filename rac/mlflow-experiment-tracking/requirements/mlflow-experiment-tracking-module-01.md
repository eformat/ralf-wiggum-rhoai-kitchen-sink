---
schema_version: 1
id: RHAIBU-M33F7MYVCWJ3
type: requirement
---
# Module 01: Core Concepts

## Problem

Before deploying MLflow workloads, learners need a mental model of the single
shared MLflow instance, the project-to-workspace mapping, and the RBAC model
(pseudo-resources and aggregate ClusterRoles) that authorizes every MLflow API
request. Without this orientation, later hands-on steps are copy-paste with no
understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to verify the `mlflowoperator` component is managed with `oc get dsc` (`spec.components.mlflowoperator.managementState: Managed`)
- [REQ-012] Learner MUST be able to confirm the feature in the RHOAI dashboard: the *Applications* menu lists *MLflow UI* once the operator is enabled
- [REQ-013] Learner MUST be able to confirm the MLflow CRDs are served with `oc api-resources --api-group=mlflow.opendatahub.io`, listing the cluster-scoped `MLflow` kind
- [REQ-014] Learner MUST be able to confirm the single shared instance with `oc get mlflow mlflow -n redhat-ods-applications` showing a ready status

## Success Metrics

Learner completes both exercises: the RBAC/architecture walkthrough and the
cluster inspection commands, each producing the documented expected output.

## Risks

- The `mlflowoperator` component defaults to `Removed`; on clusters without it, the inspection exercises must be adapted or module 02's enablement followed first

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33F7MYEAZF9

## Verified By

- features/mlops/mlflow-experiment-tracking/content/modules/ROOT/pages/module-01-concepts.adoc
