---
schema_version: 1
id: RHAIBU-M33CV702JM2V
type: requirement
---
# Module 01: Getting Started

## Problem

Before browsing the catalog, learners must understand what the Agent Catalog in
AI Hub is and how its visibility is controlled: the UI is gated behind the
`agentsCatalog` flag in the `OdhDashboardConfig` custom resource, not by a
component in the `DataScienceCluster` object. Without this orientation, learners
cannot enable the Developer Preview feature or diagnose a missing *AI hub →
Agents* menu item.

## Requirements

- [REQ-011] Learner MUST be able to check the current state of the `agentsCatalog` flag with `oc get odhdashboardconfig odh-dashboard-config -n redhat-ods-applications -o jsonpath='{.spec.dashboardConfig.agentsCatalog}'` (empty output means hidden, `true` means already enabled)
- [REQ-012] Learner MUST be able to patch the `OdhDashboardConfig` custom resource with `--type=merge -p '{"spec":{"dashboardConfig":{"agentsCatalog":true}}}'` and receive the `odhdashboardconfig.opendatahub.io/odh-dashboard-config patched` confirmation
- [REQ-013] Learner MUST be able to confirm the flag now reads `true` and hard-refresh the dashboard so the *AI hub → Agents* page shows a browsable list of pre-loaded agent starter kits

## Success Metrics

Learner completes all three exercises: the flag-state inspection, the
`OdhDashboardConfig` patch, and opening the catalog from the dashboard — each
producing the documented expected output.

## Risks

- Patching `OdhDashboardConfig` requires cluster administrator privileges
- If the *Agents* menu item does not appear after patching, dashboard pod logs must be checked for errors

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- The OpenShift AI operator has created the default `odh-dashboard-config` resource

## Related Requirements

- RHAIBU-M33CV6ZMZY9C

## Verified By

- features/agents-mcp/agent-catalog-ai-hub/content/modules/ROOT/pages/module-01-getting-started.adoc
