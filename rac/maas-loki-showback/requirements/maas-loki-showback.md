---
schema_version: 1
id: RHAIBU-M33FD4E5MCYB
type: requirement
---
# Loki-based Showback and User-Scoped Usage Dashboards (MaaS) Workshop

## Problem

Platform administrators running Models-as-a-Service on RHOAI 3.5 need to answer
*"who consumed how many tokens, on which models, through which subscriptions?"*
and hand usage data to finance teams for showback cost attribution. The MaaS
observability stack — a Perses-based dashboard querying Prometheus plus a
Loki-based structured log pipeline — must be enabled through several separate
configuration switches (Kuadrant observability, Tenant telemetry, dashboard
console flags), and without hands-on practice administrators cannot connect the
switches to the dashboards and CSV exports they need. This workshop targets
cluster administrators with working knowledge of OpenShift and MaaS.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster as a cluster administrator (`oc login`)
- [REQ-002] Learner MUST be able to verify the MaaS CRDs are installed, the `openshift-user-workload-monitoring` namespace exists, and the Tenant resource shows `READY: True`, `REASON: Reconciled`
- [REQ-003] Learner MUST be able to verify `spec.dashboardConfig.observabilityDashboard` returns `true` from the `OdhDashboardConfig` custom resource
- [REQ-004] Learner MUST be able to enable Kuadrant observability (`spec.observability.enable: true`) and confirm the `kuadrant-limitador-monitor` PodMonitor exists in `kuadrant-system` with the `limited_calls` metric available
- [REQ-005] Learner MUST be able to enable MaaS telemetry on the Tenant custom resource and confirm the `authorized_calls` query returns usage metrics with the expected labels
- [REQ-006] Learner MUST be able to enable per-user metrics with `captureUser: true` and confirm `authorized_hits_total` appears in *Observe* → *Metrics* after MaaS traffic
- [REQ-007] Learner MUST be able to navigate the MaaS observability dashboard *Usage* tab: Overview section with non-zero values, the Token Consumption by User table, and time-period updates
- [REQ-008] Learner MUST be able to export the Token Consumption by User table as a CSV file matching the selected filters and time period (one row per user, subscription, and model combination with token and request totals)
- [REQ-009] Learner SHOULD be able to explain the Loki-based log pipeline (30-day retention on object storage) and the user-scoped read-only dashboards described in the 3.5 release notes

## Success Metrics

All eight MUST criteria are demonstrated by the learner during the lab: the
prerequisite checks pass in module 01, both telemetry switches are enabled and
verified via Prometheus queries, the dashboard's Token Consumption by User
table renders per-user data in module 02, and the CSV export downloads with
data matching the selected filters.

## Risks

- The MaaS observability dashboard is Technology Preview in 3.5; APIs and manifests may change between releases
- The CSV export requires the Cluster Observability Operator to be installed and configured on the workshop cluster
- Enabling `captureUser` on a production cluster can significantly increase Prometheus database size (cardinality cost)
- The Loki-based log pipeline and user-scoped dashboards have no published step-by-step configuration commands in the 3.5 docs (release notes only)

## Assumptions

- RHOAI 3.5 is installed with the RHOAI operator running and Models-as-a-Service deployed and enabled
- At least one model is published through the MaaS gateway
- The observability stack for OpenShift AI is configured, including metrics storage in the `DSCInitialization` resource
- Learners have cluster administrator privileges — dashboard access is restricted to cluster administrators

## Related Designs

- RHAIBU-M33FD4FPATKE

## Related Decisions

- RHAIBU-M33FD4F3BPW8
- RHAIBU-M33FD4FC5P38

## Related Requirements

- RHAIBU-M33FD4EFB5FT
- RHAIBU-M33FD4ES2FE8
