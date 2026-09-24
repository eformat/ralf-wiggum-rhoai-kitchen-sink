# Observations: Automated Tool-calling Evaluation for Custom MCP Servers (doc-derived)

## Summary

Automated tool-calling evaluation-data generation for custom MCP servers is
RHOAI 3.5's GA path for letting AI coding agents discover evaluation providers,
submit jobs, and interpret results on OpenShift AI through the EvalHub MCP
server. This observation document was produced from the official RHOAI 3.5
product documentation (Evaluating AI systems — Use EvalHub with AI coding
agents, Generate and use evaluation cards; AI Hub MCP Catalog) because no live
demo cluster was available at authoring time. Every item below is doc evidence,
not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | automated-tool-calling-eval-evaluating-ai-systems.txt | §4.1 EvalHub MCP server overview | MCP server connects AI coding agents (Claude Code, VS Code with GitHub Copilot, Cursor) to EvalHub; four capability types: tools, resources (`evalhub://` URIs), prompts, agent skills; distributed as standalone binary and container image managed by the TrustyAI Operator |
| 2 | automated-tool-calling-eval-evaluating-ai-systems.txt | §4.1.2 Transport modes | `stdio` (JSON-RPC over stdin/stdout, local child process) and `http` (Streamable HTTP, remote or shared server) with a `GET /health` endpoint |
| 3 | automated-tool-calling-eval-evaluating-ai-systems.txt | §4.1.3 Typical workflow | Deploy MCP server → discover providers (`discover_providers`) → submit evaluation (`submit_evaluation`) → monitor (`get_job_status`) → compare runs (`compare_runs` prompt) |
| 4 | automated-tool-calling-eval-evaluating-ai-systems.txt | §4.2 Agent-discoverable evaluations | Structured agent metadata on providers, benchmarks, collections; optional and backwards-compatible; three-step agent workflow: discover (`evaluates` tags, `recommended_when`), execute (`hints`), interpret (`result_interpretation`, `score_ranges`) |
| 5 | automated-tool-calling-eval-evaluating-ai-systems.txt | §4.3 Deploy the EvalHub MCP server | `spec.mcp` block (`enabled: true`, `transport: http`, `port: 3001`) on the EvalHub CR; `oc expose service evalhub-mcp --port=3001`; Claude Code registration with `Authorization: Bearer` + `x-tenant` headers; verification via pod container readiness jsonpath |
| 6 | automated-tool-calling-eval-evaluating-ai-systems.txt | §4.4 Install the agent skills plugin | Four skills (`evalhub`, `evalhub-discovery`, `evalhub-eval`, `evalhub-jobs`); `claude plugin install evalhub@evalhub` or symlinked local dev clone (`make install-all`); verification via `evalhub_providers.py --agent` JSON; skills prefer MCP resources when both are connected |
| 7 | automated-tool-calling-eval-evaluating-ai-systems.txt | §4.5–4.9 Tools, prompts, metadata reference | Tools: `discover_providers`, `submit_evaluation`, `get_job_status`, `cancel_job`; prompts: `evaluate_model`, `compare_runs`, `edd_workflow`; agent metadata fields at provider, benchmark, and collection levels |
| 8 | automated-tool-calling-eval-evaluating-ai-systems.txt | §5.1–5.3 Evaluation cards | Card generated only when the job request includes an MLflow experiment or OCI export configuration; one card per job as a post-processing step; addresses reproducibility, accessibility, governance (EU AI Act, FedRAMP); retrieved via `.artifacts` |
| 9 | automated-tool-calling-eval-evaluating-ai-systems.txt | §2.11 Job states | Evaluation jobs progress through `pending`, `running`, `completed`, `failed`, `cancelled`, `partially_failed` |
| 10 | automated-tool-calling-eval-mcp-catalog.txt | §2.1–2.2 MCP Lifecycle Operator | Adjacent context: the MCP Lifecycle Operator and AI Hub MCP Catalog deploy MCP servers from the dashboard; distinct from the EvalHub MCP server which rides on the TrustyAI Operator's EvalHub CR |

