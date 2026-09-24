---
schema_version: 1
id: RHAIBU-M33E4K9NQRNN
type: requirement
---
# OpenShell (Secure Agent Sandboxing and Policy Enforcement) Workshop

## Problem

Platform engineers and security-minded RHOAI users evaluating RHOAI 3.5 need to
understand how OpenShell — a Developer Preview feature for secure agent onboarding
on OpenShift — sandboxes AI agents with policy-controlled restrictions on system
calls, network access, and tool availability before they can adopt it or pair it
with the platform's other security layers. Because the preview is documented
primarily in release notes and a guide covering five areas, learners need a
structured guided tour that connects the concepts to their own cluster without
fabricated deployment steps. This workshop targets RHOAI users with working
knowledge of OpenShift and AI agent concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and confirm their identity and working project (`oc whoami`, `oc project` after `oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to open the OpenShift console and reach the RHOAI dashboard from the application launcher
- [REQ-003] Learner MUST be able to explain what OpenShell is and name the three surfaces it restricts for AI agents: system calls, network access, and tool availability
- [REQ-004] Learner MUST be able to identify the five areas the included OpenShell guide covers: Helm deployment, mTLS, LLM provider setup, isolated sandboxes, and controlled network egress
- [REQ-005] Learner SHOULD be able to describe how OpenShell's sandbox-level enforcement complements other RHOAI security layers such as guardrails on MCP gateway tool calls
- [REQ-006] Learner MUST be able to locate OpenShell-managed agents as Sandbox custom resources (CRs) in the dashboard running agent deployments view, with name, status, and filtering per namespace
- [REQ-007] Learner SHOULD be able to observe the workloads a deployed sandbox produces in their namespace with `oc get pods -n {guid}-{user}`

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab:
environment connectivity verified in Getting Connected and module 01, the guided
tour of the three enforcement surfaces and five guide areas completed, and the
Sandbox CR observation (dashboard view plus `oc get pods`) performed in module 02.

## Risks

- OpenShell is a Developer Preview using upstream artifacts — commands, chart values, and resource names may change or be removed between releases
- The dashboard running-agent-deployments view comes from a related Developer Preview feature and its console location may change
- Module 02's pod observation requires a facilitator-deployed agent in the learner's namespace

## Assumptions

- RHOAI 3.5 is installed (RHOAI operator installed) on an OpenShift cluster
- An agent deployment exists or can be deployed by the facilitator (agents deployed manually appear as OpenShell-managed Sandbox CRs)
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)

## Related Designs

- RHAIBU-M33E4KBMZRSR

## Related Decisions

- RHAIBU-M33E4KATYVRC
- RHAIBU-M33E4KB7Z2FV

## Related Requirements

- RHAIBU-M33E4KA1ZS6N
- RHAIBU-M33E4KAEVTR9
