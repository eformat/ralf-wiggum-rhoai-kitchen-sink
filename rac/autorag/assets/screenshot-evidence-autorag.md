---
schema_version: 1
type: asset
---
# Screenshot Evidence: AutoRAG (feature-store-automl-autorag)

## Capture Summary

- **Date:** 2026-09-24
- **Cluster:** cluster-44gxc.dyn.redhatworkshops.io (RHOAI 3.5.1)
- **Captured:** 1/2 shots
- **Failed:** 1 shot (02-autorag-leaderboard.png — requires completed AutoRAG optimization runs; prior file on disk was an error-page capture and was removed, TODO marker kept)

## Evidence Map

| Screenshot | Page | Requirement | Criterion | Status |
|------------|------|-------------|-----------|--------|
| 01-autorag-page.png | module-01-getting-started.adoc | RHAIBU-M33F08EBF9CZ | REQ-013/REQ-014 — AutoRAG page in Gen AI studio (empty state; run listing requires executed optimization runs) | captured (empty state) |

## Uncovered Criteria

- REQ-013/REQ-014 run-creation and run-listing states — not screenshottable without a configured pipeline server and executed runs (needs cluster work)
- 02-autorag-leaderboard.png — leaderboard requires completed runs; removed junk error-page capture, TODO kept
