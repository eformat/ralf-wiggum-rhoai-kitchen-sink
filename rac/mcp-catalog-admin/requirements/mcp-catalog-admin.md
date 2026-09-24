---
schema_version: 1
id: RHAIBU-M33DK8EWJ8XK
type: requirement
---
# MCP Catalog Administrative Interface Workshop

## Problem

OpenShift AI administrators need hands-on experience with the MCP Catalog
administrative interface — the Developer Preview Settings-page surface for
managing MCP server catalog entries — before they can administer it for their
teams. Without a structured workshop, administrators must reverse-engineer the
enablement checks, the Settings-page entry lifecycle, and the ConfigMap-based
approach it replaces from product documentation alone. This workshop targets
RHOAI 3.5 users with administrator access to the dashboard and working
knowledge of OpenShift.

## Requirements

- [REQ-001] Learner MUST be able to confirm the `DataScienceCluster` object exists (typically `default-dsc`) with `oc get datasciencecluster`
- [REQ-002] Learner MUST be able to verify the MCP Lifecycle Operator is installed via `.status.installedComponents.mcplifecycleoperator` returning `true`
- [REQ-003] Learner MUST be able to verify the `mcpCatalog` dashboard feature flag is enabled via `.spec.dashboardConfig.mcpCatalog` returning `true` on `odhdashboardconfig` in `redhat-ods-applications`
- [REQ-004] Learner MUST be able to tour the dashboard Settings page and observe the list of MCP catalog source entries with their status
- [REQ-005] Learner MUST be able to add an MCP catalog entry through YAML-based creation in the dashboard, without any `oc apply` step
- [REQ-006] Learner MUST be able to edit an existing MCP catalog entry's YAML and save the changes
- [REQ-007] Learner MUST be able to remove an MCP catalog entry and observe its servers disappear from the AI Hub MCP Catalog (`AI hub` → `MCP servers`)
- [REQ-008] Learner SHOULD be able to contrast the interface with the manual ConfigMap-based approach it replaces and recognize the aligned Model Catalog administrative interface UX

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the
single-module lab: both jsonpath enablement checks return `true`, the
add/edit/remove round trip completes with no CLI ConfigMap edits, and the
AI Hub MCP Catalog cards reflect the entry changes from the developer's point
of view.

## Risks

- The feature is Developer Preview in 3.5 — the Settings page layout and dialog fields may change between releases, so exact labels are indicative
- The `mcpCatalog` flag and MCP Lifecycle Operator must be pre-enabled; if the jsonpath check returns `false`, the facilitator must enable them first
- Removing a catalog entry changes what every user in the organization can discover in the AI Hub MCP Catalog — coordination is required before deleting shared entries

## Assumptions

- RHOAI 3.5 is installed on an OpenShift 4.22 or later cluster with the RHOAI operator
- MCP Catalog is enabled (MCP Lifecycle Operator installed and `mcpCatalog` flag on)
- The learner has OpenShift AI administrator access to the dashboard for the catalog management operations

## Related Designs

- RHAIBU-M33DK8FP5DRK

## Related Decisions

- RHAIBU-M33DK8F7DB7P
- RHAIBU-M33DK8FE75WG

## Related Requirements

- RHAIBU-M33DK8F0GBC2
