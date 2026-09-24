# Observations: MaaS Multi-tenancy (doc-derived)

## Summary

MaaS multi-tenancy is RHOAI 3.5's Technology Preview path for provisioning
isolated tenants for Models-as-a-Service so multiple teams share a single MaaS
platform without accessing each other's resources. This observation document
was produced from the official RHOAI 3.5 product documentation (Manage MaaS
multi-tenancy, §1.20 of the Govern LLM access with Models-as-a-Service guide)
because no live demo cluster was available at authoring time. Every item below
is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | maas-oidc-govern-llm.txt | §1.20.1 Models-as-a-Service multi-tenancy | Default tenant `models-as-a-service` auto-created on MaaS deploy, references `maas-default-gateway`; `Tenant` resource migrated to `MaasTenantConfig`; additional tenants via `AITenant` CRs in `ai-tenants` |
| 2 | maas-oidc-govern-llm.txt | §1.20.1 Tenant isolation boundaries | Isolated: identity realm, Gateway, namespace, API keys/JWT tokens, subscriptions/auth policies, usage data. Shared: GPU compute and model weights, PostgreSQL database, cluster infrastructure, Authorino and Limitador, observability stack |
| 3 | maas-oidc-govern-llm.txt | §1.20.1 Layered access control model | Three layers: namespace-scoped Kubernetes RBAC (controller creates Roles, admins create RoleBindings), gateway-scoped Kuadrant AuthPolicies (CEL expressions), MaaS subscription-based access control |
| 4 | maas-oidc-govern-llm.txt | §1.20.2 Multi-tenancy prerequisites | Default tenant Ready, Gateway API CRDs + `openshift-default` GatewayClass, cert-manager, Connectivity Link with Kuadrant v1.4.2+ (`spec.defaults.rules`), cluster-admin access; Gateway annotations `opendatahub.io/managed: "false"` and `security.opendatahub.io/authorino-tls-bootstrap: "true"`; AITenant naming: DNS-1123, max 41 chars |
| 5 | maas-oidc-govern-llm.txt | §1.20.3 Provision a MaaS tenant | Env vars → label infra/model namespaces (`gateway-access-<tenant>` label) → Gateway YAML with namespace-selector `allowedRoutes` → check auto-provisioned Route → `PROGRAMMED: True` → `AITenant` in `ai-tenants` with `spec.gateway.name`; optional `oidc` section (issuerUrl, clientId, ttl default 300) |
| 6 | maas-oidc-govern-llm.txt | §1.20.4 Verify a multitenant MaaS deployment | Tenant namespace labels (`ai-gateway.opendatahub.io/tenant`, `maas.opendatahub.io/managed-by-aitenant=true`), `MaasTenantConfig` in tenant namespace, `maas-api-<tenant>` deployment `READY 1/1`; authenticated `/v1/models` 200; unauthenticated 401/403; cross-tenant key against `maas-default-gateway` 404 (prevents information disclosure) |
| 7 | maas-oidc-govern-llm.txt | §1.20.5 Grant MaaS tenant access | Roles `aitenant-<tenant_name>-tenant-admin` (tenant namespace) and `aitenant-<tenant_name>-object-admin` (`ai-tenants`); controller never creates RoleBindings; `oc auth can-i create maassubscriptions...` returns `yes`; Role names truncated + hashed for long tenant names |
| 8 | maas-oidc-govern-llm.txt | §1.20.6 Delete a MaaS tenant | Finalizer ordered cleanup (revoke API keys → delete `MaasTenantConfig` → remove Roles/RoleBindings → release gateway claims → remove finalizer); `AITenant`/`MaasTenantConfig` deleted, tenant namespace + Gateway/Route + user RoleBindings preserved; stale RoleBindings warning on re-create |
| 9 | maas-oidc-govern-llm.txt | §1.20.7 AITenant custom resource reference | API group `maas.opendatahub.io` v1alpha1, short name `ait`, namespaced; spec.gateway/oidc/rbac fields; status.phase values Pending/Active/Failed/Terminating; admission webhook enforces placement + Gateway uniqueness; bootstrapped resources table; `MaasTenantConfig` spec (apiKeys.maxExpirationDays, telemetry.metrics.capture*) |
| 10 | maas-oidc-govern-llm.txt | §1.20.8–1.20.9 RBAC reference + known limitations | Tenant-admin Role verbs per resource; user-created RoleBindings preserved on delete; TP limitations: external models default-tenant-only (`DISABLE_EXTERNAL_MODEL_CONTROLLER=true` injected to avoid HTTPRoute flapping), cross-tenant access prevention at every layer, `spec.rbac` deprecated and ignored |

