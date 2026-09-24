---
schema_version: 1
id: RHAIBU-M33F08EBF9CZ
type: requirement
---
# Module 01: Get started with AutoRAG

## Problem

Before creating optimization runs, learners need to understand what AutoRAG
does, the limits of its Technology Preview scope, and how to structure the JSON
test data that drives evaluation. Without well-formed test data and an
understanding of the run parameters (metric, preset, model maximum), the
optimization run either fails or produces scores the learner cannot interpret.

## Requirements

- [REQ-011] Learner MUST be able to create a `test-data.json` file where every entry contains `question` and `correct_answers` fields and every `correct_answer_document_ids` value matches a file name in the document set exactly
- [REQ-012] Learner MUST be able to validate the test data file is well-formed JSON with `python3 -m json.tool test-data.json` (normalized output, not a `JSONDecodeError`)
- [REQ-013] Learner MUST be able to create an AutoRAG optimization run via the dashboard (`Gen AI studio > AutoRAG > Create AutoRAG optimization run`) selecting an OGX connection, S3 documents, vector database, evaluation dataset, optimization metric, and run preset
- [REQ-014] Learner MUST be able to confirm the new run is listed on the AutoRAG page with status Running or Pending and progresses to Complete

## Success Metrics

Learner completes both exercises: the validated test data file and the created
optimization run, each producing the documented expected output (normalized JSON
reprint; run status Running/Pending progressing to Complete).

## Risks

- Optimization runs cannot be edited after creation — wrong metric, preset, or model selection forces a re-run
- Technology Preview limits (remote-only vector databases, 3+2 model maximum, no OCR, no embedded-image processing) can fail a run if ignored
- vLLM-deployed foundation models without tool calling enabled cause run failures

## Assumptions

- Learner has completed Getting Connected (dashboard access, working project)
- Administrator has enabled `spec.dashboardConfig.genAiStudio` and `spec.dashboardConfig.autorag` in the DataScienceCluster, and the project has a pipeline server with AutoML/AutoRAG pipelines enabled

## Related Requirements

- RHAIBU-M33F08DZCEWR

## Verified By

- features/feature-store-automl-autorag/autorag/content/modules/ROOT/pages/module-01-getting-started.adoc
