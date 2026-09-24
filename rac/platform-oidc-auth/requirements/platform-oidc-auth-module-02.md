---
schema_version: 1
id: RHAIBU-M33G4BTFHSSF
type: requirement
---
# Module 02: Verify, authorize, and troubleshoot OIDC access

## Problem

Configuration alone does not prove the authentication flow works. Learners need
to verify the provisioned resources end to end, map external IdP groups to
OpenShift ClusterRoles for authorization, rehearse the documented diagnosis for
a `Ready: False` GatewayConfig, and exercise the second authentication method of
the central authentication service — service account token authentication for
programmatic and CLI access — otherwise an incomplete rollout surfaces as a
support ticket instead of a quick fix.

## Requirements

- [REQ-021] Learner MUST be able to verify the OIDC flow end to end: GatewayConfig `Ready` and `ProvisioningSucceeded` conditions are `True`, `kube-auth-proxy` reports `1/1` ready, `data-science-gateway` reports `PROGRAMMED: True`, the OIDC discovery endpoint returns JSON, and console login redirects through the IdP and back with RHOAI components accessible
- [REQ-022] Learner MUST be able to create the `odh-projects-read` ClusterRole, bind it and the built-in `self-provisioner` ClusterRole to an IdP group, and confirm the ClusterRoleBinding subject
- [REQ-023] Learner SHOULD be able to diagnose a `Ready: False` GatewayConfig (`oc get`/`oc describe`), verify issuer URL accessibility (`curl -I` returns `HTTP/2 200` with `content-type: application/json`), and add custom CA trust via an `oidc-ca-bundle` Secret referenced by `spec.providerCASecretName`
- [REQ-024] Learner MUST be able to access the gateway programmatically: create a ServiceAccount (`oc create serviceaccount`), grant it `services/proxy` access through a Role and RoleBinding scoped to one service, mint a token with `oc create token --duration` (Kubernetes minimum 10 minutes), and call a service through the `data-science-gateway` route with `Authorization: Bearer` — a valid token returns HTTP 200, an invalid or missing token returns HTTP 403 or redirects to authentication

## Success Metrics

Learner completes all four exercises: end-to-end verification, group-to-role
authorization, the troubleshooting walkthrough, and the programmatic
ServiceAccount token flow — with the GatewayConfig reporting `Ready: True`,
dashboard login succeeding without TLS errors, and a bearer-token request
through the Gateway returning HTTP 200.

## Risks

- Private-CA-signed IdP certificates crash-loop `kube-auth-proxy` pods unless `providerCASecretName` is set
- IdP users cannot see any projects until group-to-ClusterRole mappings exist
- Service account tokens leak or outlive their purpose unless lifetimes are limited with `--duration` and rotation is planned

## Assumptions

- Learner completed Module 01 (GatewayConfig patched, `idp-client-secret` created)
- A test user in the `odh-users` IdP group is available for console verification

## Related Requirements

- RHAIBU-M33G4BT3B9QJ

## Verified By

- features/platform-gateway/platform-oidc-auth/content/modules/ROOT/pages/module-02-hands-on.adoc
