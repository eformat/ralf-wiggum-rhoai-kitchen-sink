---
schema_version: 1
id: RHAIBU-M33EBKPA661M
type: requirement
---
# KubeRay (CodeFlare Operator successor) Workshop

## Problem

Platform engineers and data scientists evaluating RHOAI 3.5 need hands-on
experience with Ray-based distributed workloads — the KubeRay Operator path
queued through the Red Hat build of Kueue — before they can run distributed
training or tuning jobs at scale. Without a structured workshop, learners must
reverse-engineer the KubeRay/Kueue/CodeFlare SDK stack, the mTLS-secured cluster
flow, and the queueing diagnostics from product documentation alone. This
workshop targets RHOAI users with working knowledge of OpenShift and the `oc`
CLI.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify the distributed workloads components are installed: `rayclusters.ray.io` CRD registered and the Ray operator and Kueue controller pods `Running` in `redhat-ods-applications`
- [REQ-003] Learner MUST be able to create a workbench with a CodeFlare SDK image and observe the workbench status change from `Starting` to `Running`
- [REQ-004] Learner MUST be able to configure and start an mTLS-secured Ray cluster from a Jupyter notebook with the CodeFlare SDK and observe it `Active` (`ready`) and admitted by Kueue (`Admitted: True`)
- [REQ-005] Learner MUST be able to manage Ray clusters with the interactive notebook controls (`view_clusters()`) and open the Ray dashboard from the notebook
- [REQ-006] Learner MUST be able to compile and run an AI pipeline that creates a Ray cluster and confirm the pipeline run completes
- [REQ-007] Learner MUST be able to monitor distributed workload metrics and status in the OpenShift AI dashboard (`Observe & monitor` → `Workload metrics`)
- [REQ-008] Learner SHOULD be able to diagnose a suspended Ray cluster via the Workload, RayCluster, and ClusterQueue resources and resolve it

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the lab;
the Ray cluster reaches `Active`/`ready` in module 02, the pipeline run logs
`Ray cluster is up and running: True` in module 03, and the suspended-cluster
diagnosis path produces a clear quota/flavor message that matches the fix.

## Risks

- Workshop cluster must have the distributed workloads components (`ray` and `kueue`) enabled by the cluster administrator
- A local queue must exist in the learner's project (or be specified explicitly in each cluster configuration)
- The Ray cluster image Python version must match the workbench Python version or the cluster fails

## Assumptions

- RHOAI 3.5 is installed with the distributed workloads components configured
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`, `%token%`, `%server%`)
- A workbench image that includes the CodeFlare SDK (for example Standard Data Science) is available

## Related Designs

- RHAIBU-M33EBKR0JVB4

## Related Decisions

- RHAIBU-M33EBKQFJRMF
- RHAIBU-M33EBKQSK76M

## Related Requirements

- RHAIBU-M33EBKPKR497
- RHAIBU-M33EBKPYJXSR
- RHAIBU-M33EBKQ7PEH9
