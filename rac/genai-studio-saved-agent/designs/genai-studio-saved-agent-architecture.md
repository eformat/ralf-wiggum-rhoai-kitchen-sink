---
schema_version: 1
id: RHAIBU-M33D7MRCHKPS
type: design
---
# Gen AI Studio Saved Agents Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Gen AI Studio saved agents (DP) is the configuration-
persistence feature of the gen AI playground: the `agentConfigManagement`
dashboard flag, the save/load/manage workflow, and the Agents tab taught here
are prerequisites for the agent-deployment monitoring and automated tool-calling
evaluation features in the same catalog.

## User Need

ML practitioners with playground working knowledge need a 30–60 minute guided
path from observing the dashboard configuration flags to saving, loading, and
managing named agents — with every step verifiable despite the feature being
Developer Preview.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/genai-studio-saved-agent/content/`):

1. **Module 01: Getting Started** — what a saved agent captures (and what it
   does not) + flag inspection (`agentConfigManagement`, `genAiStudio` jsonpath
   reads), flag enablement via `oc patch` with verified output, and the
   saved-agent UI walkthrough (playground header menu + Agents tab)
2. **Module 02: Hands-on Exercise** — save a configured playground as a named
   agent (Save agent dialog with summary), load from the header menu or the
   Agents tab (Try in Playground) with restored-settings verification, then
   manage agents: Save as new agent variants, rename/edit, delete, and Clear
   agent

Bookends: Overview (DP maturity banner + prerequisites) and Getting Connected
are shared boilerplate; Conclusion links the agent-deployment and evaluation
workshops.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP`
- Developer Preview status must be flagged inline in every module
- The flag patch requires cluster administrator privileges — called out with an IMPORTANT admonition
- The saved-agent Kubernetes resource kind is not named in the docs — CLI discovery steps are labeled as discovery, not documented interfaces
- Dialog labels are doc-derived and may change between releases

## Rationale

DP maturity drives a guided-tour-into-hands-on shape: the only cluster mutation
is the reversible flag patch, and the rest is UI workflow verification. Module
order follows the learner's dependency chain (enable → save/load → manage),
matching the module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: flag enablement and agent lifecycle lose separation, and the nav loses module granularity
- **Fabricate the agent CR kind for a deeper CLI section** — rejected: the docs do not name the resource kind; inventing it would violate the no-fabrication guardrail

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Keyboard-only paths (hard refresh Ctrl+Shift+R / Cmd+Shift+R) documented for both platforms

## Open Questions

- Confirm the exact `Gen AI studio → AI asset endpoints` menu label against a live 3.5 console (doc-derived)
- The saved-agent Kubernetes resource kind and API group must be confirmed in a live cluster before Act-phase CLI testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33D7MQ4CZCB
- RHAIBU-M33D7MQCQJYN
- RHAIBU-M33D7MQK3J4Q

## Related Decisions

- RHAIBU-M33D7MQWDZ3H
- RHAIBU-M33D7MR456VK
