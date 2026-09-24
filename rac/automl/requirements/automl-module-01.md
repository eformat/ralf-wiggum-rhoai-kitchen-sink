---
schema_version: 1
id: RHAIBU-M33ESDJ3W2KS
type: requirement
---
# Module 01: Getting Started

## Problem

Before creating an optimization run, learners must enable and validate every
prerequisite: the DSC dashboard flag, the pipeline server's managed-pipelines
setting, the CSV training data, the S3 data connection, and the AutoML page
itself. Without this checkpoint, later hands-on steps fail for reasons that are
hard to trace back to a missing enablement flag.

## Requirements

- [REQ-011] Learner MUST be able to enable AutoML on the DataScienceCluster (`oc patch datasciencecluster default ... dashboardConfig.automl=true`) and verify it returns `true` via `oc get dsc default -o jsonpath='{.spec.dashboardConfig.automl}'`
- [REQ-012] Learner MUST be able to confirm the pipeline server exists (`oc get dspa -n {guid}-{user}`) and enable AutoML pipelines via `spec.apiServer.managedPipelines`, then verify the server reports `READY: True`
- [REQ-013] Learner MUST be able to validate their CSV training data meets the format rules (UTF-8 encoding, comma delimiters, header row; 32 MiB dashboard upload cap, 100 MB S3 cap)
- [REQ-014] Learner MUST be able to confirm an S3 data connection exists in the project (`oc get secrets -n {guid}-{user}`) and that the AutoML page loads in the dashboard under *Develop and train > AutoML*

## Success Metrics

Learner completes all three exercises: the DSC patch with verified output
`true`, the pipeline-server enablement with `READY: True`, and the
data/dashboard validation — each producing the documented expected output.

## Risks

- Patching the DataScienceCluster is cluster-wide; in shared workshop environments the facilitator must pre-enable AutoML instead
- A pipeline server that is not ready blocks every exercise in Module 02

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- Learner has cluster-admin rights for the DSC patch, or the facilitator has pre-enabled AutoML

## Related Requirements

- RHAIBU-M33ESDHNJPDR

## Verified By

- features/feature-store-automl-autorag/automl/content/modules/ROOT/pages/module-01-getting-started.adoc
