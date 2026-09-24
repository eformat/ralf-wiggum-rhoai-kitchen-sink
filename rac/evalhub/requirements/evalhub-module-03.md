---
schema_version: 1
id: RHAIBU-M33ESYF00CKR
type: requirement
---
# Module 03: Advanced Usage

## Problem

After CLI-driven single jobs, platform engineers need the visual workflow and
the collaboration surfaces: submitting and comparing evaluations from the RHOAI
dashboard, bundling benchmarks into reusable collections, logging results to
MLflow, and locking down tenant access with RBAC.

## Requirements

- [REQ-031] Learner MUST be able to submit an evaluation from the RHOAI dashboard (`Develop & train → Evaluations → Start evaluation run`) with benchmarks or suites, a threshold, and benchmark parameters, and view benchmark scores and pass or fail status
- [REQ-032] Learner MUST be able to compare two or more completed evaluation runs in the embedded MLflow comparison view with parameters and metrics in aligned columns
- [REQ-033] Learner MUST be able to create a custom collection from a YAML spec file (`evalhub collections create --file`) and confirm the name, category, and benchmark list with `evalhub collections describe <collection_id>`
- [REQ-034] Learner MUST be able to log results to an MLflow experiment (verify the experiment URL resolves) and grant tenant access with a Role and RoleBinding verified by `oc auth can-i create evaluations.trustyai.opendatahub.io --as=<user_name>` returning `yes`

## Success Metrics

Learner completes all four exercises: the dashboard submission with threshold,
the MLflow comparison view with aligned columns, the custom collection described
with its benchmark list, and the MLflow experiment URL plus the `yes`
impersonation check.

## Risks

- Dashboard comparison requires MLflow experiment tracking configured and the MLflow federated plugin enabled on the dashboard
- The comparison view shows raw metric values only (no score direction, thresholds, or suite grouping)

## Assumptions

- Learner has completed Module 02 (a completed job exists to compare against)

## Related Requirements

- RHAIBU-M33ESYEB6HGQ

## Verified By

- features/evaluation/evalhub/content/modules/ROOT/pages/module-03-advanced.adoc
