---
schema_version: 1
id: RHAIBU-M33E4B10VYFE
type: requirement
---
# OpenCode Coding-Agent Deployment Workshop

## Problem

Platform engineers and AI practitioners evaluating RHOAI 3.5 need hands-on
experience with OpenCode coding-agent deployment — the first coding agent
validated to follow the OpenClaw onboarding pattern — before they can recommend
or operate agentic workloads in production. OpenCode is a Technology Preview
feature documented only at the release-notes level, so without a structured
workshop learners cannot connect the validation building blocks (agent platform
operators, vLLM and OGX inference backends, MLflow tracing) to a live cluster.
This workshop targets RHOAI users with working knowledge of OpenShift and
workbench IDEs.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to state the three building blocks the OpenCode validation covers (agent platform operators, vLLM and OGX inference backends, MLflow tracing integration) and the four deliverables it provides
- [REQ-003] Learner MUST be able to verify the RHOAI operator is installed by confirming a `rhods-operator` CSV in the `Succeeded` phase in `redhat-ods-operator`
- [REQ-004] Learner MUST be able to probe an OpenAI-compatible inference endpoint with a `GET /models` request and receive JSON with `"object": "list"` and at least one model entry
- [REQ-005] Learner MUST be able to open a workbench IDE terminal and run `git --version && python --version` successfully
- [REQ-006] Learner SHOULD be able to view registered external model endpoints under *AI hub* → *Models* → *External models* in the dashboard
- [REQ-007] Learner SHOULD be able to identify where MLflow tracing captures agent model calls, tool executions, and context assembly spans

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the OpenAI-compatible `GET /models` probe returns a JSON model list in module
02 and the workbench terminal prints git and Python versions.

## Risks

- OpenCode is Technology Preview in 3.5 and documented only at the release-notes level; the deployment procedure may change between releases
- The workshop requires an LLM serving endpoint (vLLM or OGX) reachable from the learner environment
- The *External models* tab requires `spec.dashboardConfig.externalModels` set to `true` in `OdhDashboardConfig`
- MLflow tracing availability depends on the MLflow Operator component being enabled

## Assumptions

- RHOAI 3.5 is installed with the RHOAI operator reconciled
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A facilitator provides the endpoint URL, API key, and model name for the workshop LLM endpoint

## Related Designs

- RHAIBU-M33E4B24784Z

## Related Decisions

- RHAIBU-M33E4B1P8X5E
- RHAIBU-M33E4B1X3MDR

## Related Requirements

- RHAIBU-M33E4B17PQW3
- RHAIBU-M33E4B1E72FC
