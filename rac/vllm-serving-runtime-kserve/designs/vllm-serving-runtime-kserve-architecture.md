---
schema_version: 1
id: RHAIBU-M33FYP4HS0VV
type: design
---
# vLLM ServingRuntime for KServe Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. The vLLM ServingRuntime for KServe (GA) is the single-model
serving anchor feature: the `ServingRuntime`/`InferenceService` CRD pairing,
runtime enablement, and OpenAI-compatible inference taught here are
prerequisites for understanding the distributed-inference and MaaS serving
features in the same catalog.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
60–90 minute guided path from runtime enablement to a deployed, serving
generative AI model queried over its OpenAI-compatible REST API — with every
step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/model-serving/vllm-serving-runtime-kserve/content/`):

1. **Module 01: Enable the vLLM ServingRuntime for KServe** — platform and runtime enablement from the dashboard (`Settings → Cluster settings → General settings`, `Settings → Model resources and operations → Serving runtimes`), verified with `oc get servingruntimes -n redhat-ods-applications`; `ServingRuntime` template inspection with annotated YAML callouts (image, entrypoint, ports, `supportedModelFormats`), verified via jsonpath
2. **Module 02: Deploy a model with the vLLM ServingRuntime** — Deploy model wizard flow (model location, generative AI type, NVIDIA GPU hardware profile, runtime selection, token authentication), generated `InferenceService` CR inspection with YAML callouts, authenticated inference via `/v1/chat/completions` with bearer token (200/401-403 negative signal)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion points at the RHOAI documentation chapters for
runtime configuration and inference requests.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`; TP/DP warning blocks stay in the index for Mode 3 version bumps
- Every code block containing `{attributes}` uses `subs="attributes"`
- vLLM requires GPU support enabled and the Node Feature Discovery Operator configured — flagged in prerequisites, not fabricated away

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (enable → deploy → query),
matching the module-flow in the related requirements. Two modules suffice
because the feature is runtime-centric: enablement is the conceptual core, and
the wizard deployment doubles as the CRD lesson.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **CLI-first deployment (raw `InferenceService` apply before the wizard)** — rejected: the wizard is the documented day-1 path and the generated CR teaches the API better than a hand-written manifest

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `Settings → Model resources and operations → Serving runtimes` menu label against a live 3.5 console (doc-derived)
- GPU availability and the exact model location connection (`granite-7b-instruct` in S3) must be confirmed before Act-phase testing
- Whether the workshop cluster has the vLLM runtime preinstalled at `vllm-runtime` with the documented digest

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FYP394X0S
- RHAIBU-M33FYP3JWJCF
- RHAIBU-M33FYP3TSTNF

## Related Decisions

- RHAIBU-M33FYP431FHD
- RHAIBU-M33FYP4AP4JE
