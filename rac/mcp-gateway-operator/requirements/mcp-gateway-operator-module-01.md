---
schema_version: 1
id: RHAIBU-M33DKVH1WS3B
type: requirement
---
# Module 01: Getting Started

## Problem

Before registering backend servers, learners need the MCP gateway stack
standing: the Operator installed with OLM, a Gateway object with an MCP
listener, and an `MCPGatewayExtension` CR wired in with a ReferenceGrant.
Without this foundation, Module 02's registrations have nothing to attach to
and no `/mcp` endpoint to serve tools through.

## Requirements

- [REQ-011] Learner MUST be able to install the MCP gateway Operator from the `redhat-operators` catalog (`preview` channel) with a Subscription and OperatorGroup, and verify the CSV phase reaches `Succeeded`
- [REQ-012] Learner MUST be able to create a Gateway object with `http` (port 80) and `mcp` (port 8080) listeners and confirm `Accepted: True` and `Programmed: True`
- [REQ-013] Learner MUST be able to create a ReferenceGrant in the gateway namespace plus an `MCPGatewayExtension` CR (`sectionName: mcp`, `httpRouteManagement: Enabled`) and verify the `Ready` condition
- [REQ-014] Learner MUST be able to verify the auto-created `mcp-gateway-route` HTTPRoute, the EnvoyFilter in the gateway namespace, and an MCP endpoint `initialize` response through the gateway

## Success Metrics

Learner completes all three exercises: the OLM install (CSV `Succeeded`), the
Gateway with listeners (`Accepted`/`Programmed` both `True`), and the
extension wiring (HTTPRoute, EnvoyFilter, and a `Kuadrant MCP Gateway`
serverInfo response), each producing the documented expected output.

## Risks

- The extension ready condition times out when the ReferenceGrant is missing, `sectionName` does not match a listener, or the broker-router deployment is not ready
- Port conflicts or a wrong `gatewayClassName` show up in the Gateway Events section

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- Connectivity Link 1.4.1 or later is installed on the cluster

## Related Requirements

- RHAIBU-M33DKVGWS3VG

## Verified By

- features/agents-mcp/mcp-gateway-operator/content/modules/ROOT/pages/module-01-getting-started.adoc
