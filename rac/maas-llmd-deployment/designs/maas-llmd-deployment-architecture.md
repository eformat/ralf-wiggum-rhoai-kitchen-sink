---
schema_version: 1
id: RHAIBU-M33FDJ7PCQ5S
type: design
---
# MaaS Deployment/Routing Path for Distributed Inference with llm-d Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. The MaaS deployment/routing path for Distributed Inference
with llm-d (Technology Preview) is the maas-category anchor: it joins the llm-d
serving path (`LLMInferenceService` deployment resource, `openshift-ai-inference`
Gateway) with the MaaS governance layer (`MaaSModelRef`, `MaaSSubscription`,
`MaaSAuthPolicy`) that other MaaS features in the catalog — multi-tenancy and
observability — build upon.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
45–90 minute guided path from platform verification to a deployed, published,
and governed model — one they can call end to end through the MaaS gateway with
an OpenAI-compatible API key — with every step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/maas/maas-llmd-deployment/content/`):

1. **Module 01: Getting Started** — verify MaaS and llm-d prerequisites (five
   `maas.opendatahub.io` CRDs, `default-tenant` `Ready`,
   `modelsAsService: Managed`, GatewayClass + Gateway `openshift-ai-inference`),
   then wizard deployment with the *Distributed inference with llm-d* deployment
   resource and *Publish as MaaS*, verified via `MaaSModelRef` and
   `LLMInferenceService` (gateway ref under `spec.router.gateway`)
2. **Module 02: Hands-on Exercise** — governance apply (`MaaSSubscription` with
   `tokenRateLimits` + `MaaSAuthPolicy`, YAML callouts), controller-generated
   `AuthPolicy`/`TokenRateLimitPolicy` verification, subscription-scoped API key
   generation from *Gen AI studio → AI asset endpoints*, and gateway inference
   (`GET /v1/models`, body-based routing on `/v1/chat/completions`, optional
   legacy path-based routing, `200`/`429` rate-limit test, `401`/`403` negative test)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the MaaS governance and llm-d distributed
inference documentation.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP` — Technology Preview note on both modules
- YAML manifests use `subs="attributes,callouts"`; every code block containing `{attributes}` uses `subs="attributes"`
- Subscription and auth-policy resources live in `models-as-a-service`; controller-generated policies are inspected in the learner project
- API key placeholders only in examples (`<your_api_key>`); keys are shown-once and expire after 1 hour

## Rationale

Technology Preview maturity still drives full hands-on depth because the lab's
commands, CRs, and console paths are verbatim from official RHOAI 3.5 docs, with
an inline TP disclaimer on both modules. Module order follows the learner's
dependency chain (verify platform → deploy + publish → govern + call),
matching the module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Doc-transcription order (governance first)** — rejected: governance resources reference a published model, so deployment must come first
- **CLI-only deployment** — rejected: the dashboard wizard flow (`Publish as MaaS` toggle) is the documented path for this feature

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the *Gen AI studio → AI asset endpoints* and *API keys* menu labels against a live 3.5 console (doc-derived)
- Confirm the MaaS infrastructure namespace (`redhat-aigateway-infra` default) and `maas.{ingress-domain}` gateway URL in workshop clusters before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FDJ5XH0SY
- RHAIBU-M33FDJ690EQS
- RHAIBU-M33FDJ6KFCJE

## Related Decisions

- RHAIBU-M33FDJ6XHHWJ
- RHAIBU-M33FDJ7A0KS5
