---
schema_version: 1
id: RHAIBU-M33DSKK6SJYQ
type: design
---
# OGX-native Agentic API Surface Workshop Architecture

## Context

The ralf-wiggum kitchen-sink catalog ships a hands-on workshop for every active
RHOAI 3.5 feature. The OGX-native agentic API surface (Technology Preview) is
the agents/mcp anchor for OpenAI-compatible and native OGX APIs: the two-layer
API map, OGXServer CR, and client connection rules taught here are
prerequisites for the RAG-with-OGX and guardrails features in the same catalog.

## User Need

AI engineers and data scientists with OpenShift and Python working knowledge
need a roughly 2-hour guided path from cluster inspection to a running
OGXServer, through a stateful multi-turn conversation, and onwards to grounded
RAG answers with citations and guardrails — with every step verifiable.

## Design

Three modules plus shared bookends, one Antora component
(`features/agents-mcp/ogx-agentic-api/content/`):

1. **Module 01: OGX agentic API concepts** — architecture walkthrough (native
   OGX vs OpenAI-compatible API-layers table) + cluster inspection
   (`CustomResourceDefinitions` search for `ogxservers`,
   `spec.components.ogx.managementState`, `oc get crd ogxservers.ogx.io`,
   empty `oc get ogxserver` list)
2. **Module 02: Responses and Conversations hands-on** — OGXServer deployment
   via `ogx.io/v1beta1` manifest (`rh-dev` distribution, inline Ollama model)
   with YAML callouts, OpenAI SDK client connection (`base_url` with `/v1`
   suffix), Chat Completions sanity check, Conversations API multi-turn chat
   (`conversation` parameter, `store=True`, items list, delete)
3. **Module 03: RAG, citations, and advanced APIs** — RAG workflow (Files API
   upload → Vector Stores create → static chunking → poll to `completed` →
   `file_search` tool query), `file_citation` annotations inspection,
   guardrails opt-in via `guardrails: true` with fail-closed behavior, Tool
   Runtime API survey (native OGX, Developer Preview)

Bookends: Overview (maturity banner + prerequisites) and Getting Connected are
shared boilerplate; Conclusion links the two source books.

## Constraints

- AsciiDoc with `role="execute"` blocks + `subs="attributes"` for every learner command; `%password%`-style placeholders only (no secrets)
- `version: ~` in `antora.yml` (RHDP theme pagination requirement)
- Maturity banner via `ifeval` on `feature_maturity: TP` — Technology Preview note in every module
- Support levels differ within the API surface: Responses API GA in the 3.5 docs, Conversations API TP, Tool Runtime and Vector_IO DP — must be labeled per endpoint
- Every code block containing `{attributes}` uses `subs="attributes"`
- The RHOAI 3.5 docs include no worked Tool Runtime client example — that exercise stays a survey, no fabricated commands

## Rationale

Technology Preview maturity still supports full hands-on depth because the
feature is enriched (enriched: true) and all commands are doc-verbatim. Module
order follows the learner's dependency chain (inspect → deploy → ground),
matching the module-flow in the related requirements.

## Alternatives

- **Single mega-module** — rejected: exercises lose per-exercise verification and the nav loses module granularity
- **API-reference order (native APIs first)** — rejected: the native layer is mostly DP and deprecated (Inference API), while the agentic surface lives on the OpenAI-compatible side; learners need the working deployment first

## Accessibility

- Alt text on every `image::` macro; width constrained to 700px
- Execute-role blocks are copy-paste friendly for screen-reader users
- Headings strictly hierarchical (`= Module` → `== Exercise` → `=== Verify`)

## Open Questions

- Confirm the `CustomResourceDefinitions → ogxservers` search flow against a live 3.5 console (doc-derived)
- Remote Milvus vector store availability in workshop clusters must be confirmed before Act-phase testing of the RAG exercise
- Exact moderation-endpoint setup (`moderation_endpoint` on the responses provider) needed for a positive guardrails test in workshop clusters

## Style Guidance

Follow the zt-rhaibu WORKSHOP-COMMON-RULES v1.2: module summary with three
bold-label sections, bridging sentences between exercises, TIP/NOTE/IMPORTANT/
WARNING admonition semantics.

## Related Requirements

- RHAIBU-M33DSKJ262BA
- RHAIBU-M33DSKJ7R2YW
- RHAIBU-M33DSKJC1RWP
- RHAIBU-M33DSKJGR1E2

## Related Decisions

- RHAIBU-M33DSKJPBSJV
- RHAIBU-M33DSKJZ56VT
