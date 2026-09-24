---
schema_version: 1
id: RHAIBU-M33CJ4CRNZ3N
type: requirement
---
# Module 03: Advanced Usage

## Problem

After a basic deployment, platform engineers need to shape traffic and manage
the llm-d configuration templates that the wizard consumes. This module covers
advanced routing via `baseRefs` and template management from the dashboard
settings.

## Requirements

- [REQ-031] Learner MUST be able to apply advanced routing to a deployment by selecting a router configuration and verify the resulting `spec.baseRefs`
- [REQ-032] Learner MUST be able to view llm-d topology configurations under `Settings → llm-d topology configurations`
- [REQ-033] Learner SHOULD be able to create a router configuration template from the dashboard with a `config-type: router` label
- [REQ-034] Learner SHOULD be able to edit and duplicate existing topology templates from the settings UI
- [REQ-035] Learner SHOULD be able to observe the WVA controller deployment (`oc get pods -n redhat-ods-applications -l 'app.kubernetes.io/name in (workload-variant-autoscaler)'`) and its default saturation-scaling thresholds (`oc get cm workload-variant-autoscaler-saturation-scaling-config -n redhat-ods-applications -o jsonpath='{.data.default}'` showing kvCacheThreshold 0.80, queueLengthThreshold 5, kvSpareTrigger 0.1, queueSpareTrigger 3)

## Success Metrics

Learner completes both exercises: the advanced-routing apply with `baseRefs`
verification, and the template management walkthrough with the router-template
YAML inspected.

## Risks

- Router and topology templates must exist for the exercises to run
- The routing configuration UI may change between releases

## Assumptions

- Learner has completed Module 02 (a deployment exists to apply routing to)

## Related Requirements

- RHAIBU-M33CJ4C9MQKD

## Verified By

- features/model-serving/llmd-core/content/modules/ROOT/pages/module-03-advanced.adoc
