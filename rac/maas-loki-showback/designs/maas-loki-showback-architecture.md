---
schema_version: 1
id: RHAIBU-M33FD4FPATKE
type: design
---
# MaaS Loki Showback Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Showback reporting and per-user usage dashboards with Loki
(Technology Preview) is the MaaS observability anchor feature: the Kuadrant
observability and Tenant telemetry switches taught here feed the dashboard and
CSV export that MaaS administrators use for cost attribution, and the
Loki-based log pipeline background section points at the user-scoped dashboards
coming in later releases.

## User Need

Cluster administrators with OpenShift and MaaS working knowledge need a
60–90 minute guided path from prerequisite verification to a working per-user
dashboard and a CSV showback export for their finance team — with every switch
flip and query verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/maas/maas-loki-showback/content/`):

1. **Module 01: Getting Started** — prerequisite verification (MaaS CRDs,
   User Workload Monitoring, Tenant `READY`/`Reconciled`,
   `observabilityDashboard` flag) + the two data-source switches: Kuadrant
   observability (`kuadrant-limitador-monitor` PodMonitor, `limited_calls`)
   and MaaS telemetry on the Tenant CR (`authorized_calls`)
2. **Module 02: Hands-on Exercise** — per-user metrics (`captureUser` patch +
   cardinality WARNING), the dashboard walk-through (*Observe & monitor* →
   *Dashboard* → *Usage* tab: Overview metrics, filters, time ranges, Token
   Consumption by User table), CSV export via *Export as CSV*, and the
   Loki-based log pipeline background section (30-day retention, user-scoped
   read-only dashboards, release-notes-only status)

Bookends: Overview (TP maturity banner + prerequisites) and Getting Connected
are shared boilerplate; Conclusion links the source documentation.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- TP maturity banner via `ifeval` on `feature_maturity: TP`
- `captureUser` patch carries a WARNING on Prometheus cardinality cost
- The Loki-based pipeline and user-scoped dashboards have no published configuration commands in the 3.5 docs — described as background only, no invented commands
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

TP maturity still drives hands-on depth because the dashboard workflow, CR
patches, and Prometheus queries are fully documented in the Govern LLM access
book; only the Loki pipeline configuration surface is release-notes-only.
Module order follows the learner's dependency chain (verify → switch on →
consume/export), matching the module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: the prerequisite/switch half and the consume/export half have different failure modes and lose per-exercise `=== Verify` granularity
- **Doc-transcription order (dashboard first)** — rejected: learners need the data sources switched on and verified before the dashboard can render anything

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Dashboard capabilities documented in tables rather than screenshots alone

## Open Questions

- Confirm the *Observe & monitor* → *Dashboard* nav label against a live 3.5 console (doc-derived)
- Loki-based pipeline configuration surface: which release publishes the step-by-step commands (release notes defer it)
- Cluster Observability Operator availability on workshop clusters before the Act phase

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FD4E5MCYB
- RHAIBU-M33FD4EFB5FT
- RHAIBU-M33FD4ES2FE8

## Related Decisions

- RHAIBU-M33FD4F3BPW8
- RHAIBU-M33FD4FC5P38
