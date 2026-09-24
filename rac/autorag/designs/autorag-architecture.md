---
schema_version: 1
id: RHAIBU-M33F08FWR6GN
type: design
---
# AutoRAG Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. AutoRAG (Technology Preview) is the RAG-optimization feature
in the feature-store-automl-autorai category: the optimization workflow,
evaluation metrics, and leaderboard interpretation taught here depend on OGX
(the product's inference server) and complement the RAG deployment guidance in
the building-RAG documentation.

## User Need

ML practitioners with editor access to a RHOAI project need a 60–90 minute
guided path from a JSON test data file to a completed optimization run, an
interpreted leaderboard, and a running RAG pattern in a workbench — with every
step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/feature-store-automl-autorag/autorag/content/`):

1. **Module 01: Get started with AutoRAG** — test data preparation (JSON structure with `question`, `correct_answers`, `correct_answer_document_ids` callouts, `python3 -m json.tool` verification) + optimization run creation through the two-step wizard (OGX connection → knowledge setup, vector database, evaluation dataset, optimization metric table, Maximum RAG patterns, run preset table, model configuration card)
2. **Module 02: Evaluate results and run the RAG pattern** — leaderboard and pattern-details interpretation (metric combinations table, Sample Q&A), Responses API code snippets vs. indexing/inference notebooks, workbench execution with S3 + OGX data connections

Bookends: Overview (TP maturity banner + prerequisites) and Getting Connected
are shared boilerplate; Conclusion links the official documentation.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP` — TP WARNING banner on the Overview page and inline TP NOTEs on both modules
- Technology Preview limits must be surfaced inline: remote-only vector databases (Milvus or pgvector), 3 foundation + 2 embedding model maximum, no OCR, no embedded-image processing, Better-quality-only table structure detection
- The "Optimization runs cannot be edited after creation" IMPORTANT admonition must precede the wizard steps
- Every code block containing `{attributes}` uses `subs="attributes"`
- No fabricated dashboard navigation: all menu paths verbatim from the RHOAI 3.5 docs (`Gen AI studio > AutoRAG`)

## Rationale

The lab has two modules because AutoRAG's workflow splits cleanly along the
run boundary: everything before `Create run` (data prep + configuration) is
irreversible once submitted, and everything after (leaderboard, snippet/notebook
capture, workbench execution) consumes the completed run. TP maturity keeps the
content honest about limitations while still exercising the full workflow, and
per-exercise `=== Verify` sections preserve the per-exercise verification depth.

## Alternatives

- **Single mega-module** — rejected: merges the irreversible run-creation step with result evaluation, losing per-exercise verification and the natural checkpoint between configuring and consuming
- **Three modules (concepts/hands-on/advanced)** — rejected: AutoRAG has no CLI path or advanced configuration surface in TP scope; a third module would be padding
- **Doc-transcription order (metrics first)** — rejected: learners need a concrete run and leaderboard before metric semantics land

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Parameter tables (metric, run preset) use header rows so screen readers announce column context

## Open Questions

- Confirm the `Gen AI studio > AutoRAG` menu label against a live 3.5 console (doc-derived)
- Whether workshop clusters have a pre-registered pgvector or Milvus instance must be confirmed before Act-phase testing
- Optimization run duration for the Faster preset on the workshop cluster is unknown — affects whether module 02 can run immediately after module 01

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33F08DZCEWR
- RHAIBU-M33F08EBF9CZ
- RHAIBU-M33F08EQRBQS

## Related Decisions

- RHAIBU-M33F08F49FKR
- RHAIBU-M33F08FFXZDF
