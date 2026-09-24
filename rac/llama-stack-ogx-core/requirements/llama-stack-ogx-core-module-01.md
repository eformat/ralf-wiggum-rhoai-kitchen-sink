---
schema_version: 1
id: RHAIBU-M33FZEKTM39K
type: requirement
---
# Module 01: Core Concepts

## Problem

Before deploying OGX workloads, learners need a mental model of the Llama Stack
to OGX renaming, the OGX Operator / OGXServer / run.yaml / provider component
model, and how to locate OGX resources in the cluster. Without this orientation,
later hands-on steps are copy-paste with no understanding of what is being
created.

## Requirements

- [REQ-011] Learner MUST be able to map the Llama Stack to OGX renaming (API group `llamastack.io` → `ogx.io`, kind `LlamaStackDistribution` → `OGXServer`, resource plural → `ogxservers`)
- [REQ-012] Learner MUST be able to verify the OGXServer custom resource definition is registered with `oc get crd ogxservers.ogx.io`
- [REQ-013] Learner MUST be able to check which API versions the CRD exposes with `oc get crd ogxservers.ogx.io -o jsonpath` (`v1beta1`)
- [REQ-014] Learner MUST be able to list any OGXServer instances across all projects with `oc get ogxserver -A` and inspect readiness via `.status.phase`

## Success Metrics

Learner completes both exercises: the architecture walkthrough (naming-mapping
table and component list) and the cluster inspection commands, each producing
the documented expected output.

## Risks

- The OGX Operator must be activated for the CRD to exist; on clusters without it, exercise 1 verification must be adapted (Module 02 covers activation)

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33FZEKGR1M7

## Verified By

- features/ogx/llama-stack-ogx-core/content/modules/ROOT/pages/module-01-concepts.adoc
