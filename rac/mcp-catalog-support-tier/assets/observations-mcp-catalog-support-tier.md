# Observations: MCP Catalog support-tier labeling (doc-derived)

## Summary

MCP Catalog support-tier labeling is a RHOAI 3.5 Technology Preview feature
that puts a support tier — *Red Hat*, *Partner*, or *Community* — on every MCP
server card in the AI Hub MCP Catalog, telling users who maintains and
supports each server. The catalog's deploy runtime is the MCP Lifecycle
Operator (`mcplifecycleoperator`), a component in the `DataScienceCluster`
that defaults to `Removed` and must be enabled explicitly. This observation
document was produced from the official RHOAI 3.5 product documentation
(Working with the MCP catalog) because no live demo cluster was available at
authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | mcp-tier-mcp-catalog.txt | §2.1 MCP Lifecycle Operator | Cluster-level component controller managed via `DataScienceCluster`; watches `MCPServer` CRs and provisions Deployments, Services, NetworkPolicies, and cluster-internal URLs; defaults to `Removed` in 3.5 |
| 2 | mcp-tier-mcp-catalog.txt | §2.1.2 Relationship to the AI Hub MCP Catalog | Catalog UI is a federated dashboard plugin pre-loaded with servers from Red Hat, technology partners, and the open source community; a separate `model-metadata-collection` data container provides catalog metadata; deploy action unavailable without the operator |
| 3 | mcp-tier-mcp-catalog.txt | §2.2 Technology Preview limitations | `MCPServer` API is `v1alpha1` with no backwards compatibility; single-cluster only; no governance/policy enforcement; dashboard gated by the `mcpCatalog` feature flag in `OdhDashboardConfig`; MCP Gateway Operator is a separate install; operator image needs no extra disconnected mirroring but server images might |
| 4 | mcp-tier-mcp-catalog.txt | §2.3 Enable the MCP Lifecycle Operator | Patch `DataScienceCluster` (`mcplifecycleoperator.managementState: Managed`) then `OdhDashboardConfig` (`dashboardConfig.mcpCatalog: true` in `redhat-ods-applications`); verify operator pod `Running` via label `app.kubernetes.io/name=mcp-lifecycle-operator` and `status.installedComponents.mcplifecycleoperator` = `true` |
| 5 | mcp-tier-mcp-catalog.txt | §3.1 Deploy MCP servers from the MCP Catalog | Navigate *AI hub* → *MCP servers*; support tiers table: Red Hat (fully supported), Partner (supported by maintaining partner), Community (best-effort); filter by deployment mode or transport protocols; optional `serviceAccountName` under `runtime:`/`security:`; deploy dialog creates `MCPServer` CR; verify `READY: True` via `oc get mcpservers` and server on the *Deployments* tab |
| 6 | mcp-tier-mcp-catalog.txt | §3.4–3.5 Remove and monitor | `oc delete mcpserver` triggers automatic cleanup of associated Deployment, Service, and other managed resources; verify `No resources found`; health via `oc describe mcpserver` looking for `type: Ready` / `status: True` |

## User Flows

### Flow 1: Enable MCP server lifecycle management (cluster administrator)

1. **Identify the DataScienceCluster** — `oc get datasciencecluster` (§2.3)
2. **Enable the operator** — patch `mcplifecycleoperator.managementState: Managed` (§2.3)
3. **Enable the dashboard flag** — patch `OdhDashboardConfig` `mcpCatalog: true` (§2.3)
4. **Verify** — operator pod `Running` + `installedComponents` `true` (§2.3)

### Flow 2: Browse the catalog and deploy a server (developer)

1. **Open the catalog** — *AI hub* → *MCP servers*; cards show name, description, supported tools, support tier (§3.1)
2. **Choose by tier** — pick *Red Hat* for the smoothest start; filter by deployment mode or transport protocols (§3.1)
3. **Deploy** — *Deploy MCP server* → review YAML → set `serviceAccountName` if the server requires one → *Deploy* (§3.1)
4. **Verify** — `oc get mcpservers` shows `READY: True`; server appears on the *Deployments* tab (§3.1)

## Features and Concepts

### OpenShift Platform
- Component controller pattern (`DataScienceCluster` `managementState`), `OdhDashboardConfig` feature flags, Deployments/Services/NetworkPolicies, namespaces and RBAC

### RHOAI / AI Platform
- AI Hub MCP Catalog (federated dashboard plugin), MCP Lifecycle Operator (`mcplifecycleoperator`), `MCPServer` custom resource (`v1alpha1`), `model-metadata-collection` data container, `mcpCatalog` dashboard feature flag

### AI/ML Fundamentals
- Model Context Protocol (MCP) servers exposing tools and capabilities to AI agents; trust and support boundaries for shared catalog content

## Workshop Potential

- **Estimated modules**: 1 (hands-on: enable → browse/deploy → monitor/remove)
- **Target audience**: cluster administrators and developers with OpenShift working knowledge
- **Prerequisite knowledge**: `oc` CLI basics, dashboard navigation
- **Estimated duration**: 45 minutes
- **Cluster requirements**: RHOAI 3.5 on OpenShift 4.22+, cluster administrator access for the enablement patches

## Open Questions

- Exact console labels (*AI hub* → *MCP servers*, *Deployments* tab, *Deploy MCP server* button) on a live 3.5 dashboard (doc-derived paths)
- Which catalog servers require a service account, for choosing the Act-phase deploy example

## Related Requirements

- RHAIBU-M33DKEN8Z3S1
