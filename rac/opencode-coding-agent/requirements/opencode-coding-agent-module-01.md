---
schema_version: 1
id: RHAIBU-M33E4B17PQW3
type: requirement
---
# Module 01: Getting Started

## Problem

Before probing any agent surface, learners need to understand what OpenCode is,
what the RHOAI 3.5 Technology Preview validation covers, and whether their
cluster is ready to support a coding-agent workload. Without this orientation
and readiness check, later hands-on steps probe endpoints with no understanding
of the validation pattern behind them.

## Requirements

- [REQ-011] Learner MUST be able to name the three building blocks the OpenCode validation covers (agent platform operators, vLLM and OGX inference backends, MLflow tracing integration) and the four deliverables it provides
- [REQ-012] Learner MUST be able to describe the onboarding pattern established by OpenClaw (validated Kustomize manifests, vLLM/OGX inference, MLflow tracing)
- [REQ-013] Learner MUST be able to confirm a `rhods-operator` CSV exists in `redhat-ods-operator` with `PHASE` `Succeeded` via `oc get csv -n redhat-ods-operator`
- [REQ-014] Learner MUST be able to confirm the working project is the active namespace via `oc project` (showing `{guid}-{user}`)

## Success Metrics

Learner completes both exercises: the feature-and-validation walkthrough and
the environment readiness commands, each producing the documented expected
output.

## Risks

- OpenCode is documented only at the release-notes level in 3.5; no step-by-step deployment procedure exists in the documentation set
- A missing `rhods-operator` CSV means the RHOAI installation must be completed before continuing

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33E4B10VYFE

## Verified By

- features/agents-mcp/opencode-coding-agent/content/modules/ROOT/pages/module-01-getting-started.adoc
