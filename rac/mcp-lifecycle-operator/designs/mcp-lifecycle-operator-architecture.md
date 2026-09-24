---
schema_version: 1
id: RHAIBU-M33DS10C9RMB
type: design
---
# MCP Lifecycle Operator Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. The MCP Lifecycle Operator (TP) is the agents-mcp anchor
feature: the gateway installation flow, `MCPGatewayExtension` wiring, and the
`MCPServerRegistration`/`MCPVirtualServer` lifecycle taught here underpin the
MCP gateway operator and MCP tier catalog features in the same catalog. The
feature rides on Red Hat Connectivity Link MCP gateway documentation
(RHEL Connectivity Link 1.4) rather than core RHOAI docs.

## User Need

Platform engineers and AI platform administrators with OpenShift, OLM, and
Gateway API working knowledge need a 60–90 minute guided path from installing
the MCP gateway Operator to a serving, discoverable, curated MCP endpoint —
with every step verifiable from the CLI.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/mcp-lifecycle-operator/content/`):

1. **Module 01: Getting Started** — install the MCP gateway deployment Operator
   with OLM (`Subscription`/`OperatorGroup` on the `preview` channel, CSV
   `Succeeded`), create a Gateway with `http` and `mcps` listeners
   (`Accepted`/`Programmed`), apply the `MCPGatewayExtension` CR and verify the
   automatic `mcp-gateway-route` HTTPRoute and managed Envoy filter
2. **Module 02: Hands-on Exercise** — register a backend MCP server
   (HTTPRoute + `MCPServerRegistration` with `prefix`), verify tool and prompt
   discovery through the unified `/mcp` endpoint with session-scoped `curl`
   (`tools/list`, `prompts/list`, `prompts/get`), curate with `MCPVirtualServer`
   via the `X-Mcp-Virtualserver` header, and unregister cleanly

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links onward to gateway authentication,
authorization, and credential management policies.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP`; alpha-CRD warning (`mcp.kuadrant.io/v1alpha1`) inline in both modules
- Every code block containing `{attributes}` uses `subs="attributes"` (workshop manifests use `{guid}`, `{user}`, `{openshift_cluster_ingress_domain}` substitutions)
- Technology Preview scope: the Operator's lifecycle is independent of the OpenShift AI operator; no invented CRD fields beyond the Connectivity Link docs
- Connectivity Link 1.4.1 or later required — 1.4.0 deprecation flagged inline in module 01

## Rationale

TP maturity still supports full hands-on depth here because every command,
CR, and console path is verbatim from the official Connectivity Link MCP
gateway docs — the no-fabrication guardrail is satisfied without a live
cluster. Module order follows the learner's dependency chain (install and
extend gateway → register and verify servers), matching the module flow in
the related requirements. Two modules suffice because the feature's install
and lifecycle halves map cleanly onto the two documented sources.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Three modules (install / register / curate)** — rejected: the curation and unregister flow is short; splitting it out breaks the end-to-end lifecycle narrative
- **Doc-transcription order (CRD API reference first)** — rejected: learners need a working gateway before registration semantics

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Callout markers (`<1>`–`<4>`) on YAML blocks instead of inline comments so annotations survive copy-paste

## Open Questions

- Confirm the Installed Operators console status rendering for the `preview`-channel operator against a live 3.5 console (doc-derived)
- Backend MCP server availability in workshop clusters (e.g. an MCP Catalog-deployed server) must be confirmed before Act-phase testing of module 02
- Whether the `2025-11-25` MCP protocol version in the `initialize` payload tracks future broker releases

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33DS0ZP7D08
- RHAIBU-M33DS0ZT56SF
- RHAIBU-M33DS0ZZ0J4F

## Related Decisions

- RHAIBU-M33DXC0R0JKG
- RHAIBU-M33DXC14VGYN
