---
schema_version: 1
id: RHAIBU-M33DSKJC1RWP
type: requirement
---
# Module 02: Responses and Conversations hands-on

## Problem

Learners must deploy a real OGXServer and prove the OpenAI-compatible surface
works end-to-end: client connection with the `/v1` suffix, inference via Chat
Completions, and a stateful multi-turn chat through the Conversations API.
This is the core deliverable of the workshop: a working OGX server with
verified server-side conversation state.

## Requirements

- [REQ-021] Learner MUST be able to apply an `OGXServer` manifest (ogx.io/v1beta1, `rh-dev` distribution with inline Ollama model) and observe the `Running` phase via `oc get ogxserver -o jsonpath='{.status.phase}'`
- [REQ-022] Learner MUST be able to configure an OpenAI SDK client with `base_url` including the `/v1` path suffix and list models with `custom_metadata` fields
- [REQ-023] Learner MUST be able to run a Chat Completions call whose assert (`len(response.choices) > 0`) does not raise
- [REQ-024] Learner MUST be able to create a conversation, drive three Responses API turns with the `conversation` parameter and `store=True`, and list the accumulated messages in ascending order

## Success Metrics

`OGXServer` reaches `Running`; `client.models.list()` returns at least one LLM
without raising `StopIteration`; Turn 2 and Turn 3 answers reference context
from previous turns before the conversation is deleted.

## Risks

- First deployment takes several minutes while the operator pulls images and provisions the persistent volume
- Deleting a conversation removes the conversation and its full history and cannot be undone

## Assumptions

- Learner has completed Module 01 (OGX component verified) and the Ollama inference server is reachable in-cluster

## Related Requirements

- RHAIBU-M33DSKJ262BA

## Verified By

- features/agents-mcp/ogx-agentic-api/content/modules/ROOT/pages/module-02-hands-on.adoc
