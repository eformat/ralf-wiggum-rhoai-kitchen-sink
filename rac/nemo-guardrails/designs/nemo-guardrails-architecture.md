---
schema_version: 1
id: RHAIBU-M33F0QT0R1C1
type: design
---
# NeMo Guardrails Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. NeMo Guardrails (GA, guardrails category) is the AI safety
anchor feature: the `NemoGuardrails` CR, the configuration ConfigMap format,
and the three API endpoints taught here are prerequisites for the NeMo
Guardrails MCP Gateway integration feature in the same catalog.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
roughly two-hour guided path from "what is NeMo Guardrails" to a serving,
authenticated guardrails deployment that blocks, masks, and customizes — with
every step verifiable against documented expected output.

## Design

Three modules plus shared bookends, one Antora component
(`features/guardrails/nemo-guardrails/content/`):

1. **Module 01: Core Concepts** — architecture walkthrough (TrustyAI Operator,
   `NemoGuardrails` CR, three API endpoints, four rail types) + cluster
   inspection (`oc get dsc` TrustyAI `Managed`, `oc get csv | grep -i trustyai`,
   `oc api-resources --api-group=trustyai.opendatahub.io`)
2. **Module 02: Hands-on Exercise** — standalone deployment (ConfigMap with
   Presidio + regex detectors → `NemoGuardrails` CR with
   `security.opendatahub.io/enable-auth: 'true'`, YAML callouts), standalone
   validation via `/v1/guardrail/checks` (safe/email/password/multi-message
   tests), then fronting a live model via `/v1/chat/completions` with input and
   output rails (ServiceAccount + RoleBinding + token secret)
3. **Module 03: Advanced Usage** — two policies on one CR (`nemoConfigs`
   entries, `default: true`, `guardrails.config_id` per-request switching,
   `spec.replicas: 3`), masking flows (`[MASKED]` instead of blocking) via `oc
   patch`, custom Colang flow + Python action (`@action(is_system_action=True)`)
   blocking over-length messages; Explore section on OpenTelemetry tracing

Bookends: Overview (maturity banner + prerequisites + ~2h estimate), Getting
Connected, and Conclusion (docs + full CR configuration reference) are shared
boilerplate.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA` (no TP/DP warning renders)
- Every code block containing `{attributes}` uses `subs="attributes"`
- No live model is needed until module 2 Exercise 3; `<model_predictor_url>` and `<model_name>` placeholders must end in `/v1`
- LLM self-check rails, Hugging Face classifiers, and the MCP Gateway integration are documented in the product guide but deliberately out of lab scope to keep the quickstart LLM-free for the first two modules

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (inspect → deploy
standalone → front a model → operate policies), and the standalone quickstart
runs with no LLM at all, matching the docs' built-in-detector-first approach.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Start with the live-model path** — rejected: requires a deployed model up front; the standalone quickstart proves rails with zero LLM dependency
- **Cover self-check and HF classifier rails in the lab** — rejected: they add latency, token cost, and dual-model setup; they stay in the Conclusion's reference links

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- YAML callout markers (`<1>`–`<4>`) reference numbered bold-label legends below each block

## Open Questions

- Confirm the model predictor URL format (`.../v1`) against a live 3.5 model-serving deployment (doc-derived)
- Confirm OpenTelemetry trace exploration against a cluster with Grafana Tempo/Jaeger deployed (optional path)

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics (IMPORTANT for the non-transparent-proxy and
content-capture caveats).

## Related Requirements

- RHAIBU-M33F0QRTSW8T
- RHAIBU-M33F0QS1E106
- RHAIBU-M33F0QS80TZC
- RHAIBU-M33F0QSEHS0X

## Related Decisions

- RHAIBU-M33F0QSMFAF2
- RHAIBU-M33F0QSVQ7CW
