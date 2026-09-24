# Observations: OpenClaw agent starter kit (doc-derived)

## Summary

OpenClaw agent starter kit is a Developer Preview feature of RHOAI 3.5 that
lets you deploy and manage OpenClaw, an open-source general-purpose agent, on
Red Hat OpenShift AI using validated Kustomize manifests and an automated
installer that manages runtime concerns and optimizes workspace persistence.
This observation document was produced from the official RHOAI 3.5 release
notes extracted text because no live demo cluster was available at authoring
time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §4 Developer Preview Features — OpenClaw agent starter kit | Deploy and manage OpenClaw via validated Kustomize manifests or the automated OpenClaw installer; installer manages runtime concerns and optimizes workspace persistence |
| 2 | ai-available-assets-release-notes.txt | §4 OpenClaw agent starter kit — capability list | Seven capabilities: deployment (Kustomize/installer), model connection (vLLM via OGX, OpenAI-compatible API), observability (MLflow via diagnostics-otel), access control (OAuth proxy + OpenShift RBAC), persistence, validation (compatibility matrix + troubleshooting guide), security (restricted-v2 SCC) |
| 3 | ai-available-assets-release-notes.txt | §3 OpenCode coding agent deployment and operation | OpenCode is the first coding agent validated to follow the onboarding pattern established by OpenClaw; confirms agent platform operators, vLLM and OGX (formerly Llama Stack) inference backends, and MLflow tracing generalize to coding workloads |
| 4 | ai-available-assets-release-notes.txt | §4 Claude Code agent starter kit | Parallel starter kit pattern (Containerfile + Kustomize manifests) for the Anthropic Claude Code agent, confirming the starter-kit onboarding family |

## User Flows

### Flow 1: Deploy OpenClaw via the starter kit (doc-described, not UI-verified)

1. **Choose a deployment option** — validated Kustomize manifests (declarative, inspectable) or the automated OpenClaw installer (fastest path; manages runtime concerns) (§4)
2. **Connect the agent to models** — self-hosted models through vLLM via the OGX inference gateway with an OpenAI-compatible API (§4)
3. **Access the agent** — browser-based access enforced through the OAuth proxy, backed by OpenShift RBAC (§4)
4. **Observe behavior** — model calls, tool executions, and context assembly spans captured in MLflow via the diagnostics-otel plugin with native OpenTelemetry tracing (§4)

### Flow 2: Operate and validate (doc-described)

1. **Persistence** — workspace storage is maintained across pod restarts (§4)
2. **Security posture** — workloads run under the OpenShift restricted-v2 SCC (§4)
3. **Validate the environment** — included model compatibility matrix and troubleshooting guide (§4)

## Features and Concepts

### OpenShift Platform
- Routes, OAuth proxy integration, OpenShift RBAC as the access-control backend, restricted-v2 security context constraint

### RHOAI / AI Platform
- OpenClaw agent starter kit (validated Kustomize manifests + automated installer), OGX inference gateway (formerly Llama Stack), diagnostics-otel plugin, MLflow tracing integration, model compatibility matrix and troubleshooting guide

### AI/ML Fundamentals
- General-purpose agents, self-hosted model serving through vLLM, OpenAI-compatible APIs, OpenTelemetry tracing spans (model calls, tool executions, context assembly)

## Workshop Potential

- **Estimated modules**: 2 (getting started / capabilities tour → hands-on / operations tour)
- **Target audience**: platform engineers and agent operators with OpenShift working knowledge
- **Prerequisite knowledge**: OpenShift basics; no model-serving depth required (docs reference vLLM/OGX as the connection path)
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI operator installed; RHOAI 3.5 installed
- **Honest-lab note**: the release notes document capabilities but not commands; only connection-check and pod-observation commands can be grounded without fabrication

## Open Questions

- Exact commands and manifest contents for both deployment options (release notes defer to the OpenClaw Agentic Starter Kit documentation, not extracted here)
- Whether the model compatibility matrix lists specific validated models (not enumerated in the extracted text)
- MLflow trace visibility location (dashboard vs MLflow UI) on a live cluster — doc evidence does not include console navigation
