---
schema_version: 1
id: RHAIBU-M33DDPKV0HZV
type: design
---
# Hierarchical KV Cache Tiering Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Hierarchical KV Cache Tiering (DP) rides on Distributed
Inference with llm-d and builds directly on the llmd-core workshop: the Endpoint
Picker layers, scorer profile, and router-configuration mechanics taught here
extend the core deployment path with cache-aware routing and metrics.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
45–60 minute guided path from understanding KV cache tiering to a verified
KV-cache-aware router attachment and real cache-metric observations — with every
step verifiable, even where the DP feature itself has no tier-configuration UI.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/llmd-kv-cache-tiering/content/`):

1. **Module 01: Getting Started** — tiering concepts (operators configure tiers,
   placement is automatic), Endpoint Picker Flow Control vs Scheduling layers,
   default 2:2:3:2 scorer profile table, `precise-prefix-cache-scorer` upgrade
   note, cluster inspection (`oc get llmisvc`, `oc get llminferenceserviceconfig
   -A`), wizard Advanced routing default observation
2. **Module 02: Hands-on Exercise** — KV-cache-aware router configuration YAML
   callouts (label, annotation, scheduler, scorer weights), router selection in
   the deployment wizard, `spec.baseRefs` verification, `llm_d_epp_` metrics
   observation with repeated inference requests and vLLM saturation-tuning tips

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the KV Cache Offloading documentation for
the tier configuration itself.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP`
- Feature is Developer Preview in 3.5 — inline DP labeling required; no invented tier-configuration commands (tier steps live in the KV Cache Offloading docs, out of scope)
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

DP maturity drives a guided-tour-plus-hands-on hybrid: concepts and read-only
cluster inspection (module 01) plus real router-attachment and metrics
exercises that work on the underlying GA llm-d stack (module 02). Module order
follows the learner's dependency chain (understand → inspect → attach →
observe), matching the module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Fabricated KV cache tier-configuration commands** — rejected: the tier configuration steps live in the KV Cache Offloading docs, not this workshop's evidence; violating docs-first would produce untestable content

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Whether a KV-cache-aware router configuration is pre-provisioned in workshop clusters; if not, module 02 exercise 2 falls back to `Default optimized routing`
- Which `llm_d_epp_` metrics are scraped into the workshop monitoring stack; learners may need the EPP metrics service path instead of the console Observe section

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33DDPJHFZQQ
- RHAIBU-M33DDPJS2ZZW
- RHAIBU-M33DDPK13SJK

## Related Decisions

- RHAIBU-M33DDPKAQ0PF
- RHAIBU-M33DDPKJV4C3
