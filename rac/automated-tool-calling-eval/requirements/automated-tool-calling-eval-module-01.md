---
schema_version: 1
id: RHAIBU-M33CVWRE0YWX
type: requirement
---
# Module 01: Core Concepts

## Problem

Before driving tool-calling evaluations, learners need a mental model of how the
EvalHub MCP server turns automated tool-calling into evaluation-data generation:
the EvalHub architecture (server, SDK and CLI, providers), the four MCP surfaces,
the three-step agent workflow, and the cluster resources the TrustyAI Operator
manages. Without this orientation, later hands-on steps are copy-paste with no
understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to name the four MCP tool names (`discover_providers`, `submit_evaluation`, `get_job_status`, `cancel_job`), the three agent workflow steps (discover, execute, interpret), and the two transport modes (`stdio`, `http`) without looking back
- [REQ-012] Learner MUST be able to confirm the `EvalHub` custom resource exists in the EvalHub namespace with `oc get evalhub -n $EVALHUB_NS`
- [REQ-013] Learner MUST be able to list the EvalHub pods and confirm each container is ready, including the `mcp` container, with the jsonpath readiness query
- [REQ-014] Learner MUST be able to confirm both the `evalhub` and `evalhub-mcp` routes exist with `oc get routes -n $EVALHUB_NS`

## Success Metrics

Learner completes both exercises: the architecture walkthrough (reciting the
MCP tools, workflow steps, and transport modes) and the cluster inspection
commands, each producing the documented expected output.

## Risks

- If the `EvalHub` resource is missing, the TrustyAI Operator has not deployed the feature yet and the hands-on module cannot proceed

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33CVWQY6RCD

## Verified By

- features/agents-mcp/automated-tool-calling-eval/content/modules/ROOT/pages/module-01-concepts.adoc
