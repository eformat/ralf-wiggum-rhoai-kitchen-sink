---
schema_version: 1
id: RHAIBU-M33EHSXD898E
type: requirement
---
# Module 03: Advanced Usage

## Problem

After the pre-built runtimes, platform engineers and data scientists need
project-specific training environments, programmatic job submission, and LLM
fine-tuning. This module covers custom namespace-scoped `TrainingRuntime`
resources, the Kubeflow SDK workflow with JIT checkpointing, and Training Hub
algorithms (OSFT and SFT).

## Requirements

- [REQ-031] Learner MUST be able to create a custom namespace-scoped `TrainingRuntime` from the console (`Home → Search → Create TrainingRuntime`) and confirm it appears in `oc get trainingruntime`
- [REQ-032] Learner MUST be able to install the Kubeflow SDK in a workbench, submit a distributed `TrainJob` with `TransformersTrainer`, and verify job status via `trainer_client.get_job` and running pods via `oc get pods -l job-name`
- [REQ-033] Learner MUST be able to run an OSFT fine-tuning job with `TrainingHubTrainer` and a `training-hub` runtime, following job logs with `client.get_job_logs` and checking the final status
- [REQ-034] Learner SHOULD be able to delete the fine-tuning job with `client.delete_job` and confirm it no longer appears in console `Workloads → Jobs`
- [REQ-035] Learner SHOULD be able to identify the documented S3-compatible checkpointing flow: create an S3-compatible object storage data connection, then set `output_dir="s3://<bucket>/<path>"` and `data_connection_name="<connection>"` on the `TransformersTrainer` so the SDK reads credentials from the connection's Kubernetes secret and uploads checkpoints in the background (local-first staging)

## Success Metrics

Learner completes all three exercises: the custom runtime listed via CLI and
console, the SDK-submitted job verified via `get_job` status and running pods,
and the OSFT fine-tuning job followed via logs to final status.

## Risks

- OSFT example requires 2 nodes with 2 NVIDIA L40/L40S GPUs each (4 GPUs total), 4 CPUs and 32 GiB memory per node
- Fine-tuning requires an RWX-capable storage class (e.g. OpenShift Data Foundation) for dataset and checkpoint mounts
- SDK access to `ClusterTrainingRuntime` resources requires RBAC configured by the cluster administrator

## Assumptions

- Learner has completed Module 02 and has a workbench with Python 3.9 or later
- A `training-hub` ClusterTrainingRuntime is available in the cluster

## Related Requirements

- RHAIBU-M33EHSWMJJJG

## Verified By

- features/distributed-training/kubeflow-trainer-v2/content/modules/ROOT/pages/module-03-advanced.adoc
