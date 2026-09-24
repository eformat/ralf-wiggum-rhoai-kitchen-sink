---
schema_version: 1
id: RHAIBU-M33CV6ZMZY9C
type: requirement
---
# Agent Catalog in AI Hub Workshop

## Problem

Platform engineers and AI practitioners evaluating RHOAI 3.5 need hands-on
experience with the Agent Catalog in AI Hub — the Developer Preview interface for
discovering and exploring agent starter kits built on LangGraph, CrewAI,
LlamaIndex, and other agentic frameworks — before they can recommend which
starter kit to adopt. Without a structured workshop, learners must discover the
`agentsCatalog` dashboard feature flag, its `OdhDashboardConfig` enablement
mechanism, and the catalog browsing workflow from release notes alone. This
workshop targets RHOAI users with cluster administrator access and basic
OpenShift CLI familiarity.

## Requirements

- [REQ-001] Learner MUST be able to observe the current state of the `agentsCatalog` dashboard flag in the `OdhDashboardConfig` custom resource (`oc get odhdashboardconfig ... -o jsonpath='{.spec.dashboardConfig.agentsCatalog}'`)
- [REQ-002] Learner MUST be able to enable the Agent Catalog by patching the `OdhDashboardConfig` custom resource with `agentsCatalog: true` and receive the `patched` confirmation
- [REQ-003] Learner MUST be able to confirm the flag reads `true` after patching and hard-refresh the dashboard so the new configuration applies
- [REQ-004] Learner MUST be able to open the Agent Catalog from *AI hub → Agents* and see a browsable list of pre-loaded agent starter kits
- [REQ-005] Learner MUST be able to filter the catalog by agentic framework and confirm the list narrows to only agents built on the selected framework, then restore the full list
- [REQ-006] Learner MUST be able to search the catalog with use-case text and observe the list narrow to matching agent starter kits
- [REQ-007] Learner MUST be able to open a catalog entry and read its description, framework, and README file with additional information about the agent

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the `agentsCatalog` flag reads `true` in module 01 and the *AI hub → Agents*
page shows a browsable, filterable, searchable catalog in module 02.

## Risks

- Developer Preview feature: catalog contents, filter options, and entry layout may change between releases
- The `agentsCatalog` flag is dashboard-gated only — there is no `DataScienceCluster` component to enable, so cluster misconfiguration shows up as a missing menu item rather than a failed reconcile
- Dashboard feature flags may require a hard browser refresh or dashboard pod restart before the menu item appears

## Assumptions

- RHOAI 3.5 is installed and the OpenShift AI dashboard (AI Hub) is accessible
- Learners have cluster administrator privileges (required to patch `OdhDashboardConfig`)
- Learners have `oc` CLI access and workshop credentials
- The dashboard operator has provisioned the default `odh-dashboard-config` resource in `redhat-ods-applications`

## Related Designs

- RHAIBU-M33CV71QBMB9

## Related Decisions

- RHAIBU-M33CV70W9SX8
- RHAIBU-M33CV7186VG2

## Related Requirements

- RHAIBU-M33CV702JM2V
- RHAIBU-M33CV70FNDNW
