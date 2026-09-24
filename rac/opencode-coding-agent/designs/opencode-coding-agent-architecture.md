---
schema_version: 1
id: RHAIBU-M33E4B24784Z
type: design
---
# OpenCode Coding-Agent Deployment Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. OpenCode coding-agent deployment (TP) is the agents anchor
feature: it is the first coding agent validated to follow the onboarding
pattern established by OpenClaw, confirming that agent platform operators, vLLM
and OGX (formerly Llama Stack) inference backends, and MLflow tracing
integration generalize to coding-specific workloads. The validation pattern and
the OpenAI-compatible connection model taught here are prerequisites for the
other agents-mcp features in the same catalog.

## User Need

Platform engineers and AI practitioners with OpenShift working knowledge need a
60–90 minute guided path from feature orientation and environment readiness to
a probed OpenAI-compatible endpoint and a tour of the console surfaces that
back a coding agent — with every step verifiable and nothing invented beyond
the release-notes evidence.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/opencode-coding-agent/content/`):

1. **Module 01: Getting Started** — feature walkthrough (three building blocks
   + four validation deliverables, TP-flagged) + environment readiness
   (`oc get csv -n redhat-ods-operator` for the `rhods-operator` CSV,
   `oc project` for the working project)
2. **Module 02: Hands-on Exercise** — OpenAI-compatible probe
   (`GET /models` with the endpoint/key/model connection model, `NO_API_KEY`
   for unauthenticated local vLLM), workbench IDE terminal exercise
   (`git --version && python --version`), dashboard surfaces (*AI hub* →
   *Models* → *External models*) and MLflow tracing observability

Bookends: Overview (maturity banner + prerequisites), Getting Connected, and
Conclusion (linking the three source books) are shared boilerplate.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP`
- OpenCode is Technology Preview and documented only at the release-notes level — no fabricated deployment commands; guided-tour + environment-verification exercises only
- The `GET /models` probe block uses callouts, so it carries `subs="attributes,callouts"`
- The *External models* tab requires `spec.dashboardConfig.externalModels: true` in `OdhDashboardConfig` — must be flagged as a platform-administrator task

## Rationale

TP maturity at release-notes-only documentation depth drives an
orientation-plus-verification depth: learners trace the validation pattern and
verify real cluster surfaces without fabricated deployment steps. Module order
follows the learner's dependency chain (understand the validation → verify
readiness → probe the endpoint → tour the surfaces), matching the module flow
in the related requirements.

## Alternatives

- **Single mega-module** — rejected: loses the orientation/readiness split and the nav loses module granularity
- **Fabricated deployment lab from starter-kit knowledge** — rejected: violates the no-fabrication guardrail; OpenCode has no step-by-step deployment procedure in the 3.5 docs

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the *AI hub* → *Models* → *External models* navigation label against a live 3.5 console (doc-derived)
- Starter-kit documentation for OpenCode deployment is expected to follow; on publication the lab should gain real deployment exercises (Act phase)

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33E4B10VYFE
- RHAIBU-M33E4B17PQW3
- RHAIBU-M33E4B1E72FC

## Related Decisions

- RHAIBU-M33E4B1P8X5E
- RHAIBU-M33E4B1X3MDR
