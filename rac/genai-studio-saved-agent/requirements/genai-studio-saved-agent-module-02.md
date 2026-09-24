---
schema_version: 1
id: RHAIBU-M33D7MQK3J4Q
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must work through the saved-agent workflow end to end — configure a
playground, save it as a named agent, load it back into a fresh session, and
manage it while iterating. This is the core deliverable of the workshop: a
named, reusable agent with a verified save/load/manage cycle.

## Requirements

- [REQ-021] Learner MUST be able to save a configured playground as a named agent and observe the agent name in the playground header and the agent on the Agents tab
- [REQ-022] Learner MUST be able to load a saved agent from the playground header menu or via Try in Playground and observe that the model, inference parameters, prompt, knowledge source, and MCP server settings match the saved agent
- [REQ-023] Learner MUST be able to create a variant copy with Save as new agent and observe that the original agent remains unchanged
- [REQ-024] Learner MUST be able to rename/edit an agent and delete an agent from the Agents tab, and clear the loaded agent from the playground

## Success Metrics

The agent name is displayed in the playground header and listed on the Agents
tab after the save; a loaded agent restores all captured settings; the updated
agent list reflects the variant, rename, and delete operations.

## Risks

- Saved agents is a Developer Preview feature in 3.5; dialog labels may change between releases
- Loading an agent can surface warnings for referenced resources that have been deleted or become unavailable
- Deleting an agent is destructive with no undo; a conflict warning appears if another user modified the agent

## Assumptions

- Learner has completed Module 01 (flag enabled, UI located)
- A playground is configured with at least one model and the MLflow service is available

## Related Requirements

- RHAIBU-M33D7MQ4CZCB

## Verified By

- features/agents-mcp/genai-studio-saved-agent/content/modules/ROOT/pages/module-02-hands-on.adoc
