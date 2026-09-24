---
schema_version: 1
type: asset
---
# Screenshot Evidence: NeMo Guardrails Workshop

## Capture Summary

- **Date:** 2026-09-24
- **Cluster:** api.cluster-44gxc.dyn.redhatworkshops.io (OCP, RHOAI 3.5.1, TrustyAI Managed, serving Headless)
- **Project:** nemo-guardrails-test
- **Captured:** 2/2 shots
- **Failed:** 0
- **Model endpoint:** granite-vllm-predictor (vllm-cpu-x86-runtime, qwen2.5-0.5b-instruct modelcar, port 8080)

## Evidence Map

| Screenshot | Page | Requirement | Criterion | Status |
|------------|------|-------------|-----------|--------|
| 01-project-topology.png | module-02-hands-on.adoc | REQ-003 | Deploy standalone NemoGuardrails service and confirm PHASE Ready (pod, service, route deployed) | captured |
| 02-deployments-list.png | module-03-advanced.adoc | REQ-032 | Scale with spec.replicas: 3 and observe READY 3/3 on nemo-policies | captured |

## Live Test Results (functional, beyond screenshots)

All exercises verified end-to-end against the deployed cluster:

- REQ-001/012-014: DSC TrustyAI Managed, operator CSV Succeeded, NemoGuardrails CRD served
- REQ-003/021: nemo-quickstart PHASE Ready; route + service created
- REQ-004/022: `/v1/guardrail/checks` — safe content `success`, email `blocked`, password keyword `blocked`, `activated_rails` observed
- REQ-023: multi-message single request, per-message results observed
- REQ-005/024: `/v1/chat/completions` with granite-vllm — safe question answered, email blocked before LLM (0 LLM calls, `bot inform answer unknown`)
- REQ-031: same request `blocked` under default strict-filtering, `success` under lenient-filtering via `guardrails.config_id`
- REQ-033: masking flow replaced PII and the request succeeded (sent to LLM)
- REQ-034: custom Colang flow + Python action blocked a 120-word message with the custom message; short message answered

## Cluster findings (content fixes identified during the run)

1. `openai_api_base` is rejected by NeMo Guardrails 0.24 (0.21-style LangChain convention) — must be `base_url`
2. Predictor URL port: RHOAI vLLM runtime templates use `--port=8080`; documented `:8000` never connects (headless svc does no port remap)
3. Colang `define flow` / `define bot` bodies must be indented (workshop rails.co is not) — `ColangParsingError`
4. Masking token in 0.24 is `<EMAIL_ADDRESS>`, not `[MASKED]`
5. Block response text is "I don't know the answer to that." (`bot inform answer unknown`), not "a message indicating that sensitive data was detected"
6. The module-03 lorem-ipsum test message is 82 words — triggers `warning_long`, not `blocked_too_long`; a >100-word message is needed to demo the block
7. Pre-installed runtimes are OpenShift Templates: `oc process -n redhat-ods-applications vllm-cpu-x86-runtime-template | oc apply -f -` + template-origin annotations (per ph-deploy-configure-rhoai module-03)
