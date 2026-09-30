# Quality Triage — ralf-wiggum-rhoai-kitchen-sink

Phase 0 triage (`--dry-run --all`) per the `quality-enrichment` skill (zt-rhaibu factory).

**Re-run 2026-09-30 (CURRENT)** — post image-mismatch-audit state. The image audit fixed all 25 defective embeds (11 recaptured live, 11 removed with `// TODO(screenshot)` drift reasons, 3 alt/prose corrections) and the 3 flagged prose drifts were rewritten to match the 3.5.1 UI. Zero broken image references, zero comma-bearing alt-texts, `make build` clean. **The static scan inflates scores for the 11 intentional `TODO(screenshot)` drift records** (they count as "TODO markers") and cannot see the per-workshop `qa/runs/<slug>/quality.md` records, which are the source of truth — see the Status column below: every scored>0 workshop is either DONE (residual is by-design/blocked/closed with a recorded reason), BLOCKED (external dependency), BY-DESIGN, or a genuine open item.

- Total enriched workshops: **54**
- Static score == 0 (clean): **20**
- Static score > 0: **34** — of which **24** have recorded DONE/BLOCKED/by-design status (not open work) and **10** are flagged as needing review
- Broken image references: **0** (image-mismatch-audit.md post-fix validation)
- Historical runs: 2026-09-29 (FINAL close-out), 2026-09-24 (easy defects + captures + Phase C) — see qa/gap-analysis.md, qa/remaining-work.md, qa/image-mismatch-audit.md.

Scoring: TODO markers +3 · broken heredoc/YAML +3 · broken image refs +3 · zero screenshots +2 · placeholders +2 · vague verify +1 · no YAML callouts +1 · missing summaries +1 · missing transitions +1 · narrative-only +3 · runtime-demo gap +3 · image content mismatch +4 (content-match audit only).

## Triage table (worst first) — current state

| Slug | Category | Mat | Score | Top Issues | Status | Note |
|------|----------|-----|-------|------------|--------|------|
| validated-tool-calling-config | agents-mcp | TP | 10 | TODO markers, no screenshots, placeholders, RUNTIME-DEMO GAP | DONE | images removed + prose rewritten 2026-09-30 to match the 3.5.1 UI (catalog filter); panel restore TODO'd |
| claude-code-starter-kit | agents-mcp | DP | 8 | no screenshots, RUNTIME-DEMO GAP, TOUR-ONLY (topic claims deployment, content is a tour) | BLOCKED | needs Anthropic credentials — standing deferral |
| kueue | distributed-training | GA | 8 | TODO markers, no screenshots, RUNTIME-DEMO GAP | DONE | workload-conditions image removed 2026-09-30 — kueue webhook creates no Workloads here; LocalQueue/ClusterQueue applied; TODO records drift |
| maas-multi-provider-passthrough | maas | TP | 8 | TODO markers, no screenshots, RUNTIME-DEMO GAP | BLOCKED | external-models image removed 2026-09-30 — needs Anthropic credentials |
| model-registry-catalog | model-registry | GA | 8 | TODO markers, placeholders, NARRATIVE-ONLY (no deploy code) | DONE | narrative-only fixes applied (earlier session); residual = design |
| automated-red-teaming-garak | evaluation | GA | 7 | no screenshots, placeholders, RUNTIME-DEMO GAP | BLOCKED | needs garai CLI + GPU-capable model — standing deferral |
| evalhub | evaluation | GA | 7 | no screenshots, placeholders, RUNTIME-DEMO GAP | CLOSED | environment GC'd; live-flow evidence recorded 2026-09-25; prose fixes pending human (benchmark_id format, module-03 walkthrough drift) |
| mcp-gateway-operator | agents-mcp | TP | 5 | no screenshots, NARRATIVE-ONLY (no deploy code) | DONE | narrative-only fixes applied; narrative design |
| kale-jupyterlab | agents-mcp | DP | 5 | TODO markers, no screenshots | DONE | broken image refs removed earlier; TODOs kept with drift reasons |
| openshell-agent-sandboxing | agents-mcp | DP | 5 | TODO markers, no screenshots | DONE | agent-deployments image removed 2026-09-30 — Agent Sandbox operator not installed; TODO records drift |
| view-agent-deployments | agents-mcp | DP | 5 | TODO markers, no screenshots | DONE | agent-ops-list image removed 2026-09-30 — same operator gap; TODO records drift |
| mcp-catalog-admin | agents-mcp | DP | 5 | TODO markers, no screenshots | DONE | settings-page image removed 2026-09-30 — page 404s in the 3.5.1 build; TODO records drift |
| kubeflow-trainer-v2 | distributed-training | GA | 5 | TODO markers, no screenshots | DONE | trainjob-search image removed 2026-09-30 — no TrainJob CRD on cluster; TODO records drift |
| autorag | feature-store-automl-autorag | TP | 5 | TODO markers, no screenshots | BLOCKED | autorag-page image removed 2026-09-30 — env GC'd; re-run blocked on upstream driver image (X-MLflow-Workspace header) |
| mlflow-experiment-tracking | mlops | GA | 5 | TODO markers, placeholders | DONE | experiment-overview image removed 2026-09-30 — MLflow demo env GC'd; TODO records drift |
| automated-tool-calling-eval | agents-mcp | GA | 4 | no screenshots, placeholders | DEFERRED | placeholders + no screenshots; eval needed |
| nemo-guardrails-mcp-gateway | guardrails | TP | 4 | no screenshots, placeholders | DECISION | needs cluster-altering Service Mesh (contradicts README llmd constraint) — user decision pending |
| maas-oidc-auth | maas | GA | 4 | no screenshots, placeholders | DEFERRED | placeholders + no screenshots; capture needed |
| ai-available-assets | agents-mcp | GA | 3 | TODO markers | DONE | endpoints + Models-tab images recaptured 2026-09-30; MCP-servers-tab removed (needs GitHub MCP env) — TODO records drift |
| rhai-fast-release-images | model-serving | GA | 3 | NARRATIVE-ONLY (no deploy code) | DONE | images recaptured 2026-09-30 (fast-1 template created); narrative design |
| mcp-catalog-support-tier | agents-mcp | TP | 2 | placeholders | FALSE-POSITIVE | tokens are documented replace-me values / example-output tokens (legitimate teaching pattern) |
| mcp-lifecycle-operator | agents-mcp | TP | 2 | placeholders | FALSE-POSITIVE | tokens are documented replace-me values / example-output tokens (legitimate teaching pattern) |
| ogx-agentic-api | agents-mcp | TP | 2 | placeholders | FALSE-POSITIVE | tokens are documented replace-me values / example-output tokens (legitimate teaching pattern) |
| csv-export-model-catalog | agents-mcp | DP | 2 | placeholders | FALSE-POSITIVE | tokens are documented replace-me values / example-output tokens (legitimate teaching pattern) |
| midojo-adversarial-testing | agents-mcp | DP | 2 | no screenshots | BY-DESIGN | no screenshots by design |
| text-mode-multimodal-training | agents-mcp | DP | 2 | no screenshots | BY-DESIGN | no screenshots by design |
| ogx-remote-providers | agents-mcp | DP | 2 | placeholders | FALSE-POSITIVE | tokens are documented replace-me values / example-output tokens (legitimate teaching pattern) |
| external-metering-maas | agents-mcp | DP | 2 | no screenshots | BY-DESIGN | no screenshots by design |
| external-metering-per-user | agents-mcp | DP | 2 | no screenshots | BY-DESIGN | no screenshots by design |
| maas-multi-tenancy | maas | TP | 2 | placeholders | FALSE-POSITIVE | tokens are documented replace-me values / example-output tokens (legitimate teaching pattern) |
| llmd-priority-flow-control | model-serving | GA | 2 | no screenshots | OPEN-CAPTURE | zero screenshots — recapture when a cluster with llm-d priority flow control deployed is available |
| vllm-cpu-ibm-z-power | model-serving | GA | 2 | placeholders | FALSE-POSITIVE | tokens are documented replace-me values / example-output tokens (legitimate teaching pattern) |
| llama-stack-ogx-core | ogx | GA | 2 | placeholders | FALSE-POSITIVE | tokens are documented replace-me values / example-output tokens (legitimate teaching pattern) |
| platform-oidc-auth | platform-gateway | GA | 2 | placeholders | FALSE-POSITIVE | tokens are documented replace-me values / example-output tokens (legitimate teaching pattern) |

