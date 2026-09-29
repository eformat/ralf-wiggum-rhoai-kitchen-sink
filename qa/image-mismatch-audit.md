# Image mismatch audit — 2026-09-29

Full semantic audit of all 54 `image::` embeds across the 54 workshops: each PNG was visually
inspected against the step text / prose it illustrates (not just alt-text). Triggered by a user
find in agent-catalog-ai-hub (step says "click AI hub → Agents", image shows the Models catalog).

**RESOLVED 2026-09-30 — all 25 defective embeds fixed: 11 re-captured live from
cluster-44gxc (workshop resources re-created where needed: agentsCatalog flag enabled, vllm-fast-1
runtime template created, ingress-gateway created in abc123-gateway), 11 removed with
`// TODO(screenshot)` drift reasons and dead PNGs deleted, 3 alt-text/prose corrections.**
`make build` clean (0 errors), zero broken image references. Skill gap fixed: the
quality-enrichment Phase 2 content-match audit (+4 triage signal), workshop-screenshot post-capture
verification (final URL/title + pixel check, rejecting 404/error/modal/empty captures), and a
Content Correctness rule in WORKSHOP-COMMON-RULES were added so this class of defect is caught
before shipping.

## Post-fix validation re-run — 2026-09-30

Full audit re-run over the current tree:

| Check | Result |
|---|---|
| Total embeds | **43** (was 54; 11 removed with `// TODO(screenshot)` drift reasons) |
| Missing files (ref to non-existent PNG) | **0** |
| Broken `image::` syntax | **0** |
| Comma-bearing alt-texts (truncate in rendered HTML) | **0** (3 found during spot-check and rewritten comma-free) |
| `make build` | **0 errors** |
| Duplicate-hash groups | 4 — all justified: OGX CRD search trio (same CRD page, verified good), llmd routing + topology empty-state pairs (documented empty states), ai-available-assets endpoints/Models-tab pair (same surface, both steps describe the same populated page) |
| Recaptured files re-verified from disk | **11/11 correct** — every replacement re-read as an image and confirmed against its step text: Agents catalog, fast-1 wizard (Limited support + fast-1 badges), llm-d wizard, Inference-service wizard, vLLM CPU wizard, populated AI-asset endpoints page (×2), Connectivity Link in kuadrant-system, created ingress-gateway, OpenShift AI operator (OGX carrier), Serving runtimes badges |
| Rendered-site spot-check | agent-catalog-ai-hub module-01 and rhai-fast-release-images module-02 render the new images with full alt-text (qa/spotcheck-agent-catalog-page.png) |

**Post-fix scoreboard: 43 embeds — 39 clean matches, 4 documented empty states, 0 defects.**
The 11 TODO'd screenshots are tracked with drift reasons below and are re-capturable as their
environments return (cluster-gated items get honest findings, not fabricated captures).

Dedup note: the original 54 embeds mapped to 44 unique files (7 duplicate-hash groups). A shared
file can be correct in one workshop and wrong in another (e.g. 01-model-catalog-page.png was
correct for csv-export-model-catalog but wrong for agent-catalog-ai-hub — the re-run split them:
csv-export keeps the Models catalog, agent-catalog now has the Agents catalog).

## Scoreboard

| Verdict | Embeds | Meaning |
|---|---|---|
| HARD mismatch | 20 | image shows the wrong page, an error/404, a welcome modal, or an empty state that contradicts the step |
| Moderate | 1 | right surface, wrong selection/state shown |
| Minor | 4 | right page, but a detail the alt/prose claims is not visible |
| Borderline-acceptable | 4 | empty state explicitly documented by alt-text and/or prose |
| Clean match | 25 | image matches step + alt-text |

**25 of 54 embeds (46%) "don't make sense"; 20 are outright wrong.**

## HARD mismatches (20)

