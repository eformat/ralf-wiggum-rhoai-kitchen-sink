---
schema_version: 1
id: RHAIBU-M33FJXA0RAZF
type: requirement
---
# Multi-provider API passthrough for external models (MaaS) Workshop

## Problem

Cluster administrators evaluating RHOAI 3.5 need hands-on experience with
Multi-provider API passthrough for external models — the Technology Preview
MaaS capability for routing native provider formats (Anthropic Messages, OpenAI
Responses) through the MaaS gateway without translation — before they can
configure it for development teams. Without a structured workshop, learners
must reverse-engineer the `ExternalProvider`/`ExternalModel`/`MaaSModelRef`
resource chain, the format-detection rules, and the passthrough decision
matrix from product documentation alone. This workshop targets administrators
with working knowledge of OpenShift and Models-as-a-Service.

## Requirements

- [REQ-001] Learner MUST be able to verify the external-model prerequisites: both CRDs (`externalmodels`, `externalproviders`) installed, the `maas-api` pod `Running` in `redhat-ai-gateway-infra`, and at least one MaaS subscription
- [REQ-002] Learner MUST be able to state how the gateway detects API formats from request path suffixes and name the only two format combinations that use passthrough (`messages` → `messages`, `openai-responses` → `openai-responses`)
- [REQ-003] Learner MUST be able to create the `{guid}-llm` model namespace and a provider API key secret labeled `inference.llm-d.ai/ipp-managed=true`, confirmed by jsonpath
- [REQ-004] Learner MUST be able to create an `ExternalProvider` custom resource (anthropic, `auth.type: apikey`) and confirm `PHASE: Ready` plus the auto-created `ServiceEntry` and `DestinationRule` resources
- [REQ-005] Learner MUST be able to create an `ExternalModel` with a passthrough-eligible `apiFormat: messages` and confirm a Ready phase with an auto-created `HTTPRoute`
- [REQ-006] Learner MUST be able to publish the external model with a `MaaSModelRef`, add it to a MaaS subscription, and verify it in the dashboard's *External models* tab with correct provider details
- [REQ-007] Learner MUST be able to send a native Anthropic Messages request to `/v1/messages` and to the single gateway URL, verifying passthrough by the `content` array response shape and the target model ID

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the `ExternalProvider` and `ExternalModel` reach `Ready` in module 01–02, the
`/v1/messages` curl requests return an Anthropic Messages response with
`stop_reason: end_turn` and `model: claude-sonnet-4-20250514`.

## Risks

- Multi-provider API passthrough is Technology Preview in 3.5; the `ExternalProvider`, `ExternalModel`, and `MaaSModelRef` APIs may change between releases
- Workshop cluster must have Models-as-a-Service deployed with at least one MaaS subscription pre-provisioned
- Requires a valid external provider API key (for example, Anthropic) that learners can access
- Passthrough models are not metered by MaaS subscription-level token rate limits; consumption must be managed at the provider level

## Assumptions

- RHOAI 3.5 is installed with Models-as-a-Service deployed
- Learners have cluster-administrator `oc` access and workshop credentials (`{user}`, `{guid}`)
- At least one external provider API key is available and the external endpoint (api.anthropic.com) is reachable from the cluster

## Related Designs

- RHAIBU-M33FJXB8HQB6

## Related Decisions

- RHAIBU-M33FJXASQFXR
- RHAIBU-M33FJXB0445B

## Related Requirements

- RHAIBU-M33FJXA915W8
- RHAIBU-M33FJXAJXJ9X
