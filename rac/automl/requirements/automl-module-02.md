---
schema_version: 1
id: RHAIBU-M33ESDJGKG9T
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must work the full AutoML lifecycle end to end: create a real
optimization run, evaluate the leaderboard and model details, run predictions
from the saved notebook, and deploy the model for inference. This is the core
deliverable of the workshop: a trained, evaluated, registered, and deployed
AutoML model with verified outputs at each stage.

## Requirements

- [REQ-021] Learner MUST be able to create an AutoML optimization run via the dashboard wizard (`Develop and train > AutoML → Create AutoML optimization run`) with an S3 CSV data source, prediction task type, and prediction settings
- [REQ-022] Learner MUST be able to verify the run shows *Running* or *Completed* on the AutoML page and that an underlying pipeline run appears via `oc get pipelineruns -n {guid}-{user}`
- [REQ-023] Learner MUST be able to evaluate the leaderboard and model detail views (feature importance, confusion matrix, ROC/precision recall curves), then register a model (listed in the model registry) or save a notebook (downloaded to the local system)
- [REQ-024] Learner MUST be able to run the saved notebook in a workbench with the S3 connection attached, all cells completing without errors and final cells displaying sample predictions
- [REQ-025] Learner MUST be able to deploy the registered model with model framework `autogluon - 1` and the *AutoGluon ServingRuntime for KServe* runtime, and verify the deployment shows *Ready* on the Deployments page
- [REQ-026] Learner SHOULD be able to select the documented training quality *Preset* when creating an optimization run (`speed` default or `balanced`; `balanced` allocates more CPU and memory but training can take more than twice as long)

## Success Metrics

The optimization run reaches *Completed*; the registered model is listed in the
model registry; all notebook cells complete without errors; the deployment
shows *Ready* with an exposed REST API endpoint.

## Risks

- AutoML/AutoRAG pipeline definitions must be uploaded before the first run or runs fail with image pull errors (RHOAIENG-64768)
- The AutoGluon serving runtime must be enabled for the project; if disabled via ServingRuntime templates it does not appear in the deployment UI
- Updating the workbench to attach connections restarts it and interrupts running kernels

## Assumptions

- Learner has completed Module 01 (AutoML enabled, pipeline server READY)
- A workbench is running in the learner's project and CSV training data is in S3

## Related Requirements

- RHAIBU-M33ESDHNJPDR

## Verified By

- features/feature-store-automl-autorag/automl/content/modules/ROOT/pages/module-02-hands-on.adoc
