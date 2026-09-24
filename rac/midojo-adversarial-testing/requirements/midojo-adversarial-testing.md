---
schema_version: 1
id: RHAIBU-M33DS65WF7N2
type: requirement
---
# MiDojo Adversarial Testing Engine Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with MiDojo — the man-in-the-middle adversarial testing execution
engine for AI agents, available as a Developer Preview feature — before they can
recommend or operate agentic workloads safely in production. Agent testing is
harder than model testing: an agent's behavior emerges from the tool calls it
makes, and attackers compromise the tools the agent trusts rather than talking
to the agent directly. Without a structured workshop, learners must
reverse-engineer the interception model, declarative scenario format, and
dual-axis grading scheme from release notes alone. This workshop targets RHOAI
users with working knowledge of OpenShift and model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to connect to the workshop environment and confirm they are working in their own project (`oc whoami && oc project`)
- [REQ-002] Learner MUST be able to explain MiDojo's man-in-the-middle interception model — injecting attack payloads into tool responses while forwarding legitimate calls upstream
- [REQ-003] Learner MUST be able to describe the three ingredients of a declarative MiDojo scenario: environment state, tasks, and injection vectors
- [REQ-004] Learner MUST be able to explain the dual grading axes — task completion (utility) and attack resistance (security) — and why a passing agent MUST be both resistant and still useful
- [REQ-005] Learner MUST be able to describe the building blocks of a testing session: custom external suites, the MiniBank reference suite, pluggable backends, and Kubernetes-native deployment
- [REQ-006] Learner MUST be able to compare the five agent protocols supported in this release (A2A, OGX, PI, OpenAI Responses API, Simple HTTP)
- [REQ-007] Learner MUST be able to interpret the four utility/security outcome combinations and how the full tool trace diagnoses each
- [REQ-008] Learner SHOULD be able to confirm the `oc` CLI tooling (`oc version --client`) they would use to inspect a Kubernetes-native MiDojo deployment

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the lab;
both orientation commands (`oc whoami && oc project`, `oc version --client`)
produce the documented expected output, and the learner can interpret a graded
run's utility/security result from the tool trace.

## Risks

- MiDojo is a Developer Preview feature: the deployment interface, scenario format, and protocol names may change between releases
- The lab is doc-derived (release notes only); no live MiDojo deployment exists in the workshop cluster, so no deployment exercises are possible
- Agent testing requires a model serving endpoint, which must be provisioned before any Act-phase hands-on extension

## Assumptions

- RHOAI 3.5 is installed with the RHOAI operator present
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A model serving endpoint is available for agents under test (per feature prerequisites)

## Related Designs

- RHAIBU-M33DS66E9NMS

## Related Decisions

- RHAIBU-M33DS667X337
- RHAIBU-M33DS66A6WJ4

## Related Requirements

- RHAIBU-M33DS660A058
- RHAIBU-M33DS663WN2J
