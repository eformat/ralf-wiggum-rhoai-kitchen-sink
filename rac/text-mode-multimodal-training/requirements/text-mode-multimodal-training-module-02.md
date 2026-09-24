---
schema_version: 1
id: RHAIBU-M33E5221Y0JN
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must walk the text-mode fine-tuning workflow end to end — prepare the
prerequisites, configure OSFT training parameters for a multimodal-capable
model fine-tuned in text mode, run the job from a workbench with the Kubeflow
SDK, observe its progress, and clean up. This is the core deliverable of the
workshop: a `TrainingHubTrainer` run on the `training-hub` runtime with
verified cleanup and retained checkpoints.

## Requirements

- [REQ-021] Learner MUST observe that the `list_runtimes()` loop prints `Selected runtime: training-hub` after configuring the SDK client with `%api_server%` and `%token%`
- [REQ-022] Learner MUST observe that `oc get clustertrainingruntime training-hub` returns the runtime with an `AGE` column value
- [REQ-023] Learner MUST be able to delete the finished job with `client.delete_job(name=job_name)` and observe that `oc get trainjob -n {guid}-{user}` no longer lists the job
- [REQ-024] Learner MUST observe that the console Administrator perspective `Workloads → Jobs` shows the job as not listed for the project, and that the `shared` PVC retains checkpoints inspectable at `ckpt_output_dir` in the workbench

## Success Metrics

The `list_runtimes()` loop selects `training-hub`; the job runs on the
`training-hub` runtime and its logs stream from the SDK; after deletion the job
disappears from the CLI and console views while checkpoints persist on the RWX
PVC.

## Risks

- The full workflow requires GPU nodes (2 nodes x 2 NVIDIA L40/L40S for OSFT); on clusters without them, learners follow along and observe
- Pip installs and SDK client authentication fail without Python 3.9+ in the workbench image and RBAC permissions for SDK access to `ClusterTrainingRuntime` resources

## Assumptions

- Learner has completed Module 01 (the `training-hub` runtime is verified)
- The workbench has an RWX-capable PVC named `shared` attached

## Related Requirements

- RHAIBU-M33E5219KH8J

## Verified By

- features/agents-mcp/text-mode-multimodal-training/content/modules/ROOT/pages/module-02-hands-on.adoc
