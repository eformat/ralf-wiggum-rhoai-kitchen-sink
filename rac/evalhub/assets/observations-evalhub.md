# Observations: Evaluation Stack (EvalHub) (doc-derived)

## Summary

Evaluation Stack (EvalHub) is RHOAI 3.5's GA evaluation orchestration service
for large language models on OpenShift: a versioned REST API for submitting
evaluation jobs against standardized benchmarks, with results tracked through
MLflow across multiple tenants. This observation document was produced from the
official RHOAI 3.5 product documentation (Evaluating AI systems — Chapter 1
Evaluation of AI systems, Chapter 2 Evaluate LLMs with EvalHub, Chapter 3
Evaluate your system by using the OpenShift AI dashboard) because no live demo
cluster was available at authoring time. Every item below is doc evidence, not
UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | garak-evaluating-ai-systems.txt | Ch.1 Evaluation of AI systems | TrustyAI evaluation tools landscape: EvalHub (automate/standardize/scale LLM evaluation across frameworks), LM-Eval (deprecated from 3.5), RAGAS, OGX |
| 2 | garak-evaluating-ai-systems.txt | §2.1 Evaluation orchestration service | Three components (Server with PostgreSQL storage, SDK/CLI, Providers as container images); core concepts: providers, benchmarks, collections, thresholds (benchmark > collection > provider), evaluation jobs with six states, FrameworkAdapter interface, UBI9 adapter images |
| 3 | garak-evaluating-ai-systems.txt | §2.2 Architecture overview | Job workflow: submit via REST/SDK/CLI → validate + persist `pending` → one Kubernetes Job per benchmark with adapter + sidecar proxy containers → results aggregated → MLflow logging |
| 4 | garak-evaluating-ai-systems.txt | §2.3 Deploy with the TrustyAI Operator | EvalHub CR (trustyai.opendatahub.io/v1) with database secret, providers, collections, MLFLOW_TRACKING_URI env; prerequisite: TrustyAI `Managed` + KServe `RawDeployment`; verification: `eval-hub` pod Running, health endpoint `{"status": "healthy"}` |
| 5 | garak-evaluating-ai-systems.txt | §2.4–2.5 SDK/CLI + local mode | `pip install "eval-hub-sdk[cli]"`; `evalhub config set base_url/tenant/token`; local mode runs the same REST API on a workstation with host subprocesses, no sidecar/init/Kueue |
| 6 | garak-evaluating-ai-systems.txt | §2.7 Multi-tenancy | Every API request except `/api/v1/health` carries `X-Tenant` header; CLI stores connection profiles at `~/.config/evalhub/config.yaml` |
| 7 | garak-evaluating-ai-systems.txt | §2.9–2.11 Providers, jobs, results | `evalhub providers list` / `describe` (lm_evaluation_harness 167 benchmarks, garak 12, guidellm 4); job submission returns 202 with job ID; status transitions `pending` → `running` → `completed`; results include per-benchmark metrics (`acc`, `acc_norm`) and a `test` pass/fail field when thresholds set |
| 8 | garak-evaluating-ai-systems.txt | §2.12–2.14 Cancel/delete, collections | Soft delete marks `cancelled` (record preserved); `--hard` removes permanently (404 after); built-in collections (`leaderboardv2`, `safety-and-fairness-v1`, `toxicity-and-ethicalprinciples`) map to dashboard suites; custom collections from YAML spec with `evalhub collections create --file` |
| 9 | garak-evaluating-ai-systems.txt | §2.20 MLflow tracking | Experiment block in job submission; results include `mlflow_experiment_url`; CLI displays the URL in `evalhub eval results` |
| 10 | garak-evaluating-ai-systems.txt | §2.27–2.30 Multi-tenancy and RBAC | TokenReview authentication, SubjectAccessReview on virtual resources (`evaluations`, `collections`, `providers`, `status-events`) under `trustyai.opendatahub.io`; tenant label `evalhub.trustyai.opendatahub.io/tenant=` auto-provisions ServiceAccount, Roles, RoleBindings, service CA ConfigMap; Role + RoleBinding grant user access, verified with `oc auth can-i --as` |
| 11 | garak-evaluating-ai-systems.txt | Ch.3 Dashboard evaluation | `Develop & train → Evaluations → Start evaluation run`; benchmark suites correspond to EvalHub collections; threshold slider 0–100 equivalent to API 0.0–1.0; comparison view (embedded MLflow) shows aligned parameters/metrics but no score direction, thresholds, suite grouping, or export |

