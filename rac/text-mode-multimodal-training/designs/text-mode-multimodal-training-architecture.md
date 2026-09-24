---
schema_version: 1
id: RHAIBU-M33E5230GZ1R
type: design
---
# Text-mode Training for Multimodal Models in Training Hub Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Text-mode training for multimodal models in Training Hub
(DP) is the training anchor feature in the agents-mcp category: the
`ClusterTrainingRuntime` concepts, `runtimeRef` connection, and Kubeflow SDK
fine-tuning workflow taught here share the Training Hub stack with the other
Training Hub features in the same catalog. It is a Developer Preview guided
tour — the lab teaches the workflow from the official docs and, where GPU
capacity exists, runs it as written.

## User Need

Data scientists and platform engineers with OpenShift working knowledge need a
60–90 minute guided path from locating the `training-hub` runtime on their
cluster to a completed `TrainingHubTrainer` run with verified cleanup — with
every step verifiable and every command verbatim from the product docs.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/text-mode-multimodal-training/content/`):

1. **Module 01: Getting Started** — guided tour of the capability and its
   text-only scope; locate the `training-hub` `ClusterTrainingRuntime`
   (`oc get clustertrainingruntime`, inspect `-o yaml`, read the `runtimeRef`
   connection to the `TrainJob`); observe the training surface from the CLI
   (`oc get trainjob` → `No resources found`), the console (`Home → Search`
   with the `TrainJob` resource type), and the Kubeflow SDK (`list_runtimes()`
   walkthrough, not yet executed)
2. **Module 02: Hands-on Exercise** — configure the job (prerequisites: RWX
   PVC, JobSet Operator, GPU nodes; pip installs from the RHOAI PyPI index;
   SDK client auth with `%api_server%`/`%token%`; OSFT training parameters
   with `.jsonl` `messages` data); run, observe, and clean up
   (`client.train` with `TrainingHubAlgorithms.OSFT`, `get_job_logs`,
   `get_job`, dashboard `Model training` progress, `delete_job`, and CLI/
   console verification that the job is gone with checkpoints retained on the
   `shared` PVC)

Bookends: Overview (DP maturity banner via `ifeval` + prerequisites) and
Getting Connected are shared boilerplate; Conclusion links the source
documentation chapters.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%api_server%`-/`%token%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP` — Developer Preview warning, as-is with no support
- DP guided tour: commands, CRs, and navigation are verbatim from the RHOAI 3.5 docs (Working with distributed workloads; release notes) — no invented content
- GPU prerequisites (2 nodes x 2 NVIDIA GPUs for OSFT) may not exist on the workshop cluster; the module must remain follow-along without them
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

DP maturity drives guided-tour depth: honest observation exercises (list,
inspect, verify empty-then-populated state) plus a full end-to-end SDK
workflow that only requires GPU capacity at the `client.train` step. Module
order follows the learner's dependency chain (locate runtime → configure and
run → verify cleanup), matching the module flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **CLI-only workflow (`oc create trainjob`)** — rejected: the documented text-mode fine-tuning path is the Kubeflow Python SDK with `TrainingHubTrainer`; a CLI-first lab would invent an unsupported workflow
- **Skip hands-on entirely (concepts only)** — rejected: the SDK workflow is fully documented and runnable where GPU capacity exists; dropping it wastes the feature's testable surface

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the dashboard `Model training` navigation label against a live 3.5 console (doc-derived)
- GPU node availability (2 x L40/L40S for OSFT) in workshop clusters must be confirmed before Act-phase testing
- SFT variant parameters (FSDP options, Qwen2.5 1.5B/7B/14B on 4x A100/80GB) are TIP-level content; a runnable SFT example may deserve its own exercise

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33E5219KH8J
- RHAIBU-M33E521NFKSW
- RHAIBU-M33E5221Y0JN

## Related Decisions

- RHAIBU-M33E522CPQBW
- RHAIBU-M33E522QXSAA
