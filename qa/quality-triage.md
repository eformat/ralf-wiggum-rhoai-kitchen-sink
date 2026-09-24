# Quality Triage — ralf-wiggum-rhoai-kitchen-sink

Phase 0 triage (`--dry-run --all`) per the `quality-enrichment` skill.
Analysis only — no workshop content, `feature-matrix.yml`, `rac/`, or pages were modified.

- RHOAI version: 3.5
- Total enriched workshops: **54**
- Scored > 0 (need processing): **54**
- Score == 0 (skip — idempotent): 0
- Recommended processing order: single-workshop sessions, **highest score first** (sorted below).
- Enrichment source repos: all 8 present; `decided` 0.27.0, `rg` 15.2.0 available.
- Live cluster: `oc` authenticated (`admin`) — available for live testing later, but this run is dry-run.

Scoring: TODO markers +3 · broken heredoc/YAML outside source block +3 · broken image refs +3 · zero screenshots +2 · placeholders in execute blocks +2 · vague verify +1 · no YAML callouts +1 · missing module summaries +1 · missing exercise transitions +1 (binary per signal). Max 17.

## Triage table (worst first)

| Slug | Category | Maturity | Score | Top Issues |
|------|----------|----------|-------|------------|
| model-registry-catalog | model-registry | GA | 11 | TODO markers, broken image refs, no screenshots, placeholders, missing transitions |
| genai-studio-saved-agent | agents-mcp | DP | 9 | TODO markers, broken image refs, no screenshots, missing transitions |
| kale-jupyterlab | agents-mcp | DP | 9 | TODO markers, broken image refs, no screenshots, missing transitions |
| mcp-catalog-support-tier | agents-mcp | TP | 9 | TODO markers, broken heredocs, placeholders, missing transitions |
| kueue | distributed-training | GA | 9 | TODO markers, broken image refs, placeholders, missing transitions |
| mlflow-experiment-tracking | mlops | GA | 8 | broken heredocs, no screenshots, placeholders, missing transitions |
| llmd-core | model-serving | GA | 8 | broken heredocs, no screenshots, placeholders, missing transitions |
| csv-export-model-catalog | agents-mcp | DP | 6 | TODO markers, placeholders, missing transitions |
| ogx-agentic-api | agents-mcp | TP | 6 | TODO markers, placeholders, missing transitions |
| validated-tool-calling-config | agents-mcp | TP | 6 | TODO markers, placeholders, missing transitions |
| kubeflow-trainer-v2 | distributed-training | GA | 6 | TODO markers, placeholders, missing transitions |
| evalhub | evaluation | GA | 6 | no screenshots, placeholders, missing transitions, no YAML callouts |
| maas-llmd-deployment | maas | TP | 6 | TODO markers, placeholders, missing transitions |
| maas-multi-provider-passthrough | maas | TP | 6 | TODO markers, placeholders, missing transitions |
| maas-multi-tenancy | maas | TP | 6 | no screenshots, placeholders, missing transitions, no YAML callouts |
| llminferenceservice-config | model-serving | GA | 6 | no screenshots, placeholders, missing transitions, no YAML callouts |
| rhai-fast-release-images | model-serving | GA | 6 | TODO markers, placeholders, missing transitions |
| vllm-cpu-ibm-z-power | model-serving | GA | 6 | TODO markers, placeholders, missing transitions |
| llama-stack-ogx-core | ogx | GA | 6 | TODO markers, placeholders, missing transitions |
| platform-oidc-auth | platform-gateway | GA | 6 | TODO markers, placeholders, missing transitions |
| automated-tool-calling-eval | agents-mcp | GA | 5 | no screenshots, placeholders, missing transitions |
| external-metering-maas | agents-mcp | DP | 5 | no screenshots, placeholders, missing transitions |
| llmd-kv-cache-tiering | agents-mcp | DP | 5 | no screenshots, placeholders, missing transitions |
| llmd-latency-routing | agents-mcp | DP | 5 | no screenshots, placeholders, missing transitions |
| llmd-lora-routing | agents-mcp | DP | 5 | no screenshots, placeholders, missing transitions |
| mcp-lifecycle-operator | agents-mcp | TP | 5 | no screenshots, placeholders, missing transitions |
| ogx-file-processors | agents-mcp | DP | 5 | no screenshots, placeholders, missing transitions |
| ogx-remote-providers | agents-mcp | DP | 5 | no screenshots, placeholders, missing transitions |
| automated-red-teaming-garak | evaluation | GA | 5 | no screenshots, placeholders, missing transitions |
| nemo-guardrails-mcp-gateway | guardrails | TP | 5 | no screenshots, placeholders, missing transitions |
| maas-oidc-auth | maas | GA | 5 | no screenshots, placeholders, missing transitions |
| llmd-priority-flow-control | model-serving | GA | 5 | no screenshots, placeholders, missing transitions |
| vllm-serving-runtime-kserve | model-serving | GA | 5 | no screenshots, placeholders, missing transitions |
| gateway-api-rhcl | platform-gateway | GA | 5 | no screenshots, placeholders, missing transitions |
| ai-available-assets | agents-mcp | GA | 4 | TODO markers, missing transitions |
| mcp-catalog-admin | agents-mcp | DP | 4 | TODO markers, missing transitions |
| openshell-agent-sandboxing | agents-mcp | DP | 4 | TODO markers, missing transitions |
| view-agent-deployments | agents-mcp | DP | 4 | TODO markers, missing transitions |
| kuberay | distributed-training | GA | 4 | no screenshots, missing transitions, vague verify |
| automl | feature-store-automl-autorag | TP | 4 | TODO markers, missing transitions |
| autorag | feature-store-automl-autorag | TP | 4 | TODO markers, missing transitions |
| feature-store-feast | feature-store-automl-autorag | GA | 4 | TODO markers, missing transitions |
| maas-core | maas | GA | 4 | TODO markers, missing transitions |
| maas-loki-showback | maas | TP | 4 | TODO markers, missing transitions |
| maas-vllm-deployment | maas | TP | 4 | TODO markers, missing transitions |
| agent-catalog-ai-hub | agents-mcp | DP | 3 | no screenshots, missing transitions |
| claude-code-starter-kit | agents-mcp | DP | 3 | no screenshots, missing transitions |
| external-metering-per-user | agents-mcp | DP | 3 | no screenshots, missing transitions |
| mcp-gateway-operator | agents-mcp | TP | 3 | no screenshots, missing transitions |
| midojo-adversarial-testing | agents-mcp | DP | 3 | no screenshots, missing transitions |
| openclaw-starter-kit | agents-mcp | DP | 3 | no screenshots, missing transitions |
| opencode-coding-agent | agents-mcp | TP | 3 | no screenshots, missing transitions |
| text-mode-multimodal-training | agents-mcp | DP | 3 | no screenshots, missing transitions |
| nemo-guardrails | guardrails | GA | 2 | missing transitions, no YAML callouts |

