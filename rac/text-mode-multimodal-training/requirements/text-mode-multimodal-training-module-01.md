---
schema_version: 1
id: RHAIBU-M33E521NFKSW
type: requirement
---
# Module 01: Getting Started

## Problem

Before running a text-mode fine-tuning job, learners need a mental model of the
Training Hub fine-tuning stack: what text-mode training does, how the
`training-hub` `ClusterTrainingRuntime` encapsulates the distributed training
infrastructure, and how the same training surface appears from the CLI, the
console, and the Kubeflow SDK. Without this orientation, later hands-on steps
are copy-paste with no understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST observe that `oc get clustertrainingruntime` output includes at least one `training-hub` row
- [REQ-012] Learner MUST observe that `oc get clustertrainingruntime training-hub -o yaml` shows the `trainer.kubeflow.org` API group and the runtime's encapsulated distributed training infrastructure
- [REQ-013] Learner MUST observe that console `Home → Search` with the `TrainJob` resource type selected shows an empty list before module 02
- [REQ-014] Learner MUST observe that `oc get trainjob` in their project returns `No resources found` before submitting a fine-tuning job

## Success Metrics

Learner completes both exercises: the Training Hub runtime tour (list and
inspect the `training-hub` runtime, read the `runtimeRef` connection) and the
training-surface observation from the console and the SDK, each producing the
documented expected output.

## Risks

- `ClusterTrainingRuntime` resources only exist after the Kubeflow Trainer component is enabled in the `DataScienceCluster`; on clusters without it, exercise 1 must be adapted
- Runtime names and variants vary by RHOAI release; the `training-hub` rows are the ones this workshop depends on

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33E5219KH8J

## Verified By

- features/agents-mcp/text-mode-multimodal-training/content/modules/ROOT/pages/module-01-getting-started.adoc
