---
schema_version: 1
id: RHAIBU-M33DE6RB6AAK
type: decision
---
# Enrichment Source: Product Docs First

## Status

Accepted

## Category

Process

## Context

The zt-rhaibu OODA pipeline starts with workshop-observe (screenshots from a live
demo cluster). No live RHOAI cluster or demo screenshots were available when the
54-feature catalog was built, but the complete RHOAI 3.5 product documentation
set was (local PDFs in `~/Downloads/RHOAI3.5/`).

## Decision

Feature labs were enriched from the official RHOAI 3.5 product docs (pdftotext
extractions greped per feature) instead of live-cluster observations. Doc-derived
observations documents in each RAC corpus's `assets/` record what the docs
evidence. Real UI screenshots and workshop-observe parity are deferred to the
Act phase, when a cluster is available.

## Consequences

- All commands, CRs, and console navigation are verbatim from official docs — no invented content
- Console screenshots are placeholders (`// TODO: capture screenshot`) until the Act phase
- Features documented only in release notes (several 3.5 DP features) get honest guided-tour labs with no fabricated commands
- Observation documents describe doc evidence, not UI evidence — explicitly labeled as such

## Alternatives Considered

- **Block on cluster availability** — rejected: stalls the entire catalog for infrastructure that may never be provisioned in this environment
- **Invent plausible commands without a source** — rejected: violates the no-fabrication guardrail and would produce untestable labs

## Related Requirements

- RHAIBU-M33DE6QRF0A2
