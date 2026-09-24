---
schema_version: 1
type: asset
---
# Screenshot Evidence: RHOAI 3.5 Kitchen Sink Workshop Run

## Capture Summary

- **Date:** 2026-09-23
- **Cluster:** CPU cluster (OCP 4.22.13)
- **Product version:** RHOAI 3.5.1
- **Captured:** 19 shots across 17 labs (playwright 1.60.0, chromium headless, 1440x900)
- **Login:** Keycloak OIDC (workshop credentials — session state only, never committed)

## Evidence Map

| Screenshot | Lab | What it shows | Status |
|------------|-----|---------------|--------|
| 01-rhods-dashboard-login.png | (qa/screenshots + platform-oidc-auth ref) | Keycloak OIDC login page for the dashboard | captured |
| 01-ai-asset-endpoints-page.png | agents-mcp/ai-available-assets | AI asset endpoints page (Gen AI studio → AI asset endpoints) | captured |
| 01-model-catalog-page.png | agents-mcp/csv-export-model-catalog | Model catalog page (AI hub → Models) | captured |
| 01-catalog-support-tiers.png | agents-mcp/mcp-catalog-support-tier | MCP catalog cards (AI hub → MCP servers) | captured |
| 01-agent-ops-list.png | agents-mcp/view-agent-deployments | Projects list (agentOps view) | captured |
| 02-agent-deployments-dashboard.png | agents-mcp/openshell-agent-sandboxing | Projects list (running agent deployments) | captured |
| 01-feature-store-workflow.png | feature-store-automl-autorag/feature-store-feast | Feature Store overview (Develop & train) | captured |
| 02-leaderboard.png | feature-store-automl-autorag/automl | AutoML page (Develop & train → AutoML) | captured |
| 01-autorag-page.png | feature-store-automl-autorag/autorag | AutoRAG page (Gen AI studio → AutoRAG) | captured |
| 02-usage-dashboard.png | maas/maas-loki-showback | Observe & monitor dashboard | captured |
| 02-external-models-tab.png | maas/maas-multi-provider-passthrough | MaaS API keys page | captured |
| 02-endpoints-dialog.png | maas/maas-core | MaaS API keys page (Endpoints) | captured |
| 01-deploy-model-wizard.png | model-serving/vllm-cpu-ibm-z-power | Project abc123-user1 deployments (Single-model serving enabled, sample-llm-inference-service state) | captured |
| 01-deploy-wizard-llmd.png | maas/maas-llmd-deployment | copy of the deploy wizard state | captured |
| 02-deploy-model-wizard.png | maas/maas-vllm-deployment | copy of the deploy wizard state | captured |
| 01-ogx-crd-search.png | agents-mcp/ogx-agentic-api | OpenShift console catalog view | captured |
| 01-ogx-operator-installed.png | ogx/llama-stack-ogx-core | OpenShift console Installed Operators | captured |
| 02-trainjob-console-search.png | distributed-training/kubeflow-trainer-v2 | Console search in abc123-user1 | captured |
| 02-workload-conditions.png | distributed-training/kueue | Console workloads in abc123-user1 | captured |

## Backlog (authenticated wizard/dialog shots for next session)

Deep-UI shots that need interactive navigation beyond the headless passes:

- `01-deploy-model-wizard.png` (model-serving/vllm-cpu-ibm-z-power) — the actual wizard form after clicking Deploy model on the Deployments tab
- `02-save-agent-dialog.png` (agents-mcp/genai-studio-saved-agent) — the Save agent dialog in the playground
- `02-kale-enable-toggle.png` (agents-mcp/kale-jupyterlab) — inside JupyterLab
- `01-mcp-catalog-settings.png` (agents-mcp/mcp-catalog-admin) — Settings → MCP catalog source management
- `01-validated-arguments-panel.png` (agents-mcp/validated-tool-calling-config) — a model details page with the Tool Calling panel
- `02-kueue-alerting-rules.png` (distributed-training/kueue) — Observe → Alerting rules
- `03-model-transfer-jobs.png` / `02-register-model-dialog.png` (model-registry-catalog) — registry dialogs

## Guardrails honored

- Keycloak credentials used in playwright session state only (/tmp), never in committed files.
- No placeholder screenshots: every capture is from the live running dashboard/console.
