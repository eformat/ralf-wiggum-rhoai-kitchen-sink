---
schema_version: 1
id: RHAIBU-M33FK0V2M8PC
type: requirement
---
# Module 01: Getting Started

## Problem

Before deploying vLLM models to MaaS, learners need to enable the Technology
Preview `vLLMDeploymentOnMaaS` feature flag and confirm the MaaS platform on
the workshop cluster is ready to govern vLLM-served models. Without this
orientation, the module 02 wizard will not offer the vLLM deployment resources
and may fail halfway through on a cluster that lacks the gateway or controller.

## Requirements

- [REQ-011] Learner MUST be able to check the current state of both dashboard flags with `oc get odhdashboardconfig` (`spec.dashboardConfig.modelAsService` and `spec.dashboardConfig.vLLMDeploymentOnMaaS`)
- [REQ-012] Learner MUST be able to enable both flags with a single `oc patch` merge on `OdhDashboardConfig` and confirm the re-read `vLLMDeploymentOnMaaS` value is `true`
- [REQ-013] Learner MUST be able to verify MaaS is enabled with `oc get dsc default` (`kserve.managementState` and `kserve.modelsAsService.managementState` both print `Managed`)
- [REQ-014] Learner MUST be able to confirm the `maas-default-gateway` exists in `openshift-ingress` and the `maas-controller` pods (found via the `maastenantconfig` `infraNamespace`) report `Running` with a ready count of `1/1` or more

## Success Metrics

Learner completes both exercises: the flag patch (re-read returning `true`) and
the platform inspection commands, each producing the documented expected output.

## Risks

- Patching `OdhDashboardConfig` and creating groups require cluster administrator access; `Forbidden` failures must be routed to the facilitator
- Gateway and controller resources only exist after MaaS is installed; on clusters without it, exercise 2 must be escalated to the facilitator

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33FK0TNTTYJ

## Verified By

- features/maas/maas-vllm-deployment/content/modules/ROOT/pages/module-01-getting-started.adoc
