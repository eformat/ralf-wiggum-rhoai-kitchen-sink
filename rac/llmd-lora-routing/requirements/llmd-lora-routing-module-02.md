---
schema_version: 1
id: RHAIBU-M33DE6QZY0YJ
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must walk the advanced routing deployment workflow end to end and
prove they can observe adapter-aware routing behavior: the EPP request metrics
that carry adapter identity, the routing references attached to a deployment,
and the warm-up versus fallback behavior that keeps requests completing. This
is the core deliverable of the workshop: a working deployment with verified
`spec.baseRefs` and observed `llm_d_epp_` metrics.

## Requirements

- [REQ-021] Learner MUST be able to name the label pair (`model_name`, `target_model_name`) that distinguishes adapter-targeted requests, the metric expected to drop for adapter-loaded pods (`llm_d_epp_request_ttft_seconds`), and the `GroupDegraded`/`MemberDivergence` condition set when group members serve different adapter sets
- [REQ-022] Learner MUST be able to walk the advanced routing workflow of the model deployment wizard (Default optimized routing default, topology-filtered router configuration list) and confirm the deployment reaches `Ready` status
- [REQ-023] Learner MUST be able to verify the routing configuration references on the deployment with `oc get llmisvc -n {guid}-{user} -o yaml | grep -A 6 baseRefs` — topology preset first, then any selected router configuration
- [REQ-024] Learner MUST observe at least one `llm_d_epp_` request metric (`llm_d_epp_request_total` or `llm_d_epp_request_ttft_seconds`) after sending repeated inference requests

## Success Metrics

Deployed model reaches `Ready` status; `spec.baseRefs` lists the routing
configuration references; repeated requests produce observable
`llm_d_epp_` request metrics with warm-up and fallback behavior interpreted.

## Risks

- No router configuration appears in the wizard if the administrator has not created compatible router `LLMInferenceServiceConfig` resources
- Which metrics are scraped into the monitoring stack depends on workshop configuration; the EPP metrics endpoint may need facilitator guidance

## Assumptions

- Learner has completed Module 01 (llm-d serving resources verified)
- vLLM parameters (`--gpu-memory-utilization`) shape warm-up behavior if tuning is needed

## Related Requirements

- RHAIBU-M33DE6QRF0A2

## Verified By

- features/agents-mcp/llmd-lora-routing/content/modules/ROOT/pages/module-02-hands-on.adoc
