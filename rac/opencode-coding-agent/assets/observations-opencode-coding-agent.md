# Observations: OpenCode coding-agent deployment (doc-derived)

## Summary

OpenCode coding-agent deployment is a RHOAI 3.5 Technology Preview feature:
OpenCode is an open-source, terminal-based coding agent, and the first coding
agent validated to follow the onboarding pattern established by OpenClaw. This
observation document was produced from the extracted RHOAI 3.5 documentation
text (release notes — OpenCode TP section; Customize Models for Gen AI and
Agentic AI Applications; Working in your data science IDE) because no live demo
cluster was available at authoring time. Every item below is doc evidence, not
UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | OpenCode coding agent deployment and operation (TP) | OpenCode is open-source and terminal-based; first coding agent validated on the OpenClaw onboarding pattern; validation confirms agent platform operators, vLLM and OGX (formerly Llama Stack) inference backends, and MLflow tracing integration generalize to coding workloads |
| 2 | ai-available-assets-release-notes.txt | OpenCode coding agent deployment and operation (TP) | Validation provides: supported container images, operator-managed deployment manifests, verified inference backend interoperability, MLflow tracing integration |
| 3 | opencode-customize-models.txt | §7.1 Generate complete responses | OpenAI-compatible connection model: model endpoint URL, API key, and model name; `NO_API_KEY` sentinel for endpoints without authentication (common with local vLLM); works with vLLM on Red Hat OpenShift AI, OpenAI, Azure OpenAI, or a local vLLM instance |
| 4 | opencode-data-science-ide.txt | §1 Access your workbench IDE | Workbench IDE access flow: dashboard → Projects → project name → Workbenches tab → start if stopped → open icon; verification is a new browser window for the IDE |
| 5 | opencode-data-science-ide.txt | §2 Working in JupyterLab | JupyterLab terminal available via File → New → Terminal; shell commands run inside the workbench container |
| 6 | ai-available-assets-release-notes.txt | RHOAI MCP section | MCP server tooling supports coding assistants such as Claude Code, OpenCode, and Gemini CLI |

## User Flows

### Flow 1: Deploy and operate OpenCode (doc level only)

1. **Validation building blocks** — agent platform operators manage the deployment lifecycle; vLLM and OGX backends serve the model; MLflow tracing captures model calls and tool executions (source 1)
2. **Deliverables** — supported container images, operator-managed deployment manifests, verified inference backend interoperability, MLflow tracing integration (source 2)
3. **Note** — the 3.5 documentation set has no step-by-step deployment procedure for OpenCode; deployment specifics come from the OpenClaw starter-kit pattern (Kustomize manifests, OpenAI-compatible API through the OGX gateway, OpenTelemetry tracing into MLflow)

### Flow 2: Connect to an OpenAI-compatible endpoint

1. **Gather parameters** — endpoint URL, API key, model name (source 3)
2. **Handle unauthenticated endpoints** — `NO_API_KEY` sentinel for local vLLM (source 3)
3. **Probe** — `GET /models` against the endpoint; validated backends answer the OpenAI-compatible probe

### Flow 3: Access the workbench IDE

1. **Navigate** — dashboard → Projects → project → Workbenches tab (source 4)
2. **Start if stopped** — Status column: Stopped → Starting → Running (source 4)
3. **Open** — open icon launches the IDE in a new browser window (source 4)
4. **Operate** — terminal inside the IDE is where a terminal-based agent runs (source 5)

## Features and Concepts

### OpenShift Platform
- Workbench IDEs (JupyterLab, code-server) as the shell home for terminal-based agents; OpenShift routes and service endpoints

### RHOAI / AI Platform
- OpenCode coding-agent deployment (TP), agent platform operators, external model endpoints view, MLflow tracing integration, MCP server tooling for coding assistants

### AI/ML Fundamentals
- OpenAI-compatible API as the lingua franca for agent inference backends; agent observability (model calls, tool executions, context assembly spans)

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and AI practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: `oc` CLI basics, workbench IDE concepts
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with the RHOAI operator installed and an LLM serving endpoint (vLLM or OGX) available

## Open Questions

- Exact *External models* tab location and menu labels on a live 3.5 console (doc-derived path)
- Detailed OpenCode starter-kit documentation is expected to follow the release-notes coverage; on publication, real deployment exercises should be added (Act phase)
