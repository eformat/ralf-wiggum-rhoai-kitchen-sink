---
schema_version: 1
id: RHAIBU-M33D1TD31VTQ
type: requirement
---
# CSV Export for Model Catalog Data Workshop

## Problem

Data scientists and AI engineers evaluating RHOAI 3.5 need a way to take Model
Catalog data out of the dashboard for spreadsheets, scripts, and reporting —
CSV export for Model Catalog data (Developer Preview) provides exactly that via
a standalone Python CLI script. Without a structured workshop, learners must
discover the catalog metadata shape, the script's options, and the output
format from product documentation alone. This workshop targets RHOAI users with
working knowledge of OpenShift and the model catalog workflow.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to open the Catalog page under `AI hub → Models` in the OpenShift AI dashboard and see at least one category of models with their names, descriptions, and labels
- [REQ-003] Learner MUST be able to run the standalone Python CSV export script with its documented options and confirm it exits without errors and reports the path to a CSV file
- [REQ-004] Learner MUST be able to validate the exported file as RFC 4180-compliant CSV: a header row followed by one row per model, with all model metadata and custom properties present
- [REQ-005] Learner SHOULD be able to confirm exported rows respect the `--source` and `--limit` options passed to the script

## Success Metrics

All five acceptance criteria are demonstrated by the learner during the lab;
the export script completes a full run and the resulting CSV opens cleanly with
a header row plus one row per catalog model.

## Risks

- The feature is Developer Preview in 3.5 and may change between releases
- The exact script name and installation steps come from the external *CSV Exporter for Model Catalog* guide, not the downloaded RHOAI documentation
- An empty catalog blocks Exercise 1 verification; learners must ask an administrator to check configured catalog sources

## Assumptions

- RHOAI 3.5 is installed with the Model Catalog accessible
- Learners have `oc` CLI access, workshop credentials (`{user}`, `{guid}`), and Python 3.10+ (the script has no additional dependencies)
- The Model Catalog REST API is reachable from the learner's environment

## Related Designs

- RHAIBU-M33D1TESK2TR

## Related Decisions

- RHAIBU-M33D1TDW4W7P
- RHAIBU-M33D1TEAXNPQ

## Related Requirements

- RHAIBU-M33D1TDG1EY0
