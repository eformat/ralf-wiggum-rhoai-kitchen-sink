---
schema_version: 1
id: RHAIBU-M33CV71QBMB9
type: design
---
# Agent Catalog in AI Hub Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Agent Catalog in AI Hub (DP) is one of the AI Hub catalog
features documented only in the release notes: its UI is gated behind the
`agentsCatalog` flag in the `OdhDashboardConfig` custom resource, the same
dashboard configuration mechanism used by the MCP catalog. There is no
`DataScienceCluster` component for this feature — enablement and diagnosis both
route through the dashboard config resource.

## User Need

Platform engineers and AI practitioners with cluster administrator access need a
30–45 minute guided path from enabling a hidden Developer Preview dashboard
feature to surveying the pre-loaded agent starter kits — browsing, filtering by
framework, searching by use case, and reading catalog entries — with every step
verifiable against release-notes behavior.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/agent-catalog-ai-hub/content/`):

1. **Module 01: Getting Started** — inspect the current `agentsCatalog` flag state (`oc get odhdashboardconfig ... -o jsonpath='{.spec.dashboardConfig.agentsCatalog}'`), patch `OdhDashboardConfig` with `agentsCatalog: true`, hard-refresh the dashboard, open the catalog from *AI hub → Agents* and scan the pre-loaded starter kits
2. **Module 02: Hands-on Exercise** — browse and framework-filter the catalog list, text-search by use case (`code`, `research`), open catalog entries and read description, framework, and README; closing note points to dedicated DP starter kits (OpenClaw, Claude Code) that ship their own deployment guides

Bookends: Overview (DP maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the release notes.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- DP maturity banner via `ifeval` on `feature_maturity: DP` in both the Overview and both modules
- DP feature documented only in release notes — commands limited to the `agentsCatalog` flag check/patch; catalog exploration is a guided tour with no fabricated API or deploy steps
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

DP maturity drives an honest guided-tour depth: the flag enablement is fully
hands-on with `=== Verify` sections, while catalog exploration is observation
based because the release notes specify no deploy workflow. Module order follows
the learner's dependency chain (enable → explore), matching the module-flow in
the related requirements.

## Alternatives

- **Single mega-module** — rejected: flag enablement (admin, CLI) and catalog exploration (all users, UI) are distinct audiences and the nav loses module granularity
- **Fabricate a deploy exercise** — rejected: the release notes document no deploy path for the catalog itself; deploying is the job of per-starter-kit guides

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the pre-loaded starter kit list and framework filter options against a live 3.5 console (doc-derived from release notes)
- Confirm whether a dashboard pod restart (not just a browser refresh) is ever required after patching `OdhDashboardConfig`
- Watch for the `agentsCatalog` flag name changing between 3.5 releases (DP contract)

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33CV6ZMZY9C
- RHAIBU-M33CV702JM2V
- RHAIBU-M33CV70FNDNW

## Related Decisions

- RHAIBU-M33CV70W9SX8
- RHAIBU-M33CV7186VG2
