---
schema_version: 1
id: RHAIBU-M33F0QRTSW8T
type: requirement
---
# NeMo Guardrails Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with NeMo Guardrails — the AI safety framework that controls LLM
input and output with rails for sensitive data detection, content filtering,
and custom validation rules — before they can recommend or operate it in
production. Without a structured workshop, learners must reverse-engineer the
`NemoGuardrails` CR, the configuration ConfigMap format, and the three API
endpoints from product documentation alone. This workshop targets RHOAI users
with working knowledge of OpenShift and model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify the TrustyAI component is `Managed` in the DataScienceCluster (`spec.components.trustyai.managementState`)
- [REQ-003] Learner MUST be able to deploy a standalone `NemoGuardrails` service backed by a configuration ConfigMap with built-in Presidio and regex detectors and confirm `PHASE` `Ready`
- [REQ-004] Learner MUST be able to test input rails with the `/v1/guardrail/checks` endpoint and observe per-message `success`/`blocked` results
- [REQ-005] Learner MUST be able to front a deployed model with input and output rails via `/v1/chat/completions` and confirm safe requests pass while sensitive data is blocked
- [REQ-006] Learner SHOULD be able to load multiple guardrail configurations on one `NemoGuardrails` resource, switch between them with `guardrails.config_id`, and scale the deployment
- [REQ-007] Learner SHOULD be able to apply masking flows so detected PII is replaced with `[MASKED]` instead of blocking the request
- [REQ-008] Learner SHOULD be able to add a custom rail with a Colang flow backed by a Python action and verify it intercepts input before the LLM is called

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the lab;
`NemoGuardrails` resources reach `PHASE` `Ready` in modules 02–03,
`/v1/guardrail/checks` returns `blocked` for email/password content and
`success` for safe content, and the masking and custom-rail exercises produce
their documented outputs.

## Risks

- Exercises that front a live model (module 2 Exercise 3, module 3) require a model deployed on the model-serving platform whose predictor URL ends in `/v1`
- The TrustyAI component must be set to `Managed` in the DSC; on clusters without it, no `NemoGuardrails` CRD is served
- LLM self-check rails (documented in the product guide) increase latency and token usage and are deliberately out of lab scope

## Assumptions

- RHOAI 3.5 is installed with the TrustyAI component enabled
- Learners have `oc` CLI access, workshop credentials (`{user}`, `{guid}`), and permissions to create ConfigMaps and `NemoGuardrails` resources
- A model location (vLLM-compatible predictor URL ending in `/v1`) is available for module 2 Exercise 3 and module 3

## Related Designs

- RHAIBU-M33F0QT0R1C1

## Related Decisions

- RHAIBU-M33F0QSMFAF2
- RHAIBU-M33F0QSVQ7CW

## Related Requirements

- RHAIBU-M33F0QS1E106
- RHAIBU-M33F0QS80TZC
- RHAIBU-M33F0QSEHS0X
