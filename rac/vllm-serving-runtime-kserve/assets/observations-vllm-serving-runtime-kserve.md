# Observations: vLLM ServingRuntime for KServe (doc-derived)

## Summary

The vLLM ServingRuntime for KServe is RHOAI 3.5's GA runtime for serving
generative AI models on the single-model serving platform. A `ServingRuntime`
CR defines the pod template (container image, vLLM OpenAI API server
entrypoint, ports, supported model formats); deploying through the wizard
generates an `InferenceService` (serving.kserve.io/v1beta1) that mounts the
model and exposes an OpenAI-compatible REST API over the OpenShift router's
HTTPS port. This observation document was produced from the official RHOAI 3.5
product documentation (Deploying models; Configuring your model-serving
platform) because no live demo cluster was available at authoring time. Every
item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | deploying-models.txt | §2.2 Automatic selection of serving runtimes | System matches model type, model format, and hardware profile; Auto-select shown only for a single distinct match; manual selection lists global and project-scoped runtime templates |
| 2 | deploying-models.txt | §2.3 Serving runtime badges | Badge combos map to support levels: Pre-installed + Version = full GA support; Pre-installed + Limited support + Version + Fast-N = 1-month limited support; no Pre-installed label = user-created custom |
| 3 | deploying-models.txt | §6.1–6.3 Token, endpoint, inference requests | Token from the deployment's *Token authentication* section; `/v1/chat/completions` with `Authorization: Bearer`; 401/403 signals missing or expired token |
| 4 | deploying-models.txt | §6.4.3 vLLM NVIDIA GPU ServingRuntime for KServe | OpenAI REST API compatible; as of vLLM v0.5.5 a chat template is required for `/v1/chat/completions`; embeddings endpoint only works with embeddings models |
| 5 | configuring-model-serving-platform.txt | §1.2 Model-serving runtimes | `ServingRuntime` CRD creates the runtime environment: pod templates that load/unload models and expose a service endpoint; `InferenceService` is the deployment CR |
| 6 | configuring-model-serving-platform.txt | §1.2.1 vLLM ServingRuntime YAML | `vllm-runtime` in `redhat-ods-applications`: `quay.io/modh/vllm` image, `python -m vllm.entrypoints.openai.api_server`, `--model=/mnt/models`, port 8080, `multiModel: false`, `supportedModelFormats: vLLM` with `autoSelect: true` |
| 7 | configuring-model-serving-platform.txt | §1.3 vLLM runtime support levels | Three levels: supported (GA), limited support (fast builds from `registry.redhat.io/rhaii-early-access`), unsupported (custom); identified by dashboard badge combinations |
| 8 | configuring-model-serving-platform.txt | §3.3 Customize the vLLM model-serving runtime | Deployment-time runtime arguments: n-gram speculative decoding (`--speculative-model=[ngram]`), draft-model decoding, multi-modal `--trust-remote-code` |

## User Flows

### Flow 1: Enable the platform and the runtime

1. **Enable model serving platform** — Settings → Cluster settings → General settings → Model serving platform checkbox (§2.9, deploying-models)
2. **Enable vLLM ServingRuntime for KServe** — Settings → Model resources and operations → Serving runtimes (§1.2, configuring-model-serving-platform)
3. **Verify** — `oc get servingruntimes -n redhat-ods-applications` lists the vLLM runtime

### Flow 2: Deploy and query a generative AI model

1. **Open the Deploy model wizard** — Projects → project → Deployments → Deploy model (§2.9, deploying-models)
2. **Configure model location and type** — S3 connection + Generative AI model (§2.9)
3. **Select hardware profile, runtime, replicas** — NVIDIA GPU hardware profile + vLLM ServingRuntime for KServe; automatic selection filters runtimes by accelerator (§2.2)
4. **Enable external route + token authentication** — token generated for a service account (§6.1)
5. **Verify deployment** — `oc get inferenceservice -n {project}` shows `READY: True`; generated CR mirrors wizard choices (§2.9)
6. **Query** — `/v1/models`, `/v1/chat/completions` with bearer token; OpenAI-compatible 200 with a `choices` array (§6.3–6.4)

## Features and Concepts

### OpenShift Platform
- Routes with HTTPS passthrough, Istio sidecar injection, RBAC (service account token authentication), NVIDIA GPU hardware profiles with Node Feature Discovery Operator

### RHOAI / AI Platform
- Single-model serving platform (KServe), `ServingRuntime` (serving.kserve.io/v1alpha1) and `InferenceService` (serving.kserve.io/v1beta1) CRDs, preinstalled runtimes in `redhat-ods-applications`, runtime support levels with badge gating, accelerator-specific runtime variants (NVIDIA, Gaudi, AMD, IBM Spyre)

### AI/ML Fundamentals
- vLLM inference engine, OpenAI-compatible REST API (`/v1/models`, `/v1/chat/completions`, `/v1/completions`, `/v1/embeddings`), chat templates, speculative decoding, embeddings vs generative models

## Workshop Potential

- **Estimated modules**: 2 (enable → deploy and query)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics, S3 model storage
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with KServe enabled, NVIDIA GPU support, S3-compatible model connection

## Open Questions

- Exact `Settings → Model resources and operations → Serving runtimes` menu label on a live console (doc-derived path)
- Availability of an S3-hosted gen AI model (for example, `granite-7b-instruct`) and GPU capacity in workshop clusters (module 02 prerequisite)
