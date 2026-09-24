---
schema_version: 1
id: RHAIBU-M33DSKJ262BA
type: requirement
---
# OGX-native Agentic API Surface Workshop

## Problem

AI engineers and data scientists evaluating RHOAI 3.5 need hands-on experience
with the OGX-native agentic API surface — Tool Runtime, Responses, and
Conversations — before they can build agentic and RAG applications on
OpenShift AI. Without a structured workshop, learners must reverse-engineer the
two API layers (native OGX vs OpenAI-compatible), the OGXServer CR, and the
client connection rules (`base_url` with `/v1` suffix) from product
documentation alone. This workshop targets RHOAI users with working knowledge
of OpenShift and Python.

## Requirements

- [REQ-001] Learner MUST be able to verify the OGX Operator is installed by locating the `OGXServer` custom resource definition in the console (`CustomResourceDefinitions` search for `ogxservers`)
- [REQ-002] Learner MUST be able to verify the `ogx` component reports `managementState: Managed` on the DataScienceCluster and the `ogxservers.ogx.io` CRD is registered
- [REQ-003] Learner MUST be able to deploy an `OGXServer` (ogx.io/v1beta1) from a YAML manifest and confirm it reaches the `Running` phase with a service exposing port `8321`
- [REQ-004] Learner MUST be able to connect an OpenAI SDK client to the OGX route (`base_url` with the `/v1` path suffix) and list models
- [REQ-005] Learner MUST be able to sanity-check inference with a Chat Completions call returning at least one choice
- [REQ-006] Learner MUST be able to drive a multi-turn, stateful chat with the Conversations API (`conversation` parameter instead of `previous_response_id`) and list the accumulated messages
- [REQ-007] Learner SHOULD be able to run a RAG workflow with the Files, Vector Stores, and Responses APIs using the `file_search` tool
- [REQ-008] Learner SHOULD be able to inspect `file_citation` annotations in Responses API output
- [REQ-009] Learner SHOULD be able to observe Responses API guardrails opt-in (`guardrails: true`) and its fail-closed behavior

## Success Metrics

All nine acceptance criteria are demonstrated by the learner during the lab;
the `OGXServer` reaches `Running: phase` in module 02, the multi-turn
conversation retains context across three turns, and the `file_search` answer
is grounded in the uploaded document.

## Risks

- The feature is Technology Preview in 3.5 — endpoints, parameters, and support levels may change between releases
- Support levels differ within the API surface (Responses API is GA in the 3.5 docs; Conversations API is TP; Tool Runtime and Vector_IO are DP)
- The RHOAI 3.5 docs include no worked client example for the Tool Runtime API, so that exercise is a survey only

## Assumptions

- RHOAI 3.5 is installed with the OGX component enabled in the DataScienceCluster
- Learners have `oc` CLI access, workshop credentials (`{user}`, `{guid}`), and a Python environment (workbench notebook or local)
- An Ollama inference server (`rh-dev` distribution default) is reachable in-cluster for the self-contained workshop deployment

## Related Designs

- RHAIBU-M33DSKK6SJYQ

## Related Decisions

- RHAIBU-M33DSKJPBSJV
- RHAIBU-M33DSKJZ56VT

## Related Requirements

- RHAIBU-M33DSKJ7R2YW
- RHAIBU-M33DSKJC1RWP
- RHAIBU-M33DSKJGR1E2
