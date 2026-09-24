---
schema_version: 1
id: RHAIBU-M33FYP3TSTNF
type: requirement
---
# Module 02: Deploy a model with the vLLM ServingRuntime

## Problem

Learners must deploy a real generative AI model through the Deploy model
wizard with the vLLM ServingRuntime for KServe and prove it serves
OpenAI-compatible inference. This is the core deliverable of the workshop: a
working `InferenceService` whose generated CR maps back to the wizard choices,
validated end to end with authenticated requests.

## Requirements

- [REQ-021] Learner MUST be able to deploy a generative AI model through the Deploy model wizard (S3 model connection, *Generative AI model* type, NVIDIA GPU hardware profile, *vLLM ServingRuntime for KServe* runtime, token authentication enabled)
- [REQ-022] Learner MUST be able to confirm the deployed model with `oc get inferenceservice -n {guid}-{user}` showing `READY: True` and inspect the generated `InferenceService` CR (`serving.kserve.io/v1beta1`) to map `modelFormat`, `runtime`, and `storage` fields to wizard choices
- [REQ-023] Learner MUST be able to make an authenticated request to `/v1/chat/completions` with the `Authorization: Bearer $TOKEN` header and receive an OpenAI-compatible JSON response with HTTP 200 containing a `choices` array
- [REQ-024] Learner SHOULD be able to verify the served model with `/v1/models` (JSON listing of the deployed model name) and the engine version with `/version`

## Success Metrics

`InferenceService` reaches `Ready: True`; `/v1/models` lists the deployed
model; `curl` with the bearer token to `/v1/chat/completions` returns 200 with
a `choices` array whose `message.content` holds the model's answer.

## Risks

- Deployment requires an available NVIDIA GPU matching the chosen hardware profile
- As of vLLM v0.5.5, `/v1/chat/completions` requires a chat template; models without a predefined template need the `--chat-template` parameter in a custom runtime
- Unexpected `403`/`401` responses indicate a missing or expired token

## Assumptions

- Learner has completed Module 01 (platform and runtime enabled) and has a model storage connection in the project

## Related Requirements

- RHAIBU-M33FYP394X0S

## Verified By

- features/model-serving/vllm-serving-runtime-kserve/content/modules/ROOT/pages/module-02-hands-on.adoc
