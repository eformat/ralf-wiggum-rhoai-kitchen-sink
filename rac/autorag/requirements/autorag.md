---
schema_version: 1
id: RHAIBU-M33F08DZCEWR
type: requirement
---
# AutoRAG Workshop

## Problem

ML practitioners and platform engineers evaluating RHOAI 3.5 need hands-on
experience with AutoRAG — the Technology Preview system that automatically
optimizes retrieval-augmented generation (RAG) configurations — before they can
recommend it for production document workloads. Manually tuning chunking,
embedding, retrieval, and generation settings is slow and error-prone, and
learners must otherwise reverse-engineer the optimization workflow, evaluation
metrics, and leaderboard interpretation from product documentation alone. This
workshop targets RHOAI users with editor access to a project and an OGX instance
configured with foundation and embedding models.

## Requirements

- [REQ-001] Learner MUST be able to prepare a JSON test data file with `question`, `correct_answers`, and `correct_answer_document_ids` fields and validate it is well-formed JSON (`python3 -m json.tool test-data.json`)
- [REQ-002] Learner MUST be able to create an AutoRAG optimization run from the dashboard wizard (`Gen AI studio > AutoRAG > Create AutoRAG optimization run`) with an OGX connection, S3 documents, a vector database, and an evaluation dataset
- [REQ-003] Learner MUST be able to select an optimization metric (Answer faithfulness, Answer correctness, or Context correctness) and a run preset (Faster or Better quality) when creating the run
- [REQ-004] Learner MUST be able to verify the new optimization run is listed with a status of Running or Pending and progresses to Complete
- [REQ-005] Learner MUST be able to review the leaderboard and pattern details of a completed run, comparing scores (mean, CI high, CI low) across the three evaluation metrics
- [REQ-006] Learner MUST be able to capture a Responses API code snippet (curl, Node.js, Go, or Python) or save the indexing and inference notebooks for the selected pattern
- [REQ-007] Learner MUST be able to run the selected RAG pattern in a workbench with the inference notebook and receive answers grounded in their documents
- [REQ-008] Learner SHOULD be able to exclude foundation and embedding models on the model configuration card, respecting the Technology Preview maximum of three foundation models and two embedding models per run

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the lab;
the optimization run reaches Complete and the inference notebook returns
grounded answers in module 02.

## Risks

- AutoRAG is Technology Preview in 3.5 — dashboard navigation, limits, and behavior may change between releases
- Optimization runs cannot be edited after creation; misconfiguration forces a new run
- Runs require pre-provisioned infrastructure: OGX instance, remote vector database (Milvus or pgvector), pipeline server with AutoML/AutoRAG pipelines enabled, and DSC dashboard flags (`spec.dashboardConfig.genAiStudio`, `spec.dashboardConfig.autorag`)
- Foundation models deployed with vLLM must have tool calling enabled (`--enable-auto-tool-choice`, `--tool-call-parser`) or runs fail

## Assumptions

- RHOAI 3.5 is installed with the DSC dashboard configuration flags for Gen AI Studio and AutoRAG set to `true`
- Learners have editor access to a project with a pipeline server, an OGX connection, and an S3-compatible bucket
- Documents are in PDF, DOCX, PPTX, Markdown, HTML, or TXT format

## Related Designs

- RHAIBU-M33F08FWR6GN

## Related Decisions

- RHAIBU-M33F08F49FKR
- RHAIBU-M33F08FFXZDF

## Related Requirements

- RHAIBU-M33F08EBF9CZ
- RHAIBU-M33F08EQRBQS
