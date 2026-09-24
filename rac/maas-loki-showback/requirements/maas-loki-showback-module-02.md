---
schema_version: 1
id: RHAIBU-M33FD4ES2FE8
type: requirement
---
# Module 02: Per-user usage dashboards and CSV showback export

## Problem

Learners must turn the metrics pipeline into answers: enable per-user metrics
collection (`captureUser`), read the MaaS observability dashboard end to end in
the console, and export usage data as CSV for showback reporting to finance
teams. This is the core deliverable of the workshop — a per-user token
consumption table and a downloadable CSV artifact.

## Requirements

- [REQ-021] Learner MUST be able to patch the Tenant resource with `captureUser: true` and confirm it remains `Ready`/`Reconciled`
- [REQ-022] Learner MUST be able to confirm `authorized_hits_total` appears in *Observe* → *Metrics* after MaaS traffic, labeled by `subscription`, `model`, and `limitador_namespace`
- [REQ-023] Learner MUST be able to navigate the dashboard *Usage* tab and confirm the Overview section shows non-zero values, the Token Consumption by User table lists users with token consumption, and changing the time period updates the metrics
- [REQ-024] Learner MUST be able to export the Token Consumption by User table as CSV and confirm the file downloads with usage data matching the selected filters — one row per user, subscription, and model combination with token and request totals

## Success Metrics

`captureUser` is enabled and accepted; `authorized_hits_total` renders per-user
breakdowns in Prometheus; the dashboard's Overview and per-user table show
activity for the selected time period; the CSV export downloads and matches the
selected filters.

## Risks

- Enabling `captureUser` with a large number of users can significantly increase the Prometheus database size (cardinality cost) — fine for a workshop cluster
- The dashboard is showback-grade, not billing-grade; production chargeback needs the Limitador metrics endpoint or external metering
- CSV export requires the Cluster Observability Operator installed and configured

## Assumptions

- Learner has completed Module 01 (both telemetry switches enabled and verified)
- MaaS traffic exists (or is generated) so the dashboard and metrics have data to report

## Related Requirements

- RHAIBU-M33FD4E5MCYB

## Verified By

- features/maas/maas-loki-showback/content/modules/ROOT/pages/module-02-hands-on.adoc
