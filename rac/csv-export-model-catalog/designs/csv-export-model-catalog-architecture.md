---
schema_version: 1
id: RHAIBU-M33D1TESK2TR
type: design
---
# CSV Export for Model Catalog Data Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. CSV export for Model Catalog data (Developer Preview) is a
compact, script-driven capability in the model catalog workflow: it packages the
full catalog result set — metadata plus custom properties — as RFC 4180-compliant
CSV via the Model Catalog REST API. Unlike platform features that teach
Kubernetes CRs, this feature teaches one CLI script and the catalog metadata it
reads.

## User Need

Data scientists and AI engineers need a 45-minute guided path from locating the
catalog metadata in the dashboard to holding a validated CSV snapshot of their
model catalog — with every step verifiable and no invented commands for the
undocumented portions of the script.

## Design

One module plus shared bookends, one Antora component
(`features/agents-mcp/csv-export-model-catalog/content/`):

1. **Module 01: Guided tour — exporting Model Catalog data as CSV** — a
   descriptive guided tour in three exercises:
   - **Exercise 1: Locate the metadata you will export** — dashboard walkthrough
     (`AI hub → Models → Catalog`), categories, search/filter, model details
     page, the metadata the export packages
   - **Exercise 2: Run the CSV export script** — Python 3.10+ check, documented
     usage pattern with `<placeholders>`, options table (`--source`, `--limit`,
     `--header`), atomic-write behavior
   - **Exercise 3: Validate the exported CSV** — header-row inspection with
     `head -n 1`, spreadsheet/CSV viewer checks, optional `--source` re-run

Bookends: Overview (DP maturity banner + prerequisites) and Getting Connected
are shared boilerplate; Conclusion links the release notes and the external
*CSV Exporter for Model Catalog* guide.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP`
- Developer Preview feature → module is descriptive (guided tour), not a full platform lab
- The script name and installation steps are not in the downloaded docs — usage pattern uses `<placeholder>` tokens referencing the external *CSV Exporter for Model Catalog* guide
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

DP maturity drives an honest guided-tour lab: learners observe the catalog data,
run the documented export script, and inspect the CSV output. A single module
matches the feature's scope — one script, three verifiable outcomes — rather
than inflating a compact capability into a multi-module platform lab. Exercise
order follows the learner's dependency chain (see the data → run the export →
validate the output).

## Alternatives

- **Multi-module lab (concepts + hands-on + advanced)** — rejected: the feature has no CRs, no cluster configuration, and no advanced surface; a single module avoids padding
- **Full hands-on lab with invented script details** — rejected: violates the no-fabrication guardrail while the script installation lives in an external guide

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the exact script name and installation steps against the external *CSV Exporter for Model Catalog* guide (referenced from the release notes)
- Capture the model catalog page screenshot in the Act phase (`// TODO: capture screenshot`)

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33D1TD31VTQ
- RHAIBU-M33D1TDG1EY0

## Related Decisions

- RHAIBU-M33D1TDW4W7P
- RHAIBU-M33D1TEAXNPQ
