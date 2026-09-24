---
schema_version: 1
id: RHAIBU-M33DZKAXTCBW
type: design
---
# OGX remote::anthropic and remote::gemini Providers Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. The OGX remote::anthropic and remote::gemini providers (DP)
is the remote-inference feature in the agents-mcp category: the provider
support table, enablement variables, and Secrets-backed credential flow taught
here are prerequisites for other OGX provider features in the same catalog.
Both providers are documented in the 3.5 EA2 release notes (Developer Preview
features section).

## User Need

Developers and platform engineers with OpenShift working knowledge need a
45–90 minute guided path from cluster inspection to a verified
remote-provider inference request through the OpenAI-compatible surface —
with every step verifiable and every credential flowing through Secrets, never
the OGXServer CR spec.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/ogx-remote-providers/content/`):

1. **Module 01: Remote providers in OGX** — provider-concepts walkthrough (inline vs remote providers, provider support table with enablement variables) + cluster inspection (`oc get crd ogxservers.ogx.io`, `oc get ogxserver`, phase via `jsonpath`) + guided walkthrough of the three enablement paths (CRD fields, environment variables, `spec.overrideConfig`) and the operator's secret collection mechanism (`ogx.io/watch: "true"`, `OGX_<PROVIDER_ID>_<FIELD>` injection)
2. **Module 02: Enable and explore remote Anthropic and Gemini** — Secret creation (`anthropic-creds`, Opaque type, `ogx.io/watch` label) with YAML callouts, guided tour of both enablement paths with a custom `config.yaml` example patterned on the documented Bedrock provider, then OpenAI-compatible verification (`/v1/models`, `/v1/chat/completions`)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the provider support table and related
OGX documentation.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets — API keys appear as `<base64-encoded-key>`)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP` on both module pages
- Developer Preview status must be flagged inline: DP features are not supported by Red Hat and are not functionally complete
- Every code block containing `{attributes}` uses `subs="attributes"`
- The custom `config.yaml` example is patterned on the documented Bedrock provider — release notes only document the enablement variables, so the example must carry an explicit NOTE to verify field names against the provider support table

## Rationale

DP maturity drives an honest depth profile: full hands-on exercises where the
docs evidence real commands (Secret creation, `oc get`, OpenAI-compatible
curl) and guided walkthroughs where only enablement variables are documented.
Module order follows the learner's dependency chain (understand → verify
platform → store credential → enable → call), matching the module-flow in the
related requirements. Egress observability (OGX pods only egress to
`api.anthropic.com` or Google endpoints once a provider is configured) is
taught as the feature's observable side effect.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Enable `remote::gemini` end to end alongside `remote::anthropic`** — rejected: both are DP, but only the Anthropic path has a full documented example shape; the Gemini flag is taught conceptually via `ENABLE_GEMINI`
- **Fabricate a full provider schema from upstream docs** — rejected: violates the no-fabrication guardrail; the release notes only document the enablement variables

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the full provider schema (provider ID and config field names for `remote::anthropic` and `remote::gemini`) against the upstream OGX `config.yaml` documentation for the release being run — the 3.5 EA2 release notes only document the enablement variables
- Confirm `remote::gemini` enablement end to end on a live cluster (taught conceptually here; the workshop exercises the Anthropic path)
- Real UI screenshots deferred to the Act phase when a cluster is available

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33DZK9PM1QM
- RHAIBU-M33DZK9XP67K
- RHAIBU-M33DZKA50BE1

## Related Decisions

- RHAIBU-M33DZKABT4T4
- RHAIBU-M33DZKAMBC37
