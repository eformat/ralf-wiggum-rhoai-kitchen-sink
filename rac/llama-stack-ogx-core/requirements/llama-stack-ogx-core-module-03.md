---
schema_version: 1
id: RHAIBU-M33FZEMBGM12
type: requirement
---
# Module 03: Advanced Usage

## Problem

After a working RAG loop, practitioners need to tune retrieval quality, keep the
OGX server available under failure and load, make uploaded files survive pod
restarts, and lock down the OGX API itself. This module covers search modes, high
availability and autoscaling, external S3-compatible Files API storage, and OAuth
token authentication for the OGX API.

## Requirements

- [REQ-031] Learner MUST be able to run `vector_io.query()` with keyword, vector, and hybrid search modes and articulate the precision versus recall tradeoff between the results
- [REQ-032] Learner SHOULD be able to inspect the auto-provisioned Gen AI Studio playground pgvector resources by the `gen-ai.opendatahub.io/pgvector` label
- [REQ-033] Learner SHOULD be able to configure high availability on the OGXServer CR (`replicas`, `podDisruptionBudget`, `topologySpreadConstraints`) and observe pod counts within bounds
- [REQ-034] Learner SHOULD be able to enable autoscaling (`minReplicas`, `maxReplicas`, CPU and memory targets) and verify the HPA with `oc get hpa`
- [REQ-035] Learner SHOULD be able to enable the `remote::s3` files provider and confirm it registers via the `/v1/providers` endpoint
- [REQ-036] Learner SHOULD be able to upload a file through the OpenAI-compatible `/v1/files` endpoint and confirm storage in the S3 bucket
- [REQ-037] Learner MUST be able to issue OAuth access tokens from an OIDC provider (password grant) and inspect the token claims (`iss`, `sub`, `preferred_username`, `ogx_roles`)
- [REQ-038] Learner MUST be able to configure the `oauth2_token` provider in a custom `run.yaml` (JWKS URI, key recheck period, issuer, audience, claims mapping) mounted through the OGXServer `userConfig`, and observe that requests without a Bearer token are rejected with HTTP 401 while an authenticated request to a permitted model returns HTTP 200
- [REQ-039] Learner SHOULD be able to apply role-based `access_policy` rules and observe HTTP 403 for a restricted model requested with a token that lacks the required role

## Success Metrics

Learner completes all four exercises: the three search-mode queries complete
without errors, the HPA targets the OGX server with replicas within bounds, the
provider list contains `"provider_id": "s3"` with a successful file upload, and
the secured OGX API rejects unauthenticated requests with HTTP 401, returns
HTTP 200 for an authenticated request to a permitted model, and returns HTTP 403
for a restricted model with a token that lacks the role.

## Risks

- Search mode availability depends on the vector store provider; keyword or hybrid search may return empty results on some providers
- A missing S3 bucket with `S3_AUTO_CREATE_BUCKET: "false"` puts the OGX pod in `CrashLoopBackOff`
- Changing replica configuration recreates OGX server pods
- The auto-provisioned playground vector store is Technology Preview and dev-only
- The OAuth exercise requires an OIDC issuer (for example Keycloak) reachable from the cluster; a workshop cluster may not provide one
- The restricted-model HTTP 403 check assumes an OpenAI provider is configured on the server, following the documented example

## Assumptions

- Learner has completed Module 02 (a running OGXServer with an ingested corpus and an S3-compatible object store available)
- For the OAuth exercise, an OIDC issuer is available with the documented example settings: realm `ogx-demo`, client `ogx` with direct access grants, role `inference_max`, an `ogx_roles` protocol mapper, and test users `user1` and `user2`

## Related Requirements

- RHAIBU-M33FZEKGR1M7

## Verified By

- features/ogx/llama-stack-ogx-core/content/modules/ROOT/pages/module-03-advanced.adoc
