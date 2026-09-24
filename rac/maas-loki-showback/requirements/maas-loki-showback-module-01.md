---
schema_version: 1
id: RHAIBU-M33FD4EFB5FT
type: requirement
---
# Module 01: Getting Started with the MaaS observability stack

## Problem

Before any dashboard will render data, learners must verify the MaaS and
observability prerequisites on the cluster and flip the two configuration
switches that feed the MaaS observability dashboard: Kuadrant observability
(rate-limiting metrics from Limitador) and MaaS telemetry (usage metrics from
the gateway). Without this orientation, the later dashboard exercises are
read-only walkthroughs with no understanding of where the data comes from.

## Requirements

- [REQ-011] Learner MUST be able to verify the MaaS CRD list includes `tenants.maas.opendatahub.io` and `maastenantconfigs.maas.opendatahub.io` and that the `openshift-user-workload-monitoring` namespace exists
- [REQ-012] Learner MUST be able to confirm the Tenant resource shows `READY: True`, `REASON: Reconciled` and the `observabilityDashboard` flag returns `true`
- [REQ-013] Learner MUST be able to enable Kuadrant observability and confirm `kuadrant-limitador-monitor` exists in `kuadrant-system`, `spec.observability.enable` returns `true`, and the `limited_calls` metric is available in *Observe* → *Metrics*
- [REQ-014] Learner MUST be able to enable MaaS telemetry on the Tenant custom resource and confirm the Tenant remains `Ready`/`Reconciled` while the `authorized_calls` query returns metrics with the expected labels

## Success Metrics

Learner completes all three exercises — the prerequisite verification, the
Kuadrant observability switch, and the Tenant telemetry switch — each producing
the documented expected output in the `=== Verify` sections.

## Risks

- If User Workload Monitoring is not enabled, the MaaS deployment might show as `Degraded` and exercise 1 must be adapted
- `limited_calls` returns no data if no models have been accessed yet — expected on an idle cluster

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- The Cluster Observability Operator installation is checked early so module 02's CSV export is not blocked

## Related Requirements

- RHAIBU-M33FD4E5MCYB

## Verified By

- features/maas/maas-loki-showback/content/modules/ROOT/pages/module-01-getting-started.adoc
