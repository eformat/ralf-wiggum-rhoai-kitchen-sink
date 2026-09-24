# Observations: Kueue (Red Hat build of Kueue Operator) (doc-derived)

## Summary

The Red Hat build of Kueue Operator is RHOAI 3.5's GA component for managing
quotas and queueing distributed workloads against them. This observation
document was produced from the official RHOAI 3.5 product documentation (Working
with distributed workloads) because no live demo cluster was available at
authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | kueue-distributed-workloads.txt | §1.1 Distributed workloads infrastructure | Six components: CodeFlare SDK, Kubeflow Training Operator (+ SDK), KubeRay Operator, Red Hat build of Kueue Operator, cert-manager; the Kueue Operator "manages quotas and how distributed workloads consume them, and manages the queueing of distributed workloads with respect to those quotas" |
| 2 | kueue-distributed-workloads.txt | §1.2 Types of distributed workloads | Ray-based workloads use the `kueue` and `ray` components; Training Operator-based use `trainingoperator` and `kueue`; CUDA images for NVIDIA GPUs, ROCm images for AMD GPUs; AI pipelines workloads are not managed by the distributed workloads feature and excluded from its metrics |
| 3 | kueue-distributed-workloads.txt | §2.4 Prerequisites for Training Operator jobs | Project enabled for Kueue management via the `kueue.openshift.io/managed=true` namespace label; resource flavor, cluster queue, and local queue Kueue objects created for the project (cross-ref: Configuring quota management for distributed workloads) |
| 4 | kueue-distributed-workloads.txt | §4.1.3 Checking the default local queue | Console flow: project → Search → Resources → LocalQueue → YAML tab; `kueue.x-k8s.io/default-queue: 'true'` annotation marks the default local queue; alternatively `codeflare_sdk.list_local_queues()` from a workbench |
| 5 | kueue-distributed-workloads.txt | §5.2 Running a job via the Training Operator SDK | Jobs target a LocalQueue through the `kueue.x-k8s.io/queue-name` label in the `labels` dict; `job_kind` defaults to PyTorchJob; AMD path changes `nvidia.com/gpu` to `amd.com/gpu` and drops `NCCL_DEBUG` |
| 6 | kueue-distributed-workloads.txt | §8.1–8.2 Viewing metrics and workload status | `Observe & monitor → Workload metrics` with Project metrics and Distributed workload status tabs; requested vs total-shared-quota (cluster queue) graphs; workload statuses: Pending, Inadmissible, Admitted, Running, Evicted, Succeeded, Failed |
| 7 | kueue-distributed-workloads.txt | §8.3 Viewing Kueue alerts | Console: Observe → Alerting → Alerting rules; each alert links to a runbook; rules: KueuePodDown (Critical, pod not ready 5 min), LowClusterQueueResourceUsage (Info, usage <20% of nominal quota >1 day), ResourceReservationExceedsQuota (Info, reservation 10× available quota), PendingWorkloadPods (Info, pod pending >3 days) |
| 8 | kueue-distributed-workloads.txt | §9.1–9.8 Troubleshooting reference | Workload `status.conditions.message` reports held-work reasons (e.g. "couldn't assign flavors to pod set … insufficient quota for nvidia.com/gpu in flavor default-flavor in ClusterQueue"); webhook error `kueue-webhook-service` means the Kueue pod may not be running; "pod terminated before image pulled" — Kueue waits 5 minutes by default before marking a workload ready |

## User Flows

### Flow 1: Prepare a project for Kueue-managed training

1. **Admin prerequisite** — Kueue installed and activated as part of the distributed workloads components (§1.1)
2. **Enable project** — apply `kueue.openshift.io/managed=true` to the project namespace (§2.4)
3. **Create queue objects** — resource flavor, cluster queue, local queue for the project (§2.4)
4. **Verify default queue** — console Search → LocalQueue, `default-queue: 'true'` annotation, or `list_local_queues()` (§4.1.3)

### Flow 2: Submit a Kueue-queued training job

1. **Submit job** — PyTorchJob (Training Operator or SDK) carrying the `kueue.x-k8s.io/queue-name` label (§5.2)
2. **Kueue decides** — workload admitted when quota allows, held otherwise; `status.conditions.message` explains held work (§9.1)
3. **Monitor** — Workload metrics and Distributed workload status tabs; statuses from Pending to Succeeded (§8.1–8.2)
4. **Troubleshoot** — Kueue alerts with runbook links; documented error messages for missing default queue, wrong local_queue name, webhook failures, image pull timeouts (§8.3, §9.3–9.8)

## Features and Concepts

### OpenShift Platform
- Namespaces and labels (`kueue.openshift.io/managed=true`), console Search/Observe surfaces, user workload monitoring

### RHOAI / AI Platform
- Red Hat build of Kueue Operator within the distributed workloads stack, ResourceFlavor/ClusterQueue/LocalQueue objects, Workload resource with admission conditions, Kueue alerting rules with runbooks, project metrics for distributed workloads

### AI/ML Fundamentals
- Distributed training with PyTorch DDP (nccl for GPU, gloo for CPU), quota-based scheduling of batch workloads, GPU vs CPU resource requests

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: distributed training concepts, `oc` CLI basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with the distributed workloads components installed and activated by a cluster administrator

## Open Questions

- Cluster queue quota sizing for workshop clusters (docs assume GPU-capable clusters; the lab uses CPU-only values) — to validate in the Act phase
- LocalQueue-vs-ClusterQueue console rendering on a live 3.5 console (doc-derived navigation paths)
