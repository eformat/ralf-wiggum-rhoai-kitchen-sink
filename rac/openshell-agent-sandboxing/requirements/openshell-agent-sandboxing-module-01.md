---
schema_version: 1
id: RHAIBU-M33E4KA1ZS6N
type: requirement
---
# Module 01: Getting Started

## Problem

Before observing OpenShell-managed agents on a cluster, learners need a mental
model of what OpenShell is, the three surfaces it restricts (system calls, network
access, tool availability), and how its sandbox-level enforcement relates to other
RHOAI security layers. Because this is a Developer Preview documented in release
notes and a guide, this module is a guided tour — without the orientation, later
observations are copy-paste with no understanding of what is being observed.

## Requirements

- [REQ-011] Learner MUST be able to verify they are connected to their workshop environment and working in their own project (`oc whoami && oc project`)
- [REQ-012] Learner MUST be able to name the three surfaces OpenShell restricts for AI agents: system calls, network access, and tool availability
- [REQ-013] Learner MUST be able to identify the five areas the included OpenShell guide covers: Helm deployment, mTLS, LLM provider setup, isolated sandboxes, and controlled network egress
- [REQ-014] Learner SHOULD be able to describe how OpenShell's sandbox-level enforcement complements tool-call enforcement with guardrails such as NeMo Guardrails integrated with the MCP gateway

## Success Metrics

Learner completes both exercises: the guided tour of what OpenShell provides
(three enforcement surfaces) and the guide-coverage walkthrough (five areas table),
each anchored by the environment-verification command producing the documented
output.

## Risks

- The preview uses upstream artifacts; the release notes' pointer to the agent-ops GitHub repository may change between releases

## Assumptions

- Learner has completed Getting Connected (cluster login, working project, RHOAI dashboard)

## Related Requirements

- RHAIBU-M33E4K9NQRNN

## Verified By

- features/agents-mcp/openshell-agent-sandboxing/content/modules/ROOT/pages/module-01-getting-started.adoc
