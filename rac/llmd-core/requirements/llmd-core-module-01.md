---
schema_version: 1
id: RHAIBU-M33CJ4CETEWH
type: requirement
---
# Module 01: Core Concepts

## Problem

Before deploying llm-d workloads, learners need a mental model of the unified
Deploy-model entry point, the validated topology patterns, and the cluster
components that back Distributed Inference with llm-d. Without this orientation,
later hands-on steps are copy-paste with no understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to name the four validated topology patterns and their use cases
- [REQ-012] Learner MUST be able to verify the model-serving platform enablement with `oc get datasciencecluster` (`kserve.managementState: Managed`)
- [REQ-013] Learner MUST be able to confirm the `openshift-ai-inference` Gateway exists in `openshift-ingress` with `PROGRAMMED: True`
- [REQ-014] Learner MUST be able to list existing `LLMInferenceService` resources cluster-wide with `oc get llminferenceservice -A`

## Success Metrics

Learner completes both exercises: the architecture walkthrough and the cluster
inspection commands, each producing the documented expected output.

## Risks

- Gateway resources only exist after the llm-d component is enabled; on clusters without it, exercise 2 must be adapted

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33CJ4C9MQKD

## Verified By

- features/model-serving/llmd-core/content/modules/ROOT/pages/module-01-concepts.adoc
