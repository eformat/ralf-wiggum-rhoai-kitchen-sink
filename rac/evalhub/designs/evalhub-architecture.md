---
schema_version: 1
id: RHAIBU-M33ESYFP6FCH
type: design
---
# Evaluation Stack (EvalHub) Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Evaluation Stack (EvalHub) (GA) is the evaluation anchor
feature: the provider/benchmark/collection model, job lifecycle, MLflow
tracking, and tenant RBAC taught here back the evaluation-adjacent features in
the same catalog (LM-Eval, RAGAS, OGX providers) and the TrustyAI tool family.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
roughly two-hour guided path from deployment inspection to a completed,
results-bearing evaluation job, and onwards to dashboard comparison, custom
collections, MLflow tracking, and tenant RBAC — with every step verifiable.

## Design

Three modules plus shared bookends, one Antora component
(`features/evaluation/evalhub/content/`):

1. **Module 01: Core Concepts** — architecture walkthrough (three components
   table, job workflow, threshold levels) + deployment inspection
   (`trustyai.managementState`, `eval-hub` pod, health endpoint, tenant
   resources)
2. **Module 02: Hands-on Exercise** — SDK/CLI install and config (`evalhub
   config set`), provider catalog discovery, job submission from the CLI
   (`evalhub eval run`) and the REST API (`POST /api/v1/evaluations/jobs` with
   `X-Tenant` header), status tracking (`pending` → `running` → `completed`),
   results table via `evalhub eval results --format table`
3. **Module 03: Advanced Usage** — dashboard submission (`Develop & train →
   Evaluations`, threshold slider, benchmark parameters), MLflow comparison
   view, custom collection from a YAML spec (`evalhub collections create
   --file`), MLflow experiment tracking, tenant RBAC with Role + RoleBinding
   verified by `oc auth can-i`

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; two reference pages (EvalHub REST API, Scoring and
Thresholds) sit outside the module flow; Conclusion links the two source doc
chapters.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- The workshop assumes a facilitator-deployed EvalHub instance (`{guid}-evalhub` namespace) with the working project registered as a tenant — deployment itself is not a lab exercise
- Multi-tenancy is surfaced as behavior: every non-health API call carries `Authorization: Bearer` + `X-Tenant` headers; the CLI sets them from the configured tenant
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (understand → submit →
collaborate): the CLI path lands first because every dashboard and RBAC
exercise depends on the vocabulary and job lifecycle it establishes.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Docs order (operator deployment first)** — rejected: EvalHub deployment is facilitator-owned in this workshop, so learners start from an already-running instance and spend time on the evaluation loop instead
- **Dashboard-first flow** — rejected: dashboard exercises need completed runs and collection concepts that only exist after the CLI module

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `Develop & train → Evaluations` menu label and the threshold slider behavior against a live 3.5 console (doc-derived)
- MLflow federated plugin availability on workshop dashboards must be confirmed before Act-phase testing (module 03 comparison exercise)

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33ESYEB6HGQ
- RHAIBU-M33ESYEH6WFB
- RHAIBU-M33ESYESMAJZ
- RHAIBU-M33ESYF00CKR

## Related Decisions

- RHAIBU-M33ESYF8W2FN
- RHAIBU-M33ESYFGWADW
