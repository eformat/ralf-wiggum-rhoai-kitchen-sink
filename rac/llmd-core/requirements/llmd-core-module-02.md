---
schema_version: 1
id: RHAIBU-M33CJ4CNZAZY
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must deploy a real LLM through the llm-d path — both via the dashboard
wizard and via the CLI — and prove it serves authenticated inference. This is the
core deliverable of the workshop: a working `LLMInferenceService` with verified
end-to-end access.

## Requirements

- [REQ-021] Learner MUST be able to deploy a model with the topology selector wizard (`Data Science Projects → Models → Deploy model → Distributed inference with llm-d`)
- [REQ-022] Learner MUST be able to apply an `LLMInferenceService` manifest (serving.kserve.io/v1alpha1) from the CLI and observe the ready condition
- [REQ-023] Learner MUST be able to make an authenticated inference request using a ServiceAccount token and receive a 200 response
- [REQ-024] Learner MUST observe that an unauthenticated request to the service returns 401

## Success Metrics

`LLMInferenceService` reaches `Ready: True`; `curl` with the ServiceAccount token
returns 200; unauthenticated access is rejected with 401.

## Risks

- The wizard topology selector is Technology Preview in 3.5
- Deployment requires available capacity matching the chosen topology and hardware profile

## Assumptions

- Learner has completed Module 01 (platform verified) and has a model location connection

## Related Requirements

- RHAIBU-M33CJ4C9MQKD

## Verified By

- features/model-serving/llmd-core/content/modules/ROOT/pages/module-02-hands-on.adoc
