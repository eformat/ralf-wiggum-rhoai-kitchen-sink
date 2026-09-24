# Quality Triage — ralf-wiggum-rhoai-kitchen-sink

Phase 0 triage (`--dry-run --all`) per the `quality-enrichment` skill (zt-rhaibu factory).
Post-session re-run 2026-09-24 — analysis only. Reflects the easy-defect processing session (12 workshops), screenshot-capture session, and the Phase C deployment session (model registry deployed, kueue operator installed, 4 llmd-* workshops cleaned, model-registry-catalog 8→3). Remaining high scores are documented cluster/exercise-gated gaps — see qa/gap-analysis.md section 6.

- RHOAI version: 3.5
- Total enriched workshops: **54**
- Scored > 0 (need processing): **37**
- Score == 0 (skip — idempotent): **17**
- Processing order: **easy content-context defects first** (placeholders, vague verify, YAML callouts), then
  screenshot/image-ref gaps when a live cluster is available for capture.
- Tools: `decided` 0.27.0, `rg` 15.2.0 available. Enrichment source repos: all 8 present.
- Live cluster: `oc` authenticated (`admin`) — available for screenshot capture later.

Scoring: TODO markers +3 · broken heredoc/YAML outside source block +3 · broken image refs +3 · zero screenshots +2 · placeholders in execute blocks +2 · vague verify +1 · no YAML callouts +1 · missing module summaries +1 · missing exercise transitions +1 (binary per signal). Max 17.

## Triage table (worst first)

| Slug | Category | Maturity | Score | Top Issues |
|------|----------|----------|-------|------------|
| genai-studio-saved-agent | agents-mcp | DP | 8 | TODO markers, no screenshots, broken image refs |
| kale-jupyterlab | agents-mcp | DP | 8 | TODO markers, no screenshots, broken image refs |
| ogx-agentic-api | agents-mcp | TP | 7 | TODO markers, no screenshots, placeholders |
| kueue | distributed-training | GA | 6 | TODO markers, broken image refs |
| feature-store-feast | feature-store-automl-autorag | GA | 5 | TODO markers, no screenshots |
| automl | feature-store-automl-autorag | TP | 5 | TODO markers, no screenshots |
| automated-tool-calling-eval | agents-mcp | GA | 4 | no screenshots, placeholders |
| ogx-remote-providers | agents-mcp | DP | 4 | no screenshots, placeholders |
| automated-red-teaming-garak | evaluation | GA | 4 | no screenshots, placeholders |
| evalhub | evaluation | GA | 4 | no screenshots, placeholders |
| nemo-guardrails-mcp-gateway | guardrails | TP | 4 | no screenshots, placeholders |
| maas-oidc-auth | maas | GA | 4 | no screenshots, placeholders |
| maas-multi-tenancy | maas | TP | 4 | no screenshots, placeholders |
| kuberay | distributed-training | GA | 3 | no screenshots, vague verify |
| autorag | feature-store-automl-autorag | TP | 3 | TODO markers |
| maas-core | maas | GA | 3 | TODO markers |
| maas-loki-showback | maas | TP | 3 | TODO markers |
| model-registry-catalog | model-registry | GA | 3 | TODO markers |
| opencode-coding-agent | agents-mcp | TP | 2 | no screenshots |
| validated-tool-calling-config | agents-mcp | TP | 2 | placeholders |
| mcp-catalog-support-tier | agents-mcp | TP | 2 | placeholders |
| mcp-lifecycle-operator | agents-mcp | TP | 2 | placeholders |
| mcp-gateway-operator | agents-mcp | TP | 2 | no screenshots |
| agent-catalog-ai-hub | agents-mcp | DP | 2 | no screenshots |
| csv-export-model-catalog | agents-mcp | DP | 2 | placeholders |
| claude-code-starter-kit | agents-mcp | DP | 2 | no screenshots |
| midojo-adversarial-testing | agents-mcp | DP | 2 | no screenshots |
| openclaw-starter-kit | agents-mcp | DP | 2 | no screenshots |
| text-mode-multimodal-training | agents-mcp | DP | 2 | no screenshots |
| ogx-file-processors | agents-mcp | DP | 2 | no screenshots |
| external-metering-maas | agents-mcp | DP | 2 | no screenshots |
| external-metering-per-user | agents-mcp | DP | 2 | no screenshots |
| mlflow-experiment-tracking | mlops | GA | 2 | placeholders |
| llmd-priority-flow-control | model-serving | GA | 2 | no screenshots |
| vllm-cpu-ibm-z-power | model-serving | GA | 2 | placeholders |
| llama-stack-ogx-core | ogx | GA | 2 | placeholders |
| platform-oidc-auth | platform-gateway | GA | 2 | placeholders |
| ai-available-assets | agents-mcp | GA | 0 | clean |
| openshell-agent-sandboxing | agents-mcp | DP | 0 | clean |
| view-agent-deployments | agents-mcp | DP | 0 | clean |
| mcp-catalog-admin | agents-mcp | DP | 0 | clean |
| llmd-kv-cache-tiering | agents-mcp | DP | 0 | clean |
| llmd-latency-routing | agents-mcp | DP | 0 | clean |
| llmd-lora-routing | agents-mcp | DP | 0 | clean |
| kubeflow-trainer-v2 | distributed-training | GA | 0 | clean |
| nemo-guardrails | guardrails | GA | 0 | clean |
| maas-llmd-deployment | maas | TP | 0 | clean |
| maas-multi-provider-passthrough | maas | TP | 0 | clean |
| maas-vllm-deployment | maas | TP | 0 | clean |
| llmd-core | model-serving | GA | 0 | clean |
| llminferenceservice-config | model-serving | GA | 0 | clean |
| rhai-fast-release-images | model-serving | GA | 0 | clean |
| vllm-serving-runtime-kserve | model-serving | GA | 0 | clean |
| gateway-api-rhcl | platform-gateway | GA | 0 | clean |

