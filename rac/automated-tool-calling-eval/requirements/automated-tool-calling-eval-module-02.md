---
schema_version: 1
id: RHAIBU-M33CVWS3QS2V
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must deploy the EvalHub MCP server, connect an AI coding agent to it
over an authenticated HTTP transport, and generate evaluation data through real
tool calls — provider discovery, job submission, and job monitoring — then prove
the generated data with the `evalhub` CLI. This is the core deliverable of the
workshop: an end-to-end automated tool-calling evaluation with verified data.

## Requirements

- [REQ-021] Learner MUST be able to enable the MCP server by adding a `spec.mcp` block (`enabled: true`, `transport: http`, `port: 3001`) to the `EvalHub` CR, apply it, and confirm `mcp=true` on the EvalHub pod plus the `evalhub-mcp` route
- [REQ-022] Learner MUST be able to register the MCP server with Claude Code (`claude mcp add evalhub --transport http`) with `Authorization: Bearer` and `x-tenant` headers, and confirm `discover_providers` returns the registered providers
- [REQ-023] Learner MUST be able to drive an evaluation through `discover_providers`, `submit_evaluation`, and `get_job_status` tool calls and observe the job state transition `pending` → `running` → `completed`, summarized with the provider's `result_interpretation` metadata
- [REQ-024] Learner MUST be able to validate the generated data with the `evalhub` CLI (`evalhub eval results <job_id> --format table`) and confirm the metrics match the values the agent interpreted

## Success Metrics

The MCP container reports `mcp=true` and the `evalhub-mcp` route exists;
`discover_providers` returns the registered providers; the tool-called job
reaches `completed`; `evalhub eval results` lists benchmark metrics matching the
agent's interpretation.

## Risks

- EvalHub requires a PostgreSQL connection Secret and a running EvalHub instance before the MCP server can be enabled
- Tokens created with `oc create token` expire; a `401 Unauthorized` response means the token expired or the `x-tenant` header does not match the tenant namespace

## Assumptions

- Learner has completed Module 01 (EvalHub CR, pods, and routes verified)
- An MCP client such as Claude Code is installed on the learner's workstation

## Related Requirements

- RHAIBU-M33CVWQY6RCD

## Verified By

- features/agents-mcp/automated-tool-calling-eval/content/modules/ROOT/pages/module-02-hands-on.adoc
