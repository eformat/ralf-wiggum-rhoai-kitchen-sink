# Observations: AI Available Assets page (doc-derived)

## Summary

The AI Available Assets page is a new RHOAI 3.5 dashboard page that enables AI
engineers and application developers to view and consume deployed AI resources
within their projects. In the dashboard it appears as *Gen AI studio → AI asset
endpoints* and lists the models and Model Context Protocol (MCP) servers of the
selected project. This observation document was produced from the official RHOAI
3.5 product documentation (Experimenting with models in the gen AI playground;
Deploying models; Working with the model catalog; Release notes; Getting started;
Connected apps) because no live demo cluster was available at authoring time.
Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-genai-playground.txt | §2.3 About the AI assets endpoints page | Central dashboard for managing generative AI assets available in your project; two categories — Models and Model Context Protocol (MCP) Server; primary purpose is a starting point for using the assets (e.g. *Add to playground*); marked Technology Preview in this doc |
| 2 | ai-available-assets-genai-playground.txt | §3 Configure a playground for your project | Two entry paths to the Configure playground dialog: Gen AI studio → Playground → Create playground, or Gen AI studio → AI asset endpoints → Models tab → Add to playground; per-model Type dropdown (Inference/Embedding); optional *Enable tracing* toggle gated on the `genAiTracing` feature flag |
| 3 | ai-available-assets-genai-playground.txt | §4 Enable custom endpoints for the playground | `OdhDashboardConfig` flags: `dashboardConfig.aiAssetCustomEndpoints` (default false), `genAiStudioConfig.aiAssetCustomEndpoints.externalProviders` (default false, requires the dashboardConfig flag), `clusterDomains` (additional internal domains; `.svc.cluster.local` always internal) |
| 4 | ai-available-assets-genai-playground.txt | §5 Create and use custom endpoints in the playground | Create endpoint form fields: model type (Inferencing/Embedding/Transcription), capabilities, model ID, display name, embedding dimensions, endpoint URL, API key/token (stored as a project-level Secret), Verify model, use case; custom endpoints is Technology Preview only |
| 5 | ai-available-assets-deploying-models.txt | §Deploy model wizard, Advanced settings | Optional *Add as AI asset endpoint* checkbox (generative AI models only) adds the model's endpoint to the Gen AI studio → AI asset endpoints page; model must be added as an AI asset endpoint to be tested on the playground page |
| 6 | ai-available-assets-model-catalog.txt | Model catalog and model registries | AI hub model catalog as the discovery surface for models to register, deploy, and customize — upstream source for project deployments |
| 7 | ai-available-assets-release-notes.txt | §2 Enhancements | "AI Available Assets page for deployed models and MCP servers": filterable UI listing available models and MCP servers in the selected project, with permission-gated access to identify accessible endpoints and integrate into the AI Playground |
| 8 | ai-available-assets-release-notes.txt | §3 Developer Preview | "AI Available Assets integration with Model-as-a-Service (MaaS)": MaaS models consumable from the AI Available Assets page; a MaaS-marked model becomes global and visible across all projects. "Additional fields added to Model Deployments": Use Case and Description free-form text plus an *Add to AI Assets* checkbox that publishes the model and its metadata |
| 9 | ai-available-assets-getting-started.txt | §1–2 | Data science workflow orientation and log-in/component-view procedures that the workshop's Getting Connected bookend mirrors |

## User Flows

### Flow 1: Discover assets on the AI asset endpoints page

1. **Navigate** — Gen AI studio → AI asset endpoints (§2.3)
2. **Select project** — assets are scoped to the currently selected project (§2.3)
3. **Browse categories** — Models tab (deployed assets, custom endpoints, MaaS) and MCP servers tab (§2.3)

### Flow 2: Publish an MCP server at the platform level

1. **Create ConfigMap** — `gen-ai-aa-mcp-servers` in `redhat-ods-applications`, one JSON entry per server (url + description) keyed by case-sensitive unique display name (§Configuring Model Context Protocol servers)
2. **Apply** — `oc apply -f gen-ai-aa-mcp-servers.yaml`; verify with `oc get configmap ... -o yaml | grep`
3. **Consume** — server entry appears in the MCP servers tab and is available in playground sessions

### Flow 3: Deploy a model as an AI asset endpoint

1. **Open deploy wizard** — Projects → Deployments → Deploy model (deploying-models doc)
2. **Model location + type** — OCI/S3/URI, Generative AI model (deploying-models doc)
3. **Advanced settings** — select *Add as AI asset endpoint*, enter use case (§Advanced settings)
4. **Verify** — `oc get inferenceservice` shows `Successful`/`True`; model appears on the Models tab

### Flow 4: Consume an asset from the page

1. **Add to playground** — Models tab → Add to playground → Configure playground dialog (§3)
2. **Configure** — per-model Type (Inference/Embedding); optional *Enable tracing* (gated on `genAiTracing`) (§3)
3. **Use** — playground loads with chat area and Configure panel; prompt receives a response from the asset endpoint

## Features and Concepts

### OpenShift Platform
- ConfigMaps (`gen-ai-aa-mcp-servers`), namespaces (`redhat-ods-applications`), Secrets (endpoint credentials), InferenceServices (model serving CRDs)

### RHOAI / AI Platform
- AI Available Assets page (Gen AI studio → AI asset endpoints), Models and MCP Server categories, OdhDashboardConfig (`dashboardConfig.aiAssetCustomEndpoints`, `genAiStudioConfig`), `genAiTracing` feature flag, MaaS integration, deployment metadata fields (Use Case, Description, Add to AI Assets)

### AI/ML Fundamentals
- Inference vs embedding vs transcription model types, MaaS, custom endpoints to external providers (OpenAI, Anthropic, AWS), RAG context and MCP tool results as data egress concerns

## Workshop Potential

- **Estimated modules**: 2 (discover → publish and consume)
- **Target audience**: AI engineers and application developers; cluster-administrator privileges needed for the MCP server and custom endpoint exercises
- **Prerequisite knowledge**: RHOAI dashboard navigation, `oc` CLI basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with dashboard accessible, RHOAI operator installed, a generative AI model in an OCI registry or S3-compatible store

## Open Questions

- The gen AI playground docs mark the AI asset endpoints page as Technology Preview while the feature matrix records GA — confirm the actual 3.5 support tier (doc conflict)
- Exact `Agents tab` behavior on the AI asset endpoints page (playground docs mention agents saved to and loaded from the page) — outside current workshop scope
- MaaS integration is Developer Preview; the workshop lists MaaS models as a category source but does not exercise enabling the MaaS toggle
