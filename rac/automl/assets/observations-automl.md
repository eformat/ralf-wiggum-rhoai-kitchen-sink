# Observations: AutoML (doc-derived)

## Summary

AutoML is RHOAI 3.5's Technology Preview automated machine learning system for
finding the best model for a prediction task: you provide CSV training data and
select a task type, and AutoML (powered by AutoGluon) trains and evaluates
multiple candidate models, ranks them on a leaderboard, and produces notebooks
for running predictions. This observation document was produced from the
official RHOAI 3.5 product documentation (Working with AutoML) because no live
demo cluster was available at authoring time. Every item below is doc evidence,
not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | automl-working-with-automl.txt | §1.1–1.3 AutoML workflow, task types, TP limitations | Workflow: load data → sample → train/test split → train candidates → evaluate on held-out test set → leaderboard ranking; four task types (binary, multiclass, regression, time series); TP limits: CSV only, 32 MiB dashboard / 100 MB S3 caps, no custom algorithms or tuning, runs cannot be edited after creation |
| 2 | automl-working-with-automl.txt | §1.4 + prerequisites | Two-tier enablement: cluster admin sets `spec.dashboardConfig.automl: true`; pipeline server with `spec.apiServer.managedPipelines: {}` (or Enable AutoML and AutoRAG pipelines checkbox); externally created runs appear on the AutoML page |
| 3 | automl-working-with-automl.txt | §2 Create an AutoML optimization run | Dashboard flow: Develop and train > AutoML → Create AutoML optimization run → S3 connection → Browse bucket → task type + prediction settings (Label column, or Target/Timestamp/ID columns for time series) → optional top-models (1-10 tabular, 1-7 time series, default 3) and optimization metric → Create run; verification: run listed with running/complete status |
| 4 | automl-working-with-automl.txt | §3 Evaluate AutoML results | Leaderboard ranks by optimized metric, top model highlighted, column headers sort by other metrics; View details: metrics, feature importance, confusion matrix, ROC curves, precision recall curves; Register model or Save notebook from actions menu; verification: model listed in registry or notebook downloaded |
| 5 | automl-working-with-automl.txt | §4 Run predictions | Attach the AI Pipelines server's S3 connection to the workbench (Connections section → Attach existing connections), upload saved notebook, run all cells; notebook loads model from S3 and displays sample predictions |
| 6 | automl-working-with-automl.txt | §5 Deploy for inference | Deploy registered model version from model registry with Model framework `autogluon - 1` and AutoGluon ServingRuntime for KServe; administrator controls runtime availability via ServingRuntime templates; verification: deployment Ready on Deployments page |
| 7 | automl-working-with-automl.txt | §6–7 Metrics and parameters | Default metrics by task type: Accuracy (binary/multiclass), R2 (regression), MASE negated (time series); detail views: feature importance (tabular only), confusion matrix + ROC + precision recall (classification only), backtesting (time series only); presets: speed (default) or balanced; AutoGluon auto-selects algorithms, hyperparameters, and train/test split |

## User Flows

### Flow 1: Enable and validate the environment

1. **Enable AutoML on the DSC** — cluster admin sets `spec.dashboardConfig.automl: true` (§1.4)
2. **Enable managed pipelines** — pipeline server with `spec.apiServer.managedPipelines: {}` (§1.4)
3. **Prepare data** — CSV (UTF-8, comma delimiters, header row) in an S3-compatible bucket (§2 prerequisites)
4. **Verify** — AutoML page loads under Develop and train

### Flow 2: Create and evaluate an optimization run

1. **Create run** — Develop and train > AutoML → Create AutoML optimization run → S3 CSV → task type → prediction settings (§2)
2. **Monitor** — run status on the AutoML page until complete (§2 verification)
3. **Evaluate** — leaderboard, View details (feature importance, confusion matrix, ROC curves) (§3, §6.2)
4. **Capture output** — Register model to a model registry, or Save notebook (§3)

### Flow 3: Predict and deploy

1. **Predict in workbench** — attach S3 connection, upload notebook, run all cells (§4)
2. **Deploy** — from model registry, framework `autogluon - 1`, AutoGluon ServingRuntime for KServe (§5)
3. **Verify** — deployment shows Ready on the Deployments page; REST API endpoint exposed (§5)

## Features and Concepts

### OpenShift Platform
- Secrets (S3 data connections), workbench restarts on connection updates, ServingRuntime template resources controlled per project by administrators

### RHOAI / AI Platform
- AutoML optimization runs as managed pipelines on the project's pipeline server, DSC `dashboardConfig.automl` flag, AutoML leaderboard and model detail views, model registry integration, AutoGluon ServingRuntime for KServe

### AI/ML Fundamentals
- Classification vs regression vs time series forecasting, train/test split evaluation, optimization metrics (Accuracy, R2, MASE), feature importance, confusion matrix, ROC and precision recall curves, backtesting

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: data scientists and ML practitioners with editor access to a RHOAI project
- **Prerequisite knowledge**: basic ML task types, `oc` CLI basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5, pipeline server with AutoML pipelines enabled, 4 CPUs + 16 GiB memory for scheduling, CSV training data in S3

## Open Questions

- Exact Advanced-settings checkbox label for AutoML pipelines on a live console (doc-derived path)
- AutoGluon ServingRuntime availability per project depends on administrator-managed ServingRuntime templates
- RHOAIENG-64768 pipeline-definitions update must be applied before the first run; confirm the workshop cluster has them
