---
schema_version: 1
id: RHAIBU-M33FJXA915W8
type: requirement
---
# Module 01: Getting Started with Multi-provider API passthrough

## Problem

Before routing native provider formats, learners need to verify the MaaS and
external-model prerequisites on their cluster, understand how the gateway
decides between translation and passthrough, and create the provider credential
foundation: the API key secret and the `ExternalProvider` custom resource.
Without this orientation and setup, the module 02 exercises are copy-paste with
no understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to verify both external-model CRDs (`oc get crd externalmodels.inference.opendatahub.io externalproviders.inference.opendatahub.io`), the `maas-api` pod `Running` in `redhat-ai-gateway-infra`, and at least one MaaS subscription
- [REQ-012] Learner MUST be able to state which request paths map to `messages`, `openai-responses`, and `openai-chat`, and name the only two passthrough-eligible combinations: `messages` → `messages` and `openai-responses` → `openai-responses`
- [REQ-013] Learner MUST be able to create the `{guid}-llm` namespace, a provider API key secret labeled `inference.llm-d.ai/ipp-managed=true`, and confirm the label via jsonpath
- [REQ-014] Learner MUST be able to create the `anthropic-provider` `ExternalProvider` and confirm `PHASE: Ready` plus the `ServiceEntry` and `DestinationRule` resources in `{guid}-llm`

## Success Metrics

Learner completes all four exercises: the prerequisite checks, the format
detection walkthrough, the secret creation, and the `ExternalProvider` creation,
each producing the documented expected output (`Ready` phase, `true` label).

## Risks

- If a CRD is not found, the MaaS deployment is incomplete and the `maas` component must be redeployed in the `DataScienceCluster` before continuing
- If no MaaS subscription exists, one must be created first via the dashboard (*Settings* → *MaaS governance*)

## Assumptions

- Learner has completed Getting Connected (cluster login as cluster administrator)

## Related Requirements

- RHAIBU-M33FJXA0RAZF

## Verified By

- features/maas/maas-multi-provider-passthrough/content/modules/ROOT/pages/module-01-getting-started.adoc
