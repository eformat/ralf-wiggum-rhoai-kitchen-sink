---
schema_version: 1
id: RHAIBU-M33D7MQCQJYN
type: requirement
---
# Module 01: Getting Started

## Problem

Before using saved agents, learners need to know what a saved agent captures
(and what it does not), enable the `agentConfigManagement` dashboard feature
flag, and locate the two UI entry points. Without this orientation, later
hands-on steps are copy-paste with no understanding of how the feature is
gated and where agents live.

## Requirements

- [REQ-011] Learner MUST be able to observe the current state of the `agentConfigManagement` and `genAiStudio` flags with `oc get odhdashboardconfig odh-dashboard-config -n redhat-ods-applications -o jsonpath`
- [REQ-012] Learner MUST be able to patch `agentConfigManagement: true` into the `OdhDashboardConfig` custom resource and verify the jsonpath output is `true`
- [REQ-013] Learner MUST be able to observe the agent actions (Save agent, Load agent, Save as new agent, Clear agent) in the playground header menu
- [REQ-014] Learner MUST be able to open the Agents tab under Gen AI studio → AI asset endpoints without error

## Success Metrics

Learner completes all three exercises: the dashboard-config inspection, the
feature-flag patch with verified output, and the saved-agent UI walkthrough,
each producing the documented expected output.

## Risks

- The flag patch requires cluster administrator privileges
- Dashboard menu items may not appear until the browser cache is cleared and the dashboard hard-refreshed

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- Gen AI Studio is enabled on the cluster (`genAiStudio: true`)

## Related Requirements

- RHAIBU-M33D7MQ4CZCB

## Verified By

- features/agents-mcp/genai-studio-saved-agent/content/modules/ROOT/pages/module-01-getting-started.adoc
