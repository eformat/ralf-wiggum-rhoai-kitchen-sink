# Gap Analysis — ralf-wiggum-rhoai-kitchen-sink

Produced 2026-09-24 per the `quality-enrichment` skill (zt-rhaibu factory, monorepo mode),
after the easy-defect processing session (12 workshops) and screenshot-capture session
(4 real UI captures, 7 junk screenshots removed). Analysis for cluster-44gxc.dyn.redhatworkshops.io
(RHOAI 3.5.1). RAC artifacts are observe-only — never edited here.

- Quality triage: 42/54 workshops score > 0, 12 clean (`qa/quality-triage.md`)
- RAC validation: 54 corpora, 917 REQs — **862 covered (94%), 55 partial, 0 gap**, all pass `decided validate`
- Cluster: RHOAI 3.5.1, CPU-only (no `nvidia.com/gpu` on any node)

## 1. Screenshot / UI gap matrix

**Captured this session (real UI, logged in as admin via RHBK):**

| Shot | Workshop | Shows | Class |
|------|----------|-------|-------|
| 01-autorag-page.png | autorag | Gen AI studio > AutoRAG page (empty state) | captured |
| 02-deploy-model-wizard.png | maas-vllm-deployment | Deployment wizard, "LLM inference service" (MaaS-compatible) selected | captured (CPU variant) |
| 01-agent-ops-list.png | view-agent-deployments | AI hub > Agents deployments page (empty state) | captured |
| 02-agent-deployments-dashboard.png | openshell-agent-sandboxing | Same Agents dashboard | captured |

**Junk removed (7):** all were the same "Could not load component state" error page or a
loading spinner, referenced as real UI. File + `image::` ref removed, `// TODO: capture
screenshot` kept: csv-export-model-catalog, mcp-catalog-support-tier, automl, autorag,
feature-store-feast, ogx-agentic-api (×1 each; 01-autorag-page re-captured for real).

**Remaining gaps — 13 TODO markers + 5 broken image refs, classified:**

| Class | Shots | Unblocking action |
|-------|-------|-------------------|
| **Needs component deployment** | model-registry-catalog: 02-register-model-dialog.png, 03-model-transfer-jobs.png (broken refs + TODOs); mcp-catalog-support-tier: 01-catalog-support-tiers.png; csv-export-model-catalog: 01-model-catalog-page.png; ogx-agentic-api: 01-ogx-crd-search.png; kueue: 02-kueue-alerting-rules.png (broken ref + TODO) | Apply `registry`, `mcp`, `monitoring` overlays; install kueue operator (OLM); llamastackoperator is Removed — OGXServer CRD requires `ogx` overlay + llamastackoperator flip |
| **Needs exercise execution (data)** | automl: 02-leaderboard.png; autorag: 02-autorag-leaderboard.png; maas-core: 02-endpoints-dialog.png; maas-loki-showback: 02-usage-dashboard.png | Execute the lab exercises to produce leaderboard rows / MaaS endpoints / usage data; heaviest class |
| **Needs workbench / model server** | kale-jupyterlab: 02-kale-enable-toggle.png (broken ref + TODO); genai-studio-saved-agent: 02-save-agent-dialog.png (broken ref + TODO) | Launch JupyterLab + KALE; deploy CPU model server + GenAI playground flow |
| **Not screenshottable** | feature-store-feast: 01-feature-store-workflow.png (conceptual diagram) | Replace with a drawn diagram or drop the ref — do not fake a UI capture |

**Dashboard reachability notes (verified live):**
- Nav exposes: Home, Projects, AI hub (Agents, Models), Gen AI studio (AutoRAG TP, AI asset
  endpoints TP, Prompts), Develop & train (Pipelines, Cluster settings, Environment setup,
  Model resources and operations), Learning resources, Applications, Settings
- Model/MCP catalog pages are **not surfaced in the nav** on this build — even after the
  `registry` overlay, catalog screenshots may require dashboard config; verify after deploy
- Gen AI studio has **no Playground entry** in this build — the save-agent-dialog shot may be
  unreachable; verify before investing in a model server

