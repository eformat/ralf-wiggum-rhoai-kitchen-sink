---
schema_version: 1
id: RHAIBU-M33FZEKGR1M7
type: requirement
---
# OGX (Llama Stack) Core Workshop

## Problem

Data scientists and AI engineers evaluating RHOAI 3.5 need hands-on experience
with OGX — the renamed and evolved Llama Stack runtime for RAG and agentic
workflows — before they can build retrieval-augmented applications on it.
Because OGX replaced Llama Stack with breaking API changes (`llamastack.io` →
`ogx.io`, `LlamaStackDistribution` → `OGXServer`), learners must relearn the
naming model, operator activation, and RAG wiring from product documentation
alone. This workshop targets RHOAI users with working knowledge of OpenShift,
model serving, and basic Python.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify the `ogxservers.ogx.io` CRD is registered and inspect the OGX naming model (`LlamaStackDistribution` → `OGXServer`)
- [REQ-003] Learner MUST be able to activate the OGX Operator by setting `spec.components.ogx.managementState: Managed` in the DataScienceCluster and confirm the operator pod is running
- [REQ-004] Learner MUST be able to deploy an `OGXServer` (ogx.io/v1beta1) connected to a vLLM inference service and PostgreSQL metadata storage and observe the server startup logs
- [REQ-005] Learner MUST be able to enable the pgvector vector store (`ENABLE_PGVECTOR: "true"`), register a vector store with the OGX client, and list the served models
- [REQ-006] Learner MUST be able to ingest a document into the vector store and run a grounded RAG query with the `file_search` tool on the Responses API
- [REQ-007] Learner MUST be able to test the vLLM model endpoint directly with an authenticated chat completion request and receive a JSON response
- [REQ-008] Learner SHOULD be able to compare keyword, vector, and hybrid search modes against the ingested corpus
- [REQ-009] Learner SHOULD be able to configure high availability and autoscaling on the OGXServer CR and verify the resulting HPA
- [REQ-010] Learner SHOULD be able to offload Files API storage to an external S3-compatible provider and verify the file upload

## Success Metrics

All seven MUST criteria are demonstrated by the learner during the lab; the
OGXServer reaches running pods with `Uvicorn running on ...:8321` in modules
01–02, the RAG loop returns context-aware responses with `file_search`, and the
vLLM endpoint returns a chat completion.

## Risks

- OGX integration is a Technology Preview feature in RHOAI 3.5 and may change between releases
- Workshop cluster must have the OGX component available in the DSC and GPU support enabled for vLLM inference
- PostgreSQL metadata storage and a remote embedding model must be pre-provisioned for module 02 exercises
- Search mode availability depends on the selected vector store provider (module 03)

## Assumptions

- RHOAI 3.5 is installed with the OGX component available in the DataScienceCluster
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A vLLM-served LLM (for example `llama-3.2-3b-instruct`) and a remote embedding model (for example `nomic-embed-text-v1-5`) are available
- PostgreSQL 14 or later is available for OGX metadata persistence

## Related Designs

- RHAIBU-M33FZEN3QKX1

## Related Decisions

- RHAIBU-M33FZEMKBDJB
- RHAIBU-M33FZEMW6GT6

## Related Requirements

- RHAIBU-M33FZEKTM39K
- RHAIBU-M33FZEM21PYV
- RHAIBU-M33FZEMBGM12
