# Observations: MCP Lifecycle Operator (doc-derived)

## Summary

The MCP Lifecycle Operator feature in RHOAI 3.5 is delivered through the
Connectivity Link MCP gateway stack: an MCP gateway deployment Operator
installed with OLM, Gateway API resources (Gateway with MCP listener,
`MCPGatewayExtension`), and lifecycle CRs (`MCPServerRegistration`,
`MCPVirtualServer`) for registering and curating backend MCP servers. This
observation document was produced from the official Red Hat Connectivity Link
1.4 documentation (Install the MCP gateway; Register MCP servers and create
policies) because no live demo cluster was available at authoring time. Every
item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | mcp-lifecycle-install-gateway.txt | §1.1 Install the MCP gateway with OLM | OLM install via `Subscription` (`redhat-operators`, `channel: preview`) + `OperatorGroup`; installplan wait commands; CSV phase `Succeeded` verification; Connectivity Link 1.4.0 deprecated, 1.4.1+ required; MCP gateway is Technology Preview only |
| 2 | mcp-lifecycle-install-gateway.txt | §1.2–1.3 Gateway object and listeners | Gateway with `gatewayClassName: openshift-default`; `http` listener (port 80), `mcps` MCP listener (port 8080), optional `https` listener with `tls.certificateRefs`; `Accepted: True` and `Programmed: True` expected in status; Events reveal port conflicts, bad `gatewayClassName`, missing routes/secrets |
| 3 | mcp-lifecycle-install-gateway.txt | §1.4–1.5 MCPGatewayExtension CR | One extension per namespace and per Gateway; oldest CR wins on conflict; automatic `mcp-gateway-route` HTTPRoute to the broker on port 8080; Envoy filter with `app.kubernetes.io/managed-by=mcpgateway-controller`; `Ready` condition reasons (`InvalidMCPGatewayExtension`, `ReferenceGrantRequired`, `DeploymentNotReady`, `SecretNotFound`, `SecretInvalid`); API fields: `httpRouteManagement`, `publicHost`, `privateHost`, `backendPingIntervalSeconds`, `trustedHeaders`, `sessionStore`, `urlElicitation` |
| 4 | mcp-lifecycle-install-gateway.txt | §1.6–1.8 ReferenceGrant, DNS, custom HTTPRoute | Cross-namespace extensions need a `ReferenceGrant` in the Gateway namespace; DNSPolicy attachment for hostname→IP mapping; custom HTTPRoute with CORS headers for production (disable `httpRouteManagement` first) |
| 5 | mcp-lifecycle-install-gateway.txt | §1.9 MCP endpoint accessibility | `curl -X POST .../mcp` with `initialize` method; response carries `serverInfo:{"name":"Kuadrant MCP Gateway","version":"0.6.0"}` and negotiated protocol version `2025-11-25` |
| 6 | mcp-lifecycle-register-servers.txt | §1.1–1.3 Register on-premise MCP servers | HTTPRoute + `MCPServerRegistration` pairing; prefix per server avoids tool-name collisions; prefix schema-constrained (a-z, 0-9, `_`, immutable); `oc get mcpsr` table with `READY`/`TOOLS`/`CREDENTIALS`; status `conditions` with `discoveredTools` count; session-based `tools/list`, `prompts/list`, `prompts/get` verification with prefixed names |
| 7 | mcp-lifecycle-register-servers.txt | §2 External MCP servers | ServiceEntry + DestinationRule + HTTPRoute + Secret (`mcp.kuadrant.io/secret: "true"` label) + AuthPolicy for external servers; `credentialRef` for simple API-key auth |
| 8 | mcp-lifecycle-register-servers.txt | §3 Virtual MCP servers | `MCPVirtualServer` CR curates tools/prompts; accessed via `X-Mcp-Virtualserver: namespace/name` header; filtering applies identity-based (`x-mcp-authorized`) then virtual-server filters in order; virtual servers filter discovery only — call routing and authorization unchanged |

## User Flows

### Flow 1: Install and extend the gateway

1. **Install Operator** — `Subscription` + `OperatorGroup` CRs on the `preview` channel; wait for installplan and CSV `Succeeded` (§1.1)
2. **Create Gateway** — `gatewayClassName: openshift-default` with `http` and `mcps` listeners; verify `Accepted: True`/`Programmed: True` (§1.2–1.3)
3. **Extend with MCP support** — `MCPGatewayExtension` CR with `targetRef.sectionName` matching the listener name and `httpRouteManagement: Enabled`; automatic HTTPRoute + Envoy filter (§1.4–1.5)
4. **Verify** — `oc get httproute mcp-gateway-route` and `oc get envoyfilter -l app.kubernetes.io/managed-by=mcpgateway-controller` (§1.5)

### Flow 2: Register and verify a backend MCP server

1. **Route to backend** — HTTPRoute CR with `parentRefs` to the gateway and `backendRefs` to the backend Service (§1.2 register)
2. **Register** — `MCPServerRegistration` CR with `prefix`, `targetRef` to the HTTPRoute, optional `credentialRef`; `oc get mcpsr` shows `READY: True` and a `TOOLS` count (§1.2)
3. **Verify discovery** — initialize MCP session, extract `mcp-session-id` header, `tools/list` and `prompts/list` return entries prefixed with the registration prefix; `prompts/get` retrieves a specific prompt (§1.3)

### Flow 3: Curate and unregister

1. **Curate** — `MCPVirtualServer` CR listing prefixed tool names; query with the `X-Mcp-Virtualserver` header in `namespace/name` format; response contains only the curated tools (§3.3–3.4)
2. **Unregister** — delete the registration and its HTTPRoute; broker stops federating automatically, no gateway restart (workshop Verify); revoked tools disappear from fresh `tools/list` (§6)

## Features and Concepts

### OpenShift Platform
- Operator Lifecycle Manager (Subscription, OperatorGroup, ClusterServiceVersion), Gateway API (Gateway, HTTPRoute, ReferenceGrant), Secrets and RBAC labels

### RHOAI / AI Platform
- MCP gateway deployment Operator, `MCPGatewayExtension`/`MCPServerRegistration`/`MCPVirtualServer` CRs (`mcp.kuadrant.io/v1alpha1`), broker-router components, Connectivity Link DNSPolicy, AuthPolicy integration

### AI/ML Fundamentals
- Model Context Protocol (MCP): JSON-RPC sessions, tool/prompt federation, tool-name prefixing to avoid collisions, curated tool exposure for LLMs and agents

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and AI platform administrators with OpenShift, OLM, and Gateway API working knowledge
- **Prerequisite knowledge**: `oc` CLI basics, Gateway API concepts, OLM operator installs
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with Connectivity Link 1.4.1+, `mcp-gateway` operator in the `redhat-operators` catalog on the `preview` channel, and a backend MCP server running as a Service

## Open Questions

- Exact Installed Operators console rendering for the `preview`-channel operator (doc-derived path, unverified UI)
- Backend MCP server provisioning in workshop clusters (module 02 prerequisite)
- Whether the automatic HTTPRoute name (`mcp-gateway-route`) is stable across broker versions
