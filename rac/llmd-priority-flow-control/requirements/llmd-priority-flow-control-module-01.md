---
schema_version: 1
id: RHAIBU-M33FSE9TQ7TP
type: requirement
---
# Module 01: Getting Started

## Problem

Before defining priority tiers, learners need to locate flow control in the
Endpoint Picker request path, understand how it differs from the scheduling
layer, and enable the `flowControl` feature gate on a deployed
`LLMInferenceService`. Without this, later load tests exercise an unconfigured
pool where `InferenceObjective` priorities are not enforced.

## Requirements

- [REQ-011] Learner MUST be able to verify the Endpoint Picker pod for a deployed `LLMInferenceService` is `Running` and inspect its logs for the loaded scheduler plugins and profiles (default four-scorer config `queue-scorer`, `kv-cache-utilization-scorer`, `prefix-cache-scorer`, `no-hit-lru-scorer` with weights 2:2:3:2 before flow control)
- [REQ-012] Learner MUST be able to add the `flowControl` feature gate and a `utilization-detector` saturation detector under `spec.router.scheduler.config.inline` and confirm the LLM inference service is still `Ready`
- [REQ-013] Learner MUST be able to verify the scheduler ServiceMonitor exists (`app.kubernetes.io/component=llmmonitoring` label, `kserve-llm-isvc-scheduler` name prefix)
- [REQ-014] Learner SHOULD be able to query `llm_d_epp_flow_control_pool_saturation` in the OpenShift console and interpret values where `1.0` is the gating set point

## Success Metrics

Learner completes both exercises: the EPP inspection and the flow-control
enablement with ServiceMonitor and saturation-metric verification, each
producing the documented expected output.

## Risks

- The EPP restart after the configuration change takes time to reach `Running` with all containers ready; the watch step must be completed before verification
- On clusters without an already-deployed `LLMInferenceService`, exercise 1 must be adapted (prerequisite: llmd-core deployment)

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- A serving `LLMInferenceService` with an Inference Gateway and Endpoint Picker exists from the prerequisite llmd-core workshop

## Related Requirements

- RHAIBU-M33FSE9JZY74

## Verified By

- features/model-serving/llmd-priority-flow-control/content/modules/ROOT/pages/module-01-getting-started.adoc
