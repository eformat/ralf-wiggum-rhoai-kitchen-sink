---
schema_version: 1
id: RHAIBU-M33EHKA0YWP3
type: requirement
---
# Module 01: Core Concepts

## Problem

Before running a scan, learners need a mental model of the two-phase assessment
(prompt generation, then security testing), the judge classifications, the
attack strategies, and the cluster components that back the feature: the
TrustyAI component, the pipeline server, and EvalHub. Without this orientation,
later hands-on steps are copy-paste with no understanding of what is being
created.

## Requirements

- [REQ-011] Learner MUST be able to name the two phases of the assessment (prompt generation, security testing) and the four judge classifications (Complied, Rejected, Alternative, Other)
- [REQ-012] Learner MUST be able to name the five attack strategies (Baseline, System Prompt Override, SPO variants, Translation, TAP) and how they run cumulatively
- [REQ-013] Learner MUST be able to verify the TrustyAI component reports `Managed` with `oc get datasciencecluster default -o jsonpath='{.spec.components.trustyai.managementState}'`
- [REQ-014] Learner MUST be able to verify the `eval-hub` pod is `Running` in the `{guid}-evalhub` namespace and the `ds-pipeline-dspa` route resolves to a host

## Success Metrics

Learner completes both exercises: the concepts walkthrough (naming the phases,
classifications, and strategies without consulting the table) and the cluster
inspection commands, each producing the documented expected output.

## Risks

- EvalHub may not be deployed on the cluster; exercise 2's EvalHub check must then be adapted (module 3 shows the standalone KFP path)

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33EHK9KK941

## Verified By

- features/evaluation/automated-red-teaming-garak/content/modules/ROOT/pages/module-01-concepts.adoc
