---
schema_version: 1
id: RHAIBU-M33E4B1E72FC
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must prove that the surfaces backing an OpenCode coding-agent workload
are live: the OpenAI-compatible inference endpoint that serves its model, the
workbench IDE terminal where a terminal-based agent operates, and the console
and tracing views that observe it. This is the core deliverable of the
workshop: a verified endpoint, a working shell, and observable agent surfaces.

## Requirements

- [REQ-021] Learner MUST be able to export the connection-model parameters (endpoint URL, API key, model name) and probe the endpoint with `curl -s $LLM_ENDPOINT/models -H "Authorization: Bearer $LLM_API_KEY"`
- [REQ-022] Learner MUST observe that the probe response is JSON with `"object": "list"` and a `data` array containing at least one model entry
- [REQ-023] Learner MUST be able to launch a workbench from the dashboard (*Data science projects* → *Workbenches*) and run `git --version && python --version` in the IDE terminal
- [REQ-024] Learner SHOULD be able to view the *External models* tab under *AI hub* → *Models* (enabled by `spec.dashboardConfig.externalModels: true` in `OdhDashboardConfig`)
- [REQ-025] Learner SHOULD be able to locate the MLflow UI and identify where agent model calls, tool executions, and context assembly spans would land

## Success Metrics

The `GET /models` probe returns a JSON model list; the workbench terminal
prints git and Python versions; the External models tab lists project
endpoints (or is empty if none are registered).

## Risks

- The endpoint must be reachable and the URL/key must be correct for the probe to return JSON
- The *External models* tab requires a platform-administrator `OdhDashboardConfig` change
- MLflow tracing availability depends on the facilitator enabling it for the agent stack

## Assumptions

- Learner has completed Module 01 (environment verified) and has the connection-model parameters from the facilitator

## Related Requirements

- RHAIBU-M33E4B10VYFE

## Verified By

- features/agents-mcp/opencode-coding-agent/content/modules/ROOT/pages/module-02-hands-on.adoc
