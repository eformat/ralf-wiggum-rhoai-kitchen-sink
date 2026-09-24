---
schema_version: 1
id: RHAIBU-M33EAXN220M3
type: requirement
---
# Module 01: View Running Agent Deployments

## Problem

Learners cannot trust a dashboard list they cannot explain. Before using the
Agent Ops view for day-to-day agent management, they need to know what gates it
(the `agentOps` dashboard configuration option, not a `DataScienceCluster`
component), what it shows (name, status, namespace scoping, filtering), and
which Kubernetes resources produce its entries (OpenShell-managed Sandbox CRs).

## Requirements

- [REQ-011] Learner MUST be able to confirm the `agentOps` flag is enabled, with `oc get odhdashboardconfig odh-dashboard-config -n redhat-ods-applications -o jsonpath='{.spec.dashboardConfig.agentOps}'` returning `true`
- [REQ-012] Learner MUST be able to open the Agent Ops view from the dashboard navigation and observe the name and status of each deployed agent instance in the selected namespace
- [REQ-013] Learner MUST be able to switch namespaces with the project selector and apply the view's filters so the list narrows by name or status
- [REQ-014] Learner MUST be able to discover the Sandbox CRD resource name with `oc api-resources | grep -i sandbox` and list the Sandbox resources across namespaces with `oc get sandboxes -A`, matching the output to the dashboard entries

## Success Metrics

Learner completes all three exercises: the feature-flag enablement, the guided
tour of the running agent deployments view, and the Sandbox CR trace — each
producing the documented expected output.

## Risks

- The exact Agent Ops menu label and location within Gen AI Studio can change between releases because the feature is a Developer Preview
- `oc get sandboxes` assumes the resource name reported by `oc api-resources`; other installations may expose a different API group
- Cluster administrator privileges are required for the `OdhDashboardConfig` patch

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- The `OdhDashboardConfig` custom resource exists in `redhat-ods-applications` and is managed by the OpenShift AI operator

## Related Requirements

- RHAIBU-M33EAXMM95XR

## Verified By

- features/agents-mcp/view-agent-deployments/content/modules/ROOT/pages/module-01-hands-on.adoc
