---
schema_version: 1
id: RHAIBU-M33F08EQRBQS
type: requirement
---
# Module 02: Evaluate results and run the RAG pattern

## Problem

After an optimization run completes, learners must interpret the leaderboard —
reading faithfulness, answer correctness, and context correctness scores
together rather than in isolation — to pick a pattern that will generalize.
They then need to put the winning pattern to work in a workbench with the
generated notebooks, which is where connection misconfigurations most often
surface.

## Requirements

- [REQ-021] Learner MUST be able to open a completed run's leaderboard and compare RAG pattern scores across the three evaluation metrics (mean, CI high, CI low)
- [REQ-022] Learner MUST be able to inspect pattern details — configuration settings organized by chunking, embedding, retrieval, and generation — and Sample Q&A results with per-question scores
- [REQ-023] Learner MUST be able to capture a Responses API code snippet via *View code* (curl, Node.js, Go, or Python) or save the indexing and inference notebooks from the actions menu
- [REQ-024] Learner MUST be able to run the inference notebook in a workbench with attached S3 and OGX data connections and receive answers grounded in their documents

## Success Metrics

Learner completes both exercises: a pattern selected from leaderboard scores and
Sample Q&A results with a snippet or notebooks captured, and the inference
notebook returning grounded answers (optionally preceded by an error-free
indexing notebook run).

## Risks

- Mean scores alone can mislead — low context correctness with high answer correctness indicates a pattern that may not generalize
- Most notebook failures at this step are a mismatched S3 bucket or OGX connection rather than a pattern problem
- *Inject credentials* snippets embed the OGX hostname and API key and must be treated as secrets

## Assumptions

- Learner has a completed optimization run from Module 01 and the notebooks or snippet captured from its leaderboard
- A running workbench exists in the learner's project

## Related Requirements

- RHAIBU-M33F08DZCEWR

## Verified By

- features/feature-store-automl-autorag/autorag/content/modules/ROOT/pages/module-02-hands-on.adoc
