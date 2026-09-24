# Observations: MCP Catalog administrative interface (doc-derived)

## Summary

The MCP Catalog administrative interface is a RHOAI 3.5 Developer Preview
feature that lets OpenShift AI administrators manage MCP server catalog source
configurations directly from the dashboard Settings page. This observation
document was produced from the official RHOAI 3.5 product documentation (release
notes Developer Preview section; Working with the MCP catalog) because no live
demo cluster was available at authoring time. Every item below is doc evidence,
not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §4 MCP Catalog administrative interface for managing entries (DP) | Administrators manage MCP Catalog source configurations from the Settings page; add, edit, and remove entries via YAML-based creation; eliminates manual Kubernetes ConfigMap edits; UX aligns with the Model Catalog administrative interface; access restricted strictly to OpenShift AI administrators |
| 2 | mcp-tier-mcp-catalog.txt | §2.1 MCP Lifecycle Operator | Cluster-level controller managed via the DataScienceCluster CR; `mcplifecycleoperator` defaults to Removed in 3.5; `managementState: Managed` required to enable; watches MCPServer custom resources and provisions Deployments, Services, NetworkPolicies, and cluster-internal URLs |
| 3 | mcp-tier-mcp-catalog.txt | §2.2 TP limitations | Dashboard UI gated by the `mcpCatalog` feature flag in OdhDashboardConfig; MCPServer CRD API is v1alpha1 with no backwards compatibility; single-cluster only; no governance/policy enforcement; MCP Gateway Operator is a separate installation |
| 4 | mcp-tier-mcp-catalog.txt | §2.3 Enable the MCP Lifecycle Operator | Patch DataScienceCluster (`mcplifecycleoperator.managementState: Managed`) and OdhDashboardConfig (`dashboardConfig.mcpCatalog: true`); verify `.status.installedComponents.mcplifecycleoperator` returns `true`; operator pod runs in `redhat-ods-applications` |
| 5 | mcp-tier-mcp-catalog.txt | §2.1.2 Relationship to the AI Hub MCP Catalog | The AI Hub MCP Catalog is a federated dashboard plugin pre-loaded with servers from Red Hat, technology partners, and the open source community; the operator provides the deployment runtime backend; without the operator the deploy action is unavailable; a model-metadata-collection data container supplies catalog metadata |
| 6 | ai-available-assets-release-notes.txt | §4 MCP Catalog for enterprise management of MCP servers (DP) | Catalog ships pre-loaded Red Hat/partner/community servers; deploy action in the catalog UI is gated on the presence of the MCP lifecycle operator; platform engineers register deployed servers in gen AI studio configuration |

## User Flows

### Flow 1: Administrator manages a catalog entry (docs DP section)

1. **Prerequisites** — MCP Lifecycle Operator enabled; `mcpCatalog` dashboard flag on (§2.3)
2. **Open Settings** — MCP catalog source management sits on the dashboard Settings page (DP section)
3. **Add** — provide the entry as YAML in the same style of source configuration that previously required a hand-edited ConfigMap (DP section)
4. **Edit / Remove** — update or delete entries from the Settings list; no ConfigMap resources touched (DP section)
5. **Effect** — changes feed the AI Hub MCP Catalog that developers browse (§2.1.2)

### Flow 2: Developer consumes the catalog

1. **Browse** — `AI hub` → `MCP servers`; server cards show name, description, supported tools, and support tier (§3.1)
2. **Deploy** — deploy gated on the MCP Lifecycle Operator presence; operator creates an MCPServer CR in the developer's namespace (§3.1)
3. **Verify** — `oc get mcpservers -n <namespace>` with READY `True` (§3.1)

## Features and Concepts

### OpenShift Platform
- ConfigMap resources (`gen-ai-aa-mcp-servers` in `redhat-ods-applications`) — the manual approach the interface replaces; OdhDashboardConfig feature flags; RBAC/administrator-only access boundaries

### RHOAI / AI Platform
- MCP Catalog administrative interface (DP, Settings page), MCP Lifecycle Operator component controller (`mcplifecycleoperator` in the DSC), AI Hub MCP Catalog federated dashboard plugin, `mcpCatalog` dashboard flag, MCPServer CR (v1alpha1), model-metadata-collection data container

### AI/ML Fundamentals
- Model Context Protocol (MCP) servers as the tool layer for AI agents; catalog source configuration as the discovery surface for agentic workflows

## Workshop Potential

- **Estimated modules**: 1 (guided tour of the administrative interface)
- **Target audience**: OpenShift AI administrators with dashboard access
- **Prerequisite knowledge**: OpenShift administration basics, `oc` CLI
- **Estimated duration**: ~30 minutes
- **Cluster requirements**: RHOAI 3.5 on OpenShift 4.22+ with MCP Catalog enabled (MCP Lifecycle Operator installed, `mcpCatalog` flag on)

## Open Questions

- Exact Settings-page submenu label for the MCP catalog settings entry on a live console — the docs describe "the Settings page of the dashboard" without a definitive menu path (doc-derived)
- Whether the add-entry flow exposes an enable/disable state per entry on a live console (doc-derived only)
