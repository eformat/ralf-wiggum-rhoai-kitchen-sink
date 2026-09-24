---
schema_version: 1
id: RHAIBU-M33F77ZMK0A8
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must work the core MaaS access workflow end to end — discover a
MaaS-published model, generate a subscription-bound API key, and call the model
through the OpenAI-compatible gateway — and prove the token mechanism works by
reading token usage and rate-limit responses. This is the core deliverable of
the workshop.

## Requirements

- [REQ-021] Learner MUST be able to locate the workshop model in the dashboard (`Gen AI studio → AI asset endpoints`) and confirm the *Model as a Service* badge with at least one subscription listed in the Endpoints dialog
- [REQ-022] Learner MUST be able to create an API key (temporary 1-hour and persistent subscription-bound) and list models through the MaaS management API with `curl -H "Authorization: Bearer $MAAS_API_KEY" "$MAAS_URL/maas-api/v1/models"`, confirming the key shows `Active` on the API keys page
- [REQ-023] Learner MUST be able to call the model via body-based routing (`/v1/chat/completions`) and receive HTTP 200 in OpenAI-compatible JSON format with a `usage` object (`prompt_tokens`, `completion_tokens`, `total_tokens`)
- [REQ-024] Learner MUST observe that an invalid key is rejected with `401` (or `403`) and that a rapid-request loop shows enforced rate limits (`429` responses, or only `200` if the subscription token limit is high)

## Success Metrics

`/v1/models` returns the workshop model with `"ready": true`; chat completions
return HTTP 200 with a `usage` object; the invalid key is rejected with `401`/`403`.

## Risks

- Requires a facilitator-published model and a group-assigned subscription; if the Subscription dropdown is empty, module 03 admin steps are needed first
- The gateway host (`maas.<cluster-ingress-domain>`) must be derived from the cluster ingress domain

## Assumptions

- Learner has completed Module 01 (platform verified) and has the workshop group's subscription assigned

## Related Requirements

- RHAIBU-M33F77Z24FAX

## Verified By

- features/maas/maas-core/content/modules/ROOT/pages/module-02-hands-on.adoc
