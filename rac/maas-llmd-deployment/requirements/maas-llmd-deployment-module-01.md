---
schema_version: 1
id: RHAIBU-M33FDJ690EQS
type: requirement
---
# Module 01: Getting Started

## Problem

Before calling a model through the MaaS gateway, learners must verify that both
MaaS and Distributed Inference with llm-d are enabled, then deploy a generative
model through the dashboard wizard using the *Distributed inference with llm-d*
deployment resource and publish it to MaaS. Without this verification and
deployment, later governance and inference steps have nothing to operate on.

## Requirements

- [REQ-011] Learner MUST be able to verify the five `maas.opendatahub.io` CRDs are listed (`aitenants`, `maasauthpolicies`, `maasmodelrefs`, `maassubscriptions`, `maastenantconfigs`)
- [REQ-012] Learner MUST be able to verify the `default-tenant` Tenant resource shows `Ready`, `modelsAsService` management state is `Managed`, and the `openshift-ai-inference` GatewayClass and Gateway both exist
- [REQ-013] Learner MUST be able to deploy a model through the wizard with the *Distributed inference with llm-d* deployment resource and see it on the *Deployments* tab with a checkmark in the *Status* column
- [REQ-014] Learner MUST be able to confirm the model was published to MaaS (`oc get maasmodelref`) and uses the LLMInferenceService architecture (`oc get llminferenceservice`), with the gateway reference under `spec.router.gateway`

## Success Metrics

Learner completes both exercises: the prerequisite verification commands and
the wizard deployment, each producing the documented expected output
(`MaaSModelRef` and `LLMInferenceService` resources listed).

## Risks

- The `default-tenant` shows `False`/`Degraded` if User Workload Monitoring is not enabled
- The Gateway uses `type: LoadBalancer` by default; on bare-metal clusters an external entry point must be configured
- Deployment requires available capacity matching the chosen hardware profile

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33FDJ5XH0SY

## Verified By

- features/maas/maas-llmd-deployment/content/modules/ROOT/pages/module-01-getting-started.adoc
