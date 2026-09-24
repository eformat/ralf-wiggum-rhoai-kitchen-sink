# Observations: Models-as-a-Service (MaaS) core (doc-derived)

## Summary

Models-as-a-Service (MaaS) is RHOAI 3.5's GA subscription-based governance layer
for large language model serving on OpenShift. This observation document was
produced from the official RHOAI 3.5 product documentation (Govern LLM access
with Models-as-a-Service) because no live demo cluster was available at
authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | maas-core-govern-llm.txt | §1.1 Configure Models-as-a-Service | Subscription-based governance layer between users and model serving; capabilities: subscription quota, self-service API keys, OpenAI API compatibility, multi-runtime (vLLM TP), usage tracking (TP), external models (TP), multi-provider passthrough (TP), multi-tenancy (TP) |
| 2 | maas-core-govern-llm.txt | §1.2 Platform and operator prerequisites | OCP 4.19.9+, RHOAI 3.4+, llm-d enabled with authentication for LLMInferenceService, Connectivity Link Operator 1.4.x + ready Kuadrant CR, DSC `kserve: Managed`, User Workload Monitoring required (else `Degraded`), PostgreSQL 14+ for API key lifecycle |
| 3 | maas-core-govern-llm.txt | §1.9 Verify Models-as-a-Service deployment | `oc get crd \| grep -E 'maas.opendatahub.io\|aitenants'` shows six CRDs; default-tenant `READY: True` with reason `Reconciled`; `False`/`Degraded` indicates missing prerequisites |
| 4 | maas-core-govern-llm.txt | §1.11 Subscriptions | Since 3.4 tiers replaced with subscriptions (CRD-based, GitOps-compatible); `MaaSSubscription` properties (name, description, groups, models, token rate limits, priority); recommended priority scheme production 100, staging 50, development 0, personal -10; explicit subscription choice bypasses priority selection |
| 5 | maas-core-govern-llm.txt | §1.11.6 Relationship with authorization policies | Both subscription and matching authorization policy required; `Create matching authorization policy` checkbox snapshots the subscription's groups and models |
| 6 | maas-core-govern-llm.txt | §1.16 Manage API keys for users | Admin API-keys page columns (Name, Status Active/Expired/Revoked, Subscription, Owner, Created, Last used, Expires); create-on-behalf-of-user; revoke user keys; `maxExpirationDays` cap in Tenant CR |
| 7 | maas-core-govern-llm.txt | §1.17 CLI and API | Management API `/maas-api/v1` (keys, models, access; accepts OIDC tokens and API keys); inference API OpenAI-compatible with body-based routing (recommended) and legacy `/llm/<model-name>/v1` path routing; API keys carry `sk-oai-` prefix |
| 8 | maas-core-govern-llm.txt | §1.19.1.3 API key lifecycle | OIDC-created keys capture group memberships at creation time; removing a user from a group does not revoke access until keys are revoked or expired |
| 9 | maas-core-govern-llm.txt | §2.2.7 Token limit responses | Exceeded token limits return `token_limit_error` code 429 with `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`, `Retry-After` headers |
| 10 | maas-core-govern-llm.txt | §1.8, §1.20 Observability and multi-tenancy | Usage dashboard requires `observabilityDashboard: true` in `OdhDashboardConfig`; both are Technology Preview; multi-tenancy provisions isolated tenants with dedicated gateway/identity realm (AITenant CRs) |

## User Flows

### Flow 1: Consume a governed model as a user

1. **Discover** — Gen AI studio → AI asset endpoints; *Model as a Service* badge; copy external endpoint URL (§2.2)
2. **Authenticate** — generate a 1-hour temporary key or create a persistent key bound to a subscription; key displayed once, `sk-oai-` prefix (§2.2.4, §2.2.10)
3. **Call** — OpenAI-compatible `/v1/chat/completions` with the model name in the request body; `usage` object reports tokens charged to quota (§1.17.1.1)
4. **Handle limits** — 429 with `X-RateLimit-*` and `Retry-After` headers when the token limit is exceeded (§2.2.7)

### Flow 2: Govern access as an administrator

1. **Verify platform** — CRDs, User Workload Monitoring, Tenant `Ready`/`Reconciled` (§1.9)
2. **Define governance** — Settings → MaaS governance; create subscription with token limits per model; optionally create a matching authorization policy (§1.14.2, §1.11.6)
3. **Declarative equivalent** — `MaaSSubscription` and `MaaSAuthPolicy` CRs in `models-as-a-service` namespace referencing `MaaSModelRef` in the model's project namespace (§1.17.2)
4. **Operate** — revoke keys, cap `maxExpirationDays`, monitor token consumption on the Usage dashboard (§1.16, §1.18)

## Features and Concepts

### OpenShift Platform
- Gateway API infrastructure (Connectivity Link/Kuadrant, Authorino), User Workload Monitoring, PostgreSQL, RBAC (groups from OpenShift or external OIDC)

### RHOAI / AI Platform
- `MaaSModelRef`, `MaaSSubscription`, `MaaSAuthPolicy`, `Tenant`/`MaaS TenantConfig`/`AITenant` CRs, MaaS controller-generated `AuthPolicy`/`TokenRateLimitPolicy` resources, MaaS governance and Usage dashboard surfaces

### AI/ML Fundamentals
- Token-based quota (prompt/completion/total tokens), rate limiting, OpenAI API compatibility, body-based model routing

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: platform engineers and administrators with OpenShift working knowledge
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with MaaS enabled, Connectivity Link/Kuadrant stack, User Workload Monitoring, PostgreSQL secret; a facilitator-published model with a group-assigned subscription for the hands-on module

## Open Questions

- Exact `Settings → MaaS governance` menu label on a live console (doc-derived path)
- Aggregated `maas-gateway-auth` AuthPolicy visibility in workshop clusters (doc-derived 3.5 controller behavior)
- Whether the workshop cluster's Usage dashboard has the observability stack configured (module 03 verification depends on it)
