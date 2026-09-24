---
schema_version: 1
id: RHAIBU-M33FDBPZXKRR
type: requirement
---
# MaaS Multi-tenancy Workshop

## Problem

Platform engineers evaluating RHOAI 3.5 need hands-on experience with
Models-as-a-Service multi-tenancy — the Technology Preview path for isolating
MaaS tenants with per-tenant gateways and identity realms — before they can
provision tenants for multiple teams on a shared MaaS platform. Without a
structured workshop, learners must reverse-engineer the `AITenant` API, the
Gateway prerequisites the controller never creates, the three-layer access
model, and the deletion cleanup semantics from product documentation alone.
This workshop targets RHOAI users with cluster-administrator knowledge of
OpenShift and the base MaaS installation.

## Requirements

- [REQ-001] Learner MUST be able to verify the default tenant is Ready (`oc get aitenant models-as-a-service -n ai-tenants` shows `READY: True`)
- [REQ-002] Learner MUST be able to verify the `openshift-default` GatewayClass is available for tenant Gateways
- [REQ-003] Learner MUST be able to confirm the default tenant's `MaasTenantConfig` singleton exists in the `models-as-a-service` namespace
- [REQ-004] Learner MUST be able to create a dedicated tenant Gateway with the required MaaS annotations and confirm `PROGRAMMED: True`
- [REQ-005] Learner MUST be able to apply an `AITenant` resource in the `ai-tenants` management namespace and verify the bootstrapped tenant namespace, `MaasTenantConfig`, and per-tenant `maas-api` deployment
- [REQ-006] Learner MUST be able to make an authenticated model-listing request through the tenant gateway endpoint and receive HTTP 200
- [REQ-007] Learner MUST observe that unauthenticated requests to the tenant gateway are rejected with 401 or 403
- [REQ-008] Learner MUST observe that a cross-tenant API key used against another tenant's gateway returns 404
- [REQ-009] Learner MUST be able to grant tenant-admin access with a RoleBinding and verify with `oc auth can-i` returning `yes`
- [REQ-010] Learner SHOULD be able to tune per-tenant API key expiration and telemetry dimensions through the `MaasTenantConfig` singleton
- [REQ-011] Learner MUST be able to delete an `AITenant` and verify the finalizer removed the `AITenant` and `MaasTenantConfig` while preserving the tenant namespace

## Success Metrics

All eleven acceptance criteria are demonstrated by the learner during the lab:
the default tenant and `MaasTenantConfig` verify in module 01, a new tenant
reaches `READY: True` with isolation proven by 200/401-403/404 responses in
module 02, and RoleBinding grants plus clean deletion with `NotFound` outputs
complete in module 03.

## Risks

- MaaS multi-tenancy is Technology Preview in 3.5 and may change between releases
- Workshop cluster must have MaaS deployed, Gateway API CRDs, cert-manager, and Red Hat Connectivity Link with Kuadrant v1.4.2 or later
- The cross-tenant isolation test requires an API key created in the additional tenant (via the MaaS API, per the MaaS core workshop)

## Assumptions

- RHOAI 3.5 is installed with MaaS enabled and the default tenant Ready
- Learners have cluster-administrator privileges and `oc` CLI access
- Gateway API CRDs, the `openshift-default` GatewayClass, cert-manager, and Connectivity Link are pre-provisioned

## Related Designs

- RHAIBU-M33FDBR84R31

## Related Decisions

- RHAIBU-M33FDBQTDEBH
- RHAIBU-M33FDBR1J8A8

## Related Requirements

- RHAIBU-M33FDBQ5DCTH
- RHAIBU-M33FDBQB4AYW
- RHAIBU-M33FDBQJP1SC
