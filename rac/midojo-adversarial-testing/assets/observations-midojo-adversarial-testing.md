# Observations: MiDojo adversarial testing engine (doc-derived)

## Summary

MiDojo is RHOAI 3.5's man-in-the-middle adversarial testing execution engine
for AI agents, available as a Developer Preview feature. It intercepts
communications at the tool layer, injecting attack payloads into tool responses
while forwarding legitimate calls upstream, and grades each execution on task
completion (utility) and attack resistance (security). This observation
document was produced from the official RHOAI 3.5 release notes because no live
demo cluster or MiDojo deployment was available at authoring time. Every item
below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §Chapter 4 Developer Preview Features — MiDojo adversarial testing execution engine | MiDojo is a man-in-the-middle adversarial testing execution engine for AI agents, available as a Developer Preview feature |
| 2 | ai-available-assets-release-notes.txt | §Chapter 4 — MiDojo | Intercepts communications at the tool layer, injecting attack payloads into tool responses while forwarding legitimate calls upstream; test agents against realistic attack scenarios without rebuilding infrastructure or modifying the agent |
| 3 | ai-available-assets-release-notes.txt | §Chapter 4 — MiDojo | Declarative YAML format authors scenarios covering environment state, tasks, and injection vectors; payloads can be delivered in prompts, data sources, or tool responses |
| 4 | ai-available-assets-release-notes.txt | §Chapter 4 — MiDojo | Executes combinations of legitimate and injection tasks to grade task completion (utility) and attack resistance (security), recording the full tool trace |
| 5 | ai-available-assets-release-notes.txt | §Chapter 4 — MiDojo | This release supports custom external suites, pluggable backends, Kubernetes-native deployment, a reference MiniBank suite, and multiple agent protocols (A2A, OGX, PI, OpenAI Responses API, Simple HTTP) |

## User Flows

### Flow 1: Test an agent with MiDojo (doc-described, not UI-observed)

1. **Author or choose a suite** — write a custom external suite in the
   declarative YAML format or start from the reference MiniBank suite (mock
   banking domain: accounts, balances, transactions)
2. **Point the suite at an agent** — select the protocol the agent speaks
   (A2A, OGX, PI, OpenAI Responses API, or Simple HTTP)
3. **Run the session** — MiDojo's Kubernetes-native deployment executes
   combinations of legitimate and injection tasks, with payloads delivered in
   prompts, data sources, or tool responses
4. **Read the graded run** — two grades per execution: utility (did the agent
   still complete its legitimate task?) and security (did it resist the
   injected payload?), plus the full tool trace for diagnosis

## Features and Concepts

### OpenShift Platform
- Kubernetes-native deployment of MiDojo in the same cluster as the agents under test

### RHOAI / AI Platform
- MiDojo adversarial testing execution engine (Developer Preview), custom external suites, reference MiniBank suite, pluggable backends, multiple agent protocols (A2A, OGX, PI, OpenAI Responses API, Simple HTTP)

### AI/ML Fundamentals
- Agent security testing at the tool layer (man-in-the-middle injection), dual utility/security grading, full tool trace auditing, injection vectors (prompts, data sources, tool responses)

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics; a model serving endpoint is required
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 installed with the RHOAI operator present; MiDojo is DP, so no deployment interface is documented — a guided-tour lab only

## Open Questions

- Actual MiDojo deployment interface and CR/API shape (doc evidence describes capabilities only, no deployment steps)
- Availability of the MiniBank reference suite and protocol endpoints in workshop clusters (prerequisite for any Act-phase hands-on extension)
