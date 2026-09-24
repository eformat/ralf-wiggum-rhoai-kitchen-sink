# Observations: Model Registry and Model Catalog (doc-derived)

## Summary

Model registry and model catalog is RHOAI 3.5's GA path for registering,
versioning, and discovering AI/ML models on OpenShift. This observation document
was produced from the official RHOAI 3.5 product documentation (Managing model
registries; Working with model registries; Working with the model catalog; Manage
and govern model catalog sources) because no live demo cluster was available at
authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | registry-managing-model-registries.txt | Ch. 1 Model catalog and model registries | Model catalog = curated library to discover/evaluate gen AI models; model registry = central repository to register/version/manage lifecycle; registry is the bridge between experimentation and serving and a key governance component |
| 2 | registry-managing-model-registries.txt | Ch. 2 Enable the model registry component | `modelregistry` component in the DSC: `managementState: Managed`, `registriesNamespace: rhoai-model-registries`; enabled by default on new 3.5 installs but required after upgrades; verify namespace + `model-registry-operator-controller-manager` pod |
| 3 | registry-managing-model-registries.txt | Ch. 3–5 Create/edit/permissions | Registry creation dialog with default (non-production) or external database (PostgreSQL 16.x, MySQL 5.x+, best 9.x); resource name rules (253 chars, lowercase/-); operator creates `registry-users-<name>` role + `<name>-users` group per instance; permissions via Users/Groups/Projects tabs; `system:authenticated` grants all cluster users |
| 4 | registry-working-with-model-registries.txt | §2.1–2.2, §2.7–2.10 Registering and viewing | Register model dialog (Model details, Version details, Model location); object storage autofill-from-connection or manual endpoint/bucket/region/path; URI location deployable from public OCI repositories only; metadata editing (labels, description, properties) |
| 5 | registry-working-with-model-registries.txt | §2.3–2.6 Register and store + transfer jobs | *Register and store* starts an async Kubernetes Job copying the model to an OCI ModelCar image; `busybox:latest` base (`quay.io/quay/busybox:latest` for Quay) layered with `olot`; creates ConfigMap + Secrets owned by the Job (garbage-collected); artifact URI `oci://<registry>/<image>:<tag>`; job statuses Pending/Running/Complete/Failed with retry and delete |
| 6 | registry-working-with-model-registries.txt | §2.11, §2.14–2.16 Deploy and lifecycle | Deploy from registry action menu creates an inference service (model deployment name = ISVC name); models with deployed versions cannot be archived; archive/restore round-trip via *View archived models*; deleting a registry does not remove its connected databases |
| 7 | registry-working-with-model-catalog.txt | Ch. 2 Discover models | Catalog page shows category, name, description, labels (task, license, provider); categories All models, Red Hat AI models, Red Hat AI validated models, Other models (only when unlabeled sources exist); search and filter by Task/Provider/License/Language/Tensor type |
| 8 | registry-working-with-model-catalog.txt | Ch. 3, §8 Performance and safety insights | Validated models show Minimum vRAM, Container size, Cold start load time, vLLM Runtime command; safety evaluation categories (prompt injection, jailbreak resistance, composite vulnerability) scored against OWASP LLM Top 10 and AVID; not a formal certification; pre-computed per release; available in disconnected environments |
| 9 | registry-manage-govern-catalog-sources.txt | Ch. 1–2 Sources | *Settings → Model resources and operations → Model catalog settings* lists sources (defaults: Red Hat AI, Red Hat AI validated, Other) with validation status; add source from Hugging Face repository (URL-slug organization, public non-gated only, not disconnected) or YAML file; include/exclude wildcard patterns with applied order (include first, then exclude) |

## User Flows

### Flow 1: Enable and create a registry (administrator)

1. **Enable the component** — DSC YAML: `modelregistry.managementState: Managed`, `registriesNamespace: rhoai-model-registries` (§2, source 2)
2. **Verify** — namespace Active, operator pod Running (§2, source 2)
3. **Create registry** — Settings → Model registry settings → Create model registry → default or external database (§3, source 3)
4. **Grant access** — Manage permissions: Users/Groups/Projects tabs (§5, source 3)

### Flow 2: Register, version, and deploy (data scientist)

1. **Register model** — AI hub → Registry → Register model: model details, version details, model location (object storage or URI) (§2.1–2.2, source 4)
2. **Register and store (optional)** — async transfer job → ModelCar image in OCI registry, `oci://` artifact URI (§2.3, source 5)
3. **Monitor job** — View model transfer jobs table, auto-poll, retry on failure (§2.4–2.5, source 5)
4. **Deploy** — action menu → Deploy → deployment wizard with connection matching → inference service created (§2.11, source 6)

### Flow 3: Discover and govern (catalog)

1. **Discover** — browse categories, search, filter, inspect model card + performance/safety insights (source 7–8)
2. **Register from catalog** — model details page → Register model → URI prefilled from catalog source (source 7)
3. **Govern sources** — Settings → Model catalog settings → Add a source (Hugging Face or YAML), visibility include/exclude patterns, validation status Connected (source 9)

## Features and Concepts

### OpenShift Platform
- DataScienceCluster component configuration, namespaces, RBAC (roles, groups, role bindings), ConfigMaps, Secrets, Kubernetes Jobs, OCI registries

### RHOAI / AI Platform
- `modelregistry` component, model registry resource, registry permissions, model catalog server, catalog sources, ModelCar transfer jobs, model archive/restore

### AI/ML Fundamentals
- Model lifecycle (discover → register → version → deploy), model versioning, MLOps governance, model card metadata (intended use, limitations, datasets), performance benchmarking (latency, RPS, vRAM)

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: administrators, platform engineers, and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: RHOAI operator installed, model serving concepts, `oc` CLI basics
- **Estimated duration**: about 2 hours
- **Cluster requirements**: RHOAI 3.5 with the `modelregistry` component enabled; for advanced exercises, an OCI registry and object storage/URI model artifacts

## Open Questions

- Exact *Model registry settings* vs *AI registry settings* menu label on a live 3.5 console (3.5 chapters differ)
- Whether the workshop cluster can reach Hugging Face (catalog-source exercise) and Quay (ModelCar destination) before Act-phase testing