## 2. Cluster capability matrix

| Component / capability | State on cluster-44gxc | Overlay | Workshops blocked |
|------------------------|------------------------|---------|-------------------|
| Dashboard, workbenches, KServe, MLflow, TrustyAI, AI pipelines | Managed (DSC default-dsc) | — | — |
| LlamaStackOperator | **Removed** | ogx (+ flip) | ogx-agentic-api, llama-stack-ogx-core (CRD shots) |
| Model Registry | **absent from DSC components** | registry | model-registry-catalog, csv-export-model-catalog, mcp-catalog-support-tier (catalog pages) |
| Kueue operator | **not installed** | monitoring + OLM subscription | kueue |
| MCP operators / catalog | **not installed** | mcp | mcp-catalog-support-tier, ogx-agentic-api, mcp-* shots |
| MaaS / Loki showback | **not deployed** | maas (flip last per cluster/README.md) | maas-core, maas-loki-showback dialogs |
| GPU (`nvidia.com/gpu`) | **0 on all nodes** — CPU-only | gpu-config (no hardware) | GPU-specific shots (vLLM CUDA LLMInferenceServiceConfig) stay observe-only |
| Keycloak (RHBK) | Running (`keycloak` ns, realm `keycloak`, user `admin`) | oidc | login flows OK |

Cluster config reference: `cluster/README.md` (apply flow, two-step overlays, ordering
constraints: MaaS flip last, llamastackoperator Removed before ogx, RHBoK ≤1.3, no Service Mesh).

## 3. RAC validation pass (all 54)

Heuristic evidence matching (criterion keywords vs content pages) + `decided validate` per corpus.
Deep per-criterion mapping for ambiguous items needs subagent review — flagged below.

**Totals: 54 corpora · 917 REQs · 862 covered (94%) · 55 partial · 0 gap · 54/54 `decided validate` OK**

**Corpora with partial evidence (review recommended):**

| Corpus | REQs | Partial | Notes |
|--------|------|---------|-------|
| mcp-lifecycle-operator | 16 | **11** | **Genuine mismatch** — content has zero mentions of `MCPGatewayExtension`, `mcpvirtualservers`, `Gateway object`, `Subscription`; the corpus contains MCP gateway-deployment-operator criteria that belong to mcp-gateway-operator scope. Report only — RAC fix goes through workshop-orient. |
| openclaw-starter-kit | 17 | 4 | keyword-match likely under-detects; spot-check |
| feature-store-feast | 23 | 3 | spot-check |
| llminferenceservice-config | 20 | 3 | spot-check |
| maas-oidc-auth | 15 | 3 | spot-check |
| maas-vllm-deployment | 17 | 3 | spot-check |
| opencode-coding-agent | 16 | 3 | spot-check |
| vllm-cpu-ibm-z-power | 16 | 3 | spot-check |
| llama-stack-ogx-core | 30 | 2 | spot-check |
| llmd-latency-routing | 15 | 2 | spot-check |
| maas-llmd-deployment | 16 | 2 | spot-check |
| text-mode-multimodal-training | 15 | 2 | spot-check |
| ogx-agentic-api | 22 | 2 | spot-check |
| others (9 corpora) | — | 1 each | low priority |

## 4. Prioritized execution plan (cheap-first)

1. **C1 — Free captures now** (~8-10 shots): AI asset endpoints page, Prompts page, Develop &
   train sub-pages, project pages — unblocks score-2 "no screenshots" workshops.
2. **C2 — Deploy Model Registry** (`registry` overlay + ModelRegistry CR) → unblocks 3
   model-registry shots; then verify whether catalog pages surface in the nav.
3. **C3 — Install kueue operator (OLM) + `monitoring` overlay** → kueue alerting rules shot.
4. **C4 — KALE workbench** (launch workbench, check KALE extension in RHOAI 3.5 images) →
   kale toggle shot; likely gap if KALE is not in stock images.
