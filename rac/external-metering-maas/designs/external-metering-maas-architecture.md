---
schema_version: 1
id: RHAIBU-M33D2G81TC6X
type: design
---
# External Metering Integration for MaaS Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. External metering integration for MaaS (Developer Preview)
extends the MaaS governance feature in the same catalog: it connects MaaS
inference traffic to an external metering or billing system using Backend-Based
Routing (BBR) plugins, and builds on the MaaSModelRef, MaaSSubscription, and
MaaSAuthPolicy foundation taught in the MaaS core workshop.

## User Need

Platform operators running MaaS as a commercial AI service need a 45–60 minute
guided path from understanding the two BBR plugins to tracing a metered request
through the gateway and observing the quota enforcement layer it works
alongside — with every observable step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/external-metering-maas/content/`):

1. **Module 01: Getting Started** — plugin walkthrough (post-inference token usage webhook vs pre-inference credit check, plugin-type table) + MaaS foundation verification (`oc get maasmodelref --all-namespaces`, `oc get maassubscription -n models-as-a-service`, `oc get maasauthpolicy -n models-as-a-service`, with the 429/403 pairing note)
2. **Module 02: Hands-on Exercise** — metered-request lifecycle trace (credit check → inference → async webhook) with the six event payload fields, + generated-policy inspection (`oc get authpolicy -n {guid}-{user}`, `oc get tokenratelimitpolicy -n {guid}-{user}`) and the Verify section against documented behavior (blocked requests, failed webhook delivery logged)

Bookends: Overview (Developer Preview maturity banner via `ifeval` +
prerequisites) and Getting Connected are shared boilerplate; Conclusion links
the product documentation for external metering and MaaS governance.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP` — Developer Preview, so no per-exercise deep-dive beyond what docs evidence
- DP maturity means guided-tour depth: no invented configuration commands for wiring an external metering endpoint
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

Developer Preview maturity drives a guided-tour lab grounded strictly in
documented behavior. Module order follows the learner's dependency chain
(understand plugins and foundation → trace metered traffic and observe the
quota layer), matching the module flow in the related requirements. Because no
external metering endpoint is provisioned, exercises center on `oc get`
verification and conceptual tracing rather than fabricated metering setup.

## Alternatives

- **Single mega-module** — rejected: the plugin/foundation orientation and the request-trace/observe split serve different cognitive modes and lose per-exercise verification
- **Fabricate a live metering-endpoint exercise** — rejected: violates the no-fabrication guardrail; the docs describe raw event emission but not an end-to-end external system setup

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Plugin comparison and event fields are conveyed as AsciiDoc tables, not images

## Open Questions

- Whether a workshop cluster can be provisioned with a reachable external metering endpoint for Act-phase testing of webhook delivery
- Confirm per-model AuthPolicy/TokenRateLimitPolicy generation against the MaaS controller on a live 3.5 cluster (doc-derived; the maas-gateway-auth aggregation may change what lists are shown)
- Exact Behavior of `oc get authpolicy` output when a tenant-gateway-scoped policy exists instead of per-model policies

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33D2G6HM38A
- RHAIBU-M33D2G6T8B98
- RHAIBU-M33D2G75GA1N

## Related Decisions

- RHAIBU-M33D2G7ERZ6C
- RHAIBU-M33D2G7QJYVX
