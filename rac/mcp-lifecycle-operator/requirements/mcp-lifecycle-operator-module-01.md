---
schema_version: 1
id: RHAIBU-M33DS0ZT56SF
type: requirement
---
# Module 01: Getting Started

## Problem

Before registering MCP servers, learners need the gateway infrastructure that the
MCP Lifecycle Operator stack depends on: the MCP gateway deployment Operator
installed with OLM, a Gateway object with an MCP listener, and an
`MCPGatewayExtension` CR that wires MCP protocol support onto that listener.
Without this orientation, later hands-on steps are copy-paste with no
understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to install the MCP gateway deployment Operator by applying `Subscription` and `OperatorGroup` CRs on the `preview` channel and wait for the CSV phase `Succeeded`
- [REQ-012] Learner MUST be able to create a Gateway object with an `http` listener and an `mcps` listener and verify `Accepted: True` and `Programmed: True` with `oc get gateway`/`oc describe gateway`
- [REQ-013] Learner MUST be able to apply an `MCPGatewayExtension` CR targeting the `mcps` listener and confirm the automatic `mcp-gateway-route` HTTPRoute and the managed Envoy filter exist
- [REQ-014] Learner MUST be able to confirm the `mcpgatewayextensions`, `mcpserverregistrations`, and `mcpvirtualservers` CRDs landed with `oc get crd | grep mcp.kuadrant.io`

## Success Metrics

Learner completes all three exercises: the Operator install with CSV `Succeeded`,
the programmed Gateway with both listeners, and the ready `MCPGatewayExtension`
with automatic HTTPRoute and Envoy filter, each producing the documented expected
output.

## Risks

- Connectivity Link 1.4.0 is deprecated; clusters running it can see authentication failures and gateway instability
- Each namespace and each Gateway object can only have one `MCPGatewayExtension` CR — newer duplicates are marked conflicted

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- The `mcp-gateway` Operator is listed in the `redhat-operators` catalog source on the `preview` channel

## Related Requirements

- RHAIBU-M33DS0ZP7D08

## Verified By

- features/agents-mcp/mcp-lifecycle-operator/content/modules/ROOT/pages/module-01-getting-started.adoc
