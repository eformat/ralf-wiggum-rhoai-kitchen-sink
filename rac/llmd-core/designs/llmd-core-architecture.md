---
schema_version: 1
id: RHAIBU-M33CJ4D7HQXC
type: design
---
# Distributed Inference with llm-d Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Distributed Inference with llm-d (GA) is the model-serving
anchor feature: the topology patterns, `LLMInferenceService` API, and routing
configuration taught here are prerequisites for the llm-d priority flow control
and advanced-routing features in the same catalog.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
45–90 minute guided path from cluster inspection to a serving, authenticated
llm-d endpoint, and onwards to advanced routing — with every step verifiable.

## Design

Three modules plus shared bookends, one Antora component
(`features/model-serving/llmd-core/content/`):

1. **Module 01: Core Concepts** — architecture walkthrough (topology patterns table) + cluster inspection (`kserve.managementState`, Gateway `PROGRAMMED`, `oc get llminferenceservice -A`)
2. **Module 02: Hands-on Exercise** — wizard deployment (topology selector, TP-flagged), CLI deployment via `LLMInferenceService` manifest with YAML callouts, authenticated inference via ServiceAccount token (200/401 negative test)
3. **Module 03: Advanced Usage** — advanced routing via router configs + `spec.baseRefs` verification; template management under `Settings → llm-d topology configurations`

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the two source books.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- Wizard topology selector is Technology Preview in 3.5 — must be flagged inline
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (inspect → deploy → shape
traffic), matching the module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Doc-transcription order (API first)** — rejected: learners need cluster context before manifest syntax

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `Settings → llm-d topology configurations` menu label against a live 3.5 console (doc-derived)
- Router template availability in workshop clusters must be confirmed before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33CJ4C9MQKD
- RHAIBU-M33CJ4CETEWH
- RHAIBU-M33CJ4CNZAZY
- RHAIBU-M33CJ4CRNZ3N

## Related Decisions

- RHAIBU-M33CJ4CX4WMJ
- RHAIBU-M33CJ4D22D76
