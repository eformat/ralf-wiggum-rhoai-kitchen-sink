# Observations: OGX (Llama Stack) Core (doc-derived)

## Summary

OGX is RHOAI 3.5's unified AI runtime environment for generative AI workloads —
the renamed and evolved Llama Stack, optimized for retrieval-augmented
generation (RAG) and agent-based workflows. This observation document was
produced from the official RHOAI 3.5 product documentation (Working with OGX;
Building RAG applications with OGX) because no live demo cluster was available
at authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ogx-working-with-ogx.txt | §1.1 Migrating from Llama Stack to OGX | Breaking rename table: API group `llamastack.io` → `ogx.io`, API version `v1alpha1` → `v1beta1`, kind `LlamaStackDistribution` → `OGXServer`, plural → `ogxservers`, short name `llsd` → `ogxserver`, container `llama-stack` → `ogx`, app label → `app: ogx`, `.status.routeURL` → `.status.externalURL`, mount `/.llama` → `/.ogx` |
| 2 | ogx-working-with-ogx.txt | §2 Overview of OGX | Component model: OGX Operator, run.yaml (enabled APIs + providers, Red Hat default shipped), OGXServer CR, inference model connections (vLLM proxy), embedding generation (remote recommended for production), vector storage (Milvus, pgvector), metadata persistence (PostgreSQL default), retrieval and agentic workflows (OpenAI-compatible Responses and Chat Completions); OGX is Technology Preview in 3.5 |
| 3 | ogx-working-with-ogx.txt | §4.1–4.2 Supported APIs | OGX API support levels vary: Responses API (`/v1/responses`) is Generally Available; Vector Stores, Files, Chat Completions, Embeddings, Models APIs are OpenAI-compatible; Dataset_IO and others are Technology Preview; several APIs are Developer Preview |
| 4 | ogx-working-with-ogx.txt | §5–6 Activating / Deploying | OGX Operator activated via DSC `ogx` component `managementState: Managed`; OGXServer CR with `distribution.name: rh-dev`, `workload.replicas`, `workload.storage`; server listens on port 8321; service named `<ogxserver-name>-service` |
| 5 | ogx-working-with-ogx.txt | §7 Testing your vLLM model endpoints | Token from `default-<model>-sa` secret, endpoint from route, curl chat completion with `Authorization: Bearer`; manual `oc expose` creates unsecured routes |
| 6 | ogx-building-rag-apps.txt | §1.1–1.2 RAG overview / OGXServer deployment | RAG audience: data scientists, MLOps engineers, data engineers, AI engineers; deployment examples A (remote Milvus, gRPC port 19530) and B (remote PostgreSQL with pgvector); remote embedding model (`nomic-embed-text-v1-5`) required; Docling-enabled ingestion pipeline for batch document processing |
| 7 | ogx-building-rag-apps.txt | §1.3–1.4 Ingesting / querying | Notebook flow: `ogx_client` install, `OGXClient(base_url=...)`, `models.list()` (LLM + embedding with `embedding_dimension` 768), `vector_stores.create` with `provider_id: "pgvector"`, `files.create` + `vector_stores.files.create` with static chunking (800/400 tokens), `responses.create` with `file_search` tool |
| 8 | ogx-building-rag-apps.txt | §2.2 OGX search types | Keyword (TF-IDF/BM25), vector (cosine/inner product), hybrid (blended) search modes with `mode`, `max_chunks`, `score_threshold` params; availability depends on the vector store provider |

## User Flows

### Flow 1: Activate and deploy an OGX server

1. **Activate operator** — DSC `spec.components.ogx.managementState: Managed` (§5)
2. **Provision metadata store** — PostgreSQL 14+ reachable from the cluster (§6)
3. **Apply OGXServer CR** — `rh-dev` distribution, `VLLM_URL` (must end `/v1`), `POSTGRES_*` env from secrets (§6)
4. **Verify** — operator pod Running; server logs `Uvicorn running on ...:8321` (§6)

### Flow 2: Build the RAG loop from a notebook

1. **Connect** — `ogx_client.OGXClient(base_url=...)`, `models.list()` (§1.3)
2. **Register vector store** — `vector_stores.create` with embedding model, dimension, `provider_id: "pgvector"` (§1.3)
3. **Ingest** — `files.create` (purpose `assistants`) then `vector_stores.files.create` with static chunking (§1.3)
4. **Query** — `responses.create` with `file_search` tool and `vector_store_ids`; direct `vector_io.query()` inspection (§1.4)
5. **Verify** — context-aware response; out-of-scope answers declined (§1.3–1.4)

### Flow 3: Test the model endpoint directly

1. **Retrieve token** — `default-<model>-sa` secret or copy login command (§7)
2. **Curl chat completion** — `POST $MODEL_ENDPOINT/v1/chat/completions` with Bearer token (§7)

## Features and Concepts

### OpenShift Platform
- Operators (Installed Operators view), DataScienceCluster CR, secrets (`Secret` key refs), routes, HPAs, pod disruption budgets, topology spread constraints

### RHOAI / AI Platform
- OGX Operator and OGXServer CR (ogx.io/v1beta1), `rh-dev` distribution reference, run.yaml provider configuration, Files API (`inline::localfs` default, `remote::s3` offload), vector stores (Milvus, pgvector), PostgreSQL metadata persistence, Gen AI Studio playground auto-provisioned pgvector (`genai-pgvector-` prefix, Technology Preview)

### AI/ML Fundamentals
- RAG (ingest, chunk, embed, retrieve, generate), embedding dimensions, static chunking strategies (max 800 / overlap 400 tokens), keyword vs vector vs hybrid retrieval, OpenAI-compatible API surface (`/v1/responses`, `/v1/files`, chat completions)

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on deploy + RAG → advanced)
- **Target audience**: data scientists and AI engineers with OpenShift working knowledge; MLOps engineers for the HA/autoscaling module
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics, Python notebooks
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with OGX available in the DSC, GPU support for vLLM inference, PostgreSQL for metadata, remote embedding model

## Open Questions

- Menu label for the operator list (`Ecosystem` vs `Operators`) differs between OpenShift 4.19 and 4.20 docs (doc-derived, both variants present)
- S3 bucket provisioning responsibility in workshop clusters (auto-create vs manual) must be confirmed before Act-phase testing
