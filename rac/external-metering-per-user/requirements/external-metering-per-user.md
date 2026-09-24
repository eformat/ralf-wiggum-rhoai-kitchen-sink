---
schema_version: 1
id: RHAIBU-M33D7VB0DVVA
type: requirement
---
# External Metering: Per-User Token Usage and Cost Workshop

## Problem

Platform operators and finance-adjacent engineers evaluating RHOAI 3.5 need to
understand how *External metering: per-user token usage and cost* — a Developer
Preview feature — lets them track per-user and per-model token consumption,
attribute costs, enforce quotas, and generate chargeback reports for inference
requests passing through the AI Inference Gateway. Because the feature is
Developer Preview and its installation/configuration procedures are not yet in
the product documentation, learners need a guided path that grounds the
architecture in the MaaS surfaces that already exist in their cluster (the
observability dashboard, Token Consumption by User table, and CSV showback
export) rather than on installing new components. This workshop targets RHOAI
users with working knowledge of OpenShift and Models-as-a-Service concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify the MaaS foundation external metering meters: the DataScienceCluster exists, the MaaS CRDs are installed (`oc get crd | grep -E 'maas.opendatahub.io|aitenants'`), and a Tenant resource is reconciled (`READY: True`)
- [REQ-003] Learner MUST be able to describe the five stages of the external metering data path: balance check at the plugin, usage extraction from the provider response, CloudEvent emission, aggregation with cache-aware pricing in the PostgreSQL service, and consumption through the dashboard and REST API
- [REQ-004] Learner MUST be able to name the five token dimensions the plugin extracts from OpenAI and Anthropic provider responses (input, output, cached, cache write, reasoning tokens)
- [REQ-005] Learner MUST be able to locate per-user usage data in the MaaS observability dashboard (`Observe & monitor → Dashboard` → Usage tab) filtered to a selected time period and User/Subscription/Model filters
- [REQ-006] Learner MUST be able to interpret the Token Consumption by User table and name which columns identify the user, the subscription, and the token totals
- [REQ-007] Learner SHOULD be able to articulate the boundary between showback-grade visibility today (dashboard, CSV export) and the Developer Preview external metering path to balance-enforced quotas and chargeback-grade reporting

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the MaaS foundation checks return the documented expected output in module 01,
and the Usage tab renders the Token Consumption by User table in module 02.

## Risks

- The feature is Developer Preview in 3.5: the architecture and API may change between releases, so no production billing pipelines can be built on it
- Installation and configuration procedures for the plugin and metering service are not yet in the product documentation; the workshop observes existing MaaS surfaces instead of installing new components
- Per-user metrics require `captureUser: true` in the `MaasTenantConfig` (disabled by default); without it the dashboard aggregates at subscription level only

## Assumptions

- RHOAI 3.5 is installed with MaaS enabled and external metering configured
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- Learners have dashboard access to the Observe & monitor → Dashboard page (cluster-administrator-level surface)

## Related Designs

- RHAIBU-M33D7VBYRMGZ

## Related Decisions

- RHAIBU-M33D7VBMH8T2
- RHAIBU-M33D7VBSAVYM

## Related Requirements

- RHAIBU-M33D7VB7FJKF
- RHAIBU-M33D7VBEA1PY
