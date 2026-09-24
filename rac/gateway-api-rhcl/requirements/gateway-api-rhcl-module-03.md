---
schema_version: 1
id: RHAIBU-M33G4F7RYCAM
type: requirement
---
# Module 03: Advanced Usage

## Problem

After the core gateway workflow, learners need the advanced capabilities that
matter for protecting real LLM inference traffic: client-visible rate-limit
headers, token-based rate limiting for OpenAI-compatible APIs, OIDC/JWT
authentication with a real identity provider, and observability across
gateways, policies, and requests. Without this module, learners cannot connect
the policy CRs to how LLM APIs actually cost resources (tokens, not request
counts), how a gateway validates JWT bearer tokens from an OIDC issuer, or how
a single request is followed across Envoy, Authorino, and Limitador.

## Requirements

- [REQ-031] Learner MUST be able to patch the Limitador CR with `rateLimitHeaders: DRAFT_VERSION_03` and observe `x-ratelimit-limit`, `x-ratelimit-remaining`, and `x-ratelimit-reset` headers on an API response
- [REQ-032] Learner MUST be able to create a TokenRateLimitPolicy targeting the Gateway (predicate `request.path == "/v1/chat/completions"`, per-user counters on `auth.identity.userid`) and confirm `Accepted` and `Enforced` conditions with `status: "True"`
- [REQ-033] Learner MUST be able to enable observability on the Kuadrant CR (`spec.observability.enable: true`) and confirm ServiceMonitor and PodMonitor resources labeled `kuadrant.io/observability=true` in the Connectivity Link and gateway namespaces
- [REQ-034] Learner SHOULD be able to import the example Grafana dashboards (IDs 21538, 20982, 20981, 22695) and correlate Envoy access logs with traces via the shared `x-request-id`
- [REQ-035] Learner MUST be able to create an AuthPolicy targeting the HTTPRoute with `rules.authentication."oidc-idp-auth".jwt.issuerUrl` pointing at an OIDC issuer (for example, Red Hat build of Keycloak), in the same namespace as the HTTPRoute, and confirm `Accepted` and `Enforced` conditions
- [REQ-036] Learner SHOULD be able to request an access token from the OIDC issuer with the Keycloak Direct Access grant (`grant_type=password`, client `demo`, user `john`) and observe an unauthenticated request returning HTTP 401 while a request with `Authorization: Bearer $ACCESS_TOKEN` returns HTTP 200

## Success Metrics

Learner completes all three core exercises: rate-limit headers observed on a
response, TokenRateLimitPolicy Accepted+Enforced, and the observability
monitors listed; the optional Grafana dashboard import succeeds where Grafana
is installed. Where the workshop environment provides a live OIDC issuer, the
optional OIDC exercise shows 401 without a token and 200 with a Bearer token.

## Risks

- The Toystore app returns no `usage.total_tokens`, so token-exhaustion 429s cannot be observed — only policy acceptance and enforcement
- Grafana dashboards require a pre-installed Grafana instance and the user-workload monitoring stack
- The OIDC exercise requires a live OIDC issuer (Red Hat build of Keycloak with the `kuadrant` realm, `demo` client, and `john` user) reachable from within the cluster; without one the AuthPolicy cannot be enforced and tokens cannot be issued, so only policy acceptance may be observable
- Only one AuthPolicy can target the same HTTPRoute, so the OIDC policy replaces the Module 02 API-key route policy until it is re-created

## Assumptions

- Learner re-created the Module 02 environment variables and the gateway/policies from Module 02 still exist
- Where the OIDC exercise is run, a trusted OIDC provider issues tokens and, if it uses a self-signed or internal cluster certificate, the trusted CA bundle was injected into the Connectivity Link installation

## Related Requirements

- RHAIBU-M33G4F72YVSZ

## Verified By

- features/platform-gateway/gateway-api-rhcl/content/modules/ROOT/pages/module-03-advanced.adoc
