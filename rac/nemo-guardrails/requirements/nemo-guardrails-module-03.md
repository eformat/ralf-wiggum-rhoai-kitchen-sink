---
schema_version: 1
id: RHAIBU-M33F0QSEHS0X
type: requirement
---
# Module 03: Advanced Usage

## Problem

After a basic deployment, platform engineers need to operate guardrails beyond
a single blocking policy: load multiple guardrail configurations on one
`NemoGuardrails` resource and switch per request with `config_id`, scale the
deployment, mask detected PII instead of blocking it, and extend the
configuration with custom Colang flows and Python actions.

## Requirements

- [REQ-031] Learner MUST be able to load two guardrail configurations on one `NemoGuardrails` resource with a `default: true` entry and switch between them per request with `guardrails.config_id`
- [REQ-032] Learner MUST be able to scale the deployment with `spec.replicas: 3` and observe `READY` `3/3` on `oc get deploy nemo-policies`
- [REQ-033] Learner SHOULD be able to patch a `NemoGuardrails` CR to masking flows (`mask sensitive data on input`/`on output`) and observe the detected address replaced with `[MASKED]` instead of a block
- [REQ-034] Learner SHOULD be able to add a custom rail with a Colang flow (`check message length`) that calls a Python action (`@action(is_system_action=True)`) and observe the block message for over-length input

## Success Metrics

Learner completes all three exercises: the same request is `blocked` under the
default strict policy and `success` under `lenient-filtering`, the deployment
reports `3/3` ready replicas, the masking request succeeds with `[MASKED]`
substitution, and the 100-word custom rail blocks over-length messages with
the documented message.

## Risks

- Patching `nemo-simple` replaces the active configuration from the previous exercise; previous `nemoConfigs` values must be recorded to restore
- Custom Python actions run in-process in the guardrails pod; a config error can break the redeploy

## Assumptions

- Learner has completed Module 02 (a `nemo-simple` deployment with a live model exists to patch)
- A tracing backend is optional; the OpenTelemetry observability section is exploratory only

## Related Requirements

- RHAIBU-M33F0QRTSW8T

## Verified By

- features/guardrails/nemo-guardrails/content/modules/ROOT/pages/module-03-advanced.adoc
