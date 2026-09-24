---
schema_version: 1
id: RHAIBU-M33FSHJMZC5N
type: requirement
---
# Module 02: Deploy a model on a fast-release ServingRuntime

## Problem

Learners must create a real custom ServingRuntime that references a Red Hat AI
Inference fast-release image, gate it with the support-status annotations, and
prove the model serves OpenAI-compatible inference. This is the core deliverable
of the workshop: an accepted fast-release runtime with verified end-to-end model
access, adopted without upgrading OpenShift AI.

## Requirements

- [REQ-021] Learner MUST be able to create a custom ServingRuntime (duplicating the vLLM NVIDIA GPU ServingRuntime) that references a `registry.redhat.io/rhaii-early-access` fast-release image and carries the `support-status`, `unsupported-status-accepted`, and `fast-version` annotations
- [REQ-022] Learner MUST be able to verify the acceptance annotations with `oc get template vllm-fast-1 -o yaml | grep -A 2 "opendatahub.io/support-status"` and see the runtime enabled with *Limited support* and `fast-N` badges
- [REQ-023] Learner MUST be able to deploy a generative model on the fast-release runtime from the *Deploy a model* wizard and observe the model pod transition from *Pending* to *Running*
- [REQ-024] Learner MUST be able to send an OpenAI-compatible chat completion (`/v1/chat/completions`) with a bearer token and receive a JSON response with a `choices` object

## Success Metrics

The fast-release ServingRuntime is created with the acceptance annotations and
shown enabled with badges; the model pod reaches `Running`; the chat completion
returns a JSON response with a `choices` object confirming the model is serving
on the fast-release image.

## Risks

- The fast-release image tag changes with every monthly fast build; the workshop tag must be validated against the Red Hat Ecosystem Catalog
- Deployment requires an NVIDIA GPU hardware profile and a reachable model location
- The acceptance annotation does not expire when the 1-month support window ends; learners must track migration to newer fast builds themselves

## Assumptions

- Learner has completed Module 01 (support levels and gating annotations understood)
- A pull secret for `registry.redhat.io` is configured
- A model location connection (S3/URI/OCI/PVC) exists in the project

## Related Requirements

- RHAIBU-M33FSHHXT2SE

## Verified By

- features/model-serving/rhai-fast-release-images/content/modules/ROOT/pages/module-02-hands-on.adoc
