---
schema_version: 1
id: RHAIBU-M33FYFY9TFZ3
type: design
---
# vLLM CPU ServingRuntime on IBM Z / Power Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. vLLM CPU ServingRuntime on IBM Z / Power (GA) is the
architecture-specific model-serving feature: the vLLM CPU ServingRuntime for
KServe is the supported vLLM path on IBM Power (ppc64le) and IBM Z (s390x),
where GPU accelerators are unavailable and only standard deployment mode is
supported. Every exercise in this lab is shaped by those two constraints.

## User Need

Platform engineers and ML practitioners working on IBM Z or IBM Power clusters
need a 60–90 minute guided path from cluster architecture inspection to a
token-authenticated, OpenAI-compatible serving endpoint — with every step
verifiable and CPU/memory sizing understood as the only capacity lever.

## Design

Two modules plus shared bookends, one Antora component
(`features/model-serving/vllm-cpu-ibm-z-power/content/`):

1. **Module 01: Getting Started** — architecture and runtime inspection
   (`oc get nodes` architecture jsonpath, `oc get dsc`, `oc get servingruntimes -n redhat-ods-applications`, container image jsonpath) + wizard deployment (model location, hardware profile, vLLM CPU runtime selection, CPU/Memory resource customization, *Model access* + *Require token authentication*)
2. **Module 02: Hands-on Exercise** — CLI verification (`oc get isvc`, Ready condition jsonpath, predictor pod, routes), token and endpoint retrieval (dashboard *Token secret* or service account secret), OpenAI-compatible inference (`/v1/models`, `/v1/chat/completions` with bearer token), 401 negative test

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the supporting documentation.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- No GPU accelerator requests on IBM Z and IBM Power — sizing happens through *Customize resource requests and limits* (CPU and Memory)
- Standard deployment mode only (KServe RawDeployment) for the vLLM CPU ServingRuntime on these architectures
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Two modules match the learner's dependency chain: establish the architecture
context and a deployment first (wizard), then verify and exercise it (CLI +
inference). The 401 negative test closes the loop on token authentication.

## Alternatives

- **A third module on custom ServingRuntimes** — rejected: custom runtimes and fast-release images are separate features in the catalog; this lab stays scoped to the pre-installed vLLM CPU runtime
- **CLI-first deployment** — rejected: the wizard flow teaches the hardware-profile/runtime-selection model that CPU-only sizing depends on

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the *AI hub* → *Deployments* inference endpoint path against a live 3.5 console (doc-derived)
- Exact pre-installed runtime resource name can vary between releases — verify the `vllm-cpu` name match on the workshop cluster

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FYFWKTS9S
- RHAIBU-M33FYFWZECSZ
- RHAIBU-M33FYFXBJWZ3

## Related Decisions

- RHAIBU-M33FYFXND646
- RHAIBU-M33FYFXX7P3J
