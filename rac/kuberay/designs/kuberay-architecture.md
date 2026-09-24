---
schema_version: 1
id: RHAIBU-M33EBKR0JVB4
type: design
---
# KubeRay (CodeFlare Operator successor) Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. KubeRay (GA) is the Ray-based distributed-training anchor:
the KubeRay/Kueue/CodeFlare SDK stack, the mTLS-secured cluster flow, and the
Kueue queueing diagnostics taught here are prerequisites for the Kueue
workload-management and Kubeflow Training Operator features in the same catalog
category.

## User Need

Platform engineers and data scientists with OpenShift and `oc` CLI working
knowledge need a guided path (about 2 hours) from cluster inspection to a
running, mTLS-secured, Kueue-queued Ray cluster — and onwards to pipelines,
metrics, and failure-state diagnosis — with every step verifiable.

## Design

Three modules plus shared bookends, one Antora component
(`features/distributed-training/kuberay/content/`):

1. **Module 01: Core Concepts** — infrastructure walkthrough (CodeFlare SDK, KubeRay, Kueue, Training Operator, cert-manager) + cluster inspection (`oc get crd rayclusters.ray.io`, operator pods in `redhat-ods-applications`, `oc get localqueues`)
2. **Module 02: Hands-on Exercise** — workbench creation, `copy_demo_nbs()`, Ray cluster from a notebook (`Cluster`/`ClusterConfiguration` with YAML callouts, `TokenAuthentication`, `generate_cert` for mTLS) verified via `cluster.status()`, `oc get rayclusters`/`workloads`, and the Ray dashboard; interactive notebook controls with `view_clusters()`
3. **Module 03: Advanced Usage** — AI pipeline component with GPU requests compiled via `kfp` and run; distributed workload metrics/status under `Observe & monitor → Workload metrics`; suspended-cluster diagnosis via `status.conditions.message` on Workload/RayCluster and ClusterQueue limits

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the docs.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- The `Cluster`/`ClusterConfiguration` code blocks use `subs="callouts"` for the `<1>`–`<5>` parameter callouts
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA` — no TP/DP flag needed for this feature
- The Ray cluster image Python version must match the workbench Python version — called out inline in module 02
- mTLS is enabled by default in the Ray component: the `generate_cert` steps are mandatory for the Ray client to connect

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (inspect → deploy →
pipeline/monitor/troubleshoot), matching the module flow in the related
requirements. The mTLS and local-queue prerequisites are surfaced in the
Important/Note admonitions before learners hit them as failures.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Kueue-first order (operator internals before the notebook flow)** — rejected: learners need a running cluster before queueing internals are meaningful
- **CLI-only cluster creation** — rejected: the CodeFlare SDK notebook flow is the documented user path and ships the demo notebooks the lab builds on

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Dashboard navigation paths spelled out with explicit menu labels (no bare "click here" references)

## Open Questions

- Confirm local-queue availability in workshop clusters (module 02 prerequisite; the lab documents the explicit `local_queue` fallback)
- GPU quota for the module 03 pipeline example must be confirmed before Act-phase testing; CPU-only fallback documented
- Confirm the `Observe & monitor → Workload metrics` menu label against a live 3.5 console (doc-derived)

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33EBKPA661M
- RHAIBU-M33EBKPKR497
- RHAIBU-M33EBKPYJXSR
- RHAIBU-M33EBKQ7PEH9

## Related Decisions

- RHAIBU-M33EBKQFJRMF
- RHAIBU-M33EBKQSK76M
