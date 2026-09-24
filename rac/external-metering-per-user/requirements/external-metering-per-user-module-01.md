---
schema_version: 1
id: RHAIBU-M33D7VB7FJKF
type: requirement
---
# Module 01: Getting Started

## Problem

Before exploring where per-user usage surfaces, learners need to know what the
external-metering IPP plugin and the standalone metering service do, verify the
MaaS foundation in their own cluster, and walk the metering data path end to
end. Without this orientation, the dashboard columns in module 02 are labels
with no model of what produced them.

## Requirements

- [REQ-011] Learner MUST be able to verify the DataScienceCluster is deployed by the OpenShift AI Operator (`oc get datasciencecluster -n redhat-ods-operator`)
- [REQ-012] Learner MUST be able to verify the MaaS CRDs are installed (`oc get crd | grep -E 'maas.opendatahub.io|aitenants'`, expecting `aitenants`, `maasauthpolicies`, `maasmodelrefs`, `maassubscriptions`, `maastenantconfigs`, `tenants`)
- [REQ-013] Learner MUST be able to verify a Tenant resource exists and is reconciled in `models-as-a-service` (`READY: True`, reason `Reconciled`)
- [REQ-014] Learner MUST be able to describe, without referring back, the five stages of the metering data path and the five token dimensions extracted from OpenAI and Anthropic provider responses

## Success Metrics

Learner completes both exercises: the cluster inspection commands each produce
the documented expected output, and the guided data-path walkthrough is
reproduced from memory in the Verify section.

## Risks

- MaaS CRDs and Tenant resources only exist on clusters with MaaS enabled; on clusters without it, exercise 1 must be adapted

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33D7VB0DVVA

## Verified By

- features/agents-mcp/external-metering-per-user/content/modules/ROOT/pages/module-01-getting-started.adoc
