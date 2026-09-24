---
schema_version: 1
id: RHAIBU-M33G4BT3B9QJ
type: requirement
---
# Platform-wide direct OIDC authentication (GatewayConfig CR) Workshop

## Problem

Cluster administrators and platform engineers evaluating RHOAI 3.5 need hands-on
experience with Platform-wide direct OIDC authentication — the centralized
authentication service that routes ingress traffic for all services behind a
single domain via the `GatewayConfig` CR — before they can recommend or operate
it in production. Without a structured workshop, learners must reverse-engineer
the OpenShift direct-OIDC prerequisites, the secret-and-patch configuration
flow, and the group-to-ClusterRole authorization model from product
documentation alone. This workshop targets RHOAI users with cluster
administrator access and an external OIDC identity provider.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc whoami`, `oc project`)
- [REQ-002] Learner MUST be able to verify the OpenShift direct-OIDC prerequisites: authentication type is `OIDC`, the provider name appears under `.spec.oidcProviders`, and the `kube-apiserver` rollout is complete (`AVAILABLE True`, `PROGRESSING False`, `DEGRADED False`)
- [REQ-003] Learner MUST be able to create the `idp-client-secret` Secret in the `openshift-ingress` namespace and patch the `default-gateway` GatewayConfig with issuer URL, client ID, and client secret reference, confirming `.spec.oidc` matches their IdP values
- [REQ-004] Learner MUST be able to verify the OIDC flow end to end: GatewayConfig `Ready` and `ProvisioningSucceeded` conditions are `True`, `kube-auth-proxy` reports `1/1` ready, `data-science-gateway` reports `PROGRAMMED: True`, the OIDC discovery endpoint returns JSON, and console login redirects through the IdP and back
- [REQ-005] Learner MUST be able to map external IdP groups to OpenShift ClusterRoles (`odh-projects-read`, `self-provisioner`) and confirm the ClusterRoleBinding carries the IdP group
- [REQ-006] Learner SHOULD be able to troubleshoot a `Ready: False` GatewayConfig, verify issuer URL accessibility, and add custom CA trust via `providerCASecretName` so dashboard login succeeds without TLS certificate errors

## Success Metrics

All six acceptance criteria are demonstrated by the learner during the lab; the
GatewayConfig reports `Ready: True` in module 02 and console login through the
external OIDC provider succeeds.

## Risks

- The `kube-apiserver` direct-OIDC rollout can take 20 minutes or more; workshop clusters must be pre-configured for direct authentication with an external OIDC provider
- Requires cluster administrator access to create secrets and patch the `GatewayConfig`
- Gateway API support must be enabled on OCP 4.19.9 or later

## Assumptions

- RHOAI 3.5 is installed with the RHOAI Operator in `rhods-operator` and the `DataScienceCluster` and `DSCInitialization` resources deployed
- Learners have `oc` CLI access, cluster administrator credentials, and workshop credentials (`{user}`, `{guid}`)
- External IdP details (issuer URL, client ID, client secret, realm name for Keycloak) are available

## Related Designs

- RHAIBU-M33G4BV6MKE0

## Related Decisions

- RHAIBU-M33G4BTP5KMH
- RHAIBU-M33G4BTXY6YS

## Related Requirements

- RHAIBU-M33G4BT9Y883
- RHAIBU-M33G4BTFHSSF
