---
schema_version: 1
id: RHAIBU-M33EBKPYJXSR
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must run a Ray-based distributed workload end to end — create a
workbench with a CodeFlare SDK image, download the demo notebooks, configure
and start an mTLS-secured Ray cluster through Kueue, and prove it is `Active`
from the notebook, the CLI, and the Ray dashboard. This is the core deliverable
of the workshop.

## Requirements

- [REQ-021] Learner MUST be able to create a workbench with a CodeFlare SDK image and observe the workbench status change from `Starting` to `Running`
- [REQ-022] Learner MUST be able to download the CodeFlare SDK demo notebooks (`copy_demo_nbs()`) and confirm `demo-notebooks/guided-demos` contains `2_basic_interactive.ipynb`
- [REQ-023] Learner MUST be able to configure and start an mTLS-secured Ray cluster from a notebook (`Cluster`, `ClusterConfiguration`, `TokenAuthentication`, `generate_cert`) and observe `cluster.status()`/`cluster.details()` reporting `Active` with `oc get rayclusters`/`oc get workloads` reporting `ready` and `Admitted: True`
- [REQ-024] Learner MUST be able to manage Ray clusters with the interactive notebook controls (`view_clusters()`) and open the Ray dashboard from the notebook

## Success Metrics

The notebooks run to completion; the Ray cluster reaches `Active`/`ready` and is
admitted by Kueue; `view_clusters()` shows the cluster selector with status and
resource details; the Ray dashboard opens from the notebook.

## Risks

- The Ray cluster image Python version must match the workbench Python version
- No default local queue means `local_queue` must be set explicitly in each cluster configuration
- The token and server credentials expire after 24 hours and must not be stored in Git

## Assumptions

- Learner has completed Module 01 (components verified) and has a project with a local queue (or sets `local_queue` explicitly)

## Related Requirements

- RHAIBU-M33EBKPA661M

## Verified By

- features/distributed-training/kuberay/content/modules/ROOT/pages/module-02-hands-on.adoc
