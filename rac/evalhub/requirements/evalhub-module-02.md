---
schema_version: 1
id: RHAIBU-M33ESYESMAJZ
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must drive a real evaluation end to end — install the EvalHub CLI,
discover the provider catalog, submit a job against a model endpoint from the
CLI and the REST API, track it to populated results, and route evaluation
jobs through a Kueue LocalQueue so they participate in cluster-wide quota
governance. This is the core deliverable of the workshop: a completed
evaluation job with per-benchmark metrics, queued through Kueue admission
control.

## Requirements

- [REQ-021] Learner MUST be able to install the EvalHub SDK with CLI support, configure `base_url` and `tenant`, and verify the connection with `evalhub health` returning `"status": "healthy"`
- [REQ-022] Learner MUST be able to list registered providers and describe one (`evalhub providers list`, `evalhub providers describe lm_evaluation_harness`); the provider list is not empty and includes the built-in providers
- [REQ-023] Learner MUST be able to submit an evaluation job from the CLI (`evalhub eval run`) and the REST API (`POST /api/v1/evaluations/jobs`) and observe the status transition `pending` to `running` to `completed`
- [REQ-024] Learner MUST be able to retrieve benchmark results with `evalhub eval results <job_id> --format table` showing a row per benchmark metric with non-empty values
- [REQ-025] Learner MUST be able to route evaluation jobs through Kueue by labeling the tenant namespace `kueue.openshift.io/managed=true` (in addition to the EvalHub tenant label), creating a LocalQueue (`kueue.x-k8s.io/v1beta1`) pointing at the ClusterQueue, submitting with `--queue kueue:<queue_name>` (or the REST `queue` block), and verifying the LocalQueue is `Active` via `oc get localqueue`
- [REQ-026] Learner MUST be able to verify Kueue admission of the queued evaluation job: `oc get workloads` in the tenant namespace lists a Workload for the Job, and `evalhub eval status <job_id>` transitions from `pending` (awaiting Kueue admission) to `running` (quota reserved)

## Success Metrics

`evalhub health` returns healthy; the provider list includes
`lm_evaluation_harness`; the submitted job reaches `completed`; the results
table shows per-benchmark metric rows such as `acc` and `acc_norm`; the queued
job's LocalQueue is `Active` and the job's Workload appears in `oc get
workloads` while the job transitions `pending` to `running`.

## Risks

- The model endpoint must be accessible from within the cluster and OpenAI-compatible; model URL format varies by provider
- Authentication requires a token from `oc whoami -t` (interactive) or a ServiceAccount token with an EvalHub Role (automation)
- EvalHub Kueue integration is Technology Preview and requires cluster-admin privileges; an invalid LocalQueue or stopped ClusterQueue fails the job with a `queue_error` message code, and without the Kueue Operator the queue label is ignored

## Assumptions

- Learner has completed Module 01 (deployment verified) and has a deployed model service
- The Red Hat build of Kueue Operator is installed and a cluster administrator can create the ClusterQueue

## Related Requirements

- RHAIBU-M33ESYEB6HGQ

## Verified By

- features/evaluation/evalhub/content/modules/ROOT/pages/module-02-hands-on.adoc
