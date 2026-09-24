---
schema_version: 1
id: RHAIBU-M33F6QN02WK2
type: design
---
# MaaS External OIDC Authentication Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. MaaS external OIDC user authentication (GA) is the
authentication anchor for the Models-as-a-Service feature family: the two-tier
authentication flow, `AITenant` OIDC configuration, and group-claim-based
subscription mapping taught here are prerequisites for the MaaS core access and
token mechanism feature in the same catalog.

## User Need

Platform engineers and cluster administrators with an external OIDC provider
(such as Keycloak) need a 60–90 minute guided path from verifying the MaaS
deployment to configuring `AITenant` OIDC trust, mapping external groups to
subscriptions, and proving authentication end to end through the MaaS management
API — with every step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/maas/maas-oidc-auth/content/`):

1. **Module 01: Configure external OIDC authentication** — two-tier
   authentication flow walkthrough + deployment verification (`aitenant`
   `READY: True`, `MaasTenantConfig` infra namespace, `$MAAS_GATEWAY_URL` from
   the gateway listener hostname with Route fallback) + `AITenant` OIDC
   configuration via console YAML or `oc patch` (`clientId`, `issuerUrl`,
   signing-key cache `ttl`), verified with `jsonpath='{.spec.oidc}'`
2. **Module 02: Govern access and verify OIDC authentication** — subscription
   creation under `Settings → MaaS governance` with groups matching the OIDC
   token claims exactly (model + token limit + matching authorization policy),
   then end-to-end verification: `curl` with a real OIDC token against
   `/maas-api/v1/models` (200 + model list, empty list = valid token but no
   matching subscription) and a 401 negative test without a token

Bookends: Overview (prerequisites + estimated time) and Getting Connected are
shared boilerplate; Conclusion links the external OIDC chapter and the
`Manage API keys using the MaaS API` guide.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- `ifeval` TP/DP warning banners in the Overview only; the feature is GA in 3.5 so no banner renders
- Every code block containing `{attributes}` uses `subs="attributes"`
- API key creation for external OIDC users goes through the MaaS API with `curl` — the dashboard does not support it (uses OpenShift OAuth); the lab must not fabricate a dashboard path

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (verify deployment → trust
the provider → govern access → prove authentication), matching the module flow
in the related requirements. Subscription group names must match OIDC token
claims exactly, so the claim-matching rule is repeated as an IMPORTANT admonition
before the exercise that depends on it.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Doc-transcription order (subscription first)** — rejected: subscriptions are useless until `AITenant` trusts the OIDC provider, so configuration must precede governance

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `Settings → MaaS governance` menu label against a live 3.5 console (doc-derived)
- Workshop clusters need a reachable external OIDC provider with a registered client application; availability must be confirmed before Act-phase testing
- Whether token-limit units (hour, minute, second) surface in the dashboard form exactly as documented must be confirmed on a live console

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33F6QKCY0FW
- RHAIBU-M33F6QKMBGDJ
- RHAIBU-M33F6QKZA4HT

## Related Decisions

- RHAIBU-M33F6QMAQ5DS
- RHAIBU-M33F6QMP6N0G
