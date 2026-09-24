# Observations: OpenShell (Secure Agent Sandboxing and Policy Enforcement) (doc-derived)

## Summary

OpenShell is a Developer Preview feature of RHOAI 3.5 for secure agent onboarding
on OpenShift — an agent-aware sandboxing platform that provides policy-controlled,
isolated execution environments for AI agents, enforcing fine-grained restrictions
on system calls, network access, and tool availability. This observation document
was produced from the official RHOAI 3.5 product documentation (release notes
Developer Preview sections; the getting-started guide glossary) because no live
demo cluster was available at authoring time. Every item below is doc evidence,
not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §4.1 3.5 GA Developer Preview Features — Secure agent sandboxing and policy enforcement using OpenShell | Developer Preview of OpenShell available for secure agent onboarding on OpenShift; included guide covers Helm deployment, mTLS, LLM provider setup, isolated sandboxes, and controlled network egress; uses upstream artifacts; not supported for production; instructions in the agent-ops GitHub repository |
| 2 | ai-available-assets-release-notes.txt | §4.1 — View running agent deployments in the dashboard | Related DP feature surfaces agents deployed manually as OpenShell-managed Sandbox CRs; dashboard shows name and status of each deployed agent instance per namespace, with filtering capabilities |
| 3 | ai-available-assets-release-notes.txt | §4 Developer Preview support-scope preamble | DP features are subject to change or removal at any time, have received limited testing, and may lack documentation |
| 4 | ai-available-assets-getting-started.txt | Glossary — OpenShell | An agent-aware sandboxing platform providing policy-controlled, isolated execution environments; enforces fine-grained restrictions on system calls, network access, and tool availability |
| 5 | ai-available-assets-getting-started.txt | Glossary — agent sandbox | An isolated execution environment in which an AI agent runs with restricted access to system resources, network, and tools; contains the blast radius of unintended agent actions and enforces security boundaries between agent workloads and the host system |
| 6 | ai-available-assets-getting-started.txt | Glossary — Kata Containers; SPIFFE/SPIRE | Kata Containers (via OpenShift Sandboxed Containers) provide VM-level isolation for high-security agent workloads; SPIFFE/SPIRE provide platform-agnostic workload identity enabling mutual TLS and fine-grained authorization without static credentials |

## User Flows

### Flow 1: Observe OpenShell-managed agents in the dashboard

1. **Prerequisite** — an agent deployed manually in a namespace (release notes §4.1)
2. **Open the dashboard view** — view the list of running agent deployments
   directly in the RHOAI dashboard (release notes §4.1)
3. **Inspect** — see the name and status of each deployed agent instance in each
   namespace, with filtering capabilities to help manage deployed agents
4. **Identify** — manually deployed agents appear as OpenShell-managed Sandbox
   custom resources (CRs)

### Flow 2: Guided tour of the five guide areas (onboarding story)

1. **Helm deployment** — deploy the OpenShell components on OpenShift from upstream Helm artifacts (§4.1)
2. **mTLS** — encrypt and authenticate traffic between sandboxed agents and their backing services (§4.1; glossary SPIFFE/SPIRE workload identity)
3. **LLM provider setup** — connect sandboxed agents to the LLM provider they call (§4.1)
4. **Isolated sandboxes** — run each agent in a policy-controlled, isolated execution environment (§4.1; glossary agent sandbox)
5. **Controlled network egress** — restrict which network destinations a sandboxed agent can reach (§4.1)

## Features and Concepts

### OpenShift Platform
- Namespaces, workloads (`oc get pods` observation), dashboard console, Helm, mTLS workload identity (SPIFFE/SPIRE glossary entry)

### RHOAI / AI Platform
- OpenShell (agent-aware sandboxing platform, DP), OpenShell-managed Sandbox CRs, running agent deployments dashboard view (related DP feature), guardrails on MCP gateway tool calls as a complementary layer, Kata Containers via OpenShift Sandboxed Containers

### AI/ML Fundamentals
- Agent sandbox pattern: blast-radius containment and security boundaries for autonomous, tool-calling agents; defense-in-depth (sandbox-level vs tool-call-level vs VM-level enforcement)

## Workshop Potential

- **Estimated modules**: 2 (getting started guided tour → hands-on guided tour with observation)
- **Target audience**: platform engineers and security-minded RHOAI users with OpenShift working knowledge
- **Prerequisite knowledge**: OpenShift CLI basics, AI agent concepts
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 installed (RHOAI operator installed); an agent deployment (agents deployed manually appear as OpenShell-managed Sandbox CRs)
- **Lab shape**: guided tour (docs-first) — the release notes provide no inline deployment steps, so commands are limited to environment verification and namespace observation

## Open Questions

- Exact console location of the running agent deployments view on a live 3.5 dashboard (doc-derived description only)
- OpenShell resource names and Helm chart values (upstream artifacts; may change between releases)
- Whether the agent-ops GitHub repository instructions remain the canonical try-it-out path after GA
