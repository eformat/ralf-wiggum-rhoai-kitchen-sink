---
schema_version: 1
id: RHAIBU-M33FJXB8HQB6
type: design
---
# Multi-provider API passthrough for external models (MaaS) Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Multi-provider API passthrough for external models (TP) is a
MaaS feature: the `ExternalProvider`/`ExternalModel`/`MaaSModelRef` resource
chain, the format-detection rules, and the passthrough decision matrix taught
here build on the MaaS governance foundation and depend on the MaaS gateway
being deployed in the DSC.

## User Need

Cluster administrators with OpenShift working knowledge need a 60–90 minute
guided path from prerequisite verification to a governed external model serving
native Anthropic Messages requests through the MaaS gateway — including
single-URL passthrough for AI coding tools such as Claude Code — with every
step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/maas/maas-multi-provider-passthrough/content/`):

1. **Module 01: Getting Started** — prerequisite verification (CRDs, `maas-api` pod, MaaS subscription), format-detection and passthrough-decision walkthrough (`/v1/messages`, `/v1/responses`, `/v1/chat/completions` tables), model namespace `{guid}-llm`, labeled provider API key secret, `ExternalProvider` creation with `ServiceEntry`/`DestinationRule` verification
2. **Module 02: Hands-on** — `ExternalModel` with `apiFormat: messages` plus `MaaSModelRef` publication, subscription governance and the *External models* tab, end-to-end passthrough with `x-api-key` curl requests to `/v1/messages`, and single-URL body-based routing via `ANTHROPIC_BASE_URL`

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the source documentation chapters.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (`%anthropic-api-key%`, `%maas-api-key%`, `%maas-gateway-url%`) — no secrets
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP` — Technology Preview flags inline in Overview and both modules
- Every code block containing `{attributes}` uses `subs="attributes"`
- Passthrough limitations must be surfaced honestly: no MaaS subscription-level token metering for passthrough formats, buffered streaming during cross-format translation, 16 KB body truncation with the Kuadrant wasm shim, NeMo Guardrails response guards not inspecting non-OpenAI formats

## Rationale

TP maturity still drives full hands-on depth because the feature has a complete,
verbatim-documented CLI workflow with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (verify → configure →
route → govern → test), matching the module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Vertex AI or OpenAI Responses as the primary example** — rejected: Anthropic Messages is the doc's canonical passthrough example and matches AI coding tool usage; Vertex AI differences are covered as walkthrough content only

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Format-detection and decision-matrix tables carry descriptive block roles (`[format-detection]`, `[decision-matrix]`)

## Open Questions

- Confirm the *External models* tab rendering and provider-details sub-table against a live 3.5 console (doc-derived; `spec.dashboardConfig.externalModels` must be true)
- Confirm the `maas-api` pod output and `redhat-ai-gateway-infra` namespace naming on a live cluster
- External endpoint reachability (api.anthropic.com) from workshop clusters must be confirmed before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FJXA0RAZF
- RHAIBU-M33FJXA915W8
- RHAIBU-M33FJXAJXJ9X

## Related Decisions

- RHAIBU-M33FJXASQFXR
- RHAIBU-M33FJXB0445B
