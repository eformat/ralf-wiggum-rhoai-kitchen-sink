---
schema_version: 1
id: RHAIBU-M33ESMPTYRSX
type: design
---
# Feature Store (Feast-based) Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Feature Store (Feast-based) (GA) is the feature-store anchor
feature in the feature-store-automl-autorag category: the `FeatureStore` CR,
`feast` CLI workflow, and online-store/scaling configuration taught here are the
foundation for feature-driven training and inference patterns elsewhere in the
catalog.

## User Need

ML engineers and data scientists with OpenShift working knowledge need a ~2 hour
guided path from enabling the Feast operator to a scaled, production-shaped
Feature Store instance serving features to both training and inference — with
every step verifiable.

## Design

Three modules plus shared bookends, one Antora component
(`features/feature-store-automl-autorag/feature-store-feast/content/`):

1. **Module 01: Core Concepts** — architecture walkthrough (registry, offline store, online store, feature servers; time-series data model vocabulary) + DSC enablement of `feastoperator` with controller-pod verification
2. **Module 02: Hands-on Exercise** — `FeatureStore` CR with Git feature repository (`oc get feast` Ready), `feast apply` in the online container, `feast materialize` / `materialize-incremental`, connected-workbench retrieval via Python SDK (`get_online_features`) and direct REST `curl`
3. **Module 03: Advanced Usage** — PostgreSQL online store with connection pooling, Gunicorn `workerConfigs`, HA scaling (`oc scale` / CR `replicas` / `services.scaling.autoscaling` HPA), client access patterns, Ray compute engine via `feast init -t ray_rag`

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the source documentation chapters.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `<DB_PASSWORD>`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- Only one `FeatureStore` instance may carry the `feature-store-ui: enabled` label
- Autoscaling (`services.scaling.autoscaling`) is mutually exclusive with `spec.replicas > 1`
- File-based persistence (SQLite, DuckDB, `registry.db`) must not be scaled beyond one replica
- YAML callout blocks use `subs="attributes,callouts"`; every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (enable → deploy → operate),
matching the module-flow in the related requirements. The CR is the unit of
deployment and `feast apply` is the unit of change, so exercises alternate
between the two.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Docs-transcription order (SDK first)** — rejected: learners need the operator and instance running before retrieval syntax is meaningful
- **Skip Ray** — rejected: distributed feature pipelines are a documented production path, kept as a SHOULD criterion

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Workbench-cluster reachability of the tutorial Git repository must be confirmed before Act-phase testing
- Redis/PostgreSQL availability in workshop clusters for the module 03 online-store exercise
- OIDC single sign-on path (§2.3 of the docs) is out of scope for this lab — revisit if a workshop cluster fronts the feature server with Keycloak

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33ESMMH5MB5
- RHAIBU-M33ESMMSV4Y0
- RHAIBU-M33ESMN38B6C
- RHAIBU-M33ESMNH6BTR

## Related Decisions

- RHAIBU-M33ESMNYFNSV
- RHAIBU-M33ESMPCHVTX
