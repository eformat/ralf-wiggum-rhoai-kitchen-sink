---
schema_version: 1
id: RHAIBU-M33D1TDG1EY0
type: requirement
---
# Module 01: Guided Tour — CSV Export

## Problem

Before running the CSV export, learners need to see where the data lives: the
Model Catalog in the OpenShift AI dashboard, the metadata each model entry
carries, and how the standalone Python script packages that metadata as
RFC 4180-compliant CSV. Without this orientation, the export is a black box
producing a file of unknown provenance.

## Requirements

- [REQ-011] Learner MUST be able to navigate to the Catalog page under `AI hub → Models` in the OpenShift AI dashboard and see at least one category of models with their names, descriptions, and labels
- [REQ-012] Learner MUST be able to run the CSV export script with its documented options (`--source`, `--limit`, `--header`) and confirm it exits without errors and reports the path to a CSV file, with no partial file left behind on failure
- [REQ-013] Learner MUST be able to verify the exported file opens cleanly as RFC 4180-compliant CSV: a header row followed by one row per model, with all model metadata and custom properties present
- [REQ-014] Learner SHOULD be able to confirm exported rows respect the `--source` and `--limit` options passed to the script

## Success Metrics

Learner completes all three exercises: locating the catalog metadata, running
the export script, and validating the exported CSV — each producing the
documented expected output.

## Risks

- The catalog may be empty if no model catalog sources are configured; Exercise 1 verification then requires administrator intervention
- Script installation steps live in an external guide; a learner without it cannot complete Exercise 2

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)
- Python 3.10+ is available on the learner's machine

## Related Requirements

- RHAIBU-M33D1TD31VTQ

## Verified By

- features/agents-mcp/csv-export-model-catalog/content/modules/ROOT/pages/module-01-hands-on.adoc
