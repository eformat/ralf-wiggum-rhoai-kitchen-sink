---
schema_version: 1
id: RHAIBU-M33FS2X4T4NW
type: requirement
---
# LLMInferenceService / LLMInferenceServiceConfig (llm-d-native) Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with the llm-d-native `LLMInferenceService` CR — the declarative
replacement for `InferenceService` in generative LLM serving — and with the
`LLMInferenceServiceConfig` template model that powers the dashboard's topology
selector, before they can recommend or operate it in production. Without a
structured workshop, learners must reverse-engineer the CR composition, the
config-type label discovery mechanism, and the `baseRefs` merge order from
product documentation alone. This workshop targets RHOAI users with working
knowledge of OpenShift and model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to verify the `LLMInferenceService` API is registered (`oc api-resources | grep -i llminference`) and name its five spec sections (`model`, `router`, `scheduler`, `template`, `baseRefs`)
- [REQ-002] Learner MUST be able to verify the shared `openshift-ai-inference` Gateway in `openshift-ingress` shows `PROGRAMMED: True` with its gateway pod and the controller manager pods `Running`
- [REQ-003] Learner MUST be able to apply an `LLMInferenceService` manifest with empty `router` and `scheduler` maps and confirm the `READY: True` condition via `oc get llminferenceservices` and the `Ready` jsonpath
- [REQ-004] Learner MUST be able to create a ServiceAccount with `get` access on the LLMInferenceService, mint a JWT with `oc create token`, and complete an authenticated chat-completion request returning HTTP 200
- [REQ-005] Learner MUST observe that requests without the `Authorization` header, or with an invalid/expired token, return `401 Unauthorized`
- [REQ-006] Learner SHOULD be able to create a topology configuration template under `Settings → llm-d topology configurations` and observe the corresponding topology radio button enabled in the Deploy model wizard
- [REQ-007] Learner SHOULD be able to create a router configuration with `config-type: router` and a `supported-topologies` annotation, and verify its merge into a deployed service's `spec.baseRefs` after the topology preset
- [REQ-008] Learner SHOULD be able to deploy a disaggregated prefill/decode workload with the `prefill` spec section and confirm the `{}` presence marker plus separate prefill/decode scheduler profiles in the EPP pod logs

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the lab;
the `LLMInferenceService` reaches `READY: True` in module 02, authenticated
`curl` requests return 200, and the `baseRefs` merge and disaggregated
`prefill` marker are verified in module 03.

## Risks

- The LLM deployment topology selector wizard and its template management pages are Technology Preview in 3.5 and may change between releases
- Workshop cluster must have Distributed Inference enabled in the DSC and the `openshift-ai-inference` Gateway programmed
- Module 03 multi-node and prefill/decode exercises require RDMA-capable networking and sufficient GPU capacity
- Administrator privileges are required for the `OdhDashboardConfig` and template exercises

## Assumptions

- RHOAI 3.5 is installed with the model-serving platform enabled and OpenShift Service Mesh v2 absent
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A model location (Hugging Face, S3/URI/OCI/PVC) is reachable for deployment
- Learners have administrator privileges for module 03

## Related Designs

- RHAIBU-M33FS2YMYMDW

## Related Decisions

- RHAIBU-M33FS2Y35VB6
- RHAIBU-M33FS2YB2WBT

## Related Requirements

- RHAIBU-M33FS2XCDCFY
- RHAIBU-M33FS2XK1NJR
- RHAIBU-M33FS2XV37B4
