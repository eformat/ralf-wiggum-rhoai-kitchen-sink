---
schema_version: 1
id: RHAIBU-M33G4F8NCB5J
type: design
---
# Gateway API and Red Hat Connectivity Link (RHCL) Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Gateway API and Red Hat Connectivity Link (GA, Connectivity
Link 1.4) is the platform-gateway anchor feature: the policy CRs and the
gateway-default/route-override precedence chain taught here are the ingress
foundation for RHOAI model-serving and inference gateway traffic.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
~2 hour guided path from verifying the Connectivity Link control plane to a
TLS-secured, authenticated, rate-limited API served through a Gateway — and
onwards to token-based LLM traffic protection and observability — with every
step verifiable via `oc` status checks or `curl` responses.

## Design

Three modules plus shared bookends, one Antora component
(`features/platform-gateway/gateway-api-rhcl/content/`):

1. **Module 01: Core Concepts** — Connectivity Link as a Gateway API policy control plane (four-Operator / policy-CR mapping table), installation inspection (`KUADRANT_SYSTEM_NS` derivation, `oc wait kuadrant/kuadrant --for="condition=Ready=true"`, pods `2/2 Running`), console-plugin enablement (`kuadrant-console-plugin` → Connectivity Link menu item)
2. **Module 02: Hands-on Exercise** — environment variables + Toystore deployment, Gateway creation (`gatewayClassName: openshift-default`, `kuadrant.io/gateway` label), TLS via ClusterIssuer + TLSPolicy, HTTPRoute publication with `curl --resolve` 200 against `${GATEWAY_ADDRESS}`, gateway-level deny-all AuthPolicy + low-limit RateLimitPolicy then route-level API-key and per-user overrides (403/200/429 curl evidence), optional DNSPolicy exercise
3. **Module 03: Advanced Usage** — rate-limit headers via Limitador CR patch (`DRAFT_VERSION_03`), TokenRateLimitPolicy for OpenAI-compatible inference traffic (Accepted/Enforced verification), observability via `spec.observability.enable` (ServiceMonitor/PodMonitor listing), Grafana dashboard import, log/trace correlation via `x-request-id`

Bookends: Overview (maturity banner + prerequisites: RHCL 1.4.1+, cert-manager,
`cluster-admin` for install steps) and Getting Connected are shared
boilerplate; Conclusion links the full RHCL documentation set (install, deploy,
observability).

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- Install, OperatorGroup, and Kuadrant CR manifests are shown for reference only — learners must not run them without `cluster-admin`
- GRPCRoute policy attachment is Technology Preview in Connectivity Link 1.4 — must be flagged inline with a WARNING
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (install → expose and
secure → protect and observe), matching the module-flow in the related
requirements. The two-namespace split (gateway namespace vs developer project)
mirrors the platform-engineer/application-developer role boundary that the
policy defaults/override model encodes.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Gateway-API-first order (routing before TLS)** — rejected: an HTTPS listener without a valid certificate never reaches `Programmed`, so verification would fail mid-flow
- **Skip the gateway-default vs route-override split** — rejected: the defaults/precedence chain is the core Connectivity Link concept and the source of the 403/200/429 curl evidence

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the console-plugin navigation labels (*Dynamic Plugins > View all*, *Connectivity Link > Overview*) against a live console (doc-derived)
- Confirm whether workshop clusters have cloud DNS credentials for the optional DNSPolicy exercise
- Confirm Grafana availability for the dashboard-import exercise before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33G4F72YVSZ
- RHAIBU-M33G4F79QYS0
- RHAIBU-M33G4F7G1ZWN
- RHAIBU-M33G4F7RYCAM

## Related Decisions

- RHAIBU-M33G4F81KQ3W
- RHAIBU-M33G4F8BRPGY
