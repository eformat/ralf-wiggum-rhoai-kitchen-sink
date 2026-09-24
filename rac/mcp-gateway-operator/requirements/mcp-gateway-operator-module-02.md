---
schema_version: 1
id: RHAIBU-M33DKVH79MA8
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must work the core MCP gateway workflow end to end: register a real
backend MCP server, prove its tools are discovered and served through the
unified `/mcp` endpoint, and curate the tool list with a virtual MCP server.
This is the core deliverable of the workshop: a federated, prefix-disambiguated
tool surface with verified discovery and filtering.

## Requirements

- [REQ-021] Learner MUST be able to register a backend MCP server with an HTTPRoute plus an `MCPServerRegistration` CR (`prefix`, `targetRef`, optional `credentialRef`) and verify `oc get mcpsr` reports `READY: True` with a `TOOLS` count greater than zero
- [REQ-022] Learner MUST be able to start an MCP session with an `initialize` request, extract the `mcp-session-id`, and list the server's tools via `tools/list` with each name prefixed by the configured `prefix` value
- [REQ-023] Learner MUST be able to verify that prompts are also federated by listing them via `prompts/list` with the prefix applied
- [REQ-024] Learner MUST be able to create an `MCPVirtualServer` CR and verify that requests with the `X-Mcp-Virtualserver` header return only the curated tools while the unfiltered request returns every tool from all registered servers

## Success Metrics

`oc get mcpsr` reports `READY: True` with discovered tools; the curl session
lists prefixed tools and prompts through the gateway; the
`X-Mcp-Virtualserver` request returns exactly the curated subset.

## Risks

- The exercise assumes a backend MCP server serving `/mcp` is running in the cluster; service and route names follow the docs example
- The `prefix` value is schema-enforced and immutable — non-conforming prefixes require delete and re-create

## Assumptions

- Learner has completed Module 01 (Operator installed, Gateway + extension ready)
- Backend server credentials, if required, are available in a Secret referenced by `credentialRef`

## Related Requirements

- RHAIBU-M33DKVGWS3VG

## Verified By

- features/agents-mcp/mcp-gateway-operator/content/modules/ROOT/pages/module-02-hands-on.adoc
