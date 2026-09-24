---
schema_version: 1
id: RHAIBU-M33FYFWZECSZ
type: requirement
---
# Module 01: Getting Started

## Problem

Before sending inference requests, learners need to confirm their cluster can
serve models on IBM Z or IBM Power, locate the pre-installed vLLM CPU
ServingRuntime for KServe, and deploy a model with the *Deploy a model* wizard.
Without this groundwork, later CLI verification and inference exercises have
nothing to operate on.

## Requirements

- [REQ-011] Learner MUST be able to confirm the cluster node architecture is `s390x` (IBM Z) or `ppc64le` (IBM Power) and the DataScienceCluster instance reports `READY: True`
- [REQ-012] Learner MUST be able to locate the pre-installed vLLM CPU ServingRuntime for KServe in the `redhat-ods-applications` namespace with `oc get servingruntimes` and inspect its container image
- [REQ-013] Learner MUST be able to deploy a generative model from the *Deploy a model* wizard: model location, hardware profile, serving runtime selection, and CPU/Memory resource sizing
- [REQ-014] Learner MUST observe the deployed model on the *Deployments* tab with a checkmark in the *Status* column

## Success Metrics

Learner completes both exercises: the architecture/runtime inspection commands
producing the documented expected output (`s390x` or `ppc64le`, `READY: True`,
vLLM CPU runtime in the list), and the wizard deployment showing a checkmark in
the *Status* column.

## Risks

- If the runtime list is empty or the vLLM CPU runtime is missing, the facilitator must enable the pre-installed model-serving runtimes in the RHOAI dashboard under *Settings*, *Serving runtimes*
- Model loading on CPU-backed nodes can take several minutes depending on model size

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- A connection to the model storage exists in the working project

## Related Requirements

- RHAIBU-M33FYFWKTS9S

## Verified By

- features/model-serving/vllm-cpu-ibm-z-power/content/modules/ROOT/pages/module-01-getting-started.adoc
