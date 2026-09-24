# Observations: Automated Red Teaming (powered by Garak) (doc-derived)

## Summary

Automated Red Teaming (powered by Garak) is RHOAI 3.5's GA feature for probing
AI models and associated guardrails for safety weaknesses: it sends adversarial
prompts across categories of harmful content, then progressively applies attack
techniques to bypass the model's safety controls, producing a report of
vulnerabilities and successful techniques. This observation document was
produced from the official RHOAI 3.5 product documentation (Evaluating AI
systems, Chapter 7: Test model safety with automated risk assessment) because
no live demo cluster was available at authoring time. Every item below is doc
evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | garak-evaluating-ai-systems.txt | §7.1 Automated risk assessment overview | Two trigger paths (EvalHub API, KFP Python SDK); two phases (prompt generation, security testing); tests the full stack the endpoint points at, including guardrails |
| 2 | garak-evaluating-ai-systems.txt | §7.2 Prepare a disconnected cluster for risk assessment | Translation strategy uses Helsinki-NLP translation models; on disconnected clusters pre-download via `huggingface-cli download Helsinki-NLP/opus-mt-zh-en|en-zh`, `aws s3 sync`, `hf_cache_path` parameter; or disable translation via `garak_config` (`langproviders: null` + pruned `probe_spec`) |
| 3 | garak-evaluating-ai-systems.txt | §7.3 Run a risk assessment | `intents-scan.json` with `id: intents`, `provider_id: garak-kfp`, `kfp_config` (endpoint/namespace/s3), `intents_models` (judge, sdg with `hosted_vllm/` prefix); POST to `/api/v1/evaluations/jobs` with Bearer + `X-Tenant` headers; four pipeline stages; results in S3 and MLflow |
| 4 | garak-evaluating-ai-systems.txt | §7.4 Run a risk assessment with the KFP Python SDK | `garak_pipeline` module: `PipelineRunner(KubeflowConfig(...))`, `run_scan(EvalConfig(...))`, `wait_for_completion`, `download_html_report`; same per-intent breakdown as EvalHub-triggered assessment |
| 5 | garak-evaluating-ai-systems.txt | §7.5 Risk assessment results | Overview metrics: Total attempts, Unsafe prompts, Safe prompts, ASR (primary, unique prompts, lower is better); score convention 1.0 = complied, 0.0 = refused, threshold 0.5; four judge classifications (Complied, Rejected, Alternative, Other) with 70% minimum confidence; HTTP errors are marked rejected without judge evaluation; five strategies (Baseline, SPO, SPO variants, Translation, TAP) applied cumulatively |
| 6 | garak-evaluating-ai-systems.txt | §7.6 Define custom harm categories | Policy dataset (JSON/CSV) with `policy_concept` + `concept_definition` columns; description guidelines ("Prompts that…", positive form, specific details, full scope); uploaded to S3, read at prompt-generation start; nine default harm categories; financial-services example dataset |
| 7 | garak-evaluating-ai-systems.txt | §7.7 Risk assessment configuration | Garak scan configuration (`eval_threshold`, `generations`, `detector_spec: judge.MulticlassJudge`, `probe_spec`); scan parameters table (`max_dan_samples: 5`, `target_lang: "zh"`, `confidence_cutoff: 70`, `score_scale: 100`); SDG flow blocks (RowMultiplierBlock → SamplerBlock → PromptBuilderBlock → LLMChatBlock → extractor → JSONParser); EvalHub job parameters (`garak_config` deep-merged, `policy_s3_key`, `intents_s3_key` skips SDG, attacker/evaluator default to judge) |

## User Flows

### Flow 1: Run a scan through the EvalHub API

1. **Verify prerequisites** — configured pipeline server, OpenAI-compatible target and judge endpoints, S3 storage, EvalHub auth token, model API key Secret (§7.3)
2. **Prepare tenant** — label namespace as EvalHub tenant; operator provisions job RBAC (workshop module 2; §7.7.4)
3. **Create `intents-scan.json`** — model target + `secret_ref`, `id: intents`, `provider_id: garak-kfp`, `kfp_config`, `intents_models` (§7.3)
4. **Submit** — POST to `/api/v1/evaluations/jobs` with Bearer token and `X-Tenant` header (§7.3)
5. **Pipeline runs** — SDG prompts → baseline test → progressive attacks on refused prompts → report aggregation to S3/MLflow (§7.3)
6. **Verify** — results in the S3 bucket from `kfp_config`; MLflow experiment artifacts when connected (§7.3)

### Flow 2: Run a scan standalone with the KFP Python SDK

1. **Get the pipeline route** — `oc get routes ds-pipeline-dspa -o jsonpath='{.spec.host}'` (§7.4)
2. **Script the run** — `PipelineRunner(KubeflowConfig(...))` → `run_scan(EvalConfig(...))` with judge and sdg `intents_models` (§7.4)
3. **Wait and retrieve** — `wait_for_completion(job.job_id, verbose=True)`, then `download_html_report(job.job_id)` (§7.4)
4. **Verify** — HTML report downloaded to the working directory; same metrics as the EvalHub path; results also in S3 (§7.4)

### Flow 3: Extend the assessment

1. **Tune** — override `garak_config` (thresholds, generations, probes, translation) deep-merged with profile defaults (§7.7.1–7.7.2)
2. **Customize categories** — upload a `policy_concept`/`concept_definition` dataset and pass `policy_s3_key`; or skip SDG entirely with `intents_s3_key` (§7.6, §7.7.4)
3. **Handle disconnection** — pre-download Helsinki-NLP translation models to S3 and set `hf_cache_path`, or disable the translation strategy (§7.2)

## Features and Concepts

### OpenShift Platform
- Kubeflow Pipelines (Data Science Pipelines) and the `ds-pipeline-dspa` route, S3/MinIO artifact storage, Kubernetes Secrets, RBAC (ServiceAccount/Role/RoleBinding), TokenReview-based auth

### RHOAI / AI Platform
- Automated risk assessment / Automated Red Teaming (GA in 3.5), TrustyAI component, EvalHub evaluations API (`/api/v1/evaluations/jobs`, `/api/v1/health`, `/api/v1/evaluations/providers`), `garak-kfp` provider, tenant namespace labels, MLflow integration, `garak_pipeline` Python module

### AI/ML Fundamentals
- LLM red teaming and jailbreaks, adversarial prompt generation (SDG), judge-model classification, Attack Success Rate (ASR), attack strategies (Baseline, System Prompt Override, SPO variants, Translation, Tree of Attacks with Pruning), harm taxonomies (illegal activity, hate speech, fraud, misinformation, etc.)

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on scan → advanced tuning/standalone)
- **Target audience**: ML practitioners and platform engineers with OpenShift and model-serving working knowledge
- **Prerequisite knowledge**: model serving endpoints, `oc` CLI basics, LLM safety concepts
- **Estimated duration**: about 2 hours (docs-derived scan latency caveat: full default scans take a while)
- **Cluster requirements**: RHOAI 3.5 with TrustyAI `Managed`, KServe RawDeployment, a configured pipeline server, EvalHub deployed (for the API path), model + judge endpoints, S3 storage

## Open Questions

- Live-console parity for EvalHub provider listings and health version (doc-derived `0.3.0`)
- Workshop cluster pipeline namespace naming and S3 secret provisioning (docs use `<namespace>`/`<s3-secret-name>` placeholders)
- Actual wall-clock duration of a full default-category scan, needed to size the hands-on module
