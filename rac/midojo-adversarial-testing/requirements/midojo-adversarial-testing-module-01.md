---
schema_version: 1
id: RHAIBU-M33DS660A058
type: requirement
---
# Module 01: Getting Started

## Problem

Because MiDojo is a Developer Preview feature, learners first need a mental
model of what the engine does, why it intercepts agents at the tool layer, and
how a declarative scenario is graded on utility and security. Without this
orientation, later descriptions of suites, backends, and protocols are
copy-paste with no understanding of what a testing session actually measures.

## Requirements

- [REQ-011] Learner MUST be able to verify workshop connectivity and namespace isolation with `oc whoami && oc project`
- [REQ-012] Learner MUST be able to name MiDojo's five documented capabilities: tool-layer interception, testing without modifying the agent, declarative YAML scenarios, full tool trace recording, and Kubernetes-native deployment
- [REQ-013] Learner MUST be able to identify the three scenario ingredients (environment state, tasks, injection vectors) and where payloads can be delivered (prompts, data sources, tool responses)
- [REQ-014] Learner MUST be able to explain the utility and security grades and why a passing agent MUST be both resistant and still useful

## Success Metrics

Learner completes both exercises: the MiDojo capability walkthrough and the
scenario-anatomy and grading tour, each producing the documented expected
output (the connectivity command confirms user and project).

## Risks

- This module is a guided tour, not a deployment walkthrough — on a live cluster the deployment steps do not exist yet

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33DS65WF7N2

## Verified By

- features/agents-mcp/midojo-adversarial-testing/content/modules/ROOT/pages/module-01-getting-started.adoc
