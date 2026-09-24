---
schema_version: 1
id: RHAIBU-M33F0QS80TZC
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must deploy a real guardrails service — a standalone `NemoGuardrails`
CR with built-in Presidio and regex detectors — and prove that rails block
sensitive data both on standalone validation (`/v1/guardrail/checks`) and on a
live inference path (`/v1/chat/completions`). This is the core deliverable of
the workshop: a working guardrails service with verified end-to-end blocking
behaviour.

## Requirements

- [REQ-021] Learner MUST be able to apply a configuration ConfigMap and a `NemoGuardrails` CR (`trustyai.opendatahub.io/v1alpha1`) with `security.opendatahub.io/enable-auth: 'true'` and observe `PHASE` `Ready`
- [REQ-022] Learner MUST be able to test the `/v1/guardrail/checks` endpoint with safe content, an email address, and a security keyword, and observe `success` versus `blocked` with `guardrails_data.log.activated_rails`
- [REQ-023] Learner MUST be able to send multiple messages in one `/v1/guardrail/checks` request and read per-message results
- [REQ-024] Learner MUST be able to front a deployed model via `/v1/chat/completions` with a live model: a safe question returns the model's answer and a message containing an email address is blocked before the LLM is called

## Success Metrics

`NemoGuardrails` reaches `PHASE` `Ready`; `/v1/guardrail/checks` returns
`blocked` for email/password content with the activating rail named in
`activated_rails`, `success` for safe content, and `llm_calls_count` 0 for
built-in detectors; a safe `/v1/chat/completions` request returns the model's
answer and an email-bearing message is blocked.

## Risks

- Exercise 3 requires a model deployed on the model-serving platform whose predictor URL ends in `/v1`
- Creating ConfigMaps and `NemoGuardrails` resources requires cluster administrator permissions or sufficient namespace permissions

## Assumptions

- Learner has completed Module 01 (TrustyAI component verified, CRD served)
- `OPENAI_API_KEY` is required on the CR; any placeholder value works for internal detectors only

## Related Requirements

- RHAIBU-M33F0QRTSW8T

## Verified By

- features/guardrails/nemo-guardrails/content/modules/ROOT/pages/module-02-hands-on.adoc
