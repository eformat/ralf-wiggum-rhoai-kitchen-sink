---
schema_version: 1
id: RHAIBU-M33FDBQJP1SC
type: requirement
---
# Module 03: Grant tenant access and delete a tenant

## Problem

After provisioning a tenant, platform engineers need to grant users access to
manage it with RoleBindings (the controller creates Roles but never
RoleBindings), tune per-tenant runtime settings through `MaasTenantConfig`, and
delete the tenant cleanly — understanding the finalizer's ordered cleanup and
which resources are preserved.

## Requirements

- [REQ-031] Learner MUST be able to grant tenant-admin access with a RoleBinding and verify with `oc auth can-i create maassubscriptions.maas.opendatahub.io --as=<username>` returning `yes`
- [REQ-032] Learner SHOULD be able to tune per-tenant API key expiration (`apiKeys.maxExpirationDays`) and telemetry dimensions (`telemetry.metrics.capture*`) by editing the `MaasTenantConfig` singleton
- [REQ-033] Learner MUST be able to delete an `AITenant`, observe the finalizer's ordered cleanup, and verify both `oc get aitenant` and `oc get maastenantconfig default-tenant` return `Error from server (NotFound)` while the preserved tenant namespace still exists
- [REQ-034] Learner SHOULD be able to review and remove stale user-created RoleBindings in the preserved tenant namespace after deletion

## Success Metrics

Learner completes both exercises: the RoleBinding grant verified with `oc auth
can-i` returning `yes`, and the tenant deletion with `NotFound` outputs for the
`AITenant` and `MaasTenantConfig` plus a preserved namespace.

## Risks

- Deleting an `AITenant` is destructive: the finalizer revokes active API keys and deletes tenant-scoped MaaS resources
- Stale user-created RoleBindings survive deletion and can silently re-enable access if a tenant with the same name is recreated

## Assumptions

- Learner has completed Module 02 (a Ready tenant exists to grant access to and delete)

## Related Requirements

- RHAIBU-M33FDBPZXKRR

## Verified By

- features/maas/maas-multi-tenancy/content/modules/ROOT/pages/module-03-advanced.adoc
