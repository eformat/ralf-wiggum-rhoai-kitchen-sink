# Observations: Text-mode Training for Multimodal Models in Training Hub (doc-derived)

## Summary

Text-mode training for multimodal models in Training Hub is a RHOAI 3.5
Developer Preview enhancement that lets Training Hub fine-tune
multimodal-capable vision-language model architectures (VLMs) using text
datasets. This observation document was produced from the official RHOAI 3.5
product documentation (release notes, Developer Preview features; Working with
distributed workloads, Kubeflow Trainer v2 chapters) because no live demo
cluster was available at authoring time. Every item below is doc evidence, not
UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §3.5 EA Developer Preview features — Text-mode training for multimodal models in Training Hub | Training Hub supports text-only training ("text mode") for multimodal model architectures; enables fine-tuning Qwen 3.5, Qwen 3.6, Qwen 3.8, Gemma, Nemotron, and Mistral vision-language models (VLMs) using text datasets; in this release multimodal-capable models can be fine-tuned in text mode only |
| 2 | kftrainer-distributed-workloads.txt | §6.1.1 Understanding ClusterTrainingRuntimes | ClusterTrainingRuntimes are cluster-scoped infrastructure templates created by the platform administrator; `TrainJob` references a runtime through the `runtimeRef` field; the runtime handles torchrun, environment variables (MASTER_ADDR, MASTER_PORT), node coordination, and container image defaults; pre-built runtimes include `training-hub` (built-in fine-tuning algorithms OSFT, SFT) and `training-hub-th05-cuda128-torch29-py312` (CUDA 12.8, PyTorch 2.9, Python 3.12) |
| 3 | kftrainer-distributed-workloads.txt | §6.4.1 Configuring the fine-tuning job | Prerequisites: JobSet Operator from OLM, RBAC for SDK access to ClusterTrainingRuntime resources, `oc get clustertrainingruntime training-hub` verification, workbench with RWX-capable storage (e.g. Red Hat OpenShift Data Foundation); procedure: `pip install kubeflow --index-url https://console.redhat.com/api/pypi/public-rhai/...` + `pip install training-hub==0.3.0`, SDK client auth via KubernetesBackendConfig, `list_runtimes()` selects `training-hub` |
| 4 | kftrainer-distributed-workloads.txt | §6.4.1.1 OSFT training parameters | OSFT (Orthogonal Subspace Fine-Tuning) enables continual learning without catastrophic forgetting and needs no supplementary dataset; example params: `model_path` Qwen/Qwen2.5-1.5B-Instruct, `.jsonl` data with `messages` structure, hyperparameters (unfreeze_rank_ratio, effective_batch_size, learning_rate), distributed settings delegated to Kubeflow Trainer (nproc_per_node, nnodes) |
| 5 | kftrainer-distributed-workloads.txt | §6.4 Fine-tuning algorithms | Two supported fine-tuning algorithms through Training Hub: OSFT and SFT (Supervised Fine-Tuning, standard task adaptation using PyTorch FSDP across multiple GPUs and nodes) |

## User Flows

### Flow 1: Identify the Training Hub runtime (concepts)

1. **Prerequisites** — Kubeflow Trainer component enabled in the DataScienceCluster (§6.4.1)
2. **List runtimes** — `oc get clustertrainingruntime`; observe `training-hub` rows (§6.1.1)
3. **Inspect runtime** — `oc get clustertrainingruntime training-hub -o yaml`; read the `runtimeRef` connection from `TrainJob` (§6.1.2–6.1.3)

### Flow 2: Fine-tune a multimodal-capable model in text mode (hands-on)

1. **Install dependencies** — `pip install kubeflow --index-url .../rhoai/...` + `pip install training-hub==0.3.0` (§6.4.1)
2. **Authenticate the SDK client** — KubernetesBackendConfig with API server URL and Bearer token (§6.4.1)
3. **Select the runtime** — `list_runtimes()` loop prints `Selected runtime: training-hub` (§6.4.1)
4. **Configure training parameters** — OSFT (or SFT) params with `model_path`, `.jsonl` `messages` data, and distributed settings (§6.4.1.1)
5. **Run and observe** — `client.train` with `TrainingHubTrainer`, follow logs, check job status (§6.4)
6. **Clean up** — delete the job to release resources

## Features and Concepts

### OpenShift Platform
- Cluster-scoped `ClusterTrainingRuntime` infrastructure templates vs namespace-scoped `TrainingRuntime`; RBAC for SDK access; Workloads → Pods/Jobs in the Administrator perspective

### RHOAI / AI Platform
- Training Hub fine-tuning stack on Kubeflow Trainer v2; unified `TrainJob` API; pre-built `training-hub` runtimes; text-mode training as Developer Preview; dashboard `Model training` progress tracking with RHOAI trainers

### AI/ML Fundamentals
- Fine-tuning with labelled data; OSFT (orthogonal subspace, continual learning without catastrophic forgetting) vs SFT (supervised, FSDP); multimodal-capable VLM architectures trained on text-only datasets; JSON Lines `messages` data format

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: data scientists and platform engineers with OpenShift working knowledge
- **Prerequisite knowledge**: distributed training concepts, `oc` CLI basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with the Kubeflow Trainer component enabled in the DataScienceCluster, JobSet Operator from OLM, RWX-capable storage; GPU nodes (2 x 2 NVIDIA L40/L40S for OSFT) only for the full hands-on run

## Open Questions

- Which Qwen/Gemma/Nemotron/Mistral VLM checkpoints are practically reachable in a workshop cluster with limited GPU quota (doc lists families, not sizes)
- Whether the SFT variant deserves a runnable example alongside the OSFT walkthrough (docs give SFT parameters and validated model sizes separately)
- Live-cluster confirmation of the dashboard `Model training` progress view (doc-derived behavior)
