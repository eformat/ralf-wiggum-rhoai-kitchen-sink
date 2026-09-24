---
schema_version: 1
id: RHAIBU-M33EHAN2PFXM
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must work the core Kueue workflow end to end: submit a real PyTorch
training job through the LocalQueue, watch Kueue admit it, hold a second job
that exceeds the quota, and diagnose queueing problems with Workload
conditions, Kueue alerts, and the documented error messages. This is the core
deliverable of the workshop.

## Requirements

- [REQ-021] Learner MUST be able to submit a PyTorchJob (`kubeflow.org/v1`) to the LocalQueue with the `kueue.x-k8s.io/queue-name: workshop-lq` label and confirm the job and its head/worker pods run with tensor values in the logs
- [REQ-022] Learner MUST observe Kueue's admission decision via `oc get workloads`: the small job `ADMITTED True`, the oversized `pytorch-ddp-xl` job `ADMITTED False`
- [REQ-023] Learner MUST be able to read the held Workload's `status.conditions.message` and see the insufficient-quota reason for flavor `default-flavor` in ClusterQueue
- [REQ-024] Learner SHOULD be able to review the Kueue alerting rules table (KueuePodDown, LowClusterQueueResourceUsage, ResourceReservationExceedsQuota, PendingWorkloadPods) and the documented error messages, and confirm a resolved alert stops firing

## Success Metrics

`pytorch-ddp` runs through the queue and its pods complete; `pytorch-ddp-xl` is
held with `ADMITTED False` and a Workload conditions message explaining the
insufficient quota; alerting-rule review is complete.

## Risks

- Resource requests must fit within the ClusterQueue nominal quota or the first job is also held
- Kueue waits 5 minutes by default before marking a workload as ready; a very large image still being pulled causes Kueue to fail the workload (documented limitation)
- The alerting rules require user workload monitoring and console access

## Assumptions

- Learner has completed Module 01 (Kueue verified, project labeled, queue objects created)

## Related Requirements

- RHAIBU-M33EHAMGX1Z9

## Verified By

- features/distributed-training/kueue/content/modules/ROOT/pages/module-02-hands-on.adoc
