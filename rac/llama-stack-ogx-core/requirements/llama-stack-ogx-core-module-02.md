---
schema_version: 1
id: RHAIBU-M33FZEM21PYV
type: requirement
---
# Module 02: Deploy an OGX Server and RAG

## Problem

Learners must activate the OGX Operator, deploy a real OGXServer wired to a
vLLM inference service and PostgreSQL metadata storage, and prove the RAG loop
end to end: ingest a document into a pgvector vector store and answer questions
grounded in it. This is the core deliverable of the workshop.

## Requirements

- [REQ-021] Learner MUST be able to activate the OGX Operator by patching the DataScienceCluster (`spec.components.ogx.managementState: Managed`) and confirm the operator pod is `Running` in `redhat-ods-applications`
- [REQ-022] Learner MUST be able to apply an OGXServer CR (ogx.io/v1beta1) with the `rh-dev` distribution, vLLM environment variables, and PostgreSQL metadata settings sourced from secrets
- [REQ-023] Learner MUST observe the server startup logs (`Uvicorn running on ...:8321`) and reach the instance at `<ogxserver-name>-service` on port 8321
- [REQ-024] Learner MUST be able to enable pgvector (`ENABLE_PGVECTOR: "true"`), create an `ogx_client.OGXClient`, and register a vector store with an embedding model and dimension
- [REQ-025] Learner MUST be able to upload a file with the Files API and index it into the vector store with a static chunking strategy
- [REQ-026] Learner MUST observe a context-aware response when `file_search` is enabled and that answers outside the document content are declined
- [REQ-027] Learner MUST be able to test the vLLM model endpoint with an authenticated chat completion request and receive a JSON chat completion response

## Success Metrics

The OGX Operator pod is running; OGXServer pods start with `Uvicorn running on
...:8321`; `client.vector_stores.files.create()` succeeds with indexed chunks;
the notebook returns a context-aware response with `file_search` enabled; the
vLLM endpoint returns a chat completion.

## Risks

- RAG requires a remote embedding model reachable from the cluster; queries without ingested content return empty or non-contextual responses
- PostgreSQL credentials must be provided via secrets, never as plaintext in the CR or command line

## Assumptions

- Learner has completed Module 01 (naming model verified) and has a vLLM-served model, remote embedding model, and PostgreSQL instance available

## Related Requirements

- RHAIBU-M33FZEKGR1M7

## Verified By

- features/ogx/llama-stack-ogx-core/content/modules/ROOT/pages/module-02-hands-on.adoc
