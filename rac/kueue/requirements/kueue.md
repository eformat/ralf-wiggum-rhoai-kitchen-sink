---
schema_version: 1
id: RHAIBU-M33EHAMGX1Z9
type: requirement
---
# Kueue (Red Hat build of Kueue Operator) Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with the Red Hat build of Kueue Operator — the GA component that
manages quotas and queues distributed workloads against them — before they can
recommend or operate it in production. Without a structured workshop, learners
must reverse-engineer the ResourceFlavor/ClusterQueue/LocalQueue object model,
the Workload admission semantics, and the alerting surface from product
documentation alone. This workshop targets RHOAI users with working knowledge of
OpenShift and distributed training concepts.

## Requirements

- [REQ-001] Learner MUST be able to verify the Kueue infrastructure with `oc get crds | grep kueue` and confirm the `kueue-controller-manager` pod reports `Running`
- [REQ-002] Learner MUST be able to enable a project for Kueue management with the `kueue.openshift.io/managed=true` label and confirm it with `oc get namespace --show-labels`
- [REQ-003] Learner MUST be able to create ResourceFlavor, ClusterQueue, and LocalQueue objects and confirm them from the CLI and the OpenShift console
- [REQ-004] Learner MUST be able to submit a PyTorchJob to a LocalQueue with the `kueue.x-k8s.io/queue-name` label and verify the job and its pods run
- [REQ-005] Learner MUST be able to observe Kueue's scheduling decision by reading Workloads: an admitted job shows `ADMITTED True` and an oversized job shows `ADMITTED False` with a `status.conditions.message` explaining the insufficient quota
- [REQ-006] Learner SHOULD be able to review the Kueue alerting rules in the OpenShift console and follow a firing alert to its linked runbook

## Success Metrics

All six acceptance criteria are demonstrated by the learner during the lab; the
`pytorch-ddp` PyTorchJob runs through the queue, the oversized `pytorch-ddp-xl`
job is held with an insufficiency message in its Workload conditions, and any
firing alert resolves after the runbook steps are followed.

## Risks

- Kueue must be installed and activated by the cluster administrator as part of the distributed workloads components; on clusters without it, every step fails
- Workshop cluster must have enough CPU/memory headroom for the 8 CPU / 32Gi ClusterQueue quota and two concurrent PyTorchJobs
- The training image `registry.redhat.io/rhoai/odh-training-cuda128-torch28-py312-rhel9:v3.0` must be pullable from the cluster

## Assumptions

- RHOAI 3.5 is installed with the distributed workloads components (`kueue`, `ray`, `trainingoperator`) enabled
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- Learners have a personal project to label and submit workloads into

## Related Designs

- RHAIBU-M33EHANXN3JC

## Related Decisions

- RHAIBU-M33EHANBB7BR
- RHAIBU-M33EHANMVTG0

## Related Requirements

- RHAIBU-M33EHAMQJPQ0
- RHAIBU-M33EHAN2PFXM
