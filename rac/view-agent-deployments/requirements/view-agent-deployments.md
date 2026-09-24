---
schema_version: 1
id: RHAIBU-M33EAXMM95XR
type: requirement
---
# View Running Agent Deployments Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need to see which
agent instances are actually running without falling back to CLI inspection for
every question. The Agent Ops features in Gen AI Studio show a list of running
agent deployments directly in the dashboard — including agents deployed manually
as OpenShell-managed Sandbox custom resources — but the feature is a Developer
Preview gated behind the `agentOps` dashboard configuration option. Without a
structured workshop, learners must discover the feature flag, the view's
namespace scoping, and the Sandbox CRs behind the list by trial and error. This
workshop targets RHOAI users with working knowledge of OpenShift.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to check the current state of the `agentOps` flag with `oc get odhdashboardconfig odh-dashboard-config -n redhat-ods-applications -o jsonpath='{.spec.dashboardConfig.agentOps}'`
- [REQ-003] Learner MUST be able to patch the `OdhDashboardConfig` custom resource to set `agentOps: true` and confirm the query returns `true`
- [REQ-004] Learner MUST be able to open the Agent Ops view from the dashboard navigation and observe the name and status of each deployed agent instance
- [REQ-005] Learner MUST be able to switch namespaces with the project selector and use the view's filters to narrow the list by name or status
- [REQ-006] Learner SHOULD be able to trace the OpenShell-managed Sandbox CRs behind the list with `oc api-resources | grep -i sandbox` and `oc get sandboxes -A`, matching the CLI output to the dashboard entries

## Success Metrics

All six acceptance criteria are demonstrated by the learner during the lab; the
`agentOps` flag query returns `true` after the patch, the Agent Ops view lists
name and status per deployed agent instance in the selected namespace, and the
`oc get sandboxes -A` output matches the dashboard list.

## Risks

- Viewing running agent deployments is a Developer Preview in 3.5 — provided as-is with no support and subject to change or removal at any time
- Patching `OdhDashboardConfig` requires cluster administrator privileges
- OpenShell is itself a Developer Preview using upstream artifacts, so the Sandbox API group and resource name can differ between installations
- A project with no deployed agents shows an empty list; facilitators must pre-deploy at least one Sandbox CR for a meaningful tour

## Assumptions

- RHOAI 3.5 is installed with the RHOAI operator managing the `OdhDashboardConfig` custom resource in `redhat-ods-applications`
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`, `{openshift_api_url}`)
- At least one agent deployment (OpenShell-managed Sandbox CR) exists in a learner-accessible namespace

## Related Designs

- RHAIBU-M33EAXPDCFTH

## Related Decisions

- RHAIBU-M33EAXNGFGVH
- RHAIBU-M33EAXNZ9QTR

## Related Requirements

- RHAIBU-M33EAXN220M3
