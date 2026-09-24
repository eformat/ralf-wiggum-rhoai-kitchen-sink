---
schema_version: 1
id: RHAIBU-M33DKENF7Y3M
type: requirement
---
# Module 01: MCP Catalog support tiers in action

## Problem

Before deploying MCP servers for their agents, learners need to see the full
catalog-to-workload loop in one pass: enable the MCP Lifecycle Operator behind
the AI Hub MCP Catalog, read the support-tier labels on the server cards,
deploy a server from the catalog, and verify the resulting `MCPServer`
workload from the CLI. Without this orientation, the support tier is just a
badge with no operational meaning.

## Requirements

- [REQ-011] Learner MUST be able to enable MCP server lifecycle management by patching the `DataScienceCluster` (`mcplifecycleoperator.managementState: Managed`) and the `OdhDashboardConfig` (`mcpCatalog: true`)
- [REQ-012] Learner MUST be able to verify the MCP Lifecycle Operator pod is `Running` and the component reports `true` in `status.installedComponents.mcplifecycleoperator`
- [REQ-013] Learner MUST be able to deploy an MCP server from the AI Hub MCP Catalog after reading its support tier and confirm the `MCPServer` shows `READY` status `True` via `oc get mcpservers -n {guid}-{user}`
- [REQ-014] Learner MUST be able to verify the server on the dashboard *Deployments* tab, confirm the `type: Ready` condition with `oc describe mcpserver`, delete the server, and confirm `No resources found` in the project

## Success Metrics

Learner completes all three exercises: the enablement exercise (pod `Running`,
installedComponents `true`), the catalog browse-and-deploy exercise (`READY:
True` + *Deployments* tab), and the health-and-cleanup exercise (empty
`MCPServer` list), each producing the documented expected output.

## Risks

- The `mcplifecycleoperator` component defaults to `Removed`; until Exercise 1 succeeds, the *Deploy MCP server* button stays disabled and Exercises 2–3 are blocked
- Console screenshot for the catalog cards is a placeholder (`// TODO: capture screenshot`) until the Act phase

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- Learner has cluster administrator access for the Exercise 1 patches

## Related Requirements

- RHAIBU-M33DKEN8Z3S1

## Verified By

- features/agents-mcp/mcp-catalog-support-tier/content/modules/ROOT/pages/module-01-hands-on.adoc
