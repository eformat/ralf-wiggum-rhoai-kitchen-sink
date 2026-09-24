---
schema_version: 1
id: RHAIBU-M33ESDHNJPDR
type: requirement
---
# AutoML Workshop

## Problem

Data scientists and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with AutoML — the Technology Preview automated model selection and
training system — before they can judge whether it fits their tabular and time
series prediction tasks. Without a structured workshop, learners must
reverse-engineer the two-tier enablement (DSC dashboard flag + pipeline server
setting), the optimization-run wizard, and the AutoGluon deployment path from
product documentation alone. This workshop targets RHOAI users with editor
access to a project and a configured pipeline server.

## Requirements

- [REQ-001] Learner MUST be able to verify AutoML is enabled on the DataScienceCluster (`oc get dsc default -o jsonpath='{.spec.dashboardConfig.automl}'` returns `true`)
- [REQ-002] Learner MUST be able to enable AutoML pipelines on their project's pipeline server (`spec.apiServer.managedPipelines`) and confirm the server reports `READY: True`
- [REQ-003] Learner MUST be able to validate CSV training data prerequisites (UTF-8, comma delimiters, header row, S3 bucket) and a working S3 data connection in the project
- [REQ-004] Learner MUST be able to create an AutoML optimization run and confirm it reaches *Running* or *Completed* status, with an underlying pipeline run visible via `oc get pipelineruns`
- [REQ-005] Learner MUST be able to evaluate the leaderboard and model detail views, then register a model to a model registry or save a notebook
- [REQ-006] Learner SHOULD be able to run predictions with the saved notebook in a workbench and observe sample predictions from test inputs
- [REQ-007] Learner MUST be able to deploy the registered model with the AutoGluon serving runtime and verify the deployment shows *Ready* on the Deployments page

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the optimization run completes on the AutoML page, a registered model appears
in the model registry, the notebook runs without errors, and the deployment
shows *Ready* with an exposed REST API endpoint.

## Risks

- AutoML is Technology Preview in 3.5 — the dashboard flow, API fields, and serving runtime names may change between releases
- The AutoML/AutoRAG pipeline definitions must be updated before the first run or runs fail with image pull errors (RHOAIENG-64768)
- Training the optimization job needs at least 4 CPUs and 16 GiB memory available for scheduling

## Assumptions

- RHOAI 3.5 is installed and the learner has editor access to a project
- A pipeline server is configured in the learner's project
- CSV training data (UTF-8, comma delimiters, header row) is in an S3-compatible bucket

## Related Designs

- RHAIBU-M33ESDKPXEZ5

## Related Decisions

- RHAIBU-M33ESDJY6C34
- RHAIBU-M33ESDKAZ4JF

## Related Requirements

- RHAIBU-M33ESDJ3W2KS
- RHAIBU-M33ESDJGKG9T
