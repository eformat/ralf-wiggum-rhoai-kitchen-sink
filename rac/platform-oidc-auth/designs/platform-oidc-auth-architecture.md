---
schema_version: 1
id: RHAIBU-M33G4BV6MKE0
type: design
---
# Platform-wide direct OIDC authentication (GatewayConfig CR) Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Platform-wide direct OIDC authentication (GA) is the
platform-gateway anchor feature: the centralized authentication service,
`GatewayConfig` CR configuration, and IdP-group-to-ClusterRole authorization
model taught here underpin every RHOAI ingress path, since all services sit
behind the single `data-science-gateway` domain once OIDC is enabled.

## User Need

Cluster administrators with OpenShift working knowledge and an external OIDC
identity provider need a 60–90 minute guided path from verifying the
direct-OIDC prerequisites to a GatewayConfig that reports `Ready: True`, a real
console login through their IdP, and mapped group authorization — with every
step verifiable and a rehearsed failure mode (`Ready: False`) for rollout day.

## Design

Two modules plus shared bookends, one Antora component
(`features/platform-gateway/platform-oidc-auth/content/`):

1. **Module 01: Configure OIDC for the platform gateway** — direct-OIDC prerequisite checks (`oc get authentication.config/cluster` type + `oidcProviders`, `oc get co kube-apiserver`) + client secret creation in `openshift-ingress` and the `default-gateway` GatewayConfig patch with callouts on `issuerURL`, `clientID`, `clientSecretRef`
2. **Module 02: Verify, authorize, and troubleshoot OIDC access** — end-to-end verification (GatewayConfig conditions, `kube-auth-proxy`, `data-science-gateway`, OIDC discovery endpoint, console login redirect), IdP-group authorization (`odh-projects-read` + `self-provisioner` ClusterRoles), and troubleshooting with custom CA trust (`providerCASecretName`)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the source documentation chapter.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- Client secret values are replaced by learner-supplied IdP details; the secret creation step uses `--from-literal`, never committed values
- Every code block containing `{attributes}` uses `subs="attributes"`
- The console-login verification step is browser-based and screenshot-deferred (`// TODO: capture screenshot`) until the Act phase

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (verify prerequisites →
configure the gateway → prove the flow → authorize groups → rehearse failure),
matching the module-flow in the related requirements. Troubleshooting is placed
last so the success path is proven before failure modes are introduced.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Authorization-first order** — rejected: group mappings only matter after authentication through the gateway is proven

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the OIDC console-login redirect flow against a live 3.5 cluster (doc-derived; screenshot deferred)
- Confirm the workshop IdP (Keycloak realm) provisioning before Act-phase testing
- Service account token authentication for the gateway is documented separately (`oc create token` flow) and is out of scope for this workshop — verify placement in a future CLI-access feature

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33G4BT3B9QJ
- RHAIBU-M33G4BT9Y883
- RHAIBU-M33G4BTFHSSF

## Related Decisions

- RHAIBU-M33G4BTP5KMH
- RHAIBU-M33G4BTXY6YS
