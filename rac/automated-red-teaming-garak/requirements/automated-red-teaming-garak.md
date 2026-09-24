---
schema_version: 1
id: RHAIBU-M33EHK9KK941
type: requirement
---
# Automated Red Teaming (powered by Garak) Workshop

## Problem

ML practitioners and platform engineers evaluating RHOAI 3.5 need hands-on
experience with Automated Red Teaming (powered by Garak) — the GA feature for
probing models and guardrails for safety weaknesses — before they can attest to
a model's safety posture. Without a structured workshop, learners must
reverse-engineer the two-phase assessment, the EvalHub tenant model, and the
Garak scan configuration from product documentation alone. This workshop targets
RHOAI users with working knowledge of OpenShift, model serving, and LLM safety
concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify the backing components: the TrustyAI component reports `Managed`, the `eval-hub` pod is `Running`, and the `ds-pipeline-dspa` route resolves to a host
- [REQ-003] Learner MUST be able to name the two assessment phases, the four judge classifications, and the five attack strategies
- [REQ-004] Learner MUST be able to register the project as an EvalHub tenant and verify the operator-provisioned ServiceAccount, RoleBindings, and service CA ConfigMap
- [REQ-005] Learner MUST be able to authenticate to EvalHub with a bearer token and confirm `garak` is enabled in the providers list
- [REQ-006] Learner MUST be able to submit an intent-based risk assessment through the EvalHub API and receive a `202 Accepted` response with a job ID
- [REQ-007] Learner MUST be able to read the risk assessment report's overview metrics, including the primary Attack Success Rate (ASR)
- [REQ-008] Learner SHOULD be able to tune the scan with `garak_config`, define custom harm categories, and run the assessment standalone with the KFP Python SDK

## Success Metrics

All eight acceptance criteria are demonstrated by the learner during the lab;
the risk assessment submission returns `202 Accepted` in module 02 and the
report's overview metrics (Total attempts, Unsafe prompts, Safe prompts, ASR)
are read from the completed scan.

## Risks

- A full scan of all default harm categories and strategies takes a long time; lab timing depends on narrowing the probe list or sample size
- The assessment requires an OpenAI-compatible target endpoint, a separate judge model endpoint, and an S3-compatible artifact store
- EvalHub must be deployed for modules 1–2; module 3 covers the standalone KFP path when it is not
- Naming and APIs are still settling between RHOAI releases (docs call it "automated risk assessment"; release notes announce Automated Red Teaming as GA)

## Assumptions

- RHOAI 3.5 is installed with the TrustyAI component set to `Managed` and KServe configured to use RawDeployment mode
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- A configured pipeline server (`ds-pipeline-dspa`) exists for the assessment pipeline

## Related Designs

- RHAIBU-M33EHKC1K1NP

## Related Decisions

- RHAIBU-M33EHKB8ZRXA
- RHAIBU-M33EHKBNSF20

## Related Requirements

- RHAIBU-M33EHKA0YWP3
- RHAIBU-M33EHKADNAR7
- RHAIBU-M33EHKATAWPA
