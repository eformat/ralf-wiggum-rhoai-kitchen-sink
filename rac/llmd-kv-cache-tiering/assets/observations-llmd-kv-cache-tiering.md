# Observations: Hierarchical KV Cache Tiering with llm-d (doc-derived)

## Summary

Hierarchical KV cache tiering for GPU inference workloads is a RHOAI 3.5
Developer Preview feature that lets platform operators serve more concurrent
users on the same GPU footprint by placing cache entries on operator-configured
tiers, increasing effective cache size and prefix-cache reuse for multi-turn and
long-context workloads. It works together with Distributed Inference with llm-d,
whose Endpoint Picker makes the cache-aware routing decisions. This observation
document was produced from the official RHOAI 3.5 product documentation
(Deploy models using Distributed Inference with llm-d; Release notes) because no
live demo cluster was available at authoring time. Every item below is doc
evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §4 Developer Preview Features — Hierarchical KV Cache Tiering | Operators configure tiers; cache entries placed automatically; increases effective cache size and prefix-cache reuse on the same GPU footprint; pointers to KV Cache Offloading docs |
| 2 | llmd-deploy-distributed-inference.txt | §2.5 Router configurations and supported topologies | Router configs are optional enhancements over topology configs; capabilities include KV cache-aware scheduling, intelligent gateway routing, batching, circuit breaking; dashboard filters by `opendatahub.io/supported-topologies` annotation |
| 3 | llmd-deploy-distributed-inference.txt | §2.11–2.12 Managing router configurations | `Settings → llm-d routing configurations` page (admin only): Name, Topology type, Enabled, Actions columns; creation requires the `llmdTemplates` feature flag in `OdhDashboardConfig`; `config-type: router` label; example `kv-cache-router-single-node` with prefix-cache-scorer weight 100 + queue-scorer weight 50 |
| 4 | llmd-deploy-distributed-inference.txt | §10.1 Scheduler configuration | Default profile: queue-scorer 2, kv-cache-utilization-scorer 2, prefix-cache-scorer 3, no-hit-lru-scorer 2 (weights 2:2:3:2); hash-based prefix detection works in disconnected environments; `precise-prefix-cache-scorer` uses token-level matching but needs a UDS Tokenizer sidecar and network access |
| 5 | llmd-deploy-distributed-inference.txt | §15 EPP metrics | Prometheus metrics at `/metrics` on the metrics service port; `llm_d_epp_` prefix (older `inference_objective_`/`inference_extension_`/`inference_pool_` prefixes deprecated); cache-relevant metrics include `llm_d_epp_average_kv_cache_utilization`, `llm_d_epp_prefix_indexer_hit_ratio`, `llm_d_epp_prefix_indexer_size`, `llm_d_epp_prefix_indexer_hit_bytes`, `llm_d_epp_request_ttft_seconds` |
| 6 | llmd-deploy-distributed-inference.txt | §1.1 Enable Distributed Inference with llm-d | Model-serving platform enabled in the DSC is the prerequisite for the llm-d serving stack the feature rides on |

## User Flows

### Flow 1: Understand and confirm cache tiering readiness

1. **Concept orientation** — KV cache computed at prefill, reused at decode; shared prefixes enable reuse; operators configure tiers, placement is automatic (release notes §4)
2. **Locate the feature's stack** — llm-d Endpoint Picker between Inference Gateway and model servers; Flow Control decides when, Scheduling decides where (§2.5)
3. **Confirm cluster readiness** — `oc get llmisvc` and `oc get llminferenceserviceconfig -A` list serving resources and configuration templates (§1.1)
4. **Locate wizard surfaces** — dashboard Settings → llm-d routing/topology configurations (admin); Deploy model wizard → Advanced routing default

### Flow 2: Apply and observe cache-aware routing

1. **Inspect a router config** — `config-type: router` label, `supported-topologies` annotation, scheduler with scorer plugins (§2.11)
2. **Attach in the wizard** — Deploy model → Advanced routing → Router configuration list filtered by selected topology (§2.5)
3. **Verify attachment** — generated `LLMInferenceService` lists the router config in `spec.baseRefs` after the topology preset
4. **Observe metrics** — repeated identical prompts push `llm_d_epp_prefix_indexer_hit_ratio` up; sustained traffic raises `llm_d_epp_average_kv_cache_utilization`; vLLM `--gpu-memory-utilization` and `--max-model-len` tune saturation (§15)

## Features and Concepts

### OpenShift Platform
- Prometheus metrics scraping (`/metrics` endpoint, metrics service port, PodMonitor), ServiceAccount-token authentication for inference requests

### RHOAI / AI Platform
- Hierarchical KV Cache Tiering (DP), Distributed Inference with llm-d serving stack, LLMInferenceService / LLMInferenceServiceConfig CRs, `spec.baseRefs` composition of topology preset + router config, `llmdTemplates` feature flag, admin settings pages for llm-d routing/topology configurations

### AI/ML Fundamentals
- KV cache (prefill/decode attention state), prefix-cache reuse for multi-turn and long-context workloads, cache tiering, scorer-plugin scheduling (queue, KV utilization, prefix, LRU tiebreaker), time-to-first-token as a cache-hit signal

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics; builds on the Distributed Inference with llm-d core workshop
- **Estimated duration**: 45–60 minutes
- **Cluster requirements**: RHOAI 3.5 with Distributed Inference with llm-d enabled; `llmdTemplates` flag for router management; optional pre-created KV-cache-aware router config

## Open Questions

- Whether a KV-cache-aware router configuration is pre-provisioned in workshop clusters (module 02 prerequisite; fallback is `Default optimized routing`)
- Which `llm_d_epp_` metrics are scraped into the workshop monitoring stack vs requiring direct EPP metrics service access (doc-derived, environment-dependent)
- Exact KV cache tier-configuration steps (KV Cache Offloading docs) are out of scope for this workshop — confirm whether a follow-up lab should cover them
