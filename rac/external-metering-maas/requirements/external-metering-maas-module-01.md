---
schema_version: 1
id: RHAIBU-M33D2G6T8B98
type: requirement
---
# Module 01: Getting Started

## Problem

Before exploring metered traffic, learners need a mental model of how external
metering connects MaaS inference traffic to a billing system: the two BBR
plugins, the event payload, and the MaaS governance foundation (MaaSModelRef,
MaaSSubscription, MaaSAuthPolicy) the integration depends on. Without this
orientation, the Module 02 lifecycle walkthrough is copy-paste with no
understanding of what is being observed.

## Requirements

- [REQ-011] Learner MUST be able to describe the post-inference token usage webhook (BBR response plugin) and the fields of its asynchronous event payload: requester identity, subscription, model, input and output token counts, request ID, and timestamp
- [REQ-012] Learner MUST be able to describe the pre-inference credit check (BBR request plugin) and its behavior of blocking the next request when credit is exhausted
- [REQ-013] Learner MUST be able to list published MaaS models with `oc get maasmodelref --all-namespaces` and locate them in the model's project namespace rather than `models-as-a-service`
- [REQ-014] Learner MUST be able to list subscriptions and authorization policies with `oc get maassubscription -n models-as-a-service` and `oc get maasauthpolicy -n models-as-a-service`

## Success Metrics

Learner completes both exercises: the plugin walkthrough with the plugin-type
table inspected, and the MaaS foundation verification commands producing the
documented expected output.

## Risks

- On workshop clusters with no published models, the foundation listings return empty lists and exercise 2 must be adapted by the facilitator

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33D2G6HM38A

## Verified By

- features/agents-mcp/external-metering-maas/content/modules/ROOT/pages/module-01-getting-started.adoc
