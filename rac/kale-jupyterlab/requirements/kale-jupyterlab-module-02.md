---
schema_version: 1
id: RHAIBU-M33D807SV65D
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners must run the notebook-to-pipeline workflow end to end — turn Kale
on for a notebook, annotate it in the Kale metadata editor, convert and
execute the pipeline run from the workbench, and observe the run's status,
graph, and step logs in the OpenShift AI dashboard. This is the core
deliverable of the workshop: a notebook wired for conversion with the
pipeline run verified in the dashboard and on the pipeline server.

## Requirements

- [REQ-021] Learner MUST be able to switch on the per-notebook Enable toggle that Kale activates, observe that the Kale metadata editor opens, and run the notebook cells before annotating
- [REQ-022] Learner MUST be able to convert the annotated notebook and create a pipeline run from the workbench via the Kale metadata editor, and observe that a pipeline run executes once immediately after it is created
- [REQ-023] Learner MUST be able to observe the converted pipeline run on the *Runs* tab under *Develop & train → Experiments* (Status column shows Succeeded/Running/Failed) and open the run details from *Develop & train → Pipelines → Runs* (run graph, execution details, input parameters, step logs, run output)
- [REQ-024] Learner SHOULD be able to confirm the converted pipeline is registered on the pipeline server by listing experiments and pipelines with an authenticated KFP SDK client (`client.list_experiments()` / `client.list_pipelines()`)
- [REQ-025] Learner SHOULD be able to open the pipeline server details from *Develop & train → Pipelines → Pipeline definitions* via *Pipeline server actions → Manage pipeline server configuration* and read the step logs of the run from the run details page

## Success Metrics

The Enable toggle is on, the Kale metadata editor is open, and the notebook
cells executed; the converted pipeline run appears on the *Runs* tab under
*Develop & train → Experiments* with status Succeeded or Running; the run
details page opens from *Pipelines → Runs* with the run graph and step logs;
`client.list_pipelines()` output lists the pipeline converted from the
notebook; the pipeline server details open from *Pipeline server actions*.

## Risks

- The field-level metadata editor options and the exact submit controls are undocumented in the RHOAI 3.5 product docs (deferred to upstream Kale documentation) and may change between releases
- The exact handoff between the extension and the pipeline server may change because Kale is a Developer Preview feature
- The KFP SDK client requires a valid OpenShift access token; a literal token pasted into commands can appear in shell history or process listings

## Assumptions

- Learner has completed Module 01 (extension enabled, KFP connected) and has a pipeline server attached to the project
- The learner's workbench terminal has `oc` access to the project and the KFP Python client is importable in the notebook environment

## Related Requirements

- RHAIBU-M33D807CPVN8

## Verified By

- features/agents-mcp/kale-jupyterlab/content/modules/ROOT/pages/module-02-hands-on.adoc
