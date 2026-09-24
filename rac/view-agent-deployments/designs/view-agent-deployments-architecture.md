---
schema_version: 1
id: RHAIBU-M33EAXPDCFTH
type: design
---
# View Running Agent Deployments Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Viewing running agent deployments (Developer Preview) is the
agents-mcp dashboard anchor: the `agentOps` flag, the Agent Ops view's namespace
scoping, and the OpenShell-managed Sandbox CRs behind the list taught here are
the bridge from the saved-agents and agent-sandboxing features in the same
catalog to day-two agent monitoring.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
short guided path from enabling the `agentOps` dashboard feature flag to reading
the running agent deployments list and tracing its Sandbox CRs with the CLI —
with every step verifiable.

## Design

One module plus shared bookends, one Antora component
(`features/agents-mcp/view-agent-deployments/content/`):

1. **Module 01: View Running Agent Deployments** — flag enablement (`oc get odhdashboardconfig` jsonpath check → merge patch → hard refresh), guided tour of the Agent Ops view under *Gen AI studio → Agent ops* (observe-only: name, status, namespace scoping, filtering), Sandbox CR trace (`oc api-resources | grep -i sandbox` → `oc get sandboxes -A` → match to dashboard entries)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links onward to the saved agents and automated
tool-calling evaluation workshops.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP` — the DP note must state the feature is gated behind the `agentOps` dashboard configuration option
- Patching `OdhDashboardConfig` requires cluster administrator privileges — flagged with an IMPORTANT admonition
- Exercise 2 is observe-only: the Agent Ops view is a guided window onto deployed agents, not an editing tool, so no dashboard edits are scripted
- Sandbox resource discovery uses `oc api-resources | grep -i sandbox` rather than a hard-coded resource name, because the OpenShell API group can differ between installations
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

Developer Preview maturity drives an honest guided-tour lab: two of the three
exercises are real commands (flag patch, Sandbox trace), while the dashboard
tour is explicitly observe-only with no fabricated UI actions. Exercise order
follows the learner's dependency chain (unlock → read → trace), matching the
module-flow in the related requirements.

## Alternatives

- **Multiple modules (concepts / hands-on split)** — rejected: the feature is documented only in release notes; one module with three exercises is the honest depth
- **Fabricate console editing steps** — rejected: the docs evidence only a view with filtering, not management actions; inventing edits would violate the no-fabrication guardrail
- **Hard-code a `sandboxes.<group>` API name** — rejected: OpenShell is itself a Developer Preview using upstream artifacts, so discovery-first is more robust

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the exact *Gen AI studio → Agent ops* menu label and location against a live 3.5 console (doc-derived; the DP note warns it can change between releases)
- Capture the `01-agent-ops-list.png` screenshot in the Act phase (`// TODO: capture screenshot`)
- Confirm at least one Sandbox CR is pre-deployed in workshop namespaces before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33EAXMM95XR
- RHAIBU-M33EAXN220M3

## Related Decisions

- RHAIBU-M33EAXNGFGVH
- RHAIBU-M33EAXNZ9QTR