## User Flows

### Flow 1: Deploy the EvalHub MCP server and connect an agent

1. **Deploy EvalHub** — TrustyAI Operator reconciles the `EvalHub` custom resource (§2.3, doc §4.3)
2. **Enable MCP** — add `spec.mcp` (`enabled: true`, `transport: http`, `port: 3001`) to the CR (§4.3)
3. **Expose** — `oc expose service evalhub-mcp --port=3001`, capture `$MCP_URL` (§4.3)
4. **Register** — `claude mcp add evalhub --transport http $MCP_URL` with `Authorization: Bearer` and `x-tenant` headers; `oc create token` for the ServiceAccount (§4.3)
5. **Verify** — pod readiness jsonpath shows `mcp=true`; the agent returns registered providers (§4.3)

### Flow 2: Generate evaluation data through tool calls

1. **Discover** — "What providers can evaluate my model for safety?" → `discover_providers` filtered by target type and capability tags (§4.2.1)
2. **Execute** — "Run a quick safety scan on my model at http://vllm:8000/v1" → `submit_evaluation` reading the provider's `hints` (§4.1.3)
3. **Monitor** — `get_job_status` repeatedly; response includes job state, `progress_percent`, per-benchmark status, then `result_interpretation` and `complements` (§4.6.3)
4. **Validate** — `evalhub eval results <job_id> --format table` from the CLI; both read the same job store (doc §2.10–2.11)

### Flow 3: Make a custom provider agent-discoverable

1. **Add agent metadata** — `agent` block with `evaluates`, `recommended_when`, `target_type`, `summary`, `complements`, `hints`, `result_interpretation` (§4.5)
2. **Update** — PATCH `/api/v1/evaluations/providers/{id}` for already-registered providers (§4.5, §2.25.2)
3. **Verify** — GET the provider shows the `agent` object; the provider appears in `evalhub_providers.py --agent` discovery results (§4.4, §4.9)

### Flow 4: Generate an evaluation card

1. **Include configuration** — MLflow `experiment` block (or OCI export) in the job submission (§5.1.1)
2. **Post-process** — EvalHub generates one card per job after committing results (§5.1.1)
3. **Retrieve** — `evalhub eval status <job_id> --format=json | jq '.artifacts'`; card carries `generated_at`, `generator`, `evaluation_context`, per-benchmark results with thresholds (§5.3)

## Features and Concepts

### OpenShift Platform
- Namespaces, routes (`evalhub`, `evalhub-mcp`), ServiceAccounts and tokens (`oc create token`, `oc whoami -t`), RBAC via tenant namespaces

### RHOAI / AI Platform
- EvalHub CR managed by the TrustyAI Operator, `spec.mcp` block, MCP server container beside the EvalHub server, agents-and-MCP catalog surfaces, MLflow results tracking, Kueue job routing

### AI/ML Fundamentals
- Evaluation frameworks (lm_evaluation_harness, garak, guidellm, lighteval), benchmarks (`mmlu`, `hellaswag`, `gsm8k`, `quick`), pass criteria and thresholds resolved most-specific-first with weighted averages, evaluation-driven development (EDD)

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: ML practitioners and platform engineers with OpenShift working knowledge
- **Prerequisite knowledge**: RHOAI operator installed, MCP server deployed, an MCP client such as Claude Code installed
- **Estimated duration**: about 2 hours
- **Cluster requirements**: TrustyAI component `Managed` with EvalHub deployed, PostgreSQL connection Secret, reachable model endpoint

## Open Questions

- Exact MCP client registration UX (headers, token refresh) on a live console (doc-derived)
- Whether a workshop cluster pre-provisions a vLLM-style model endpoint for `submit_evaluation` targets
- CLI rendering of `partially_failed` jobs and per-benchmark status in table format (doc-derived schema only)
