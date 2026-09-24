---
schema_version: 1
id: RHAIBU-M33DE6QRF0A2
type: requirement
---
# LoRA-aware Routing for llm-d Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with LoRA-aware routing for llm-d — the Developer Preview capability
that routes inference requests to pods where the target LoRA adapter is already
loaded — before they can recommend or operate multi-adapter model serving in
production. Without a structured workshop, learners must reverse-engineer the
Endpoint Picker metrics, the routing-group partitioning behavior, and the
advanced routing wizard workflow from product documentation alone. This
workshop targets RHOAI users with working knowledge of OpenShift and model
serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to explain why a request pays cold-load latency when it lands on a pod without the target adapter, what happens when no pod with the adapter is available (fallback to standard routing), and which llm-d serving stack owns the routing decision
- [REQ-002] Learner MUST be able to locate the `llm-d routing configurations` and `llm-d topology configurations` pages under the dashboard Settings menu
- [REQ-003] Learner MUST be able to run read-only `oc` commands (`oc get llmisvc`, `oc get llminferenceserviceconfig -A`) without errors and locate the Advanced routing section of the model deployment wizard
- [REQ-004] Learner MUST be able to name the `model_name`/`target_model_name` label pair that distinguishes adapter-targeted requests, the metric expected to drop for adapter-loaded pods, and the `GroupDegraded`/`MemberDivergence` condition
- [REQ-005] Learner MUST be able to complete a model deployment that reaches `Ready` status and verify the routing configuration references in `spec.baseRefs`
- [REQ-006] Learner SHOULD be able to send repeated inference requests and observe at least one `llm_d_epp_` request metric (total request counts and TTFT distribution respond immediately)

## Success Metrics

All six acceptance criteria are demonstrated by the learner during the lab; the
deployed model reaches `Ready` status in module 02 with `spec.baseRefs`
verified, and at least one `llm_d_epp_` request metric is observed after
repeated inference requests.

## Risks

- LoRA-aware request routing is Developer Preview in 3.5 and may change between releases
- Workshop cluster must have the Distributed Inference (llm-d) component enabled in the DSC
- The 3.5 documentation covers LoRA-aware routing only as a release notes entry — there is no dedicated configuration procedure chapter for it yet, so the lab is a guided tour of the routing surfaces it builds on
- Router configuration availability depends on administrator-created router `LLMInferenceServiceConfig` resources

## Assumptions

- RHOAI 3.5 is installed with Distributed Inference with llm-d enabled
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- Learners have completed Getting Connected (cluster login, working project)

## Related Designs

- RHAIBU-M33DE6RH8Z20

## Related Decisions

- RHAIBU-M33DE6R5ED69
- RHAIBU-M33DE6RB6AAK

## Related Requirements

- RHAIBU-M33DE6QWQY7X
- RHAIBU-M33DE6QZY0YJ
