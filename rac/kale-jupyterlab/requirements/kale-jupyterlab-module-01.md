---
schema_version: 1
id: RHAIBU-M33D807JY58F
type: requirement
---
# Module 01: Getting Started

## Problem

Before converting notebooks to pipelines, learners need a mental model of what
Kale does, confirmation that the KFP backend exists in their project, and the
extension enabled in their workbench. Without this orientation, later
hands-on steps are toggle-flipping with no understanding of what Kale talks
to and why the connection status matters.

## Requirements

- [REQ-011] Learner MUST be able to verify the Data Science Pipelines Application is deployed with `oc get dspa -n {guid}-{user}` (a `NAME` entry with `AGE`; `No resources found` means the backend is missing)
- [REQ-012] Learner MUST be able to identify whether the workbench image ships the Kale extension (pre-installed and disabled by default in Standard Data Science, PyTorch, TensorFlow, TrustyAI, ROCm-PyTorch, and ROCm-TensorFlow images; not available in custom images)
- [REQ-013] Learner MUST be able to enable the Kale extension with `jupyter labextension enable jupyterlab-kubeflow-kale` and confirm it with `jupyter labextension list`
- [REQ-014] Learner MUST be able to interpret the Kale KFP connection status indicator (green means KFP is connected, yellow means the Data Science Pipelines Application is missing)

## Success Metrics

Learner completes all three exercises: the pipeline-readiness check, the
extension enablement, and the connection-status observation, each producing
the documented expected output.

## Risks

- The Data Science Pipelines Application must be in the same namespace as the workbench; a missing DSPA keeps the connection status yellow
- Learners on custom notebook images cannot proceed without recreating the workbench

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33D807CPVN8

## Verified By

- features/agents-mcp/kale-jupyterlab/content/modules/ROOT/pages/module-01-getting-started.adoc
