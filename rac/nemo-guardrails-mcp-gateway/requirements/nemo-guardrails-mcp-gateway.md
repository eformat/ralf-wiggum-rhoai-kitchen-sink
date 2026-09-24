---
schema_version: 1
id: RHAIBU-M33F0QPJ2XT7
type: requirement
---
# NeMo Guardrails integration with MCP Gateway Workshop

## Problem

Platform engineers and AI practitioners evaluating RHOAI 3.5 need hands-on
experience with NeMo Guardrails integration with MCP Gateway — the Technology
Preview path for enforcing guardrails on agent tool calls at the gateway layer —
before they can recommend or operate it. Without a structured workshop, learners
must reverse-engineer the `mcpGateway` configuration, the discovery mechanism,
and the status fields from product documentation alone. This workshop targets
RHOAI users with working knowledge of OpenShift and gateway concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify the `MCPGatewayExtension` CRD is available and at least one resource exists in the gateway namespace (`oc get mcpgatewayextensions -n mcp-gateway-system`)
- [REQ-003] Learner MUST be able to confirm at least one EnvoyFilter in the gateway namespace contains the BBR ext_proc sub-filter (`grep "envoy.filters.http.ext_proc.bbr"` returns output)
- [REQ-004] Learner MUST be able to deploy a standalone NeMo Guardrails service with built-in detectors and confirm the CR reaches `PHASE: Ready`
- [REQ-005] Learner MUST be able to test the `/v1/guardrail/checks` endpoint with safe content (`"status": "success"`) and with an email address (`"status": "blocked"`)
- [REQ-006] Learner MUST be able to apply the `NemoGuardrails` CR with the `mcpGateway` field and verify discovery via `status.mcpGateway` (`{"mcpGatewayFound":true}`) and `status.bbrPlugin` (`{"bbrPluginFound":true}`)
- [REQ-007] Learner MUST be able to verify the `mcp-sse-strip` EnvoyFilter was provisioned in the gateway namespace
- [REQ-008] Learner SHOULD be able to trigger automatic EnvoyFilter deletion and recreation by removing and restoring the `mcpGateway` field

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the lab;
the `NemoGuardrails` CR reports `mcpGatewayFound` and `bbrPluginFound` as true,
the `mcp-sse-strip` EnvoyFilter exists in the gateway namespace, and
`/v1/guardrail/checks` returns `success` for safe content and `blocked` for an
email address.

## Risks

- NeMo Guardrails integration with MCP gateway is Technology Preview in 3.5; the CRD API versions (`trustyai.opendatahub.io/v1alpha1`, `mcp.kuadrant.io/v1alpha1`) may change between releases
- The MCP gateway Operator, `MCPGatewayExtension` resources, and BBR plugins are external prerequisites deployed by the workshop facilitator; modules 01–02 fail without them
- OpenShift Service Mesh or Istio with `EnvoyFilter` support must be installed in the gateway namespace

## Assumptions

- RHOAI 3.5 is installed with the TrustyAI component `Managed` (or `mCPGuardrailsOnlyMode=True` for standalone mode)
- The facilitator pre-deployed the MCP gateway, at least one `MCPGatewayExtension`, and the `nemo-request-guard`/`nemo-response-guard` BBR plugins in `mcp-gateway-system`
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)

## Related Designs

- RHAIBU-M33F0QQKS846

## Related Decisions

- RHAIBU-M33F0QQ6P5SF
- RHAIBU-M33F0QQC12FT

## Related Requirements

- RHAIBU-M33F0QPSWBDW
- RHAIBU-M33F0QQ0SETN
