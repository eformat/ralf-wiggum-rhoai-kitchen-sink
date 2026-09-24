---
schema_version: 1
id: RHAIBU-M33FSHJ84P3N
type: requirement
---
# Module 01: Explore vLLM runtime support levels

## Problem

Before adopting a fast-release image, learners need a mental model of where it
fits into the three vLLM runtime support levels — supported (GA), limited
support (fast builds), unsupported (custom) — and how the dashboard badges and
support-status gating annotations identify each level. Without this orientation,
later hands-on steps are copy-paste with no understanding of what the
annotations are gating.

## Requirements

- [REQ-011] Learner MUST be able to identify at least one runtime in each support level on the *Serving runtimes* page and decode the badge combinations, including the `fast-N` monthly fast-build badge
- [REQ-012] Learner MUST be able to list serving runtimes across the cluster with `oc get servingruntimes -A` and compare container image registries (`registry.redhat.io/rhaii` vs `registry.redhat.io/rhaii-early-access`)
- [REQ-013] Learner MUST be able to inspect gating annotations with `oc get template <runtime-name> -o yaml | grep unsupported-status-accepted` and observe `opendatahub.io/unsupported-status-accepted: "true"` on an accepted limited-support runtime and no output for a GA runtime

## Success Metrics

Learner completes both exercises: the dashboard badge tour and the CLI runtime
inspection, each producing the documented expected output.

## Risks

- Limited-support runtimes only appear in the badge tour if the administrator has enabled them; on clusters without fast builds, exercise 1 must be adapted
- The `fast-N` badge requires a Red Hat-built fast build to be present in the cluster

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33FSHHXT2SE

## Verified By

- features/model-serving/rhai-fast-release-images/content/modules/ROOT/pages/module-01-getting-started.adoc
