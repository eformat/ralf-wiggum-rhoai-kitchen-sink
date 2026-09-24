---
schema_version: 1
id: RHAIBU-M33EBKQ7PEH9
type: requirement
---
# Module 03: Advanced Usage

## Problem

After the notebook workflow, learners need to go beyond notebooks: run Ray
workloads from an AI pipeline, monitor distributed workload metrics and status
in the OpenShift AI dashboard, and troubleshoot the most common Ray cluster
failure state — a suspended cluster caused by insufficient quota or a missing
resource flavor.

## Requirements

- [REQ-031] Learner MUST be able to compile an AI pipeline component that creates a Ray cluster with GPU requests (`worker_extended_resource_requests`) and confirm the pipeline run completes with `Ray cluster is up and running: True`
- [REQ-032] Learner MUST be able to view project metrics and distributed workload status in the OpenShift AI dashboard (`Observe & monitor` → `Workload metrics`)
- [REQ-033] Learner MUST be able to diagnose a suspended Ray cluster by checking `status.conditions.message` on the Workload and RayCluster resources and the ClusterQueue limits
- [REQ-034] Learner SHOULD be able to resolve the suspended state by reducing requested resources (or gaining quota) and observe the Ray cluster status move from `Suspended` toward `Active`

## Success Metrics

Learner completes all three exercises: the pipeline run with
`Ray cluster is up and running: True` in the logs, the metrics/status
walkthrough with resource-usage data, and the suspended-cluster diagnosis with
a quota/flavor message that matches the fix.

## Risks

- The pipeline exercises require a configured connection and pipeline server plus S3-compatible object storage
- AI pipelines workloads are not included in the distributed workloads metrics
- GPU quota must exist for the `worker_extended_resource_requests` example

## Assumptions

- Learner has completed Module 02 (a Ray cluster workflow exists to diagnose)

## Related Requirements

- RHAIBU-M33EBKPA661M

## Verified By

- features/distributed-training/kuberay/content/modules/ROOT/pages/module-03-advanced.adoc
