---
schema_version: 1
id: RHAIBU-M33EB4H56BSG
type: design
---
# Validated Tool-calling Configuration in Model Catalog Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. Validated tool-calling configuration in Model Catalog (TP)
bridges the model catalog and the agentic-evaluation features: the validated
`vllm serve` arguments surfaced here pair with the SDG Hub MCP evaluation
pipeline for ranking candidate models on proprietary tool ecosystems before
deployment.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
60–90 minute guided path from enabling a dashboard feature flag to copying
validated tool-calling arguments and scoring candidate models against their own
MCP servers — with every step verifiable.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/validated-tool-calling-config/content/`):

1. **Module 01: Getting Started** — feature-flag enablement (`oc patch OdhDashboardConfig` with `spec.dashboardConfig.toolCalling: true`, jsonpath verification, dashboard pod check) + catalog walkthrough (*Validated Arguments* section, *Tool Calling* panel, *Validated Arguments* filter)
2. **Module 02: Hands-on Exercise** — four-stage SDG Hub MCP evaluation pipeline (`generate.ipynb` benchmark generation from custom MCP servers) + candidate evaluation (`evaluate.ipynb` with `MODEL_CONFIGS`, LLM-as-judge six dimensions, four programmatic trace metrics, `ZERO_JUDGE`/`ZERO_METRICS` failure indicators)

Bookends: Overview (maturity banner + prerequisites), Getting Connected, and
Conclusion are shared boilerplate. Module 02's Next steps link back to Module 01
arguments for registration and deployment.

## Constraints

- AsciiDoc with `role="execute"` blocks for every learner command; `%password%`-style placeholders only (no secrets); `.env` credentials must stay out of git
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP` — flag name, UI panels, and notebook config dictionaries may change between releases
- Every code block containing `{attributes}` uses `subs="attributes"`
- Screenshot placeholder (`// TODO: capture screenshot`) with alt text on the `image::` macro until the Act phase

## Rationale

TP maturity with a doc-derived, fully tested exercise set: Module 01 keeps the
cluster work small (one flag patch + catalog navigation) while Module 02 carries
the depth, mirroring how the feature itself splits (catalog surface →
evaluation pipeline). Module order follows the learner's dependency chain
(enable flag → see validated arguments → measure accuracy on your tools),
matching the module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: the flag/CRT work and the notebook pipeline have different audiences and verification styles; splitting preserves per-exercise `=== Verify` granularity
- **Lead with the evaluation pipeline (catalog second)** — rejected: learners need the feature enabled and the validated arguments in hand before measuring accuracy, or the rankings have no deployment path

## Accessibility

- Alt text on the `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Trace-metric meanings presented as a table (`tool_recall` … `param_match`) rather than prose-only

## Open Questions

- Confirm the *Validated Arguments* section and *Tool Calling* panel labels against a live 3.5 console (doc-derived; TP may rename)
- MCP server/agent default port ranges (8001–8006, 2024–2029) must be confirmed against the actual `sdg_hub` example at workshop run time

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics (the active tool-invocation WARNING is load-bearing
for module 02 safety).

## Related Requirements

- RHAIBU-M33EB4F3BPFR
- RHAIBU-M33EB4FEBDAE
- RHAIBU-M33EB4FVJT4E

## Related Decisions

- RHAIBU-M33EB4G74DNR
- RHAIBU-M33EB4GQFNSF
