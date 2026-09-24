# GPU Tracking — labs needing a GPU node

This run was executed on the CPU cluster (OCP 4.22.13, amd64, **no GPU**).
Labs below need a GPU node (or IBM Z/Power for the last one) and were run
**observe-only** — revisit when a GPU cluster is provisioned.

| Lab | What needs GPU | Status this run |
|---|---|---|
| `vllm-serving-runtime-kserve` | `nvidia.com/gpu: 1` in the InferenceService; NVIDIA hardware profile | module 02 deploy observe-only |
| `rhai-fast-release-images` | CUDA fast-release image + NFD; GPU hardware profile | module 02 deploy observe-only |
| `llmd-core` | NVIDIA A100/A10G accelerator profile; `nvidia.com/gpu: 1` per replica | model deploy observe-only |
| `llminferenceservice-config` | `nvidia.com/gpu: 1` per replica; RDMA for prefill/decode disaggregation | deploy observe-only |
| `llmd-kv-cache-tiering` / `llmd-latency-routing` / `llmd-lora-routing` | model deploy via wizard (single-node, GPU implied) | observe-only |
| `maas-vllm-deployment` | hardware profile with ≥1 NVIDIA GPU; vLLM CUDA LLMInferenceServiceConfig | deploy observe-only |
| `maas-llmd-deployment` | appropriate (GPU) hardware profile for llm-d | deploy observe-only |
| `kubeflow-trainer-v2` | 2-node PyTorch TrainJobs; OSFT: 4x L40/L40S; without GPU observe-only | observe-only |
| `text-mode-multimodal-training` | 2 nodes x 2x NVIDIA L40/L40S for OSFT | observe-only |
| `kuberay` | module 03: `nvidia.com/gpu: 1` worker + CUDA Ray image; modules 1-2 CPU | module 03 observe-only |
| `llama-stack-ogx-core` | vLLM models it connects to are learner-deployed with GPU (prereq: vllm-serving-runtime-kserve) | module 02 observe-only |
| `autorag` | vLLM foundation models with tool calling (GPU-backed) | observe-only |
| `automated-red-teaming-garak` / `evalhub` | GPU-backed target models (external endpoints otherwise) | observe-only |
| `vllm-cpu-ibm-z-power` | IBM Z (s390x) / Power (ppc64le) architecture — NOT a GPU need; meaningless on x86_64 | observe-only (arch) |

GPU-requiring module steps are marked in `qa/status.yml` as `observe-only` and
in each lab's run report under `qa/runs/<slug>/`.

## What a GPU cluster needs to add

1. `cluster/overlays/gpu-config` — NFD operator + `activation/` NodeFeatureDiscovery + sample NVIDIA AcceleratorProfile
2. GPU worker nodes with the NVIDIA operator (accelerator operators: NVIDIA/Gaudi/AMD/Spyre per the vllm lab)
3. Re-run the observe-only labs with `qa/run-lab.sh <slug> --from <NN>` after generating fresh playbooks
