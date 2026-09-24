# Observations: Validated tool-calling configuration in Model Catalog (doc-derived)

## Summary

Validated tool-calling configuration in Model Catalog is a RHOAI 3.5 Technology
Preview that surfaces Red Hat-validated vLLM deployment arguments for models
with confirmed tool-calling support, so a model can be run with tool calling
enabled on the first attempt without guessing runtime arguments. It is paired
with an automated SDG Hub MCP evaluation pipeline that generates tool-calling
benchmark data from custom MCP servers. This observation document was produced
from the official RHOAI 3.5 product documentation (release notes; Customize
Models for Gen AI and Agentic AI Applications; Working with the model catalog)
because no live demo cluster was available at authoring time. Every item below
is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §Validated tool-calling configuration for models in the model catalog | Catalog displays validated vLLM deployment arguments for models with confirmed tool-calling support; Validated Arguments section on the Model Details page with a Tool Calling panel (`--tool-call-parser`, `--reasoning-parser`, `--chat-template`, `--enable-auto-tool-choice`); Validated Arguments filter; enabled via `spec.dashboardConfig.toolCalling` in the `OdhDashboardConfig` CR |
| 2 | validated-tooling-customize-models.txt | §5.1 MCP evaluation benchmark pipeline | SDG Hub evaluation pipeline, four stages: MCP exploration, question generation, ground truth generation, quality validation; produces verified question-answer-tool-call triplets; `num_samples` controls tools per scenario (2 simple / 4 moderate / 8 complex tool-chaining) |
| 3 | validated-tooling-customize-models.txt | §5.1.2 Agent architecture and model swapping | Same LangGraph agent for data generation and evaluation; underlying LLM swapped to the candidate via the LangGraph configurable parameter while tools, guardrails, and orchestration stay identical — scores reflect the candidate's tool-calling accuracy in isolation |
| 4 | validated-tooling-customize-models.txt | §5.2.1 Active tool invocation risks | Pipeline actively calls tools (not just reading schemas); side-effect risks include DB writes, notification triggers, infrastructure changes, financial transactions; run against development/staging servers first |
| 5 | validated-tooling-customize-models.txt | §5.7.3–5.7.6 Output format and scoring | Four programmatic trace metrics (tool_recall, tool_precision, order_match, param_match) + six LLM-as-judge dimensions (task fulfillment, grounding, tool appropriateness, parameter accuracy, dependency awareness, parallelism and efficiency); `ZERO_JUDGE`/`ZERO_METRICS` failure constants; results cached in `evaluation_results.jsonl`, cache invalidated when `benchmark_tasks.jsonl` changes |
| 6 | ai-available-assets-release-notes.txt | §Adversarial vulnerability scanning for Red Hat-validated models | New models in the Red Hat AI validated models catalog undergo automated adversarial vulnerability scanning (garak, run via EvalHub); vulnerability scores published alongside accuracy and performance data |
| 7 | validated-tooling-model-catalog.txt | §Working with the model catalog | Catalog categories (Red Hat AI validated models: third-party models benchmarked by Red Hat); for validated models the Model details section includes Minimum vRAM and Container size; Performance insights tab compares hardware configurations |

## User Flows

### Flow 1: Enable the feature and copy validated arguments

1. **Patch the flag** — `oc patch OdhDashboardConfig odh-dashboard-config -n redhat-ods-applications -type=merge -p '{"spec":{"dashboardConfig":{"toolCalling":true}}}'` (release notes §Validated tool-calling configuration)
2. **Verify** — jsonpath prints `true`; dashboard pods running
3. **Browse the catalog** — AI hub → Models → Catalog; use the Validated Arguments filter (release notes)
4. **Copy arguments** — Model Details page → Validated Arguments → Tool Calling panel (release notes)

### Flow 2: Generate benchmarks and evaluate candidates

1. **Start MCP servers and agents** — `start_servers.sh` / `start_agents.sh` with `--check` health verification (§5.4 startup scripts)
2. **Generate benchmarks** — configure `MCP_SERVERS`/`AGENT_URLS`/`SERVER_DESCRIPTIONS`/`NUM_SAMPLES_LEVELS` in `generate.ipynb`; run the four-stage pipeline (§5.1)
3. **Verify ground truth** — `benchmark_tasks.jsonl` records carry `server`, `question`, `expert_answer`, `expert_tools`, `expert_tool_trace`, quality ratings (§5.7.1)
4. **Evaluate** — configure `MODEL_CONFIGS` in `evaluate.ipynb`; per-server scores, six judge dimensions, four trace metrics, composite rankings (§5.7.2–5.7.4)
5. **Rank and deploy** — select the model whose validated arguments were found in Module 01, register and deploy from the catalog

## Features and Concepts

### OpenShift Platform
- `OdhDashboardConfig` cluster-wide CR and its `spec.dashboardConfig` feature flags

### RHOAI / AI Platform
- Model catalog (Red Hat AI validated models category, Validated Arguments section/filter, Performance insights), tool-calling accuracy validation on custom MCP tools, SDG Hub MCP evaluation pipeline, Adversarial vulnerability scanning (garak/EvalHub)

### AI/ML Fundamentals
- vLLM tool-calling runtime arguments (tool-call parser, reasoning parser, chat template, auto tool choice), LLM-as-judge scoring, programmatic trace metrics, tool chaining

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: model catalog basics, `oc` CLI basics; cluster admin for the flag patch
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with the model catalog accessible and model registry component enabled; Module 02 needs development/staging MCP servers and an OpenAI API-compatible frontier LLM endpoint

## Open Questions

- Exact Validated Arguments section / Tool Calling panel labels on a live 3.5 console (doc-derived; Technology Preview)
- Default MCP server/agent port ranges in the `sdg_hub` example repo (doc-derived from `start_servers.sh`/`start_agents.sh` behavior)
