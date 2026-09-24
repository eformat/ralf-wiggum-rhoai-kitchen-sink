---
schema_version: 1
id: RHAIBU-M33EHKADNAR7
type: requirement
---
# Module 02: Run a Risk Assessment

## Problem

Learners must register their project as an EvalHub tenant, authenticate to
EvalHub with a bearer token, and run an intent-based risk assessment against a
model endpoint through the EvalHub API. This is the core deliverable of the
workshop: a submitted scan with a `202 Accepted` job and a readable report.

## Requirements

- [REQ-021] Learner MUST be able to label the project namespace with `evalhub.trustyai.opendatahub.io/tenant=` and verify the operator-provisioned ServiceAccount, RoleBindings, and service CA ConfigMap
- [REQ-022] Learner MUST be able to create a ServiceAccount with an EvalHub-access Role and RoleBinding, mint a token with `oc create token`, and confirm `curl $EVALHUB_URL/api/v1/health` returns `healthy`
- [REQ-023] Learner MUST be able to list the registered providers with `Authorization: Bearer` and `X-Tenant` headers and confirm `garak` is enabled
- [REQ-024] Learner MUST be able to submit an `intents-scan.json` request (benchmark `id: intents`, `provider_id: garak-kfp`) to `/api/v1/evaluations/jobs` and receive `202 Accepted` with a job ID
- [REQ-025] Learner MUST observe the report's overview metrics: Total attempts, Unsafe prompts, Safe prompts, and the primary Attack Success Rate (ASR)

## Success Metrics

Tenant label and operator RBAC verified; health endpoint returns `healthy` and
the providers list includes `garak`; the scan submission returns `202 Accepted`
and the report metrics are read from the completed run.

## Risks

- Tokens created with `oc create token` expire; a `401 Unauthorized` later in the module requires minting a new token
- Submission requires an OpenAI-compatible target endpoint, a separate judge endpoint, an S3 endpoint, and a model API key Secret

## Assumptions

- Learner has completed Module 01 (components verified) and has a model endpoint with a judge model

## Related Requirements

- RHAIBU-M33EHK9KK941

## Verified By

- features/evaluation/automated-red-teaming-garak/content/modules/ROOT/pages/module-02-hands-on.adoc
