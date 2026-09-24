---
schema_version: 1
type: asset
---
# Screenshot Evidence: OpenShell agent sandboxing (openshell-agent-sandboxing)

## Capture Summary

- **Date:** 2026-09-24
- **Cluster:** cluster-44gxc.dyn.redhatworkshops.io (RHOAI 3.5.1)
- **Captured:** 1/1 shots
- **Failed:** 0

## Evidence Map

| Screenshot | Page | Requirement | Criterion | Status |
|------------|------|-------------|-----------|--------|
| 02-agent-deployments-dashboard.png | module-02-hands-on.adoc | (module-02 visual criteria) — agent deployments dashboard (AI hub > Agents) reflecting OpenShell-managed Sandbox CRs | captured (empty state — no agent sandboxes in project abc123-user1) |

## Uncovered Criteria

- Populated dashboard reflecting OpenShell-managed Sandbox CRs — requires sandbox CRs applied to the project (exercise execution).
