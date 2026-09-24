---
schema_version: 1
id: RHAIBU-M33D1QN2BXKW
type: requirement
---
# Claude Code Agent Starter Kit Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with the Claude Code agent starter kit — a Developer Preview feature
that deploys and configures the Anthropic Claude Code agent on OpenShift AI from
a pre-configured Containerfile and Kustomize manifests — before they can
recommend it for agentic workflows. Because the feature is a Developer Preview,
the deployment interface may change between releases, so learners need a
structured guided tour that teaches the kit's capabilities and trade-offs
without fabricating commands. This workshop targets RHOAI users with working
knowledge of OpenShift.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster with workshop credentials and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify their workshop connection (`oc whoami` shows the username and `oc project` shows the working project)
- [REQ-003] Learner MUST be able to name the six capabilities of the starter kit: pre-configured Containerfile + Kustomize deployment, three validated inference paths, built-in MLflow tracing, ConfigMap-based skill and MCP injection, persistent workspace storage, and restricted-v2 SCC security
- [REQ-004] Learner MUST be able to compare the three validated inference paths (direct Anthropic API, self-hosted models through vLLM, vLLM through the OGX gateway) and choose the correct path for a given environment
- [REQ-005] Learner MUST be able to explain how skills and MCP server configurations are injected at deploy time through a ConfigMap without rebuilding container images
- [REQ-006] Learner MUST be able to describe what the built-in MLflow tracing integration captures: tool calls, token usage, and agent execution traces
- [REQ-007] Learner MUST be able to summarize the security and persistence guarantees: workloads run under the OpenShift restricted-v2 SCC with no special security grants, and workspace storage is maintained across pod restarts

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the guided
tour; the connectivity checks in the Getting Connected bookend produce the
documented expected output (`oc whoami`, `oc project`), and the learner correctly
maps each inference-path choice to an environment with or without Anthropic API
access.

## Risks

- The feature is Developer Preview in 3.5 and its deployment interface may change between releases
- Only the direct Anthropic path requires Anthropic API access; the vLLM-based paths depend on self-hosted model infrastructure
- Observing the deployed agent pod (module 02) depends on the facilitator having deployed the starter kit into a shared namespace

## Assumptions

- RHOAI 3.5 is installed via the RHOAI operator
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A facilitator-deployed starter kit is available for pod observation in module 02

## Related Designs

- RHAIBU-M33D1QPAYPCZ

## Related Decisions

- RHAIBU-M33D1QNS8TAD
- RHAIBU-M33D1QNZ62QC

## Related Requirements

- RHAIBU-M33D1QNAV38F
- RHAIBU-M33D1QNHKDTA
