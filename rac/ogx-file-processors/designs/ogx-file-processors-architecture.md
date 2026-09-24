---
schema_version: 1
id: RHAIBU-M33DZJ9E2Q5V
type: design
---
# OGX File Processors API Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. The OGX File Processors API (DP) is the document-ingestion
anchor of the agents-mcp category: the provider enablement model and the
document-to-chunks path taught here are prerequisites for RAG-app building on
OGX in the same catalog.

## User Need

Platform engineers and ML practitioners with OpenShift and RAG working
knowledge need a 60–90 minute guided path from API-surface inspection to a
stored, chunked, indexed document and a retrieval-grounded answer — with every
step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/ogx-file-processors/content/`):

1. **Module 01: Tour the File Processors API** — API surface tour (endpoint `/v1alpha/file-processors`, Developer Preview status, five-provider table with enablement model) + OGX environment verification (`ogx.managementState`, `oc get crd ogxservers.ogx.io`, `oc get ogxserver -n {guid}-{user}`)
2. **Module 02: Walk the document-processing path** — three-stage flow trace (upload → extraction → indexing) with `oc get svc` port `8321` identification; upload-and-index via `ogx_client` (Files API `client.files.create`, Vector Stores `client.vector_stores.files.create` with `chunking_strategy`, polling to `completed`); Docling pipeline run with parameter table and `file_search`-backed query verification

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the source documentation chapters.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP`
- The 3.5 docs publish no direct request example for the `/v1alpha/file-processors` endpoint — the lab tours the documented Files + Vector Stores and Docling pipeline workflows and must not invent alpha-endpoint payloads
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

DP maturity with docs-only evidence drives a guided-tour-plus-workflow depth:
the API surface is taught honestly from the documented table, and hands-on
verification comes from the documented client workflows the API backs. Module
order follows the learner's dependency chain (inspect → trace → drive),
matching the module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Fabricate alpha-endpoint request examples** — rejected: violates the no-fabrication guardrail; the docs publish none
- **Doc-transcription order (pipeline first)** — rejected: learners need the API surface and OGX environment verified before driving client workflows

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the extraction-backends table (five providers, enablement model) against a live 3.5 console (doc-derived)
- Docling pipeline sample availability in workshop clusters must be confirmed before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33DZJ8RFSS3
- RHAIBU-M33DZJ8XH5JA
- RHAIBU-M33DZJ913MYJ

## Related Decisions

- RHAIBU-M33DZJ96YYJ4
- RHAIBU-M33DZJ9ANMZK