| # | Workshop / file | Prose says | Image actually shows |
|---|---|---|---|
| 1 | agent-catalog-ai-hub `01-model-catalog-page.png` | "click AI hub → Agents", observe agent starter kits | Models catalog page (AI hub → Models highlighted) — the user's find. NB: same file is CORRECT in csv-export-model-catalog |
| 2 | ai-available-assets `01-ai-asset-endpoints-page.png` | endpoints page, per-project assets | Loading spinner + "Welcome to OpenShift AI 3.5!" tour modal + "No projects" |
| 3 | ai-available-assets `01-mcp-servers-tab.png` | "the GitHub MCP server now appears in the MCP servers tab" | "No MCP configuration found" empty state — contradicts the verify step |
| 4 | ai-available-assets `02-models-tab.png` | Models tab with deployed model + capability badges | "Models as a Service could not be loaded" error banner + "Some model sources could not be loaded" empty state |
| 5 | openshell-agent-sandboxing `02-agent-deployments-dashboard.png` | "Running agent deployments in the RHOAI dashboard" | "No agent deployments" empty state |
| 6 | view-agent-deployments `01-agent-ops-list.png` | "Running agent deployments list in the dashboard" | Same empty-state file as #5 (md5 5fa918ac) |
| 7 | mcp-catalog-admin `01-mcp-catalog-settings.png` | Settings page with MCP catalog source management | Console "We can't find that page" 404 + welcome tour modal (page doesn't exist in this build) |
| 8 | rhai-fast-release-images `01-serving-runtime-badges.png` | Serving runtimes page with badge combinations | Same 404 file as #7 (md5 ac734e54) |
| 9 | validated-tool-calling-config `01-validated-arguments-panel.png` | Validated Arguments / Tool Calling panel | Raw OAuth `server_error` JSON page (failed auth redirect; also renders a state param) |
| 10 | maas-llmd-deployment `01-deploy-wizard-llmd.png` | Deploy wizard, "Distributed inference with llm-d" resource selected | Welcome tour modal over a project page showing a **Failed** deployment card |
| 11 | rhai-fast-release-images `02-wizard-fast-runtime.png` | Deploy wizard with fast-1 runtime selected | Same welcome-modal file as #10 (md5 f7f8cce8) |
| 12 | vllm-cpu-ibm-z-power `01-deploy-model-wizard.png` | Wizard with vLLM CPU ServingRuntime selected | Same welcome-modal file as #10 (md5 f7f8cce8) |
| 13 | kueue `02-workload-conditions.png` | Workload YAML status conditions | Console "404: The server doesn't have a resource type 'workloads'" error page |
| 14 | kubeflow-trainer-v2 `02-trainjob-console-search.png` | TrainJob listed on console Search page | "No resources selected" empty Search page (no TrainJob) |
| 15 | autorag `01-autorag-page.png` | AutoRAG page listing optimization runs | "Configure a pipeline server" empty state |
| 16 | maas-multi-provider-passthrough `02-external-models-tab.png` | External models tab, claude-sonnet Ready | API keys page + "No API keys" empty state + welcome modal — wrong page entirely |
| 17 | model-registry-catalog `03-model-transfer-jobs.png` | Transfer-jobs table with names/namespaces/statuses | "No model transfer jobs" empty state |
| 18 | llama-stack-ogx-core `01-ogx-operator-installed.png` | OGX Operator in Installed Operators view | Console "404: Page Not Found" (project redhat-ods-operator) |
| 19 | mlflow-experiment-tracking `02-experiment-overview.png` | demo-experiment overview with run statistics, logged params, metric charts | GenAI **Usage** tab: "Traces 0", "No data available for the selected time range", empty latency/error panels |
| 20 | gateway-api-rhcl `02-gateways-status.png` | Verify: created Gateway reports Resource accepted / programmed | Gateways list view with 3 pre-existing platform Gateways (data-science, maas-default, openshift-ai-inference) — the created Gateway is not shown |

## Moderate (1)

| Workshop / file | Issue |
|---|---|
| maas-vllm-deployment `02-deploy-model-wizard.png` | Wizard shows the **"LLM inference service"** deployment method selected; this workshop deploys the legacy vLLM path, which requires the **"Inference service"** radio (the one the prose contrasts against) |

## Minor (4)

| Workshop / file | Issue |
|---|---|
| gateway-api-rhcl `01-installed-operators-kuadrant.png` | Right page (kuadrant-system Installed Operators) but Connectivity Link operator is NOT visible in the list (Agent Sandbox, Authorino, AWS EFS, Cluster Observability, DNS only) |
| llmd-kv-cache-tiering `01-llmd-topology-configurations.png` | Prose says "note the columns shown" — the empty-state image shows no columns (same file is correct in llmd-core, whose prose says the table is empty) |
| llminferenceservice-config `02-deployed-models-llminferenceservice.png` | Right deployments list, but the claimed "Ready status badge" is not visible (no status column in frame) |
| llminferenceservice-config `03-deploy-wizard-llmd-multinode.png` | Alt says "Multi-node topology option enabled"; image shows **Single node** selected |

## Borderline-acceptable (4) — no action

Empty states that the alt-text/prose explicitly documents: llmd-latency-routing and
llmd-lora-routing routing-configurations, llmd-core topology-configurations,
mcp-lifecycle-operator deployments tab.

## Root causes

1. **Bulk capture session captured whatever state the browser was in** — welcome tour modals,
   loading spinners, 404s and OAuth error pages shipped unreviewed.
2. **Files copy-pasted across sibling workshops** (agents-mcp, model-serving families) — one bad
   capture propagates to 2-3 embeds; the 404 and wizard-modal files each cover 2-3 workshops.
3. **No alt-text vs pixels check** — several alt-texts honestly describe the intended image, so a
   text-only review passes while the pixels are wrong.
4. **Cluster-state drift** — some states (MCP catalog settings page, workloads API, transfer jobs)
   don't exist in the current build, so the capture can never match.

## Recommended actions

**RESOLVED 2026-09-30 (dispositions of each of the 25):**

Re-captured live (11):
- agent-catalog-ai-hub `01-model-catalog-page.png` — the real AI hub → Agents catalog (agentsCatalog flag enabled on the cluster first, per the workshop's own Exercise 2); alt-text corrected
- ai-available-assets `01-ai-asset-endpoints-page.png` — populated endpoints page (project abc123-user1, qwen25-05b Ready)
- ai-available-assets `02-models-tab.png` — Models tab with the deployed models
- maas-llmd-deployment `01-deploy-wizard-llmd.png` — wizard with "LLM inference service with llm-d" selected
- rhai-fast-release-images `02-wizard-fast-runtime.png` — wizard with the fast-1 runtime (Limited support + fast-1 badges); the workshop's vllm-fast-1 runtime template was created on the cluster (OpenShift Template in redhat-ods-applications — the wizard lists Templates, not ServingRuntime CRs)
- vllm-cpu-ibm-z-power `01-deploy-model-wizard.png` — wizard with vLLM CPU (x86) runtime selected
- maas-vllm-deployment `02-deploy-model-wizard.png` — wizard with "Inference service" selected
- rhai-fast-release-images `01-serving-runtime-badges.png` — Serving runtimes page with Pre-installed/version badges
- gateway-api-rhcl `01-installed-operators-kuadrant.png` — kuadrant-system Installed Operators with Red Hat Connectivity Link (required a taller viewport: the console table virtualizes)
- gateway-api-rhcl `02-gateways-status.png` — Gateways view with the created ingress-gateway (workshop resource re-created in abc123-gateway; Programmed=False matches the content's own RHDP note — no LoadBalancer hostname)
- llama-stack-ogx-core `01-ogx-operator-installed.png` — redhat-ods-applications Installed Operators with the OpenShift AI operator (OGX's carrier); alt-text corrected (no separate OGX Operator CSV exists in this build)

Removed + `// TODO(screenshot)` with drift reasons (11):
- ai-available-assets `01-mcp-servers-tab.png` — needs a published GitHub MCP server + playground MCP config (none deployed)
- openshell-agent-sandboxing + view-agent-deployments (2 files) — need the Agent Sandbox operator (not installed)
- mcp-catalog-admin `01-mcp-catalog-settings.png` — the settings page 404s in the 3.5.1 build
- validated-tool-calling-config `01-validated-arguments-panel.png` — the model details Validated Arguments/Tool Calling panel does not exist in this build (catalog filter does); prose flagged for review
- kueue `02-workload-conditions.png` — kueue admission webhook does not create Workloads here (LocalQueue/ClusterQueue applied, job ran, no Workload CR)
- kubeflow-trainer-v2 `02-trainjob-console-search.png` — no TrainJob CRD installed
- autorag `01-autorag-page.png` — environment GC'd; re-run blocked on upstream driver image
- maas-multi-provider-passthrough `02-external-models-tab.png` — needs Anthropic credentials
- model-registry-catalog `03-model-transfer-jobs.png` — no transfer jobs exist
- mlflow-experiment-tracking `02-experiment-overview.png` — MLflow demo environment GC'd

Alt-text/prose corrections (3):
- llminferenceservice-config module-02 alt — removed the unverifiable "Ready status badge" claim
- llminferenceservice-config module-03 alt — describes the actual wizard state (Single node selected, Multi-node available)
- llmd-kv-cache-tiering prose — no longer asks the learner to "note the columns shown" in an empty state

Residual prose drifts — RESOLVED 2026-09-30 (all three rewritten to match the shipped UI):
- validated-tool-calling-config Exercise 2 + module summary — now uses the catalog's *Validated arguments* > *Tool calling* filter and the model-labels verification; TODO notes the panel can be restored when it ships
- gateway-api-rhcl module-02 Verify — now documents both states: `Programmed=True` on LoadBalancer clusters and `Accepted=True`/`Programmed=False` (AddressNotAssigned) on the RHDP workshop cluster, with the Route exposure path
- llama-stack-ogx-core module-01 — now states OGX ships as a component of the OpenShift AI operator (no separate OGX operator CSV); conceptual "OGX Operator" references retained where accurate

Alt-text comma note: AsciiDoc splits block attributes on commas, so comma-containing alt-texts
render truncated in the built site — the three new comma-bearing alts were rewritten comma-free
(rebuilt and verified in the rendered HTML; spot-check: qa/spotcheck-agent-catalog-page.png).

- Anti-recurrence (DONE): the screenshot QA gap is fixed in the skills — quality-enrichment
  Phase 2 step 7 (content-match audit, +4 triage signal, WRONG/STALE verdicts, hash-dedup per
  embed), workshop-screenshot step 4 (final URL/title + pixel verification, rejecting 404/error/
  modal/empty captures), and a Content Correctness rule in WORKSHOP-COMMON-RULES Section 2.
- Re-capture requires dashboard auth: the workshop Keycloak (rhbk realm, admin creds) works for
  both dashboard and console via playwright-cli.
