---
schema_version: 1
type: asset
---
# Screenshot Evidence: vLLM deployment via MaaS (maas-vllm-deployment)

## Capture Summary

- **Date:** 2026-09-24
- **Cluster:** cluster-44gxc.dyn.redhatworkshops.io (RHOAI 3.5.1)
- **Captured:** 1/1 shots
- **Failed:** 0

## Evidence Map

| Screenshot | Page | Requirement | Criterion | Status |
|------------|------|-------------|-----------|--------|
| 02-deploy-model-wizard.png | module-02-hands-on.adoc | RHAIBU-M33FK0VDA7NX | REQ-021 — dashboard deployment wizard with "LLM inference service" (MaaS-compatible vLLM path) deployment method selected | captured (CPU cluster — hardware profile shows default-profile 2 CPU/4 GiB; GPU LLMInferenceServiceConfig not present on this cluster) |

## Uncovered Criteria

- REQ-021 GPU-specific deployment resource selection — this cluster is CPU-only; the `vLLM NVIDIA CUDA GPU LLMInferenceServiceConfig` resource is not available here. Re-capture from a GPU cluster when available.
