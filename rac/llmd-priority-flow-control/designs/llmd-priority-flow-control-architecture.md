---
schema_version: 1
id: RHAIBU-M33FSEAJ74K7
type: design
---
# Flow Control and Priority-Based Queuing Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Flow control and priority-based queuing (GA) is a
model-serving deep-dive that builds directly on the Distributed Inference with
llm-d core workshop: the same `LLMInferenceService` API and Endpoint Picker
taught there are prerequisites here, extended with the `flowControl` feature
gate, `InferenceObjective` priority tiers, and `llm_d_epp_flow_control_*`
observability.

## User Need

Platform engineers and ML practitioners with an already-deployed llm-d workload
need a 45–90 minute guided path from Endpoint Picker inspection to verified
priority-based queuing under load — with every step verifiable against metrics
they query themselves.

## Design

Two modules plus shared bookends, one Antora component
(`features/model-serving/llmd-priority-flow-control/content/`):

1. **Module 01: Getting Started** — locate flow control in the EPP request path (flow control layer vs scheduling layer), inspect the EPP pod and its default four-scorer scheduler config, enable the `flowControl` feature gate + `utilization-detector` saturation detector under `spec.router.scheduler.config.inline`, verify the scheduler ServiceMonitor and query `llm_d_epp_flow_control_pool_saturation`
2. **Module 02: Hands-on Exercise** — create critical (`priority: 100`) and sheddable (`priority: -1`) `InferenceObjective` resources with `poolRef`, configure optional `priorityBands` (capacity limits, request TTL, ordering/fairness policies), drive sustained load, and validate priority queuing via `llm_d_epp_flow_control_queue_size`, `llm_d_epp_flow_control_request_queue_duration_seconds`, and the `x-llm-d-request-dropped-reason` rejection table

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion recaps and links the RHOAI docs for mixed-workload
priority queuing.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- PromQL console queries use `subs="attributes"` for the `{guid}-{user}` namespace substitution
- YAML callout blocks for `InferenceObjective`/`EndpointPickerConfig` use `subs="attributes,callouts"`
- The Gateway's authentication-based header mapping (`x-gateway-inference-objective` = ServiceAccount namespace / `authenticated` / `unauthenticated`) must be explained before naming the objectives

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (inspect → enable → define
tiers → drive load): `InferenceObjective` priorities are not enforced without the
`flowControl` feature gate, so enablement must precede tier creation, and
saturation metrics must be verified before load testing can show queuing.

## Alternatives

- **Single mega-module** — rejected: the enablement step and the load-test step need separate verification gates; combining them makes failures hard to localize
- **Three-module split (concepts → enable → load test)** — rejected: the concepts are inseparable from the EPP inspection exercise, and a third module would have no independent verification criteria
- **Lead with the rejection-reason table** — rejected: rejections only occur under saturation; learners need a working priority setup before interpreting failure modes

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- The priority-tier and rejection-reason tables use `|===` block markup with header rows for screen-reader table navigation

## Open Questions

- Confirm the *Observe & Monitor* → *Dashboard* → *LLM Traffic* / *LLM Performance* dashboard labels against a live 3.5 console (doc-derived)
- Load-testing tool choice and the minimum concurrency to saturate a workshop-cluster InferencePool must be validated before Act-phase testing
- The optional `priorityBands` exercise is learner-optional; confirm whether it should be a graded verify step instead

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FSE9JZY74
- RHAIBU-M33FSE9TQ7TP
- RHAIBU-M33FSEA0PZHG

## Related Decisions

- RHAIBU-M33FSEA6ZVWS
- RHAIBU-M33FSEAD2V62
