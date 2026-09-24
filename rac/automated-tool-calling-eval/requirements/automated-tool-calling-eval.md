---
schema_version: 1
id: RHAIBU-M33CVWQY6RCD
type: requirement
---
# Automated Tool-calling Evaluation-data Generation for Custom MCP Servers Workshop

## Problem

ML practitioners and platform engineers evaluating RHOAI 3.5 need hands-on
experience with the EvalHub MCP server — the automated tool-calling path that
lets AI coding agents discover evaluation providers, submit jobs, and interpret
results on OpenShift AI — before they can make custom MCP servers and providers
agent-discoverable in production. Without a structured workshop, learners must
reverse-engineer the EvalHub architecture, the `spec.mcp` configuration, agent
metadata fields, and evaluation-card generation from product documentation
alone. This workshop targets RHOAI users with working knowledge of OpenShift,
an MCP client such as Claude Code installed, and EvalHub deployed by the
TrustyAI Operator.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to name the four MCP tool names, the three agent workflow steps, and the two transport modes without looking back
- [REQ-003] Learner MUST be able to verify the `EvalHub` custom resource exists, the EvalHub pod reports its containers ready (including `mcp=true`), and both the `evalhub` and `evalhub-mcp` routes exist
- [REQ-004] Learner MUST be able to enable the MCP server by applying a `spec.mcp` block (`enabled: true`, `transport: http`) to the `EvalHub` CR and confirm the ready MCP container and `evalhub-mcp` route
- [REQ-005] Learner MUST be able to register the EvalHub MCP server with Claude Code using an authenticated HTTP transport with `Authorization` and `x-tenant` headers, and confirm `discover_providers` returns the registered providers
- [REQ-006] Learner MUST be able to drive an evaluation through tool calls and observe a job state transition from `pending` to `running` to `completed`, summarized with the provider's `result_interpretation` metadata
- [REQ-007] Learner MUST be able to validate the generated evaluation data with the `evalhub` CLI (`evalhub eval results <job_id> --format table`) and confirm the metrics match the values the agent interpreted
- [REQ-008] Learner MUST be able to verify the agent skills plugin connects to EvalHub (`evalhub_providers.py --agent` returns JSON with agent metadata) and confirm an added `agent` metadata block appears in the provider API response
- [REQ-009] Learner MUST be able to generate an evaluation card by including an MLflow experiment configuration and retrieve it with `evalhub eval status <job_id> --format=json | jq '.artifacts'`

## Success Metrics

All nine acceptance criteria are demonstrated by the learner during the lab;
the MCP server container reports ready, `discover_providers` returns the
registered providers, the tool-called job reaches `completed`, the CLI lists
matching benchmark metrics, and the evaluation card appears in `.artifacts`.

## Risks

- EvalHub requires a PostgreSQL connection Secret and a running EvalHub instance before the MCP server can be enabled
- Tokens created with `oc create token` expire; stale tokens surface as `401 Unauthorized` responses in the MCP client
- A custom provider without an `agent` block is excluded from filtered `discover_providers` results, which can confuse learners in module 03
- Evaluation cards are only generated when the job request includes an MLflow experiment or OCI export configuration

## Assumptions

- RHOAI 3.5 is installed with the TrustyAI component `Managed` and EvalHub deployed by the TrustyAI Operator
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- An MCP client such as Claude Code is installed on the learner's workstation
- A model endpoint (e.g. `http://vllm:8000/v1`) is reachable for evaluation jobs

## Related Designs

- RHAIBU-M33CVWV845NV

## Related Decisions

- RHAIBU-M33CVWT4XCKP
- RHAIBU-M33CVWTRAWDM

## Related Requirements

- RHAIBU-M33CVWRE0YWX
- RHAIBU-M33CVWS3QS2V
- RHAIBU-M33CVWSM5ZFG
