---
schema_version: 1
id: RHAIBU-M33EHSWXEF4M
type: requirement
---
# Module 01: Core Concepts

## Problem

Before launching distributed training jobs, learners need a mental model of the
unified `TrainJob` API, how `runtimeRef` connects a job to a
`ClusterTrainingRuntime`, and which pre-built runtimes the platform provides.
Without this orientation, the v1→v2 mapping (`numNodes`, `resourcesPerNode`,
`podTemplateOverrides`) in later hands-on steps is copy-paste with no
understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to confirm the Kubeflow Trainer v2 CRDs are installed by finding the `TrainJob` resource type via console `Home → Search`
- [REQ-012] Learner MUST be able to map Training Operator v1 concepts (PyTorchJob, Master/Worker replicas, per-replica resources) to the TrainJob v2 API (`numNodes`, `resourcesPerNode`, `runtimeRef`)
- [REQ-013] Learner MUST be able to list the pre-built `ClusterTrainingRuntime` resources with `oc get clustertrainingruntime` and confirm `torch-distributed` and `training-hub` are present
- [REQ-014] Learner MUST be able to view the `torch-distributed` runtime YAML with `oc get clustertrainingruntime torch-distributed -o yaml` and identify the `mlPolicy` and `template` sections

## Success Metrics

Learner completes both exercises: the v1→v2 concept mapping walkthrough and the
runtime inspection commands, each producing the documented expected output.

## Risks

- Runtime names vary with the RHOAI release; the exercises only require `torch-distributed` and `training-hub` to be present

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33EHSWMJJJG

## Verified By

- features/distributed-training/kubeflow-trainer-v2/content/modules/ROOT/pages/module-01-concepts.adoc
