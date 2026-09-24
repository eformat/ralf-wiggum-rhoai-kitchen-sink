---
schema_version: 1
id: RHAIBU-M33DZK9XP67K
type: requirement
---
# Module 01: Remote providers in OGX

## Problem

Before enabling a remote provider, learners need a mental model of what OGX
remote providers are, where `remote::anthropic` and `remote::gemini` sit in the
OGX API provider support table, and how provider enablement flows through
environment variables and the OGX `config.yaml` file. Without this orientation,
later hands-on steps are copy-paste with no understanding of what is being
created.

## Requirements

- [REQ-011] Learner MUST be able to name the two provider flavors (inline and remote) and identify `remote::anthropic` and `remote::gemini` as remote inference providers in the OGX provider support table
- [REQ-012] Learner MUST be able to identify the enablement variable for each provider: `ANTHROPIC_API_KEY` for `remote::anthropic` and `ENABLE_GEMINI` for `remote::gemini`, both Developer Preview for RHOAI 3.5 EA2
- [REQ-013] Learner MUST be able to confirm the OGX operator is installed with `oc get crd ogxservers.ogx.io`
- [REQ-014] Learner MUST be able to list at least one OGXServer in the project with `oc get ogxserver` and confirm the phase prints `Running` (or `Ready`)

## Success Metrics

Learner completes the provider-table walkthrough and both cluster inspection
exercises: the CRD query returns `ogxservers.ogx.io` and the OGXServer phase
prints `Running` (or `Ready`).

## Risks

- OGXServer resources only exist after OGX is enabled; on clusters without it, Exercise 2 must be adapted
- Provider support status shifts between Technology Preview and Developer Preview across releases, so the support table must match the release being run

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33DZK9PM1QM

## Verified By

- features/agents-mcp/ogx-remote-providers/content/modules/ROOT/pages/module-01-getting-started.adoc
