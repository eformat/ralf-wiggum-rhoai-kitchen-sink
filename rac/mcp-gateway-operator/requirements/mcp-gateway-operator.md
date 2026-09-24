---
schema_version: 1
id: RHAIBU-M33DKVGWS3VG
type: requirement
---
# MCP gateway Operator Workshop

## Problem

Platform engineers and AI application teams evaluating RHOAI 3.5 need hands-on
experience with the MCP gateway Operator — the Red Hat Connectivity Link feature
(Technology Preview) that connects and secures backend Model Context Protocol
(MCP) servers to frontend agentic AI services behind a single endpoint — before
they can recommend or operate it in production. Without a structured workshop,
learners must reverse-engineer the Gateway listener, `MCPGatewayExtension`,
`MCPServerRegistration`, and `MCPVirtualServer` CR patterns from product
documentation alone. This workshop targets RHOAI users with working knowledge of
OpenShift and Kubernetes Gateway API concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to install the MCP gateway Operator with OLM (Subscription from `redhat-operators`, `preview` channel) and verify the ClusterServiceVersion reaches `Succeeded` phase
- [REQ-003] Learner MUST be able to create a Gateway object with `http` and `mcp` listeners and confirm `Accepted: True` and `Programmed: True`
- [REQ-004] Learner MUST be able to apply a ReferenceGrant plus `MCPGatewayExtension` CR and verify the auto-created HTTPRoute and EnvoyFilter
- [REQ-005] Learner MUST be able to reach the MCP endpoint through the gateway with a `curl` `initialize` request and observe the `Kuadrant MCP Gateway` serverInfo response
- [REQ-006] Learner MUST be able to register a backend MCP server with an HTTPRoute plus `MCPServerRegistration` CR and verify `oc get mcpsr` reports `READY: True` with a `TOOLS` count greater than zero
- [REQ-007] Learner MUST be able to list the registered server's tools and prompts through the gateway and confirm each name carries the configured prefix
- [REQ-008] Learner SHOULD be able to curate tools into a virtual MCP server with an `MCPVirtualServer` CR and verify the `X-Mcp-Virtualserver` header filters `tools/list` while the unfiltered request returns all tools

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the lab;
the MCP endpoint responds to `initialize` through the gateway in modules 01–02,
`oc get mcpsr` reports `READY: True` with discovered tools, and the virtual
server filter returns exactly the curated tool list.

## Risks

- The MCP gateway is Technology Preview in 3.5; APIs (`mcp.kuadrant.io/v1alpha1`) and manifests may change between releases
- Workshop clusters must have Red Hat Connectivity Link 1.4.1 or later installed (1.4.0 is deprecated and causes authentication and gateway instability issues)
- Module 02 assumes a backend MCP server serving `/mcp` is running in the cluster with a fronting service
- Cross-namespace references (`MCPGatewayExtension` → Gateway) require a ReferenceGrant; a missing one times out the extension ready condition

## Assumptions

- RHOAI 3.5 is installed with the MCP Lifecycle Operator enabled
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- DNS can resolve the MCP listener hostname in the workshop environment (or `/etc/hosts` is updated with the Gateway address)

## Related Designs

- RHAIBU-M33DKVHS96MX

## Related Decisions

- RHAIBU-M33DKVHDZTDS
- RHAIBU-M33DKVHKC83X

## Related Requirements

- RHAIBU-M33DKVH1WS3B
- RHAIBU-M33DKVH79MA8
