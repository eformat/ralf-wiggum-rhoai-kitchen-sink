---
schema_version: 1
id: RHAIBU-M33EB4FEBDAE
type: requirement
---
# Module 01: Getting Started

## Problem

Before evaluating tool-calling accuracy, learners need to enable the feature
cluster-wide and locate the validated arguments the model catalog exposes for
models with confirmed tool-calling support. Without this, later hands-on steps
start from a flag that is not set and a UI panel that does not exist.

## Requirements

- [REQ-011] Learner MUST be able to confirm the `OdhDashboardConfig` custom resource exists and patch `spec.dashboardConfig.toolCalling` to `true` from the CLI
- [REQ-012] Learner MUST be able to verify the flag with `oc get OdhDashboardConfig -o jsonpath='{.spec.dashboardConfig.toolCalling}'` (prints `true`)
- [REQ-013] Learner MUST be able to verify the dashboard pods are running (`oc get pods -n redhat-ods-applications -l app=odh-dashboard`)
- [REQ-014] Learner MUST be able to open a model details page whose sidebar lists the *Validated Arguments* section, expand the *Tool Calling* panel, and copy the validated `vllm serve` arguments

## Success Metrics

Learner completes both exercises: the flag patch with jsonpath and pod
verification, and the catalog walkthrough producing the documented model
details page layout with the Tool Calling panel visible.

## Risks

- Cluster administrator privileges are required for the patch
- Only models with confirmed tool-calling support display the *Validated Arguments* section; the learner must pick another model otherwise

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33EB4F3BPFR

## Verified By

- features/agents-mcp/validated-tool-calling-config/content/modules/ROOT/pages/module-01-getting-started.adoc
