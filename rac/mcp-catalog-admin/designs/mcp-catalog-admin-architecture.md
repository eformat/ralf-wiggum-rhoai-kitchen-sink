---
schema_version: 1
id: RHAIBU-M33DK8FP5DRK
type: design
---
# MCP Catalog Administrative Interface Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. The MCP Catalog administrative interface (DP) is the
administrator-facing control surface for the catalog: it governs the MCP server
entries that feed the AI Hub MCP Catalog discovery UI. It sits downstream of the
MCP Lifecycle Operator and the `mcpCatalog` dashboard flag, and it is a
prerequisite concept for the MCP Catalog support-tier labeling workshop in the
same catalog.

## User Need

OpenShift AI administrators with dashboard access need a ~30 minute guided path
from cluster readiness checks to a full add/edit/remove entry lifecycle in the
Settings page — with the round trip visible from the developer's point of view
in the AI Hub MCP Catalog, and every step verifiable.

## Design

Single module plus shared bookends, one Antora component
(`features/agents-mcp/mcp-catalog-admin/content/`):

1. **Module 01: Guided tour of the MCP Catalog administrative interface**
   - Exercise 1: cluster readiness — `oc get datasciencecluster`, the
     `mcplifecycleoperator` installedComponents jsonpath, and the
     `mcpCatalog` dashboardConfig jsonpath (all expected `true`); NOTE
     block with facilitator enablement patch commands
   - Exercise 2: Settings-page tour — entry list with status, administrator-only
     access boundary, optional contrast with Model catalog settings
   - Exercise 3: entry lifecycle — old-way ConfigMap YAML with callouts, then
     new-way YAML-based add/edit/remove dialogs; verify from
     `AI hub` → `MCP servers` that catalog cards reflect the changes

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the RHOAI 3.5 release notes.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP`
- Developer Preview: Settings page layout and dialog fields may change between releases — exact labels flagged as indicative inline
- Every code block containing `{attributes}` uses `subs="attributes"`
- Screenshots are `// TODO: capture screenshot` placeholders until the Act phase

## Rationale

DP maturity drives an honest guided-tour depth: read-only readiness checks and
observed UI workflows rather than fabricated console screenshots. The single
module mirrors the feature's narrow admin surface, and the exercise order
follows the learner's dependency chain (verify cluster → find the interface →
exercise the lifecycle), matching the module-flow in the related requirements.

## Alternatives

- **Multi-module split (concepts / hands-on)** — rejected: the feature is a single admin surface; a split adds nav overhead for ~30 minutes of content
- **Hands-on enablement module first** — rejected: enablement is owned by the MCP Catalog support-tier labeling workshop; duplicating it here would drift

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Exact Settings-page submenu label for the MCP catalog settings entry on a live 3.5 console (doc-derived; release notes are the fallback reference)
- Whether the add/edit/remove dialogs expose entry-level enable/disable state that learners should exercise (doc-derived only)

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33DK8EWJ8XK
- RHAIBU-M33DK8F0GBC2

## Related Decisions

- RHAIBU-M33DK8F7DB7P
- RHAIBU-M33DK8FE75WG
