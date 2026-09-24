---
schema_version: 1
id: RHAIBU-M33G4F72YVSZ
type: requirement
---
# Gateway API and Red Hat Connectivity Link (RHCL) Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with Gateway API and Red Hat Connectivity Link (RHCL) — the GA path
for managing, securing, and observing inference gateway traffic — before they
can expose model-serving APIs in production. Without a structured workshop,
learners must reverse-engineer the four-Operator composition, the policy CR
attachment model (`targetRef`), and the gateway-default/route-override
precedence rules from product documentation alone. This workshop targets RHOAI
users with working knowledge of OpenShift and basic networking concepts.

## Requirements

- [REQ-001] Learner MUST be able to describe how Connectivity Link applies policies to standard Gateway API resources, name the four Operators (Connectivity Link/Kuadrant, Authorino, Limitador, DNS) and the policy CRs each enables, and locate the Red Hat Connectivity Link Operator in *Ecosystem > Installed Operators*
- [REQ-002] Learner MUST be able to derive the `kuadrant-system` namespace and verify the Connectivity Link control plane is ready (`oc wait kuadrant/kuadrant --for="condition=Ready=true"` prints `kuadrant.kuadrant.io/kuadrant Ready`) with all four component Operator pods `2/2 Running`
- [REQ-003] Learner MUST be able to enable the `kuadrant-console-plugin` (Dynamic Plugins > View all) and confirm a *Connectivity Link* menu item appears in the console navigation sidebar
- [REQ-004] Learner MUST be able to create a Gateway with `gatewayClassName: openshift-default` that reports `Resource accepted` and `Resource programmed, assigned to service(s)`, and secure its HTTPS listener with a ClusterIssuer + TLSPolicy reporting accepted and successfully enforced
- [REQ-005] Learner MUST be able to publish an API with an HTTPRoute attached to the Gateway, confirm the route status `Route was valid`, and reach the API through the gateway load balancer with an `HTTP/1.1 200 OK` response
- [REQ-006] Learner MUST be able to enforce a gateway-level deny-all AuthPolicy and low-limit RateLimitPolicy (HTTP 403 without credentials, `/health` HTTP 200 via predicate), then override the defaults at route level with API-key authentication and per-user limits (alice: 200×5 then 429; bob: 200×2 then 429 per 10s window)
- [REQ-007] Learner MUST be able to add `x-ratelimit-limit`, `x-ratelimit-remaining`, and `x-ratelimit-reset` headers to API responses by patching the Limitador CR with `rateLimitHeaders: DRAFT_VERSION_03`
- [REQ-008] Learner MUST be able to create a TokenRateLimitPolicy targeting the Gateway for OpenAI-compatible inference traffic and confirm `Accepted` and `Enforced` conditions with `status: "True"`
- [REQ-009] Learner SHOULD be able to enable Connectivity Link observability on the Kuadrant CR and confirm ServiceMonitor and PodMonitor resources labeled `kuadrant.io/observability=true`
- [REQ-010] Learner SHOULD be able to connect the Gateway to cloud DNS with a DNSPolicy (provider credentials Secret, health check, load-balancing strategy) and confirm healthy sub-resources

## Success Metrics

All eight MUST criteria are demonstrated by the learner during the lab: the
Toystore API is served through a TLS-secured gateway with HTTP 200, the
policy precedence chain is observable with plain `curl` (403/200/429), the
TokenRateLimitPolicy is enforced, and the observability monitors are listed.
The two SHOULD criteria (observability dashboards, DNSPolicy) are demonstrated
where the environment provides cloud DNS credentials and Grafana.

## Risks

- Writing API-key Secrets to the Connectivity Link system namespace requires elevated permissions; facilitators must pre-create them if learners lack cluster-scope write access
- cert-manager Operator must be installed for the TLSPolicy exercise to issue certificates
- Certificate issuance and policy enforcement can take several minutes, stretching module pacing
- TokenRateLimitPolicy full enforcement (429 on token exhaustion) cannot be observed against the Toystore app because it returns no `usage.total_tokens`

## Assumptions

- RHOAI 3.5 is installed with Connectivity Link 1.4.1+ installed by a cluster-admin
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- OpenShift 4.19+ is in use so the Cluster Ingress Operator is the default Gateway API controller (Service Mesh not required)
- No cloud DNS provider credentials are available by default, so exercises use `curl --resolve` against the gateway load balancer address

## Related Designs

- RHAIBU-M33G4F8NCB5J

## Related Decisions

- RHAIBU-M33G4F81KQ3W
- RHAIBU-M33G4F8BRPGY

## Related Requirements

- RHAIBU-M33G4F79QYS0
- RHAIBU-M33G4F7G1ZWN
- RHAIBU-M33G4F7RYCAM
