---
schema_version: 1
id: RHAIBU-M33EHSWMJJJG
type: requirement
---
# Kubeflow Trainer v2 Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with Kubeflow Trainer v2 — the GA path for distributed model
training on OpenShift — before they can recommend or operate it in production.
Training Operator v1's framework-specific CRDs (`PyTorchJob`) embedded per-job
infrastructure in every manifest; v2 moves that complexity into
`ClusterTrainingRuntime` templates referenced through `runtimeRef`. Without a
structured workshop, learners must reverse-engineer the runtime model, the
`TrainJob` API, and the SDK workflow from product documentation alone. This
workshop targets RHOAI users with working knowledge of OpenShift and
distributed training concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to confirm the Kubeflow Trainer v2 CRDs are installed via the console (`Home → Search` offers the `TrainJob` resource type)
- [REQ-003] Learner MUST be able to list the pre-built `ClusterTrainingRuntime` resources (`oc get clustertrainingruntime`) and inspect `torch-distributed` with `-o yaml`, including `mlPolicy` and `template` sections
- [REQ-004] Learner MUST be able to launch a two-node distributed PyTorch `TrainJob` from the CLI with a ConfigMap-mounted training script and confirm it appears in `oc get trainjob`
- [REQ-005] Learner MUST be able to verify distributed training by reading pod logs that show each rank out of `world_size` and a matching `all_reduce` result across nodes
- [REQ-006] Learner MUST be able to suspend, resume, and delete the `TrainJob` via `oc patch`/`oc delete` and confirm the job and pods are gone
- [REQ-007] Learner SHOULD be able to create a custom namespace-scoped `TrainingRuntime`, submit and monitor a `TrainJob` with the Kubeflow SDK, and run an OSFT fine-tuning job with a Training Hub runtime

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the `pytorch-minimal-example` `TrainJob` runs on two nodes with verified
`all_reduce` output in module 02, and the SDK/Training Hub fine-tuning job
reaches `Completed` status in module 03.

## Risks

- Hands-on exercises require worker nodes with supported NVIDIA GPUs; without GPUs the apply/monitor steps degrade to observe-only
- Kubeflow Trainer v2 in RHOAI 3.5 is not compatible with Red Hat Build of Kueue (RHBoK) 1.4 or later — workshop clusters must keep RHBoK at 1.3 or earlier
- Fine-tuning exercises (OSFT) need 4 GPUs total (2x L40/L40S per node) and RWX-capable storage such as OpenShift Data Foundation

## Assumptions

- RHOAI 3.5 is installed with the Kubeflow Trainer component enabled in the DataScienceCluster
- The platform administrator provisioned the pre-built `ClusterTrainingRuntime` resources (`torch-distributed`, `training-hub`)
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)

## Related Designs

- RHAIBU-M33EHSYBR70M

## Related Decisions

- RHAIBU-M33EHSXR38G7
- RHAIBU-M33EHSY3T5A6

## Related Requirements

- RHAIBU-M33EHSWXEF4M
- RHAIBU-M33EHSX5V8XN
- RHAIBU-M33EHSXD898E
