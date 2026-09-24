# Observations: Kubeflow Trainer v2 (doc-derived)

## Summary

Kubeflow Trainer v2 is RHOAI 3.5's GA path for distributed model training on
OpenShift. It replaces Training Operator v1's framework-specific CRDs
(`PyTorchJob`) with a unified `TrainJob` API plus pre-built
`ClusterTrainingRuntime` infrastructure templates referenced through
`runtimeRef`. This observation document was produced from the official RHOAI
3.5 product documentation (Working with distributed workloads, Chapter 6: Run
Kubeflow Trainer v2-based distributed training workloads) because no live demo
cluster was available at authoring time. Every item below is doc evidence, not
UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | kftrainer-distributed-workloads.txt | §6.1 Understanding and using training runtimes | Five pre-built ClusterTrainingRuntimes: `torch-distributed`, `torch-distributed-rocm`, `torch-distributed-cuda128-torch29-py312`, `training-hub`, `training-hub-th05-cuda128-torch29-py312`; `runtimeRef` connects a TrainJob to a runtime by name and kind; runtimes encapsulate torchrun, `MASTER_ADDR`/`MASTER_PORT`, node coordination, image defaults |
| 2 | kftrainer-distributed-workloads.txt | §6.1.4 Creating a custom TrainingRuntime | Namespace-scoped `TrainingRuntime` created from console (Administrator perspective → Home → Search → Create TrainingRuntime); useful for custom images, env vars, default resources, volume mounts; TrainJob must be created in the same namespace |
| 3 | kftrainer-distributed-workloads.txt | §6.2.1–6.2.2 Creating a TrainJob (console + CLI) | `numNodes` replaces separate Master/Worker replicas (1 Master + 2 Workers ≡ `numNodes: 3`); `resourcesPerNode` applies the same requests/limits to every node; `podTemplateOverrides` mounts a ConfigMap training script; console flow: Home → Search → TrainJob → Create; CLI: `oc apply -f trainjob.yaml` then `oc get trainjob`; JobSet Operator from OLM is a prerequisite |
| 4 | kftrainer-distributed-workloads.txt | §6.2.3–6.2.5 Suspend/resume/delete | `oc patch trainjob ... --type=merge -p '{"spec":{"suspend":true}}'` pauses training and frees resources; with JIT checkpointing the state is saved before pods terminate on suspend; resume (`suspend:false`) reloads the latest checkpoint; `oc delete trainjob/<name>` removes the job |
| 5 | kftrainer-distributed-workloads.txt | §6.3 Using the Kubeflow SDK | `pip install kubeflow --index-url https://console.redhat.com/api/pypi/public-rhai/rhoai/3.2/cuda12.9-ubi9/simple/` (`pip show` → `0.2.1+rhai0`); auth via `oc whoami --show-server/--show-token`; `TrainerClient` + `KubernetesBackendConfig`; `TransformersTrainer(func, num_nodes, resources_per_node)`; RHAI trainers enable progress tracking and JIT checkpointing by default (`enable_progression_tracking=False` to disable); RBAC for SDK access to ClusterTrainingRuntimes is an admin prerequisite |
| 6 | kftrainer-distributed-workloads.txt | §6.3.2 + §7 Checkpointing | JIT checkpointing: `output_dir="pvc://..."` on the TransformersTrainer, PVC with ReadWriteMany required, checkpoint saved on SIGTERM and reloaded on restart; S3 checkpointing uses `s3://` output_dir + `data_connection_name` + `periodic_checkpoint_config`; known limitations: no shared model cache (a 70B BF16 model uses ~140 GB cache per pod), TorchElastic graceful-shutdown period may be insufficient for very large models |
| 7 | kftrainer-distributed-workloads.txt | §6.4 Fine-tuning with Training Hub | OSFT: continual learning without catastrophic forgetting, no supplementary dataset required; SFT: standard fine-tuning using PyTorch FSDP; `pip install training-hub==0.3.0`; OSFT example needs 2 nodes x 2 NVIDIA L40/L40S GPUs, 4 CPUs, 32 GiB per node; RWX-capable storage provisioner (e.g. OpenShift Data Foundation) required |
| 8 | kftrainer-distributed-workloads.txt | §8 Monitoring distributed workloads | OpenShift AI dashboard: `Observe & monitor → Workload metrics`; project metrics show CPU/Memory requested vs total shared cluster-queue quota; distributed workload status and Kueue alerts views; AI pipelines workloads are excluded from distributed-workloads metrics |

