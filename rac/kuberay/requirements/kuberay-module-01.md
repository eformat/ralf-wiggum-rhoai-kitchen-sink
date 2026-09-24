---
schema_version: 1
id: RHAIBU-M33EBKPKR497
type: requirement
---
# Module 01: Core Concepts

## Problem

Before creating Ray-based workloads, learners need a mental model of the
distributed workloads infrastructure — CodeFlare SDK, KubeRay Operator, Kueue,
Training Operator, and cert-manager — and confirmation that the KubeRay and
Kueue components are actually installed in the cluster. Without this
orientation, the later hands-on steps are copy-paste with no understanding of
what is being created.

## Requirements

- [REQ-011] Learner MUST be able to explain the role of each distributed workloads component (CodeFlare SDK, KubeRay Operator, Kueue Operator, Training Operator, cert-manager) and that Ray-based workloads use the `kueue` and `ray` components
- [REQ-012] Learner MUST be able to verify the KubeRay CRD is registered (`oc get crd rayclusters.ray.io` returns the CRD instead of `NotFound`)
- [REQ-013] Learner MUST be able to confirm the Ray operator and Kueue controller pods show `Running` in `redhat-ods-applications`
- [REQ-014] Learner MUST be able to list local queues in the working project (`oc get localqueues -n {user}`) or note that none exist

## Success Metrics

Learner completes both exercises: the architecture walkthrough and the cluster
inspection commands, each producing the documented expected output.

## Risks

- On clusters without the distributed workloads components installed, exercise 2 must be adapted

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33EBKPA661M

## Verified By

- features/distributed-training/kuberay/content/modules/ROOT/pages/module-01-concepts.adoc
