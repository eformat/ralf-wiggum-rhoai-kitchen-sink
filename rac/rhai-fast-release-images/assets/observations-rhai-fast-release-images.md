# Observations: Red Hat AI Inference fast-release images as custom ServingRuntime (doc-derived)

## Summary

Red Hat AI Inference fast-release images as custom ServingRuntime is RHOAI 3.5's
GA path to the latest vLLM versions between OpenShift AI stable releases:
Red Hat-built vLLM container images published to
`registry.redhat.io/rhaii-early-access`, deployed as custom ServingRuntimes
gated by support-status annotations. This observation document was produced from
the official RHOAI 3.5 product documentation (Configuring your model-serving
platform; Deploying models; Red Hat AI available assets release notes) because
no live demo cluster was available at authoring time. Every item below is doc
evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | rhai-configuring-model-serving.txt | §1.3 vLLM runtime support levels | Three support levels: supported (GA), limited support (fast builds), unsupported (custom); fast builds are Red Hat-built images in `registry.redhat.io/rhaii-early-access` with a 1-month support coverage window |
| 2 | rhai-configuring-model-serving.txt | §1.3 Badge indicators | Badges appear in admin view (Settings → Model resources and operations → Serving runtimes) and data-scientist view (deployment wizard runtime dropdown); Limited support = orange, version = blue, `fast-N` = yellow, Pre-installed = blue |
| 3 | rhai-configuring-model-serving.txt | §1.3 Fast build versioning | `opendatahub.io/fast-version` annotation; sequential numeric versions `fast-1`/`fast-2`/`fast-N`; each build maps to a specific upstream vLLM version shown with a version badge |
| 4 | rhai-configuring-model-serving.txt | §2.5 Enable limited-support runtimes from the Dashboard | Risk acknowledgment modal ("support coverage limited to 1 month after release"), I understand checkbox + Enable; verification via `oc get template <runtime-name> -o yaml | grep unsupported-status-accepted` |
| 5 | rhai-configuring-model-serving.txt | §2.6 Enable limited-support runtimes using GitOps | Same annotations applied declaratively (ArgoCD/Flux); `opendatahub.io/support-status: unsupported`, `unsupported-status-accepted: "true"`, `fast-version: "1"`; Git commit history is the auditable acceptance record |
| 6 | rhai-configuring-model-serving.txt | §2.7 Limited-support runtime state and backward compatibility | Acceptance annotation persists through disable/re-enable, operator upgrades, and cluster maintenance; annotation does not auto-expire; revocation via `oc annotate servingruntime <name> opendatahub.io/unsupported-status-accepted-`; runtimes without `support-status` annotation treated as supported (purely additive) |
| 7 | rhai-configuring-model-serving.txt | §2.3 Adding a custom model-serving runtime | Custom runtimes are user-created and distinct from limited-support runtimes — custom have no Red Hat support, fast builds are Red Hat-built with a 1-month window |
| 8 | ai-available-assets-release-notes.txt | Support for deploying Red Hat AI Inference fast release container images as a custom serving runtime | Adopt fast-release images without upgrading RHOAI; create a ServingRuntime resource and an LLMInferenceServiceConfig manifest referencing the fast container image; fast images from the next version cycle are validated against the current stable release |

## User Flows

### Flow 1: Decode support levels and inspect gating (admin)

1. **Open the Serving runtimes page** — Settings → Model resources and operations → Serving runtimes (§1.3)
2. **Read the badges** — Pre-installed + version (GA); Pre-installed + Limited support + version + `fast-N` (fast builds); no Pre-installed label (custom) (§1.3)
3. **Inspect gating from the CLI** — `oc get servingruntimes -A`; registry comparison `registry.redhat.io/rhaii` vs `registry.redhat.io/rhaii-early-access`; grep `unsupported-status-accepted` on a runtime template (§2.5)

### Flow 2: Adopt a fast-release image as a gated custom runtime

1. **Enable via Dashboard** — toggle the limited-support runtime, accept the 1-month risk modal (§2.5); or **via GitOps** — add the acceptance annotations to the manifest and sync (§2.6)
2. **Verify acceptance** — `unsupported-status-accepted: "true"` in the cluster resource; runtime shown enabled with Limited support and `fast-N` badges, visible to data scientists in the wizard dropdown (§2.5–2.6)
3. **Deploy a model** — create a ServingRuntime and LLMInferenceServiceConfig referencing the fast container image; fast images from the next version cycle are validated against the current stable release (release notes)
4. **Manage the lifecycle** — annotation persists across disable/re-enable and upgrades; does not auto-expire at the 1-month mark; revoke by removing the annotation (§2.7)

## Features and Concepts

### OpenShift Platform
- ServingRuntime and LLMInferenceServiceConfig CRs (serving.kserve.io/v1alpha1), annotations as gating mechanism, GitOps pipelines (ArgoCD/Flux) with cluster-admin RBAC

### RHOAI / AI Platform
- vLLM runtime support levels, `registry.redhat.io/rhaii-early-access` release channel, dashboard badges (Pre-installed / Limited support / version / `fast-N`), risk acknowledgment modal, vLLMDeploymentOnMaaS feature flag for accelerator configurations (Technology Preview)

### AI/ML Fundamentals
- Upstream vLLM release cadence vs stable OpenShift AI releases; model support and new model formats arriving faster through fast builds

## Workshop Potential

- **Estimated modules**: 2 (support levels → deploy on a fast-release runtime)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics, RHOAI operator installed, KServe enabled
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5, pull secret for `registry.redhat.io`, GPU support with Node Feature Discovery Operator for the CUDA fast-release image

## Open Questions

- Exact fast-build tag for `vllm-cuda-rhel9` in the Red Hat Ecosystem Catalog at workshop time (tag changes with every monthly fast build)
- Whether the release-notes flow (ServingRuntime + LLMInferenceServiceConfig manifest pair) is fully exercised by the workshop's dashboard-duplicate approach (doc evidence covers both paths)
