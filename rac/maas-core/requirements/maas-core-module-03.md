---
schema_version: 1
id: RHAIBU-M33F77ZXJ4RZ
type: requirement
---
# Module 03: Advanced Usage

## Problem

After consuming a governed model as a user, administrators need to create the
subscription and authorization policy that gate access, apply the same
governance as YAML for GitOps workflows, and manage API keys and usage
monitoring — including revocation and key-expiration caps.

## Requirements

- [REQ-031] Learner MUST be able to create a subscription from the *MaaS governance* page (`Settings → MaaS governance`) with at least one token limit per model and confirm it shows `Active` (`oc get maassubscription -n models-as-a-service`)
- [REQ-032] Learner MUST be able to apply `MaaSSubscription` and `MaaSAuthPolicy` YAML manifests and confirm the controller-generated `AuthPolicy` and `TokenRateLimitPolicy` resources in the model namespace
- [REQ-033] Learner MUST be able to revoke an API key and verify the revoked key returns `401` at the management API
- [REQ-034] Learner SHOULD be able to cap `maxExpirationDays` on the Tenant resource via `oc patch` and view token consumption on the Usage dashboard

## Success Metrics

Learner completes all three exercises: the subscription creation with `Active`
status, the YAML apply with controller-generated gateway policies verified, and
the key-revocation/expiration-cap walkthrough with the revoked key returning
`401`.

## Risks

- The matching authorization policy is a snapshot: later subscription changes are not propagated, so policy drift is possible
- Gateway policy enforcement takes effect only after the Authorino cache expires
- Requires dashboard administrator privileges

## Assumptions

- Learner has completed Module 02 (a model is published and consumable; `$MAAS_URL` is exported)

## Related Requirements

- RHAIBU-M33F77Z24FAX

## Verified By

- features/maas/maas-core/content/modules/ROOT/pages/module-03-advanced.adoc
