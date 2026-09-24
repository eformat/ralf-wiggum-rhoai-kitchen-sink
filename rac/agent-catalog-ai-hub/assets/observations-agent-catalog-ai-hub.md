# Observations: Agent Catalog in AI Hub (doc-derived)

## Summary

The Agent Catalog in AI Hub is RHOAI 3.5's Developer Preview interface for
discovering and exploring agent starter kits on OpenShift AI: a centralized,
pre-loaded catalog of starter kits built on LangGraph, CrewAI, LlamaIndex, and
other agentic frameworks, gated behind the `agentsCatalog` dashboard feature
flag. This observation document was produced from the official RHOAI 3.5
release notes because the feature is Developer Preview and documented only in
the release notes — no full doc page, and no live demo cluster was available at
authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | Agent Catalog in AI Hub for agent starter kit discovery | Centralized interface for discovering and exploring agent starter kits as a Developer Preview |
| 2 | ai-available-assets-release-notes.txt | Agent Catalog in AI Hub for agent starter kit discovery | Browsing: view each agent's description, filter by framework, use text search to find agents for a specific use case |
| 3 | ai-available-assets-release-notes.txt | Agent Catalog in AI Hub for agent starter kit discovery | Each catalog entry displays the agent's description, framework, and a README file with additional information about the agent |
| 4 | ai-available-assets-release-notes.txt | Agent Catalog in AI Hub for agent starter kit discovery | The catalog ships pre-loaded with agent starter kits built on LangGraph, CrewAI, LlamaIndex, and other agentic frameworks |
| 5 | ai-available-assets-release-notes.txt | Agent Catalog in AI Hub for agent starter kit discovery | Enablement: set the `agentsCatalog` feature flag to `true`; access via *AI hub → Agents* in the OpenShift AI dashboard |

## User Flows

### Flow 1: Enable and open the catalog

1. **Set the flag** — set the `agentsCatalog` feature flag to `true` (release notes; the workshop locates this on the `OdhDashboardConfig` custom resource)
2. **Open the catalog** — from the OpenShift AI dashboard, click *AI hub → Agents*
3. **Survey** — the catalog ships pre-loaded with agent starter kits built on LangGraph, CrewAI, LlamaIndex, and other agentic frameworks

### Flow 2: Discover an agent starter kit

1. **Browse** — view each agent's description in the catalog list
2. **Narrow** — filter by framework or use text search to find agents for a specific use case
3. **Evaluate** — open a catalog entry to read its description, framework, and README file with additional information about the agent

## Features and Concepts

### OpenShift Platform
- Dashboard feature flags on the `OdhDashboardConfig` custom resource (`redhat-ods-applications` namespace), controlled by the OpenShift AI operator

### RHOAI / AI Platform
- Agent Catalog in AI Hub (Developer Preview), `agentsCatalog` dashboard feature flag, pre-loaded agent starter kits, *AI hub → Agents* navigation

### AI/ML Fundamentals
- Agentic frameworks (LangGraph, CrewAI, LlamaIndex), agent starter kits as adoption units with README-based evaluation

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on guided tour)
- **Target audience**: platform engineers and AI practitioners with cluster administrator access
- **Prerequisite knowledge**: OpenShift CLI basics, RHOAI dashboard familiarity
- **Estimated duration**: 30–45 minutes
- **Cluster requirements**: RHOAI 3.5 installed with the OpenShift AI dashboard (AI Hub) accessible

## Open Questions

- Exact contents of the pre-loaded starter kit list on a live 3.5 console (release notes name only the frameworks)
- Whether the framework filter values mirror the framework names or a different taxonomy (doc-derived)
- Whether the `agentsCatalog` flag name persists across releases (Developer Preview contract)
