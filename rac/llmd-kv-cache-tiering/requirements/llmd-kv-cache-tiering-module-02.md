---
schema_version: 1
id: RHAIBU-M33DDPK13SJK
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must work through the cache-aware routing workflow end to end —
inspecting a KV-cache-aware router configuration, applying it to a model
deployment, and observing the metrics that show KV cache behavior during
inference. This is the core deliverable of the workshop: a verified router
attachment and real cache-metric observations.

## Requirements

- [REQ-021] Learner MUST be able to name `opendatahub.io/config-type: router` as the label that marks a router configuration, `opendatahub.io/supported-topologies` as the annotation that filters it by topology, and the `prefix-cache-scorer` (heaviest weight) as the scorer prioritized in a cache-reuse-focused profile
- [REQ-022] Learner MUST be able to select a KV-cache-aware router configuration in the deployment wizard's Advanced routing section and verify the generated `LLMInferenceService` lists it in `spec.baseRefs` after the topology preset
- [REQ-023] Learner MUST be able to send repeated inference requests and observe at least one `llm_d_epp_` cache metric moving in the documented direction: prefix indexer hit ratio up for repeated prefixes, average KV cache utilization up under sustained load

## Success Metrics

The applied router configuration appears in `spec.baseRefs`; repeated requests
push `llm_d_epp_prefix_indexer_hit_ratio` upward while sustained traffic raises
`llm_d_epp_average_kv_cache_utilization`.

## Risks

- Router configurations require the `llmdTemplates` feature flag in `OdhDashboardConfig`; if the settings page is empty, exercise 2 stays with `Default optimized routing`
- The dashboard only offers router configurations whose `supported-topologies` annotation includes the selected deployment topology
- Metrics visibility in the console's Observe section depends on workshop scraping configuration

## Assumptions

- Learner has completed Module 01 (llm-d serving stack confirmed) and has a model deployment available

## Related Requirements

- RHAIBU-M33DDPJHFZQQ

## Verified By

- features/agents-mcp/llmd-kv-cache-tiering/content/modules/ROOT/pages/module-02-hands-on.adoc
