---
schema_version: 1
id: RHAIBU-M33DDTNAHG76
type: requirement
---
# Latency-aware Routing for llm-d Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with Latency-aware routing for Distributed Inference with llm-d — a
Developer Preview capability that places each inference request on a pod
predicted to meet its declared TTFT/TPOT target — before they can recommend or
operate latency-sensitive model deployments in production. Without a structured
workshop, learners must reverse-engineer the Endpoint Picker's plugin
architecture, the inline scheduler configuration format, and the
router-configuration selection flow from product documentation alone. This
workshop targets RHOAI users with working knowledge of OpenShift and Distributed
Inference with llm-d.

## Requirements

- [REQ-001] Learner MUST be able to state the two per-request latency metrics (TTFT and TPOT) operators can declare targets for, and where latency-sensitive versus throughput-sensitive traffic is routed
- [REQ-002] Learner MUST be able to name the Endpoint Picker's Flow Control and Scheduling layers and identify that latency-aware routing lives in the Scheduling layer
- [REQ-003] Learner MUST be able to run read-only `oc get llmisvc` and `oc get llminferenceserviceconfig -A` commands without errors to confirm the llm-d serving stack is present
- [REQ-004] Learner MUST be able to name the three latency-aware plugins (`predicted-latency-producer`, `latency-scorer`, `weighted-random-picker`), the plugin the scorer depends on for predictions, and the picker that replaces `max-score-picker`
- [REQ-005] Learner MUST be able to inspect a latency-aware router configuration YAML from `Settings → llm-d routing configurations`
- [REQ-006] Learner MUST be able to attach a router configuration via the deployment wizard's Advanced routing section and verify it appears in `spec.baseRefs` after the topology preset config
- [REQ-007] Learner MUST be able to generate inference traffic and locate at least one `llm_d_epp_request_` latency metric (or the LLM Performance dashboard panels that chart it), and interpret the TTFT-versus-ITL diagnostic patterns

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
read-only `oc` commands succeed in module 01, the deployed model's
`LLMInferenceService` lists the selected router configuration in `spec.baseRefs`
in module 02, and at least one `llm_d_epp_request_` metric is located for the
deployment.

## Risks

- The feature is Developer Preview in 3.5 and may change between releases
- Router configurations with latency-aware scheduling must be pre-provisioned by an administrator for the module 02 attach-and-verify exercise; the lab documents a default-routing fallback if none exists
- Metrics visibility depends on User Workload Monitoring and the Cluster Observability Operator in the workshop cluster

## Assumptions

- RHOAI 3.5 is installed with Distributed Inference with llm-d enabled
- Learners have completed Getting Connected (cluster login, working project, `{guid}-{user}` namespace)
- A model can be deployed in the workshop project so the EPP metrics have data

## Related Designs

- RHAIBU-M33DDTPV452S

## Related Decisions

- RHAIBU-M33DDTP8SDHR
- RHAIBU-M33DDTPJ2XYG

## Related Requirements

- RHAIBU-M33DDTNPRE12
- RHAIBU-M33DDTNY28CC
