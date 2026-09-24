---
schema_version: 1
id: RHAIBU-M33G4F79QYS0
type: requirement
---
# Module 01: Core Concepts

## Problem

Before deploying gateways and policies, learners need a mental model of
Connectivity Link as a policy control plane on top of standard Gateway API
resources, the four bundled Operators and their policy CRs, and the
installation state of the control plane in their cluster. Without this
orientation, later hands-on steps are copy-paste with no understanding of what
is being created or which component enforces which policy.

## Requirements

- [REQ-011] Learner MUST be able to describe the four Connectivity Link Operators (Connectivity Link/Kuadrant, Authorino, Limitador, DNS) and map each policy CR (`AuthPolicy`, `RateLimitPolicy`/`TokenRateLimitPolicy`, `DNSPolicy`, `TLSPolicy`) to its backing component, and locate the Red Hat Connectivity Link Operator in *Ecosystem > Installed Operators*
- [REQ-012] Learner MUST be able to derive the Connectivity Link install namespace from `oc get kuadrant -A` and confirm the control plane is ready with `oc wait kuadrant/kuadrant --for="condition=Ready=true"` printing `kuadrant.kuadrant.io/kuadrant Ready`
- [REQ-013] Learner MUST be able to verify the component Operator pods (`authorino-operator`, `dns-operator`, `kuadrant-operator`, `limitador-operator`) report `2/2 Running` in `${KUADRANT_SYSTEM_NS}`
- [REQ-014] Learner MUST be able to enable the `kuadrant-console-plugin` under *Home > Overview > Dynamic Plugins > View all* and confirm the *Connectivity Link* menu item and Overview page appear in the console

## Success Metrics

Learner completes all three exercises: the architecture walkthrough (Operator
and policy-CR mapping table), the installation inspection (`oc wait` Ready +
pods `2/2 Running`), and the console-plugin enablement, each producing the
documented expected output.

## Risks

- The console-plugin step requires `cluster-admin`; on restricted clusters it must be completed by the facilitator beforehand

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- Connectivity Link was pre-installed as `cluster-admin` (Subscription, OperatorGroup, Kuadrant CR in place)

## Related Requirements

- RHAIBU-M33G4F72YVSZ

## Verified By

- features/platform-gateway/gateway-api-rhcl/content/modules/ROOT/pages/module-01-concepts.adoc
