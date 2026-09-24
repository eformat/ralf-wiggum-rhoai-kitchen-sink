# Observations: AutoRAG (doc-derived)

## Summary

AutoRAG is RHOAI 3.5's Technology Preview system for automatically optimizing
retrieval-augmented generation (RAG) configurations. You provide documents and a
JSON test data file; AutoRAG tests combinations of chunking, embedding,
retrieval, and generation settings, ranks the resulting RAG patterns on a
leaderboard by evaluation metrics, and generates Jupyter notebooks to run the
best pattern. This observation document was produced from the official RHOAI 3.5
product documentation (Working with AutoRAG; Deploying a RAG stack / evaluating
RAG systems with OGX) because no live demo cluster was available at authoring
time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | autorag-working-with-autorag.txt | §1.1 Workflow, §1.2 Terminology | AutoRAG tests chunking/embedding/retrieval/generation combinations against test data; each combination produces a RAG pattern with scores; automatically samples up to 1 GiB of relevant documents, prioritizing documents referenced in test data |
| 2 | autorag-working-with-autorag.txt | §1.5 Technology Preview limitations | Remote vector databases only (Milvus, pgvector); max 3 foundation + 2 embedding models per run; no embedded-image processing; no OCR for PDFs; table structure detection only with Better quality preset |
| 3 | autorag-working-with-autorag.txt | §2 Prepare test data | JSON array with `question`, `correct_answers` (multiple phrasings improve accuracy), `correct_answer_document_ids` (base file names, no folder paths); verification: valid JSON, required fields present, IDs match file names |
| 4 | autorag-working-with-autorag.txt | §3 Create an optimization run | Two-step wizard: name + OGX connection → knowledge setup (S3 documents, vector I/O provider, evaluation dataset), metric, Maximum RAG patterns (4–20, default 8), run preset, model exclusion; runs cannot be edited after creation |
| 5 | autorag-working-with-autorag.txt | §4 Evaluate results, §6 Metrics | Leaderboard ranks patterns by the selected metric; scores 0–1 with mean, CI high, CI low; pattern details show config by category + Sample Q&A; metric-combination guidance (high faithfulness + low correctness, etc.); View code (curl/Node.js/Go/Python), Try this pattern chat panel, Save as indexing/inference notebook |
| 6 | autorag-working-with-autorag.txt | §5 Run the RAG pattern | Attach same S3 bucket + OGX connection to workbench; indexing notebook optional (vector DB already populated); inference notebook prompts for a question and returns grounded answers; connection mismatches are the common failure |
| 7 | autorag-working-with-autorag.txt | §7 Configuration parameters | User-configurable parameters table (run preset, metric, Maximum RAG patterns, models, vector DB, input documents, evaluation dataset); search space defaults by preset (chunking method/size/overlap, retrieval method, number of chunks); Faster = 4 vCPU/16 GiB, Better quality = 8 vCPU/32 GiB |
| 8 | autorag-building-rag-ogx.txt | §1 RAG stack, §2 Evaluating RAG systems | OGXServer instance deployment, Llama model ingestion/querying, Docling document preparation, RAGAS evaluation with OGX; AutoRAG's evaluation-metric semantics align with these RAGAS-style measures |

## User Flows

### Flow 1: Create an optimization run

1. **Enable prerequisites** — admin sets `spec.dashboardConfig.genAiStudio` and `spec.dashboardConfig.autorag` to `true`; pipeline server with Enable AutoML and AutoRAG pipelines; OGX instance with models; remote vector database registered; OGX connection in project (§3 Prerequisites)
2. **Prepare test data** — JSON array with questions, expected answers, document IDs (§2)
3. **Open wizard** — Gen AI studio > AutoRAG > Create AutoRAG optimization run (§3)
4. **Configure** — OGX connection → knowledge setup (S3 documents up to 32 MiB upload, vector I/O provider, evaluation dataset), optimization metric, Maximum RAG patterns, run preset, optional model exclusion (§3)
5. **Verify** — run listed with Running/Pending status, progresses to Complete (§3)

### Flow 2: Evaluate and run the winning pattern

1. **Review leaderboard** — scores with mean, CI high, CI low; metric combinations read together (§4, §6)
2. **Inspect pattern details** — config by category, Sample Q&A with per-question scores (§4)
3. **Capture integration artifact** — View code (Responses API snippets) or Save as indexing/inference notebooks (§4)
4. **Run in workbench** — attach S3 + OGX connections, run indexing notebook (optional), run inference notebook, verify grounded answers (§5)

## Features and Concepts

### OpenShift Platform
- Projects, workbenches, data connections (S3 object storage, OGX connection with base URL + API key), pipeline servers, Kubernetes secrets for OGX credentials

### RHOAI / AI Platform
- AutoRAG optimization runs, RAG patterns (metrics + notebooks + Responses API template), leaderboards, Gen AI Studio dashboard entry point, OGX instance with foundation and embedding models, vector I/O providers (Milvus, pgvector), DataScienceCluster dashboard configuration flags, DataSciencePipelinesApplication `managedPipelines`

### AI/ML Fundamentals
- RAG (retrieval-augmented generation), chunking (recursive vs. hybrid with Docling structural contextualization), embedding models, evaluation metrics (answer faithfulness, answer correctness, context correctness), confidence intervals on scores, test-data-driven evaluation

## Workshop Potential

- **Estimated modules**: 2 (get started → evaluate and run)
- **Target audience**: ML practitioners and platform engineers with editor access to a RHOAI project
- **Prerequisite knowledge**: RAG concepts, RHOAI dashboard basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with Gen AI Studio/AutoRAG DSC flags, OGX instance, remote vector database, pipeline server with AutoML/AutoRAG pipelines enabled

## Open Questions

- Exact `Gen AI studio > AutoRAG` menu label on a live console (doc-derived path)
- Whether evaluation runs complete fast enough on the workshop cluster for module 02 to follow module 01 immediately (Faster preset duration unknown)
- Externally created runs (from the pipeline outside the AutoRAG interface) appear on the AutoRAG page — behavior to confirm in Act phase
