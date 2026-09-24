# Observations: Kale JupyterLab extension (doc-derived)

## Summary

The Kale (Kubeflow Automated pipeLines Engine) JupyterLab extension is
RHOAI 3.5's Developer Preview path for converting annotated Jupyter notebooks
into AI Pipelines without writing Kubeflow Pipelines SDK code. This
observation document was produced from the official RHOAI 3.5 product
documentation (release notes Kale section; Using AI Pipelines; Data Science
IDE) because no live demo cluster was available at authoring time. Every item
below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | Kale JupyterLab extension for notebook-to-pipeline conversion | Kale converts annotated Jupyter notebooks into AI Pipelines without writing Kubeflow Pipelines SDK code; ships pre-installed but disabled by default |
| 2 | ai-available-assets-release-notes.txt | Kale NOTE block | Supported images: Standard Data Science, PyTorch, TensorFlow, TrustyAI, ROCm-PyTorch, ROCm-TensorFlow; not available in custom notebook images |
| 3 | ai-available-assets-release-notes.txt | Kale NOTE block | Enablement: `jupyter labextension enable jupyterlab-kubeflow-kale` in the workbench terminal + browser refresh; Data Science Pipelines Application must be in the same namespace as the workbench |
| 4 | ai-available-assets-release-notes.txt | Kale NOTE block | Connection status: green = KFP connected, yellow = disconnected; opening a notebook activates the Enable toggle, which opens the Kale metadata editor |
| 5 | kale-ai-pipelines.txt | §1.1.1–1.2.3 Pipeline servers | Pipeline server is attached to the project and hosts the AI pipeline; Kubeflow Pipelines 2.0 SDK is the alternative authoring path Kale skips |
| 6 | kale-ai-pipelines.txt | §2 Storage | Pipeline definitions stored as YAML in the `/pipelines` folder of the pipeline server's S3-compatible bucket; run artifacts in the `/pipeline-name` folder in the bucket root |
| 7 | kale-data-science-ide.txt | Notebooks | Workbenches run Python notebooks; S3-compatible cloud storage makes data available to notebooks and scripts |

## User Flows

### Flow 1: Enable Kale and check the KFP connection

1. **Verify prerequisites** — Data Science Pipelines Application deployed in the workbench namespace (release notes NOTE)
2. **Enable the extension** — `jupyter labextension enable jupyterlab-kubeflow-kale` in the workbench terminal; refresh the browser (release notes NOTE)
3. **Observe connection** — green status means KFP connected; yellow means disconnected (release notes NOTE)

### Flow 2: Convert a notebook into a pipeline

1. **Open a notebook** — opening a notebook activates the Enable toggle (release notes NOTE)
2. **Switch the toggle on** — the Kale metadata editor opens for annotation (release notes NOTE)
3. **Observe the result in the dashboard** — pipeline server hosts the definition; runs execute once immediately after creation by default and appear under *Develop & train → Experiments* (kale-ai-pipelines.txt)

## Features and Concepts

### OpenShift Platform
- Data Science Pipelines Application (DSPA) in the project namespace, S3-compatible object storage buckets, workbench notebook images

### RHOAI / AI Platform
- Kale JupyterLab extension (`jupyterlab-kubeflow-kale`) pre-installed but disabled by default in six default data science notebook images; Data Science Pipelines component; pipeline server, pipeline definitions, experiments, and runs in the dashboard

### AI/ML Fundamentals
- Pipeline authoring: the Kubeflow Pipelines SDK compiles Python to IR YAML; Kale skips that authoring step by converting annotated notebooks directly

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: data scientists and MLOps engineers with a running workbench
- **Prerequisite knowledge**: JupyterLab basics, `oc` CLI basics
- **Estimated duration**: 30–60 minutes
- **Cluster requirements**: RHOAI 3.5 with Data Science Pipelines enabled; workbench on a default data science notebook image (Kale is not in custom images)

## Open Questions

- Field-level Kale metadata editor options are undocumented in the RHOAI 3.5 product docs (release notes defer to upstream Kale documentation)
- Whether a pipeline run can actually be driven from the notebook in a workshop cluster (Developer Preview handoff may change between releases)
