---
schema_version: 1
id: RHAIBU-M33DSKJGR1E2
type: requirement
---
# Module 03: RAG, citations, and advanced APIs

## Problem

After a working OGX server, AI engineers need to ground answers in their own
documents (RAG via Files, Vector Stores, and the `file_search` tool), trace
answers back to sources with `file_citation` annotations, and understand the
guardrails opt-in and the native Tool Runtime API support level. These are the
advanced surfaces of the agentic API.

## Requirements

- [REQ-031] Learner MUST be able to run a RAG workflow (upload file via Files API, create a vector store, index with a static chunking strategy) and poll until the file status prints `completed`
- [REQ-032] Learner MUST be able to query with the `file_search` tool (`vector_store_ids`) and observe a grounded answer, versus an ungrounded answer without `vector_store_ids`
- [REQ-033] Learner SHOULD be able to inspect `file_citation` annotations under `output[].content[]` with `type`, `file_id`, `filename`, and `index` fields
- [REQ-034] Learner SHOULD be able to observe the guardrails opt-in (`guardrails: true`) returning either a normal completion or an explanatory `400` when no `moderation_endpoint` is configured, and state the fail-closed behavior
- [REQ-035] Learner SHOULD be able to state which layer hosts the Tool Runtime API (native OGX, not OpenAI-compatible) and its support level (Developer Preview)

## Success Metrics

Learner completes all four exercises: the polling loop prints `File status:
completed`, the `file_search` answer is grounded, the annotations array shows
`file_citation` entries, and the guardrails/Tool Runtime survey questions are
answered.

## Risks

- Citation accuracy depends on the underlying model's capabilities; smaller models may produce less precise attributions
- The `guardrails: true` request returns a `400` when no `moderation_endpoint` is configured on the responses provider (platform-administrator setup)
- The RHOAI 3.5 docs include no worked client example for the Tool Runtime API

## Assumptions

- Learner has completed Module 02 (a running OGXServer and connected client exist)
- An embedding model and a vector store provider (remote Milvus) are available for the RAG exercise

## Related Requirements

- RHAIBU-M33DSKJ262BA

## Verified By

- features/agents-mcp/ogx-agentic-api/content/modules/ROOT/pages/module-03-advanced.adoc
