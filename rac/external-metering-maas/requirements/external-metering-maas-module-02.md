---
schema_version: 1
id: RHAIBU-M33D2G75GA1N
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must connect the two BBR plugins to a concrete request lifecycle —
credit check before inference, asynchronous usage webhook after — and inspect
the gateway quota layer the MaaS controller generates. This is the core
deliverable of the workshop: a traced metered request with every token usage
event field identified and the generated policies observed in the cluster.

## Requirements

- [REQ-021] Learner MUST be able to trace a metered request through the pre-inference credit check, model processing, and post-inference token usage webhook stages
- [REQ-022] Learner MUST be able to identify the six fields of the emitted token usage event: requester identity, subscription, model, input and output token counts, request ID, and timestamp
- [REQ-023] Learner MUST be able to list the generated policies with `oc get authpolicy -n {guid}-{user}` and `oc get tokenratelimitpolicy -n {guid}-{user}` and expect one AuthPolicy and TokenRateLimitPolicy per published model
- [REQ-024] Learner SHOULD observe the documented behavior that failed webhook delivery attempts are logged for alerting and recovery

## Success Metrics

Learner completes both exercises: the metered-request lifecycle walkthrough
naming every event payload field, and the generated-policy listing commands
producing output that matches the documented controller behavior.

## Risks

- Listing generated policies requires a published model in the working project; if policies are missing, the MaaS controller logs must be checked
- No live external metering endpoint exists in the workshop, so webhook delivery is observed conceptually

## Assumptions

- Learner has completed Module 01 (MaaS foundation verified)

## Related Requirements

- RHAIBU-M33D2G6HM38A

## Verified By

- features/agents-mcp/external-metering-maas/content/modules/ROOT/pages/module-02-hands-on.adoc
