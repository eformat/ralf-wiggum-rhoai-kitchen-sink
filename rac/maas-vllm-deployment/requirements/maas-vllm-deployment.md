---
schema_version: 1
id: RHAIBU-M33FK0TNTTYJ
type: requirement
---
# vLLM Deployment on MaaS Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with vLLM deployment on Models-as-a-Service — the Technology Preview
path for serving vLLM-based models behind the shared MaaS governance layer —
before they can recommend or operate it in production. Without a structured
workshop, learners must reverse-engineer the feature flag, the wizard's
vLLM deployment-resource option, and the subscription/authorization-policy
governance model from product documentation alone. This workshop targets RHOAI
users with working knowledge of OpenShift and model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster (`oc whoami` returns the workshop username) and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to enable the `modelAsService` and `vLLMDeploymentOnMaaS` dashboard flags via an `OdhDashboardConfig` merge patch and confirm the re-read value is `true`
- [REQ-003] Learner MUST be able to verify the MaaS platform is enabled (`kserve.managementState` and `modelsAsService.managementState` both `Managed`)
- [REQ-004] Learner MUST be able to verify the `maas-default-gateway` exists in `openshift-ingress` and the `maas-controller` pods report `Running` with a ready count of `1/1` or more
- [REQ-005] Learner MUST be able to deploy a vLLM-based model through the dashboard wizard (vLLM NVIDIA CUDA GPU LLMInferenceServiceConfig deployment resource, Publish as MaaS) and confirm the `MaaSModelRef` was created and the `LLMInferenceService` shows `READY: True`
- [REQ-006] Learner MUST be able to grant group access with a `MaaSSubscription` and a `MaaSAuthPolicy` and confirm the controller generated the per-model `AuthPolicy` and `TokenRateLimitPolicy` in the model namespace
- [REQ-007] Learner MUST be able to create a subscription-bound MaaS API key and call the OpenAI-compatible MaaS endpoint, receiving an HTTP 200 completion body
- [REQ-008] Learner SHOULD observe that a request with an invalid API key is rejected with `401` or `403`

## Success Metrics

All seven MUST criteria are demonstrated by the learner during the lab; the
`LLMInferenceService` reaches `READY: True` in module 02, the governed `curl`
request returns HTTP 200, and the negative test returns `401`/`403`.

## Risks

- The vLLM deployment on MaaS feature flag and vLLM-based LLMInferenceServiceConfig resources are Technology Preview in 3.5 and may change between releases
- Workshop cluster requires the MaaS prerequisites (Connectivity Link Operator 1.4.x with a ready Kuadrant CR, llm-d authentication enabled) and a hardware profile with at least one NVIDIA GPU
- `OdhDashboardConfig` patching and group creation require cluster administrator access; on shared clusters the facilitator must perform or approve these steps

## Assumptions

- RHOAI 3.5 is installed with MaaS prerequisites and operators in place
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`, `%password%`-style placeholders only)
- A model storage connection with the model path (`facebook/opt-125m`) is available

## Related Designs

- RHAIBU-M33FK0WJE0RE

## Related Decisions

- RHAIBU-M33FK0VTD0NN
- RHAIBU-M33FK0W7371K

## Related Requirements

- RHAIBU-M33FK0V2M8PC
- RHAIBU-M33FK0VDA7NX
