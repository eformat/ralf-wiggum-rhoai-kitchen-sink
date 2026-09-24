# Observations: Claude Code agent starter kit (doc-derived)

## Summary

The Claude Code agent starter kit is a Developer Preview feature of RHOAI 3.5
that lets you deploy and configure the Anthropic Claude Code agent on Red Hat
OpenShift AI using a pre-configured Containerfile and Kustomize deployment
manifests. This observation document was produced from the official RHOAI 3.5
release notes (Developer Preview Features chapter) because the feature is
documented only in release notes and no live demo cluster was available at
authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | Ch. 4 Developer Preview Features — Claude Code agent starter kit | Kit provides a Containerfile and Kustomize deployment manifests to streamline setup in a secure environment |
| 2 | ai-available-assets-release-notes.txt | Ch. 4 — validated inference paths | Three paths: direct Anthropic API, self-hosted models through vLLM, vLLM through the OGX gateway (own models without an Anthropic subscription) |
| 3 | ai-available-assets-release-notes.txt | Ch. 4 — observability | Observe and track tool calls, token usage, and agent execution traces using built-in MLflow tracing integration |
| 4 | ai-available-assets-release-notes.txt | Ch. 4 — extensibility | Inject modular skills and Model Context Protocol (MCP) server configurations at deploy time through a ConfigMap without rebuilding container images |
| 5 | ai-available-assets-release-notes.txt | Ch. 4 — persistence and security | Workspace storage maintained across pod restarts; workloads run under the OpenShift restricted-v2 SCC with no special security grants required |
| 6 | ai-available-assets-release-notes.txt | Ch. 4 — further reading | "For more information, see Claude Code Agentic Starter Kit" (upstream kit documentation) |

## User Flows

### Flow 1: Deploy the agent from the starter kit

1. **Use the kit** — pre-configured Containerfile + Kustomize deployment manifests, no bespoke image builds (§1)
2. **Choose a validated inference path** — direct Anthropic API, self-hosted vLLM, or vLLM through the OGX gateway (§2)
3. **Run securely** — agent pod under the OpenShift restricted-v2 SCC with no special grants (§5)

### Flow 2: Configure the agent at deploy time

1. **Inject skills and MCP servers** — ConfigMap carries modular skills and MCP server configurations (§4)
2. **Redeploy** — configuration changes are a ConfigMap update plus a Kustomize redeploy, not a container image rebuild (§4)
3. **Observe behavior** — MLflow tracing records tool calls, token usage, and execution traces (§3)

## Features and Concepts

### OpenShift Platform
- Kustomize deployment manifests, ConfigMaps, security context constraints (restricted-v2 SCC), pod lifecycle and persistent workspace storage

### RHOAI / AI Platform
- Agentic starter kit as a Developer Preview feature, OGX inference gateway, built-in MLflow tracing integration, MCP server configuration injection

### AI/ML Fundamentals
- AI coding agents (Claude Code), Model Context Protocol (MCP), agent execution traces and token accounting

## Workshop Potential

- **Estimated modules**: 2 (getting started → guided-tour hands-on)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: OpenShift basics, `oc` CLI; Anthropic API access only needed for the direct inference path
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 installed; facilitator-deployed starter kit for pod observation

## Open Questions

- Exact Kustomize manifest contents and inference-path selection mechanism (release notes defer to the upstream Claude Code Agentic Starter Kit docs)
- MLflow tracing destination (server endpoint) for a deployed kit
- Whether the OGX-gateway path requires the model-serving platform enabled
