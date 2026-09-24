---
schema_version: 1
id: RHAIBU-M33FDBQ5DCTH
type: requirement
---
# Module 01: Core Concepts

## Problem

Before provisioning tenants, learners need a mental model of the multitenant
architecture: which resources are isolated per tenant (identity realm, Gateway,
namespace, API keys) versus shared (GPU compute, PostgreSQL, observability
stack), the three access-control layers, and how the `AITenant` controller
bootstraps tenant infrastructure. Without this orientation, later hands-on
steps are copy-paste with no understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to distinguish isolated per-tenant resources from shared resources and name the three access-control layers (Kubernetes RBAC, gateway-scoped Kuadrant AuthPolicies, MaaS subscriptions)
- [REQ-012] Learner MUST be able to verify the default tenant is Ready with `oc get aitenant models-as-a-service -n ai-tenants` (`READY: True`)
- [REQ-013] Learner MUST be able to verify the `openshift-default` GatewayClass is available with `oc get gatewayclass openshift-default`
- [REQ-014] Learner MUST be able to confirm the default tenant's `MaasTenantConfig` singleton exists with `oc get maastenantconfig default-tenant -n models-as-a-service`

## Success Metrics

Learner completes both exercises: the architecture walkthrough (answering the
isolation/access-control questions) and the cluster inspection commands, each
producing the documented expected output.

## Risks

- Gateway resources and the `ai-tenants` namespace only exist after MaaS is deployed; on clusters without it, exercise 2 must be adapted

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- Base MaaS installation is deployed on the cluster

## Related Requirements

- RHAIBU-M33FDBPZXKRR

## Verified By

- features/maas/maas-multi-tenancy/content/modules/ROOT/pages/module-01-concepts.adoc
