---
schema_version: 1
id: RHAIBU-M33F77ZAW9NQ
type: requirement
---
# Module 01: Core Concepts

## Problem

Before consuming governed models, learners need a mental model of the MaaS
access model — how subscriptions, authorization policies, and API keys govern
access between users and model serving infrastructure — and must verify the
platform-level deployment (CRDs, monitoring, tenant) that makes it work.
Without this orientation, later hands-on steps are copy-paste with no
understanding of why a request returns 403 versus 429.

## Requirements

- [REQ-011] Learner MUST be able to name the three MaaS access-model custom resources (`MaaSModelRef`, `MaaSSubscription`, `MaaSAuthPolicy`) and explain that both a subscription and a matching authorization policy are required
- [REQ-012] Learner MUST be able to list the MaaS resources in the cluster with `oc get maassubscriptions`, `oc get maasauthpolicy`, and `oc get maasmodelref --all-namespaces` (empty lists are expected before any model is published)
- [REQ-013] Learner MUST be able to verify all six `maas.opendatahub.io` CRDs are installed, the `openshift-user-workload-monitoring` namespace exists, and the default Tenant shows `READY: True` with `REASON: Reconciled`
- [REQ-014] Learner MUST be able to confirm the MaaS dashboard flags (`modelAsService`, `genAiStudio`, `maasAuthPolicies`) are present in the `OdhDashboardConfig` custom resource

## Success Metrics

Learner completes both exercises: the access-model walkthrough and the cluster
inspection commands, each producing the documented expected output.

## Risks

- User Workload Monitoring must be enabled; without it the MaaS deployment shows a `Degraded` status
- A missing `maas-db-config` secret or a not-ready Kuadrant resource can also show `False`/`Degraded` tenant conditions

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33F77Z24FAX

## Verified By

- features/maas/maas-core/content/modules/ROOT/pages/module-01-concepts.adoc
