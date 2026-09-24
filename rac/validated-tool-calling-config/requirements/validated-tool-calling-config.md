---
schema_version: 1
id: RHAIBU-M33EB4F3BPFR
type: requirement
---
# Validated Tool-calling Configuration in Model Catalog Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with Validated tool-calling configuration in Model Catalog — the
Technology Preview that surfaces Red Hat-validated `vllm serve` arguments for
models with confirmed tool-calling support — before they can run tool-calling
models with confidence or rank candidates against their own MCP tool ecosystem.
Without a structured workshop, learners must reverse-engineer the
`OdhDashboardConfig` feature flag, the Validated Arguments UI, and the SDG Hub
MCP evaluation pipeline from product documentation alone. This workshop targets
RHOAI users with working knowledge of OpenShift and the model catalog.

## Requirements

- [REQ-001] Learner MUST be able to enable validated tool-calling configuration by patching `spec.dashboardConfig.toolCalling` to `true` on the `OdhDashboardConfig` custom resource and verify the flag via jsonpath (`true`)
- [REQ-002] Learner MUST be able to verify the dashboard pods are running (`oc get pods -n redhat-ods-applications -l app=odh-dashboard`) so the change is picked up
- [REQ-003] Learner MUST be able to find a model details page in the catalog that lists the *Validated Arguments* section and copy the exact `vllm serve` arguments from the *Tool Calling* panel (`--tool-call-parser`, `--reasoning-parser`, `--chat-template`, `--enable-auto-tool-choice`)
- [REQ-004] Learner SHOULD be able to use the *Validated Arguments* filter to narrow the catalog to models with confirmed tool-calling support
- [REQ-005] Learner MUST be able to generate tool-calling evaluation benchmarks from their own MCP servers with the SDG Hub evaluation pipeline and verify `benchmark_tasks.jsonl` contains well-formed records
- [REQ-006] Learner MUST be able to evaluate candidate models against the generated benchmarks and confirm every configured model has a non-zero score count in `evaluation_results.jsonl`
- [REQ-007] Learner MUST be able to check `ZERO_JUDGE` and `ZERO_METRICS` failure indicators and interpret the four programmatic trace metrics (`tool_recall`, `tool_precision`, `order_match`, `param_match`)

## Success Metrics

All seven acceptance criteria are demonstrated by the learner during the lab;
the `toolCalling` flag verifies as `true`, the benchmark and results files
verify with well-formed records, and every configured candidate model has
scores in `evaluation_results.jsonl`.

## Risks

- The feature is Technology Preview in 3.5 — the `toolCalling` flag name, Validated Arguments UI panels, and displayed arguments may change between releases
- The `OdhDashboardConfig` patch requires cluster administrator privileges and is cluster-wide
- Module 02 needs one or more development/staging MCP servers and an OpenAI API-compatible frontier LLM endpoint; the pipeline actively invokes tools, so production servers are unsafe

## Assumptions

- RHOAI 3.5 is installed with the model catalog accessible and the model registry component enabled
- Learners have `oc` CLI access and cluster administrator credentials
- Module 02 learners have MCP servers and a frontier LLM API key (`OPENAI_API_KEY`)

## Related Designs

- RHAIBU-M33EB4H56BSG

## Related Decisions

- RHAIBU-M33EB4G74DNR
- RHAIBU-M33EB4GQFNSF

## Related Requirements

- RHAIBU-M33EB4FEBDAE
- RHAIBU-M33EB4FVJT4E
