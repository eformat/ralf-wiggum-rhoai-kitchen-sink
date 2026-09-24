# Observations: LLMInferenceService / LLMInferenceServiceConfig (llm-d-native) (doc-derived)

## Summary

LLMInferenceService / LLMInferenceServiceConfig (llm-d-native) is RHOAI 3.5's GA
declarative path for generative LLM serving: a single `LLMInferenceService` CR
(serving.kserve.io/v1alpha1) composes the model location, workload template, and
llm-d routing components, while `LLMInferenceServiceConfig` templates — discovered
by `opendatahub.io/config-type` labels — power the dashboard's topology selector
and `baseRefs` merge behavior. This observation document was produced from the
official RHOAI 3.5 product documentation (Deploy models using Distributed
Inference with llm-d, LLMInferenceService/LLMInferenceServiceConfig chapters)
because no live demo cluster was available at authoring time. Every item below is
doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | llmd-deploy-distributed-inference.txt | §2.1 Unified generative model serving | Administrator control: admins create topology and router configuration templates; non-single-node topologies disabled in the wizard until templates exist |
| 2 | llmd-deploy-distributed-inference.txt | §2.2 Inference workload deployment topology patterns | Four validated patterns (single-node, multi-node data-parallel, single-node P/D disaggregate, multi-node P/D disaggregate) plus WideEP for MoE (Developer Preview only) |
| 3 | llmd-deploy-distributed-inference.txt | §2.3 Deployment topology configuration labels | `opendatahub.io/config-type` label values: `workload-single-node`, `workload-multi-node-data-parallel`, `workload-single-node-pd`, `workload-multi-node-data-parallel-pd`, `router` |
| 4 | llmd-deploy-distributed-inference.txt | §2.9 Managing topology configuration templates | Prerequisites: administrator privileges, model serving platform, `llmdTemplates` feature flag in `OdhDashboardConfig`; page columns Name/Topology type/Enabled/Pre-installed/Actions; Add flow: topology type → Start from sample/Upload/scratch → YAML review → Create |
| 5 | llmd-deploy-distributed-inference.txt | §2.9 Verification + webhook errors | New config appears in list; corresponding topology radio button enabled in the Deploy model wizard; KServe webhook errors: `baseRefs field is forbidden in LLMInferenceServiceConfig`, `scheduler replicas must be greater than 0` |
| 6 | llmd-deploy-distributed-inference.txt | §2.10 Managing existing topology configurations | Edit/duplicate/delete from the page's action menu; deleting a configuration does not affect deployed models that reference it |
| 7 | llmd-deploy-distributed-inference.txt | §2.11 Managing router configurations | `Settings → llm-d routing configurations`; router templates are optional enhancements filtered by the `opendatahub.io/supported-topologies` annotation (JSON array) |
| 8 | llmd-deploy-distributed-inference.txt | §2.13 Deploy disaggregated prefill/decode topology | `spec.prefill` presence activates disaggregated mode; controller auto-applies separate prefill/decode scheduler profiles and inline/ConfigMap overrides are locked out; requires RDMA-capable networking (InfiniBand or RoCE v2) |
| 9 | llmd-deploy-distributed-inference.txt | §5.1 Make authenticated inference requests | ServiceAccount + Role (`resourceNames`) + RoleBinding + `oc create token`; authenticated chat-completion returns 200, unauthenticated 401 |

## User Flows

### Flow 1: Administrator creates a topology configuration template

1. **Enable prerequisites** — administrator role, model serving platform, `llmdTemplates` feature flag (§2.9)
2. **Open settings page** — Settings → llm-d topology configurations (§2.9)
3. **Add configuration** — pick topology type, source (sample/upload/scratch), name, YAML review, Create (§2.9)
4. **Verify YAML** — `opendatahub.io/config-type` label matches the topology; worker pool `spec.workers` for multi-node; `spec.scheduler.replicas ≥ 1` for P/D (§2.9)
5. **Verify** — configuration appears in the list; matching topology radio button enabled in the Deploy model wizard (§2.9)

### Flow 2: Administrator adds a router configuration

1. **Open settings page** — Settings → llm-d routing configurations (§2.11)
2. **Create router template** — `config-type: router` label plus `opendatahub.io/supported-topologies` JSON-array annotation (§2.11)
3. **Select in wizard** — advanced routing section filters routers by topology compatibility (§2.11)
4. **Verify merge** — generated `LLMInferenceService` `spec.baseRefs` lists the `kserve-system` topology preset followed by the selected router (§2.8)

### Flow 3: Deploy disaggregated prefill/decode

1. **Add `spec.prefill`** — presence alone activates the disaggregated topology (§2.13)
2. **Automatic scheduler** — controller applies separate prefill/decode profiles; cannot be overridden inline or by ConfigMap (§2.13.1)
3. **Verify** — empty `spec.prefill` presence marker after processing; EPP scheduler pod logs show the disaggregated profile handler (§2.13)

## Features and Concepts

### OpenShift Platform
- Gateways and GatewayClass (`openshift-ai-inference`), HTTPRoutes, RBAC (ServiceAccount/Role/RoleBinding)

### RHOAI / AI Platform
- `LLMInferenceService` (serving.kserve.io/v1alpha1) and `LLMInferenceServiceConfig` CRs; `baseRefs` merge order (lower entries take precedence); `opendatahub.io/config-type` / `opendatahub.io/supported-topologies` discovery; `llmdTemplates` dashboard feature flag; KServe webhook validation (baseRefs forbidden on configs, scheduler replicas > 0)

### AI/ML Fundamentals
- LLM serving topologies (single-node, multi-node data-parallel, prefill/decode disaggregation, WideEP for MoE), KV-cache-aware scheduling, NIXL KV-cache transfers over RDMA

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: platform engineers and ML administrators with OpenShift working knowledge
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics, Kubernetes Gateway API basics
- **Estimated duration**: about 2 hours
- **Cluster requirements**: RHOAI 3.5 with Distributed Inference enabled in the DSC, `openshift-ai-inference` Gateway programmed, administrator privileges for module 03

## Open Questions

- Exact `Settings → llm-d topology configurations` / `llm-d routing configurations` menu labels on a live console (doc-derived paths)
- Router configuration template availability in workshop clusters (module 03 prerequisite)
- RDMA-capable networking and multi-GPU capacity for the disaggregated prefill/decode exercise
