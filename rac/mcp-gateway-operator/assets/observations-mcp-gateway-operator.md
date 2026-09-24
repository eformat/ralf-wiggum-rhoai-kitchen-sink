# Observations: MCP gateway Operator (doc-derived)

## Summary

The MCP gateway Operator is the Red Hat Connectivity Link 1.4 feature (RHOAI
3.5, Technology Preview) that centralizes and manages connectivity for agentic
AI applications accessing Model Context Protocol (MCP) servers: it gathers
backend MCP servers behind a single endpoint and secures them like RESTful
APIs. This observation document was produced from the official Connectivity
Link 1.4 product documentation (MCP gateway; Install the MCP gateway; Register
on-premise MCP servers) because no live demo cluster was available at authoring
time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | mcp-gw-gateway.txt | §1.1–1.2 About the MCP gateway / Architecture | TP-only feature; extends the Envoy proxy (conformance-tested Kubernetes Gateway API implementation) with router, broker, and discovery controller; Istio as the gateway control plane; Connectivity Link for policies (AuthPolicy, rate-limiting) |
| 2 | mcp-gw-gateway.txt | §1.2.1 Architectural components | Router parses the JSON-RPC request object and sets `:authority`, `:path`, `x-mcp-method`, `x-mcp-servername`, `x-mcp-toolname`, `mcp-session-id` headers; broker presents a unified MCP server at `/mcp` and validates minimum protocol version/capabilities; controller watches `MCPServerRegistration` and `HTTPRoute` CRs and reports registration status |
| 3 | mcp-gw-install.txt | §1.1–1.3 Install with OLM / Gateway / listeners | Operator installs from OLM with `channel: preview`; Gateway object with an MCP listener is the security perimeter; listener is referenced by `MCPGatewayExtension` `spec.targetRef.sectionName`; DNSPolicy can map hostnames to the Gateway |
| 4 | mcp-gw-install.txt | §1.4–1.6 MCPGatewayExtension / ReferenceGrant | One `MCPGatewayExtension` per namespace and per Gateway object; auto-creates an HTTPRoute (`mcp-gateway-route`) and an EnvoyFilter; cross-namespace references require a ReferenceGrant (status reason `ReferenceGrantRequired`); verify endpoint with a `curl` `initialize` POST returning `Kuadrant MCP Gateway` serverInfo |
| 5 | mcp-gw-register.txt | §1.1–1.3 Server registration | `MCPServerRegistration` CR references an HTTPRoute and prefixes all tools/prompts from the server; prefix accepts only lowercase letters, digits, underscores, must start with a letter or digit, and is immutable (delete and re-create to fix); `oc get mcpsr` reports READY/TOOLS/CREDENTIALS status |
| 6 | mcp-gw-register.txt | §2.1–2.7 External MCP servers | External servers register via ServiceEntry (Istio registry), DestinationRule (TLS), HTTPRoute with URLRewrite, Secret, and AuthPolicy (passes through the Authorization header) before the `MCPServerRegistration` |
| 7 | mcp-gw-register.txt | §3.1–3.5 Virtual MCP servers | `MCPVirtualServer` CR curates tools/prompts; accessed with the `X-Mcp-Virtualserver` header in `namespace/name` format; filtering changes discovery (`tools/list`, `prompts/list`) but not call routing or authorization |
| 8 | mcp-gw-register.txt | §4 Authentication | AuthPolicy with an identity provider (Red Hat build of Keycloak) validates JWTs on the `mcp` listener and returns 401 with OAuth discovery information; a second AuthPolicy with CEL expressions authorizes which users can call which tools |

## User Flows

### Flow 1: Install and expose the gateway

1. **Install Operator** — OLM Subscription (`preview` channel) + OperatorGroup (§install 1.1)
2. **Create Gateway** — Gateway object with `http` and `mcp` listeners (§install 1.2–1.3)
3. **Extend with MCP support** — ReferenceGrant (cross-namespace) + `MCPGatewayExtension` targeting the Gateway's `mcp` listener (§install 1.4–1.6)
4. **Verify** — auto-created HTTPRoute, EnvoyFilter, and a `curl` `initialize` request through the gateway (§install 1.9)

### Flow 2: Register and curate backend MCP servers

1. **Route to backend** — HTTPRoute from the Gateway to the backend MCP server (§register 1.2)
2. **Register** — `MCPServerRegistration` with prefix, `targetRef` to the route, optional `credentialRef` (§register 1.2)
3. **Verify discovery** — `oc get mcpsr` READY/TOOLS; session `initialize`, `tools/list`, `prompts/list` with prefixed names (§register 1.3)
4. **Curate** — `MCPVirtualServer` + `X-Mcp-Virtualserver` header filters discovery only (§register 3.3–3.4)
5. **Secure (going further)** — AuthPolicy with Keycloak JWTs returns 401 with OAuth discovery (§register 4)

## Features and Concepts

### OpenShift Platform
- Gateway API (Gateway, HTTPRoute, ReferenceGrant), Envoy proxy, Istio control plane, OLM (Subscription/OperatorGroup/CSV), Secrets for backend credentials

### RHOAI / AI Platform
- MCP gateway Operator (Connectivity Link), `MCPGatewayExtension`, `MCPServerRegistration`, `MCPVirtualServer` CRs (`mcp.kuadrant.io/v1alpha1`), MCP discovery controller, DNSPolicy for hostname mapping

### AI/ML Fundamentals
- Model Context Protocol (JSON-RPC, sessions, tools/prompts discovery), agentic AI clients, tool-name prefixing to avoid collisions across servers

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and AI application teams with OpenShift + Gateway API working knowledge
- **Prerequisite knowledge**: RHOAI operator installed, MCP Lifecycle Operator enabled, Connectivity Link 1.4.1+
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with Connectivity Link 1.4.1+ and a backend MCP server serving `/mcp`

## Open Questions

- Backend MCP server availability in workshop clusters (module 02 prerequisite)
- Listener hostname resolution strategy in the workshop environment (doc-derived: `/etc/hosts` workaround or DNSPolicy/ExternalDNS automation)
