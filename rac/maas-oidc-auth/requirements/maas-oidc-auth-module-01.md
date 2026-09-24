---
schema_version: 1
id: RHAIBU-M33F6QKMBGDJ
type: requirement
---
# Module 01: Configure external OIDC authentication

## Problem

Before governing access with OIDC groups, learners need a mental model of the
two-tier authentication flow — OIDC tokens for platform APIs, API keys for model
access — and must verify the MaaS default tenant, `MaasTenantConfig`, and
gateway are ready before configuring the `AITenant` custom resource with their
external OIDC provider. Without this orientation, later hands-on steps are
copy-paste with no understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to verify the MaaS default tenant is ready (`oc get aitenant models-as-a-service -n ai-tenants` shows `READY: True`)
- [REQ-012] Learner MUST be able to confirm the `MaasTenantConfig` status returns the infrastructure namespace (`redhat-ai-gateway-infra`)
- [REQ-013] Learner MUST be able to export `$MAAS_GATEWAY_URL` from the `maas-default-gateway` listener hostname, falling back to the auto-provisioned Route when the listener hostname is empty
- [REQ-014] Learner MUST be able to add the `oidc` configuration (`clientId`, `issuerUrl`, `ttl` with default 300 and minimum 30) to the `AITenant` custom resource via console or `oc patch` and confirm it is stored via `jsonpath='{.spec.oidc}'`

## Success Metrics

Learner completes both exercises: the deployment verification (tenant ready,
infra namespace resolved, gateway URL exported) and the `AITenant` OIDC
configuration, each producing the documented expected output.

## Risks

- Exercise 2 requires a registered client application in the external OIDC provider; without one, the `clientId`/`issuerUrl` values cannot be filled in
- On clusters where the gateway listener hostname is empty, the Route fallback path must be exercised instead

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- Learner has cluster administrator privileges and user groups with group claims exist in the OIDC provider

## Related Requirements

- RHAIBU-M33F6QKCY0FW

## Verified By

- features/maas/maas-oidc-auth/content/modules/ROOT/pages/module-01-getting-started.adoc
