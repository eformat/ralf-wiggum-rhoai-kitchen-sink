---
schema_version: 1
id: RHAIBU-M33E4KBMZRSR
type: design
---
# OpenShell (Secure Agent Sandboxing and Policy Enforcement) Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. OpenShell (DP) is the agent-security anchor in the agents-mcp
category: the agent sandbox pattern, the five guide areas, and the
OpenShell-managed Sandbox CR observation taught here complement the adjacent
MCP/guardrails and agent-deployments features in the same catalog.

## User Need

Platform engineers and security-minded RHOAI users with OpenShift working
knowledge need a 60–90 minute guided path from environment connectivity through a
guided tour of OpenShell's enforcement model (three surfaces, five guide areas) to
observing OpenShell-managed agents as Sandbox CRs in their own namespace — with
every step verifiable and no fabricated deployment commands.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/openshell-agent-sandboxing/content/`):

1. **Module 01: Getting Started** — guided tour of what OpenShell provides
   (policy-controlled, isolated execution environments restricting system calls,
   network access, and tool availability) + the five guide areas table (Helm
   deployment, mTLS, LLM provider setup, isolated sandboxes, controlled network
   egress) + environment verification (`oc whoami && oc project`)
2. **Module 02: Hands-on Exercise** — how the first three guide areas onboard a
   sandboxed agent (Helm deployment, mTLS workload identity, LLM provider setup),
   how isolated sandboxes and controlled network egress contain agent actions, and
   the observation exercise: the dashboard running agent deployments view
   (Sandbox CRs with name, status, and filtering per namespace) plus
   `oc get pods -n {guid}-{user}`

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the RHOAI 3.5 release notes Developer
Preview section.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP` — Developer Preview warning is mandatory
- OpenShell is documented primarily in release notes and a guide: honest guided-tour labs with no fabricated deployment commands (docs-first-enrichment decision)
- Every code block containing `{attributes}` uses `subs="attributes"`
- The dashboard running-agent-deployments screenshot is a placeholder (`// TODO: capture screenshot`) until the Act phase

## Rationale

DP maturity drives guided-tour depth: concept orientation first, then a single
real observation (Sandbox CRs in the dashboard plus namespace pods). Module order
follows the learner's dependency chain (understand the enforcement model →
observe managed agents), matching the module flow in the related requirements.

## Alternatives

- **Fabricated Helm deployment walkthrough** — rejected: violates the no-fabrication guardrail; the release notes point to the agent-ops GitHub repository for instructions rather than inline steps
- **Single mega-module** — rejected: loses the concepts → observation split and the nav loses module granularity

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the dashboard running agent deployments view location against a live 3.5 console (doc-derived)
- Availability of a facilitator-deployed agent in workshop namespaces must be confirmed before Act-phase testing
- Whether the OpenShell guide's Helm chart values remain stable across 3.5.z releases (upstream artifacts)

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33E4K9NQRNN
- RHAIBU-M33E4KA1ZS6N
- RHAIBU-M33E4KAEVTR9

## Related Decisions

- RHAIBU-M33E4KATYVRC
- RHAIBU-M33E4KB7Z2FV
