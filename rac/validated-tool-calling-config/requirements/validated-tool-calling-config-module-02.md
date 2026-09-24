---
schema_version: 1
id: RHAIBU-M33EB4FVJT4E
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must validate a model's tool-calling accuracy end to end: generate
evaluation benchmarks from their own MCP servers with the SDG Hub evaluation
pipeline, then score candidate models against those benchmarks. This is the
core deliverable of the workshop: verified benchmark data and ranked candidate
models before production deployment.

## Requirements

- [REQ-021] Learner MUST be able to configure the `MCP_SERVERS`, `AGENT_URLS`, `SERVER_DESCRIPTIONS`, and `NUM_SAMPLES_LEVELS` dictionaries in `generate.ipynb` and run the four-stage pipeline (exploration, question generation, ground truth, quality validation)
- [REQ-022] Learner MUST be able to verify `benchmark_tasks.jsonl` contains one line per generated task and each record contains the `server`, `question`, `expert_answer`, `expert_tools`, `expert_tool_trace`, `question_quality_rating`, and `completeness_rating` fields
- [REQ-023] Learner MUST be able to configure `MODEL_CONFIGS` in `evaluate.ipynb`, run the evaluation, and confirm every configured model has a non-zero count in `evaluation_results.jsonl`
- [REQ-024] Learner MUST be able to check `ZERO_JUDGE` and `ZERO_METRICS` failure indicators and interpret the four trace metrics (`tool_recall`, `tool_precision`, `order_match`, `param_match`)

## Success Metrics

`benchmark_tasks.jsonl` verifies with well-formed records per server; every
configured model has a non-zero score count in `evaluation_results.jsonl`; the
learner can name what a low score on each trace metric indicates.

## Risks

- The evaluation pipeline actively invokes tools on MCP servers — side effects can modify data or system state
- Requires accessible MCP servers (default ports 8001–8006) and LangGraph agents (ports 2024–2029)
- Forced re-evaluation (deleting the results cache) costs additional LLM inference time and money

## Assumptions

- Learner has completed Module 01 (feature enabled, validated arguments located)
- SDG Hub is installed and an OpenAI API-compatible frontier LLM endpoint with API key is available

## Related Requirements

- RHAIBU-M33EB4F3BPFR

## Verified By

- features/agents-mcp/validated-tool-calling-config/content/modules/ROOT/pages/module-02-hands-on.adoc