## Session result (2026-09-24, easy-defect processing)

Processed 12 workshops in 4 batches (3 parallel each): csv-export-model-catalog, vllm-cpu-ibm-z-power,
llama-stack-ogx-core, validated-tool-calling-config, mcp-catalog-support-tier, mcp-lifecycle-operator,
ogx-agentic-api, kubeflow-trainer-v2, mlflow-experiment-tracking, llminferenceservice-config,
gateway-api-rhcl, platform-oidc-auth. Per-workshop records: qa/runs/<slug>/quality.md.

Residual 'placeholders' flags on csv-export-model-catalog, vllm-cpu-ibm-z-power, llama-stack-ogx-core,
mlflow-experiment-tracking, platform-oidc-auth are scanner false positives — by-design learner-supplied
values, now explicit in prose per skill 4b case 3 (see each workshop's quality.md).

Remaining real defects are cluster-gated: screenshot gaps + `// TODO: capture screenshot` markers.
Antora build (`make build`) verified after fixes: 287 pages, warnings are pre-existing baseline items.

Deferred (TODO = screenshot gap, needs live cluster): feature-store-feast, automl, autorag, maas-core, maas-loki-showback, maas-vllm-deployment, kuberay, mcp-gateway-operator, opencode-coding-agent, agent-catalog-ai-hub, claude-code-starter-kit, midojo-adversarial-testing, openclaw-starter-kit, text-mode-multimodal-training, ogx-file-processors, external-metering-maas, external-metering-per-user, llmd-kv-cache-tiering, llmd-latency-routing, llmd-lora-routing.

## GPU-dependent workshops (content-only fixes now; live tests deferred as observe-only)

Detected via `llmd-*`, `maas-llmd-deployment`, vLLM GPU paths, distributed-training GPU exercises, and `nvidia.com/gpu`/CUDA markers in content:

- **kueue** (distributed-training, GA, score 6) — content-only fixes now; live tests deferred as observe-only.
- **llmd-core** (model-serving, GA, score 0 — clean) — content-only fixes now; live tests deferred as observe-only.
- **evalhub** (evaluation, GA, score 4) — content-only fixes now; live tests deferred as observe-only.
- **llmd-priority-flow-control** (model-serving, GA, score 2) — content-only fixes now; live tests deferred as observe-only.
- **kuberay** (distributed-training, GA, score 3) — content-only fixes now; live tests deferred as observe-only.
- **maas-vllm-deployment** (maas, TP, score 0 — clean) — content-only fixes now; live tests deferred as observe-only.
- **kubeflow-trainer-v2** (distributed-training, GA, score 0 — clean) — content-only fixes now; live tests deferred as observe-only.
- **llminferenceservice-config** (model-serving, GA, score 0 — clean) — content-only fixes now; live tests deferred as observe-only.
- **llmd-kv-cache-tiering** (agents-mcp, DP, score 0 — clean) — content-only fixes now; live tests deferred as observe-only.
- **llmd-latency-routing** (agents-mcp, DP, score 0 — clean) — content-only fixes now; live tests deferred as observe-only.
- **llmd-lora-routing** (agents-mcp, DP, score 0 — clean) — content-only fixes now; live tests deferred as observe-only.
- **text-mode-multimodal-training** (agents-mcp, DP, score 2) — content-only fixes now; live tests deferred as observe-only.
- **rhai-fast-release-images** (model-serving, GA, score 0 — clean) — content-only fixes now; live tests deferred as observe-only.
- **vllm-serving-runtime-kserve** (model-serving, GA, score 0 — clean) — content-only fixes now; live tests deferred as observe-only.
- **maas-llmd-deployment** (maas, TP, score 0 — clean) — content-only fixes now; live tests deferred as observe-only.

## Signal detail (workshops with score > 0)

### genai-studio-saved-agent (agents-mcp) — score 8

- TODO markers: 1 occurrence(s) (all `// TODO: capture screenshot` gaps — need live cluster)
- Zero screenshots in assets/images/ (0 png/jpg)
- Broken image refs (1 of 1): 02-save-agent-dialog.png (module-02-hands-on.adoc)
- Screenshots on disk: 0

### kale-jupyterlab (agents-mcp) — score 8

- TODO markers: 1 occurrence(s) (all `// TODO: capture screenshot` gaps — need live cluster)
- Zero screenshots in assets/images/ (0 png/jpg)
- Broken image refs (1 of 1): 02-kale-enable-toggle.png (module-02-hands-on.adoc)
- Screenshots on disk: 0

### ogx-agentic-api (agents-mcp) — score 7

- TODO markers: 1 occurrence(s) (all `// TODO: capture screenshot` gaps — need live cluster)
- Zero screenshots in assets/images/ (0 png/jpg)
- Placeholder tokens in source blocks: 1 (<model-id>)
- Screenshots on disk: 0

### kueue (distributed-training) — score 6

- TODO markers: 1 occurrence(s) (all `// TODO: capture screenshot` gaps — need live cluster)
- Broken image refs (1 of 2): 02-kueue-alerting-rules.png (module-02-hands-on.adoc)
- Screenshots on disk: 1

### feature-store-feast (feature-store-automl-autorag) — score 5

- TODO markers: 1 occurrence(s) (all `// TODO: capture screenshot` gaps — need live cluster)
- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### automl (feature-store-automl-autorag) — score 5

- TODO markers: 1 occurrence(s) (all `// TODO: capture screenshot` gaps — need live cluster)
- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### automated-tool-calling-eval (agents-mcp) — score 4

- Zero screenshots in assets/images/ (0 png/jpg)
- Placeholder tokens in source blocks: 6 (<job_id>, <provider_id>, <service_account>)
- Screenshots on disk: 0

### ogx-remote-providers (agents-mcp) — score 4

- Zero screenshots in assets/images/ (0 png/jpg)
- Placeholder tokens in source blocks: 3 (<base64-encoded-key>, <model_id>, <name>)
- Screenshots on disk: 0

### automated-red-teaming-garak (evaluation) — score 4

- Zero screenshots in assets/images/ (0 png/jpg)
- Placeholder tokens in source blocks: 1 (<api_key>)
- Screenshots on disk: 0

### evalhub (evaluation) — score 4

- Zero screenshots in assets/images/ (0 png/jpg)
- Placeholder tokens in source blocks: 16 (<collection_id>, <job_id>, <model-svc>, <user_name>)
- Screenshots on disk: 0

### nemo-guardrails-mcp-gateway (guardrails) — score 4

- Zero screenshots in assets/images/ (0 png/jpg)
- Placeholder tokens in source blocks: 2 (<prefixed_tool_name>)
- Screenshots on disk: 0

### maas-oidc-auth (maas) — score 4

- Zero screenshots in assets/images/ (0 png/jpg)
- Placeholder tokens in source blocks: 1 (<user-access-token-from-your-oidc-provider>)
- Screenshots on disk: 0

### maas-multi-tenancy (maas) — score 4

- Zero screenshots in assets/images/ (0 png/jpg)
- Placeholder tokens in source blocks: 2 (<tenant_api_key>, <tenant_name>)
- Screenshots on disk: 0

### kuberay (distributed-training) — score 3

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0
- Vague verify sections: module-03-advanced.adoc

### autorag (feature-store-automl-autorag) — score 3

- TODO markers: 1 occurrence(s) (all `// TODO: capture screenshot` gaps — need live cluster)
- Image refs: 1, all resolve
- Screenshots on disk: 1

### maas-core (maas) — score 3

- TODO markers: 1 occurrence(s) (all `// TODO: capture screenshot` gaps — need live cluster)
- Image refs: 1, all resolve
- Screenshots on disk: 1

### maas-loki-showback (maas) — score 3

- TODO markers: 1 occurrence(s) (all `// TODO: capture screenshot` gaps — need live cluster)
- Image refs: 1, all resolve
- Screenshots on disk: 1

### model-registry-catalog (model-registry) — score 3

- TODO markers: 2 occurrence(s) (all `// TODO: capture screenshot` gaps — need live cluster)
- Image refs: 3, all resolve
- Screenshots on disk: 3

### opencode-coding-agent (agents-mcp) — score 2

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### validated-tool-calling-config (agents-mcp) — score 2

- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 3 (<model_api_key_1>, <model_api_key_2>, <your_api_key>)
- Screenshots on disk: 1

### mcp-catalog-support-tier (agents-mcp) — score 2

- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 1 (<service_account_name>)
- Screenshots on disk: 1

### mcp-lifecycle-operator (agents-mcp) — score 2

- Image refs: 2, all resolve
- Placeholder tokens in source blocks: 2 (<service_account_name>)
- Screenshots on disk: 2

### mcp-gateway-operator (agents-mcp) — score 2

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### agent-catalog-ai-hub (agents-mcp) — score 2

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### csv-export-model-catalog (agents-mcp) — score 2

- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 5 (<authorization-header>, <catalog-source>, <count>, <export-script>, <exported-file>)
- Screenshots on disk: 1

### claude-code-starter-kit (agents-mcp) — score 2

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### midojo-adversarial-testing (agents-mcp) — score 2

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### openclaw-starter-kit (agents-mcp) — score 2

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### text-mode-multimodal-training (agents-mcp) — score 2

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### ogx-file-processors (agents-mcp) — score 2

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### external-metering-maas (agents-mcp) — score 2

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### external-metering-per-user (agents-mcp) — score 2

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### mlflow-experiment-tracking (mlops) — score 2

- Image refs: 2, all resolve
- Placeholder tokens in source blocks: 2 (<experiment_id_1>, <experiment_id_2>)
- Screenshots on disk: 2

### llmd-priority-flow-control (model-serving) — score 2

- Zero screenshots in assets/images/ (0 png/jpg)
- Screenshots on disk: 0

### vllm-cpu-ibm-z-power (model-serving) — score 2

- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 1 (<token-secret-value>)
- Screenshots on disk: 1

### llama-stack-ogx-core (ogx) — score 2

- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 17 (<access_key_id>, <age>, <bucket_name>, <client_secret>, <embedding-token>, <keycloak-host>, <pgvector-password>, <pod-suffix>, <s3_endpoint_url>, <secret_access_key>, <token-identifier>, <token>, <user1-password>, <user2-password>)
- Screenshots on disk: 1

### platform-oidc-auth (platform-gateway) — score 2

- Image refs: 1, all resolve
- Placeholder tokens in source blocks: 2 (<gateway-elb-address>, <your-client-secret>)
- Screenshots on disk: 1

## Record keeping

- This file: repo-level triage snapshot; re-run after processing sessions to show drift.
- `qa/runs/<slug>/quality.md`: per-workshop record written by the workshop-enricher subagent after fixes (date, score before/after, fixes applied, human-attention items) — same convention as `qa/runs/<slug>/fixes.md` for functional runs.
