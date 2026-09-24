# Observations: Latency-aware Routing for llm-d (doc-derived)

## Summary

Latency-aware routing for Distributed Inference with llm-d is a Developer
Preview feature in RHOAI 3.5 that lets platform operators declare per-request
latency targets for Time To First Token (TTFT) and Time Per Output Token (TPOT);
the routing layer then places each request on a pod predicted to meet its
target. This observation document was produced from the official RHOAI 3.5
product documentation (Deploy models using Distributed Inference with llm-d) and
the RHOAI 3.5 release notes (Developer Preview features section) because no live
demo cluster was available at authoring time. Every item below is doc evidence,
not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §4 Developer Preview features, Latency-aware routing for Distributed Inference with llm-d | Per-request TTFT/TPOT targets; latency-sensitive traffic routed to pods with available capacity, throughput-sensitive traffic fills pods already handling longer work |
| 2 | llmd-deploy-distributed-inference.txt | §10.1 Configure scheduler settings | Inline vs ConfigMap-based scheduler configuration; latency-scorer for latency-sensitive workloads; the two methods are mutually exclusive |
| 3 | llmd-deploy-distributed-inference.txt | §10.2 Endpoint Picker architecture | EPP sits between Inference Gateway and backend model servers; Flow Control layer decides when (priority queuing, saturation detection, load shedding), Scheduling layer decides where; Scheduling is always enabled, Flow Control optional via `flowControl` feature gate |
| 4 | llmd-deploy-distributed-inference.txt | §10.6 Available plugins | `latency-scorer` (recommended weight 3) requires `predicted-latency-producer` and `weighted-random-picker`; `predicted-latency-producer` annotates candidates with predicted TTFT/TPOT; `weighted-random-picker` uses reservoir sampling to avoid hot-spotting; all three disconnected-compatible |
| 5 | llmd-deploy-distributed-inference.txt | §10.7 EPP and inference scheduler metrics | `llm_d_epp_request_` prefix; service-level metrics include queue wait and network latency; TTFT, streaming TPOT, streaming ITL, duration histograms; `llm_d_epp_request_total` labeled by model, target model, fairness ID, priority |
| 6 | llmd-deploy-distributed-inference.txt | §2.5 Router configurations and supported topologies | Router configs are `LLMInferenceServiceConfig` resources labeled `opendatahub.io/config-type: router`, filtered client-side by the `opendatahub.io/supported-topologies` annotation; Default optimized routing pre-selected in the wizard |

## User Flows

### Flow 1: Understand where latency-aware routing fits

1. **Mixed workloads** — interactive (TTFT-bound) vs batch (throughput-bound) workloads share the GPU pool
2. **Declare targets** — operators declare per-request TTFT and TPOT targets (§4 release notes)
3. **Scheduling layer placement** — requests placed on pods predicted to meet their target (§10.2)

### Flow 2: Attach latency-aware routing to a deployment

1. **Verify prerequisites** — Distributed Inference with llm-d enabled; llm-d resources recognized (`oc get llmisvc`, `oc get llminferenceserviceconfig -A`)
2. **Open deployment wizard** — Data Science Projects → Deploy model → Advanced routing (§2.5)
3. **Select router config** — list filtered by supported topologies; Default optimized routing pre-selected
4. **Verify attachment** — `spec.baseRefs` on the generated LLMInferenceService lists the router config after the topology preset

### Flow 3: Observe latency behavior

1. **Generate traffic** — inference requests so the EPP histograms have data
2. **Read service-level metrics** — `llm_d_epp_request_ttft_seconds`, `llm_d_epp_request_streaming_tpot_seconds`, `llm_d_epp_request_streaming_itl_seconds` (§10.7)
3. **Diagnose** — high TTFT with normal ITL indicates prefill bottleneck; high ITL with normal TTFT indicates decode bottleneck; normal TTFT/ITL with high end-to-end latency indicates scheduling delays

## Features and Concepts

### OpenShift Platform
- Inference Gateway, Prometheus metrics at `/metrics` on the metrics service port, User Workload Monitoring, Cluster Observability Operator (LLM Performance dashboard)

### RHOAI / AI Platform
- Latency-aware routing for llm-d (Developer Preview), LLMInferenceService `spec.router.scheduler.config.inline` EndpointPickerConfig, router configurations as `LLMInferenceServiceConfig` CRs, deployment wizard Advanced routing section

### AI/ML Fundamentals
- TTFT, TPOT, ITL latency metrics; prefill vs decode bottlenecks; KV cache utilization; latency predictor learning from historical request patterns

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform engineers and ML practitioners with OpenShift and llm-d working knowledge
- **Prerequisite knowledge**: Distributed Inference with llm-d concepts (llmd-core workshop), `oc` CLI basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with Distributed Inference with llm-d enabled; administrator-created router config for the attach-and-verify exercise; User Workload Monitoring for dashboards

## Open Questions

- Availability of a pre-provisioned latency-aware router configuration in workshop clusters (module 02 prerequisite)
- Whether the LLM Performance dashboard panels render in the workshop monitoring stack (doc-derived dashboard path)
