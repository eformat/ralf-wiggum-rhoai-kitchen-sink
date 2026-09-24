---
schema_version: 1
id: RHAIBU-M33DS0ZP7D08
type: requirement
---
# MCP Lifecycle Operator Workshop

## Problem

Platform engineers and AI platform administrators evaluating RHOAI 3.5 need hands-on
experience with the MCP Lifecycle Operator stack — installing the MCP gateway
deployment Operator, extending a Gateway with MCP protocol support, and managing
MCP server lifecycles — before they can recommend or operate it in production.
Without a structured workshop, learners must reverse-engineer the
`MCPGatewayExtension`, `MCPServerRegistration`, and `MCPVirtualServer` CRs
(`mcp.kuadrant.io/v1alpha1`) from Connectivity Link documentation alone. This
workshop targets RHOAI users with working knowledge of OpenShift, OLM, and
Gateway API concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and work in a personal project (`oc project {guid}-{user} || oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to install the MCP gateway deployment Operator via OLM `Subscription`/`OperatorGroup` CRs and confirm the ClusterServiceVersion phase is `Succeeded`
- [REQ-003] Learner MUST be able to create a Gateway object with an MCP listener and confirm `Accepted: True` and `Programmed: True` in its status conditions
- [REQ-004] Learner MUST be able to apply an `MCPGatewayExtension` CR and confirm the automatic HTTPRoute and Envoy filter were created
- [REQ-005] Learner MUST be able to register a backend MCP server by pairing an HTTPRoute with an `MCPServerRegistration` CR and confirm `READY: True` with a nonzero `TOOLS` count
- [REQ-006] Learner MUST be able to initialize an MCP session on the `/mcp` endpoint and list the server's tools and prompts via `tools/list` and `prompts/list` with the registered prefix
- [REQ-007] Learner SHOULD be able to curate the exposed tool set with an `MCPVirtualServer` CR and the `X-Mcp-Virtualserver` header
- [REQ-008] Learner MUST be able to unregister the server by deleting the registration and confirm its tools no longer appear in a fresh `tools/list` response

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the lab; the
`MCPGatewayExtension` reaches `Ready` condition met in module 01, the registration
reports `READY: True` with discovered tools in module 02, and session-scoped
`tools/list`/`prompts/list` responses carry the registered prefix before and after
curation and unregister.

## Risks

- The MCP gateway Operator is Technology Preview in 3.5 and its CRDs (`mcp.kuadrant.io/v1alpha1`) are alpha APIs that may change between releases
- The Operator is installed, configured, and upgraded independently from the OpenShift AI operator lifecycle; cluster administrators own its full lifecycle
- Connectivity Link 1.4.0 is deprecated — the workshop requires 1.4.1 or later
- The `mcp-gateway` Operator must be available in the `redhat-operators` catalog source with the `preview` channel

## Assumptions

- RHOAI 3.5 is installed with Connectivity Link 1.4.1+ available
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A backend MCP server is already running in the learner's project as a Service before module 02 registration

## Related Designs

- RHAIBU-M33DS10C9RMB

## Related Decisions

- RHAIBU-M33DXC0R0JKG
- RHAIBU-M33DXC14VGYN

## Related Requirements

- RHAIBU-M33DS0ZT56SF
- RHAIBU-M33DS0ZZ0J4F
