---
schema_version: 1
id: RHAIBU-M33FDJ5XH0SY
type: requirement
---
# MaaS Deployment/Routing Path for Distributed Inference with llm-d Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience serving generative models through the MaaS deployment/routing path
for Distributed Inference with llm-d — a Technology Preview feature that
combines the llm-d serving path with subscription-based MaaS governance —
before they can recommend or operate it in production. Without a structured
workshop, learners must reverse-engineer how the `LLMInferenceService`
deployment resource, the MaaS custom resources (`MaaSModelRef`,
`MaaSSubscription`, `MaaSAuthPolicy`), and the `openshift-ai-inference` Gateway
fit together from product documentation alone. This workshop targets RHOAI
users with working knowledge of OpenShift and model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to verify the MaaS custom resource definitions are installed (`oc get crd | grep -E 'maas.opendatahub.io|aitenants'`) and the `default-tenant` Tenant resource shows `Ready`
- [REQ-002] Learner MUST be able to verify MaaS is enabled (`kserve.modelsAsService.managementState: Managed`) and the `openshift-ai-inference` GatewayClass and Gateway both exist in `openshift-ingress`
- [REQ-003] Learner MUST be able to deploy a model through the dashboard wizard selecting the *Distributed inference with llm-d* deployment resource and *Publish as MaaS*
- [REQ-004] Learner MUST be able to confirm the deployed model is registered with MaaS (`oc get maasmodelref`) and uses the LLMInferenceService architecture (`oc get llminferenceservice`)
- [REQ-005] Learner MUST be able to grant model access with `MaaSSubscription` and `MaaSAuthPolicy` custom resources and confirm the controller generated `AuthPolicy` and `TokenRateLimitPolicy` resources
- [REQ-006] Learner MUST be able to call the model through the MaaS gateway with an OpenAI-compatible API key (`/v1/models` and `/v1/chat/completions`) and receive OpenAI-compatible responses
- [REQ-007] Learner SHOULD be able to observe that token rate limits are enforced (mix of `200` and `429`) and that an invalid API key is rejected (`401 Unauthorized`)

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the deployed model is published as MaaS with a `MaaSModelRef`, the controller
generates the gateway policies, and authenticated `curl` requests through the
MaaS gateway return OpenAI-compatible JSON with rate limiting enforced.

## Risks

- The feature is Technology Preview in 3.5; MaaS APIs and manifests may change between releases
- Workshop cluster must have both MaaS (`kserve.modelsAsService: Managed`) and Distributed Inference (llm-d) enabled in the DSC
- The `default-tenant` Tenant resource must show `Ready` (requires User Workload Monitoring) before deployment
- An administrator must create a subscription and add the published model before users can access it through the gateway

## Assumptions

- RHOAI 3.5 is installed with both MaaS and Distributed Inference (llm-d) enabled
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A model location (S3/PVC/OCI/URI connection) is available for deployment
- Learners have completed the workshop's Getting Connected module

## Related Designs

- RHAIBU-M33FDJ7PCQ5S

## Related Decisions

- RHAIBU-M33FDJ6XHHWJ
- RHAIBU-M33FDJ7A0KS5

## Related Requirements

- RHAIBU-M33FDJ690EQS
- RHAIBU-M33FDJ6KFCJE