## GPU-dependent workshops (content-only fixes now; live tests deferred as observe-only)

Detected via `llmd-*`, `maas-llmd-deployment`, `vllm-cuda`/vLLM GPU paths, distributed-training GPU exercises, and `nvidia.com/gpu`/CUDA markers in content:

- **kueue** (distributed-training, GA, score 9) — content-only fixes now; live tests deferred as observe-only.
- **llmd-core** (model-serving, GA, score 8) — content-only fixes now; live tests deferred as observe-only.
- **kubeflow-trainer-v2** (distributed-training, GA, score 6) — content-only fixes now; live tests deferred as observe-only.
- **evalhub** (evaluation, GA, score 6) — content-only fixes now; live tests deferred as observe-only.
- **maas-llmd-deployment** (maas, TP, score 6) — content-only fixes now; live tests deferred as observe-only.
- **llminferenceservice-config** (model-serving, GA, score 6) — content-only fixes now; live tests deferred as observe-only.
- **rhai-fast-release-images** (model-serving, GA, score 6) — content-only fixes now; live tests deferred as observe-only.
- **llmd-kv-cache-tiering** (agents-mcp, DP, score 5) — content-only fixes now; live tests deferred as observe-only.
- **llmd-latency-routing** (agents-mcp, DP, score 5) — content-only fixes now; live tests deferred as observe-only.
- **llmd-lora-routing** (agents-mcp, DP, score 5) — content-only fixes now; live tests deferred as observe-only.
- **llmd-priority-flow-control** (model-serving, GA, score 5) — content-only fixes now; live tests deferred as observe-only.
- **vllm-serving-runtime-kserve** (model-serving, GA, score 5) — content-only fixes now; live tests deferred as observe-only.
- **kuberay** (distributed-training, GA, score 4) — content-only fixes now; live tests deferred as observe-only.
- **maas-vllm-deployment** (maas, TP, score 4) — content-only fixes now; live tests deferred as observe-only.
- **text-mode-multimodal-training** (agents-mcp, DP, score 3) — content-only fixes now; live tests deferred as observe-only.

