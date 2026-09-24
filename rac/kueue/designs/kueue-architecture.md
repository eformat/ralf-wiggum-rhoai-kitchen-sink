---
schema_version: 1
id: RHAIBU-M33EHANXN3JC
type: design
---
# Kueue Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Kueue (Red Hat build of Kueue Operator, GA) is the scheduling
anchor of the distributed-training category: the ResourceFlavor,
ClusterQueue, and LocalQueue object model taught here underpins the KubeRay and
Kubeflow Trainer v2 workshops in the same catalog, which submit workloads
through Kueue queues.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
60–90 minute guided path from verifying the Kueue operator to submitting real
PyTorch training jobs through a LocalQueue, watching Kueue admit one and hold
another, and diagnosing queueing problems with Workload conditions, alerts, and
the documented error messages — with every step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/distributed-training/kueue/content/`):

1. **Module 01: Getting Started** — verify Kueue infrastructure (`oc get crds | grep kueue`, controller pods in `redhat-ods-applications`), enable the project with `kueue.openshift.io/managed=true`, and create the queue objects (`kueue-objects.yaml`: ResourceFlavor `default-flavor`, ClusterQueue `workshop-cq` with 8 CPU / 32Gi nominal quota, default LocalQueue `workshop-lq`) with CLI and console verification
2. **Module 02: Hands-on Exercise** — submit a PyTorchJob (`pytorch-ddp`) via the `kueue.x-k8s.io/queue-name` label and confirm pods run; apply an oversized `pytorch-ddp-xl` (`cpu: "50"`) and read the `ADMITTED False` Workload conditions; review the Kueue alerting rules table and documented error messages; clean up jobs and workloads

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the source docs chapters.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity` — Kueue is GA, so the TP/DP warning blocks in `index.adoc` do not render
- Every code block containing `{attributes}` uses `subs="attributes"`
- Workshop values are CPU-only (8 CPU / 32Gi quota, `gloo` backend fallback in the training script) so the lab runs on clusters without GPUs; the documented AMD/GPU variants stay as NOTE callouts
- Console navigation steps (Search → LocalQueue, Observe → Alerting) are doc-derived; screenshots are placeholders until Act phase

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (verify operator → create
queues → submit work), matching the module-flow in the related requirements.
The two-job contrast (admitted vs held) makes Workload admission semantics
observable rather than described.

## Alternatives

- **Single mega-module** — rejected: setup and submission lose separate verification and the nav loses module granularity
- **GPU-sized quota and image** — rejected: most workshop clusters have no GPUs; the CPU-only variant keeps every step runnable
- **KubeRay-style RayCluster submission instead of PyTorchJob** — rejected: covered by the kuberay workshop; the PyTorchJob keeps this corpus focused on Kueue itself

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the workshop cluster headroom for 8 CPU / 32Gi ClusterQueue quota plus two concurrent PyTorchJobs before Act-phase testing
- Confirm `redhat-ods-applications` pod names and CRD creation timestamps on a live 3.5 console (doc-derived expected outputs)
- Screenshot capture for Workload conditions and alerting rules deferred to Act phase

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33EHAMGX1Z9
- RHAIBU-M33EHAMQJPQ0
- RHAIBU-M33EHAN2PFXM

## Related Decisions

- RHAIBU-M33EHANBB7BR
- RHAIBU-M33EHANMVTG0
