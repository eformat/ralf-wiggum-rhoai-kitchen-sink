---
schema_version: 1
id: RHAIBU-M33FS2YMYMDW
type: design
---
# LLMInferenceService / LLMInferenceServiceConfig Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. LLMInferenceService / LLMInferenceServiceConfig (llm-d-native)
is a GA model-serving feature: the CR composition, config-type label discovery,
and `baseRefs` merge order taught here are prerequisites for the llm-d priority
flow control and advanced-routing features in the same catalog.

## User Need

Platform engineers and ML administrators with OpenShift working knowledge need a
~2-hour guided path from cluster inspection to a serving, authenticated
llm-d-native endpoint, and onwards to admin template management and
disaggregated prefill/decode serving — with every step verifiable.

## Design

Three modules plus shared bookends, one Antora component
(`features/model-serving/llminferenceservice-config/content/`):

1. **Module 01: Core Concepts** — CR walkthrough (five spec sections: `model`, `router`, `scheduler`, `template`, `baseRefs`), topology patterns table with config-type labels, cluster inspection (`oc api-resources`, Gateway `ACCEPTED`/`PROGRAMMED`, gateway pod, controller pods)
2. **Module 02: Hands-on Exercise** — CLI deployment via `LLMInferenceService` manifest with empty `router`/`scheduler` maps and YAML callouts, `Ready` condition + `status.addresses` verification, authenticated chat-completion via ServiceAccount JWT (200/401 negative tests)
3. **Module 03: Advanced Usage** — `llmdTemplates` feature flag enablement, topology template creation with wizard radio-button verification, router configuration with `supported-topologies` annotation and `spec.baseRefs` merge-order verification, optional disaggregated prefill/decode workload with `prefill` spec section

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the source documentation.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity`; `LLMInferenceService`/`LLMInferenceServiceConfig` are GA but the topology selector wizard and template management pages are Technology Preview — must be flagged inline
- Every code block containing `{attributes}` uses `subs="attributes"`
- Wizard exercises require the `llmdTemplates` dashboard feature flag and cluster administrator privileges

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (inspect → deploy → shape
topology), matching the module-flow in the related requirements. Admin-side
template management lands last because it depends on a deployed model to
verify the `baseRefs` merge.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Wizard-first order (topology selector before CLI)** — rejected: the wizard is Technology Preview and consumes templates that only make sense after the CR concepts; CLI deployment is the GA path

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `Settings → llm-d topology configurations` and `llm-d routing configurations` menu labels against a live 3.5 console (doc-derived)
- RDMA-capable networking and multi-GPU capacity in workshop clusters must be confirmed before Act-phase testing of module 03 disaggregation
- Confirm `serving.kserve.io/v1alpha2` (disaggregated example) vs `v1alpha1` (module 02 example) API version stability across releases

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FS2X4T4NW
- RHAIBU-M33FS2XCDCFY
- RHAIBU-M33FS2XK1NJR
- RHAIBU-M33FS2XV37B4

## Related Decisions

- RHAIBU-M33FS2Y35VB6
- RHAIBU-M33FS2YB2WBT
