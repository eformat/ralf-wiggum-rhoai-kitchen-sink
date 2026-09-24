---
schema_version: 1
id: RHAIBU-M33CTVN1VNYS
type: requirement
---
# Module 02: Publish and consume a model asset

## Problem

A model only becomes a discoverable asset when it is designated as an available
asset during deployment. Learners need to deploy a generative AI model with the
*Add as AI asset endpoint* option, verify the endpoint from the CLI, and then
consume it by launching a configured Gen AI playground directly from the AI
Available Assets page — the page's primary purpose as a starting point for
using assets.

## Requirements

- [REQ-021] Learner MUST be able to deploy a generative AI model with the *Add as AI asset endpoint* checkbox and a use-case label (`chat`, `multimodal`, `natural language processing`)
- [REQ-022] Learner MUST be able to verify the deployed endpoint with `oc get inferenceservice -n {guid}-{user}` showing `STATUS` `Successful` and `URL` `True`
- [REQ-023] Learner MUST be able to consume the asset by clicking *Add to playground* on the Models tab, configuring a playground (Inference/Embedding types), and sending a prompt from the chat area
- [REQ-024] Learner SHOULD be able to enable custom endpoints via the `OdhDashboardConfig` flags (`dashboardConfig.aiAssetCustomEndpoints`, `genAiStudioConfig.externalProviders`) and confirm the *Create endpoint* option appears

## Success Metrics

Learner completes both exercises: the deployment (inference service `Successful`
with `URL` `True`, model visible on the Models tab) and the playground creation
from the AI asset endpoints page (chat area loads, Model tab shows the deployed
model, prompt receives a response). The optional custom-endpoint exercise is
demonstrated only with cluster-administrator privileges.

## Risks

- Skipping the *Add as AI asset endpoint* checkbox leaves the deployment running but unlisted as an available asset
- Enabling `externalProviders` sends data from the responses API (RAG context, MCP tool results, user input) outside the cluster — data security must be evaluated
- Hardware profile availability must be confirmed on the workshop cluster before the deployment exercise

## Assumptions

- Learner has completed Module 01 (page located, MCP server published)
- A generative AI model is available in an OCI registry, S3-compatible object storage, or URI
- Cluster-administrator privileges are available for the optional custom-endpoint exercise

## Related Requirements

- RHAIBU-M33CTVKS1W3G

## Verified By

- features/agents-mcp/ai-available-assets/content/modules/ROOT/pages/module-02-hands-on.adoc
