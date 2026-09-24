---
schema_version: 1
id: RHAIBU-M33FS2XV37B4
type: requirement
---
# Module 03: Topology Templates, Routers, and P/D Disaggregation

## Problem

After a basic deployment, platform administrators need to control the
deployment options the wizard exposes: topology `LLMInferenceServiceConfig`
templates gated behind the `llmdTemplates` feature flag, router configurations
with `baseRefs` merge behavior, and the disaggregated prefill/decode topology
with its `prefill` spec section.

## Requirements

- [REQ-031] Learner MUST be able to enable the `llmdTemplates` feature flag in `OdhDashboardConfig` and create a topology configuration template that appears under `Settings → llm-d topology configurations`
- [REQ-032] Learner MUST observe that creating the matching topology template enables the corresponding topology radio button in the Deploy model wizard (and that single-node has a built-in default, always available)
- [REQ-033] Learner MUST be able to create a router configuration with `config-type: router` and a `supported-topologies` annotation, and verify the generated `spec.baseRefs` array lists the `kserve-system` topology preset followed by the selected router
- [REQ-034] Learner SHOULD be able to deploy a disaggregated prefill/decode workload with the `prefill` spec section and confirm the `{}` presence marker plus separate prefill/decode scheduler profiles in the EPP pod logs

## Success Metrics

Learner completes the exercises: the topology template with its wizard radio
button enabled, the `baseRefs` merge order verified in the generated resource
with test requests still returning 200, and the disaggregated mode confirmed
via the empty `spec.prefill` marker.

## Risks

- The topology selector wizard and its template management pages are Technology Preview in 3.5
- Setting `spec.baseRefs` on an `LLMInferenceServiceConfig` is forbidden and rejected by the KServe webhook
- Disaggregated prefill/decode requires RDMA-capable networking (InfiniBand or RoCE v2) and multi-GPU capacity

## Assumptions

- Learner has completed Module 02 (a deployment exists) and has cluster administrator privileges

## Related Requirements

- RHAIBU-M33FS2X4T4NW

## Verified By

- features/model-serving/llminferenceservice-config/content/modules/ROOT/pages/module-03-advanced.adoc
