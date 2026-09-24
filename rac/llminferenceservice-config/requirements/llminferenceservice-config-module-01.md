---
schema_version: 1
id: RHAIBU-M33FS2XCDCFY
type: requirement
---
# Module 01: LLMInferenceService Core Concepts

## Problem

Before deploying llm-d workloads, learners need a mental model of what the
llm-d-native `LLMInferenceService` CR replaces, how its five spec sections
compose the serving stack, and how `LLMInferenceServiceConfig` templates with
`opendatahub.io/config-type` labels drive the dashboard topology selector.
Without this orientation, later hands-on steps are copy-paste with no
understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to name the five spec sections of `LLMInferenceService` (`model`, `router`, `scheduler`, `template`, `baseRefs`) and what each controls
- [REQ-012] Learner MUST be able to describe the four validated llm-d topology patterns and their `opendatahub.io/config-type` template labels
- [REQ-013] Learner MUST be able to verify the `LLMInferenceService` API is registered with `oc api-resources | grep -i llminference`
- [REQ-014] Learner MUST be able to confirm the `openshift-ai-inference` Gateway shows `ACCEPTED: True` / `PROGRAMMED: True`, its gateway pod is `Running`, and the controller manager pods in `redhat-ods-applications` are `Running`

## Success Metrics

Learner completes both exercises: the concept walkthrough ending with the
five-spec-section check, and the cluster inspection commands each producing
the documented expected output (`PROGRAMMED: True` gateway table).

## Risks

- Gateway resources only exist after the llm-d component is enabled; on clusters without it, exercise 2 must be adapted

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33FS2X4T4NW

## Verified By

- features/model-serving/llminferenceservice-config/content/modules/ROOT/pages/module-01-concepts.adoc
