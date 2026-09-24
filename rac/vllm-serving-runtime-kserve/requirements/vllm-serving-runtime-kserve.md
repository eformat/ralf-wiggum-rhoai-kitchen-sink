---
schema_version: 1
id: RHAIBU-M33FYP394X0S
type: requirement
---
# vLLM ServingRuntime for KServe Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with the vLLM ServingRuntime for KServe — the GA runtime path for
serving generative AI models on the single-model serving platform — before they
can recommend or operate it in production. Without a structured workshop,
learners must reverse-engineer the `ServingRuntime`/`InferenceService` CRD
pairing, the dashboard enablement flow, and OpenAI-compatible inference
requests from product documentation alone. This workshop targets RHOAI users
with working knowledge of OpenShift and model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to enable the model serving platform and the vLLM ServingRuntime for KServe from the dashboard and confirm the runtime is listed by `oc get servingruntimes -n redhat-ods-applications`
- [REQ-003] Learner MUST be able to verify the vLLM runtime advertises the `vLLM` model format with `autoSelect: true` via `oc get servingruntime vll-runtime -o jsonpath`
- [REQ-004] Learner MUST be able to deploy a generative AI model through the Deploy model wizard and confirm the `InferenceService` reaches `READY: True`
- [REQ-005] Learner MUST be able to inspect the generated `InferenceService` CR and map its fields (`modelFormat`, `runtime`, `storage`, GPU resources) to their wizard choices
- [REQ-006] Learner MUST be able to make an authenticated inference request to `/v1/chat/completions` with a bearer token and receive an OpenAI-compatible 200 response
- [REQ-007] Learner SHOULD be able to verify the served model with `/v1/models` and the vLLM version with `/version` on the inference endpoint

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the `InferenceService` reaches `Ready: True` in module 02 and authenticated
`curl` requests to `/v1/chat/completions` return 200 with a `choices` array.

## Risks

- The vLLM runtime requires GPU support enabled and the Node Feature Discovery Operator configured; workshop clusters without GPU capacity cannot run module 02
- The model storage connection must point to S3-compatible object storage holding a gen AI model (for example, `granite-7b-instruct`)
- Dashboard menu paths (`Settings → Cluster settings`, `Settings → Model resources and operations`) may shift between RHOAI releases

## Assumptions

- RHOAI 3.5 is installed with the RHOAI operator and KServe available
- Learners have `oc` CLI access, dashboard administrator privileges for enablement, and workshop credentials (`{user}`, `{guid}`)
- An NVIDIA GPU hardware profile and an S3-compatible model connection are pre-provisioned

## Related Designs

- RHAIBU-M33FYP4HS0VV

## Related Decisions

- RHAIBU-M33FYP431FHD
- RHAIBU-M33FYP4AP4JE

## Related Requirements

- RHAIBU-M33FYP3JWJCF
- RHAIBU-M33FYP3TSTNF
