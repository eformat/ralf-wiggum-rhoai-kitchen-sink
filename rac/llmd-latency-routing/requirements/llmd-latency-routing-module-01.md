---
schema_version: 1
id: RHAIBU-M33DDTNPRE12
type: requirement
---
# Module 01: Getting Started

## Problem

Before touching a latency-aware configuration, learners need a mental model of
what per-request latency targets mean, where the Endpoint Picker's Scheduling
layer sits in the request path, and how to confirm the llm-d serving stack is
present in their project. Without this orientation, later hands-on steps are
copy-paste with no understanding of what is being configured.

## Requirements

- [REQ-011] Learner MUST be able to state which two latency metrics (TTFT and TPOT) operators can declare per-request targets for, and where latency-sensitive versus throughput-sensitive traffic is routed
- [REQ-012] Learner MUST be able to name the Endpoint Picker's Flow Control and Scheduling layers and identify that latency-aware scheduling happens in the Scheduling layer
- [REQ-013] Learner MUST be able to navigate to the model deployment wizard's Advanced routing section and observe the pre-selected Default optimized routing option
- [REQ-014] Learner MUST be able to run read-only `oc get llmisvc -n {guid}-{user}` and `oc get llminferenceserviceconfig -A` commands without errors

## Success Metrics

Learner completes all three exercises: the latency-aware routing walkthrough,
the llm-d serving-stack mapping, and the environment readiness inspection, each
producing the documented expected output.

## Risks

- `oc get llmisvc` fails with `the server doesn't have a resource type` when the Distributed Inference with llm-d component is not enabled; on such clusters exercise 3 must be adapted

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33DDTNAHG76

## Verified By

- features/agents-mcp/llmd-latency-routing/content/modules/ROOT/pages/module-01-getting-started.adoc
