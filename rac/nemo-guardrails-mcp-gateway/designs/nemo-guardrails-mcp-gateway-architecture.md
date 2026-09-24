---
schema_version: 1
id: RHAIBU-M33F0QQKS846
type: design
---
# NeMo Guardrails integration with MCP Gateway Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. NeMo Guardrails integration with MCP Gateway (Technology
Preview) is the guardrails anchor feature for agent tool-call enforcement: the
`mcpGateway` configuration, discovery mechanism, and status fields taught here
are prerequisites for understanding gateway-layer AI safety enforcement across
the guardrails features in the same catalog.

## User Need

Platform engineers and AI practitioners with OpenShift working knowledge need a
60–90 minute guided path from verifying MCP gateway prerequisites to a tested
standalone NeMo Guardrails service and onwards to enforcement wired into the
gateway — with every step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/guardrails/nemo-guardrails-mcp-gateway/content/`):

1. **Module 01: Getting Started** — integration concept walkthrough (gateway
   discovery via `MCPGatewayExtension` targetRef → BBR plugin detection →
   `mcp-sse-strip` auto-provisioning) + prerequisite verification
   (`oc get mcpgatewayextensions`, EnvoyFilter BBR grep) + standalone NeMo
   Guardrails deployment with built-in Presidio/regex detectors and
   `/v1/guardrail/checks` positive/negative tests
2. **Module 02: Hands-on Exercise** — `NemoGuardrails` CR with the
   `mcpGateway` field (named gateway lookup), status verification
   (`{"mcpGatewayFound":true}`, `{"bbrPluginFound":true}`), `mcp-sse-strip`
   verification, EnvoyFilter lifecycle exercise (remove/restore `mcpGateway` →
   delete/recreate), and a troubleshooting section on discovery failures

Bookends: Overview (TP banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the two source doc sets (RHOAI Guardrails
and RHCL MCP gateway installation).

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP`
- Technology Preview warning inline; CRD API versions (`trustyai.opendatahub.io/v1alpha1`, `mcp.kuadrant.io/v1alpha1`) flagged as subject to change
- Every code block containing `{attributes}` uses `subs="attributes"`
- The MCP gateway Operator, `MCPGatewayExtension` resources, and BBR plugins are facilitator-deployed external prerequisites — learners never install them

## Rationale

Technology Preview maturity, but complete doc evidence (RHOAI 3.5 Guardrails
guide §1.3–1.5 + RHCL 1.4 MCP gateway install guide) supports full hands-on
depth with per-exercise `=== Verify` sections. Module order follows the
learner's dependency chain (verify prerequisites → standalone rails → wire
into gateway → observe lifecycle), matching the module-flow in the related
requirements.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Learners install the MCP gateway themselves** — rejected: gateway installation is Connectivity Link scope and an external prerequisite per the docs, not part of the RHOAI guardrails integration
- **Guided-tour-only lab (no commands)** — rejected: the doc evidence is complete enough for verbatim, tested commands

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the CR status JSON shape (`status.mcpGateway`, `status.bbrPlugin`) against a live 3.5 console (doc-derived)
- BBR plugin EnvoyFilter availability in workshop clusters must be confirmed before Act-phase testing
- `mCPGuardrailsOnlyMode=True` standalone-mode behavior in the workshop DataScienceCluster must be confirmed with the facilitator

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33F0QPJ2XT7
- RHAIBU-M33F0QPSWBDW
- RHAIBU-M33F0QQ0SETN

## Related Decisions

- RHAIBU-M33F0QQ6P5SF
- RHAIBU-M33F0QQC12FT
