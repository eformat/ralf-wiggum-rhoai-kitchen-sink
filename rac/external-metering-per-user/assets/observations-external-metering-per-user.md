# Observations: External metering per-user token usage and cost (doc-derived)

## Summary

External metering for per-user token usage and cost tracking is a RHOAI 3.5
Developer Preview feature: an external metering IPP plugin and a standalone
metering service that let platform operators track per-user and per-model token
consumption, attribute costs, enforce quotas, and generate chargeback reports
for inference requests passing through the AI Inference Gateway. This
observation document was produced from the official RHOAI 3.5 documentation —
the release notes Developer Preview section and the MaaS observability chapters
of Govern LLM access with Models-as-a-Service — because no live demo cluster
was available at authoring time. Every item below is doc evidence, not UI
evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §4 Developer Preview features — External metering for per-user token usage and cost tracking | IPP plugin + standalone metering service available as Developer Preview; track per-user/per-model token consumption, attribute costs, enforce quotas, generate chargeback reports |
| 2 | ai-available-assets-release-notes.txt | same section (plugin behavior) | Plugin operates in the IPP plugin chain; checks user balances before processing requests; extracts input, output, cached, cache write, and reasoning tokens from OpenAI and Anthropic provider responses; emits CloudEvents to a PostgreSQL-backed metering service |
| 3 | ai-available-assets-release-notes.txt | same section (service behavior) | Service aggregates usage, calculates cache-aware pricing, provides an administrative dashboard and REST API for usage queries and balance checks |
| 4 | ai-available-assets-release-notes.txt | §3 Technology Preview — Models-as-a-Service observability dashboard | Usage tab with Token Consumption by User table; filtering by user, subscription, model; time ranges 5 minutes to 14 days; CSV export for integration with external metering, billing, and financial reporting systems |
| 5 | maas-core-govern-llm.txt | §1.18 Monitor MaaS usage by using the observability dashboard | Dashboard embedded via Perses, queries Prometheus, restricted to cluster administrators; intended for internal usage tracking and showback, not billing-grade metering |
| 6 | maas-core-govern-llm.txt | §1.18.2 Token Consumption by User table + Prometheus metrics | Columns: User, Subscription, Model (`<endpoint-name>/<model-id>`), Tokens, Requests, Rate Limited; metrics `authorized_hits_total`, `authorized_calls_total`, `limited_calls_total` collected from Kuadrant and MaaS components |
| 7 | maas-core-govern-llm.txt | §1.18.2 NOTE on captureUser | User label disabled by default (`captureUser: false`); enable per-user metrics via `captureUser` in `MaasTenantConfig`; model label displays only on `authorized_hits_total` due to Kuadrant wasm-shim limitations |
| 8 | maas-core-govern-llm.txt | §1.18.5 Export usage data for cost attribution | Hover Token Consumption by User table → Export as CSV; subscription-level data, suitable for showback, not billing-grade; for production chargeback configure external metering and billing tools |
| 9 | maas-core-govern-llm.txt | §1.1 Deploy and manage MaaS verification checks | `oc get datasciencecluster -n redhat-ods-operator`; `oc get crd | grep -E 'maas.opendatahub.io|aitenants'` lists aitenants, maasauthpolicies, maasmodelrefs, maassubscriptions, maastenantconfigs, tenants; Tenant resource `READY: True` / `Reconciled` |

## User Flows

### Flow 1: Request becomes a metering event (Developer Preview, release-notes-derived)

1. **Request enters the AI Inference Gateway** — external-metering plugin sits in the IPP plugin chain
2. **Balance check** — plugin checks the user's balance from the metering service before processing; exhausted credit can stop the next request
3. **Usage extraction** — plugin extracts token usage details from OpenAI and Anthropic provider responses (input, output, cached, cache write, reasoning tokens)
4. **CloudEvent emission** — usage details emitted as a CloudEvent to the standalone PostgreSQL-backed metering service
5. **Aggregation** — service aggregates usage, calculates cache-aware pricing, stores results
6. **Consumption** — administrative dashboard and REST API for usage queries and balance checks

### Flow 2: Locate per-user usage today (Technology Preview observability dashboard)

1. **Open dashboard** — OpenShift AI dashboard → Observe & monitor → Dashboard (cluster administrator)
2. **Usage tab** — three tabs: Cluster, Models, Usage
3. **Scope the view** — Time period dropdown (5 minutes to 14 days, custom range); User/Subscription/Model filters
4. **Review** — Overview metrics (Total Tokens, Total Requests, Total Errors, Success Rate, Active Users) and Token Consumption by User table
5. **Export** — hover the table → Export as CSV (subscription-level, showback-grade)

## Features and Concepts

### OpenShift Platform
- IPP (inference plugin protocol) plugin chain at the gateway, CloudEvents, PostgreSQL persistence, Prometheus/Kuadrant metrics, RBAC-scoped dashboard access

### RHOAI / AI Platform
- External-metering IPP plugin and standalone metering service (Developer Preview), MaaS observability dashboard and CSV export (Technology Preview), `MaasTenantConfig` `captureUser` setting, MaaS CRDs (`aitenants`, `tenants`, `maassubscriptions`, `maastenantconfigs`, `maasmodelrefs`, `maasauthpolicies`)

### AI/ML Fundamentals
- Token accounting dimensions (input, output, cached, cache write, reasoning), cache-aware pricing, per-user/per-model cost attribution and chargeback

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on)
- **Target audience**: platform operators and finance-adjacent engineers with OpenShift and MaaS working knowledge
- **Prerequisite knowledge**: MaaS concepts, `oc` CLI basics; cluster prerequisites: RHOAI operator installed, MaaS enabled, external metering configured
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5 with MaaS enabled; external metering configured; `captureUser: true` for per-user dashboard rows
- **Honesty boundary**: plugin/metering-service installation procedures are not in the 3.5 docs — the lab observes documented MaaS surfaces and walks the DP architecture in prose

## Open Questions

- Availability of the external-metering plugin and metering service installation procedures in later 3.x documentation
- Whether the administrative dashboard and REST API of the standalone metering service become separately documented surfaces in a future release
- Live-cluster confirmation of per-user rows (requires `captureUser: true` in `MaasTenantConfig`)
