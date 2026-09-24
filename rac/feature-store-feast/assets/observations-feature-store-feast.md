# Observations: Feature Store (Feast-based) (doc-derived)

## Summary

Feature Store (Feast-based) is RHOAI 3.5's GA framework for storing, managing,
and serving machine learning features using existing infrastructure and data
stores. This observation document was produced from the official RHOAI 3.5
product documentation (Working with machine learning features) because no live
demo cluster was available at authoring time. Every item below is doc evidence,
not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | feast-machine-learning-features.txt | §1.3 Overview of Feature Store | Four components: registry (feature definitions catalog), offline store (historical time-series for training/batch scoring), online store (low-latency retrieval at inference), feature servers (online HTTP/JSON, offline Arrow Flight, registry gRPC) |
| 2 | feast-machine-learning-features.txt | §2.1.2 Enable the Feature Store component | `feastoperator` is disabled by default; enable via `spec.components.feastoperator.managementState: Managed` in the DataScienceCluster CR; verify `feast-operator-controller-manager-<pod-id>` pod Running in `redhat-ods-applications` |
| 3 | feast-machine-learning-features.txt | §2.1.3 Creating a Feature Store instance | `FeatureStore` CR (`feast.dev/v1`) with `feastProject`, `feastProjectDir.git` (cloned at deploy time); starts a remote online feature server with local provider defaults (SQL/file registry, Parquet offline, SQLite online) |
| 4 | feast-machine-learning-features.txt | §2.1.5 Adding feature definitions | `oc exec -it deployments/<name> -c online -- feast apply`; reads all Python files recursively (`.feastignore` to exclude); registers feature views, entities, data sources; does not delete removed objects |
| 5 | feast-machine-learning-features.txt | §2.2.6–2.2.8 HA and autoscaling | Single-replica limitation for the Feature Store Operator; `oc scale` / CR `replicas` triggers RollingUpdate with injected soft pod anti-affinity (node) and topology spread (zone); `services.scaling.autoscaling` creates an HPA (min/max replicas, CPU utilization target, podDisruptionBudgets) |
| 6 | feast-machine-learning-features.txt | §2.2.12–2.2.13 Online store tuning | Online store dominates `get_online_features()` latency; PostgreSQL with `conn_type: pool`, min/max conn, keepalives, `sslmode: require`; Redis for p99 < 10 ms; Gunicorn `workerConfigs` (workers, workerConnections, maxRequests); connection budgeting when scaling horizontally |
| 7 | feast-machine-learning-features.txt | §2.2.16 Client access patterns | Three patterns: direct REST API (client → feature server → store, lowest client-side usage, recommended for production inference), SDK with remote store (`online_store: type: remote`), SDK direct (client → store, restricted to development — multiplies connection load) |
| 8 | feast-machine-learning-features.txt | §5 Feature Store integration with workbenches | Connected feature stores section in the workbench creation/edit dialog; client config mounted at `feast-configs/<my_project>`; `FeatureStore(fs_yaml_file='feast-configs/<my_project>')`; bidirectional visibility (View Connected Workbenches on the Feature Store details page); project-based auth, no manual tokens |
| 9 | feast-machine-learning-features.txt | §6 Compute engines | Ray compute engine executes feature computation as distributed DAGs with point-in-time joins, broadcast join selection, lazy evaluation; `offline_store: type: ray` + `batch_engine: type: ray.engine` (max_workers, broadcast_join_threshold_mb); `feast init -t ray_rag` RAG template parallelizes embedding generation; Spark engine also documented |
| 10 | feast-machine-learning-features.txt | §2.3 OIDC authentication | External OIDC providers (Keycloak) for fine-grained auth; single sign-on access to Feature Store data |

## User Flows

### Flow 1: Enable and deploy an instance

1. **Enable component** — `spec.components.feastoperator.managementState: Managed` in the DSC; verify controller pod (§2.1.2)
2. **Create instance** — `FeatureStore` CR with Git feature repository; `oc get feast` → Ready (§2.1.3)
3. **Register definitions** — `feast apply` in the online container; entities and feature views created (§2.1.5)

### Flow 2: Materialize and retrieve

1. **Materialize** — `feast materialize <start> <end>` / `feast materialize-incremental` loads offline data into the online store
2. **Connect workbench** — Connected feature stores section; config mounted at `feast-configs/<my_project>` (§5.2)
3. **Retrieve** — Python SDK `get_online_features` or direct REST POST to `get-online-features` (§2.2.16)

### Flow 3: Scale for production

1. **Tune** — PostgreSQL connection pooling + Gunicorn `workerConfigs` (§2.2.12–2.2.13)
2. **Scale** — static replicas (anti-affinity + topology spread injected) or HPA via `services.scaling.autoscaling` (§2.2.7–2.2.8)
3. **Verify** — `oc get hpa` shows the `feast-<name>` HPA with MINPODS/MAXPODS bounds

## Features and Concepts

### OpenShift Platform
- DataScienceCluster CR components, operators, RBAC (§2.1.4), HPA and pod disruption budgets

### RHOAI / AI Platform
- Feast operator, `FeatureStore` CR, feature servers, registry/offline/online stores, workbench integration (`feast-configs/` mounting, bidirectional visibility, permissions §5.4), OIDC authentication

### AI/ML Fundamentals
- Feature engineering and reuse, time-series feature data (event timestamps, point-in-time joins), materialization, embeddings for RAG

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: ML engineers and data scientists with OpenShift working knowledge
- **Prerequisite knowledge**: OpenShift basics, `oc` CLI, basic ML concepts
- **Estimated duration**: about 2 hours
- **Cluster requirements**: RHOAI 3.5, cluster-admin for the DSC step, working project

## Open Questions

- Tutorial Git repository (`feast-dev/feast-credit-score-local-tutorial`) reachability from workshop clusters (doc-derived prerequisite)
- Redis/PostgreSQL availability for the production online-store exercise (docs cover both; lab uses PostgreSQL examples)
- OIDC/Keycloak fronting of the feature server is documented but not exercised — scope for a future lab
