---
schema_version: 1
id: RHAIBU-M33DS0ZZ0J4F
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

With the gateway infrastructure in place, learners must manage a real MCP server
lifecycle end to end — register a backend server, verify that the gateway
discovers and federates its tools through the unified `/mcp` endpoint, curate the
exposed tool set, and unregister cleanly. This is the core deliverable of the
workshop.

## Requirements

- [REQ-021] Learner MUST be able to register a backend MCP server by pairing an HTTPRoute CR with an `MCPServerRegistration` CR and observe `READY: True` with a `discoveredTools` count in the status block
- [REQ-022] Learner MUST be able to initialize an MCP session on the `/mcp` endpoint, extract the `mcp-session-id` header, and list tools with `tools/list`, each prefixed with the registration's `prefix` value
- [REQ-023] Learner MUST be able to verify prompts are federated with `prompts/list` and retrieve a specific prompt with `prompts/get` and the prefixed name
- [REQ-024] Learner MUST be able to curate the tool set with an `MCPVirtualServer` CR accessed via the `X-Mcp-Virtualserver` header, then unregister the server and confirm its tools no longer appear in a fresh `tools/list` response

## Success Metrics

The registration reaches `READY: True` with discovered tools; `tools/list` and
`prompts/list` responses carry the `serverone_` prefix; the `X-Mcp-Virtualserver`
request returns only the curated tools; after deletion a fresh `tools/list`
excludes the unregistered server.

## Risks

- Registering before the backend Service is reachable reports `READY: False` — expected friction
- The `prefix` field is immutable and schema-constrained (lowercase letters, digits, underscores); changing it requires delete and re-create
- Deleting a registration with active sessions only invalidates them later; production unregisters need a maintenance window

## Assumptions

- Learner has completed Module 01 (gateway infrastructure ready) and has a backend MCP server running as a Service in the project

## Related Requirements

- RHAIBU-M33DS0ZP7D08

## Verified By

- features/agents-mcp/mcp-lifecycle-operator/content/modules/ROOT/pages/module-02-hands-on.adoc
