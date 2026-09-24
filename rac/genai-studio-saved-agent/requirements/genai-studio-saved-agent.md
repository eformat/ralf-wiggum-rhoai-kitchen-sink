---
schema_version: 1
id: RHAIBU-M33D7MQ4CZCB
type: requirement
---
# Gen AI Studio Saved Agents Workshop

## Problem

ML practitioners and platform engineers evaluating RHOAI 3.5 need hands-on
experience with saved agents in Gen AI Studio — configuration persistence for
the gen AI playground — before they can recommend or operate agent
configurations for their teams. Without a structured workshop, learners must
reverse-engineer the `agentConfigManagement` dashboard flag, the saved-agent UI
entry points, and the save/load/manage workflow from product documentation
alone. This workshop targets RHOAI users with working knowledge of OpenShift
and the gen AI playground.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to observe the current state of the `agentConfigManagement` and `genAiStudio` dashboard flags on the `OdhDashboardConfig` custom resource
- [REQ-003] Learner MUST be able to enable the `agentConfigManagement` feature flag by patching `OdhDashboardConfig` and verify the flag reads `true`
- [REQ-004] Learner MUST be able to locate the saved-agent UI in the playground header menu and on the Agents tab under Gen AI studio → AI asset endpoints
- [REQ-005] Learner MUST be able to save a configured playground as a named agent and see the agent in the playground header and on the Agents tab
- [REQ-006] Learner MUST be able to load a saved agent from the playground header menu or via Try in Playground and observe that all captured settings are restored
- [REQ-007] Learner MUST be able to create a variant copy with Save as new agent, rename/edit an agent, delete an agent, and clear the loaded agent

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the `agentConfigManagement` flag reads `true` after the patch in module 01, and
the Agents tab reflects the save, variant, rename, and delete operations from
module 02.

## Risks

- Saved agents is a Developer Preview feature in 3.5 and may change or be removed between releases
- Enabling the flag requires cluster administrator privileges on the `OdhDashboardConfig` custom resource
- The saved-agent Kubernetes resource kind is not named in the docs, so CLI discovery steps may vary between releases

## Assumptions

- RHOAI 3.5 is installed with Gen AI Studio enabled (`genAiStudio: true`)
- Learners have `oc` CLI access, workshop credentials (`{user}`, `{guid}`), and cluster admin privileges for the flag patch
- A playground with at least one model is available, and the MLflow service is reachable in the project (saved agents reference MLflow prompts)

## Related Designs

- RHAIBU-M33D7MRCHKPS

## Related Decisions

- RHAIBU-M33D7MQWDZ3H
- RHAIBU-M33D7MR456VK

## Related Requirements

- RHAIBU-M33D7MQCQJYN
- RHAIBU-M33D7MQK3J4Q
