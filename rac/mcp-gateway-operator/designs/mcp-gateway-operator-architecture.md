---
schema_version: 1
id: RHAIBU-M33DKVHS96MX
type: design
---
# MCP gateway Operator Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. The MCP gateway Operator (TP) is the agents-mcp connectivity
anchor: it connects backend Model Context Protocol (MCP) servers to frontend
agentic AI services behind a single endpoint, and it depends on the MCP
Lifecycle Operator being enabled. The Gateway listener, `MCPGatewayExtension`,
`MCPServerRegistration`, and `MCPVirtualServer` CR patterns taught here are the
foundation for securing agent tool traffic with Connectivity Link policies.

## User Need

Platform engineers and AI application teams with OpenShift and Gateway API
working knowledge need a 60–90 minute guided path from an OLM Operator install
to a serving `/mcp` endpoint with federated, prefix-disambiguated tools and a
curated virtual server — with every step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/mcp-gateway-operator/content/`):

1. **Module 01: Getting Started** — OLM install (Subscription from
   `redhat-operators`, `preview` channel, CSV `Succeeded`), Gateway object with
   `http` + `mcp` listeners (`Accepted`/`Programmed` check), ReferenceGrant +
   `MCPGatewayExtension` CR (`sectionName: mcp`), auto-created HTTPRoute and
   EnvoyFilter verification, and a `curl` `initialize` request that returns the
   `Kuadrant MCP Gateway` serverInfo
2. **Module 02: Hands-on Exercise** — backend server registration via HTTPRoute +
   `MCPServerRegistration` (schema-enforced `prefix`, optional `credentialRef`),
   `oc get mcpsr` status with `READY`/`TOOLS` columns, MCP session with
   `mcp-session-id` extraction, prefixed `tools/list` and `prompts/list`,
   `MCPVirtualServer` curation verified with the `X-Mcp-Virtualserver` header
   against the unfiltered list

Bookends: Overview (TP maturity banner + prerequisites) and Getting Connected
are shared boilerplate; Conclusion links the Connectivity Link securing and
external-server procedures.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP` — Technology Preview NOTE must be flagged inline in each module
- The `preview` OLM channel and `mcp.kuadrant.io/v1alpha1` API group can change between releases
- Red Hat Connectivity Link 1.4.1 or later is required; 1.4.0 is deprecated
- Only one `MCPGatewayExtension` CR per namespace and per Gateway object; cross-namespace references need a ReferenceGrant in the Gateway's namespace
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

TP maturity still drives a full hands-on lab because the docs provide complete,
concrete procedures for install through virtual servers. Module order follows
the learner's dependency chain (install/extend → register/curate): registrations
have nothing to attach to until the Gateway + extension are ready. Registration
and curation live in one module because they form a single verified workflow
over the same `/mcp` endpoint and session.

## Alternatives

- **Three modules (install / register / curate)** — rejected: the register-and-curate split would leave module 3 with a single exercise and no independent verification target
- **Guided-tour only (no commands)** — rejected: the docs give complete working procedures, so a hands-on lab is honest and testable
- **Include AuthPolicy securing in module 02** — rejected: securing is a Connectivity Link concern documented in separate procedures; it is linked in Going further and the Conclusion instead

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Admonition semantics (NOTE/IMPORTANT/WARNING) carry the TP and prefix-immutability warnings in text, not color

## Open Questions

- Confirm the backend MCP server (`mcp-api-key-server`, port 9090) availability in workshop clusters before Act-phase testing
- Confirm listener hostname resolution strategy (`/etc/hosts` vs DNSPolicy/ExternalDNS) for the workshop environment
- The `preview` channel name and `mcp.kuadrant.io/v1alpha1` group may change on the next RHOAI release — revisit on a Mode 3 bump

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33DKVGWS3VG
- RHAIBU-M33DKVH1WS3B
- RHAIBU-M33DKVH79MA8

## Related Decisions

- RHAIBU-M33DKVHDZTDS
- RHAIBU-M33DKVHKC83X
