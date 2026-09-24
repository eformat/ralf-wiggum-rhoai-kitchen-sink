# Observations: MaaS Deployment/Routing Path for Distributed Inference with llm-d (doc-derived)

## Summary

The MaaS deployment/routing path for Distributed Inference with llm-d is a
RHOAI 3.5 Technology Preview feature that joins two capabilities: models
deployed through the llm-d distributed inference path (`LLMInferenceService`
architecture, `openshift-ai-inference` Gateway) and published for
subscription-based governance through Models-as-a-Service (MaaS). This
observation document was produced from the official RHOAI 3.5 product
documentation (Deploy and manage Models-as-a-Service; Deploy models using
Distributed Inference with llm-d) because no live demo cluster was available at
authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | maas-core-govern-llm.txt | §1.1 Configure Models-as-a-Service | Subscription-based governance for LLM serving; subscriptions replaced the 3.3 tier model; capabilities: quota management, self-service API keys, OpenAI API compatibility, multi-runtime support (llm-d or vLLM), external models and observability dashboard are Technology Preview |
| 2 | maas-core-govern-llm.txt | §1.17.2 MaaS custom resource workflow | Publish order: MaaSModelRef (references deployed inference server) → MaaSSubscription (groups + token quota) → MaaSAuthPolicy (gateway access) |
| 3 | maas-core-govern-llm.txt | §1.17.1 API structure | Management API at `/maas-api/v1`; inference via body-based routing on `/v1/chat/completions` (recommended) or legacy path-based `/llm/<model-name>/v1`; API keys carry the `sk-oai-` prefix |
| 4 | maas-core-govern-llm.txt | §1.15–1.16 Enable + API keys | `spec.components.kserve.modelsAsService.managementState` to `Managed`; default infrastructure namespace in 3.5 is `redhat-aigateway-infra`; five `maas.opendatahub.io` CRDs plus `tenants`; temporary API keys shown once, expire (default 1 hour) |
| 5 | maas-core-govern-llm.txt | §2.2–2.3 User access errors | Subscription without auth policy → `403 Forbidden`; auth policy without subscription → `429 Too Many Requests`; invalid key → `401 Unauthorized`; gateway URL derived as `maas.$(oc get ingresses.config.openshift.io cluster -o jsonpath='{.spec.domain}')` |
| 6 | llmd-deploy-distributed-inference.txt | §1.1 Enable Distributed Inference | Deploy with `LLMInferenceService` instead of default InferenceService; requires GatewayClass + Gateway named `openshift-ai-inference` in `openshift-ingress`, OpenShift 4.19.9+, no OpenShift Service Mesh v2; bare-metal needs an external entry point (Gateway defaults to `type: LoadBalancer`) |
| 7 | llmd-deploy-distributed-inference.txt | §2.1–2.7 Unified serving + wizard | Single *Deploy model* entry point for all generative AI models; wizard topology selector deploys with validated templates; *Publish as MaaS* under Model availability creates a `MaaSModelRef` |
| 8 | llmd-deploy-distributed-inference.txt | §3.3 Select a gateway in the wizard | Gateway Selection field in the wizard does not support MaaS Gateways — the MaaS gateway fronting governed traffic is distinct from wizard-level gateway selection |

## User Flows

### Flow 1: Deploy a model through the llm-d path and publish it as MaaS

1. **Enable prerequisites** — `modelsAsService` managementState `Managed` (maas-core §1.15); `openshift-ai-inference` GatewayClass + Gateway (llmd §1.1); `default-tenant` Tenant `Ready`
2. **Open wizard** — Projects → project → Deployments → Deploy model (llmd §2.7)
3. **Deploy with llm-d runtime** — select *Distributed inference with llm-d* as the deployment resource; leave *Use legacy deployment method* unchecked
4. **Publish as MaaS** — Model availability → *Publish as MaaS*; a `MaaSModelRef` registers the model for subscription assignment (llmd §2.7)
5. **Verify** — `oc get maasmodelref` and `oc get llminferenceservice` (gateway ref under `spec.router.gateway`)

### Flow 2: Govern and consume the model through the MaaS gateway

1. **Grant quota** — apply `MaaSSubscription` with owner groups, model refs, `tokenRateLimits` (maas-core §1.17.2)
2. **Grant access** — apply `MaaSAuthPolicy` with model refs and subject groups; the MaaS controller generates `AuthPolicy` + `TokenRateLimitPolicy` per model
3. **Generate API key** — *Gen AI studio → AI asset endpoints* → View endpoints → select subscription → *Generate API key* (shown once, expires after 1 hour)
4. **Consume** — `GET ${MAAS_URL}/v1/models` then body-based `POST /v1/chat/completions` with the `model` field; OpenAI-compatible JSON responses
5. **Negative tests** — rapid requests mix `200` and `429` when the token limit is low; invalid key returns `401 Unauthorized` or `403 Forbidden` (maas-core §2.2–2.3)

## Features and Concepts

### OpenShift Platform
- Gateway API (GatewayClass + Gateway `openshift-ai-inference` in `openshift-ingress`), routes/ingress domain, RBAC groups

### RHOAI / AI Platform
- Models-as-a-Service governance layer: `MaaSModelRef`, `MaaSSubscription`, `MaaSAuthPolicy`, `MaaSTenantConfig` CRs; `maas.opendatahub.io` API group; MaaS controller in `redhat-aigateway-infra`
- Distributed Inference with llm-d: `LLMInferenceService` (serving.kserve.io), `spec.router.gateway`, topology/router configuration templates
- Intersection: *Publish as MaaS* bridges the llm-d serving path into MaaS governance; wizard Gateway Selection does not support MaaS Gateways

### AI/ML Fundamentals
- LLM serving topologies, token rate limiting per subscription window, OpenAI-compatible chat completions API

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics
- **Estimated duration**: 45–90 minutes
- **Cluster requirements**: RHOAI 3.5 with MaaS (`kserve.modelsAsService: Managed`) and Distributed Inference (llm-d) enabled; `default-tenant` `Ready` (User Workload Monitoring)
- **Maturity**: Technology Preview — APIs and manifests may change between releases

## Open Questions

- Confirm the *Gen AI studio → AI asset endpoints* endpoint dialog and *API keys* menu labels on a live 3.5 console (doc-derived paths)
- Confirm `maas.{ingress-domain}` gateway URL resolution and `redhat-aigateway-infra` namespace in workshop clusters
- Whether the workshop cluster's subscription token limits are low enough to trigger the `429` rate-limit test
