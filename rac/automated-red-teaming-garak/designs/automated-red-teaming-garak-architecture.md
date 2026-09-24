---
schema_version: 1
id: RHAIBU-M33EHKC1K1NP
type: design
---
# Automated Red Teaming (powered by Garak) Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Automated Red Teaming (powered by Garak) (GA) is the
evaluation/safety anchor: the EvalHub tenant model, the `garak-kfp` provider,
and the Garak scan configuration taught here complement the Evaluation Stack
(EvalHub) and guardrails features in the same catalog. The docs name the feature
"automated risk assessment" while the release notes announce Automated Red
Teaming as GA — the workshop flags this naming drift inline.

## User Need

ML practitioners and platform engineers with OpenShift and model-serving working
knowledge need a ~2 hour guided path from cluster inspection to a submitted,
reported adversarial-robustness scan — and onwards to tuned scans, custom harm
categories, and the standalone KFP SDK path — with every step verifiable.

## Design

Three modules plus shared bookends, one Antora component
(`features/evaluation/automated-red-teaming-garak/content/`):

1. **Module 01: Core Concepts** — two-phase assessment walkthrough (judge
   classification table, five cumulative attack strategies) + cluster inspection
   (`trustyai.managementState`, `eval-hub` pod, `ds-pipeline-dspa` route)
2. **Module 02: Run a Risk Assessment** — tenant registration via namespace
   label, EvalHub auth (Role/RoleBinding + bearer token + `X-Tenant` header),
   `intents-scan.json` submission (`id: intents`, `provider_id: garak-kfp`) with
   JSON callouts, pipeline-stage trace, and report metrics (ASR primary)
3. **Module 03: Advanced Usage** — `garak_config` overrides (deep-merged),
   custom harm categories via `policy_s3_key` CSV, standalone KFP Python SDK run
   (`PipelineRunner` → `download_html_report`), disconnected-cluster
   Helsinki-NLP pre-download

Bookends: Overview (maturity banner + prerequisites + naming-drift NOTE) and
Getting Connected are shared boilerplate; Conclusion links the reference docs.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity`
- There is no dedicated dashboard page for red teaming — all triggering is via the EvalHub API or KFP SDK; no fabricated console screenshots of a scan UI
- The judge model must be a different model from the target; the `sdg` name uses the `hosted_vllm/` prefix
- JSON/YAML manifests use `subs="attributes"` where `{guid}` placeholders appear, and callouts for parameter explanations

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (understand → prepare and
submit → tune and extend), matching the module flow in the related
requirements. The standalone KFP SDK path is placed last so EvalHub-dependent
exercises come first, keeping the lab runnable when EvalHub is absent.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Docs-transcription order (configuration reference first)** — rejected: learners need the two-phase mental model and verified backing components before `garak_config` overrides
- **Dashboard-driven lab** — rejected: the docs document API/SDK triggering only; no dashboard page for red teaming exists

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm EvalHub provider listing and health endpoint versions against a live 3.5 cluster (doc-derived `0.3.0` example)
- Confirm `ds-pipeline-dspa` pipeline namespace naming in workshop clusters before Act-phase testing
- Scan duration for the full default category/strategy set must be measured to size the lab window

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33EHK9KK941
- RHAIBU-M33EHKA0YWP3
- RHAIBU-M33EHKADNAR7
- RHAIBU-M33EHKATAWPA

## Related Decisions

- RHAIBU-M33EHKB8ZRXA
- RHAIBU-M33EHKBNSF20
