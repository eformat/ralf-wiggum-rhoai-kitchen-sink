---
schema_version: 1
id: RHAIBU-M33F6QKCY0FW
type: requirement
---
# MaaS External OIDC Authentication Workshop

## Problem

Platform engineers and administrators evaluating RHOAI 3.5 need hands-on
experience authenticating Models-as-a-Service (MaaS) users through external OIDC
providers — the GA path for enterprise-wide identity integration — before they
can recommend or operate it in production. Without a structured workshop,
learners must reverse-engineer the two-tier authentication flow (OIDC tokens for
platform APIs, API keys for model access), the `AITenant` OIDC configuration,
and group-claim-based subscription mapping from product documentation alone.
This workshop targets RHOAI users with cluster administrator privileges and an
external OIDC provider such as Keycloak.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and connect to the workshop environment (Getting Connected bookend)
- [REQ-002] Learner MUST be able to verify the MaaS default tenant is ready (`oc get aitenant models-as-a-service -n ai-tenants` shows `READY: True`)
- [REQ-003] Learner MUST be able to resolve the MaaS infrastructure namespace from `MaasTenantConfig` status and export the MaaS gateway URL from the `maas-default-gateway` listener hostname
- [REQ-004] Learner MUST be able to configure the `AITenant` custom resource with external OIDC settings (`clientId`, `issuerUrl`, signing-key cache `ttl`) and confirm they are stored on the resource
- [REQ-005] Learner MUST be able to create a MaaS subscription whose group names exactly match the OIDC token `groups` claim, with at least one model and token limit, plus a matching authorization policy
- [REQ-006] Learner MUST be able to verify external OIDC authentication by listing models through the MaaS management API with a real OIDC token (`curl -H "Authorization: Bearer $OIDC_TOKEN" .../maas-api/v1/models` returns 200)
- [REQ-007] Learner MUST observe that a request without a valid token is rejected with `401 Unauthorized`

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the `AITenant` resource stores the configured `clientId`, `issuerUrl`, and `ttl`
in module 01, the subscription appears *Active* in `Settings → MaaS governance`
in module 02, and authenticated `curl` requests against the MaaS management API
return 200 while unauthenticated requests return 401.

## Risks

- The workshop requires a live external OIDC provider (e.g. Keycloak) with a registered client application, user groups, and group claims in ID tokens — none of which are provisioned by the lab itself
- Dashboard API key creation is not supported for external OIDC users; all key lifecycle steps go through the MaaS API with `curl`
- Subscription group names must match OIDC token claims exactly; any mismatch yields an empty model list that learners may misread as an authentication failure

## Assumptions

- RHOAI 3.5 is installed with Models-as-a-Service deployed
- Learners have cluster administrator privileges and workshop credentials
- An external OIDC provider with registered client application (issuer URL and client ID) and group-bearing ID tokens is available
- Upgrades from the legacy `Tenant` custom resource migrate `externalOIDC` values to `AITenant` automatically

## Related Designs

- RHAIBU-M33F6QN02WK2

## Related Decisions

- RHAIBU-M33F6QMAQ5DS
- RHAIBU-M33F6QMP6N0G

## Related Requirements

- RHAIBU-M33F6QKMBGDJ
- RHAIBU-M33F6QKZA4HT
