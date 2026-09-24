---
schema_version: 1
id: RHAIBU-M33ESYEB6HGQ
type: requirement
---
# Evaluation Stack (EvalHub) Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with the Evaluation Stack (EvalHub) — the GA evaluation orchestration
service for LLMs — before they can build repeatable, multi-tenant evaluation
workflows in production. Without a structured workshop, learners must
reverse-engineer the provider/benchmark/collection model, the job lifecycle,
MLflow tracking, and tenant RBAC from product documentation alone. This workshop
targets RHOAI users with working knowledge of OpenShift and a model-serving
endpoint with an OpenAI-compatible `/v1` API.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to verify the EvalHub deployment: the TrustyAI component reports `Managed`, the `eval-hub` pod is `Running`, the health endpoint returns `"status": "healthy"`, and tenant resources exist in the working project
- [REQ-003] Learner MUST be able to name the three EvalHub components, the job state progression, and the three threshold levels without consulting the page
- [REQ-004] Learner MUST be able to install and configure the `evalhub` CLI against the server route and tenant; `evalhub health` returns `"status": "healthy"` with a version string
- [REQ-005] Learner MUST be able to list registered providers and their benchmarks; the list is not empty and includes the built-in providers such as `lm_evaluation_harness`
- [REQ-006] Learner MUST be able to submit an evaluation job from the CLI and the REST API and observe the status transition `pending` to `running` to `completed`
- [REQ-007] Learner MUST be able to retrieve benchmark results with `evalhub eval results <job_id> --format table` showing a row per benchmark metric with non-empty values
- [REQ-008] Learner MUST be able to submit an evaluation from the RHOAI dashboard with benchmarks or suites, a threshold, and benchmark parameters, and view benchmark scores and pass or fail status
- [REQ-009] Learner SHOULD be able to compare completed evaluation runs in the embedded MLflow comparison view with parameters and metrics in aligned columns
- [REQ-010] Learner MUST be able to create a custom collection from a YAML spec file and confirm it with `evalhub collections describe`
- [REQ-011] Learner MUST be able to log job results to an MLflow experiment and grant tenant access with a Role and RoleBinding verified by `oc auth can-i`

## Success Metrics

All eleven acceptance criteria are demonstrated by the learner during the lab;
the CLI job reaches `completed` in module 02 with a populated results table, the
dashboard run shows scores and pass or fail status, and the RBAC impersonation
check returns `yes`.

## Risks

- The workshop requires a pre-deployed EvalHub instance (`{guid}-evalhub` namespace) with the working project registered as a tenant by the facilitator
- Model serving endpoint must expose an OpenAI-compatible `/v1` API; model URL format varies by provider
- The dashboard comparison view requires MLflow tracking configured and the MLflow federated plugin on the dashboard
- Benchmark parameters and dashboard UI may change between releases

## Assumptions

- RHOAI 3.5 is installed with the TrustyAI component `Managed` and KServe in `RawDeployment` mode
- Learners have `oc` CLI access, workshop credentials (`{user}`, `{guid}`), and Python 3.11+ with PyPI access
- MLflow tracking URI is set in the EvalHub CR for module 03 exercises

## Related Designs

- RHAIBU-M33ESYFP6FCH

## Related Decisions

- RHAIBU-M33ESYF8W2FN
- RHAIBU-M33ESYFGWADW

## Related Requirements

- RHAIBU-M33ESYEH6WFB
- RHAIBU-M33ESYESMAJZ
- RHAIBU-M33ESYF00CKR
