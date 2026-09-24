---
schema_version: 1
id: RHAIBU-M33FK2FCVS2Z
type: requirement
---
# Model Registry and Model Catalog Workshop

## Problem

Platform engineers, administrators, and ML practitioners evaluating RHOAI 3.5
need hands-on experience with the Model Registry and Model Catalog — the GA
register/version/discover path of the model lifecycle — before they can operate
registries or govern catalog sources in production. Without a structured
workshop, learners must reverse-engineer the `modelregistry` component
configuration, registry permissions RBAC, ModelCar OCI transfer jobs, and
catalog source governance from product documentation alone. This workshop
targets RHOAI users with working knowledge of OpenShift.

## Requirements

- [REQ-001] Learner MUST be able to open both the model catalog (*AI hub → Models → Catalog*) and the model registry (*AI hub → Registry*) pages in the dashboard without errors, with the registry page showing a *Model registry* drop-down list
- [REQ-002] Learner MUST be able to enable the `modelregistry` component in the DataScienceCluster (`managementState: Managed`, `registriesNamespace: rhoai-model-registries`) and verify the `rhoai-model-registries` namespace is `Active`, the `model-registry-operator-controller-manager` deployment is available, and the component reports `Managed`
- [REQ-003] Learner MUST be able to create a model registry with the default database from *Settings → Model resources and operations → Model registry settings*, grant groups, users, and projects access, and confirm the registry resource and its `registry-users-<name>` role from the CLI
- [REQ-004] Learner MUST be able to register a model and an additional version from the *AI hub → Registry* page and see both versions listed on the model's *Overview* tab and the *Latest version* column
- [REQ-005] Learner MUST be able to deploy a registered model version from the registry and confirm the created inference service with `oc get inferenceservices -n {guid}-{user}`
- [REQ-006] Learner MUST be able to discover a model in the model catalog (categories, search, filters, performance and safety insights) and register it into the registry
- [REQ-007] Learner MUST be able to store a model as an OCI ModelCar image via *Register and store* and verify the transfer job completes (`COMPLETIONS 1/1`) with an `oci://` artifact URI
- [REQ-008] Learner SHOULD be able to add and govern a model catalog source (validation status *Connected*, include/exclude patterns) and archive, restore, and delete registry assets

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the lab;
`workshop-registry` is created with the default database, two versions are
registered, an inference service is created from a registered version, the
ModelCar transfer job completes with an `oci://` URI, and the added catalog
source reports *Connected*.

## Risks

- The default database is non-production only — Red Hat does not support it for production use cases, so the workshop scope is evaluation
- URI-based model deployment is supported for public OCI repositories only; external-database and CA-certificate options are documented but only partially exercised
- Hugging Face catalog sources require external network access and public non-gated models; unsupported in disconnected environments
- s390x restrictions: only `granite-3.3-8b-instruct` is supported in the catalog, and catalog registration and custom catalog sources are not supported on s390x

## Assumptions

- RHOAI 3.5 is installed with the RHOAI operator; the `modelregistry` component is enabled by default on new installs (Module 01 walks through enablement after upgrades)
- Learners have cluster-administrator access for component and registry management steps and dashboard credentials (`{guid}`, `{user}`) for data scientist steps
- An OCI registry (for example, Quay) and an object storage or URI model artifact are available for the register-and-store exercise

## Related Designs

- RHAIBU-M33FK2HK36PH

## Related Decisions

- RHAIBU-M33FK2GWCX15
- RHAIBU-M33FK2H8XNM1

## Related Requirements

- RHAIBU-M33FK2FTT6KT
- RHAIBU-M33FK2G4CKAQ
- RHAIBU-M33FK2GGZ90Z
