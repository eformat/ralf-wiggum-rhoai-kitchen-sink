---
schema_version: 1
id: RHAIBU-M33CTVKS1W3G
type: requirement
---
# AI Available Assets Page Workshop

## Problem

AI engineers and application developers evaluating RHOAI 3.5 need hands-on
experience with the AI Available Assets page — the dashboard's discovery point
for models, custom endpoints, MaaS models, and MCP servers — before they can
integrate those assets into the Gen AI playground or their own applications.
Without a structured workshop, learners must reverse-engineer the page's asset
categories, the `gen-ai-aa-mcp-servers` ConfigMap contract, and the
`Add as AI asset endpoint` deployment option from product documentation alone.
This workshop targets RHOAI users with dashboard access and `oc` CLI
credentials, plus cluster-administrator privileges for the MCP server and
custom endpoint exercises.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to open the AI asset endpoints page (`Gen AI studio → AI asset endpoints`) for their project and identify its two asset categories (Models, MCP Server)
- [REQ-003] Learner MUST be able to publish an MCP server into the available assets by applying the `gen-ai-aa-mcp-servers` ConfigMap in `redhat-ods-applications` and confirm its creation with `oc get configmap ... -o yaml`
- [REQ-004] Learner MUST be able to confirm the published MCP server appears in the *MCP servers* tab of the AI asset endpoints page
- [REQ-005] Learner MUST be able to deploy a generative AI model with the *Add as AI asset endpoint* checkbox and verify the endpoint with `oc get inferenceservice -n {guid}-{user}` (`STATUS` `Successful`, `URL` `True`)
- [REQ-006] Learner MUST be able to confirm the deployed model appears on the *Models* tab of the AI asset endpoints page for the selected project
- [REQ-007] Learner MUST be able to consume an available asset by creating a playground from the AI asset endpoints page (*Add to playground*) and sending a prompt that receives a response
- [REQ-008] Learner SHOULD be able to enable custom endpoints via the `OdhDashboardConfig` flags (`aiAssetCustomEndpoints`, `externalProviders`) and create an endpoint from a model outside their namespace

## Success Metrics

All seven MUST criteria are demonstrated by the learner during the lab; the
inference service reaches `Successful` in module 02 and the playground created
from the AI asset endpoints page responds to a prompt. The optional criterion
is demonstrated only when cluster-administrator privileges are available.

## Risks

- The AI asset endpoints page is documented as Technology Preview in the gen AI playground docs and may change between releases
- The MCP server exercise requires write access to the `redhat-ods-applications` namespace
- The custom endpoint exercise requires cluster-administrator privileges and `OdhDashboardConfig` edit rights
- The *Enable tracing* playground toggle only appears when the platform observability stack and `genAiTracing` flag are configured

## Assumptions

- RHOAI 3.5 is installed with the dashboard accessible and the RHOAI operator installed
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A generative AI model is available in an OCI registry or S3-compatible object store
- Learners doing the optional exercise have cluster-administrator privileges

## Related Designs

- RHAIBU-M33CTVQ1Z5SZ

## Related Decisions

- RHAIBU-M33CTVNM5D1V
- RHAIBU-M33CTVP8SMCG

## Related Requirements

- RHAIBU-M33CTVMB23E3
- RHAIBU-M33CTVN1VNYS
