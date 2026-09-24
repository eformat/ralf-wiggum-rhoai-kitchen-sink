---
schema_version: 1
id: RHAIBU-M33ESDKPXEZ5
type: design
---
# AutoML Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. AutoML (Technology Preview) is the automated model selection
and training anchor in the feature-store-automl-autorag category: its
two-tier enablement (DSC dashboard flag + pipeline server managed pipelines)
and its AutoGluon serving runtime are prerequisites for the AutoRAG feature in
the same catalog, which runs on the same pipeline-server setting.

## User Need

Data scientists and ML practitioners with editor access to a RHOAI project need
a 60–90 minute guided path from enablement and prerequisite validation to a
completed optimization run, an evaluated and registered model, notebook-based
predictions, and a deployed AutoGluon endpoint — with every step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/feature-store-automl-autorag/automl/content/`):

1. **Module 01: Getting Started** — AutoML orientation (workflow, task types,
   TP limitations), enablement (DSC patch `dashboardConfig.automl=true` with
   jsonpath verify; pipeline-server `spec.apiServer.managedPipelines` with
   `READY: True` check), and prerequisite validation (CSV format rules, S3
   data connection via `oc get secrets`, AutoML page visible under
   *Develop and train*)
2. **Module 02: Hands-on Exercise** — optimization-run wizard (S3 CSV source,
   task type, label/target columns, top-models and optimization-metric
   tuning), run monitoring on the AutoML page + `oc get pipelineruns`,
   leaderboard and model-detail evaluation (register model or save notebook),
   notebook predictions in a workbench with the attached S3 connection, and
   deployment via model framework `autogluon - 1` + AutoGluon ServingRuntime
   for KServe

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion closes the workshop.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP`
- TP limitation callouts on the fields (`spec.dashboardConfig.automl`, `spec.apiServer.managedPipelines`) and dashboard flow — may change between releases
- Every code block containing `{attributes}` uses `subs="attributes"`
- DataScienceCluster patch warning: cluster-wide effect; confirm with the facilitator in shared environments

## Rationale

The two-module split follows the learner's dependency chain: enable and
validate first (a non-ready pipeline server blocks everything downstream),
then run the full lifecycle. TP maturity still gets full hands-on depth with
per-exercise `=== Verify` sections because the docs document every command and
console path, matching the docs-first enrichment decision.

## Alternatives

- **Single mega-module** — rejected: enablement failures and lifecycle exercises lose per-exercise verification and the nav loses module granularity
- **Deployment-first order (deploy, then train)** — rejected: deployment requires a registered model, which requires a completed optimization run

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the *Enable AutoML and AutoRAG pipelines* checkbox label in Advanced settings against a live 3.5 console (doc-derived)
- AutoGluon serving runtime availability in workshop clusters must be confirmed before Act-phase testing
- The leaderboard screenshot (`02-leaderboard.png`) is a placeholder until a live cluster is available

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33ESDHNJPDR
- RHAIBU-M33ESDJ3W2KS
- RHAIBU-M33ESDJGKG9T

## Related Decisions

- RHAIBU-M33ESDJY6C34
- RHAIBU-M33ESDKAZ4JF
