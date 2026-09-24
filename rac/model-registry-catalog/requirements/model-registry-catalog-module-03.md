---
schema_version: 1
id: RHAIBU-M33FK2GGZ90Z
type: requirement
---
# Module 03: Advanced Usage

## Problem

After the core workflow, learners need the advanced capabilities that make the
registry and catalog production-ready: discovering and registering catalog
models with performance and safety insights, deploying models directly from
the catalog through the serving wizard, storing models as OCI ModelCar
images with background transfer jobs, governing catalog sources as an
administrator, and managing the registry lifecycle with archive, restore, and
delete.

## Requirements

- [REQ-031] Learner MUST be able to browse the model catalog (categories, search, filters, *Performance insights*, *Safety and security insights*) and register a catalog model into `workshop-registry`
- [REQ-032] Learner MUST be able to store a model with *Register and store* and verify the transfer job with `oc get jobs -n {guid}-{user}` (`COMPLETIONS 1/1`) and the `oci://<registry>/<image>:<tag>` artifact URI
- [REQ-033] Learner MUST be able to add a model catalog source (Hugging Face repository or YAML file) and confirm validation status *Connected* with models visible under *Other models* or the `<label>` category, and `oc get configmap model-catalog-sources -n rhoai-model-registries`
- [REQ-034] Learner SHOULD be able to archive a model (after deleting deployed versions), restore it from *View archived models*, and delete a registry with confirmation
- [REQ-035] Learner MUST be able to deploy a model directly from the model catalog via the *Deploy a model* wizard (read-only catalog URI, *Model type*, hardware profile, serving runtime selection, *Deployment strategy*) and confirm the created inference service with `oc get inferenceservices -n {guid}-{user}`

## Success Metrics

Learner completes all four exercises: a catalog model registered into the
registry, a catalog deployment confirmed with an inference service, a ModelCar
transfer job completed with an `oci://` URI and job logs reviewed, a governed
catalog source showing *Connected*, and archive/restore round-trip
demonstrated.

## Risks

- Hugging Face catalog sources require external network access, public non-gated models, and the URL-slug organization name; unsupported in disconnected environments
- s390x: only `granite-3.3-8b-instruct` is supported in the catalog, and catalog registration, catalog deployment advanced settings, and custom catalog sources are not supported on s390x
- Catalog deployments rely on the global cluster pull secret to pull OCI-compliant ModelCar format from the catalog
- Models with deployed versions cannot be archived; the lifecycle exercise depends on deployments from Module 02 being deleted first
- OCI registry credentials (username/token) must be available for the ModelCar destination

## Assumptions

- Learner has completed Module 02 (registry created, model registered and deployed)
- An OCI registry (for example, Quay) and an object storage or URI model origin are available
- Cluster administrator access is available for the catalog-source ConfigMap exercise

## Related Requirements

- RHAIBU-M33FK2FCVS2Z

## Verified By

- features/model-registry/model-registry-catalog/content/modules/ROOT/pages/module-03-advanced.adoc
