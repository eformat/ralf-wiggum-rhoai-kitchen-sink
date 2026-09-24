---
schema_version: 1
id: RHAIBU-M33ESMNH6BTR
type: requirement
---
# Module 03: Advanced Usage

## Problem

Development defaults (SQLite online store, single replica) do not survive
production. Learners need to tune the online store and feature-server workers
for latency and throughput, scale for high availability with static replicas or
an HPA, choose a client access pattern, and know when to reach for the Ray
compute engine for large feature pipelines.

## Requirements

- [REQ-031] Learner MUST be able to apply a production online-store configuration (PostgreSQL connection pooling, TLS) and Gunicorn `workerConfigs` in the FeatureStore CR, then confirm `oc get feast` shows `Ready` after reconcile
- [REQ-032] Learner MUST be able to scale the instance with `oc scale` / CR `replicas` or an HPA (`services.scaling.autoscaling`), then verify the HorizontalPodAutoscaler with `oc get hpa` showing the configured MINPODS/MAXPODS bounds
- [REQ-033] Learner MUST be able to compare the three client access patterns (direct REST API, SDK with remote store, SDK direct) and their connection-load trade-offs
- [REQ-034] Learner SHOULD be able to scaffold a Ray RAG repository with `feast init -t ray_rag` and confirm `feast configuration` displays the `ray.engine` batch engine settings
- [REQ-035] Learner SHOULD be able to identify the three production topologies (minimal, standard — recommended, enterprise) and enable OIDC authentication with `authz: { oidc: {} }` (or `authz.oidc.issuerUrl` for non-Gateway-API providers) in the FeatureStore CR, verified via the `Authorization` status condition reporting `"status": "True"`

## Success Metrics

Learner completes all three exercises: the tuned CR reconciles to `Ready`, the
HPA appears with the configured bounds (TARGETS resolving from `unknown` to a
live value), and the Ray template scaffolds with the `ray.engine` settings
visible in `feast configuration`.

## Risks

- Autoscaling is mutually exclusive with `spec.replicas > 1`
- File-based persistence (SQLite, DuckDB, `registry.db`) must never be scaled beyond one replica
- HPA TARGETS reads `cpu: <unknown>/70%` for about a minute before metrics resolve

## Assumptions

- Learner has completed Module 02 (instance ready, features materialized)
- Database-backed persistence is available for horizontal-scaling exercises

## Related Requirements

- RHAIBU-M33ESMMH5MB5

## Verified By

- features/feature-store-automl-autorag/feature-store-feast/content/modules/ROOT/pages/module-03-advanced.adoc