## User Flows

### Flow 1: Provision a tenant end to end

1. **Verify prerequisites** — default tenant Ready, GatewayClass, cert-manager, Connectivity Link/Kuadrant v1.4.2+ (§1.20.2)
2. **Prepare namespaces** — label infrastructure and model namespaces with `maas.opendatahub.io/gateway-access-<tenant_name>=true` (§1.20.3)
3. **Create dedicated Gateway** — `openshift-default` GatewayClass, HTTPS listener on 443, namespace-selector `allowedRoutes`, required annotations; confirm `PROGRAMMED: True` (§1.20.3)
4. **Create AITenant** — in `ai-tenants` with `spec.gateway.name`; optional `oidc` section for BYOIDP (§1.20.3)
5. **Watch bootstrap** — `READY: True`; tenant namespace, `MaasTenantConfig`, `maas-api-<tenant>`, AuthPolicy, Roles created (§1.20.3, §1.20.7)

### Flow 2: Verify tenant isolation

1. **Check AITenant conditions** — `status.conditions` via jsonpath (§1.20.4)
2. **Verify bootstrap artifacts** — namespace labels, `MaasTenantConfig`, `maas-api-<tenant>` deployment (§1.20.4)
3. **Authenticated request** — `oc whoami -t` token against tenant gateway `/v1/models` → 200 (§1.20.4)
4. **Negative tests** — unauthenticated → 401/403; cross-tenant API key against default gateway → 404 (§1.20.4, §1.20.9)

### Flow 3: Operate and delete a tenant

1. **Grant access** — RoleBindings for tenant-admin/object-admin Roles; verify with `oc auth can-i` (§1.20.5)
2. **Tune runtime config** — edit `MaasTenantConfig` (API key expiration, telemetry capture dimensions) (§1.20.7)
3. **Delete tenant** — `oc delete aitenant`; finalizer ordered cleanup; `NotFound` verification; preserve-namespace and stale-RoleBinding warnings (§1.20.6)

## Features and Concepts

### OpenShift Platform
- Gateway API (GatewayClass `openshift-default`, Gateway listeners/allowedRoutes/TLS), OpenShift Routes, RBAC (Roles, RoleBindings, admission webhooks), namespaces

### RHOAI / AI Platform
- `AITenant` / `MaasTenantConfig` CRs (maas.opendatahub.io/v1alpha1), per-tenant `maas-api` instances, `MaaSSubscription` / `MaaSAuthPolicy` / `MaaSModelRef` tenant-scoped resources, Red Hat Connectivity Link with Kuadrant, Authorino, Limitador

### AI/ML Fundamentals
- Multi-tenant model serving with shared GPU compute, per-tenant API-key auth and subscription quota, per-tenant observability (Prometheus/OTEL tenant dimension)

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: platform engineers with cluster-administrator OpenShift knowledge
- **Prerequisite knowledge**: base MaaS installation, `oc` CLI basics, Gateway API concepts
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with MaaS deployed, Gateway API CRDs, cert-manager, Connectivity Link with Kuadrant v1.4.2+

## Open Questions

- Whether the workshop cluster provides Connectivity Link/Kuadrant v1.4.2+ (gateway-scoped AuthPolicy requires `spec.defaults.rules`) — doc-derived prerequisite
- Whether external-access Routes are auto-provisioned on the workshop cluster's network stack or must be created manually (bare metal / restricted environments)
- Confirm the `redhat-ai-gateway-infra` infrastructure namespace default against a live 3.5 console (doc-derived)
