# Observations: Multi-provider API passthrough for external models (doc-derived)

## Summary

Multi-provider API passthrough is RHOAI 3.5's Technology Preview capability for
routing inference requests through the MaaS gateway in native provider formats
(Anthropic Messages, OpenAI Responses) without translation, preserving
provider-specific features that format conversion would strip. This observation
document was produced from the official RHOAI 3.5 product documentation
(Govern LLM access with Models-as-a-Service — external models and passthrough
chapters) because no live demo cluster was available at authoring time. Every
item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | maas-core-govern-llm.txt | §1.21.2 Multi-provider API passthrough for external models | Technology Preview only; passthrough activates when the client API format matches the `apiFormat` on the `ExternalModel`; `openai-chat` always uses translation |
| 2 | maas-core-govern-llm.txt | §1.21.2.1 When to use passthrough | Anthropic SDK/Claude Code users set `apiFormat: messages` (preserves prompt caching, extended thinking, beta flags); OpenAI Responses users set `openai-responses`; Vertex AI with Anthropic SDK clients route via `messages`; OpenAI-format-only deployments unaffected |
| 3 | maas-core-govern-llm.txt | §1.21.3.1 Format detection | Gateway detects format from request path suffix: `/v1/chat/completions` → `openai-chat`, `/v1/messages` → `messages`, `/v1/responses` → `openai-responses`; unrecognized path returns 400 |
| 4 | maas-core-govern-llm.txt | §1.21.3.2–1.21.3.3 apiFormat values and decision matrix | Only two passthrough-eligible combinations: `messages` → `messages` and `openai-responses` → `openai-responses`; `vertex-messages` uses minimal translation; other combinations return 400 Bad Request |
| 5 | maas-core-govern-llm.txt | §1.21.3.4–1.21.3.5 Authentication headers and auth types | Provider type maps to header: `anthropic` → `x-api-key`, `openai` → `Authorization: Bearer`, `azure` → `api-key`; `auth.type` values: `apikey`, `sigv4` (Bedrock), `oauth2` (Vertex) |
| 6 | maas-core-govern-llm.txt | §1.21.4 Configure routing to external model providers | Two-resource architecture: `ExternalProvider` (endpoint + credentials) and `ExternalModel` (client-facing name + `externalProviderRefs` with `targetModel`, `apiFormat`, `path`, `weight`); controller auto-creates `Service`, `ServiceEntry`, `DestinationRule` for the provider and an `HTTPRoute` for the model; `MaaSModelRef` publishes to MaaS |
| 7 | maas-core-govern-llm.txt | §1.21.3.7 Body-based model routing | Pre-auth ext_proc filter extracts model name from request body into `X-Gateway-Model-Name`; matched against `spec.modelName` if set, otherwise `metadata.name`; enabled by default |
| 8 | maas-core-govern-llm.txt | §1.21.5 Use single-URL passthrough with AI coding tools | Claude Code: `ANTHROPIC_BASE_URL` + `ANTHROPIC_API_KEY` against one gateway URL; OpenAI Responses tools: `OPENAI_BASE_URL`/`OPENAI_API_KEY` with `/v1/responses`; tools switch models mid-session via the request body |
| 9 | maas-core-govern-llm.txt | §1.21.3.8 Limitations | Subscription-level token rate limits meter only OpenAI Chat Completions (`usage.total_tokens`); streaming buffered during cross-format translation; >16 KB body truncation with Kuadrant wasm shim (resolved in OSSM 3.3.1+); NeMo Guardrails response guards skip non-OpenAI formats; unmatched model names are not rejected immediately |

## User Flows

### Flow 1: Configure an external model with passthrough (administrator)

1. **Verify prerequisites** — cluster admin, RHOAI installed, MaaS deployed, at least one MaaS subscription, provider API key (§1.21.4 prerequisites)
2. **Create model namespace and secret** — `oc create secret generic` with `api-key` literal + `inference.llm-d.ai/ipp-managed=true` label (§1.21.4 step 1)
3. **Create ExternalProvider** — provider type, endpoint FQDN, `auth.type: apikey` with `secretRef`; verify `PHASE: Ready` (§1.21.4 step 2)
4. **Create ExternalModel** — `externalProviderRefs` with `targetModel`, `apiFormat: messages`, `path: /v1/messages`, `weight: 100`; controller auto-creates `HTTPRoute` (§1.21.4 step 3)
5. **Publish and govern** — `MaaSModelRef` in the same namespace; add to subscription; verify in the *External models* tab (§1.21.4 step 4)

### Flow 2: Test passthrough and single-URL access (user)

1. **Obtain endpoint and MaaS API key** — Gen AI studio → AI asset endpoints → *Create API key* (§1.21.5)
2. **Send native Anthropic Messages request** — `curl` to `/v1/messages` with `x-api-key` and `anthropic-version` headers; verify `content` array + `stop_reason: end_turn` response shape, no `choices` field (§1.21.5 verification)
3. **Configure single-URL access** — `ANTHROPIC_BASE_URL` = MaaS gateway URL; gateway resolves model from request body `model` field; switch models by changing the model name (§1.21.5)

## Features and Concepts

### OpenShift Platform
- Kubernetes secrets with managed labels, RBAC-governed MaaS subscriptions, Istio networking (`ServiceEntry`, `DestinationRule`, `HTTPRoute`) auto-created by the controllers

### RHOAI / AI Platform
- `ExternalProvider`, `ExternalModel`, `MaaSModelRef` CRs (inference.opendatahub.io / maas.opendatahub.io groups), MaaS gateway with format detection, body-based model routing via `X-Gateway-Model-Name`, *External models* tab (`spec.dashboardConfig.externalModels: true`), two-tier authentication (MaaS API key for users, provider API key injected by the gateway), token limits at subscription and provider levels

### AI/ML Fundamentals
- Provider API formats (OpenAI Chat Completions, Anthropic Messages, OpenAI Responses), translation vs passthrough trade-offs, provider-specific features preserved by passthrough (prompt caching, extended thinking, beta flags), cross-format streaming buffering

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: cluster administrators with OpenShift working knowledge
- **Prerequisite knowledge**: MaaS governance basics, `oc` CLI basics, provider API concepts
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with Models-as-a-Service deployed, at least one MaaS subscription, a valid external provider API key

## Open Questions

- Exact *External models* tab layout and provider-details sub-table on a live console (doc-derived; requires `spec.dashboardConfig.externalModels: true`)
- `maas-api` pod naming and `redhat-ai-gateway-infra` namespace on a live cluster (doc-derived defaults)
- Cluster-wide x-api-key enablement behavior when any `ExternalModel` has `apiFormat: messages` — confirm 401 semantics for existing Anthropic clients after deletion
