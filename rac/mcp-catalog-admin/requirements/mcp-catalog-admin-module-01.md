---
schema_version: 1
id: RHAIBU-M33DK8F0GBC2
type: requirement
---
# Module 01: Guided tour of the MCP Catalog administrative interface

## Problem

Before administering MCP catalog entries, learners need to confirm their cluster
is ready, find where the administrative interface lives in the dashboard, and
see how the YAML-based entry lifecycle replaces manual ConfigMap edits. Without
this guided tour, later administration steps are copy-paste with no
understanding of what is being changed or who it affects.

## Requirements

- [REQ-011] Learner MUST be able to verify cluster readiness with three read-only commands: `oc get datasciencecluster`, the `mcplifecycleoperator` installedComponents jsonpath (expected `true`), and the `mcpCatalog` dashboardConfig jsonpath (expected `true`)
- [REQ-012] Learner MUST be able to navigate to the dashboard Settings page and observe the list of configured MCP catalog source entries with their status
- [REQ-013] Learner MUST be able to confirm the access boundary: catalog management controls are restricted strictly to OpenShift AI administrators
- [REQ-014] Learner MUST be able to walk the add, edit, and remove entry lifecycle via YAML-based creation and confirm from `AI hub` → `MCP servers` that catalog cards reflect the changes with no `oc apply` step

## Success Metrics

Learner completes all three exercises: the cluster readiness checks produce the
documented expected output (`true` for both jsonpath checks), the Settings-page
tour identifies the entry list and access controls, and the entry round trip is
visible in the AI Hub MCP Catalog.

## Risks

- If the `mcpCatalog` flag is missing or `false`, the facilitator must enable it first (enablement is walked through hands-on in the MCP Catalog support-tier labeling workshop)

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- Learner has OpenShift AI administrator access for the catalog management operations

## Related Requirements

- RHAIBU-M33DK8EWJ8XK

## Verified By

- features/agents-mcp/mcp-catalog-admin/content/modules/ROOT/pages/module-01-hands-on.adoc
