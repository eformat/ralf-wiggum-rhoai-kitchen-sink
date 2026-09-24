---
schema_version: 1
id: RHAIBU-M33EHKATAWPA
type: requirement
---
# Module 03: Advanced Usage

## Problem

After a first scan, practitioners need to tune the assessment to their
organization's policies and to environments without EvalHub: override scan
behavior with `garak_config`, define custom harm categories, and run the
assessment standalone with the KFP Python SDK.

## Requirements

- [REQ-031] Learner MUST be able to re-submit the module 2 scan with an updated `garak_config` (deep-merged with profile defaults) and confirm the report reflects the new settings
- [REQ-032] Learner MUST be able to define custom harm categories in a policy dataset (`policy_concept`, `concept_definition`) and reference it with `policy_s3_key`, confirming results appear alongside the standard categories
- [REQ-033] Learner SHOULD be able to submit the assessment pipeline directly with the KFP Python SDK (`PipelineRunner.run_scan`, `wait_for_completion`) and download the HTML report
- [REQ-034] Learner SHOULD be able to prepare a disconnected cluster for translation attacks by pre-downloading the Helsinki-NLP models to S3 and verifying with `aws s3 ls`

## Success Metrics

Learner completes all three exercises: the tuned re-scan reflecting new
settings, the custom policy dataset producing per-category results in the same
report, and the standalone KFP SDK run downloading the HTML report.

## Risks

- On disconnected clusters the translation strategy cannot download models at runtime; it must be disabled via `garak_config` or the models pre-downloaded to S3
- Custom categories require an S3 bucket accessible with the `kfp_config.s3_secret_name` credentials

## Assumptions

- Learner has completed Module 02 (a scan exists to re-submit with the tuned configuration)

## Related Requirements

- RHAIBU-M33EHK9KK941

## Verified By

- features/evaluation/automated-red-teaming-garak/content/modules/ROOT/pages/module-03-advanced.adoc
