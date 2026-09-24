# Observations: Platform-wide direct OIDC authentication (GatewayConfig CR) (doc-derived)

## Summary

Platform-wide direct OIDC authentication is RHOAI 3.5's GA centralized
authentication service: one authentication service routes ingress traffic for
all services behind a single domain, configured with the `GatewayConfig` CR on
OpenShift Gateway API (OCP 4.19.9 or later). This observation document was
produced from the official RHOAI 3.5 product documentation (Managing OpenShift
AI, Chapter 10: Configure a central authentication service for an external OIDC
provider) because no live demo cluster was available at authoring time. Every
item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | oidc-managing-openshift-ai.txt | §10.1 Centralized authentication service for external OIDC providers | One client ID and secret from the external IdP; backend services assume traffic is authenticated; authorization stays at service/pod level with `kube-rbac-proxy` sidecars; gateway-to-backend traffic fully encrypted with TLS |
| 2 | oidc-managing-openshift-ai.txt | §10.1.1 Authentication methods | Two methods: user authentication via OIDC (interactive browser) and service account token authentication (programmatic/CLI); based on Gateway API support in OCP 4.19.9 or later |
| 3 | oidc-managing-openshift-ai.txt | §10.2 Configure OIDC for the centralized authentication service | Prerequisite checks: `oc get authentication.config/cluster` (`type: OIDC`, `oidcProviders`), `oc get co kube-apiserver`; create secret in `openshift-ingress`; patch `gatewayconfig default-gateway` with `oidc.issuerURL`, `clientID`, `clientSecretRef`; verify `.spec.oidc` |
| 4 | oidc-managing-openshift-ai.txt | §10.2 Verification | Console login redirects to the OIDC provider and back; GatewayConfig YAML shows `Ready` and `ProvisioningSucceeded` conditions `True`; `kube-auth-proxy` `1/1` in `openshift-ingress`; `data-science-gateway` `PROGRAMMED True`; discovery endpoint returns JSON |
| 5 | oidc-managing-openshift-ai.txt | §10.2 Next steps (authorization) | `odh-projects-read` ClusterRole (`project.openshift.io` projects get/list) + `oc adm policy add-cluster-role-to-group` for the IdP group and `self-provisioner` |
| 6 | oidc-managing-openshift-ai.txt | §10.3 Configure service token auth | ServiceAccount + Role (`services/proxy`, `resourceNames`) + RoleBinding + `oc create token --duration=1h`; bearer-token curl returns HTTP 200, invalid/missing tokens return 403 or redirect; min token duration 10 minutes |
| 7 | oidc-managing-openshift-ai.txt | §10.4 Configure custom CA certificates | `oc create secret generic <oidc-ca-bundle> --from-file=ca.crt=...` in `openshift-ingress`; reference via `spec.providerCASecretName`; `insecureSkipVerify: true` is dev/test only |
| 8 | oidc-managing-openshift-ai.txt | §10.5 Troubleshooting reference | `Ready: False` diagnosis (`oc get`/`describe gatewayconfig`), issuer URL check (`curl -I` → `HTTP/2 200`, `content-type: application/json`), CrashLoopBackOff `kube-auth-proxy` with private CAs, token duration error (<10m rejected), HTTP 401 from expired tokens or missing TokenReview permissions |

## User Flows

### Flow 1: Configure OIDC for the platform gateway

1. **Verify cluster prerequisites** — `type: OIDC`, provider configured, `kube-apiserver` rollout complete (§10.2)
2. **Create the client secret** — `oc create secret generic idp-client-secret --from-literal=clientSecret=... -n openshift-ingress` (§10.2)
3. **Patch the GatewayConfig** — `default-gateway` with `issuerURL`, `clientID`, `clientSecretRef` (§10.2)
4. **Verify** — secret exists (`Opaque`, 1 data item); `.spec.oidc` matches IdP values (§10.2)

### Flow 2: Verify, authorize, and troubleshoot

1. **Verify end to end** — console login redirect through the IdP; `Ready` + `ProvisioningSucceeded` conditions `True`; `kube-auth-proxy` `1/1`; `data-science-gateway` `PROGRAMMED True`; discovery endpoint JSON (§10.2 Verification)
2. **Authorize groups** — `odh-projects-read` ClusterRole + `self-provisioner` bound to the `odh-users` IdP group (§10.2 Next steps)
3. **Troubleshoot** — `Ready: False` diagnosis, issuer accessibility check, `oidc-ca-bundle` Secret + `providerCASecretName` for private CAs (§10.4, §10.5)

## Features and Concepts

### OpenShift Platform
- Gateway API (OCP 4.19.9+), `gatewayconfig`/`gateway` resources, `authentication.config` cluster type, ClusterRoles and ClusterRoleBindings, Secrets in `openshift-ingress`, `kube-apiserver` cluster operator rollout

### RHOAI / AI Platform
- Centralized authentication service behind `data-science-gateway`, `kube-auth-proxy` deployment, `GatewayConfig` CR (opendatahub.io/v1alpha1), `odh-projects-read` role naming, service account token authentication for programmatic access

### AI/ML Fundamentals
- OIDC issuer/discovery endpoints, browser redirect authentication flow, token lifetimes, TLS certificate chains and private CA trust

## Workshop Potential

- **Estimated modules**: 2 (configure → verify/authorize/troubleshoot)
- **Target audience**: cluster administrators and platform engineers configuring RHOAI ingress authentication
- **Prerequisite knowledge**: OpenShift CLI, Kubernetes Secrets and RBAC, OIDC basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 installed; OpenShift configured for direct authentication with an external OIDC provider; Gateway API enabled on OCP 4.19.9+; cluster administrator access

## Open Questions

- Console-login redirect behavior on a live cluster (doc-derived; screenshots deferred to Act phase)
- Whether the service account token authentication flow (§10.3) belongs in this workshop or a separate CLI-access feature
- Workshop IdP provisioning (Keycloak realm, `odh-users` group) for the authorization exercises
