---
schema_version: 1
id: RHAIBU-M33FK2G4CKAQ
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

With the component enabled, learners need the end-to-end registry workflow:
creating a registry as an administrator, granting access to it, registering a
model and a new version, and deploying a registered version through the model
serving platform. Without hands-on practice, the RBAC model and the connection
between registered versions and inference services stays abstract.

## Requirements

- [REQ-021] Learner MUST be able to create `workshop-registry` with the default database from *Settings → Model resources and operations → Model registry settings* and grant a group, a user, and a project access through *Manage permissions*
- [REQ-022] Learner MUST be able to confirm the registry with `oc get modelregistries` and its `registry-users-workshop-registry` role and role bindings in `rhoai-model-registries`
- [REQ-023] Learner MUST be able to register a model (`fraud-detection-demo`) with version `v1` and a second version `v2` from the *AI hub → Registry* page, seeing both in the *Latest versions* section and the *Latest version* column
- [REQ-024] Learner MUST be able to deploy a registered version from the registry's action menu and confirm the inference service named after the *Model deployment name* with `oc get inferenceservices -n {guid}-{user}`

## Success Metrics

Learner completes all three exercises: registry created and permissions granted
with RBAC resources visible from the CLI, two versions registered with both
listed in the UI, and an inference service created in the learner's project.

## Risks

- The default database is non-production only; production registries need an external MySQL or PostgreSQL database with optional CA certificate
- URI-based model location is deployable from public OCI repositories only
- `oc get modelregistries` may be unavailable in some deployments; dashboard verification is the fallback

## Assumptions

- Learner has completed Module 01 (`modelregistry` component enabled)
- A connection with a bucket, or a URI, is available as the model location
- Learner's working project exists for the deployment target

## Related Requirements

- RHAIBU-M33FK2FCVS2Z

## Verified By

- features/model-registry/model-registry-catalog/content/modules/ROOT/pages/module-02-hands-on.adoc
