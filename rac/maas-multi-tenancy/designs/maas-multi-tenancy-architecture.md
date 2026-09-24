---
schema_version: 1
id: RHAIBU-M33FDBR84R31
type: design
---
# MaaS Multi-tenancy Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. MaaS multi-tenancy (TP) is the tenant-isolation anchor in the
maas category: the `AITenant` API, Gateway prerequisites, three-layer access
model, and deletion cleanup semantics taught here are prerequisites for the
other MaaS governance features (external models, multi-provider passthrough) in
the same catalog.

## User Need

Platform engineers with cluster-administrator OpenShift knowledge need a
45–90 minute guided path from multitenant-architecture orientation to a
provisioned, isolated tenant with proven 200/401-403/404 boundaries, and onwards
to RoleBinding grants and clean deletion — with every step verifiable.

## Design

Three modules plus shared bookends, one Antora component
(`features/maas/maas-multi-tenancy/content/`):

1. **Module 01: Core Concepts** — architecture walkthrough (isolated vs shared
   resources, three access-control layers) + cluster inspection (`oc get
   aitenant models-as-a-service -n ai-tenants`, `oc get gatewayclass
   openshift-default`, `oc get maastenantconfig default-tenant -n
   models-as-a-service`)
2. **Module 02: Provision a tenant and verify isolation** — dedicated Gateway
   manifest with MaaS annotations and callouts, `AITenant` apply in
   `ai-tenants`, bootstrap verification (tenant namespace labels,
   `MaasTenantConfig`, `maas-api-<tenant>` deployment), isolation proof via
   authenticated 200 / unauthenticated 401-403 / cross-tenant key 404
3. **Module 03: Grant tenant access and delete a tenant** — RoleBinding grants
   verified with `oc auth can-i`, `MaasTenantConfig` tuning (API key expiration,
   telemetry dimensions), destructive deletion with finalizer-ordered cleanup
   table and stale-RoleBinding warning

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the MaaS governance documentation chapters.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP` — Technology Preview warning on every module
- The Gateway, cert-manager, and Connectivity Link are external prerequisites the controller never creates — must be stated as prerequisites, not lab steps
- The cross-tenant key test depends on an API key created via the MaaS API (MaaS core workshop) — cross-reference, do not re-teach
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

TP maturity still supports full hands-on depth because the entire lab is CLI
and manifest work verified with `=== Verify` sections — no console navigation
to drift. Module order follows the tenant lifecycle (orient → provision →
operate/delete), matching the module flow in the related requirements. The
destructive-delete exercise is last so a learner cannot strand the rest of the
lab.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Skip deletion (end after isolation proof)** — rejected: the finalizer cleanup table and stale-RoleBinding hazard are core operational knowledge for a multi-tenant platform
- **Create the API key inside this lab** — rejected: API-key management belongs to the MaaS core workshop; duplicating it drifts

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `redhat-ai-gateway-infra` infrastructure namespace label value on a live 3.5 console (doc-derived default)
- Confirm whether the gateway-scoped AuthPolicy name pattern `<tenant_name>-maas-auth` is visible to learners without cluster-admin read on the Gateway namespace
- Kuadrant v1.4.2+ / Connectivity Link availability in workshop clusters must be confirmed before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FDBPZXKRR
- RHAIBU-M33FDBQ5DCTH
- RHAIBU-M33FDBQB4AYW
- RHAIBU-M33FDBQJP1SC

## Related Decisions

- RHAIBU-M33FDBQTDEBH
- RHAIBU-M33FDBR1J8A8