5. **C5 — GenAI playground + CPU model server** → save-agent dialog shot; **verify the
   Playground nav entry exists first** — this build's Gen AI studio shows only
   AutoRAG / AI asset endpoints / Prompts.
6. **C6 — Exercise execution for data-dependent shots** (leaderboards, MaaS dialogs) —
   heaviest; GPU-gated items stay observe-only.
7. **RAC spot-checks** — subagent review of the 14 partial-heavy corpora above; report
   findings (never edit RAC).

## 6. Deployment-session results (2026-09-24, Phase C execution)

### C1 — Free captures: DONE (7 real UI shots)

Settings llm-d topology/routing configurations, Serving runtimes, AutoML, MLflow Experiments,
GenAI assets, GenAI prompts pages — captured to `qa/screenshots/` (staging) and embedded:
`llmd-kv-cache-tiering`, `llmd-latency-routing`, `llmd-lora-routing`, `llmd-core`
(one honest-fit shot each); `llmd-priority-flow-control` had no honest fit (its UI surface is
Observe > Metrics, not the Settings pages).

### C2 — Model Registry: DONE (3 shots captured)

`registry` overlay applied; Model Registry component deployed; `workshop-registry` created via
the dashboard (the lab's Exercise 1); Model/MCP catalog tabs surfaced in the AI hub nav.
Captured: 01-model-registry-settings.png, 02-register-model-dialog.png, 03-model-transfer-jobs.png
(embedded; refs restored where junk screenshots had been removed). RAC evidence:
`rac/model-registry-catalog/assets/screenshot-evidence-model-registry-catalog.md`.

### C3 — Kueue: operator installed; alerting shot = CONTENT GAP

`distributed` overlay applied (kueue-operator subscription stable-v1.3.2, CSV Succeeded);
Kueue CR activated (`kueue.openshift.io/v1 Kueue cluster` with integrations) → 11
`kueue.x-k8s.io` CRDs installed. **Finding:** no Kueue alerting rules (KueuePodDown,
LowClusterQueueResourceUsage, ResourceReservationExceedsQuota, PendingWorkloadPods) ship with
RHBoK 1.3.2 — the console Alerting rules page has no Kueue rules, so the workshop's
"Kueue ships alerting rules" claim and the 02-kueue-alerting-rules.png shot cannot be captured.
Needs: content correction (rules table may be aspirational) or manual PrometheusRule creation.
Flagged for human attention.

### C4 — KALE: workbench flow tested live; Kale toggle = CONTENT/IMAGE GAP

Live-tested the full flow: created `kale-workbench` (runtime-datascience) in project
abc123-user1; KALE v2.1.1 confirmed present but disabled via the image's
`/opt/app-root/etc/jupyter/labconfig/page_config.json`; `jupyter labextension enable
jupyterlab-kubeflow-kale` reports enabled but the runtime labconfig still pins the disable;
flipping the labconfig and restarting the Jupyter server kills the container (ephemeral fs
reverts the change). **Finding:** the workshop's enable step (`jupyter labextension enable` +
browser refresh) does not produce the Kale UI on the 3.5 runtime-datascience image. Needs:
content correction (different image or enablement path) or an image fix. Flagged for human
attention. Workbench deleted after the test.

### C5 — GenAI playground: NOT AVAILABLE IN THIS BUILD

The 3.5 dashboard's Gen AI studio exposes only AutoRAG / AI asset endpoints / Prompts — no
Playground entry, so the save-agent dialog flow (02-save-agent-dialog.png) is unreachable.
Flagged as a gap.

### RAC spot-checks: DONE

24/25 corpora clean (heuristic false positives); `mcp-lifecycle-operator` confirmed as a
genuine RAC mismatch — 15/16 criteria mis-scoped from the mcp-gateway-operator corpus
(RAC re-retrofit goes through workshop-orient; report only).

## Guardrails applied

- Build validation (`make build`) after content changes — passing
- Screenshots only from live, verified UI; no fabricated images
- RAC observe-only; content fixes only inside a workshop's own content dir
- Cluster changes only via documented `cluster/` overlays with ordering constraints
- No secrets committed; playwright auth state kept in session only
