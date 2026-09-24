# Observations: KubeRay (CodeFlare Operator successor) (doc-derived)

## Summary

KubeRay (CodeFlare Operator successor) is RHOAI 3.5's GA path for running
Ray-based distributed workloads on OpenShift: the KubeRay Operator manages and
secures remote Ray clusters while the Red Hat build of Kueue manages the quotas
they consume. This observation document was produced from the official RHOAI
3.5 product documentation (Working with distributed workloads; Getting started
with Red Hat OpenShift AI) because no live demo cluster was available at
authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | kuberay-distributed-workloads.txt | §1.1 Distributed workloads infrastructure | Six components: CodeFlare SDK, Kubeflow Training Operator (+ Training Operator SDK), KubeRay Operator, Red Hat build of Kueue Operator, cert-manager Operator; CodeFlare SDK is not installed as part of OpenShift AI but included in some workbench images |
| 2 | kuberay-distributed-workloads.txt | §1.2 Types of distributed workloads | Ray-based workloads use the `kueue` and `ray` components; Training Operator-based use `trainingoperator` and `kueue`; CUDA images for NVIDIA GPUs and ROCm images for AMD GPUs; workloads run from AI pipelines, Jupyter notebooks, or VS Code files; AI pipelines workloads are not managed by the distributed workloads feature and excluded from its metrics |
| 3 | kuberay-distributed-workloads.txt | §2.1 Creating a workbench for distributed training | Workbench image + hardware profile (request/limit for CPU and memory) + cluster storage for sharing data between workbench and training runs; Verification: status changes from Starting to Running |
| 4 | kuberay-distributed-workloads.txt | §2.2 Using the cluster server and token to authenticate | Server and token values come from the OpenShift Console; authentication to the OpenShift API requires both |
| 5 | kuberay-distributed-workloads.txt | §4.1.1–4.1.3 Running workloads from Jupyter notebooks | `copy_demo_nbs()` copies demo notebooks from the installed CodeFlare SDK version; guided and additional demo notebook sets; `view_clusters()` interactive browser controls list Ray clusters, show status/allocated resources, and open the Ray dashboard without switching to the console; controls complement but do not replace the commands |
| 6 | kuberay-distributed-workloads.txt | §4.2 Running workloads from AI pipelines | Pipeline must include a link to the Ray cluster image; requires S3-compatible object storage, a connection, and a pipeline server |
| 7 | kuberay-distributed-workloads.txt | §8.1–8.2 Monitor distributed workloads | `Observe & monitor → Workload metrics`: Project metrics tab (CPU/Memory requested by project vs all projects vs total shared cluster-queue quota; top-5 resource consumers; resource metrics table with progress bars); Distributed workload status tab: Pending, Inadmissible, Admitted, Running, Evicted, Succeeded, Failed with a latest message per workload |
| 8 | kuberay-distributed-workloads.txt | §9.1–9.6 Troubleshooting reference | Suspended Ray cluster: check `status.conditions.message` on Workload and RayCluster resources plus ClusterQueue limits; failed state usually resolves after reconciliation; "Default Local Queue not found" and "local_queue provided does not exist" errors; wrong credentials give a 403 on CRD fetch |
| 9 | kuberay-getting-started.txt | §1.1 Data science workflow / glossary | Distributed orchestration stack (CodeFlare, Ray, Kueue) defined as CodeFlare for simplified distributed training, Ray for general-purpose distributed computing, Kueue for batch job queueing |
| 10 | kuberay-getting-started.txt | §4.2 Create a workbench | Dashboard flow: Projects → project → Workbenches tab → Create workbench → image, hardware profile, environment variables, cluster storage, connections |

## User Flows

### Flow 1: Ray cluster from a Jupyter notebook

1. **Prepare** — workbench with a CodeFlare SDK image; authenticate with the OpenShift server and token (§2.1–2.2)
2. **Download demos** — `copy_demo_nbs()` into `demo-notebooks` (§4.1.1)
3. **Configure cluster** — `Cluster`/`ClusterConfiguration` with namespace, worker count, image, local queue; `TokenAuthentication` login; `generate_cert` for mTLS (§4.1.2)
4. **Verify** — `cluster.status()`/`cluster.details()`; Kueue admission; Ray dashboard (§4.1.2–4.1.3)

### Flow 2: Ray cluster from an AI pipeline

1. **Prerequisites** — S3-compatible storage, connection, pipeline server; Ray cluster image link in the pipeline (§4.2)
2. **Compile** — `kfp` component wrapping the CodeFlare SDK cluster lifecycle, compiled to YAML
3. **Run** — import the pipeline and schedule a run; the run creates and tears down the Ray cluster
4. **Monitor** — Workload metrics for projects with distributed workloads (§8.1–8.2)

## Features and Concepts

### OpenShift Platform
- OpenShift API authentication (server + token), projects/namespaces, CRDs (`rayclusters.ray.io`), RBAC, operator pods in `redhat-ods-applications`

### RHOAI / AI Platform
- KubeRay Operator (manages/secures remote Ray clusters, controlled-network environment), Red Hat build of Kueue Operator (quotas, queueing, Workload/LocalQueue/ClusterQueue), distributed workloads metrics in `Observe & monitor → Workload metrics`

### AI/ML Fundamentals
- Ray head/worker pods and distributed compute, GPU acceleration (CUDA/ROCm images), quota-gated training runs

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: platform engineers and data scientists with OpenShift working knowledge
- **Prerequisite knowledge**: `oc` CLI basics, RHOAI operator installed, distributed workloads enabled
- **Estimated duration**: about 2 hours
- **Cluster requirements**: RHOAI 3.5 with `ray` and `kueue` components configured; local queue (or explicit `local_queue` per configuration)

## Open Questions

- Local-queue availability in workshop clusters (docs document the explicit `local_queue` fallback)
- Whether a VS Code-based flow (mentioned in §1.2 as a supported origin) warrants a workshop extension
- GPU quota in workshop clusters for the pipeline example (CPU-only fallback documented in docs)
