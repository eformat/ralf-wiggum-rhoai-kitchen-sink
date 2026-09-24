---
schema_version: 1
id: RHAIBU-M33D1QPAYPCZ
type: design
---
# Claude Code Agent Starter Kit Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. The Claude Code agent starter kit (Developer Preview) is an
agents-mcp feature: it deploys and configures the Anthropic Claude Code agent on
OpenShift AI from a pre-configured Containerfile and Kustomize manifests, and its
deploy-time ConfigMap pattern is the foundation for the MCP gateway and other
agentic features in the same catalog.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
60–90 minute guided path from environment connection through the kit's
capabilities, deploy-time configuration, MLflow tracing, and security posture —
with every runnable step verifiable and no fabricated commands.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/claude-code-starter-kit/content/`):

1. **Module 01: Getting Started** — guided tour of the six starter-kit
   capabilities (deployment, validated inference paths, MLflow tracing,
   ConfigMap-based skill/MCP injection, persistence, restricted-v2 security) +
   inference-path comparison (direct Anthropic API, self-hosted vLLM, vLLM
   through the OGX gateway) + connectivity check (`oc whoami && oc project`)
2. **Module 02: Hands-on Exercise** — guided tour of deploy-time configuration
   and workspace persistence (ConfigMap carries skills and MCP settings), built-in
   MLflow tracing exploration (tool calls, token usage, agent execution traces,
   hypothetical debugging scenario), security posture under restricted-v2, and
   optional agent-pod observation (`oc get pods -n {guid}-{user}`)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the source documentation.

Because the feature is Developer Preview and documented only in the release
notes, both modules are guided tours of documented capabilities rather than
deployment walkthroughs — no invented commands.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP`
- Developer Preview means no fabricated deployment commands — commands limited to what the docs evidence (`oc whoami`, `oc project`, `oc get pods`)
- Every code block containing `{attributes}` uses `subs="attributes"`
- No manifest modification to grant additional security contexts — the restricted-v2 posture is what the kit is validated against

## Rationale

DP maturity drives a guided-tour depth with honest, doc-evidenced content rather
than fabricated deployment exercises. Module order follows the learner's
dependency chain (orient on the kit → see it in operation), matching the
module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: the capability tour and the operational tour cover distinct concerns and the nav loses module granularity
- **Fabricated deployment walkthrough** — rejected: release-notes-only DP evidence cannot support real deploy commands without violating the no-fabrication guardrail

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Exact Kustomize manifest contents and inference-path selection mechanism are not detailed in the release notes — confirm against the Claude Code Agentic Starter Kit upstream docs
- MLflow tracing destination (server endpoint) for a deployed kit is not specified in the release notes
- Whether the OGX-gateway path requires the model-serving platform enabled must be confirmed before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33D1QN2BXKW
- RHAIBU-M33D1QNAV38F
- RHAIBU-M33D1QNHKDTA

## Related Decisions

- RHAIBU-M33D1QNS8TAD
- RHAIBU-M33D1QNZ62QC
