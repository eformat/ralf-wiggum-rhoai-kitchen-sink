---
schema_version: 1
id: RHAIBU-M33EHAMQJPQ0
type: requirement
---
# Module 01: Getting Started

## Problem

Before submitting workloads, learners need the Kueue queue objects in place: a
ResourceFlavor describing the cluster resources, a ClusterQueue defining the
quota, and a LocalQueue inside their project that workloads reference. They also
need their project labeled for Kueue management. Without this orientation,
later hands-on steps are copy-paste with no understanding of what is being
created.

## Requirements

- [REQ-011] Learner MUST be able to explain the role of the Red Hat build of Kueue Operator in the distributed workloads stack (Ray-based workloads use `kueue` and `ray`; Training Operator-based use `trainingoperator` and `kueue`)
- [REQ-012] Learner MUST be able to verify the Kueue CRDs (`clusterqueues`, `localqueues`, `resourceflavors`, `workloads`) and the running `kueue-controller-manager` pod in `redhat-ods-applications`
- [REQ-013] Learner MUST be able to apply the `kueue.openshift.io/managed=true` label to their namespace and confirm it via `oc get namespace {guid}-{user} --show-labels`
- [REQ-014] Learner MUST be able to list `workshop-lq`, `workshop-cq`, and `default-flavor` via `oc get localqueues,clusterqueues,resourceflavors` and confirm the `kueue.x-k8s.io/default-queue: 'true'` annotation from the console

## Success Metrics

Learner completes all three exercises: the infrastructure check, the namespace
label, and the queue-object apply, each producing the documented expected
output.

## Risks

- The Kueue CRDs and controller pods only exist after the distributed workloads components are activated; on clusters without them, Exercise 1 must be adapted
- Labeling a shared namespace changes how all of its workloads are queued (documented WARNING)

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33EHAMGX1Z9

## Verified By

- features/distributed-training/kueue/content/modules/ROOT/pages/module-01-getting-started.adoc
