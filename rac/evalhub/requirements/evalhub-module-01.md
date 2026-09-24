---
schema_version: 1
id: RHAIBU-M33ESYEH6WFB
type: requirement
---
# Module 01: Core Concepts

## Problem

Before submitting evaluation jobs, learners need a mental model of the EvalHub
architecture — server, SDK/CLI, and providers — the provider/benchmark/collection
vocabulary, and the cluster components that back the service. Without this
orientation, later hands-on steps are copy-paste with no understanding of what
is being created.

## Requirements

- [REQ-011] Learner MUST be able to name the three EvalHub components (Server, SDK/CLI, Providers) and their roles
- [REQ-012] Learner MUST be able to state the job state progression (`pending`, `running`, `completed`, `failed`, `cancelled`, `partially_failed`) and the three threshold levels (benchmark, collection, provider)
- [REQ-013] Learner MUST be able to confirm the TrustyAI component is managed with `oc get datasciencecluster default -o jsonpath='{.spec.components.trustyai.managementState}'` returning `Managed`
- [REQ-014] Learner MUST be able to confirm the `eval-hub` pod is `Running`, the health endpoint returns `"status": "healthy"`, and the tenant resources exist in the working project

## Success Metrics

Learner completes both exercises: the concepts walkthrough (components, job
workflow, threshold levels recited without the page) and the deployment
inspection commands, each producing the documented expected output.

## Risks

- EvalHub must be pre-deployed in the `{guid}-evalhub` namespace and the working project registered as a tenant, or exercise 2 must be adapted

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33ESYEB6HGQ

## Verified By

- features/evaluation/evalhub/content/modules/ROOT/pages/module-01-concepts.adoc
