---
schema_version: 1
id: RHAIBU-M33DKEP8W03X
type: design
---
# MCP Catalog Support-Tier Labeling Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. MCP Catalog support-tier labeling (Technology Preview) is the
agents-mcp anchor for trusting catalog content: the `mcplifecycleoperator`
component, `mcpCatalog` dashboard flag, and `MCPServer` custom resource workflow
taught here are prerequisites for the MCP Lifecycle Operator and MCP Gateway
Operator features in the same catalog.

## User Need

Cluster administrators and developers with OpenShift working knowledge need a
45–60 minute guided path from enabling the MCP Lifecycle Operator to browsing
the AI Hub MCP Catalog, deploying a tier-labeled server into their namespace,
and verifying the resulting `MCPServer` workload — with every step verifiable.

## Design

One module plus shared bookends, one Antora component
(`features/agents-mcp/mcp-catalog-support-tier/content/`):

1. **Module 01: MCP Catalog support tiers in action** —
   - Before-you-start: the pieces behind the catalog (federated dashboard plugin, `model-metadata-collection` data container, support-tier table, `mcplifecycleoperator` defaults to `Removed`)
   - Exercise 1: enable MCP server lifecycle management (`oc patch datasciencecluster` → `mcplifecycleoperator: Managed`, `oc patch odhdashboardconfig` → `mcpCatalog: true`; verify pod `Running` + `installedComponents` `true`)
   - Exercise 2: read the support tiers and deploy a server from the catalog (*AI hub* → *MCP servers*, tier table, filter by deployment mode/transport, `serviceAccountName` under `runtime:`/`security:`, verify `READY: True` + *Deployments* tab)
   - Exercise 3: monitor server health and remove the server (`oc describe mcpserver` → `type: Ready`, `oc delete mcpserver`, verify `No resources found`)

Bookends: Overview (TP maturity banner + prerequisites) and Getting Connected
are shared boilerplate; Conclusion links the *Working with the MCP catalog*
chapter in the RHOAI 3.5 docs.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP`
- The `MCPServer` CRD API is `v1alpha1` with no backwards-compatibility commitment — the TP WARNING must state commands and manifests may change between releases
- The `mcplifecycleoperator` component defaults to `Removed` in RHOAI 3.5 — the enablement prerequisite must be stated before any deploy step
- The MCP Gateway Operator is a separate Technology Preview installation (Red Hat Connectivity Link) and must be presented as optional, not required
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

Technology Preview maturity drives a focused single-module lab: the feature's
entire user-facing surface (enable → browse → deploy → verify → clean up) fits
one session, so splitting into multiple modules would add navigation overhead
without adding content. Module order follows the learner's dependency chain
(enable is a hard prerequisite for the deploy button), matching the module-flow
in the related requirements.

## Alternatives

- **Two modules (admin enablement vs developer deploy)** — rejected: the lab is 45 minutes end-to-end; splitting forces learners to context-switch between modules for a single dependency chain
- **Include MCP Gateway Operator setup** — rejected: it is an independent Technology Preview install outside the RHOAI operator lifecycle and is out of scope for support-tier labeling

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Support-tier distinctions conveyed by text labels, not color alone

## Open Questions

- Confirm the *AI hub* → *MCP servers* menu labels and the *Deployments* tab against a live 3.5 console (doc-derived)
- Confirm which MCP servers in a real catalog deployment require a service account, to pick the smoothest *Red Hat*-tier example for Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33DKEN8Z3S1
- RHAIBU-M33DKENF7Y3M

## Related Decisions

- RHAIBU-M33DKENQP694
- RHAIBU-M33DKEP1KDNS