## User Flows

### Flow 1: Launch a distributed TrainJob from the CLI

1. **Verify runtime availability** — `oc get clustertrainingruntime` lists `torch-distributed` (§6.2.2)
2. **Create the training script and ConfigMap** — `oc create configmap training-script-configmap --from-file=train.py` (§6.2.2)
3. **Apply the TrainJob manifest** — `runtimeRef` (name + kind), `trainer.command`, `numNodes`, `resourcesPerNode`, `podTemplateOverrides` for the ConfigMap mount (§6.2.2)
4. **Monitor** — `oc get trainjob -n <namespace>`, then `oc logs <pod-name>` (§6.2.2)
5. **Lifecycle** — suspend/resume via `oc patch ... spec.suspend`, delete via `oc delete trainjob/<name>` (§6.2.3–6.2.5)

### Flow 2: Submit a TrainJob with the Kubeflow SDK

1. **Prerequisites** — workbench with Python 3.9+, SDK installed from the Red Hat PyPI index, RBAC for SDK access (§6.3.1)
2. **Authenticate** — `oc whoami --show-server` / `--show-token`; `KubernetesBackendConfig` with Bearer token (§6.3.1)
3. **Define and submit** — `train_func` closure, `TransformersTrainer(func, num_nodes, resources_per_node)`, `trainer_client.train(trainer, runtime)` (§6.3.1)
4. **Verify** — `trainer_client.get_job(job_name)` status; `oc get pods -l job-name=<job-name>`; optional dashboard TrainingJobs progress metrics (§6.3.1)

### Flow 3: Fine-tune an LLM with Training Hub

1. **Verify the runtime** — `oc get clustertrainingruntime training-hub` (§6.4.1)
2. **Install and configure** — `pip install training-hub==0.3.0`, SDK client auth (§6.4.1)
3. **Set OSFT parameters** — model/data paths, hyperparameters (`unfreeze_rank_ratio`, `use_liger`), distributed settings (§6.4.1.1)
4. **Run and verify** — `TrainingHubTrainer(algorithm=OSFT, func_args, resources_per_node)` with RWX PVC mounted via pod-template overrides; follow logs with `get_job_logs` (§6.4.1)

## Features and Concepts

### OpenShift Platform
- TrainJob / TrainingRuntime / ClusterTrainingRuntime CRs (`trainer.kubeflow.org/v1alpha1`), JobsSet Operator from OLM, ConfigMap volumes, RBAC for SDK access

### RHOAI / AI Platform
- Kubeflow Trainer component in the DataScienceCluster, pre-built ClusterTrainingRuntimes, Kubeflow SDK from the Red Hat PyPI index, RHAI trainers (`TransformersTrainer`, `TrainingHubTrainer`) with progress tracking + JIT checkpointing by default, Training Hub fine-tuning algorithms (OSFT, SFT), dashboard `Model training` / `Observe & monitor → Workload metrics`

### AI/ML Fundamentals
- Distributed PyTorch training (torchrun, process groups, DDP), FSDP sharding for SFT, fine-tuning vs continual learning (OSFT), checkpointing strategies (JIT vs periodic, PVC vs S3), storage planning per training strategy (FSDP predictable 2x checkpoint peaks; ZeRO-3 up to 42.5x)

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: distributed training concepts, `oc` CLI basics, Python
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with the Kubeflow Trainer component enabled in the DSC, JobSet Operator installed, worker nodes with NVIDIA GPUs, RWX-capable storage for fine-tuning exercises

## Open Questions

- Workshop cluster GPU inventory (module 02 needs 2+ NVIDIA GPUs; the OSFT example needs 4x L40/L40S) must be confirmed before Act-phase testing
- Confirm the pre-built runtime names on the workshop cluster (doc notes names vary with the RHOAI release; only `torch-distributed` and `training-hub` are guaranteed)
- Whether the RHBoK 1.4 compatibility constraint (flagged in workshop content) applies to the target workshop cluster's Kueue version
