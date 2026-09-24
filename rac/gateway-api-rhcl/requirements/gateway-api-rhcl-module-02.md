---
schema_version: 1
id: RHAIBU-M33G4F7G1ZWN
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners need to work through the core Connectivity Link workflow end to end —
expose an API through a Gateway, secure it with TLS, and protect it with
authentication and rate-limiting policies — to internalize the
platform-engineer (gateway-level defaults) versus application-developer
(route-level overrides) split. Without this exercise the policy CRs remain
abstract and the zero-trust precedence chain is not observable.

## Requirements

- [REQ-021] Learner MUST be able to create a Gateway labeled `kuadrant.io/gateway: "true"` with `gatewayClassName: openshift-default` and an HTTPS listener, confirming `Resource accepted` and `Resource programmed, assigned to service(s)` status
- [REQ-022] Learner MUST be able to secure the listener with a self-signed ClusterIssuer and a TLSPolicy (`targetRef` to the Gateway), confirming the TLSPolicy is accepted and successfully enforced
- [REQ-023] Learner MUST be able to publish the Toystore API with an HTTPRoute whose `parentRefs` and `hostnames` match the Gateway, confirm `Route was valid`, and reach the API via `${GATEWAY_ADDRESS}` with `curl --resolve` returning `HTTP/1.1 200 OK`
- [REQ-024] Learner MUST be able to enforce a gateway-level deny-all AuthPolicy and low-limit RateLimitPolicy (HTTP 403 without an API key, `/health` HTTP 200 via predicate), then override the defaults at route level with API-key Secrets (`alice`/`bob`) and per-user RateLimitPolicy counters (alice: 200×5 then 429; bob: 200×2 then 429 per 10s window)

## Success Metrics

Learner completes all six exercises: environment setup, Gateway creation,
TLSPolicy, HTTPRoute publication with a 200 curl, gateway-default enforcement
with route-level overrides (403/200/429 patterns), and the optional DNSPolicy
exercise where cloud credentials exist.

## Risks

- Certificate issuance and policy enforcement can take several minutes between apply and enforce
- Creating API-key Secrets in the Connectivity Link system namespace requires elevated permissions

## Assumptions

- Learner completed Module 01 (control plane verified, console plugin enabled)
- The Toystore example application manifest is reachable from the cluster

## Related Requirements

- RHAIBU-M33G4F72YVSZ

## Verified By

- features/platform-gateway/gateway-api-rhcl/content/modules/ROOT/pages/module-02-hands-on.adoc
