---
schema_version: 1
id: RHAIBU-M33E4KAEVTR9
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must connect the OpenShell guide's five areas — deployment, identity,
model connectivity, sandbox isolation, and egress control — into one onboarding
story, and prove they can locate OpenShell-managed agents in their own
environment. This is the core deliverable of the workshop: observing a real
sandboxed agent as a Sandbox custom resource (CR) from the dashboard and the CLI.

## Requirements

- [REQ-021] Learner MUST be able to describe how Helm deployment, mTLS, and LLM provider setup connect a sandboxed agent to the platform
- [REQ-022] Learner MUST be able to explain how isolated sandboxes and controlled network egress contain the blast radius of agent actions
- [REQ-023] Learner MUST be able to locate OpenShell-managed agents as Sandbox CRs in the dashboard running agent deployments view, with name, status, and filtering per namespace
- [REQ-024] Learner SHOULD be able to observe the workloads the sandbox produces with `oc get pods -n {guid}-{user}`, identifying the agent pod alongside any supporting components

## Success Metrics

Learner completes all three exercises: the onboarding walkthrough (deployment,
mTLS identity, LLM provider), the isolation and egress review, and the
OpenShell-managed agent observation via the dashboard view plus the namespace
pod listing.

## Risks

- The dashboard view and the OpenShell CRs come from Developer Preview features; the exact console location and resource names may change between releases
- The `oc get pods` observation is an observation rather than a fixed output — pod names depend on the deployment

## Assumptions

- Learner has completed Module 01 (environment verified, guide areas identified)
- A facilitator has deployed an agent into the learner's workshop namespace for the pod observation

## Related Requirements

- RHAIBU-M33E4K9NQRNN

## Verified By

- features/agents-mcp/openshell-agent-sandboxing/content/modules/ROOT/pages/module-02-hands-on.adoc
