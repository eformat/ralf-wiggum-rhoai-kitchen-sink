---
schema_version: 1
id: RHAIBU-M33DZKA50BE1
type: requirement
---
# Module 02: Enable and explore remote Anthropic and Gemini

## Problem

Learners must walk the enablement path for a remote OGX inference provider end
to end — store the credential in a Kubernetes Secret, wire the provider into an
OGXServer, and call the remote model through the OpenAI-compatible `/v1`
surface. This is the core deliverable of the workshop: a verified
remote-provider inference request.

## Requirements

- [REQ-021] Learner MUST be able to create an Opaque Secret (`anthropic-creds`) with the `ogx.io/watch: "true"` label and confirm it exists with `oc get secret` showing `DATA` count `1`
- [REQ-022] Learner MUST be able to articulate both enablement paths: Secrets-backed environment variables for the default distribution, and a custom `config.yaml` via `spec.overrideConfig` naming `remote::anthropic` as the provider type with the key resolved from `${env.ANTHROPIC_API_KEY}`
- [REQ-023] Learner MUST be able to list model IDs registered through the remote provider with `curl "$OGX_URL/v1/models"`
- [REQ-024] Learner MUST be able to send a chat completion with `curl -X POST "$OGX_URL/v1/chat/completions"` and receive a plain-text answer proving the request was proxied to the remote API and back

## Success Metrics

The credential Secret exists with `DATA` count `1`; `/v1/models` lists
remote-provider model IDs; the chat completion returns a plain-text answer
(authentication failures resolve by re-checking the `ogx.io/watch: "true"`
label and the pod roll).

## Risks

- Requests to remote providers egress the cluster to `api.anthropic.com` or Google endpoints; disconnected clusters cannot reach them
- Per-request costs are billed against the API key registered in the Secret
- The full provider schema (provider ID and config field names) follows the upstream OGX `config.yaml` format and might change between releases

## Assumptions

- Learner has completed Module 01 (OGX operator verified, OGXServer running) and has a valid Anthropic API key

## Related Requirements

- RHAIBU-M33DZK9PM1QM

## Verified By

- features/agents-mcp/ogx-remote-providers/content/modules/ROOT/pages/module-02-hands-on.adoc
