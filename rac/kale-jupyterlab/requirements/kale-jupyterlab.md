---
schema_version: 1
id: RHAIBU-M33D807CPVN8
type: requirement
---
# Kale JupyterLab Extension Workshop

## Problem

Data scientists and MLOps engineers evaluating RHOAI 3.5 need hands-on
experience with the Kale JupyterLab extension — the Developer Preview path for
authoring AI Pipelines from annotated notebooks without writing Kubeflow
Pipelines SDK code — before they can recommend or operate it in production.
Without a structured workshop, learners must reverse-engineer the
extension enablement flow, the KFP connection model, and the dashboard
pipeline views from release notes alone. This workshop targets RHOAI users
with a running workbench and basic JupyterLab familiarity.

## Requirements

- [REQ-001] Learner MUST be able to verify a Data Science Pipelines Application is deployed in the workbench namespace (`oc get dspa -n {guid}-{user}` returns a `NAME` entry with an `AGE`)
- [REQ-002] Learner MUST be able to confirm the workbench runs a default data science notebook image that ships Kale (Standard Data Science, PyTorch, TensorFlow, TrustyAI, ROCm-PyTorch, or ROCm-TensorFlow)
- [REQ-003] Learner MUST be able to enable the Kale extension from the workbench terminal (`jupyter labextension enable jupyterlab-kubeflow-kale`)
- [REQ-004] Learner MUST be able to confirm the extension is registered via `jupyter labextension list` and observe the Kale UI in JupyterLab after a browser refresh
- [REQ-005] Learner MUST be able to interpret the Kale KFP connection status indicator (green means connected, yellow means disconnected)
- [REQ-006] Learner MUST be able to switch on Kale for a notebook with the per-notebook Enable toggle and observe that the Kale metadata editor opens
- [REQ-007] Learner SHOULD be able to locate the pipeline server details and the runs for their project in the dashboard (*Pipeline definitions → Pipeline server actions → Manage pipeline server configuration*; *Develop & train → Experiments → Runs*) and read step logs

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
`jupyter labextension list` reports `jupyterlab-kubeflow-kale` enabled in
module 01, and the dashboard shows the pipeline server details and run records
in module 02.

## Risks

- Kale is Developer Preview in 3.5 and is described only in the release notes — the field-level metadata editor options are undocumented and may change between releases
- Workshop cluster must have Data Science Pipelines enabled in the DSC; without it the KFP connection status stays yellow
- A custom notebook image does not ship Kale; learners on custom images must recreate the workbench from a default image

## Assumptions

- RHOAI 3.5 is installed with Data Science Pipelines enabled
- Learners have a running workbench with JupyterLab and `oc` CLI access with workshop credentials (`{user}`, `{guid}`)
- The Data Science Pipelines Application is deployed in the same namespace as the workbench

## Related Designs

- RHAIBU-M33D808CWPHP

## Related Decisions

- RHAIBU-M33D80805FR9
- RHAIBU-M33D8086PRWV

## Related Requirements

- RHAIBU-M33D807JY58F
- RHAIBU-M33D807SV65D
