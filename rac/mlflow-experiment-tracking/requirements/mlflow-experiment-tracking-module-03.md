---
schema_version: 1
id: RHAIBU-M33F7MZNSFEG
type: requirement
---
# Module 03: Advanced Usage

## Problem

After the basic deployment, platform engineers need to shape storage and
lifecycle behaviour: overriding artifact storage per project with the
namespace-scoped `MLflowConfig` resource, archiving trace payloads to
S3-compatible storage with the `traceArchival` section, and disabling the
workbench integration cleanly without leaving stale permissions behind.

## Requirements

- [REQ-031] Learner MUST be able to override artifact storage for a project with an `MLflowConfig` resource (`artifactRootSecret: mlflow-artifact-connection`) and verify new runs' artifact URIs point under the overridden bucket rather than the default path
- [REQ-032] Learner MUST be able to enable trace archival in the `MLflow` CR and verify the operator created the archival CronJob
- [REQ-033] Learner MUST be able to set a per-experiment retention override from the dashboard (*Edit Experiment* → *Trace archival retention*) and confirm the *Archive after* badge
- [REQ-034] Learner MUST be able to disable the workbench integration by removing the `opendatahub.io/mlflow-instance` annotation (after stopping the workbench) and verify the environment variables are gone and the RoleBinding deleted

## Success Metrics

Learner completes all three exercises: new-experiment artifacts resolving
under the S3 bucket, the archival CronJob listed with the configured schedule
and the *Archive after* badge shown, and a clean teardown with
`my-workbench-mlflow` returning NotFound.

## Risks

- MLflow does not serve artifacts for per-project overrides — the client needs valid S3 credentials
- Archival cannot be undone: archived span payloads are served from artifact storage and cannot be moved back
- Removing the annotation on a running workbench causes authentication failures; the validating webhook rejects removal unless `kubeflow-resource-stopped` is present

## Assumptions

- Learner has completed Module 02 (a tracking server and workbench integration exist)
- An S3-compatible bucket is available for the per-project override and trace archive exercises

## Related Requirements

- RHAIBU-M33F7MYEAZF9

## Verified By

- features/mlops/mlflow-experiment-tracking/content/modules/ROOT/pages/module-03-advanced.adoc
