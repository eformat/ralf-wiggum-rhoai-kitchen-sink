---
schema_version: 1
id: RHAIBU-M33FSE9JZY74
type: requirement
---
# Flow Control and Priority-Based Queuing Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with flow control in Distributed Inference with llm-d — the
priority-based queuing, fairness, and load-shedding layer that lets multitenant
latency-sensitive and throughput-sensitive workloads consolidate on one cluster
without violating critical SLOs. Without a structured workshop, learners must
reverse-engineer the `flowControl` feature gate, `InferenceObjective` priority
tiers, and the `llm_d_epp_flow_control_*` metrics from product documentation
alone. This workshop targets RHOAI users who have already deployed llm-d
workloads and working knowledge of OpenShift and model serving concepts.

## Requirements

- [REQ-001] Learner MUST be able to verify the Endpoint Picker (EPP) pod for a deployed `LLMInferenceService` is `Running` and its logs show the loaded scheduler plugins and profiles
- [REQ-002] Learner MUST be able to enable the `flowControl` feature gate and a utilization-based saturation detector in the inline scheduler config and confirm the service is still `Ready`
- [REQ-003] Learner MUST be able to verify the scheduler ServiceMonitor (`kserve-llm-isvc-scheduler` prefix, `llmmonitoring` component label) exists and query `llm_d_epp_flow_control_pool_saturation` in the OpenShift console
- [REQ-004] Learner MUST be able to create critical (`priority: 100`) and sheddable (`priority: -1`) `InferenceObjective` resources and confirm the priority values were accepted
- [REQ-005] Learner MUST be able to drive sustained load and observe queuing conditions (`vllm:num_requests_running` at/near the `--max-num-seqs` cap, `vllm:num_requests_waiting` above zero)
- [REQ-006] Learner MUST be able to confirm priority differentiation via the `llm_d_epp_flow_control_request_queue_duration_seconds` metric with a `priority` label matching the `InferenceObjective` values
- [REQ-007] Learner SHOULD be able to configure per-band capacity limits, request TTL, and fairness policies in the `priorityBands` flow control configuration

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
flow control is enabled and verified in module 01, and priority queuing under
load is validated in module 02 with `llm_d_epp_flow_control_*` metrics showing
queue depth and priority-labeled dispatch.

## Risks

- Priority differentiation only manifests under saturation; workshop clusters must be load-tested with enough concurrency to trigger queuing
- `InferenceObjective` priorities are not enforced without the `flowControl` feature gate enabled in module 01
- If the EPP becomes unavailable the default configuration fails open: priority ordering, fairness policies, and saturation gating are not enforced until it recovers

## Assumptions

- Distributed Inference with llm-d is deployed with an Inference Gateway and an Endpoint Picker (prerequisite: llmd-core workshop)
- Learners have `oc` CLI access, workshop credentials (`{user}`, `{guid}`), and load-testing tools
- RHOAI 3.5 auto-creates PodMonitor/ServiceMonitor resources for vLLM engines and the inference scheduler

## Related Designs

- RHAIBU-M33FSEAJ74K7

## Related Decisions

- RHAIBU-M33FSEA6ZVWS
- RHAIBU-M33FSEAD2V62

## Related Requirements

- RHAIBU-M33FSE9TQ7TP
- RHAIBU-M33FSEA0PZHG
