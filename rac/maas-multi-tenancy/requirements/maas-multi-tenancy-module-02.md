---
schema_version: 1
id: RHAIBU-M33FDBQB4AYW
type: requirement
---
# Module 02: Provision a tenant and verify isolation

## Problem

Learners must provision a real isolated tenant end to end — a dedicated Gateway
with required MaaS annotations followed by an `AITenant` custom resource — and
prove the controller bootstrapped all required resources and that tenant
isolation holds with real API calls. This is the core deliverable of the
workshop: a working tenant with verified 200/401-403/404 isolation boundaries.

## Requirements

- [REQ-021] Learner MUST be able to create a dedicated tenant Gateway with the required annotations (`opendatahub.io/managed: "false"`, `security.opendatahub.io/authorino-tls-bootstrap: "true"`), the `openshift-default` GatewayClass, and a unique hostname, and confirm `PROGRAMMED: True`
- [REQ-022] Learner MUST be able to apply an `AITenant` resource (maas.opendatahub.io/v1alpha1) in the `ai-tenants` namespace and observe `READY: True` with the tenant namespace labeled `ai-gateway.opendatahub.io/tenant` and `maas.opendatahub.io/managed-by-aitenant=true`
- [REQ-023] Learner MUST be able to verify the `MaasTenantConfig` CR in the tenant namespace and the per-tenant `maas-api-<tenant>` deployment (`READY 1/1`) in the infrastructure namespace
- [REQ-024] Learner MUST verify tenant isolation with API calls: authenticated `/v1/models` through the tenant gateway returns 200, unauthenticated requests return 401 or 403, and a cross-tenant API key against the default gateway returns 404

## Success Metrics

`AITenant` reaches `READY: True`; the tenant gateway returns 200 for
authenticated model listing; unauthenticated access is rejected with 401/403;
the cross-tenant key test returns 404 confirming isolation.

## Risks

- Gateway and identity provider are external prerequisites the controller never creates; missing Gateway, `maas-db-config` secret, or Connectivity Link leaves the `AITenant` in `Pending`
- Deployment requires LoadBalancer support or a manually created OpenShift Route for external access

## Assumptions

- Learner has completed Module 01 (default tenant verified) and has cluster-administrator privileges

## Related Requirements

- RHAIBU-M33FDBPZXKRR

## Verified By

- features/maas/maas-multi-tenancy/content/modules/ROOT/pages/module-02-hands-on.adoc
