---
schema_version: 1
id: RHAIBU-M33DDTPV452S
type: design
---
# Latency-aware Routing for llm-d Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Latency-aware routing for llm-d (DP) rides on the Distributed
Inference with llm-d serving stack taught in the llmd-core workshop: the
Endpoint Picker's Scheduling layer, `EndpointPickerConfig` plugins, and
router-configuration selection assume that foundation. As a Developer Preview
feature documented across the llm-d routing chapters and the release notes, it
gets an honest guided-tour-to-hands-on path without fabricating cluster state.

## User Need

Platform engineers and ML practitioners with OpenShift and llm-d working
knowledge need a 60–90 minute guided path from understanding per-request
TTFT/TPOT targets, through attaching a latency-aware router configuration to a
real deployment, to reading the `llm_d_epp_request_` metrics that show the
routing decisions — with every step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/llmd-latency-routing/content/`):

1. **Module 01: Getting Started** — guided tour of latency-aware routing
   (TTFT/TPOT targets, latency-sensitive vs throughput-sensitive placement), the
   EPP two-layer model (Flow Control vs Scheduling) and the three latency-aware
   plugins table, then environment readiness via read-only `oc get llmisvc` and
   `oc get llminferenceserviceconfig -A` plus the wizard's Advanced routing
   section with the pre-selected Default optimized routing option
2. **Module 02: Hands-on Exercise** — inspect a latency-aware
   `EndpointPickerConfig` inline example with callouts, view router configs
   under `Settings → llm-d routing configurations` (admin-only), attach a router
   configuration through the deployment wizard and verify `spec.baseRefs`
   ordering, then generate traffic and observe `llm_d_epp_request_` metrics in
   the LLM Performance dashboard with the TTFT-vs-ITL diagnostic patterns

Bookends: Overview (DP maturity banner + prerequisites) and Getting Connected
are shared boilerplate; Conclusion links the Configure request routing and
authenticated-requests chapters of the llm-d documentation.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP` (Developer Preview warning)
- The feature is Developer Preview — no fabrication of unavailable console state; the attach-and-verify exercise documents a Default optimized routing fallback when no compatible router config exists
- Router config inspection and creation are administrator-only — learners inspect, not create
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

DP maturity shapes a guided-tour module 01 with real read-only commands, then a
hands-on module 02 where every command is doc-verbatim. Module order follows the
learner's dependency chain (understand → attach → observe), matching the
module-flow in the related requirements. The inline `EndpointPickerConfig`
example is presented with numbered callouts because the
`latency-scorer` → `predicted-latency-producer` dependency and
`weighted-random-picker` replacement of `max-score-picker` are the structural
facts learners must retain.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Full CLI-first deployment lab** — rejected: router configurations are administrator-managed; the wizard flow is the documented user-facing path for attaching them

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Plugin table uses a header row and is read naturally by screen readers

## Open Questions

- Availability of a pre-provisioned latency-aware router config in workshop clusters must be confirmed before Act-phase testing
- LLM Performance dashboard panels depend on User Workload Monitoring and Cluster Observability Operator configuration in the workshop environment (doc-derived)

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33DDTNAHG76
- RHAIBU-M33DDTNPRE12
- RHAIBU-M33DDTNY28CC

## Related Decisions

- RHAIBU-M33DDTP8SDHR
- RHAIBU-M33DDTPJ2XYG
