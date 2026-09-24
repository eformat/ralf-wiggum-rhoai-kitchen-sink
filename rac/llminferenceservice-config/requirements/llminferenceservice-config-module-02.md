---
schema_version: 1
id: RHAIBU-M33FS2XK1NJR
type: requirement
---
# Module 02: Deploy a Model with LLMInferenceService

## Problem

Learners must deploy a real LLM through the llm-d-native path — applying an
`LLMInferenceService` manifest from the CLI with empty `router` and `scheduler`
maps — and prove it serves authenticated chat-completions. This is the core
deliverable of the workshop: a working `LLMInferenceService` with verified
end-to-end access.

## Requirements

- [REQ-021] Learner MUST be able to apply an `LLMInferenceService` manifest (serving.kserve.io/v1alpha1) with empty `router` and `scheduler` maps from the CLI and observe the `READY: True` condition
- [REQ-022] Learner MUST be able to read the `Ready` condition via jsonpath and inspect `status.addresses` for entries with `origin.kind: Route`
- [REQ-023] Learner MUST be able to mint a ServiceAccount JWT (`oc create token ll-user`) and complete an authenticated chat-completion request returning HTTP 200
- [REQ-024] Learner MUST observe that requests without the `Authorization` header, or with an invalid/expired token, return `401 Unauthorized`

## Success Metrics

`LLMInferenceService` reaches `READY: True`; `curl` with the ServiceAccount
token returns 200 with a chat-completion body; unauthenticated and
invalid-token access is rejected with 401.

## Risks

- Deployment requires available capacity matching the template resources (1 GPU per replica, `replicas: 2`)
- Model weight download can take several minutes before `READY: True`
- Auth behavior depends on platform authentication or the `security.opendatahub.io/enable-auth` annotation (or Red Hat Connectivity Link configuration)

## Assumptions

- Learner has completed Module 01 (gateway and controllers verified) and has a reachable model location

## Related Requirements

- RHAIBU-M33FS2X4T4NW

## Verified By

- features/model-serving/llminferenceservice-config/content/modules/ROOT/pages/module-02-hands-on.adoc
