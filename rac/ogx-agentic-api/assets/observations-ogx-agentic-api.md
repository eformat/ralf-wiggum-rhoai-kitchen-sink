# Observations: OGX-native agentic API surface (doc-derived)

## Summary

The OGX-native agentic API surface (Tool Runtime, Responses, Conversations) is
RHOAI 3.5's Technology Preview path for building agentic and RAG applications
on OpenShift AI. OGX is a unified AI runtime managed by the OGX Operator
through OGXServer custom resources; it exposes a native API layer (Tool
Runtime, Vector_IO, File Processors, Datasets_IO — mostly Developer Preview)
and an OpenAI-compatible layer (Responses GA, Conversations TP, Chat
Completions TP) that lets existing OpenAI SDKs connect unchanged apart from the
`base_url`. This observation document was produced from the official RHOAI 3.5
product documentation because no live demo cluster was available at authoring
time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ogx-working-with-ogx.txt | §1 LLAMA STACK TO OGX MIGRATION | Migration from LlamaStackDistribution to OGXServer (ogx.io/v1beta1); `dsc.spec.components.ogx = "Managed"` in the DSC |
| 2 | ogx-working-with-ogx.txt | §2 OVERVIEW OF OGX | OGX Operator + run.yaml (defines enabled APIs and backend providers) + OGXServer CR; OGX integration is Technology Preview in 3.5; OGX Operator not supported on IBM Z |
| 3 | ogx-working-with-ogx.txt | §4.1 SUPPORTED OGX APIS | Native layer: File Processors (`/v1alpha/file-processors`, DP), Datasets_IO (`/v1alpha/datasetio`, TP), Inference (`/v1alpha/inference`, DP, mostly deprecated), Tool Runtime (`/v1/tool-runtime`, DP), Vector_IO (`/v1/vector-io`, DP) |
| 4 | ogx-working-with-ogx.txt | §4.2 OPENAI-COMPATIBLE APIS | `base_url` must use the OGX route with the `/v1` path suffix or requests fail; Models, Chat Completions, Completions, Embeddings, Files TP; Vector Store Files DP; Responses GA; Conversations TP |
| 5 | ogx-working-with-ogx.txt | §4.2.1.8 Responses API | RAG workflow combining Files API, Vector Stores API, and Responses API with the `file_search` tool |
| 6 | ogx-working-with-ogx.txt | §4.2.1.9 Conversations API | Server-side conversation state; `conversation` parameter instead of `previous_response_id`; full CRUD + `/items` subpaths; `store=True` persists each response |
| 7 | ogx-working-with-ogx.txt | §3.3–3.4 SECURITY REFERENCE | Guardrails via `moderation_endpoint` on the responses provider (not CRD level); `NemoGuardrails` CRD (trustyai.opendatahub.io/v1alpha1) as the production path |
| 8 | ogx-building-rag-apps.txt | §1.2 DEPLOYING A OGXSERVER INSTANCE | Example OGXServer manifests: remote Milvus (production) and pgvector configurations; connection secrets |
| 9 | ogx-building-rag-apps.txt | §1.3–1.4 INGESTING/QUERYING CONTENT | OGX SDK in a notebook: upload PDF, create vector store (remote Milvus recommended for production), add file with static chunking strategy, poll status to `completed`, query |

## User Flows

### Flow 1: Deploy an OGXServer and connect an OpenAI SDK client

1. **Verify prerequisites** — `ogx` component `managementState: Managed` in the DSC (§1)
2. **Apply OGXServer manifest** — ogx.io/v1beta1, `rh-dev` distribution, storage size, env overrides for the inference model (§1.2 in ogx-building-rag-apps.txt)
3. **Watch phase** — `status.phase` reaches `Running`; operator-created services expose port `8321`
4. **Connect client** — OpenAI SDK with `base_url` = OGX route/service hostname + `/v1` suffix (§4.2)
5. **List models and infer** — `client.models.list()`, then Chat Completions (§4.2)

### Flow 2: Multi-turn conversation with server-side state

1. **Create conversation** — `POST /v1/conversations` with optional metadata (§4.2.1.9)
2. **Send turns** — Responses API with `conversation` parameter and `store=True` (§4.2.1.9)
3. **List items** — `GET /v1/conversations/{id}/items` returns accumulated messages
4. **Delete** — `DELETE /v1/conversations/{id}` removes conversation and history (§4.2.1.9)

### Flow 3: Grounded RAG query

1. **Upload file** — Files API with `purpose: assistants` (§4.2.1.8)
2. **Create vector store** — Vector Stores API with embedding model/dimension and `provider_id: milvus-remote` (§4.2.1.8, ogx-building-rag-apps.txt)
3. **Index file** — static chunking strategy (700 max chunk tokens, 100 overlap); poll status to `completed` (ogx-building-rag-apps.txt)
4. **Query with file_search** — Responses API with `tools: [{type: file_search, vector_store_ids: [...]}]`; OGX retrieves chunks as context (§4.2.1.8)

## Features and Concepts

### OpenShift Platform
- OGX Operator, OGXServer CRD, DataScienceCluster component spec, connection secrets, services

### RHOAI / AI Platform
- Native OGX APIs (Tool Runtime, Vector_IO, File Processors, Datasets_IO), OpenAI-compatible surface (Models, Chat Completions, Files, Vector Stores, Responses, Conversations), run.yaml provider configuration, guardrails (`moderation_endpoint`, `moderation_headers`, fail-closed), `NemoGuardrails` CRD production path

### AI/ML Fundamentals
- RAG (ingestion, chunking, embedding, similarity search), vector stores (Milvus, pgvector), multi-turn conversation state, tool calling at runtime

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: AI engineers and data scientists building agentic/RAG apps on OpenShift AI
- **Prerequisite knowledge**: OpenShift basics, Python, OpenAI SDK familiarity
- **Estimated duration**: about 2 hours
- **Cluster requirements**: RHOAI 3.5 with the OGX component enabled in the DSC; an Ollama inference server for the self-contained workshop deployment; remote Milvus for the RAG exercise

## Open Questions

- Remote Milvus vector store availability in workshop clusters (RAG exercise prerequisite)
- Moderation endpoint (`moderation_endpoint` on the responses provider) must be configured by a platform administrator before a positive guardrails test can run
- No worked Tool Runtime client example exists in the 3.5 docs — the survey exercise cannot be hands-on until upstream docs add one
