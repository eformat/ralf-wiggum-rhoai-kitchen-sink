# Observations: Flow Control and Priority-Based Queuing (doc-derived)

## Summary

Flow control is the pool defense mechanism in the Endpoint Picker (EPP) of
Distributed Inference with llm-d: priority-based queuing, fairness, and load
shedding that let latency-sensitive and throughput-sensitive workloads
consolidate on one cluster while protecting critical SLOs. This observation
document was produced from the official RHOAI 3.5 product documentation
(Deploy models using Distributed Inference with llm-d — Chapters 10 and 11,
Configure request routing / Manage mixed workloads by using priority queuing)
because no live demo cluster was available at authoring time. Every item below
is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | llmd-priority-deploy-distributed-inference.txt | §10.2 Endpoint Picker architecture | EPP has two layers: Flow Control (when/in what order to dispatch — queuing, saturation detection, load shedding) and Scheduling (where to route); scheduling is always enabled, flow control is optional via the `flowControl` feature gate; flow control is work-conserving |
| 2 | llmd-priority-deploy-distributed-inference.txt | §10.2.1–10.2.2 Request flow | Gateway injects `x-gateway-inference-fairness-id` and `x-gateway-inference-objective` headers; strict priority ordering with intra-band fairness; saturation check halts dispatch; late-binding endpoint selection at dispatch time; queues requests when zero ready backends (scale-from-zero) |
| 3 | llmd-priority-deploy-distributed-inference.txt | §11.1.2 Key concepts | Example tier table: Critical 100 (interactive), Standard 0 default, Sheddable -1 (batch); auth-based prioritization (ServiceAccount namespace / `authenticated` / `unauthenticated` header values); starvation protection; rejection table: 429 rejected-saturated, 503 rejected-ttl-expired / context-cancelled / no-endpoints / shutting-down via `x-llm-d-request-dropped-reason` |
| 4 | llmd-priority-deploy-distributed-inference.txt | §11.2 Configure flow control | `oc edit llminferenceservice`; add `featureGates: ["flowControl"]` + saturation detector under `spec.router.scheduler.config.inline`; verification via `llm_d_epp_flow_control_request_queue_duration_seconds` with `priority` label and `vllm:num_requests_running`/`vllm:num_requests_waiting` under load |
| 5 | llmd-priority-deploy-distributed-inference.txt | §10.5 Table 10.5 Flow control metrics | `llm_d_epp_flow_control_queue_size` (gauge, fairness_id/priority), `_queue_bytes`, `_pool_saturation` (0.0–1.0, dispatch halts at threshold), `_requests_total` (counter, outcome label), `_request_queue_duration_seconds` (histogram), `_dispatch_cycle_duration_seconds` |
| 6 | llmd-priority-deploy-distributed-inference.txt | §11.3 InferenceObjective CR reference | `apiVersion llm-d.ai/v1alpha2`, `spec.priority`, `spec.poolRef` (group `llm-d.ai`, kind `InferencePool`, required name); `EndpointPickerConfig` is `llm-d.ai/v1alpha1` embedded under `spec.router.scheduler` |
| 7 | llmd-priority-deploy-distributed-inference.txt | §Observability (PodMonitor/ServiceMonitor, dashboards) | Controller auto-creates PodMonitor/ServiceMonitor (`llmmonitoring` component label); scheduler ServiceMonitor name begins `kserve-llm-isvc-scheduler`; prebuilt LLM Traffic and LLM Performance dashboards in the Observe & Monitor section |

## User Flows

### Flow 1: Enable flow control on a deployed service

1. **Prerequisite** — llm-d deployed with Inference Gateway and EPP; authentication enabled (§11.2)
2. **Edit service** — `oc edit llminferenceservice <name>` (§11.2)
3. **Add feature gate** — `featureGates: ["flowControl"]` + saturation detector (utilization or concurrency) in the inline EndpointPickerConfig (§11.2)
4. **Verify** — scheduler ServiceMonitor exists; `llm_d_epp_flow_control_pool_saturation` queryable in the console

### Flow 2: Define priority tiers and validate under load

1. **Create objectives** — `InferenceObjective` (llm-d.ai/v1alpha2) with `priority: 100` / `-1` and `poolRef` (§11.2, §11.3)
2. **Optional: shape bands** — `priorityBands` with maxBytes/maxRequests, ordering policy (fcfs/edf/slo-deadline), fairness policy (global-strict vs round-robin), `defaultRequestTTL` (§11.2 step 6)
3. **Drive load** — sustained traffic with varying priorities until `vllm:num_requests_waiting > 0` (§11.2 Verification)
4. **Verify priority dispatch** — `llm_d_epp_flow_control_request_queue_duration_seconds` with `priority` label; higher priority dispatches first; sheddable tier dropped first at saturation (§11.2)
5. **Observe** — `llm_d_epp_flow_control_queue_size` by fairness group and priority band; LLM Traffic/LLM Performance dashboards (§10.5, §Observability)

## Features and Concepts

### OpenShift Platform
- Gateway-injected auth headers (`x-gateway-inference-fairness-id`, `x-gateway-inference-objective`), PodMonitor/ServiceMonitor auto-creation, Prometheus metrics queries in the Observe console

### RHOAI / AI Platform
- EndpointPickerConfig feature gates, InferenceObjective CR, scheduler ServiceMonitor (`kserve-llm-isvc-scheduler`), LLM Traffic / LLM Performance dashboards, fail-open EPP behavior

### AI/ML Fundamentals
- Multitenant LLM serving SLAs, strict priority ordering vs intra-band fairness, saturation detection (queue depth, KV cache utilization), load shedding, starvation protection

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on load test)
- **Target audience**: platform engineers and ML practitioners who have deployed llm-d workloads
- **Prerequisite knowledge**: Distributed Inference with llm-d (llmd-core workshop), model serving concepts, `oc` CLI basics
- **Estimated duration**: 45–90 minutes
- **Cluster requirements**: RHOAI 3.5 with llm-d deployed (Gateway + EPP), authentication enabled, load-testing tooling, and enough concurrency to trigger saturation

## Open Questions

- Minimum concurrency needed to saturate a workshop InferencePool and trigger visible priority differentiation (doc says increase concurrency if queue depth stays 0)
- Load-testing tool choice for the sustained-traffic step (docs say "load testing tools" generically)
- Whether the optional `priorityBands` configuration step should be a graded exercise or stay optional
