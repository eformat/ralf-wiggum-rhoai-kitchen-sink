# Observations: MaaS External OIDC Authentication (doc-derived)

## Summary

MaaS external OIDC user authentication is RHOAI 3.5's GA path for
authenticating Models-as-a-Service users through an external OpenID Connect
(OIDC) identity provider, enabling enterprise-wide access without requiring
OpenShift accounts for every user. This observation document was produced from
the official RHOAI 3.5 product documentation (Govern LLM access with
Models-as-a-Service, §1.19 Configure external OIDC authentication for
Models-as-a-Service) because no live demo cluster was available at authoring
time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | maas-oidc-govern-llm.txt | §1.19.1.1 Authentication flow | Two-tier flow: OIDC token from the external provider for platform APIs; API keys created through the MaaS API using the OIDC token for model access. Dashboard does not support API key creation for external OIDC users (it uses OpenShift OAuth) |
| 2 | maas-oidc-govern-llm.txt | §1.19.1.2 Group-based access control | MaaS validates IdP groups directly from OIDC token `groups` claims; group names in subscriptions and authorization policies must match token claims exactly, with no OpenShift group creation or synchronization |
| 3 | maas-oidc-govern-llm.txt | §1.19.1.3 API key lifecycle | Five-step key creation (OIDC token → MaaS API call → token validation → key generated with requested expiration up to the `MaasTenantConfig` maximum → model access); keys snapshot group memberships at creation and keep working after group removal until revoked or expired |
| 4 | maas-oidc-govern-llm.txt | §1.19.1.4 Use cases | Enterprise deployment (existing IdPs such as Keycloak), service provider deployment (centralized OIDC with subscription isolation and quota), regulated industries (centralized authentication and audit logging) |
| 5 | maas-oidc-govern-llm.txt | §1.19.2 Configure MaaS for external OIDC users | Edit the `AITenant` CR: console path Administration → CustomResourceDefinitions → AITenant → Instances → models-as-a-service → YAML, or CLI `oc patch aitenants.maas.opendatahub.io models-as-a-service -n ai-tenants --type merge`; `spec.oidc` fields are `clientId`, `issuerUrl`, `ttl` (default 300, minimum 30) |
| 6 | maas-oidc-govern-llm.txt | §1.19.2 Verification | `curl -H "Authorization: Bearer <oidc-token>" https://<maas-gateway-url>/maas-api/v1/models` returns the model list for the token's groups; empty list means valid token but no matching subscription groups |

## User Flows

### Flow 1: Configure the AITenant for an external OIDC provider

1. **Meet prerequisites** — cluster admin, RHOAI installed, MaaS deployed, external OIDC provider with registered client application, user groups, group claims in ID tokens (§1.19.2 Prerequisites)
2. **Edit AITenant** — console CRD YAML editor or `oc patch` with `spec.oidc`: `clientId`, `issuerUrl`, `ttl` (§1.19.2 Procedure)
3. **Create subscriptions** — include the groups from the OIDC provider, names matching token claims exactly (§1.19.2 Next steps note)

### Flow 2: Verify external OIDC authentication

1. **Obtain a user access token** — interactive flow such as authorization code or device grant (§1.19.2 Verification)
2. **List models** — `curl -H "Authorization: Bearer <oidc-token>" https://<maas-gateway-url>/maas-api/v1/models`; success returns the models available to the token's groups (§1.19.2 Verification)
3. **Interpret an empty list** — token is valid but no subscription group matches the token's claims (§1.19.2 Verification)

## Features and Concepts

### OpenShift Platform
- OpenShift authentication (dashboard uses OpenShift OAuth), Gateways and Routes for the MaaS API gateway, RBAC for cluster administration

### RHOAI / AI Platform
- `AITenant` custom resource (source of truth for OIDC configuration in 3.5), `MaasTenantConfig` (API key expiration limits, external OIDC settings; legacy `Tenant` resource is deprecated and migrates to it), MaaS subscriptions and authorization policies, MaaS management API (`/maas-api/v1/models`, accepts both OIDC tokens and API keys)

### AI/ML Fundamentals
- Token-based identity federation (OIDC/JWT), group-claim authorization, API key lifecycle management, token rate limits per model

## Workshop Potential

- **Estimated modules**: 2 (configure OIDC authentication → govern access and verify)
- **Target audience**: platform engineers and cluster administrators
- **Prerequisite knowledge**: OpenShift administration, OIDC concepts, MaaS basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with MaaS deployed plus an external OIDC provider (e.g. Keycloak) with a registered client application and group-bearing ID tokens

## Open Questions

- Exact `Settings → MaaS governance` dashboard label on a live 3.5 console (doc-derived path)
- Whether the legacy `Tenant` → `MaasTenantConfig`/`AITenant` migration path needs its own exercise for upgrade scenarios (doc mentions automatic migration during upgrade)
- API key creation flow via the MaaS API is referenced by the verification NOTE but not exercised in the modules — confirm whether a third exercise is wanted in the Act phase
