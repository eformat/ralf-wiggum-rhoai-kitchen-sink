# Observations: Gateway API and Red Hat Connectivity Link (RHCL) (doc-derived)

## Summary

Gateway API and Red Hat Connectivity Link (RHCL 1.4) is RHOAI 3.5's GA path for
managing, securing, and observing inference gateway traffic on OpenShift.
Connectivity Link is a control plane that applies authentication, rate limiting,
TLS, and DNS policies to standard Kubernetes Gateway API resources. This
observation document was produced from the official RHCL 1.4 product
documentation (Connectivity Link overview; Install Connectivity Link; Secure
your Gateway API deployments; Observability) because no live demo cluster was
available at authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | rhcl-overview.txt | About Connectivity Link | Four Operators in one catalog: Connectivity Link (Kuadrant), Authorino (authn/authz), Limitador (rate limiting), DNS (multi-cluster DNS); updates flow through OLM dependencies |
| 2 | rhcl-install-connectivity-link.txt | Single-cluster installation | Subscription `rhcl-operator`, channel `stable`, install namespace `kuadrant-system`, then an empty-spec Kuadrant CR activates the control plane; console plugin `kuadrant-console-plugin` enabled via Dynamic Plugins |
| 3 | rhcl-deploy-connectivity-link.txt | Gateway + TLSPolicy | Gateway with `gatewayClassName: openshift-default`; TLSPolicy provisions certificates via cert-manager; TLSPolicy reports Accepted and Enforced |
| 4 | rhcl-deploy-connectivity-link.txt | Zero-trust AuthPolicy | Gateway-level deny-all AuthPolicy (OPA `allow = false`) means no traffic flows unless a specific allow rule exists; route-level AuthPolicy required per application developer |
| 5 | rhcl-deploy-connectivity-link.txt | API key authentication | API-key Secrets labeled `authorino.kuadrant.io/managed-by: authorino` in the system namespace; clients send `Authorization: APIKEY <key>`; requests return 403 without credentials |
| 6 | rhcl-deploy-connectivity-link.txt | RateLimitPolicy + DNSPolicy | Gateway-level low-limit default overridden at route level with per-user `counters`; DNSPolicy with `healthCheck`, `loadBalancing` geo/weight publishes the Gateway hostname via cloud DNS providers (Route 53, Google Cloud DNS, Azure DNS) |
| 7 | rhcl-observability.txt | Observability capabilities | Prometheus metrics, distributed tracing with Red Hat build of OpenTelemetry, Envoy access logs with request correlation, pre-built Grafana dashboards; `spec.observability.enable` creates ServiceMonitor and PodMonitor CRs |

## User Flows

### Flow 1: Install and enable the control plane (platform engineer)

1. **Install Operators** — Subscription `rhcl-operator`, channel `stable`, namespace `kuadrant-system` (§ rhcl-install)
2. **Activate the control plane** — empty-spec Kuadrant CR; Authorino, Limitador, and DNS Operators install automatically (§ rhcl-install)
3. **Enable the console plugin** — Dynamic Plugins > View all → `kuadrant-console-plugin` → Enable (§ rhcl-install)

### Flow 2: Expose and secure an API (platform engineer + developer)

1. **Create the Gateway** — `gatewayClassName: openshift-default`, HTTPS listener, TLS terminate mode (§ rhcl-deploy)
2. **Program the listener** — TLSPolicy via cert-manager; status Accepted + Enforced (§ rhcl-deploy)
3. **Publish the API** — HTTPRoute with `parentRefs` to the Gateway; route status valid (§ rhcl-deploy)
4. **Set zero-trust defaults** — gateway-level deny-all AuthPolicy and low-limit RateLimitPolicy; 403 without credentials (§ rhcl-deploy)
5. **Override at route level** — API-key authentication and per-user rate-limit counters (§ rhcl-deploy)

### Flow 3: Protect and observe LLM inference traffic

1. **Token-based limits** — TokenRateLimitPolicy extracts `usage.total_tokens` from OpenAI-style responses as a `hits_addend` to Limitador (§ module 03 / rhcl docs)
2. **Enable observability** — `spec.observability.enable: true` on the Kuadrant CR creates ServiceMonitors and PodMonitors (§ rhcl-observability)
3. **Correlate requests** — Envoy access logs and traces share `x-request-id`; dashboards follow one request across Envoy, Authorino, and Limitador (§ rhcl-observability)

## Features and Concepts

### OpenShift Platform
- Kubernetes Gateway API (Gateway, HTTPRoute, GRPCRoute), GatewayClass `openshift-default` (Cluster Ingress Operator), OpenShift Service Mesh (required on OpenShift 4.18 or older and for mTLS), cert-manager, OLM subscriptions

### RHOAI / AI Platform
- Connectivity Link policy CRs (`AuthPolicy`, `RateLimitPolicy`, `TokenRateLimitPolicy`, `DNSPolicy`, `TLSPolicy`) attached with a consistent `targetRef` pattern; `kuadrant.io/*` labels are load-bearing for resource filtering; Kuadrant CR `spec.observability.enable` flag

### AI/ML Fundamentals
- Token-based rate limiting matches LLM cost models (tokens, not request counts); OpenAI-compatible chat-completions endpoints on model serving; per-user/group token budgets (free vs pro tiers)

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: OpenShift basics, `oc` CLI, basic Gateway API concepts
- **Estimated duration**: about 2 hours
- **Cluster requirements**: RHOAI 3.5, Connectivity Link 1.4.1+ installed by a cluster-admin, cert-manager Operator; `cluster-admin` only for install and console-plugin steps

## Open Questions

- Exact console-plugin navigation labels on a live console (doc-derived path)
- Cloud DNS provider credential availability for the DNSPolicy exercise in workshop clusters
- Grafana instance availability for importing the example dashboards (IDs 21538, 20982, 20981, 22695)
