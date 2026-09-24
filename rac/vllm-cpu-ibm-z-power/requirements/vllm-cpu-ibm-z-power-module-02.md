---
schema_version: 1
id: RHAIBU-M33FYFXBJWZ3
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must prove the deployed model actually serves traffic on CPU-only
nodes: verify the deployment from the CLI, access the authentication token and
inference endpoint, and send OpenAI-compatible requests. This is the core
deliverable of the workshop — a working, token-authenticated inference endpoint
verified end to end.

## Requirements

- [REQ-021] Learner MUST be able to verify the deployment from the CLI: `oc get isvc` reports `Ready: True` and the predictor pod is `Running`
- [REQ-022] Learner MUST be able to retrieve the authentication token from the dashboard *Token secret* field or from the CLI via the service account secret
- [REQ-023] Learner MUST be able to send authenticated requests to the `/v1/models` and `/v1/chat/completions` endpoints with a bearer token and receive successful responses
- [REQ-024] Learner MUST observe that an unauthenticated request to the endpoint returns `401 Unauthorized`

## Success Metrics

The `InferenceService` reports `Ready: True`; the predictor pod is `Running`;
the `/v1/models` request lists the model; the chat completion request returns
generated text; unauthenticated access is rejected with `401 Unauthorized`.

## Risks

- Requests return `404` or `503` if the model status is not ready or the bearer token has expired
- Models without a predefined chat template require the `--chat-template` runtime argument for `/v1/chat/completions` queries

## Assumptions

- Learner has completed Module 01 (a deployment exists with *Model access* and *Require token authentication* enabled)

## Related Requirements

- RHAIBU-M33FYFWKTS9S

## Verified By

- features/model-serving/vllm-cpu-ibm-z-power/content/modules/ROOT/pages/module-02-hands-on.adoc