## Signal detail (workshops with score > 0)

### model-registry-catalog (model-registry) — score 11

- TODO markers: 2 occurrence(s)
- Broken image refs (2 of 2): 02-register-model-dialog.png (module-02-hands-on.adoc); 03-model-transfer-jobs.png (module-03-advanced.adoc)
- Placeholder tokens in source blocks: 1 (<job-resource-name>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3), module-03-advanced.adoc (ex 4)

### genai-studio-saved-agent (agents-mcp) — score 9

- TODO markers: 1 occurrence(s)
- Broken image refs (1 of 1): 02-save-agent-dialog.png (module-02-hands-on.adoc)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-01-getting-started.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### kale-jupyterlab (agents-mcp) — score 9

- TODO markers: 1 occurrence(s)
- Broken image refs (1 of 1): 02-kale-enable-toggle.png (module-02-hands-on.adoc)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-01-getting-started.adoc (ex 3), module-02-hands-on.adoc (ex 2)

### mcp-catalog-support-tier (agents-mcp) — score 9

- TODO markers: 1 occurrence(s)
- Broken heredoc/YAML outside block: module-01-hands-on.adoc:148 (manifest YAML outside source block); module-01-hands-on.adoc:164 (manifest YAML outside source block)
- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 4 (<id>, <mcp_server_name>)
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-hands-on.adoc (ex 2), module-01-hands-on.adoc (ex 3)

### kueue (distributed-training) — score 9

- TODO markers: 2 occurrence(s)
- Broken image refs (1 of 2): 02-kueue-alerting-rules.png (module-02-hands-on.adoc)
- Placeholder tokens in source blocks: 1 (<pod-name>)
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### mlflow-experiment-tracking (mlops) — score 8

- Broken heredoc/YAML outside block: module-02-hands-on.adoc:53; module-02-hands-on.adoc:56 (manifest YAML outside source block)
- Placeholder tokens in source blocks: 8 (<experiment_id_1>, <experiment_id_2>, <gateway_hostname>, <your_aws_access_key>, <your_aws_region>, <your_aws_secret_access_key>, <your_bucket>, <your_s3_endpoint>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3)

### llmd-core (model-serving) — score 8

- Broken heredoc/YAML outside block: module-01-concepts.adoc:156 (manifest YAML outside source block)
- Placeholder tokens in source blocks: 6 (<age>, <hash>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-03-advanced.adoc (ex 2)

### csv-export-model-catalog (agents-mcp) — score 6

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 5 (<authorization-header>, <catalog-source>, <count>, <export-script>, <exported-file>)
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-hands-on.adoc (ex 2), module-01-hands-on.adoc (ex 3)

### ogx-agentic-api (agents-mcp) — score 6

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 2 (<dsc-name>, <model-id>)
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-02-hands-on.adoc (ex 4), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3), module-03-advanced.adoc (ex 4)

### validated-tool-calling-config (agents-mcp) — score 6

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 8 (<model_api_key_1>, <model_api_key_2>, <model_endpoint_url_1>, <model_endpoint_url_2>, <model_name>, <model_name_1>, <model_name_2>, <your_api_key>)
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3)

