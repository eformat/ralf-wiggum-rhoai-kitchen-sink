# Observations: vLLM Deployment on MaaS (doc-derived)

## Summary

vLLM deployment on MaaS is RHOAI 3.5's Technology Preview path for serving
vLLM-based models behind the shared Models-as-a-Service governance layer. This
observation document was produced from the official RHOAI 3.5 product
documentation (Govern LLM access with Models-as-a-Service; Deploying models)
because no live demo cluster was available at authoring time. Every item below
is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | maas-core-govern-llm.txt | §1 MaaS capabilities | Subscription-based quota management, self-service API key management, OpenAI API compatibility (`/v1/chat/completions` with body-based model routing), multi-runtime support (llm-d or vLLM; vLLM is Technology Preview), usage tracking/observability dashboard (TP), external model passthrough |
| 2 | maas-core-govern-llm.txt | §1.2 Platform and Operator prerequisites | OpenShift 4.19.9+, RHOAI 3.4+, llm-d distributed inference with authentication enabled, Connectivity Link Operator 1.4.x with a ready Kuadrant CR in `kuadrant-system`, and `spec.dashboardConfig.vLLMDeploymentOnMaaS: true` for vLLM runtime (TP) |
| 3 | maas-core-govern-llm.txt | §1.1 MaaS custom resources | AITenant, MaasTenantConfig, MaaSModelRef, MaaSSubscription, MaaSAuthPolicy, ExternalProvider/ExternalModel; Tenant CR deprecated |
| 4 | maas-core-govern-llm.txt | §1.6 API keys | API keys retain a snapshot of group memberships at creation; revocation is per-key; keys can be permanent or expiring |
| 5 | maas-core-govern-llm.txt | §1.4 Subscriptions and authorization policies | Both are required for access; a subscription without an auth policy yields `403 Forbidden`, an auth policy without a subscription yields `429 Too Many Requests`; subscriptions live in `models-as-a-service` |
| 6 | maas-core-govern-llm.txt | Infrastructure namespace | In 3.5 the default infrastructure namespace is `redhat-aigateway-infra`; resolve per deployment via `oc get maastenantconfig ... -o jsonpath='{.status.infraNamespace}'` |
| 7 | rhai-deploying-models.txt | §1 Deploy wizard (vLLMDeploymentOnMaaS enabled) | Wizard flow: Projects → Deployments → Deploy model → model path + `Generative AI model (Example, LLM)` → legacy method unchecked → deployment name, hardware profile, deployment resource (`vLLM NVIDIA CUDA GPU LLMInferenceServiceConfig` for vLLM serving as TP) → Advanced: `Publish as MaaS`; publishing creates a `MaaSModelRef` |

## User Flows

### Flow 1: Enable the vLLM feature flag and verify the platform

1. **Check flags** — `oc get odhdashboardconfig` for `modelAsService` and `vLLMDeploymentOnMaaS`
2. **Patch** — merge patch sets both to `true` (§1.2 prerequisite, TP)
3. **Verify platform** — DSC `kserve` and `modelsAsService` both `Managed`; `maas-default-gateway` in `openshift-ingress`; `maas-controller` pods running in the `infraNamespace` resolved from `maastenantconfig`

### Flow 2: Deploy a vLLM model and publish it to MaaS

1. **Wizard** — Projects → Deployments → Deploy model; storage connection + model path; `Generative AI model (Example, LLM)`; legacy method unchecked (§ wizard, deploying-models)
2. **Deployment resource** — `vLLM NVIDIA CUDA GPU LLMInferenceServiceConfig` (Technology Preview)
3. **Publish as MaaS** — creates a `MaaSModelRef` registering the model for subscription assignment
4. **Verify** — Deployments tab checkmark, `oc get maasmodelref`, `LLMInferenceService` `READY: True`

### Flow 3: Govern access and call the endpoint

1. **Group** — `oc adm groups new {guid}-model-users {user}` (cluster admin)
2. **Subscription** — `MaaSSubscription` in `models-as-a-service` with `owner.groups`, `modelRefs` matching the `MaaSModelRef`, and `tokenRateLimits`
3. **Auth policy** — `MaaSAuthPolicy` with the same `modelRefs` and `subjects.groups`
4. **Controller policies** — MaaS controller generates per-model `AuthPolicy` and `TokenRateLimitPolicy` in the model's project namespace
5. **API key** — created in the dashboard (Gen AI studio → API keys), bound to the subscription
6. **Verify** — curl with `Authorization: Bearer %api-key%` to `/llm/<deployment>/v1/chat/completions` returns HTTP 200 in OpenAI-compatible format; invalid key returns `401`/`403`

## Features and Concepts

### OpenShift Platform
- Gateways (`maas-default-gateway` in `openshift-ingress`), routes, ingress controller with TLS, RBAC (groups, ServiceAccounts), `oc` CLI

### RHOAI / AI Platform
- MaaS governance layer (subscriptions, quotas, API keys, authorization policies), `MaaSModelRef`/`MaaSSubscription`/`MaaSAuthPolicy` CRs (maas.opendatahub.io/v1alpha1), `maastenantconfig`/`AITenant` tenancy, `OdhDashboardConfig` feature flags, model deployment wizard, Gen AI studio API keys and AI asset endpoints

### AI/ML Fundamentals
- vLLM serving runtime, LLMInferenceService architecture, token rate limits and token-based quota, OpenAI-compatible chat completions API, model path vs. model deployment naming

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics
- **Estimated duration**: 45–90 minutes
- **Cluster requirements**: RHOAI 3.5 with MaaS prerequisites installed (Connectivity Link Operator 1.4.x, ready Kuadrant CR, llm-d authentication) and a hardware profile with at least one NVIDIA GPU

## Open Questions

- Exact `Gen AI studio → API keys` and `AI asset endpoints` menu labels on a live console (doc-derived path)
- Default infrastructure namespace (`redhat-aigateway-infra`) must be confirmed via the `maastenantconfig` lookup on the workshop cluster
- Playground testing token consumption from the subscription limit — confirm UX in the Act phase
