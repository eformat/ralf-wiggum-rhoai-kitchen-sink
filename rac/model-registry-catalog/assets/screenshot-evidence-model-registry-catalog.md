---
schema_version: 1
type: asset
---
# Screenshot Evidence: Model Registry / Catalog (model-registry-catalog)

## Capture Summary

- **Date:** 2026-09-24
- **Cluster:** cluster-44gxc.dyn.redhatworkshops.io (RHOAI 3.5.1)
- **Captured:** 3/3 shots
- **Failed:** 0
- **Cluster work performed:** applied `cluster/overlays/registry` (DSC `modelregistry: Managed`,
  registriesNamespace `rhoai-model-registries`); Model Registry component deployed
  (model-catalog + postgres pods); `workshop-registry` ModelRegistry instance created via the
  dashboard (the lab's Exercise 1 flow); Model/MCP catalog tabs surfaced in the AI hub.

## Evidence Map

| Screenshot | Page | Requirement | Criterion | Status |
|------------|------|-------------|-----------|--------|
| 01-model-registry-settings.png | module-02-hands-on.adoc (Exercise 1 Verify) | (module-01/02 criteria) — Model registry settings page showing the created `workshop-registry` row | captured |
| 02-register-model-dialog.png | module-02-hands-on.adoc:126 | Register model dialog (Model details / version details / model location fields) | captured (empty dialog, workshop-registry selected) |
| 03-model-transfer-jobs.png | module-03-hands-on.adoc | Model transfer jobs table (job names, namespaces, statuses) | captured (empty state — jobs are created at registration time when artifacts are stored) |

## Uncovered Criteria

- Populated register-model dialog fields and transfer-job rows — require executing the
  registration exercise (model artifacts at registration time).
