---
schema_version: 1
id: RHAIBU-M33FSHHXT2SE
type: requirement
---
# Red Hat AI Inference fast-release images as custom ServingRuntime Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience using Red Hat AI Inference fast-release images as custom
ServingRuntimes — the GA path to the latest vLLM versions between OpenShift AI
stable releases — before they can recommend or operate it in production. Without
a structured workshop, learners must reverse-engineer the three vLLM runtime
support levels, the support-status gating annotations, and the custom
ServingRuntime workflow from product documentation alone. This workshop targets
RHOAI users with working knowledge of OpenShift and model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to identify at least one vLLM runtime in each support level (supported GA, limited support, unsupported custom) on the dashboard *Serving runtimes* page, including the `fast-N` badge
- [REQ-002] Learner MUST be able to list serving runtimes cluster-wide (`oc get servingruntimes -A`) and distinguish GA images (`registry.redhat.io/rhaii`) from fast builds (`registry.redhat.io/rhaii-early-access`)
- [REQ-003] Learner MUST be able to inspect the gating annotations on a limited-support runtime template and observe `opendatahub.io/unsupported-status-accepted: "true"`
- [REQ-004] Learner MUST be able to create a custom ServingRuntime that references a fast-release image and carries the support-status, acceptance, and `fast-version` annotations, and verify it from the CLI
- [REQ-005] Learner MUST be able to deploy a generative model on the fast-release runtime from the deployment wizard and observe the pod transition to `Running`
- [REQ-006] Learner MUST be able to send an OpenAI-compatible chat completion request with a bearer token and receive a JSON response containing a `choices` object

## Success Metrics

All six acceptance criteria are demonstrated by the learner during the lab; the
fast-release ServingRuntime carries the acceptance annotations after module 02
exercise 1, the model pod reaches `Running` in module 02 exercise 2, and the
OpenAI-compatible `curl` request returns a JSON response with a `choices` object.

## Risks

- The fast-release image tag (`vllm-cuda-rhel9:3.5.0-ea.1-1780065492`) changes with every monthly fast build and must be checked against the Red Hat Ecosystem Catalog at workshop time
- The CUDA fast-release image requires GPU support with the Node Feature Discovery Operator installed
- The 1-month support window may expire before the workshop runs; migration to a newer fast build (`fast-N`) or a GA runtime may be needed

## Assumptions

- RHOAI 3.5 is installed with KServe enabled and the RHOAI operator present
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A pull secret for `registry.redhat.io` is available so the fast-release image can be pulled
- A model location (S3/URI/OCI/PVC connection) is available for deployment

## Related Designs

- RHAIBU-M33FSHKR3T54

## Related Decisions

- RHAIBU-M33FSHK0SQC0
- RHAIBU-M33FSHKCDV4R

## Related Requirements

- RHAIBU-M33FSHJ84P3N
- RHAIBU-M33FSHJMZC5N
