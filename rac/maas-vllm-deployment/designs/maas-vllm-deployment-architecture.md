---
schema_version: 1
id: RHAIBU-M33FK0WJE0RE
type: design
---
# vLLM Deployment on MaaS Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. vLLM deployment on MaaS (TP) is the MaaS category's
runtime-diversity feature: MaaS already governs llm-d-served models (the llmd-core
workshop), and this lab shows the same governance layer — subscriptions, quotas,
API keys — applied to vLLM-based deployment resources. It depends on the MaaS
prerequisites taught in the maas-core govern-llm path.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
45–90 minute guided path from enabling the Technology Preview feature flag to a
publishing a vLLM model to MaaS, granting governed group access, and calling the
OpenAI-compatible endpoint with a subscription-bound API key — with every step
verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/maas/maas-vllm-deployment/content/`):

1. **Module 01: Getting Started** — enable the Technology Preview `vLLMDeploymentOnMaaS` flag (read-only check → merge patch → re-read verify), then verify the MaaS platform: DSC `kserve` and `modelsAsService` both `Managed`, `maas-default-gateway` in `openshift-ingress`, `maas-controller` pods found via the `maastenantconfig` `infraNamespace` lookup
2. **Module 02: Hands-on Exercise** — wizard deployment (model path `facebook/opt-125m`, legacy method unchecked, vLLM NVIDIA CUDA GPU LLMInferenceServiceConfig, Publish as MaaS), `MaaSModelRef` + `LLMInferenceService` verification, MaaSSubscription + MaaSAuthPolicy YAML callouts, controller-generated AuthPolicy/TokenRateLimitPolicy check, API key creation in Gen AI studio, governed curl (200) with invalid-key negative test (401/403)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the full documentation set.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`/`%api-key%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP`
- The vLLM feature flag, vLLM-based LLMInferenceServiceConfig resources, and MaaS observability dashboard are Technology Preview in 3.5 — must be flagged inline
- Every code block containing `{attributes}` or callout tokens uses the matching `subs=` value

## Rationale

TP maturity still warrants full hands-on depth because the workshop exercises
are lifted verbatim from the official docs (docs-first enrichment); the only
TP-gated piece is the wizard's deployment-resource list, which the flag
exercise itself controls. Module order follows the learner's dependency chain
(enable flag → verify platform → deploy → govern → call), matching the
module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **CLI-first deployment** — rejected: the feature's value is the wizard's vLLM deployment-resource option; CLI manifests for MaaSSubscription/MaaSAuthPolicy already cover declarative configuration in exercise 2

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `Gen AI studio → API keys` and `AI asset endpoints` menu labels against a live 3.5 console (doc-derived)
- Confirm the default infrastructure namespace (`redhat-aigateway-infra` in 3.5) via the `maastenantconfig` lookup before Act-phase testing
- Workshop clusters must have Connectivity Link Operator 1.4.x with a ready Kuadrant CR confirmed before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FK0TNTTYJ
- RHAIBU-M33FK0V2M8PC
- RHAIBU-M33FK0VDA7NX

## Related Decisions

- RHAIBU-M33FK0VTD0NN
- RHAIBU-M33FK0W7371K
