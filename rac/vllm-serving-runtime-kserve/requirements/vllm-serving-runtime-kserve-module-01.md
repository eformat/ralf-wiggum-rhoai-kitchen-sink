---
schema_version: 1
id: RHAIBU-M33FYP3JWJCF
type: requirement
---
# Module 01: Enable the vLLM ServingRuntime for KServe

## Problem

Before deploying models, learners need a mental model of how the
`ServingRuntime` and `InferenceService` CRDs fit together on the single-model
serving platform, and they must flip the two configuration switches (model
serving platform, vLLM runtime) that gate every later step. Without this
orientation, the module-02 deployment is copy-paste with no understanding of
the pod template KServe instantiates.

## Requirements

- [REQ-011] Learner MUST be able to enable the model serving platform from the dashboard (`Settings → Cluster settings → General settings`, *Model serving platform* checkbox)
- [REQ-012] Learner MUST be able to enable the vLLM ServingRuntime for KServe from `Settings → Model resources and operations → Serving runtimes`
- [REQ-013] Learner MUST be able to confirm the runtime is enabled with `oc get servingruntimes -n redhat-ods-applications` and identify its GA support level from the dashboard badges (*Pre-installed* label + version badge, no *Limited support* badge)
- [REQ-014] Learner MUST be able to inspect the `ServingRuntime` template and verify `supportedModelFormats` shows `[{"autoSelect":true,"name":"vLLM"}]` via `oc get servingruntime vll-runtime -o jsonpath`

## Success Metrics

Learner completes both exercises: the platform/runtime enablement and the
`ServingRuntime` template inspection, each producing the documented expected
output.

## Risks

- Enablement requires dashboard administrator privileges
- On clusters without accelerator operators, the accelerator-specific vLLM variants (NVIDIA, Gaudi, AMD, Spyre) are not usable — only the base runtime is exercised

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33FYP394X0S

## Verified By

- features/model-serving/vllm-serving-runtime-kserve/content/modules/ROOT/pages/module-01-getting-started.adoc
