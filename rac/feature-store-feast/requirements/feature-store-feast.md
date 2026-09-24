---
schema_version: 1
id: RHAIBU-M33ESMMH5MB5
type: requirement
---
# Feature Store (Feast-based) Workshop

## Problem

ML engineers, data scientists, and platform engineers evaluating RHOAI 3.5 need
hands-on experience with the Feature Store (Feast-based) — the centralized
repository that stores, manages, and serves machine learning features for both
training and inference. Without a structured workshop, learners must
reverse-engineer the `FeatureStore` CR, the `feast` CLI workflow, and the
online-store/scaling configuration from product documentation alone. This
workshop targets RHOAI users with working knowledge of OpenShift and basic ML
concepts.

## Requirements

- [REQ-001] Learner MUST be able to log in to the OpenShift cluster with `oc` and use a working project for the Feature Store instance
- [REQ-002] Learner MUST be able to enable the `feastoperator` component in the DataScienceCluster (`managementState: Managed`) and verify the `feast-operator-controller-manager` pod is `Running`
- [REQ-003] Learner MUST be able to create a `FeatureStore` CR with a Git feature repository and confirm `oc get feast` reports `Ready`
- [REQ-004] Learner MUST be able to initialize the instance with `feast apply` and list the registered entities and feature views with `feast entities list` and `feast feature-views list`
- [REQ-005] Learner MUST be able to materialize features into the online store with `feast materialize` / `feast materialize-incremental` and observe the completion output
- [REQ-006] Learner MUST be able to connect a workbench to the Feature Store instance and retrieve features with the Python SDK (`fs.list_feature_views()`, `get_online_features`)
- [REQ-007] Learner MUST be able to retrieve online features via the feature server REST API with `curl` and receive a JSON response
- [REQ-008] Learner MUST be able to tune online-store and feature-server worker settings in the CR and confirm the FeatureStore reconciles to `Ready`
- [REQ-009] Learner MUST be able to scale the instance with a horizontal pod autoscaler and verify it with `oc get hpa`
- [REQ-010] Learner SHOULD be able to enable the Ray compute engine and confirm `feast configuration` shows the `ray.engine` batch engine settings

## Success Metrics

All ten acceptance criteria are demonstrated by the learner during the lab; the
`FeatureStore` resource reaches `Ready` in modules 02–03, `feast apply`
registers the tutorial entities and feature views, materialization completes
with a progress bar, and `get_online_features` plus the REST call return the
materialized feature values.

## Risks

- The `feastoperator` component is disabled by default and requires `cluster-admin` access to the DSC
- `feast apply` creates cloud infrastructure that may incur costs on non-local providers
- HPA verification depends on the metrics server scraping availability; TARGETS shows `unknown` for the first minute
- Horizontal scaling requires database-backed persistence for all enabled services

## Assumptions

- RHOAI 3.5 is installed with cluster-admin access available for the DSC step
- Learners have `oc` CLI access and a working project
- The credit scoring tutorial Git repository (`feast-dev/feast-credit-score-local-tutorial`) is reachable, or a facilitator-provided substitute is available
- Feast SDK is available in the workbench image (all images except minimal)

## Related Designs

- RHAIBU-M33ESMPTYRSX

## Related Decisions

- RHAIBU-M33ESMNYFNSV
- RHAIBU-M33ESMPCHVTX

## Related Requirements

- RHAIBU-M33ESMMSV4Y0
- RHAIBU-M33ESMN38B6C
- RHAIBU-M33ESMNH6BTR
