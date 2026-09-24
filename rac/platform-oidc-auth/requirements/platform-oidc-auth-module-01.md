---
schema_version: 1
id: RHAIBU-M33G4BT9Y883
type: requirement
---
# Module 01: Configure OIDC for the platform gateway

## Problem

Before enabling the centralized authentication service, learners need to confirm
the cluster-side direct-OIDC prerequisites and understand what the
`GatewayConfig` CR controls. Without this orientation, the gateway patch in
module 02 is copy-paste with no understanding of which IdP values the gateway
consumes and why OpenShift and the gateway must use the same OIDC provider.

## Requirements

- [REQ-011] Learner MUST be able to verify the OpenShift authentication type with `oc get authentication.config/cluster -o jsonpath='{.spec.type}'` (`OIDC`)
- [REQ-012] Learner MUST be able to verify the configured OIDC provider name appears under `.spec.oidcProviders` and that `kube-apiserver` reports `AVAILABLE True` with `PROGRESSING False` and `DEGRADED False`
- [REQ-013] Learner MUST be able to create the `idp-client-secret` Secret in the `openshift-ingress` namespace and confirm it exists (`Opaque`, `DATA 1`)
- [REQ-014] Learner MUST be able to patch the `default-gateway` GatewayConfig with `spec.oidc` (`issuerURL`, `clientID`, `clientSecretRef`) and confirm `.spec.oidc` carries their IdP values

## Success Metrics

Learner completes both exercises: the direct-OIDC prerequisite checks and the
GatewayConfig secret-plus-patch configuration, each producing the documented
expected output.

## Risks

- If the cluster is not configured for direct authentication, the `kube-apiserver` rollout must be completed first (20 minutes or more) before module 02 can proceed

## Assumptions

- Learner has completed Getting Connected (cluster login, working project) and holds cluster administrator access
- External IdP details (issuer URL, client ID, client secret) are available

## Related Requirements

- RHAIBU-M33G4BT3B9QJ

## Verified By

- features/platform-gateway/platform-oidc-auth/content/modules/ROOT/pages/module-01-getting-started.adoc
