---
schema_version: 1
id: RHAIBU-M33FK0VDA7NX
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must deploy a real LLM with a vLLM-based deployment resource, publish
it to MaaS, govern access with a subscription and an authorization policy, and
prove the governed endpoint serves inference. This is the core deliverable of
the workshop: a published `MaaSModelRef`, generated gateway policies, and a
verified end-to-end API-key-authenticated call.

## Requirements

- [REQ-021] Learner MUST be able to deploy a model through the dashboard wizard selecting the `vLLM NVIDIA CUDA GPU LLMInferenceServiceConfig` deployment resource and `Publish as MaaS` model availability, with the legacy deployment method unchecked
- [REQ-022] Learner MUST be able to confirm the model shows a checkmark on the Deployments tab, a `MaaSModelRef` exists in the project (`oc get maasmodelref`), and the underlying `LLMInferenceService` shows `READY: True`
- [REQ-023] Learner MUST be able to apply a `MaaSSubscription` and a `MaaSAuthPolicy` (maas.opendatahub.io/v1alpha1) and confirm the controller generated per-model `AuthPolicy` and `TokenRateLimitPolicy` resources in the model namespace
- [REQ-024] Learner MUST be able to create a MaaS API key bound to the workshop subscription and call the OpenAI-compatible endpoint `/llm/<deployment>/v1/chat/completions`, receiving HTTP 200
- [REQ-025] Learner MUST observe that a request with an invalid API key returns `401` or `403`

## Success Metrics

`LLMInferenceService` reaches `READY: True`; the gateway policies are generated;
`curl` with the subscription-bound API key returns HTTP 200; the invalid-key
negative test returns `401` or `403`.

## Risks

- The vLLM-based LLMInferenceServiceConfig deployment resources are Technology Preview and not supported with Red Hat production SLAs
- Deployment requires a hardware profile with at least one NVIDIA GPU and available capacity
- A `MaaSAuthPolicy` without a `MaaSSubscription` yields `429 Too Many Requests`; a `MaaSSubscription` without a `MaaSAuthPolicy` yields `403 Forbidden` — both resources are required

## Assumptions

- Learner has completed Module 01 (flags enabled, platform verified) and has a model storage connection

## Related Requirements

- RHAIBU-M33FK0TNTTYJ

## Verified By

- features/maas/maas-vllm-deployment/content/modules/ROOT/pages/module-02-hands-on.adoc
