# Observations: LoRA-aware Routing for llm-d (doc-derived)

## Summary

LoRA-aware request routing for Distributed Inference with llm-d is a RHOAI 3.5
Developer Preview capability that lets platform operators route inference
requests to pods where the target LoRA adapter is already loaded, avoiding
cold-load latency from on-demand adapter swaps. When no pod with the target
adapter is available, requests automatically fall back to standard routing.
This observation document was produced from the official RHOAI 3.5 product
documentation (release notes Developer Preview section; Deploy models using
Distributed Inference with llm-d) because no live demo cluster was available at
authoring time. Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §Developer Preview features, "LoRA-aware request routing for Distributed Inference with llm-d" | Route requests to pods where the target LoRA adapter is already loaded; avoids cold-load latency from on-demand adapter swaps; automatic fallback to standard routing when no adapter-warm pod is available; DP — no dedicated configuration chapter |
| 2 | llmd-deploy-distributed-inference.txt | §10.2 Endpoint Picker architecture | EPP is the request orchestration component between the Inference Gateway and backend model servers; two sequential layers: Flow Control (when — priority queuing, saturation, load shedding) and Scheduling (where — scorer/routing plugins) |
| 3 | llmd-deploy-distributed-inference.txt | §10.x EPP metrics | Prometheus metrics at `/metrics` with `llm_d_epp_` prefix; `llm_d_epp_request_total`, `llm_d_epp_request_ttft_seconds`, `llm_d_epp_request_duration_seconds`, `llm_d_epp_request_error_total` all carry `model_name`, `target_model_name`, `fairness_id`, `priority` labels; `target_model_name` distinguishes adapter-targeted requests |
| 4 | llmd-deploy-distributed-inference.txt | §6.6.4 Routing group conditions | `GroupDegraded` set with reason `MemberDivergence` when group members serve different models or LoRA adapter sets; controller partitions the group by model and adapter set; condition does not block readiness — GroupReady and Ready can both be True while GroupDegraded is True |
| 5 | llmd-deploy-distributed-inference.txt | §2.8 Configuring advanced routing for deployed models | Advanced routing section of the deployment wizard; Default optimized routing pre-selected; dashboard filters router configurations by `opendatahub.io/supported-topologies` annotation; `spec.baseRefs` array lists topology preset then selected router configuration |
| 6 | llmd-deploy-distributed-inference.txt | §2.x Router configuration templates | Router `LLMInferenceServiceConfig` resources labeled `opendatahub.io/config-type: router`; admin-managed via `Settings → llm-d routing configurations` and `llm-d topology configurations` pages |

## User Flows

### Flow 1: Observe adapter-aware routing via EPP metrics

1. **Confirm the stack** — `oc get llmisvc` and `oc get llminferenceserviceconfig -A` show llm-d resources (§2.x prerequisites)
2. **Send repeated requests** — same request warms the serving pod; authenticated with an Authorization header when auth is enabled (§5.1)
3. **Read the metrics** — `llm_d_epp_request_total` splits traffic by `target_model_name`; `llm_d_epp_request_ttft_seconds` drops as pods warm (§10.x)
4. **Interpret** — first requests after cold start pay warm-up latency (the same effect adapter swaps cause); requests without an adapter-matched pod fall back and still complete

### Flow 2: Walk the advanced routing deployment workflow

1. **Open the wizard** — Data Science Projects → project → Deploy model; select Generative AI or Distributed inference with llm-d (§2.1)
2. **Choose topology and storage** — §2.8 procedure
3. **Expand Advanced routing** — Default optimized routing pre-selected; router configuration list filtered by `opendatahub.io/supported-topologies` (§2.8)
4. **Create and verify** — deployment reaches Ready; `spec.baseRefs` lists topology preset first, then any selected router configuration (§2.8)

## Features and Concepts

### OpenShift Platform
- Inference Gateway, HTTPRoute weighted backend references, Prometheus metrics endpoint, RBAC (ServiceAccount/Role/RoleBinding)

### RHOAI / AI Platform
- LoRA-aware request routing (DP), Distributed Inference with llm-d (GA), Endpoint Picker (EPP) / inference scheduler, LLMInferenceService and LLMInferenceServiceConfig CRs, router and topology configuration templates, routing-group partitioning by model and adapter set

### AI/ML Fundamentals
- LoRA (Low-Rank Adaptation) parameter-efficient fine-tuning, adapter cold-load latency, warm-up vs steady-state serving, KV cache-aware scheduling, TTFT as a latency signal

## Workshop Potential

- **Estimated modules**: 2 (guided tour → hands-on observation)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics, Distributed Inference with llm-d enabled
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with Distributed Inference (llm-d) enabled in the DSC; router configuration visibility depends on administrator-created resources

## Open Questions

- Whether LoRA-aware routing gets a dedicated configuration procedure chapter in a later release (currently release-notes-only)
- Router configuration availability and EPP metrics scraping in workshop clusters (facilitator-dependent)
- Exact `Settings → llm-d routing configurations` menu label on a live console (doc-derived path)
