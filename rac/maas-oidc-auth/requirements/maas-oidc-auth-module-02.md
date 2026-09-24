---
schema_version: 1
id: RHAIBU-M33F6QKZA4HT
type: requirement
---
# Module 02: Govern access and verify OIDC authentication

## Problem

Learners must map their external OIDC groups to MaaS model access and prove the
authentication flow works end to end. This is the core deliverable of the
workshop: a subscription plus authorization policy whose groups match the OIDC
token claims exactly, verified through the MaaS management API with a real OIDC
token.

## Requirements

- [REQ-021] Learner MUST be able to create a MaaS subscription via `Settings → MaaS governance` with group names exactly matching the OIDC token `groups` claim, at least one published model, and at least one token limit per model
- [REQ-022] Learner MUST be able to confirm the subscription is *Active* in the dashboard and that the OIDC group names are stored on the `MaaSSubscription` custom resource under `spec.groups` (`oc get maassubscription -n models-as-a-service -o yaml`)
- [REQ-023] Learner MUST be able to verify external OIDC authentication with a real OIDC token: `curl -H "Authorization: Bearer $OIDC_TOKEN" .../maas-api/v1/models` returns HTTP 200 and lists models available to the token's groups
- [REQ-024] Learner MUST observe that the same request without a valid token returns `401 Unauthorized`, confirming the gateway enforces authentication

## Success Metrics

The subscription appears *Active* with the expected groups, models, token
limits, and priority; `curl` with the OIDC token returns 200 with a model list;
unauthenticated access is rejected with 401.

## Risks

- Both a subscription AND a matching authorization policy are required; without the policy users get `403 Forbidden` even with a valid subscription
- API keys snapshot group memberships at creation time, so access after a group change persists until keys are revoked or expired
- An empty model list (valid token, no matching subscription group) can be mistaken for an authentication failure

## Assumptions

- Learner has completed Module 01 (`AITenant` OIDC configuration saved)
- Learner can obtain a user access token from the OIDC provider via an interactive flow (authorization code or device grant)

## Related Requirements

- RHAIBU-M33F6QKCY0FW

## Verified By

- features/maas/maas-oidc-auth/content/modules/ROOT/pages/module-02-hands-on.adoc
