# Observations: OGX File Processors API (doc-derived)

## Summary

The OGX File Processors API is a Developer Preview API in RHOAI 3.5 that
converts documents into vector-ready chunks using configurable extraction
backends, exposed at the `/v1alpha/file-processors` endpoint on OGX servers.
This observation document was produced from the official RHOAI 3.5 product
documentation (Working with OGX; Building a RAG application with OGX; 3.5
release notes) because no live demo cluster was available at authoring time.
Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ogx-working-with-ogx.txt | §4.1.1 File Processors API | Endpoint `/v1alpha/file-processors`; providers: all file processor backends deployed through OpenShift AI; support level Developer Preview; converts document types into vector-ready chunks via Docling, PyPDF, and others |
| 2 | ogx-working-with-ogx.txt | §4.3 OGX API provider support | Five file-processor providers: `inline::auto` (enabled by default), `inline::docling`, `inline::markitdown`, `inline::pypdf`, `remote::doclingserve` — the latter four "Dependency only. Requires a custom config.yaml file"; all Developer Preview, no disconnected support |
| 3 | ogx-working-with-ogx.txt | §4.2 OpenAI-compatible APIs | base_url rules: OGX client uses the service root without `/v1`; OpenAI-compatible SDKs and raw HTTP require the `/v1` path suffix |
| 4 | ogx-building-rag-apps.txt | Files API + Vector Stores flow | `client.files.create` (purpose `assistants`, default provider `inline::localfs`), `client.vector_stores.create` with `embedding_model`/`embedding_dimension`/`provider_id: milvus-remote`, `vector_stores.files.create` with static `chunking_strategy` (700/100), poll to `completed` |
| 5 | ogx-building-rag-apps.txt | Docling pipeline + query verification | Dashboard-imported pipeline with `base_url`, `pdf_filenames`, `num_workers`, `vector_store_id`, `service_url`, `embed_model_id`, `max_tokens`, `use_gpu` parameters; retrieval verified via `responses.create` with the `file_search` tool; OGX service exposes port `8321` |
| 6 | ai-available-assets-release-notes.txt | §4.2 3.5 EA2 Developer Preview features | File Processors API on OGX announced with the same five providers; note that some providers need a custom config.yaml including provider definitions |

## User Flows

### Flow 1: Document-to-chunks path

1. **Upload** — document stored through the OpenAI-compatible Files API (`/v1/files`); default provider `inline::localfs` (§4.2, Building a RAG app)
2. **Extraction** — a file processor backend (Docling, PyPDF, …) converts the document into structured, vector-ready chunks; this is the stage the File Processors API exposes as Developer Preview (§4.1.1)
3. **Indexing** — chunks embedded and written to a vector store through the Vector Stores API, making the document searchable (§4.1.5 Vector_IO; Building a RAG app)

### Flow 2: Upload and index from a client

1. **Connect** — `OgxClient(base_url="http://<ogx-service>:8321")` (service root without `/v1`; `/v1` only for OpenAI-compatible SDKs)
2. **Select embedding model** — `client.models.list()`, filter `model_type == "embedding"`
3. **Upload** — `client.files.create(file=(filename, f), purpose="assistants")`
4. **Index** — `client.vector_stores.create(...)` + `vector_stores.files.create(...)` with static chunking strategy (max 700 tokens, 100 overlap)
5. **Poll** — list vector-store files until status `completed` or `failed`

### Flow 3: Batch Docling pipeline

1. **Import pipeline YAML** into the project from the dashboard
2. **Run pipeline** with customizable parameters (base_url, pdf_filenames, num_workers, vector_store_id, service_url, embed_model_id, max_tokens, use_gpu)
3. **Verify retrieval** — `responses.create` with the `file_search` tool returns an answer grounded in the ingested document content

## Features and Concepts

### OpenShift Platform
- DataScienceCluster component management (`spec.components.ogx.managementState: Managed`), OGXServer CRD (`ogxservers.ogx.io`), services exposing port `8321`, RBAC/config secrets (Milvus endpoint and token)

### RHOAI / AI Platform
- OGX unified AI runtime, File Processors API (DP), extraction-backend providers with the "Dependency only" enablement model (custom config.yaml at runtime; dependencies pre-installed in the container image), OpenAI-compatible Files and Vector Stores APIs, Docling pipeline in the RAG demo repository

### AI/ML Fundamentals
- Document parsing and chunking vs embedding and indexing separation, static chunking strategies (chunk size + overlap), retrieval-grounded generation

## Workshop Potential

- **Estimated modules**: 2 (API tour → document-processing path)
- **Target audience**: platform engineers and ML practitioners with OpenShift and RAG working knowledge
- **Prerequisite knowledge**: RHOAI operator installed, OGX enabled, `oc` CLI basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with OGX enabled in the DSC; OGX server on port `8321`; reachable inference and embedding models; vector store provider (for example Milvus) configured

## Open Questions

- Whether any provider beyond `inline::auto` can be demonstrated without supplying a custom config.yaml (doc says no — all others are Dependency only)
- Availability of the RAG demo Docling pipeline sample in workshop clusters (module 02 prerequisite)
