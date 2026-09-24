---
schema_version: 1
id: RHAIBU-M33D7VBYRMGZ
type: design
---
# External Metering Per-User Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. External metering: per-user token usage and cost (DP) is the
metering anchor for the agents-mcp category: the IPP plugin chain, CloudEvent
flow, and PostgreSQL-backed metering service taught here complement the
separate BBR-plugin External metering integration for Models-as-a-Service
workshop in the same catalog. Because the feature is Developer Preview with no
installation procedures in the product docs, the workshop is a guided tour
anchored to MaaS surfaces that already exist in the cluster.

## User Need

Platform operators and finance-adjacent engineers with OpenShift and
Models-as-a-Service working knowledge need a 60–90 minute guided path from
observing the MaaS foundation, through the metering data path, to locating
per-user usage in the observability dashboard — with every observable step
verifiable and no fabricated installation commands.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/external-metering-per-user/content/`):

1. **Module 01: Getting Started** — observe the MaaS foundation (`oc get datasciencecluster`, `oc get crd | grep -E 'maas.opendatahub.io|aitenants'`, `oc get tenants.maas.opendatahub.io -n models-as-a-service`) + guided data-path walkthrough (balance check → usage extraction → CloudEvent → aggregation with cache-aware pricing → dashboard/REST API consumption) with the five-token-dimensions table
2. **Module 02: Hands-on Exercise** — explore the observability dashboard Usage tab (Time period + User/Subscription/Model filters, Token Consumption by User table, Prometheus metrics, `captureUser` note) + guided showback-vs-chargeback walkthrough (CSV export boundary, user-scoped dashboards, external metering chargeback path, DP boundary statement)

Bookends: Overview (DP maturity banner via `ifeval` + prerequisites) and
Getting Connected are shared boilerplate; Conclusion links the release-notes
section and the MaaS observability chapters.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- DP maturity banner via `ifeval` on `feature_maturity: DP` — Developer Preview warning, no installation procedures may be fabricated
- Release-notes-only feature: commands limited to MaaS foundation checks that ARE documented in the MaaS guide; everything else is guided walkthrough
- Every code block containing `{attributes}` uses `subs="attributes"`
- Cross-reference to the sibling `external-metering-maas` component stays namespaced (`xref:external-metering-maas::index.adoc`)

## Rationale

DP maturity drives an honest guided-tour depth: observe documented surfaces,
walk undocumented architecture in prose, and state the Developer Preview
boundary explicitly in module 02. Module order follows the learner's dependency
chain (verify the foundation → interpret the per-user data it produces),
matching the module flow in the related requirements.

## Alternatives

- **Fabricated plugin installation lab** — rejected: violates the no-fabrication guardrail; installation/configuration procedures are not in the 3.5 product docs
- **Single mega-module** — rejected: the observe-the-foundation and explore-the-data phases have different Verify styles (command output vs dashboard navigation) and lose module granularity
- **BBR-plugin coverage in the same lab** — rejected: the BBR integration is a separate feature with its own workshop (`external-metering-maas`); conflation would blur both features' boundaries

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Markdown tables for token dimensions and dashboard columns provide header-row semantics

## Open Questions

- Confirm the `Observe & monitor → Dashboard` → Usage tab navigation labels against a live 3.5 console (doc-derived)
- Confirm a live cluster where `captureUser: true` is set so per-user rows actually render before Act-phase testing
- External metering plugin/metering service installation procedures may appear in later 3.x docs — revisit for a hands-on upgrade in the next version bump

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33D7VB0DVVA
- RHAIBU-M33D7VB7FJKF
- RHAIBU-M33D7VBEA1PY

## Related Decisions

- RHAIBU-M33D7VBMH8T2
- RHAIBU-M33D7VBSAVYM
