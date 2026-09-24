---
schema_version: 1
id: RHAIBU-M33EHSYBR70M
type: design
---
# Kubeflow Trainer v2 Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Kubeflow Trainer v2 (GA) is the distributed-training anchor
feature: the `TrainJob` API, `ClusterTrainingRuntime` model, and Kubeflow SDK
workflow taught here are prerequisites for the Kueue quota management and Ray
distributed-workload features in the same catalog. Trainer v2 replaces
Training Operator v1's framework-specific CRDs, so the workshop also carries
the v1→v2 migration story.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
45–90 minute guided path from runtime inspection to a running, verified
two-node distributed PyTorch job, onwards to SDK-based submission and LLM
fine-tuning — with every step verifiable.

## Design

Three modules plus shared bookends, one Antora component
(`features/distributed-training/kubeflow-trainer-v2/content/`):

1. **Module 01: Core Concepts** — v1→v2 mapping (PyTorchJob vs TrainJob table, pre-built runtimes table) + runtime inspection (`oc get clustertrainingruntime`, `torch-distributed -o yaml` with `mlPolicy`/`template` callouts)
2. **Module 02: Hands-on Exercise** — CLI launch of a two-node `TrainJob` (`numNodes`, `resourcesPerNode`, ConfigMap mount via `podTemplateOverrides`), pod-log verification of ranks + `all_reduce` across nodes, lifecycle via `oc patch` suspend/resume and `oc delete`
3. **Module 03: Advanced Usage** — custom namespace-scoped `TrainingRuntime` from the console, Kubeflow SDK submission from a workbench (`TrainerClient` + `TransformersTrainer`, JIT checkpointing via `pvc://`), OSFT/SFT fine-tuning with `TrainingHubTrainer` and RWX storage

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion points to the Kubeflow Trainer v2 chapter of the
RHOAI 3.5 documentation.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- The SDK auth pattern uses `%token%` placeholder and a commented `verify_ssl = False` line for self-signed certificates
- Every code block containing `{attributes}` uses `subs="attributes"`; YAML callouts use `subs="attributes,callouts"`
- GPU-dependent steps carry an IMPORTANT admonition directing no-GPU users to observe-only mode
- RHBoK 1.4 incompatibility flagged with a WARNING in module 01

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (inspect runtimes → run a
CLI job → customize via SDK/fine-tuning), matching the module-flow in the
related requirements. The `all_reduce` verification makes distributed execution
observable without requiring large models or long training runs.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **SDK-first order** — rejected: learners need the manifest-level `TrainJob`/`ClusterTrainingRuntime` mental model before the SDK abstracts it away
- **Fine-tuning-only workshop** — rejected: misses the lifecycle control (suspend/resume/delete) that operators need day two

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Workshop cluster GPU inventory (2+ NVIDIA GPUs for module 02; 4x L40/L40S for the OSFT exercise) must be confirmed before Act-phase testing
- Confirm the Kubeflow SDK index-url stays pinned to the `rhoai/3.2` PyPI path in the workshop's target RHOAI release
- RWX-capable storage class availability (e.g. OpenShift Data Foundation) for the fine-tuning exercises

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33EHSWMJJJG
- RHAIBU-M33EHSWXEF4M
- RHAIBU-M33EHSX5V8XN
- RHAIBU-M33EHSXD898E

## Related Decisions

- RHAIBU-M33EHSXR38G7
- RHAIBU-M33EHSY3T5A6
