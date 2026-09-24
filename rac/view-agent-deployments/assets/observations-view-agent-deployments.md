# Observations: View Running Agent Deployments in the Dashboard (doc-derived)

## Summary

Viewing running agent deployments in the dashboard is a RHOAI 3.5 Developer
Preview feature: the dashboard lists agents deployed manually as
OpenShell-managed Sandbox custom resources (CRs), showing the name and status of
each deployed agent instance per namespace with filtering capabilities. This
observation document was produced from the official RHOAI 3.5 product
documentation (release notes; Managing resources — dashboard configuration
table) because no live demo cluster was available at authoring time. Every item
below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §4.1 3.5 GA Developer Preview features → "View running agent deployments in the dashboard" | List of running agent deployments directly in the dashboard; agents deployed manually as OpenShell-managed Sandbox CRs; name and status of each deployed agent instance in each namespace; filtering capabilities |
| 2 | managing-resources.txt | Dashboard configuration options table | `spec.dashboardConfig.agentOps` (Developer Preview), default `false`, enables the Agent Ops features in Gen AI Studio; sibling flags `agentConfigManagement` (saved agents) and `agentsCatalog` (Agents Catalog page) use the same mechanism |

## User Flows

### Flow 1: View running agent deployments

1. **Enable the flag** — cluster administrator patches `OdhDashboardConfig` to set `spec.dashboardConfig.agentOps: true` (default is `false`) and refreshes the dashboard
2. **Open the view** — Agent Ops entry under Gen AI Studio in the dashboard navigation
3. **Read the list** — name and status of each deployed agent instance, scoped to the selected namespace
4. **Narrow the view** — filter by name or status to manage deployed agents

### Flow 2: Trace the list to its resources (workshop extension)

1. **Discover the Sandbox CRD** — `oc api-resources | grep -i sandbox` (OpenShell is itself a Developer Preview; the API group can differ between installations)
2. **List the CRs** — `oc get sandboxes -A` across namespaces
3. **Match** — every running Sandbox CR corresponds to an agent instance entry in the dashboard list

## Features and Concepts

### OpenShift Platform
- `OdhDashboardConfig` custom resource in `redhat-ods-applications`, created by the OpenShift AI operator; namespace scoping and RBAC for cluster administrators patching it

### RHOAI / AI Platform
- Agent Ops features in Gen AI Studio, gated by the `agentOps` dashboard configuration option (not by a component in the `DataScienceCluster` object); OpenShell-managed Sandbox CRs as the deployment record the view reads

### AI/ML Fundamentals
- Agent instance lifecycle: deployed agent configurations running as Sandbox CRs; dashboard monitoring as the day-two question after deployment

## Workshop Potential

- **Estimated modules**: 1 (flag enablement → guided tour → Sandbox CR trace)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: `oc` CLI basics, RHOAI operator/dashboard model
- **Estimated duration**: 30–45 minutes
- **Cluster requirements**: RHOAI 3.5 with the RHOAI operator installed; cluster-admin rights for the flag patch; at least one OpenShell-managed Sandbox CR deployed for a meaningful list
- **Maturity**: Developer Preview — observe-only tour, no fabricated UI actions

## Open Questions

- Exact Agent Ops menu label and location within Gen AI Studio on a live 3.5 console (doc evidence says "Gen AI Studio"; the section wording may shift between releases)
- Sandbox API group and resource name on the target cluster (docs name the CR kind, not the group; discovery-first via `oc api-resources` is required)
