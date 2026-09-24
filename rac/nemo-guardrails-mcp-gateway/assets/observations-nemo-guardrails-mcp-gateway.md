# Observations: NeMo Guardrails integration with MCP Gateway (doc-derived)

## Summary

NeMo Guardrails integration with MCP Gateway is RHOAI 3.5's Technology Preview
path for enforcing guardrails on agent tool calls at the gateway layer, so PII
leakage, prompt injection, and content safety violations are blocked before
traffic reaches backend tool servers. This observation document was produced
from the official RHOAI 3.5 Guardrails documentation (Enabling AI safety with
Guardrails) and the Red Hat Connectivity Link 1.4 MCP gateway installation
guide because no live demo cluster was available at authoring time. Every item
below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | nemo-guardrails-ai-safety.txt | §1.3 NeMo Guardrails integration with MCP gateway for agent tool-call enforcement | Architecture and discovery: operator searches `MCPGatewayExtension` resources, resolves `targetRef` to a Kubernetes `Gateway`; BBR plugin detection via the `envoy.filters.http.ext_proc.bbr` sub-filter; auto-provisions the `mcp-sse-strip` EnvoyFilter converting SSE to JSON; two discovery modes (named gateway lookup / zero-config auto-discovery); lifecycle (auto-creation, auto-patching, auto-deletion, 30-second retries) |
| 2 | nemo-guardrails-ai-safety.txt | §1.4 Configure NeMo Guardrails to enforce guardrails on MCP gateway agent tool calls | Prerequisites (TrustyAI `Managed`, `MCPGatewayExtension` CRD, Service Mesh/Istio with `EnvoyFilter` support, `nemo-request-guard`/`nemo-response-guard` BBR plugins); `mcpGateway` field under `spec.template.pod` with `name` + `namespace`; verification via `status.mcpGateway` → `{"mcpGatewayFound":true}`, `status.bbrPlugin` → `{"bbrPluginFound":true}`, `oc get envoyfilters mcp-sse-strip`; troubleshooting error messages |
| 3 | nemo-guardrails-ai-safety.txt | §1.5 Checking content against guardrails without generating responses | `/v1/guardrail/checks` endpoint; message roles map to rails (user→input, assistant→output, tool→tool_input); no LLM required for internal detectors; built-in detectors config (`sensitive_data_detection` entities, `regex_detection` patterns with double-backslash escapes); `OPENAI_API_KEY` env var required, set to any value when using internal detectors only |
| 4 | mcp-gw-install.txt | §1.1–1.3 Install and configure MCP gateway | OLM install (Subscription + OperatorGroup, `preview` channel); Gateway object with listeners (MCP listener port 8080, HTTPS listener with TLS `Terminate`); `Accepted: True` and `Programmed: True` conditions expected |
| 5 | mcp-gw-install.txt | §1.4–1.5 Understand and apply the MCPGatewayExtension CR | `targetRef` (group/kind/name/namespace/sectionName); one `MCPGatewayExtension` per namespace and per Gateway — oldest wins, newer marked conflicted; automatic `mcpgateway-route` HTTPRoute; EnvoyFilter created by the mcpgateway-controller; `Ready` condition with reasons (`ReferenceGrantRequired`, `DeploymentNotReady`, `SecretNotFound`) |
| 6 | mcp-gw-install.txt | §1.6–1.9 ReferenceGrant, DNS, custom HTTPRoute, endpoint verification | `ReferenceGrant` required for cross-namespace Gateway references; custom HTTPRoute requires `httpRouteManagement: Disabled`; curl `initialize` request returns `protocolVersion` and `serverInfo` (`Kuadrant MCP Gateway`) |

## User Flows

### Flow 1: Verify gateway prerequisites and deploy standalone guardrails (§1.4 steps 1–2, §1.5)

1. **Verify extension CRD** — `oc get mcpgatewayextensions -n <gateway_namespace>` lists at least one resource (§1.4)
2. **Verify BBR plugin** — `oc get envoyfilters ... | grep "envoy.filters.http.ext_proc.bbr"` returns output (§1.4)
3. **Deploy standalone service** — ConfigMap with built-in detectors + `NemoGuardrails` CR; `PHASE: Ready` (§1.5)
4. **Test rails** — `/v1/guardrail/checks` with safe content (success) and sensitive content (blocked) (§1.5)

### Flow 2: Wire guardrails into the MCP gateway (§1.4)

1. **Configure `mcpGateway`** — `spec.template.pod.mcpGateway.name` = Gateway name the `MCPGatewayExtension` references; omit `name` for zero-config auto-discovery (§1.4)
2. **Apply the CR** — operator discovers gateway and BBR plugin, provisions `mcp-sse-strip` within ~30 seconds (§1.4)
3. **Verify status** — `{"mcpGatewayFound":true}`, `{"bbrPluginFound":true}`, EnvoyFilter present (§1.4)
4. **Observe lifecycle** — remove `mcpGateway` → filter deleted; re-apply → filter recreated; retries every 30 seconds while prerequisites unavailable (§1.3)

## Features and Concepts

### OpenShift Platform
- Gateway API `Gateway` objects with listeners, `HTTPRoute`, `EnvoyFilter`, `ReferenceGrant`, RBAC (`nemo-guardrails-manager-role` ClusterRole with read-only `mcpgatewayextensions`/`gateways` access and full CRUD on `envoyfilters`)

### RHOAI / AI Platform
- `NemoGuardrails` CR (`trustyai.opendatahub.io/v1alpha1`), `mcpGateway` field, `status.mcpGateway`/`status.bbrPlugin` fields, `mcp-sse-strip` EnvoyFilter, TrustyAI operator reconciliation, `MCPGatewayExtension` CR (`mcp.kuadrant.io/v1alpha1`), `mCPGuardrailsOnlyMode=True` standalone mode

### AI/ML Fundamentals
- Guardrail rails keyed by message role (input/output/tool_input), PII leakage, prompt injection, content safety violations, Model Context Protocol (MCP) tool calls, server-sent events (SSE) vs JSON processing

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and AI practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: `oc` CLI basics, gateway/Istio concepts
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with TrustyAI `Managed`; facilitator-deployed MCP gateway with `MCPGatewayExtension` and BBR plugins in the gateway namespace

## Open Questions

- Exact CR status JSON shape on a live console (doc-derived jsonpath output)
- BBR plugin EnvoyFilter availability in workshop clusters (module 01 prerequisite)
- Zero-config auto-discovery behavior in a namespace with multiple `MCPGatewayExtension` resources (docs: the first one found is used)
