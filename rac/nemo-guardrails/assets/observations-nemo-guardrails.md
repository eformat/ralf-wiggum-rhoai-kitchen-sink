# Observations: NeMo Guardrails (doc-derived)

## Summary

NeMo Guardrails is the AI safety framework in RHOAI 3.5 that controls LLM input
and output with rails for sensitive data detection, content filtering, and
custom validation rules. The service is deployed through a `NemoGuardrails`
custom resource managed by the TrustyAI Operator and exposes three API
endpoints (`/v1/chat/completions`, `/v1/guardrail/checks`, `/v1/checks`). This
observation document was produced from the official RHOAI 3.5 product
documentation (Enabling AI safety with Guardrails) because no live demo cluster
was available at authoring time. Every item below is doc evidence, not UI
evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | nemo-guardrails-ai-safety.txt | §1.1 Standalone quickstart | Built-in Presidio sensitive data detection + regex pattern matching run entirely inside the NeMo Guardrails pod; no LLM calls or external services; quickstart flow: project → ConfigMap → `NemoGuardrails` CR → wait for `PHASE` `Ready` → `/v1/guardrail/checks` tests (safe/email/person/password/SSN) |
| 2 | nemo-guardrails-ai-safety.txt | §1.2.1–1.2.2 Deployment with an LLM | ServiceAccount + RoleBinding (view ClusterRole) + token secret; `OPENAI_API_KEY` env (from secretKeyRef for real tokens); config `models.engine: openai` with `openai_api_base` predictor URL ending `/v1`; input and output sensitive data detection flows |
| 3 | nemo-guardrails-ai-safety.txt | §1.2.3 Custom rails with Python actions | Colang flow calls a Python action with `execute`; `@action(is_system_action=True)`; example blocks messages over 100 words with `stop` on block |
| 4 | nemo-guardrails-ai-safety.txt | §1.2.4–1.2.6 Self-check + Hugging Face rails | LLM self-check rails via prompt templates; separate task-specific self-check models; `hf_classifier` rail with transformers (in-process) or vLLM (runtime) engines |
| 5 | nemo-guardrails-ai-safety.txt | §1.2.7 CR configuration reference | `NemoGuardrails` (trustyai.opendatahub.io/v1alpha1) parameters: `security.opendatahub.io/enable-auth`, `spec.nemoConfigs[]` (name → `/app/config/<name>` directory, configMaps, default), `spec.replicas` (default 1, min 1), `spec.env`; status fields report MCP Gateway discovery and BBR plugin detection |
| 6 | nemo-guardrails-ai-safety.txt | §1.2.8 OpenTelemetry observability | `tracing.enabled`, `tracing.span_format: opentelemetry`, `tracing.enable_content_capture`; OTEL env on the CR (`OTEL_EXPORTER_OTLP_ENDPOINT`, `OTEL_EXPORTER_OTLP_PROTOCOL`); spans for request, rail flows, LLM calls, custom actions; `enable_content_capture: false` recommended in production |
| 7 | nemo-guardrails-ai-safety.txt | §1.3–1.4 MCP Gateway integration | Guardrails on agent tool calls at the gateway layer via `MCPGatewayExtension` and BBR plugin EnvoyFilter; rails defined once enforced across agent tool calls |
| 8 | nemo-guardrails-ai-safety.txt | §1.5–1.7 Checks + flows + config examples | `/v1/guardrail/checks` validates without generating responses (user → input rails, assistant → output rails, tool → tool_input rails); `/v1/checks` single-turn with transformations (PII anonymization); library flows tables; masking PII instead of blocking (`[MASKED]`) |
| 9 | nemo-guardrails-ai-safety.txt | §2.1 FMS migration | Red Hat is consolidating on NeMo Guardrails; architectural differences in CRs, detection mechanisms, configuration, API endpoints, and deployment topology |

## User Flows

### Flow 1: Standalone quickstart (no LLM)

1. **Prerequisites** — RHOAI installed and logged in; permissions for ConfigMaps and the `NemoGuardrails` CR (§1.1)
2. **Create project** — `oc new-project nemo-quickstart` (§1.1)
3. **Apply configuration ConfigMap** — Presidio entities + regex patterns + input flows (§1.1)
4. **Apply `NemoGuardrails` CR** — `nemoConfigs` + `enable-auth` + `OPENAI_API_KEY` placeholder (§1.1)
5. **Verify** — `PHASE` `Ready`, route exported, `/v1/guardrail/checks` returns `blocked` for email/person/password/SSN content and `success` for safe content (§1.1)

### Flow 2: Front a live model with guardrails

1. **Set up authentication** — ServiceAccount + view RoleBinding + token secret (§1.2.1)
2. **Configure basic deployment** — `models.engine: openai`, predictor URL ending `/v1`, input/output sensitive data flows (§1.2.2)
3. **Verify** — safe prompt through `/v1/chat/completions` returns the LLM answer; email-bearing prompt is blocked before the LLM is called (§1.2.2)
4. **Advanced** — custom Python action rail (§1.2.3), self-check rails (§1.2.4–1.2.5), HF classifiers (§1.2.6), masking instead of blocking (§1.7.2)

### Flow 3: MCP Gateway tool-call enforcement

1. **Verify CRD and BBR plugin EnvoyFilter** in the gateway namespace (§1.4)
2. **Create `NemoGuardrails` CR** with the `mcpGateway` configuration (§1.4)
3. **Verify** — `status.mcpGateway.mcpGatewayFound` and `status.bbrPlugin.bbrPluginFound` both true; operator provisions the `mcp-sse-strip` EnvoyFilter (§1.2.7.1)

## Features and Concepts

### OpenShift Platform
- ConfigMaps, RBAC (ServiceAccount/RoleBinding/token secrets), Routes, deployments and scaling, EnvoyFilters (MCP Gateway integration)

### RHOAI / AI Platform
- TrustyAI Operator and `NemoGuardrails` CRD (trustyai.opendatahub.io/v1alpha1), `nemoConfigs` config mounting to `/app/config/<name>`, route auth annotation, three API endpoints, OpenTelemetry tracing, MCP Gateway enforcement, FMS Guardrails migration path

### AI/ML Fundamentals
- Rail types (input, output, retrieval, tool input), Presidio PII detection, regex pattern matching, LLM self-check guardrails, Hugging Face text classification, prompt injection and jailbreak detection, PII masking vs blocking

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics
- **Estimated duration**: about 2 hours
- **Cluster requirements**: RHOAI 3.5 with the TrustyAI component `Managed` in the DSC; a live model only for the chat-completions exercises

## Open Questions

- Exact predictor URL format (`.../v1`) on a live 3.5 model-serving deployment (doc-derived)
- Whether the LLM self-check and HF classifier rails (documented but out of lab scope) merit an advanced follow-up module
- MCP Gateway integration exercises require an `MCPGatewayExtension` and BBR plugin in the gateway namespace — availability in workshop clusters must be confirmed before Act-phase testing
