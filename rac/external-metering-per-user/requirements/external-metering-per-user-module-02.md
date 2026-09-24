---
schema_version: 1
id: RHAIBU-M33D7VBEA1PY
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Per-user token usage is the heart of the feature, but it is scattered across
surfaces with different fidelity: the MaaS observability dashboard, the CSV
showback export, and the Developer Preview external metering path. Learners
need to locate and interpret the per-user data that exists today and
articulate precisely where the chargeback gap begins — otherwise the Developer
Preview boundary stays abstract.

## Requirements

- [REQ-021] Learner MUST be able to navigate to the MaaS observability dashboard (`Observe & monitor → Dashboard` → Usage tab) and configure the Time period and User/Subscription/Model filters
- [REQ-022] Learner MUST be able to interpret the Token Consumption by User table: which columns identify the user, the subscription, and the token totals
- [REQ-023] Learner SHOULD be able to name the Prometheus metrics behind the table (`authorized_hits_total`, `authorized_calls_total`, `limited_calls_total`) and the `captureUser: false` default that hides per-user labels
- [REQ-024] Learner MUST be able to articulate the difference between showback-grade visibility today (dashboard, CSV export) and the Developer Preview external metering path to balance-enforced quotas and chargeback-grade reporting

## Success Metrics

Learner completes both exercises: the Usage tab renders the Token Consumption
by User table filtered to the selected time period, and the showback-vs-
chargeback boundary is stated in the learner's own words in the Verify section.

## Risks

- The observability dashboard is a Technology Preview surface and its tabs/labels may change between releases
- Per-user rows only appear when `captureUser: true` is set in the `MaasTenantConfig`; with the default, usage aggregates at subscription level

## Assumptions

- Learner has completed Module 01 (MaaS foundation verified, data path understood)
- The cluster has recent MaaS traffic so the table shows non-zero values

## Related Requirements

- RHAIBU-M33D7VB0DVVA

## Verified By

- features/agents-mcp/external-metering-per-user/content/modules/ROOT/pages/module-02-hands-on.adoc
