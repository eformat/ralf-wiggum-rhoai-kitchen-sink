---
schema_version: 1
id: RHAIBU-M33DE6RH8Z20
type: design
---
# LoRA-aware Routing for llm-d Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. LoRA-aware routing for llm-d (DP) extends the model-serving
anchor: it rides on Distributed Inference with llm-d, the GA serving stack whose
Endpoint Picker owns request placement. Unlike the anchor feature, LoRA-aware
routing is documented only as a Developer Preview release-notes entry — there
is no dedicated configuration procedure chapter in 3.5 — so the workshop is a
guided tour of the documented routing surfaces it builds on rather than a
configuration guide.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
60–90 minute guided path from the cold-load latency problem to observing
adapter-aware routing behavior in EPP metrics and the advanced routing wizard
workflow — with every step verifiable despite the DP status.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/llmd-lora-routing/content/`):

1. **Module 01: Getting Started** — LoRA-aware request routing walkthrough
   (cold-load latency, fallback semantics, DP release-notes status) + the llm-d
   serving stack mapping (Endpoint Picker flow control and scheduling layers,
   `model_name`/`target_model_name` labels, routing-group
   `GroupDegraded`/`MemberDivergence` partitioning) + read-only cluster
   inspection (`oc get llmisvc`, `oc get llminferenceserviceconfig -A`, wizard
   Advanced routing pre-selection)
2. **Module 02: Hands-on Exercise** — EPP metrics table (`llm_d_epp_request_`
   prefix with `model_name`, `target_model_name`, `fairness_id`, `priority`
   labels), the advanced routing deployment workflow with `spec.baseRefs`
   verification via `oc get llmisvc -o yaml | grep -A 6 baseRefs`, and repeated
   inference requests to observe warm-up and fallback behavior in TTFT and
   request-total metrics

Bookends: Overview (DP maturity banner via `ifeval`) and Getting Connected are
shared boilerplate; Conclusion links the llm-d documentation chapters.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP`
- DP status forbids inventing a configuration procedure: commands are read-only `oc` inspections and wizard walkthroughs sourced from the release notes and the llm-d routing/metrics chapters
- The wizard's topology selector portion is Technology Preview in 3.5 and is not exercised directly — only its Advanced routing section is observed
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

DP maturity and release-notes-only documentation drive a guided-tour depth:
concept mapping and read-only inspection rather than resource mutation. Module
order follows the learner's dependency chain (understand → observe), matching
the module flow in the related requirements. The EPP metrics table grounds the
abstraction: `target_model_name` is the observable trace of adapter-aware
placement even in a workshop without multiple adapters.

## Alternatives

- **Full adapter-deployment lab** — rejected: no documented 3.5 procedure exists for deploying LoRA adapters with llm-d; fabricating one would violate the no-fabrication guardrail
- **Doc-transcription order (routing-group internals first)** — rejected: learners need the cold-load latency problem before the partitioning behavior makes sense
- **Single mega-module** — rejected: loses per-exercise verification and the nav loses module granularity

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `Settings → llm-d routing configurations` menu label against a live 3.5 console (doc-derived)
- Router configuration availability in workshop clusters must be confirmed before Act-phase testing
- Whether LoRA-aware routing graduates to TP/GA with a dedicated configuration chapter in 3.6 (Mode 3 version bump should re-check)

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33DE6QRF0A2
- RHAIBU-M33DE6QWQY7X
- RHAIBU-M33DE6QZY0YJ

## Related Decisions

- RHAIBU-M33DE6R5ED69
- RHAIBU-M33DE6RB6AAK
