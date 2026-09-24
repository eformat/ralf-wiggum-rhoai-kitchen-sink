---
schema_version: 1
id: RHAIBU-M33DKEN8Z3S1
type: requirement
---
# MCP Catalog Support-Tier Labeling Workshop

## Problem

Cluster administrators and developers evaluating RHOAI 3.5 need hands-on
experience with MCP Catalog support-tier labeling — the Technology Preview
feature that puts a `Red Hat`, `Partner`, or `Community` support tier on every
MCP server card in the AI Hub MCP Catalog — before they can decide which
catalog servers to trust and deploy for their agents. Without a structured
workshop, learners must piece together the operator enablement, dashboard
feature flag, and `MCPServer` custom resource workflow from product
documentation alone. This workshop targets RHOAI users with working knowledge
of OpenShift; the enablement exercise additionally requires cluster
administrator access.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to enable MCP server lifecycle management by patching the `DataScienceCluster` (`mcplifecycleoperator.managementState: Managed`) and the `OdhDashboardConfig` (`mcpCatalog: true`)
- [REQ-003] Learner MUST be able to verify the MCP Lifecycle Operator pod is `Running` (label `app.kubernetes.io/name=mcp-lifecycle-operator`) and `status.installedComponents.mcplifecycleoperator` is `true`
- [REQ-004] Learner MUST be able to read the support-tier labels (`Red Hat`, `Partner`, `Community`) on MCP server cards in the AI Hub MCP Catalog and filter the catalog by deployment mode or transport protocols
- [REQ-005] Learner MUST be able to deploy an MCP server from the catalog (setting `serviceAccountName` under `runtime:`/`security:` when the server metadata requires one) and confirm `READY` is `True` via `oc get mcpservers -n {guid}-{user}`
- [REQ-006] Learner SHOULD be able to confirm the deployed server appears on the dashboard's *Deployments* tab under *AI hub* → *MCP servers*
- [REQ-007] Learner MUST be able to inspect server health with `oc describe mcpserver` (`type: Ready`, `status: True`), delete the server, and confirm no `MCPServer` resources remain in the project

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the enablement patches return successfully, the operator pod reports `Running`,
the deployed `MCPServer` reaches `READY: True` in module 01, and deletion
leaves `No resources found`.

## Risks

- The feature is Technology Preview in 3.5; the `MCPServer` CRD API is `v1alpha1` with no backwards-compatibility commitment, so commands may change between releases
- The `mcplifecycleoperator` component defaults to `Removed` — the entire deploy workflow is blocked until the administrator enables it
- Console screenshots are placeholders until the Act phase (no live cluster at authoring time)

## Assumptions

- RHOAI 3.5 is installed on an OpenShift 4.22 or later cluster
- Learners have `oc` CLI access, workshop credentials (`{user}`, `{guid}`), and administrator access for the enablement exercise
- The MCP Gateway Operator is an optional separate installation and is not required for this lab

## Related Designs

- RHAIBU-M33DKEP8W03X

## Related Decisions

- RHAIBU-M33DKENQP694
- RHAIBU-M33DKEP1KDNS

## Related Requirements

- RHAIBU-M33DKENF7Y3M
