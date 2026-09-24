# Observations: Distributed Inference with llm-d (doc-derived)

## Summary

Distributed Inference with llm-d is RHOAI 3.5's GA path for serving large
language models on OpenShift. This observation document was produced from the
official RHOAI 3.5 product documentation (Deploy models using Distributed
Inference with llm-d; Configuring your model-serving platform) because no live
demo cluster was available at authoring time. Every item below is doc evidence,
not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | llmd-deploy-distributed-inference.txt | §2.2 Inference workload deployment topology patterns | Four validated topology patterns: single-node, multi-node data-parallel, single-node prefill/decode, prefill/decode with WideEP |
| 2 | llmd-deploy-distributed-inference.txt | §2.7 Deploy with the topology selector | Dashboard wizard flow: Data Science Projects → Models → Deploy model → Distributed inference with llm-d → topology radio buttons → hardware profile → model location; wizard portion is Technology Preview in 3.5 |
| 3 | llmd-deploy-distributed-inference.txt | §5.1 Authenticated requests | ServiceAccount + Role (resourceNames) + RoleBinding + `oc create token`; authenticated curl returns 200, unauthenticated 401 |
| 4 | llmd-deploy-distributed-inference.txt | §2.8 Advanced routing | Router configuration selection in the wizard; `spec.baseRefs` on the generated LLMInferenceService |
| 5 | llmd-deploy-distributed-inference.txt | §2.9–2.11 Template management | `Settings → llm-d topology configurations` and `llm-d routing configurations`; router templates carry `config-type: router` label and `supported-topologies` annotation |
| 6 | llmd-deploy-distributed-inference.txt | §1.1 Prerequisites | Model-serving platform enabled in DSC; `openshift-ai-inference` Gateway in `openshift-ingress` with `PROGRAMMED: True` |

## User Flows

### Flow 1: Deploy via the dashboard wizard

1. **Enable prerequisites** — model-serving platform enabled; Gateway programmed (§1.1)
2. **Open wizard** — Data Science Projects → Models → Deploy model (§2.7)
3. **Choose topology** — Distributed inference with llm-d → single-node-default (§2.7)
4. **Select hardware profile and model location** — §2.7
5. **Verify** — LLMInferenceService ready condition (§2.7)

### Flow 2: Deploy from the CLI

1. **Apply LLMInferenceService manifest** (serving.kserve.io/v1alpha1) with model, router, scheduler stanzas
2. **Watch ready condition** — `status.conditions` + `status.url`
3. **Make authenticated request** — ServiceAccount token, curl 200 / 401 negative test (§5.1)

## Features and Concepts

### OpenShift Platform
- Gateways and GatewayClass (`openshift-ai-inference`), routes, RBAC (ServiceAccount/Role/RoleBinding)

### RHOAI / AI Platform
- Distributed Inference with llm-d component in the DSC, LLMInferenceService / LLMInferenceServiceConfig CRs, topology and router configuration templates

### AI/ML Fundamentals
- LLM serving topologies (single-node, prefill/decode disaggregation, WideEP), KV-cache-aware scheduling

## Workshop Potential

- **Estimated modules**: 3 (concepts → hands-on → advanced)
- **Target audience**: platform engineers and ML practitioners with OpenShift working knowledge
- **Prerequisite knowledge**: model serving concepts, `oc` CLI basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with Distributed Inference (llm-d) enabled in the DSC

## Open Questions

- Exact `Settings → llm-d topology configurations` menu label on a live console (doc-derived path)
- Router template availability in workshop clusters (module 03 prerequisite)
