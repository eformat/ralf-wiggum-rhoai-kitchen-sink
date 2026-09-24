---
schema_version: 1
id: RHAIBU-M33FYFWKTS9S
type: requirement
---
# vLLM CPU ServingRuntime on IBM Z / Power Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 on IBM Z (s390x) or
IBM Power (ppc64le) need hands-on experience serving models with the vLLM CPU
ServingRuntime for KServe — the supported vLLM path on those architectures —
before they can recommend or operate it in production. Without a structured
workshop, learners must reverse-engineer the architecture constraints (no GPU
accelerators, standard deployment mode only) and the CPU-only resource sizing
model from product documentation alone. This workshop targets RHOAI users with
working knowledge of OpenShift and model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to confirm the cluster node architecture (`s390x` on IBM Z or `ppc64le` on IBM Power) with `oc get nodes -o jsonpath='{.items[0].status.nodeInfo.architecture}'`
- [REQ-002] Learner MUST be able to verify the DataScienceCluster instance reports `READY: True` with `oc get dsc`
- [REQ-003] Learner MUST be able to locate the pre-installed vLLM CPU ServingRuntime for KServe in `redhat-ods-applications` and inspect its container image
- [REQ-004] Learner MUST be able to deploy a generative model from the *Deploy a model* wizard, selecting the vLLM CPU ServingRuntime for KServe and sizing the deployment through CPU and Memory requests and limits
- [REQ-005] Learner MUST be able to verify the deployment from the CLI: the `InferenceService` reports `Ready: True` and the predictor pod is `Running`
- [REQ-006] Learner MUST be able to retrieve the authentication token and inference endpoint for the deployed model from the dashboard and the CLI
- [REQ-007] Learner MUST be able to send authenticated OpenAI-compatible requests to the `/v1/models` and `/v1/chat/completions` endpoints and receive successful responses
- [REQ-008] Learner MUST observe that an unauthenticated request to the service returns `401 Unauthorized`

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the lab;
the wizard deployment completes with a checkmark in the *Status* column, the
`InferenceService` reaches `Ready: True`, and the `/v1/models` request lists the
model while unauthenticated access is rejected with `401`.

## Risks

- Workshop cluster must run on IBM Z (s390x) or IBM Power (ppc64le) — the exercises are meaningless on x86_64
- Pre-installed model-serving runtimes must be enabled in the RHOAI dashboard under *Settings*, *Serving runtimes*
- Loading a model on CPU-backed nodes can take several minutes depending on model size and requested resources

## Assumptions

- RHOAI 3.5 is installed on an OpenShift cluster with IBM Z or IBM Power nodes and the model serving platform enabled
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A model location (OCI registry, S3 object storage, URI, or PVC) is accessible to the model server with a connection in the working project

## Related Designs

- RHAIBU-M33FYFY9TFZ3

## Related Decisions

- RHAIBU-M33FYFXND646
- RHAIBU-M33FYFXX7P3J

## Related Requirements

- RHAIBU-M33FYFWZECSZ
- RHAIBU-M33FYFXBJWZ3
