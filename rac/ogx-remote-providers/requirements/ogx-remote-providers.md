---
schema_version: 1
id: RHAIBU-M33DZK9PM1QM
type: requirement
---
# OGX remote::anthropic and remote::gemini Providers Workshop

## Problem

Developers and platform engineers evaluating RHOAI 3.5 EA2 need hands-on
experience with the `remote::anthropic` and `remote::gemini` OGX inference
providers — the Developer Preview path for proxying OpenAI-compatible requests
to the Anthropic and Google Gemini APIs — before they can adopt or operate
remote providers in their agents. Without a structured workshop, learners must
reverse-engineer the provider support matrix, the enablement variables
(`ANTHROPIC_API_KEY`, `ENABLE_GEMINI`), and the Secrets-backed credential flow
from product documentation alone. This workshop targets RHOAI users with
working knowledge of OpenShift and the OGX inference gateway.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to identify `remote::anthropic` and `remote::gemini` as Developer Preview Inference API providers in the OGX API provider support table, with their enablement variables `ANTHROPIC_API_KEY` and `ENABLE_GEMINI`
- [REQ-003] Learner MUST be able to verify the OGX operator is installed by querying the `ogxservers.ogx.io` CRD
- [REQ-004] Learner MUST be able to list at least one OGXServer in their project and confirm its phase prints `Running` (or `Ready`)
- [REQ-005] Learner MUST be able to store an external API key in an Opaque Kubernetes Secret labeled `ogx.io/watch: "true"` and confirm it exists with a `DATA` count of 1
- [REQ-006] Learner MUST be able to articulate both documented enablement paths: Secrets-backed environment variables for the default distribution, and a custom `config.yaml` via `spec.overrideConfig`
- [REQ-007] Learner MUST be able to list registered models through the OpenAI-compatible `/v1/models` endpoint and send a chat completion that returns a plain-text answer via `/v1/chat/completions`

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the credential Secret is applied in module 01–02 and the OpenAI-compatible
chat completion returns a plain-text answer, proving the request was proxied
to the remote API and back.

## Risks

- Both providers are Developer Preview in 3.5 EA2 and the exact provider configuration options might change between releases
- Workshop cluster must have the RHOAI operator installed and OGX enabled with a running OGXServer
- Requests to remote providers egress the cluster to `api.anthropic.com` or Google endpoints — disconnected (air-gapped) clusters cannot reach them, and per-request costs are billed against the registered API key

## Assumptions

- RHOAI 3.5 EA2 is installed with the RHOAI operator and OGX enabled
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- Valid external API keys (Anthropic, Gemini) are available to store in Secrets

## Related Designs

- RHAIBU-M33DZKAXTCBW

## Related Decisions

- RHAIBU-M33DZKABT4T4
- RHAIBU-M33DZKAMBC37

## Related Requirements

- RHAIBU-M33DZK9XP67K
- RHAIBU-M33DZKA50BE1
