---
schema_version: 1
id: RHAIBU-M33DZQ8MRM2B
type: design
---
# OpenClaw agent starter kit Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. OpenClaw agent starter kit (DP) is the anchor of the
agents-mcp category: it establishes the agent onboarding pattern that other
starter kits on OpenShift AI follow — per the 3.5 release notes, OpenCode is
the first coding agent validated to follow the pattern established by OpenClaw.
The release notes document the kit as a capability list (deployment, model
connection, observability, access control, persistence, validation, security)
rather than as a procedure, which shapes the lab format.

## User Need

Platform engineers and agent operators with OpenShift working knowledge need a
60–90 minute guided path from cluster connection to a working understanding of
how the starter kit deploys OpenClaw, connects it to self-hosted vLLM models
through the OGX gateway, traces agent behavior in MLflow, controls browser
access through the OAuth proxy and OpenShift RBAC, and stays secure under the
restricted-v2 SCC — with every hands-on step verifiable and no fabricated
commands.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/openclaw-starter-kit/content/`):

1. **Module 01: Getting Started** — guided tour of the seven starter kit
   capabilities from the release notes, with a connection check
   (`oc whoami && oc project` in a `role="execute"` block); deployment-options
   comparison table (validated Kustomize manifests vs automated OpenClaw
   installer); OGX/vLLM OpenAI-compatible model connection walkthrough
2. **Module 02: Hands-on Exercise** — three exercises: (a) observability
   through MLflow and OpenTelemetry tracing via the diagnostics-otel plugin
   (model calls, tool executions, context assembly spans) with a hypothetical
   debugging walkthrough; (b) access control flow — route → OAuth proxy →
   OpenShift RBAC delegation; (c) persistence, restricted-v2 SCC security
   posture, and environment validation, with an `oc get pods -n {guid}-{user}`
   observation of the deployed agent pod

Bookends: Overview (DP maturity banner via `ifeval` + prerequisites) and
Getting Connected (`oc login`, `oc new-project {guid}-{user}`, console/RHOAI
dashboard access) are shared boilerplate; Conclusion links the source docs.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP` — Developer Preview warning, not TP
- DP feature documented only in the release notes: no invented CLI commands or manifests — the lab is a guided tour plus observation commands, not a deployment walkthrough
- Every code block containing `{attributes}` uses `subs="attributes"`
- The `oc get pods` output is explicitly framed as an observation (exact pod names depend on the deployment option chosen)

## Rationale

DP maturity and release-notes-only evidence drive a guided-tour depth: two
modules with conceptual exercises and only the two commands the docs support
(connection check, pod observation). Module order follows the learner's
dependency chain (what the kit provides → how it operates), matching the
module-flow in the related requirements. This mirrors the pilot's
inspect-then-operate ordering while honestly omitting deployment commands the
docs do not provide.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **Fabricated deployment walkthrough (apply Kustomize manifests step-by-step)** — rejected: the release notes do not document the manifest contents or install commands; inventing them violates the no-fabrication guardrail
- **Discussion-only lab with no commands** — rejected: the two documented observation commands give learners real cluster contact without fabrication

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)
- Deployment-option comparison rendered as a headered AsciiDoc table rather than an image

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics (WARNING reserved for the DP banner and the
do-not-bypass-OAuth-proxy instruction).

## Open Questions

- Exact pod names and supporting components produced by each deployment option (Kustomize manifests vs automated installer) must be confirmed in the Act phase
- Whether the automated OpenClaw installer command surface is documented in the OpenClaw Agentic Starter Kit docs — if so, a hands-on deployment module can be added when the feature reaches GA

## Related Requirements

- RHAIBU-M33DZQ7G95Q9
- RHAIBU-M33DZQ7QYQ7W
- RHAIBU-M33DZQ7Y1W5P

## Related Decisions

- RHAIBU-M33DZQ85954V
- RHAIBU-M33DZQ8BRHS9
