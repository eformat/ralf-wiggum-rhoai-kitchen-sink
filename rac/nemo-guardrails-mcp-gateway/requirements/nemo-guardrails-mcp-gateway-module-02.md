---
schema_version: 1
id: RHAIBU-M33F0QQ0SETN
type: requirement
---
# Module 02: Enforce Guardrails on MCP Gateway Agent Tool Calls

## Problem

With a standalone NeMo Guardrails service running, learners need to wire it
into the MCP gateway by adding the `mcpGateway` field to the `NemoGuardrails`
CR, then verify that the operator discovers the gateway and BBR plugin and
provisions the enforcement plumbing. They also need to understand the
integration's lifecycle — what happens to the EnvoyFilter when the
configuration changes — before trusting the integration in any environment.
Finally, they need to drive a real MCP tool call through the guarded gateway
and observe the guardrails outcome, so the enforcement story is demonstrated
end to end rather than stopping at the plumbing.

## Requirements

- [REQ-021] Learner MUST be able to apply the `NemoGuardrails` CR with the `mcpGateway` field (named gateway lookup specifying both `name` and `namespace`)
- [REQ-022] Learner MUST be able to verify MCP gateway discovery and BBR plugin detection through CR status fields (`{"mcpGatewayFound":true}` and `{"bbrPluginFound":true}`)
- [REQ-023] Learner MUST be able to verify the `mcp-sse-strip` EnvoyFilter was created in the gateway namespace (`oc get envoyfilters mcp-sse-strip -n mcp-gateway-system`)
- [REQ-024] Learner MUST be able to trigger automatic EnvoyFilter deletion (`NotFound` after removing the `mcpGateway` field) and recreation (filter details again after re-applying the CR)
- [REQ-025] Learner MUST be able to initialize an MCP session against the guarded gateway (`POST /mcp` with `initialize`) and extract the `mcp-session-id` response header
- [REQ-026] Learner MUST be able to list the tools exposed by the gateway (`tools/list` with the session ID returns tool names with the configured `MCPServerRegistration` prefix)
- [REQ-027] Learner MUST be able to call a tool through the guarded gateway (`tools/call` with the session ID returns a JSON-RPC result for benign arguments)
- [REQ-028] Learner MUST be able to observe the guardrails decision on tool-call payloads via `/v1/guardrail/checks` (`"status": "success"` for benign content; `"status": "blocked"` with `detect sensitive data on input` and `regex check input` in `guardrails_data.log.activated_rails` for content carrying an email address and an api key)

## Success Metrics

Learner completes all three exercises: the `mcpGateway` configuration with
status verification, the EnvoyFilter lifecycle exercise (delete on removal,
recreate on restore), and the guarded tool-call exercise (initialize session,
tools/list, tools/call, guardrails outcome), each producing the documented
expected output.

## Risks

- Discovery fails when the specified `MCPGatewayExtension` does not exist or its `targetRef` does not resolve to a Kubernetes `Gateway`; troubleshooting requires reading `status.mcpGateway` error messages
- The 3.5 documentation documents the MCP call flow and the guardrails response schema in separate procedures without a single end-to-end guarded tool-call walkthrough; the lab composes the two documented pieces and says so (NOTE in Exercise 3)

## Assumptions

- Learner completed Module 01 (standalone NeMo Guardrails service deployed, rails configuration `nemo-quickstart-config` reusable)
- The example values `my-mcp-gateway` in `mcp-gateway-system` are supplied by the facilitator
- The facilitator supplies the external URL of the MCP gateway and has registered at least one MCP server, so `tools/list` returns prefixed tool names

## Related Requirements

- RHAIBU-M33F0QPJ2XT7

## Verified By

- features/guardrails/nemo-guardrails-mcp-gateway/content/modules/ROOT/pages/module-02-hands-on.adoc
