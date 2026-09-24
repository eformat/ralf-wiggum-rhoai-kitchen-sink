---
schema_version: 1
id: RHAIBU-M33CV70FNDNW
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

With the catalog open, learners must explore it end to end — browse the
pre-loaded agent starter kits, filter by framework, search by use case, and read
a catalog entry's description, framework, and README. This guided tour is the
core deliverable of the workshop: learners learn what the catalog offers and how
they would evaluate a starter kit, not how to deploy anything.

## Requirements

- [REQ-021] Learner MUST be able to browse the full pre-loaded catalog list and apply the framework filter, confirming it narrows the list to only agents built on the selected framework and that clearing it restores the full list
- [REQ-022] Learner MUST be able to search the catalog with use-case text (for example `code` or `research`) and observe the list narrow to matching agent starter kits
- [REQ-023] Learner MUST be able to open catalog entries and confirm each displays the agent's description and framework and includes a README file with additional information about the agent

## Success Metrics

The framework filter narrows and restores the list; text search narrows the list
to relevant matches; every opened catalog entry shows description, framework,
and a README.

## Risks

- Developer Preview: catalog contents, filter options, and entry layout may change between releases
- An empty catalog list despite the menu item being present indicates the flag is not set or the dashboard was not hard-refreshed

## Assumptions

- Learner has completed Module 01 (`agentsCatalog` flag enabled, catalog visible)

## Related Requirements

- RHAIBU-M33CV6ZMZY9C

## Verified By

- features/agents-mcp/agent-catalog-ai-hub/content/modules/ROOT/pages/module-02-hands-on.adoc
