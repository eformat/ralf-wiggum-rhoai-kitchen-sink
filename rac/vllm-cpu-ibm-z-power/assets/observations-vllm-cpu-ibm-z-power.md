# Observations: vLLM CPU ServingRuntime on IBM Z / Power (doc-derived)

## Summary

The vLLM CPU ServingRuntime for KServe is RHOAI 3.5's supported path for serving
models with vLLM on IBM Power (ppc64le) and IBM Z (s390x) clusters. This
observation document was produced from the official RHOAI 3.5 product
documentation and the Red Hat supported-configurations article (extracted text)
because no live demo cluster was available at authoring time. Every item below
is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | supported-configs-3x.txt | Supported OpenShift configurations | RHOAI Self-Managed is supported on x86_64, ppc64le, s390x, and aarch64 architectures; IBM Power and IBM Z are explicitly listed deployment topologies |
| 2 | supported-configs-3x.txt | Pre-installed model-serving runtimes | vLLM CPU ServingRuntime for KServe described as "a high-throughput and memory-efficient inference and serving runtime that supports IBM Power (ppc64le) and IBM Z (s390x)" |
| 3 | supported-configs-3x.txt | Tested and verified model-serving runtimes (footnote 1) | For vLLM CPU ServingRuntime for KServe on IBM Z and IBM Power, models can only be deployed in standard deployment mode |
| 4 | deploying-models.txt | §6.4 Serving runtimes | "To use the VLLM runtime on IBM Z and IBM Power, use the vLLM CPU ServingRuntime for KServe. You cannot use GPU accelerators with IBM Z and IBM Power architectures." |
| 5 | deploying-models.txt | §2.1 Model deployment wizard | Wizard flow: model location and type → deployment name, hardware profile, serving runtime selection, replicas → advanced settings (external routes, token authentication, deployment strategy) |
| 6 | deploying-models.txt | Chat template note | As of vLLM v0.5.5, a chat template is required for `/v1/chat/completions` queries; the `--chat-template` parameter can be added via custom runtime arguments |
| 7 | supported-product-hardware.txt | Table 3.9 vllm-cpu-rhel9 CPU configurations | Supported x86_64 CPU configurations for the Red Hat AI Inference vLLM CPU image: vLLM v0.24.0, Intel Xeon/AMD EPYC with AVX2 minimum, Python 3.12 |

## User Flows

### Flow 1: Deploy a model on IBM Z / Power from the dashboard

1. **Verify architecture** — `oc get nodes` shows `s390x` or `ppc64le` (§6.4)
2. **Open wizard** — Projects → project → Deployments → Deploy model (§2.1)
3. **Configure model** — model location (OCI registry, S3, URI, PVC) + Generative AI model type (§2.1)
4. **Select runtime and size** — hardware profile, vLLM CPU ServingRuntime, CPU/Memory requests and limits (no GPU requests possible) (§2.1, §6.4)
5. **Enable access** — Model access external route + Require token authentication (§2.1)

### Flow 2: Serve authenticated inference

1. **Verify deployment** — InferenceService ready condition + predictor pod running
2. **Retrieve token** — dashboard *Token secret* field or service account secret
3. **List models** — `GET /v1/models` with `Authorization: Bearer` header
4. **Chat completion** — `POST /v1/chat/completions` over the OpenShift router HTTPS port (usually 443); chat template required as of vLLM v0.5.5
5. **Negative test** — unauthenticated request returns `401 Unauthorized`

## Features and Concepts

### OpenShift Platform
- Multi-architecture support (ppc64le, s390x), KServe deployment modes (Knative Serverless default vs KServe RawDeployment standard), routes, service accounts and tokens

### RHOAI / AI Platform
- Pre-installed vLLM CPU ServingRuntime for KServe in `redhat-ods-applications`, *Deploy a model* wizard, hardware profiles, serving runtime badges (Pre-installed, Version, Fast-N, Limited support)

### AI/ML Fundamentals
- CPU-only LLM inference (no GPU accelerators on IBM Z/Power), OpenAI-compatible REST API, chat templates, high-throughput memory-efficient serving

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and ML practitioners working on IBM Z or IBM Power clusters
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: OpenShift on IBM Z (s390x) or IBM Power (ppc64le) with RHOAI 3.5, model serving platform enabled, vLLM CPU runtime enabled

## Open Questions

- Supported model list for the vLLM CPU ServingRuntime: the upstream vLLM supported-models link is documented as confusing for Red Hat customers; a validated-models reference for CPU architectures is not identified in the extracted docs
- Exact pre-installed runtime resource name on a live 3.5 cluster (docs note names can vary between releases)
