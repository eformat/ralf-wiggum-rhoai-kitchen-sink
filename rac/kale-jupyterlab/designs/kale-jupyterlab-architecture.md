---
schema_version: 1
id: RHAIBU-M33D808CWPHP
type: design
---
# Kale JupyterLab Extension Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. The Kale JupyterLab extension (Developer Preview) is the
agents-mcp category's notebook-to-pipeline authoring feature: the extension
enablement flow, KFP connection model, and dashboard pipeline views taught here
build on the Data Science Pipelines component and complement the AI Pipelines
workshops in the same catalog.

## User Need

Data scientists and MLOps engineers with a running workbench need a 30–60
minute guided path from a pipeline-ready project to a notebook wired for
conversion and its pipeline evidence in the dashboard — with every step
verifiable despite Developer Preview documentation gaps.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/kale-jupyterlab/content/`):

1. **Module 01: Getting Started** — what Kale does (KFP authoring skip explained) + pipeline readiness (`oc get dspa -n {guid}-{user}`, workbench image check) + extension enablement (`jupyter labextension enable jupyterlab-kubeflow-kale`, `jupyter labextension list`) + KFP connection status interpretation
2. **Module 02: Hands-on Exercise** — per-notebook Enable toggle and Kale metadata editor, then dashboard evidence hunt (*Pipeline definitions → Manage pipeline server configuration*; *Develop & train → Experiments → Runs*; pipeline logs views)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the upstream Kale documentation.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP`
- Kale is Developer Preview in 3.5 — DP banner required and commands limited to the release-notes enablement flow
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

Developer Preview maturity drives guided-tour depth: release-notes-verbatim
commands (`oc get dspa`, `jupyter labextension enable/list`) and dashboard
navigation instead of undocumented field-level editor detail. Module order
follows the learner's dependency chain (verify prerequisites → enable →
convert → observe), matching the module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: concepts/enablement and the hands-on workflow have different verification styles (CLI output vs dashboard navigation)
- **Fabricating metadata-editor field detail** — rejected: violates the no-fabrication guardrail; the release notes defer to upstream Kale documentation

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Connection status colors paired with text semantics (green = connected, yellow = disconnected) rather than color alone

## Open Questions

- Field-level Kale metadata editor options must be confirmed against upstream Kale documentation or a live workbench (doc-derived gap)
- Whether module 02 should drive an actual pipeline run from the notebook or remain observation-only pending Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33D807CPVN8
- RHAIBU-M33D807JY58F
- RHAIBU-M33D807SV65D

## Related Decisions

- RHAIBU-M33D80805FR9
- RHAIBU-M33D8086PRWV
