---
schema_version: 1
id: RHAIBU-M33F0QS1E106
type: requirement
---
# Module 01: Core Concepts

## Problem

Before deploying guardrails, learners need a mental model of what NeMo
Guardrails is, the three API endpoints, the four rail types, and the cluster
components that back the service — the TrustyAI Operator, the
`NemoGuardrails` CRD, and the `Managed` TrustyAI component in the
DataScienceCluster. Without this orientation, later hands-on steps are
copy-paste with no understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to name the three API endpoints (`/v1/chat/completions`, `/v1/guardrail/checks`, `/v1/checks`) and their use cases
- [REQ-012] Learner MUST be able to verify the TrustyAI component is `Managed` with `oc get dsc -o custom-columns=...` (`spec.components.trustyai.managementState`)
- [REQ-013] Learner MUST be able to confirm the TrustyAI Operator is installed with `oc get csv | grep -i trustyai` in `Succeeded` phase
- [REQ-014] Learner MUST be able to confirm the `NemoGuardrails` CRD is served by `trustyai.opendatahub.io/v1alpha1` with `oc api-resources --api-group=trustyai.opendatahub.io`

## Success Metrics

Learner completes both exercises: the architecture walkthrough and the cluster
inspection commands, each producing the documented expected output.

## Risks

- The `NemoGuardrails` CRD only exists after the TrustyAI component is installed and managed; on clusters without it, Exercise 2 must be adapted

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33F0QRTSW8T

## Verified By

- features/guardrails/nemo-guardrails/content/modules/ROOT/pages/module-01-concepts.adoc
