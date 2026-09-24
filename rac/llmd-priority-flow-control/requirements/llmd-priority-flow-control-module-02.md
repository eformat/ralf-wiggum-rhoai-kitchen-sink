---
schema_version: 1
id: RHAIBU-M33FSEA0PZHG
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

With flow control enabled, learners must prove that priority tiers actually
govern dispatch: `InferenceObjective` resources define the tiers, and only
sustained load reveals priority-based queuing, fairness, and load shedding.
Without a load-driven validation, priority configuration is untested
declarative YAML.

## Requirements

- [REQ-021] Learner MUST be able to create critical (`priority: 100`) and sheddable (`priority: -1`) `InferenceObjective` resources scoped to the InferencePool and list them with `oc get inferenceobjective`
- [REQ-022] Learner MUST be able to confirm the priority values were accepted (`oc get inferenceobjective ... -o jsonpath='{.spec.priority}'` shows `100`)
- [REQ-023] Learner MUST be able to drive sustained load and observe saturation conditions (`vllm:num_requests_running` at or near the `--max-num-seqs` cap, `vllm:num_requests_waiting` above zero) with `llm_d_epp_flow_control_queue_size` showing queue depth by fairness group and priority band
- [REQ-024] Learner MUST be able to confirm priority differentiation: `llm_d_epp_flow_control_request_queue_duration_seconds` exists with a `priority` label matching the `InferenceObjective` values, higher-priority requests dispatch before lower-priority ones, and the batch tier is first dropped at saturation
- [REQ-025] Learner MUST be able to resolve the Inference Gateway service in-cluster using the `gateway.networking.k8s.io/gateway-name` label selector and derive the `https://<gateway-svc>.<namespace>.svc.cluster.local/<namespace>/<llm-service-name>/v1/chat/completions` endpoint URL
- [REQ-026] Learner MUST be able to deploy the documented in-cluster load generator (a `curlimages/curl` pod running a ConfigMap-mounted script) that sends concurrent curl requests (`xargs -P 200`, 5000 total) with long-generation prompts (`max_tokens: 2048`) and alternating `interactive-critical`/`batch-workload` objective headers, driving the pool toward saturation
- [REQ-027] Learner MUST be able to observe rejection outcomes in the load-generator output: per-request `status=` lines showing HTTP 200 while capacity remains and HTTP 429 (`rejected-saturated`) once a priority band's queue capacity is exhausted, countable with `oc logs load-test | grep -o "status=[0-9]*" | sort | uniq -c`

## Success Metrics

Learner completes all three exercises: the priority-tier creation with verified
priority values, the in-cluster load generator driving the pool toward
saturation with observable HTTP 200/429 outcomes, and the load-driven
validation showing queuing at the Endpoint Picker and priority-labeled
dispatch metrics.

## Risks

- Queue depth remains at 0 without sufficient concurrency; the learner must increase load until saturation occurs
- The load generator runs in-cluster and consumes CPU and memory; the documented concurrency (200) and request count (5000) may need tuning for the target cluster
- Gateway authentication and rate limiting can throttle the load before saturation occurs; the documented testing approach disables authentication with the `security.opendatahub.io/enable-auth: "false"` annotation, which production deployments must never set

## Assumptions

- Learner completed module 01 (the `flowControl` feature gate is enabled — without it, `InferenceObjective` priorities are not enforced)
- The OpenShift AI dashboard exposes the LLM Traffic and LLM Performance dashboards for the learner's project

## Related Requirements

- RHAIBU-M33FSE9JZY74

## Verified By

- features/model-serving/llmd-priority-flow-control/content/modules/ROOT/pages/module-02-hands-on.adoc
