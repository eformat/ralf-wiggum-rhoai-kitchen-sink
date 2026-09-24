---
schema_version: 1
id: RHAIBU-M33D2G6HM38A
type: requirement
---
# External Metering Integration for MaaS Workshop

## Problem

Platform operators running Models-as-a-Service (MaaS) as a commercial AI service
need to connect inference traffic to an external metering or billing system, but
the External metering integration for MaaS feature (Developer Preview in RHOAI
3.5) has no hands-on learning path. Without a structured workshop, learners must
reverse-engineer the Backend-Based Routing (BBR) plugin model, the token usage
event payload, and the MaaS governance layer the integration depends on from
product documentation alone. This workshop targets RHOAI users with a working
knowledge of OpenShift and the MaaS governance layer.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify the MaaS foundation with `oc get maasmodelref --all-namespaces`, `oc get maassubscription -n models-as-a-service`, and `oc get maasauthpolicy -n models-as-a-service`
- [REQ-003] Learner MUST be able to describe the two BBR plugins — the post-inference token usage webhook and the pre-inference credit check — and when each runs relative to an inference request
- [REQ-004] Learner MUST be able to trace a metered request through the pre-inference credit check, model processing, and post-inference usage webhook stages, and identify every field of the emitted token usage event
- [REQ-005] Learner MUST be able to list the AuthPolicy and TokenRateLimitPolicy resources the MaaS controller generates in the working project (`oc get authpolicy -n {guid}-{user}`, `oc get tokenratelimitpolicy -n {guid}-{user}`)
- [REQ-006] Learner SHOULD observe the documented quota pairing behavior: a MaaSAuthPolicy without a corresponding MaaSSubscription yields `429 Too Many Requests` and a MaaSSubscription without a MaaSAuthPolicy yields `403 Forbidden`
- [REQ-007] Learner SHOULD understand that the integration emits raw usage events only, and that invoice generation, cost attribution, and rate calculation are the responsibility of the external metering system

## Success Metrics

All acceptance criteria are demonstrated by the learner during the lab: the MaaS
foundation listings return the expected resources, the metered-request lifecycle
walkthrough names all six event payload fields, and the generated AuthPolicy and
TokenRateLimitPolicy listings succeed in the working project.

## Risks

- The feature is Developer Preview in 3.5 and may change between releases
- Workshop cluster must have MaaS enabled and at least one published model, subscription, and authorization policy for the listings to return non-empty output
- No external metering endpoint is provisioned in the workshop; the exercises observe the plugins and quota layer conceptually rather than against a live billing system

## Assumptions

- RHOAI 3.5 is installed with the MaaS component enabled
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A demo published model, subscription, and authorization policy may be pre-created by the facilitator

## Related Designs

- RHAIBU-M33D2G81TC6X

## Related Decisions

- RHAIBU-M33D2G7ERZ6C
- RHAIBU-M33D2G7QJYVX

## Related Requirements

- RHAIBU-M33D2G6T8B98
- RHAIBU-M33D2G75GA1N
