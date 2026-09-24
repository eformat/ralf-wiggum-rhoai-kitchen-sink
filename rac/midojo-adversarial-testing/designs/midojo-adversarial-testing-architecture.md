---
schema_version: 1
id: RHAIBU-M33DS66E9NMS
type: design
---
# MiDojo Adversarial Testing Engine Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. MiDojo adversarial testing engine (Developer Preview) is the
agents-and-MCP testing anchor: the tool-layer interception model, declarative
scenario format, and dual utility/security grading taught here are the testing
counterpart to the catalog's agent-serving features (OGX, MCP gateway) and the
tool-layer complement to the garak model-safety workshop in the evaluation
category.

## User Need

Platform engineers and ML practitioners with OpenShift working knowledge need a
60–90 minute guided path from "what is MiDojo" to "I can read a graded run and
know whether an agent stayed useful and resisted attack" — with the DP
maturity honestly reflected: a guided tour of concepts and building blocks, not
a fabricated deployment walkthrough.

## Design

Two modules plus shared bookends, one Antora component
(`features/agents-mcp/midojo-adversarial-testing/content/`):

1. **Module 01: Getting Started** — what MiDojo does (man-in-the-middle
   tool-layer interception, no agent modification, declarative YAML scenarios,
   full tool trace, Kubernetes-native deployment) + scenario anatomy
   (environment state, tasks, injection vectors) + dual utility/security
   grading; connectivity check with `oc whoami && oc project`
2. **Module 02: Hands-on Exercise** — building blocks of a testing session
   (custom external suites, MiniBank reference suite, pluggable backends,
   Kubernetes-native deployment) + the five supported agent protocols (A2A,
   OGX, PI, OpenAI Responses API, Simple HTTP) + reading a graded run via the
   four utility/security outcome combinations; CLI orientation with
   `oc version --client`

Bookends: Overview (DP maturity banner + prerequisites) and Getting Connected
are shared boilerplate; Conclusion links the release-notes reference and the
paired workshops in this catalog.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: DP` (Developer Preview: no SLA, may change between releases)
- DP maturity drives a guided-tour depth: no fabricated deployment commands, CRs, or console navigation beyond the release-notes evidence
- Every code block containing `{attributes}` uses `subs="attributes"`

## Rationale

DP maturity means the feature is documented only in the release notes, so the
module order follows the learner's dependency chain (interception model and
grading → building blocks and reading results) rather than a deploy-first flow.
Each module's orientation commands are verifiable with a stock `oc` CLI, keeping
the lab honest while still giving learners something to run.

## Alternatives

- **Fabricated deployment walkthrough (deploy-first)** — rejected: violates the no-fabrication guardrail; no deployment interface is documented beyond "Kubernetes-native"
- **Single mega-module** — rejected: loses module granularity and the concepts/reading split that matches the two-axis grading story

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise`)
- Scenario ingredients, protocol notes, and outcome combinations are conveyed as tables plus prose, not tables alone

## Open Questions

- Confirm the actual MiDojo deployment interface and CR/API shape when it moves past Developer Preview (doc-derived: release notes only)
- Confirm protocol support (A2A, OGX, PI, OpenAI Responses API, Simple HTTP) against a live MiDojo release before Act-phase testing

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33DS65WF7N2
- RHAIBU-M33DS660A058
- RHAIBU-M33DS663WN2J

## Related Decisions

- RHAIBU-M33DS667X337
- RHAIBU-M33DS66A6WJ4