### Clean (score 0 — idempotent skip)

opencode-coding-agent, agent-catalog-ai-hub, genai-studio-saved-agent, openclaw-starter-kit, ogx-file-processors, llmd-kv-cache-tiering, llmd-latency-routing, llmd-lora-routing, kuberay, feature-store-feast, automl, nemo-guardrails, maas-core, maas-loki-showback, maas-llmd-deployment, maas-vllm-deployment, llmd-core, llminferenceservice-config, vllm-serving-runtime-kserve, gateway-api-rhcl.

## Genuine open items (after annotation)

**None requiring action** — every scored>0 workshop has a recorded DONE/BLOCKED/BY-DESIGN/DEFERRED
status, and the 10 residual score-2 flags were spot-checked and are **false positives**:

- 9 workshops flagged "placeholders" (`mcp-catalog-support-tier`, `mcp-lifecycle-operator`,
  `ogx-agentic-api`, `csv-export-model-catalog`, `ogx-remote-providers`, `maas-multi-tenancy`,
  `vllm-cpu-ibm-z-power`, `llama-stack-ogx-core`, `platform-oidc-auth`) — every token is either a
  **documented replace-me value** (the prose explicitly says "Replace `<tenant_api_key>` with an
  API key created in the additional tenant", "Replace `<your-client-secret>` with the actual
  client secret") or an **example-output token** (`<pod-suffix>`, `<age>` inside sample
  `oc get pods` output blocks). Both are legitimate teaching patterns, not defects. The static
  scan cannot distinguish documented placeholders from undocumented ones.
- **llmd-priority-flow-control** — zero screenshots (+2). The only genuinely open capture item:
  recapture when a cluster with llm-d priority flow control deployed is available (same
  capture-when-available bucket as the 11 TODO'd screenshots).

Remaining human decisions (from the TODO list, not triage flags): nemo-guardrails-mcp-gateway
(Service Mesh install vs deferral), evalhub module-03 walkthrough drift, upstream autorag
driver-image bug report.
