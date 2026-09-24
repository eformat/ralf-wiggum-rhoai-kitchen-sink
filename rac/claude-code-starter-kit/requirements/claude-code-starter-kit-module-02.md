---
schema_version: 1
id: RHAIBU-M33D1QNHKDTA
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners evaluating the Claude Code agent starter kit need to understand how it
operates once deployed: how configuration is injected at deploy time, how agent
behavior is observed through MLflow tracing, and what security and persistence
guarantees the kit provides under the OpenShift restricted-v2 SCC. Without this
guided tour, the kit's deploy-time configuration model and security posture
remain opaque.

## Requirements

- [REQ-021] Learner MUST be able to explain that skills and MCP server configurations are injected at deploy time through a ConfigMap, so changes require a redeploy of the Kustomize manifests rather than a container image rebuild
- [REQ-022] Learner MUST be able to describe what the built-in MLflow tracing integration captures: tool calls, token usage, and agent execution traces
- [REQ-023] Learner MUST be able to observe the deployed agent pod with `oc get pods -n {guid}-{user}` when the starter kit is deployed to a shared namespace
- [REQ-024] Learner MUST be able to summarize the security and persistence guarantees: workloads run under the restricted-v2 SCC with no special security grants, and workspace storage persists across pod restarts

## Success Metrics

Learner completes all three exercises: the deploy-time configuration and
persistence walkthrough, the MLflow tracing exploration with a hypothetical
debugging scenario, and the security-posture summary.

## Risks

- Observing the agent pod depends on the facilitator having deployed the starter kit into a shared namespace; the exact pod names depend on the deployed inference path
- Modifying manifests to grant additional security contexts undermines the validated restricted-v2 security posture

## Assumptions

- Learner has completed Module 01 and understands the three validated inference paths
- The MCP gateway is an alternative routing pattern covered by the separate RHOAI MCP Catalog and MCP Gateway documentation, not by this workshop

## Related Requirements

- RHAIBU-M33D1QN2BXKW

## Verified By

- features/agents-mcp/claude-code-starter-kit/content/modules/ROOT/pages/module-02-hands-on.adoc
