---
schema_version: 1
id: RHAIBU-M33EHSX5V8XN
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must run a real distributed PyTorch training job end to end —
ConfigMap-mounted script, `TrainJob` referencing the `torch-distributed`
runtime, verified multi-node output, and full lifecycle control. This is the
core deliverable of the workshop: a working two-node `TrainJob` with proven
distributed execution and suspend/resume/delete lifecycle management.

## Requirements

- [REQ-021] Learner MUST be able to apply a ConfigMap and a `TrainJob` manifest (trainer.kubeflow.org/v1alpha1, `runtimeRef: torch-distributed`, `numNodes: 2`, `resourcesPerNode`, `podTemplateOverrides`) from the CLI and confirm the job appears in `oc get trainjob`
- [REQ-022] Learner MUST be able to list the training pods with the `job-name` label and read pod logs showing each rank out of `world_size` 2 with a matching `all_reduce result = 1.0`
- [REQ-023] Learner MUST be able to suspend and resume the `TrainJob` via `oc patch` and verify `spec.suspend` toggles and the training pods are terminated
- [REQ-024] Learner MUST be able to delete the `TrainJob` via `oc delete` and verify the job and training pods are gone

## Success Metrics

`oc get trainjob` lists `pytorch-minimal-example`; pod logs on both nodes show
`Rank 0/2` and `Rank 1/2` with `all_reduce result = 1.0`; suspend/resume
toggles `spec.suspend`; delete removes the job and pods.

## Risks

- Exercises need worker nodes with supported NVIDIA GPUs; without GPUs the apply/monitor steps are observe-only
- The ConfigMap must be applied before the TrainJob or the pods fail to start

## Assumptions

- Learner has completed Module 01 (runtimes inspected) and has GPU capacity matching `resourcesPerNode`

## Related Requirements

- RHAIBU-M33EHSWMJJJG

## Verified By

- features/distributed-training/kubeflow-trainer-v2/content/modules/ROOT/pages/module-02-hands-on.adoc