### kubeflow-trainer-v2 (distributed-training) — score 6

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 2 (<job-name>, <pod-name>)
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3)

### evalhub (evaluation) — score 6

- Placeholder tokens in source blocks: 16 (<collection_id>, <job_id>, <model-svc>, <user_name>)
- Zero screenshots in assets/images/ (0 png/jpg)
- [source,yaml] blocks near oc apply lacking callouts: 4
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-02-hands-on.adoc (ex 4), module-02-hands-on.adoc (ex 5), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3), module-03-advanced.adoc (ex 4)

### maas-llmd-deployment (maas) — score 6

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 1 (<your_api_key>)
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3)

### maas-multi-provider-passthrough (maas) — score 6

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 1 (<base64-encoded-api-key>)
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-01-getting-started.adoc (ex 3), module-01-getting-started.adoc (ex 4), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### maas-multi-tenancy (maas) — score 6

- Placeholder tokens in source blocks: 31 (<gateway_name>, <group_name>, <model_namespace>, <tenant_api_key>, <tenant_name>, <username>)
- Zero screenshots in assets/images/ (0 png/jpg)
- [source,yaml] blocks near oc apply lacking callouts: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-03-advanced.adoc (ex 2)

### llminferenceservice-config (model-serving) — score 6

- Placeholder tokens in source blocks: 7 (<epp-pod-name>, <inference-endpoint-url>, <llm-service-name>, <model-name>, <model-uri>)
- Zero screenshots in assets/images/ (0 png/jpg)
- [source,yaml] blocks near oc apply lacking callouts: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3)

### rhai-fast-release-images (model-serving) — score 6

- TODO markers: 2 occurrence(s)
- Image refs: 2, all resolve
- Placeholder tokens in source blocks: 4 (<inference_endpoint_url>, <runtime-name>, <token>)
- Screenshots present: 2
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2)

### vllm-cpu-ibm-z-power (model-serving) — score 6

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 3 (<runtime-name>, <service-account-name>, <token-secret-value>)
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2)

### llama-stack-ogx-core (ogx) — score 6

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 28 (<access_key_id>, <age>, <bucket_name>, <client_secret>, <embedding-endpoint>, <embedding-token>, <keycloak-host>, <pgvector-database>, <pgvector-hostname>, <pgvector-password>, <pgvector-username>, <p)
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 4), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 4)

### platform-oidc-auth (platform-gateway) — score 6

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 5 (<gateway-elb-address>, <your-client-id>, <your-client-secret>, <your-namespace>, <your-realm>)
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-02-hands-on.adoc (ex 4)

### automated-tool-calling-eval (agents-mcp) — score 5

- Placeholder tokens in source blocks: 6 (<job_id>, <provider_id>, <service_account>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-02-hands-on.adoc (ex 4), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3)

### external-metering-maas (agents-mcp) — score 5

- Placeholder tokens in source blocks: 2 (<model_namespace>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2)

### llmd-kv-cache-tiering (agents-mcp) — score 5

