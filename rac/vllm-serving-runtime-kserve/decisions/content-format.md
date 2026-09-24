---
schema_version: 1
id: RHAIBU-M33FYP431FHD
type: decision
---
# Content Format: Monorepo Antora Component

## Status

Accepted

## Category

Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships one workshop per active RHOAI 3.5
feature — 54 workshops. The zt-rhaibu exemplar pattern is one Antora showroom
repo per workshop. Duplicating the full Antora build toolchain across 54
repositories would multiply build maintenance and drift.

## Decision

Each feature workshop is a single Antora component
(`features/<category>/<slug>/content/`) inside the ralf-wiggum-rhoai-kitchen-sink
monorepo. A master `site-35.yml` registers all components as content sources of
one local content source with distinct `start_path` values. Shared UI assets live
once under `shared/`.

## Consequences

- One build (`make build`) produces the whole catalog; no cross-repo build coordination
- Component versioning is two-tier: feature `antora.yml` defaults + site-level overrides for a new release (`site-36.yml`)
- The repo is the unit of change; per-workshop git isolation is traded away
- `decided validate` tooling runs per-corpus inside this monorepo rather than per-repo

## Alternatives Considered

- **One Antora repo per workshop (zt-rhaibu exemplar)** — rejected: 54 repos to build, upgrade, and keep in sync for a catalog that is consumed as a single unit
- **One giant component with 54 modules** — rejected: loses per-feature maturity badges, nav isolation, and per-component xref addressing

## Related Requirements

- RHAIBU-M33FYP394X0S
