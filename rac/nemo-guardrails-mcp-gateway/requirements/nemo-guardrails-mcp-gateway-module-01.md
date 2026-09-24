---
schema_version: 1
id: RHAIBU-M33F0QPSWBDW
type: requirement
---
# Module 01: Getting Started with Guardrails and the MCP Gateway

## Problem

Before wiring guardrails into the MCP gateway, learners need a mental model of
gateway-layer enforcement — how the TrustyAI operator discovers the gateway
through `MCPGatewayExtension` resources, detects the BBR plugin, and provisions
the `mcp-sse-strip` EnvoyFilter — plus a working standalone NeMo Guardrails
service whose rails they can test directly. Without this orientation, later
hands-on steps are copy-paste with no understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to explain how the TrustyAI operator enforces guardrails on MCP gateway tool calls (gateway discovery via `MCPGatewayExtension` targetRef, BBR plugin detection, `mcp-sse-strip` provisioning)
- [REQ-012] Learner MUST be able to verify the `MCPGatewayExtension` CRD is available and at least one resource exists in the gateway namespace (`oc get mcpgatewayextensions -n mcp-gateway-system` lists a resource)
- [REQ-013] Learner MUST be able to confirm at least one EnvoyFilter in the gateway namespace contains the BBR ext_proc sub-filter (`oc get envoyfilters ... -o yaml | grep "envoy.filters.http.ext_proc.bbr"` returns output)
- [REQ-014] Learner MUST be able to deploy a standalone NeMo Guardrails service with built-in Presidio and regex detectors, confirm `PHASE: Ready`, and test `/v1/guardrail/checks` — safe content returns `"status": "success"` and an email address returns `"status": "blocked"`

## Success Metrics

Learner completes both exercises: the MCP gateway prerequisite verification and
the standalone NeMo Guardrails deployment with its positive/negative
`/v1/guardrail/checks` tests, each producing the documented expected output.

## Risks

- `MCPGatewayExtension` resources and BBR plugin EnvoyFilters only exist after the facilitator deploys the MCP gateway; on clusters without them, Exercise 1 must be adapted

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- TrustyAI operator is installed with additional RBAC for MCP gateway integration (`nemo-guardrails-manager-role` ClusterRole)

## Related Requirements

- RHAIBU-M33F0QPJ2XT7

## Verified By

- features/guardrails/nemo-guardrails-mcp-gateway/content/modules/ROOT/pages/module-01-getting-started.adoc
