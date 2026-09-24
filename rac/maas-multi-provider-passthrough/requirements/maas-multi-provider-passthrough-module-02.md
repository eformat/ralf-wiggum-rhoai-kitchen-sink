---
schema_version: 1
id: RHAIBU-M33FJXAJXJ9X
type: requirement
---
# Module 02: Hands-on — Route native provider formats through the MaaS gateway

## Problem

Learners must wire up the full external-model chain — `ExternalModel` with a
passthrough-eligible `apiFormat`, `MaaSModelRef` publication, subscription
governance — and prove end-to-end passthrough with real traffic in the
provider's native format. This is the core deliverable of the workshop: an
Anthropic Messages request forwarded unchanged to api.anthropic.com through the
MaaS gateway.

## Requirements

- [REQ-021] Learner MUST be able to create an `ExternalModel` with `apiFormat: messages` and a `MaaSModelRef`, confirming a Ready phase, an existing `HTTPRoute`, and the `MaaSModelRef` resource
- [REQ-022] Learner MUST be able to verify the external model in the subscription's *Models* section and in the dashboard's *External models* tab with Ready status and correct provider details (provider URL, authentication method, target model ID)
- [REQ-023] Learner MUST be able to send a `/v1/messages` request with the `x-api-key` header and receive an Anthropic Messages response with a `content` array and `stop_reason: end_turn`
- [REQ-024] Learner MUST be able to send a single-URL request against `%maas-gateway-url%` and verify body-based routing resolves the model from the request body `model` field to the target model ID

## Success Metrics

`ExternalModel` and `MaaSModelRef` reconcile Ready; the subscription and
*External models* tab list `claude-sonnet`; both curl requests return Anthropic
Messages responses with `model: claude-sonnet-4-20250514`.

## Risks

- The `ExternalModel` must reference an `ExternalProvider` in Ready status before it can reconcile
- External models are supported for the default tenant only in multitenant deployments; non-default tenants have the `ExternalModel` controller disabled
- MaaS subscription-level token rate limits do not meter passthrough formats (`messages`, `openai-responses`); provider-level limits must manage consumption

## Assumptions

- Learner has completed Module 01 (prerequisites verified, `ExternalProvider` Ready, secret created)
- Learner has a valid external provider API key and a MaaS API key from the dashboard

## Related Requirements

- RHAIBU-M33FJXA0RAZF

## Verified By

- features/maas/maas-multi-provider-passthrough/content/modules/ROOT/pages/module-02-hands-on.adoc
