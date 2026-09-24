---
schema_version: 1
id: RHAIBU-M33E5219KH8J
type: requirement
---
# Text-mode Training for Multimodal Models in Training Hub Workshop

## Problem

Data scientists and platform engineers evaluating RHOAI 3.5 need hands-on
experience with text-mode training for multimodal models in Training Hub — the
Developer Preview enhancement that lets Training Hub fine-tune
multimodal-capable vision-language model architectures using text datasets —
before they can recommend or operate the fine-tuning stack in production.
Without a structured workshop, learners must reverse-engineer the
`ClusterTrainingRuntime` infrastructure, the `runtimeRef` connection, and the
Kubeflow SDK workflow from product documentation alone. This workshop targets
RHOAI users with working knowledge of OpenShift and distributed training
concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify the `training-hub` `ClusterTrainingRuntime` exists with `oc get clustertrainingruntime` (at least one `training-hub` row)
- [REQ-003] Learner MUST be able to inspect the runtime structure with `-o yaml` and read how a `TrainJob` connects to it through the `runtimeRef` field (`trainer.kubeflow.org` API group)
- [REQ-004] Learner MUST be able to observe the training surface from the CLI and console before training (`oc get trainjob` returns `No resources found`; `TrainJob` appears as a creatable resource type under console `Home → Search`)
- [REQ-005] Learner MUST be able to configure the Kubeflow SDK client in a workbench and select the `training-hub` runtime (`list_runtimes()` prints `Selected runtime: training-hub`)
- [REQ-006] Learner MUST be able to run the fine-tuning job with `TrainingHubTrainer`, follow its logs with `client.get_job_logs`, and check the final job status with `client.get_job`
- [REQ-007] Learner MUST be able to delete the finished job and verify removal from the CLI and console with checkpoints retained on the `shared` RWX PVC

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the `training-hub` runtime is identified in module 01, the SDK client selects
it in module 02, and after `client.delete_job` the job no longer appears in
`oc get trainjob -n {guid}-{user}` or the console `Workloads → Jobs` list.

## Risks

- Text-mode training is a Developer Preview feature in 3.5 and may change between releases
- The hands-on workflow requires GPU nodes (2 nodes x 2 NVIDIA GPUs for the OSFT example) that workshop clusters may not provide; learners follow along and observe instead
- SDK access requires RBAC permissions for `ClusterTrainingRuntime` resources configured by the cluster administrator

## Assumptions

- RHOAI 3.5 is installed with the Kubeflow Trainer component enabled in the `DataScienceCluster`
- The JobSet Operator is installed from OLM and configured by the cluster administrator
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- The hands-on module assumes a workbench with an RWX-capable PVC named `shared` (such as Red Hat OpenShift Data Foundation)

## Related Designs

- RHAIBU-M33E5230GZ1R

## Related Decisions

- RHAIBU-M33E522CPQBW
- RHAIBU-M33E522QXSAA

## Related Requirements

- RHAIBU-M33E521NFKSW
- RHAIBU-M33E5221Y0JN
