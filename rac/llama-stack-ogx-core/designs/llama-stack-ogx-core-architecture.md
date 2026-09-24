---
schema_version: 1
id: RHAIBU-M33FZEN3QKX1
type: design
---
# OGX (Llama Stack) Core Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. OGX (Llama Stack) core (GA) is the catalog's RAG-and-agentic
anchor feature: the OGXServer CR, provider wiring, and `file_search` RAG loop
taught here underpin the OGX guardrails and evaluation features in the same
catalog. OGX replaced Llama Stack in 3.5 with breaking API changes, so the
naming model is a first-class learning objective.

## User Need

Data scientists and AI engineers with OpenShift working knowledge and basic
Python need a 60–90 minute guided path from cluster inspection to a running,
RAG-enabled OGX server — with every step verifiable, from operator activation
through search-mode tuning, high availability, and S3 file offload.

## Design

Three modules plus shared bookends, one Antora component
(`features/ogx/llama-stack-ogx-core/content/`):

1. **Module 01: Core Concepts** — Llama Stack → OGX renaming table
   (`llamastack.io` → `ogx.io`, `OGXServer`, `ogxservers`) + cluster inspection
   (`oc get crd ogxservers.ogx.io`, operator pod check, `oc get ogxserver -A`)
2. **Module 02: Deploy an OGX Server and RAG** — operator activation via DSC
   patch (`spec.components.ogx.managementState: Managed`), OGXServer deployment
   with `rh-dev` distribution + callout YAML (vLLM URL, PostgreSQL from
   secrets), pgvector enablement, notebook RAG loop with `ogx_client`
   (`files.create` → `vector_stores.files.create` with static chunking →
   `responses.create` with `file_search`), vLLM endpoint curl test
3. **Module 03: Advanced Usage** — keyword/vector/hybrid `vector_io.query()`
   search modes; HA + autoscaling on the OGXServer CR (`podDisruptionBudget`,
   `topologySpreadConstraints`, HPA targets); `remote::s3` Files API offload
   verified via `/v1/providers` and `/v1/files` upload

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the two source books.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: GA`
- Credentials (`POSTGRES_PASSWORD`, `PGVECTOR_PASSWORD`, AWS keys) must come from secrets, never plaintext in the CR or command line
- Every code block containing `{attributes}` uses `subs="attributes"`
- OGX integration is Technology Preview in 3.5 docs — flagged inline where relevant

## Rationale

GA maturity drives full hands-on depth with per-exercise `=== Verify` sections.
Module order follows the learner's dependency chain (understand the rename →
activate and deploy → tune and scale), matching the module-flow in the related
requirements. The RAG loop is deliberately built from the notebook (`ogx_client`)
side first, because the Responses API with `file_search` is the GA entry point.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Milvus-first vector store example** — rejected: pgvector with PostgreSQL matches the lab's pre-provisioned metadata backend and keeps one database for both persistence and vector storage
- **Docs-transcription order (API support table first)** — rejected: learners need the renaming model and cluster context before API surface details

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `Ecosystem → Installed Operators` vs `Operators → Installed Operators` menu label across OpenShift 4.19/4.20 consoles (doc-derived, both variants used)
- Whether workshop clusters pre-provision the external S3-compatible bucket or learners must create it (`S3_AUTO_CREATE_BUCKET` tradeoff) before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33FZEKGR1M7
- RHAIBU-M33FZEKTM39K
- RHAIBU-M33FZEM21PYV
- RHAIBU-M33FZEMBGM12

## Related Decisions

- RHAIBU-M33FZEMKBDJB
- RHAIBU-M33FZEMW6GT6
