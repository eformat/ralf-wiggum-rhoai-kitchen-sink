---
schema_version: 1
id: RHAIBU-M33FK2HK36PH
type: design
---
# Model Registry and Model Catalog Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Model registry and model catalog (GA) is the
register/version/discover anchor of the model lifecycle: the `modelregistry`
component configuration, registry permissions RBAC, ModelCar OCI transfer jobs,
and catalog source governance taught here are prerequisites for governed,
production-shaped model workflows in the same catalog.

## User Need

Administrators, platform engineers, and ML practitioners with OpenShift working
knowledge need a ~2 hour guided path from component enablement to a registry
with registered versions, a deployed inference service, an OCI ModelCar
artifact, and a governed catalog source — with every step verifiable from the
dashboard and the CLI.

## Design

Three modules plus shared bookends, one Antora component
(`features/model-registry/model-registry-catalog/content/`):

1. **Module 01: Core Concepts** — catalog vs registry landscape walkthrough
   (capability comparison table) + component enablement (`managementState:
   Managed`, `registriesNamespace: rhoai-model-registries`) with three CLI
   verifications (namespace `Active`, operator deployment, DSC jsonpath `Managed`)
2. **Module 02: Hands-on Exercise** — registry creation with default database,
   permissions (Users/Groups/Projects tabs), RBAC verification
   (`registry-users-workshop-registry` role in `rhoai-model-registries`),
   model + two versions registered with object-storage/URI model location,
   deploy-from-registry through the deployment wizard with connection matching,
   `oc get inferenceservices` confirmation
3. **Module 03: Advanced Usage** — catalog discovery (categories, search,
   filters, performance and safety insights) with catalog registration,
   *Register and store* ModelCar transfer job (`olot` layering onto `busybox`,
   `oci://` artifact URI, `oc get jobs`/`oc logs` verification, retry/delete),
   catalog source governance (Hugging Face or YAML source, include/exclude
   patterns, `model-catalog-sources` ConfigMap), and lifecycle
   (archive/restore/delete with confirmation dialogs)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the four source documents.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- Default database is non-production only — must be flagged inline with the NOTE that Red Hat does not support it for production
- s390x restrictions (single catalog model, no catalog registration, no custom catalog sources) must be flagged inline
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (enable → create/register →
store/govern), mirroring the docs' chapter order (Managing model registries →
Working with model registries → Working with the model catalog → Manage and
govern catalog sources) while splitting the hands-on registry workflow into a
dedicated module.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Catalog-first order (discover before register)** — rejected: learners need a registry to register into before they can register catalog models

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the *Settings → Model resources and operations → Model registry settings* vs *AI registry settings* menu label against a live 3.5 console (some 3.5 chapters use *AI registry settings*)
- OCI registry credentials and Hugging Face network access in workshop clusters must be confirmed before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FK2FCVS2Z
- RHAIBU-M33FK2FTT6KT
- RHAIBU-M33FK2G4CKAQ
- RHAIBU-M33FK2GGZ90Z

## Related Decisions

- RHAIBU-M33FK2GWCX15
- RHAIBU-M33FK2H8XNM1