- Placeholder tokens in source blocks: 2 (<inference-endpoint-url>, <model-name>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-01-getting-started.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### llmd-latency-routing (agents-mcp) — score 5

- Placeholder tokens in source blocks: 2 (<inference-endpoint-url>, <model-name>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-01-getting-started.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### llmd-lora-routing (agents-mcp) — score 5

- Placeholder tokens in source blocks: 2 (<inference-endpoint-url>, <model-name>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-01-getting-started.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### mcp-lifecycle-operator (agents-mcp) — score 5

- Placeholder tokens in source blocks: 3 (<id>, <service_account_name>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-01-getting-started.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### ogx-file-processors (agents-mcp) — score 5

- Placeholder tokens in source blocks: 1 (<dsc-name>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### ogx-remote-providers (agents-mcp) — score 5

- Placeholder tokens in source blocks: 3 (<base64-encoded-key>, <model_id>, <name>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### automated-red-teaming-garak (evaluation) — score 5

- Placeholder tokens in source blocks: 36 (<api_key>, <attacker-model-endpoint>, <attacker-model-name>, <bucket>, <ds-pipeline-dspa-route>, <evaluator-model-endpoint>, <evaluator-model-name>, <judge-model-endpoint>, <judge-model-name>, <model-)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3)

### nemo-guardrails-mcp-gateway (guardrails) — score 5

- Placeholder tokens in source blocks: 2 (<gateway-url>, <prefixed_tool_name>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### maas-oidc-auth (maas) — score 5

- Placeholder tokens in source blocks: 7 (<oidc-client-id>, <oidc-provider-issuer-url>, <user-access-token-from-your-oidc-provider>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2)

### llmd-priority-flow-control (model-serving) — score 5

- Placeholder tokens in source blocks: 1 (<epp_pod_name>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### vllm-serving-runtime-kserve (model-serving) — score 5

- Placeholder tokens in source blocks: 2 (<domain>, <project>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2)

### gateway-api-rhcl (platform-gateway) — score 5

- Placeholder tokens in source blocks: 4 (<hash>)
- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-01-concepts.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-02-hands-on.adoc (ex 4), module-02-hands-on.adoc (ex 5), module-02-hands-on.adoc (ex 6), module-03-advanced.adoc (ex 2)

### ai-available-assets (agents-mcp) — score 4

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2)

### mcp-catalog-admin (agents-mcp) — score 4

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-hands-on.adoc (ex 3)

### openshell-agent-sandboxing (agents-mcp) — score 4

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### view-agent-deployments (agents-mcp) — score 4

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-hands-on.adoc (ex 2), module-01-hands-on.adoc (ex 3)

### kuberay (distributed-training) — score 4

- Zero screenshots in assets/images/ (0 png/jpg)
- Vague verify sections: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-02-hands-on.adoc (ex 4), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3)

### automl (feature-store-automl-autorag) — score 4

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-01-getting-started.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-02-hands-on.adoc (ex 4)

### autorag (feature-store-automl-autorag) — score 4

- TODO markers: 2 occurrence(s)
- Image refs: 2, all resolve
- Screenshots present: 2
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2)

### feature-store-feast (feature-store-automl-autorag) — score 4

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3)

### maas-core (maas) — score 4

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-concepts.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-02-hands-on.adoc (ex 4), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3)

### maas-loki-showback (maas) — score 4

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### maas-vllm-deployment (maas) — score 4

- TODO markers: 1 occurrence(s)
- Image refs: 1, all resolve
- Screenshots present: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2)

### agent-catalog-ai-hub (agents-mcp) — score 3

- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-01-getting-started.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### claude-code-starter-kit (agents-mcp) — score 3

- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### external-metering-per-user (agents-mcp) — score 3

- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2)

### mcp-gateway-operator (agents-mcp) — score 3

- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 3)

### midojo-adversarial-testing (agents-mcp) — score 3

- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2)

### openclaw-starter-kit (agents-mcp) — score 3

- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3)

### opencode-coding-agent (agents-mcp) — score 3

- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2), module-02-hands-on.adoc (ex 2)

### text-mode-multimodal-training (agents-mcp) — score 3

- Zero screenshots in assets/images/ (0 png/jpg)
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-01-getting-started.adoc (ex 2)

### nemo-guardrails (guardrails) — score 2

- Image refs: 2, all resolve
- Screenshots present: 2
- [source,yaml] blocks near oc apply lacking callouts: 1
- Missing exercise transitions: getting-connected.adoc (ex 2), getting-connected.adoc (ex 3), module-02-hands-on.adoc (ex 2), module-02-hands-on.adoc (ex 3), module-03-advanced.adoc (ex 2), module-03-advanced.adoc (ex 3)

## Processing plan

- **54 single-workshop sessions** recommended (workshops scoring > 0), processed in the table order above (worst quality first).
- Skill's batch alternative: up to 3 parallel subagent batches (~18 batches), max 5 batches (15 workshops) before pausing for confirmation.
- GPU-dependent workshops get content-only fixes now; live tests deferred as observe-only (listed above).
- Workshops scoring 0 are skipped (idempotent operation).
