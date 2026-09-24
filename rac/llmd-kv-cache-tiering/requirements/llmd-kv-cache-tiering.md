---
schema_version: 1
id: RHAIBU-M33DDPJHFZQQ
type: requirement
---
# Hierarchical KV Cache Tiering with llm-d Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with Hierarchical KV Cache Tiering — the Developer Preview capability
that lets operators serve more concurrent users on the same GPU footprint —
before they can recommend or operate cache-aware llm-d serving in production.
Without a structured workshop, learners must reverse-engineer the llm-d Endpoint
Picker layers, the default 4-scorer scheduler profile, KV-cache-aware router
configurations, and the `llm_d_epp_` metrics surface from product documentation
alone. This workshop targets RHOAI users with working knowledge of OpenShift and
model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to explain how hierarchical KV cache tiering increases effective cache size and prefix-cache reuse, and who configures the tiers versus who places cache entries on them
- [REQ-002] Learner MUST be able to map the llm-d Endpoint Picker Flow Control and Scheduling layers and the default 2:2:3:2 scorer profile
- [REQ-003] Learner MUST be able to confirm the llm-d serving stack is available with read-only `oc get llmisvc` and `oc get llminferenceserviceconfig -A` commands
- [REQ-004] Learner MUST be able to name the label, annotation, and heaviest-weighted scorer that make a router configuration KV-cache-aware
- [REQ-005] Learner MUST be able to apply a KV-cache-aware router configuration through the model deployment wizard and verify it in `spec.baseRefs` on the deployed model
- [REQ-006] Learner MUST be able to observe `llm_d_epp_` cache metrics (prefix indexer hit ratio, average KV cache utilization) moving in the documented direction during repeated inference requests

## Success Metrics

All six acceptance criteria are demonstrated by the learner during the lab; a
router configuration applied in module 02 appears in the generated
`LLMInferenceService` `spec.baseRefs`, and at least one `llm_d_epp_` cache
metric moves in the direction the docs describe during Exercise 3.

## Risks

- Hierarchical KV Cache Tiering is a Developer Preview feature in 3.5 and may change between releases
- KV-cache-aware router configurations must be pre-created by an administrator with the `llmdTemplates` feature flag enabled; if none exist, module 02 falls back to default routing
- Which `llm_d_epp_` metrics are scraped into the cluster monitoring stack depends on workshop configuration

## Assumptions

- RHOAI 3.5 is installed with the Distributed Inference with llm-d component enabled
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A model deployment exists or can be created for the router-attachment and metrics exercises

## Related Designs

- RHAIBU-M33DDPKV0HZV

## Related Decisions

- RHAIBU-M33DDPKAQ0PF
- RHAIBU-M33DDPKJV4C3

## Related Requirements

- RHAIBU-M33DDPJS2ZZW
- RHAIBU-M33DDPK13SJK
