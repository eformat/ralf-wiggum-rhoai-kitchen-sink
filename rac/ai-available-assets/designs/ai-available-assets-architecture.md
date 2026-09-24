---
schema_version: 1
id: RHAIBU-M33CTVQ1Z5SZ
type: design
---
# AI Available Assets Page Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. The AI Available Assets page (GA) is the discovery anchor
for the Gen AI studio: the asset categories, the `gen-ai-aa-mcp-servers`
ConfigMap contract, and the *Add as AI asset endpoint* deployment option taught
here are prerequisites for the gen AI playground and MCP management features in
the same catalog.

## User Need

AI engineers and application developers with dashboard access and `oc` CLI
credentials need a 60–90 minute guided path from locating the AI asset endpoints
page to publishing an MCP server, deploying a model as an AI asset endpoint, and
consuming it in a configured Gen AI playground — with every step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/ai-available-assets/content/`):

1. **Module 01: Discover AI assets in the dashboard** — page tour (`Gen AI studio → AI asset endpoints`, Models and MCP servers tabs, project scoping) + MCP server publication via the `gen-ai-aa-mcp-servers` ConfigMap in `redhat-ods-applications` with YAML callouts
2. **Module 02: Publish and consume a model asset** — wizard deployment with the *Add as AI asset endpoint* checkbox and use-case label, CLI verification via `oc get inferenceservice`, playground creation from the *Add to playground* action, optional custom endpoints via `OdhDashboardConfig` flags

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the four source docs.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity`
- The `gen-ai-aa-mcp-servers` ConfigMap name and `redhat-ods-applications` namespace are exact-match contracts with the dashboard — must not be paraphrased
- Custom endpoints and MaaS integration are flagged Technology Preview / Developer Preview in the docs — must be flagged inline
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

The workshop scope is the discovery page itself, so module order follows the
learner's dependency chain (discover → publish → deploy → consume), matching the
module-flow in the related requirements. Two modules keep the lab inside the
60–90 minute estimate; the optional custom-endpoint exercise is segregated so
clusters without administrator privileges can still complete the core path.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Docs-transcription order (ConfigMap API first)** — rejected: learners need to see the page and its categories before publishing into it

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `Gen AI studio → AI asset endpoints` navigation label against a live 3.5 console (doc-derived)
- The gen AI playground docs mark the AI asset endpoints page as Technology Preview while the feature matrix records GA — confirm the actual 3.5 support tier
- Whether the `Agents tab` on the AI asset endpoints page (documented in the playground docs) belongs in the workshop scope

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33CTVKS1W3G
- RHAIBU-M33CTVMB23E3
- RHAIBU-M33CTVN1VNYS

## Related Decisions

- RHAIBU-M33CTVNM5D1V
- RHAIBU-M33CTVP8SMCG
