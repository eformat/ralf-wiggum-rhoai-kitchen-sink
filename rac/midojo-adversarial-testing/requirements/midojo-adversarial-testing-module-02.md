---
schema_version: 1
id: RHAIBU-M33DS663WN2J
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must understand the building blocks of a real MiDojo testing session —
suites, backends, protocols — and be able to interpret a graded run before they
can author their own adversarial scenarios. This is the core deliverable of the
workshop: reading the four utility/security outcome combinations from the full
tool trace.

## Requirements

- [REQ-021] Learner MUST be able to describe the building blocks of a testing session: custom external suites, the reference MiniBank suite, pluggable backends, and Kubernetes-native deployment
- [REQ-022] Learner MUST be able to list the five agent protocols supported in this release (A2A, OGX, PI, OpenAI Responses API, Simple HTTP)
- [REQ-023] Learner MUST be able to interpret the four utility/security outcome combinations (pass/pass, pass/fail, fail/pass, fail/fail) and what each means
- [REQ-024] Learner SHOULD be able to confirm the `oc` CLI client version (`oc version --client`) used to inspect a future Kubernetes-native MiDojo deployment

## Success Metrics

Learner completes both exercises: the building-blocks and protocol tour, and
the graded-run interpretation walkthrough with the four-outcome table, each
producing the documented expected output.

## Risks

- The protocol names and suite format come from the RHOAI 3.5 release notes and may change between releases
- No live MiDojo deployment exists in the workshop cluster, so the graded-run reading is descriptive rather than observed

## Assumptions

- Learner has completed Module 01 (interception model and grading axes) and Getting Connected

## Related Requirements

- RHAIBU-M33DS65WF7N2

## Verified By

- features/agents-mcp/midojo-adversarial-testing/content/modules/ROOT/pages/module-02-hands-on.adoc
