---
schema_version: 1
id: RHAIBU-M33F780W9YKE
type: design
---
# Models-as-a-Service (MaaS) Core Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Models-as-a-Service (MaaS) core: access model and token
mechanism (GA) is the maas category's anchor feature: the subscription-based
access model, `maas.opendatahub.io` custom resources, and API-key authentication
taught here are prerequisites for the multi-tenancy and external-models
features documented in the Govern LLM access with Models-as-a-Service guide.

## User Need

Platform engineers and administrators with OpenShift working knowledge need a
45–90 minute guided path from cluster verification to a governed, authenticated
model call — and onwards to administrator-side governance as YAML and usage
monitoring — with every step verifiable.

## Design

Three modules plus shared bookends, one Antora component
(`features/maas/maas-core/content/`):

1. **Module 01: Core Concepts** — access-model walkthrough (`MaaSModelRef`,
   `MaaSSubscription`, `MaaSAuthPolicy` table; 403-vs-429 IMPORTANT callout) +
   cluster inspection (`oc get crd | grep maas.opendatahub.io`,
   `openshift-user-workload-monitoring`, Tenant `READY`/`Reconciled` conditions,
   `OdhDashboardConfig` flags)
2. **Module 02: Hands-on Exercise** — user workflow end to end: Endpoints dialog
   discovery (badge + subscription selector), API key generation (1-hour
   temporary + persistent, `sk-oai-` prefix, displayed-once warning), body-based
   routing via `/v1/chat/completions` with `usage` object, invalid-key (401/403)
   and rate-limit (429 with `X-RateLimit-*`/`Retry-After`) probes
3. **Module 03: Advanced Usage** — administrator role: subscription creation
   under `Settings → MaaS governance` (token limits, priority, matching-policy
   snapshot warning), YAML governance via `MaaSSubscription`/`MaaSAuthPolicy`
   with controller-generated `AuthPolicy`/`TokenRateLimitPolicy` verification,
   key revocation, `maxExpirationDays` cap via `oc patch`, Usage dashboard
   (TP-flagged)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the Govern LLM access with
Models-as-a-Service source guide.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- API keys are displayed only once at creation — content must warn to save before closing the dialog
- Secrets appear as `%maas-api-key%`/`%revoked-api-key%` placeholders, never literal keys
- Every code block containing `{attributes}` uses `subs="attributes"` (YAML manifests use `subs="attributes,callouts"`)

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (verify platform → consume
as user → govern as admin), matching the module-flow in the related
requirements. The 403-vs-429 diagnostic is taught in module 01 and re-encountered
in module 03 so the "which piece is missing" reasoning sticks.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Doc-transcription order (admin first)** — rejected: learners need to consume a governed model before creating its governance, and module 02 assumes the facilitator's subscription already exists

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `Settings → MaaS governance` menu label against a live 3.5 console (doc-derived)
- Confirm the aggregated `maas-gateway-auth` AuthPolicy (3.5 controller behavior) is visible in workshop clusters
- Workshop cluster must have User Workload Monitoring and the `maas-db-config` secret pre-provisioned before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33F77Z24FAX
- RHAIBU-M33F77ZAW9NQ
- RHAIBU-M33F77ZMK0A8
- RHAIBU-M33F77ZXJ4RZ

## Related Decisions

- RHAIBU-M33F7807BHRD
- RHAIBU-M33F780HKM5R
