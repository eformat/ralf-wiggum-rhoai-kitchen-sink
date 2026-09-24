---
schema_version: 1
id: RHAIBU-M33CVWV845NV
type: design
---
# Automated Tool-calling Evaluation Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Automated tool-calling evaluation-data generation for custom
MCP servers (GA) is the agents-and-MCP anchor feature: the EvalHub MCP server,
agent metadata, agent skills plugin, and evaluation cards taught here are the
evaluation path for every MCP-based feature in the same catalog, complementing
the dashboard-based evaluation flow.

## User Need

ML practitioners and platform engineers with OpenShift working knowledge need a
guided path from cluster inspection to a connected MCP client that generates
evaluation data through real tool calls, and onwards to making custom providers
agent-discoverable and generating auditable evaluation cards — with every step
verifiable. Estimated time is about 2 hours.

## Design

Three modules plus shared bookends, one Antora component
(`features/agents-mcp/automated-tool-calling-eval/content/`):

1. **Module 01: Core Concepts** — EvalHub architecture walkthrough (server, SDK and CLI, providers; benchmarks, collections, pass criteria; four MCP surfaces) + cluster inspection (`oc get evalhub`, pod container readiness jsonpath including `mcp=true`, `evalhub` and `evalhub-mcp` routes)
2. **Module 02: Hands-on Exercise** — enable the MCP server via the `spec.mcp` block on the `EvalHub` CR (YAML callouts), expose it through the `evalhub-mcp` route, register Claude Code with authenticated HTTP transport (`Authorization: Bearer` + `x-tenant` headers), drive `discover_providers` → `submit_evaluation` → `get_job_status` tool calls through the pending → running → completed job lifecycle, then validate the generated data with the `evalhub` CLI (200-equivalent negative path: expired token or wrong `x-tenant` surfaces as `401 Unauthorized`)
3. **Module 03: Advanced Usage** — install the agent skills plugin (marketplace or symlinked local dev clone) and verify scripted discovery with `evalhub_providers.py --agent`; add an `agent` metadata block (with YAML callouts for `evaluates`, `recommended_when`, `target_type`, `summary`, `hints`, `result_interpretation`) plus a PATCH path for already-registered providers; generate an evaluation card via an MLflow `experiment` block and retrieve it from `.artifacts`; optional `edd_workflow` prompt for evaluation-driven development

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the source documentation.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- The `spec.mcp` YAML block and `agent` metadata YAML block use callout lists explaining each field
- Every code block containing `{attributes}` uses `subs="attributes"`
- Agent skills scripts require Python 3.11+ and `uv`; `EVALHUB_INSECURE=true` for self-signed certificate clusters

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (understand the surfaces →
connect and generate → extend to custom providers), matching the module-flow in
the related requirements. The CLI validation step closes the loop: MCP tool
calls and the `evalhub` CLI read from the same job store, so either can verify
the other.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Dashboard-first order (REST API first)** — rejected: the feature's differentiator is agent tool-calling, so the MCP surfaces and cluster inspection must come before CLI detail
- **Teach only MCP, skip agent skills** — rejected: agent skills are the scripted fallback for CI pipelines and the path to making custom providers discoverable

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the exact Anthropic plugin-marketplace registration (`evalhub@evalhub`) against a live console (doc-derived)
- Confirm a reachable vLLM-style model endpoint is pre-provisioned in workshop clusters before Act-phase testing
- Verify the `partially_failed` job state renders in the CLI table output for mixed-outcome jobs

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33CVWQY6RCD
- RHAIBU-M33CVWRE0YWX
- RHAIBU-M33CVWS3QS2V
- RHAIBU-M33CVWSM5ZFG

## Related Decisions

- RHAIBU-M33CVWT4XCKP
- RHAIBU-M33CVWTRAWDM
