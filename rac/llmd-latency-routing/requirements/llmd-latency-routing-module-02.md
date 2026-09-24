---
schema_version: 1
id: RHAIBU-M33DDTNY28CC
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners who understand the latency-aware plugin architecture need to see the
workflow end to end: recognize a latency-aware scheduler configuration in YAML,
attach it to a real deployment through the dashboard wizard, and interpret the
service-level EPP metrics that reveal how requests were routed. Without this
hands-on pass, learners cannot distinguish a routing problem from a capacity
problem in production.

## Requirements

- [REQ-021] Learner MUST be able to name the three plugins that make a scheduler configuration latency-aware, the plugin `latency-scorer` depends on for its predictions, and the picker that replaces `max-score-picker`
- [REQ-022] Learner MUST be able to inspect a latency-aware router configuration YAML from `Settings → llm-d routing configurations` and compare its plugin list with the documented inline example
- [REQ-023] Learner MUST be able to select a router configuration in the deployment wizard and verify the deployed model's `LLMInferenceService` lists it in `spec.baseRefs` after the topology preset config
- [REQ-024] Learner MUST be able to generate inference traffic and locate at least one `llm_d_epp_request_` latency metric (or the LLM Performance dashboard panels that chart it), then interpret the documented TTFT-versus-ITL diagnostic patterns

## Success Metrics

Learner completes all three exercises: the scheduler-configuration walkthrough,
the router-configuration attach-and-verify (or the documented default-routing
fallback), and the metrics observation with latency-pattern interpretation.

## Risks

- The `llm-d routing configurations` settings page is visible to administrators only; learners may need facilitator help to open it
- No compatible router configuration may exist in the workshop environment; the lab documents staying with Default optimized routing and continuing to the metrics exercise
- LLM Performance dashboards require User Workload Monitoring enabled and the Cluster Observability Operator installed

## Assumptions

- Learner has completed Module 01 (latency-aware routing concepts, environment readiness)
- A model deployment exists or is created in exercise 2 so inference traffic can be generated

## Related Requirements

- RHAIBU-M33DDTNAHG76

## Verified By

- features/agents-mcp/llmd-latency-routing/content/modules/ROOT/pages/module-02-hands-on.adoc
