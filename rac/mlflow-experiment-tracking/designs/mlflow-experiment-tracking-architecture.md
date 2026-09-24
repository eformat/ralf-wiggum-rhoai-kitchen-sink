---
schema_version: 1
id: RHAIBU-M33F7N0Y9M0M
type: design
---
# MLflow Experiment Tracking Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. MLflow experiment tracking / MLOps integration (GA) is the
MLOps anchor feature: the project-to-workspace mapping, the MLflow RBAC model,
and the `MLflow`/`MLflowConfig` CR patterns taught here are prerequisites for
evaluation, guardrails, and pipeline features in the same catalog that log to
MLflow.

## User Need

Data scientists and platform engineers with OpenShift working knowledge need an
approximately 2-hour guided path from cluster inspection to a deployed tracking
server, a workbench-integrated SDK experiment run, and advanced per-project
storage and trace-archival configuration — with every step verifiable.

## Design

Three modules plus shared bookends, one Antora component
(`features/mlops/mlflow-experiment-tracking/content/`):

1. **Module 01: Core Concepts** — architecture walkthrough (MLflow deployment
   model, project-to-workspace mapping, pseudo-resources and aggregate
   ClusterRoles tables) + cluster inspection (`mlflowoperator` managementState,
   dashboard *Applications* → *MLflow UI*, `oc api-resources`, `oc get mlflow`)
2. **Module 02: Hands-on Exercise** — enable the operator via DSC patch
   (admin-only, `oc patch`), deploy the `MLflow` CR with SQLite/PVC and
   PostgreSQL/S3 variants with YAML callouts, enable workbench integration via
   the `opendatahub.io/mlflow-instance` annotation, verify injected
   `MLFLOW_*` env vars and the `<notebook>-mlflow` RoleBinding, then track an
   experiment with the SDK and review it in the dashboard
3. **Module 03: Advanced Usage** — per-project artifact override with
   `MLflowConfig` + S3 connection, trace archival (`traceArchival` section,
   CronJob verification, per-experiment retention from the dashboard), and
   clean integration teardown (stop-first, annotation removal, RoleBinding
   NotFound)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the full MLflow documentation.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- The `MLflow` resource is cluster-scoped and must be named `mlflow` in `redhat-ods-applications` — manifests must encode this exactly
- The module 02 install steps require cluster administrator privileges — flagged inline
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (inspect → deploy → shape
storage and lifecycle), matching the module-flow in the related requirements.
The workbench integration is taught before the SDK exercise so the notebook
needs no manual `MLFLOW_TRACKING_URI` exports.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **SDK-first order (manual env vars before integration)** — rejected: learners should experience the automatic integration the product is built around; manual SDK configuration remains referenced in the docs-backed content

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the *Experiments (MLflow)* menu label and *Archive after* badge against a live 3.5 console (doc-derived)
- S3-compatible bucket availability in workshop clusters must be confirmed before Act-phase testing of module 03

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33F7MYEAZF9
- RHAIBU-M33F7MYVCWJ3
- RHAIBU-M33F7MZ9H8NN
- RHAIBU-M33F7MZNSFEG

## Related Decisions

- RHAIBU-M33F7N022329
- RHAIBU-M33F7N0J4QG5
