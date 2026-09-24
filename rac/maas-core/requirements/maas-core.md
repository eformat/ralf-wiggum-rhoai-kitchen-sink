---
schema_version: 1
id: RHAIBU-M33F77Z24FAX
type: requirement
---
# Models-as-a-Service (MaaS) Core Workshop

## Problem

Platform engineers and administrators evaluating RHOAI 3.5 need hands-on
experience with Models-as-a-Service (MaaS) — the GA subscription-based governance
layer for large language model serving — before they can recommend or operate it
in production. Since OpenShift AI 3.4, MaaS replaced the 3.3 tier-based model
with subscriptions bound to API keys, so learners must understand how
subscriptions, authorization policies, and API keys work together. Without a
structured workshop, learners must reverse-engineer the access model, the
`maas.opendatahub.io` custom resources, and the gateway authentication flow from
product documentation alone. This workshop targets RHOAI users with working
knowledge of OpenShift and model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to name the three MaaS access-model custom resources (`MaaSModelRef`, `MaaSSubscription`, `MaaSAuthPolicy`) and the dashboard areas where each is managed
- [REQ-003] Learner MUST be able to verify the MaaS deployment: all six `maas.opendatahub.io` CRDs installed, User Workload Monitoring enabled, default Tenant `READY: True` with `REASON: Reconciled`, and MaaS dashboard flags present in `OdhDashboardConfig`
- [REQ-004] Learner MUST be able to locate a MaaS-published model in the dashboard (`Gen AI studio → AI asset endpoints`) and confirm the *Model as a Service* badge with a subscription listed in the Endpoints dialog
- [REQ-005] Learner MUST be able to create a subscription-bound API key and list models through the MaaS management API (`/maas-api/v1/models`) with the key, confirming it shows `Active` on the API keys page
- [REQ-006] Learner MUST be able to call the model through the OpenAI-compatible gateway (`/v1/chat/completions`) and receive HTTP 200 with a `usage` object reporting `prompt_tokens`, `completion_tokens`, and `total_tokens`
- [REQ-007] Learner MUST observe that an invalid API key is rejected with `401` (or `403`) and that rapid requests reveal enforced token rate limits (`429` responses with `X-RateLimit-*` and `Retry-After` headers)
- [REQ-008] Learner MUST be able to create a subscription and authorization policy from the *MaaS governance* page and apply the same governance as `MaaSSubscription`/`MaaSAuthPolicy` YAML, confirming the controller-generated `AuthPolicy` and `TokenRateLimitPolicy` resources in the model namespace
- [REQ-009] Learner SHOULD be able to revoke an API key and observe `401` at the management API, cap `maxExpirationDays` on the Tenant resource, and view token consumption on the Usage dashboard

## Success Metrics

All nine acceptance criteria are demonstrated by the learner during the lab: the
Tenant verifies `Ready: True` in module 01, authenticated chat completions return
HTTP 200 with a `usage` object in module 02, and the YAML-applied governance
produces controller-generated gateway policies in module 03.

## Risks

- Module 02 exercises require a facilitator-published model and a group-assigned subscription; without them the Subscription dropdown is empty
- The MaaS observability dashboard is Technology Preview in 3.5 and is showback-oriented, not billing-grade
- Module 03 requires dashboard administrator privileges or a facilitator-provided admin account
- User Workload Monitoring must be enabled or the MaaS deployment shows a `Degraded` status

## Assumptions

- RHOAI 3.5 is installed with MaaS enabled, Connectivity Link/Kuadrant stack in place, and a PostgreSQL database secret provisioned
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- The workshop user's group has a subscription with a token limit for the workshop model

## Related Designs

- RHAIBU-M33F780W9YKE

## Related Decisions

- RHAIBU-M33F7807BHRD
- RHAIBU-M33F780HKM5R

## Related Requirements

- RHAIBU-M33F77ZAW9NQ
- RHAIBU-M33F77ZMK0A8
- RHAIBU-M33F77ZXJ4RZ
