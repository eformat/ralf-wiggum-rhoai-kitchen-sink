---
schema_version: 1
id: RHAIBU-M33CJ4C9MQKD
type: requirement
---
# Distributed Inference with llm-d Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with Distributed Inference using llm-d — the GA model-serving path for
large language models — before they can recommend or operate it in production.
Without a structured workshop, learners must reverse-engineer the topology
patterns, LLMInferenceService API, and routing configuration from product
documentation alone. This workshop targets RHOAI users with working knowledge of
OpenShift and model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify the model-serving platform is enabled (`kserve.managementState: Managed`) and the `openshift-ai-inference` Gateway is `PROGRAMMED: True`
- [REQ-003] Learner MUST be able to deploy a model using the topology selector wizard, choosing the `single-node-default` topology
- [REQ-004] Learner MUST be able to deploy a model from the CLI with an `LLMInferenceService` manifest and confirm the ready condition
- [REQ-005] Learner MUST be able to make authenticated inference requests via a ServiceAccount token and receive a 200 response
- [REQ-006] Learner SHOULD be able to apply advanced routing to a deployment via `baseRefs` and verify the merged configuration
- [REQ-007] Learner SHOULD be able to manage llm-d topology and router configuration templates from the dashboard settings

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab; the
`LLMInferenceService` reaches `Ready: True` in modules 02–03 and authenticated
`curl` requests return 200.

## Risks

- The topology selector wizard portion is Technology Preview in 3.5 and may change between releases
- Workshop cluster must have the Distributed Inference (llm-d) component enabled in the DSC
- Router and topology configuration templates must be pre-provisioned for module 03 exercises

## Assumptions

- RHOAI 3.5 is installed with the model-serving platform enabled
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A model location (S3/URI/OCI/PVC connection) is available for deployment

## Related Designs

- RHAIBU-M33CJ4D7HQXC

## Related Decisions

- RHAIBU-M33CJ4CX4WMJ
- RHAIBU-M33CJ4D22D76

## Related Requirements

- RHAIBU-M33CJ4CETEWH
- RHAIBU-M33CJ4CNZAZY
- RHAIBU-M33CJ4CRNZ3N
