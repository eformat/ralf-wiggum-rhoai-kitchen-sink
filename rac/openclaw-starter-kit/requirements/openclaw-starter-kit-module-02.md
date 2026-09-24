---
schema_version: 1
id: RHAIBU-M33DZQ7Y1W5P
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

After learning what the starter kit provides, learners need to understand how
the kit operates once deployed: how agent behavior is captured in MLflow
through OpenTelemetry tracing, how browser-based access control is enforced,
and how persistence, security, and environment validation work. Without this
guided tour, an operator cannot reason about where agent behavior is visible
or who can reach the agent.

## Requirements

- [REQ-021] Learner MUST be able to describe what the diagnostics-otel plugin captures in MLflow: model calls, tool executions, and context assembly spans
- [REQ-022] Learner MUST be able to explain the three-step access control flow: route exposure, OAuth proxy authentication of the browser session, and authorization delegated to OpenShift RBAC
- [REQ-023] Learner SHOULD be able to observe the running agent workload with `oc get pods -n {guid}-{user}` and treat the pod names as an observation rather than a fixed output
- [REQ-024] Learner MUST be able to summarize workspace persistence across pod restarts, the restricted-v2 SCC security posture, and the model compatibility matrix and troubleshooting guide

## Success Metrics

Learner completes all three exercises — the MLflow/OpenTelemetry tracing
tour (including the hypothetical debugging walkthrough), the OAuth proxy and
OpenShift RBAC access control flow, and the persistence/security/validation
review with the `oc get pods` observation — each matching the documented
module summary.

## Risks

- The `oc get pods` observation depends on a facilitator having deployed the starter kit into a shared namespace; without it the observation step is discussion only
- The module warns against bypassing the OAuth proxy or modifying manifests to grant additional security contexts — learners who ignore these warnings undermine the validated posture

## Assumptions

- Learner has completed Module 01 and Getting Connected (working project `{guid}-{user}`)

## Related Requirements

- RHAIBU-M33DZQ7G95Q9

## Verified By

- features/agents-mcp/openclaw-starter-kit/content/modules/ROOT/pages/module-02-hands-on.adoc
