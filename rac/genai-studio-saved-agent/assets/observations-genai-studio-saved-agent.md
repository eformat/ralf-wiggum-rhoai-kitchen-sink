# Observations: Gen AI Studio Saved Agents (doc-derived)

## Summary

Gen AI Studio saved agents is RHOAI 3.5's Developer Preview configuration-
persistence feature for the gen AI playground: a saved agent captures a complete
playground configuration — model selection, inference parameters, MLflow prompt
reference, RAG knowledge sources, and MCP server connections — as a single named
object scoped to the project namespace, stored as Kubernetes resources. This
observation document was produced from the official RHOAI 3.5 product
documentation (Experimenting with models in the gen AI playground, Chapter 15;
RHOAI 3.5 release notes, "Configuration persistence for Gen AI Studio") because
no live demo cluster was available at authoring time. Every item below is doc
evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | genai-playground.txt | Ch. 15 intro | Saved agents is a Developer Preview feature only; a saved agent captures model selection, inference parameters, MLflow prompt reference, RAG knowledge sources, and MCP server connections; chat history, guardrail settings, and credential values are not included |
| 2 | genai-playground.txt | Ch. 15 intro | Agents are stored as Kubernetes resources in the project namespace; all project members can view and load agents for that namespace; browse from the Agents tab on the AI asset endpoints page; loading validates referenced resources and warns about missing ones |
| 3 | genai-playground.txt | §15.1 Save a playground agent | Prerequisites: configured playground, at least one model selected, `agentConfigManagement` DP flag enabled; Save agent dialog displays a config summary; unsaved-changes indicator; conflict warning path uses Save as new agent; guardrail settings excluded |
| 4 | genai-playground.txt | §15.2 Load a saved agent | Load agent dialog shows a table of saved agents in the current project; alternative path: Agents tab → Try in Playground; verification is restored settings matching the saved agent |
| 5 | genai-playground.txt | §15.3 Manage saved agents | Save as new agent creates variant copies (original unchanged); rename via Edit dialog; delete from the Agents tab with confirmation, permanently removed from the namespace; Clear agent resets the playground |
| 6 | ai-available-assets-release-notes.txt | Configuration persistence for Gen AI Studio | 3.5 release-notes entry: save with name and description, load to restore all captured settings, Save as new agent for variants, browse/rename/delete from the Agents tab, validation on load detects deleted or unavailable referenced resources; enabled via the `agentConfigManagement` dashboard configuration option |

## User Flows

### Flow 1: Enable and locate the feature

1. **Check flags** — `oc get odhdashboardconfig odh-dashboard-config -n redhat-ods-applications -o jsonpath` for `agentConfigManagement` and `genAiStudio` (§15.1 prerequisites; release notes)
2. **Enable** — set the `agentConfigManagement` dashboard configuration option to `true` (release notes)
3. **Locate UI** — playground header menu (Save agent, Load agent, Save as new agent, Clear agent) and the Agents tab under Gen AI studio → AI asset endpoints (§15.1–15.3)

### Flow 2: Save, load, manage agents

1. **Save** — configure the playground → header menu → Save agent → name/description → Save; agent name appears in the playground header (§15.1)
2. **Load** — header menu → Load agent (table of project agents), or Agents tab → Try in Playground; all captured settings restored (§15.2)
3. **Manage** — Save as new agent for variants; Edit for rename/description; Delete from the Agents tab; Clear agent from the header menu (§15.3)

## Features and Concepts

### OpenShift Platform
- Dashboard feature flags via the `OdhDashboardConfig` custom resource in `redhat-ods-applications`; Kubernetes resources scoped to project namespaces

### RHOAI / AI Platform
- Gen AI Studio playground, saved agents (Developer Preview, `agentConfigManagement` flag), Agents tab on the AI asset endpoints page, MLflow prompt references

### AI/ML Fundamentals
- Reusable agent configurations: model + inference parameters + prompt + RAG knowledge sources + MCP server connections; variant experiments from a baseline configuration

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: ML practitioners with gen AI playground working knowledge
- **Prerequisite knowledge**: playground basics, `oc` CLI basics
- **Estimated duration**: 30–60 minutes
- **Cluster requirements**: RHOAI 3.5 with Gen AI Studio enabled; cluster admin privileges for the `OdhDashboardConfig` flag patch; MLflow service available in the project

## Open Questions

- Exact `Gen AI studio → AI asset endpoints` menu label on a live console (doc-derived path)
- The saved-agent Kubernetes resource kind and API group are not named in the docs; confirm in a live cluster before Act-phase CLI testing