## User Flows

### Flow 1: Submit an evaluation job from the CLI

1. **Verify the deployment** — TrustyAI `Managed`, `eval-hub` pod Running, health endpoint healthy (§2.3)
2. **Install and configure the CLI** — `pip install "eval-hub-sdk[cli]"`, `evalhub config set base_url/tenant/token`, `evalhub health` (§2.4)
3. **Discover providers** — `evalhub providers list`, `evalhub providers describe lm_evaluation_harness` (§2.9)
4. **Submit the job** — `evalhub eval run` with model URL and benchmarks, or `POST /api/v1/evaluations/jobs` with `X-Tenant` header (§2.10)
5. **Track to results** — `evalhub eval status --watch`, `evalhub eval results --format table` (§2.11)

### Flow 2: Submit from the dashboard and compare

1. **Prerequisites** — TrustyAI enabled, MLflow tracking configured, MLflow federated plugin, Evaluations page enabled (Ch.3 §3.1)
2. **Start evaluation run** — `Develop & train → Evaluations`, select benchmarks or suites, set name/MLflow experiment/source/threshold (§3.2)
3. **Verify** — Status column Running → Completed; click name for scores and pass/fail (§3.2)
4. **Compare runs** — select completed runs, Compare, Choose Benchmarks for suites, review aligned parameters and metrics (§3.3)

### Flow 3: Reusable suites and tenant access

1. **Create a collection** — YAML spec with provider/benchmark IDs, `evalhub collections create --file` (§2.14)
2. **Run against the collection** — job references `collection.id` (§2.14)
3. **Log to MLflow** — `experiment` block in submission; results include `mlflow_experiment_url` (§2.20)
4. **Grant tenant access** — tenant label auto-provisions resources; Role + RoleBinding on virtual resources; verify with `oc auth can-i` (§2.28–2.29)

## Features and Concepts

### OpenShift Platform
- Kubernetes Jobs per benchmark, ServiceAccount tokens, TokenReview, SubjectAccessReview, RBAC (Role/RoleBinding), ConfigMaps, routes, namespace labels

### RHOAI / AI Platform
- EvalHub CR deployed by the TrustyAI Operator (TrustyAI component `Managed`, KServe `RawDeployment`), virtual resources under `trustyai.opendatahub.io`, tenant namespace auto-provisioning, built-in read-only providers and collections, MLflow and OCI registry sidecar proxying, optional Kueue queue routing (Technology Preview), local mode with `runtime.local`

### AI/ML Fundamentals
- Standardized LLM benchmarks (mmlu, hellaswag, gsm8k), benchmark categories (math, reasoning, safety, code), metrics and primary score (`acc_norm`, `lower_is_better`), pass criteria and weighted threshold levels, artifact-agnostic comparison (models, RAG pipelines, agentic systems, prompt templates)

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: RHOAI operator with TrustyAI `Managed` + KServe `RawDeployment`, model serving endpoint with OpenAI-compatible `/v1` API, `oc` CLI basics, Python 3.11+
- **Estimated duration**: about 2 hours
- **Cluster requirements**: EvalHub pre-deployed (dedicated namespace), working project registered as tenant, MLflow tracking configured for the comparison exercise

## Open Questions

- Confirm the dashboard `Develop & train → Evaluations` menu label and threshold slider behavior on a live 3.5 console (doc-derived)
- MLflow federated plugin availability on the workshop dashboard (module 03 comparison prerequisite)
- Model URL format expected by each provider varies — confirm against a live deployment before Act-phase testing
