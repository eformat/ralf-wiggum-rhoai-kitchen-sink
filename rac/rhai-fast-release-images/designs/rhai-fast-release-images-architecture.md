---
schema_version: 1
id: RHAIBU-M33FSHKR3T54
type: design
---
# Red Hat AI Inference fast-release images Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Red Hat AI Inference fast-release images as custom
ServingRuntime (GA) is the model-serving "fast lane" feature: it lets learners
access the latest vLLM versions between OpenShift AI stable releases by
publishing Red Hat-built vLLM images to `registry.redhat.io/rhaii-early-access`
and adopting them as gated custom ServingRuntimes.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
60–90 minute guided path from decoding vLLM runtime support levels to an
accepted fast-release ServingRuntime serving verified OpenAI-compatible
inference — with every step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/model-serving/rhai-fast-release-images/content/`):

1. **Module 01: Explore vLLM runtime support levels** — dashboard badge tour (supported/limited-support/unsupported combinations, `fast-N` badge) + CLI inspection (`oc get servingruntimes -A`, registry comparison, gating annotation grep)
2. **Module 02: Deploy a model on a fast-release ServingRuntime** — duplicate the vLLM NVIDIA GPU ServingRuntime, edit annotations + container image in the YAML editor (callouts), verify acceptance annotations, wizard deployment on the new runtime, OpenAI-compatible chat completion with bearer token

The "Manage the support window" section closes module 02: annotation
persistence through disable/re-enable and upgrades, expiration tracking, and
acceptance revocation.

Bookends: Overview (maturity banner + prerequisites), Getting Connected, and
Conclusion are shared boilerplate.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- The fast-release image tag changes with every monthly fast build — must be flagged inline and validated against the Red Hat Ecosystem Catalog
- The `fast-version` annotation value displays with a `fast-` prefix in the dashboard (e.g. `"1"` → `fast-1`)
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (decode support levels →
adopt a gated runtime → deploy and verify inference), matching the module-flow
in the related requirements. Duplicating a pre-installed vLLM runtime keeps the
spec correct by construction rather than hand-writing a ServingRuntime from
scratch.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Hand-write the ServingRuntime manifest from scratch** — rejected: duplicating the pre-installed runtime carries over model formats and container configuration and mirrors the documented procedure
- **LLMInferenceServiceConfig path (MaaS accelerator configs)** — deferred: requires the `vLLMDeploymentOnMaaS` feature flag (Technology Preview), not part of this GA workshop

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Badge semantics conveyed in tables, not color alone

## Open Questions

- Confirm the current fast-build tag for `vllm-cuda-rhel9` in the Red Hat Ecosystem Catalog at workshop time (the workshop tag `3.5.0-ea.1-1780065492` ages with each monthly build)
- Confirm badge rendering on a live 3.5 console (doc-derived)

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FSHHXT2SE
- RHAIBU-M33FSHJ84P3N
- RHAIBU-M33FSHJMZC5N

## Related Decisions

- RHAIBU-M33FSHK0SQC0
- RHAIBU-M33FSHKCDV4R
