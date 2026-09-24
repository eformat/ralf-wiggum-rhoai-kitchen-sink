---
schema_version: 1
id: RHAIBU-M33ESMMSV4Y0
type: requirement
---
# Module 01: Core Concepts

## Problem

Before deploying Feature Store workloads, learners need a mental model of the
four Feature Store components (registry, offline store, online store, feature
servers), the time-series data model vocabulary, and the DSC enablement path.
Without this orientation, later hands-on steps are copy-paste with no
understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to name the four Feature Store components and the role each plays (registry catalog, offline store for training, online store for inference, feature servers)
- [REQ-012] Learner MUST be able to define the core vocabulary: feature vs feature value, entity, feature view, and materialization
- [REQ-013] Learner MUST be able to enable the `feastoperator` component by setting `managementState: Managed` in the `DataScienceCluster` YAML
- [REQ-014] Learner MUST be able to verify the controller pod is running with `oc get pods -n redhat-ods-applications -l control-plane=controller-manager`

## Success Metrics

Learner completes both exercises: the architecture walkthrough and the DSC
enablement plus controller-pod inspection, each producing the documented
expected output.

## Risks

- DSC editing requires cluster-admin; learners without it must observe the facilitator
- On OpenShift 4.20+ the console path to Installed Operators changed (Ecosystem menu)

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33ESMMH5MB5

## Verified By

- features/feature-store-automl-autorag/feature-store-feast/content/modules/ROOT/pages/module-01-concepts.adoc
