---
schema_version: 1
id: RHAIBU-M33FK2FTT6KT
type: requirement
---
# Module 01: Core Concepts

## Problem

Before creating registries and registering models, learners need a mental model
of where the Model Catalog and Model Registry fit in the RHOAI model lifecycle
and how to enable and verify the `modelregistry` component that backs both
features. Without this orientation, later hands-on steps are copy-paste with no
understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to explain the difference between the model catalog (discover and evaluate) and the model registry (register, version, manage) and locate both pages in the dashboard without errors
- [REQ-012] Learner MUST be able to enable the `modelregistry` component in the DataScienceCluster so `managementState` is `Managed` and `registriesNamespace` is `rhoai-model-registries`
- [REQ-013] Learner MUST be able to confirm the `rhoai-model-registries` namespace is `Active` with `oc get namespace rhoai-model-registries` and the `model-registry-operator-controller-manager` deployment is available in `redhat-ods-applications`
- [REQ-014] Learner MUST be able to confirm the component reports `Managed` with `oc get datasciencecluster default-dsc -o jsonpath='{.spec.components.modelregistry.managementState}'`

## Success Metrics

Learner completes both exercises: the catalog/registry landscape walkthrough and
the component enablement with all three verification commands producing the
documented expected output (`Active`, operator deployment listed, `Managed`).

## Risks

- The `modelregistry` component is enabled by default on new 3.5 installs; on clusters upgraded from older versions it must be enabled explicitly, so exercise 2 outcomes differ by cluster history
- Component enablement requires cluster administrator privileges

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- The RHOAI Operator is installed on the cluster

## Related Requirements

- RHAIBU-M33FK2FCVS2Z

## Verified By

- features/model-registry/model-registry-catalog/content/modules/ROOT/pages/module-01-concepts.adoc
