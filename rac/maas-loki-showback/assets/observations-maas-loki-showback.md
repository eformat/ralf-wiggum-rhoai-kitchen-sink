# Observations: MaaS Loki-based showback and user-scoped usage dashboards (doc-derived)

## Summary

Showback reporting and per-user usage dashboards with Loki is the RHOAI 3.5
Models-as-a-Service observability feature: a metrics-based dashboard embedded in
the OpenShift AI console (built on Perses, querying Prometheus) for
subscription-level usage monitoring, plus a Loki-based structured log pipeline
for showback data with 30-day retention on object storage. This observation
document was produced from the official RHOAI 3.5 product documentation
(Govern LLM access with Models-as-a-Service; Monitoring your AI systems) because
no live demo cluster was available at authoring time. Every item below is doc
evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | lokishowback-govern-llm.txt | §1.8 Observability configuration for Models-as-a-Service | Prerequisites: `spec.dashboardConfig.observabilityDashboard: true` in `OdhDashboardConfig`; observability stack with metrics storage in `DSCInitialization`; Cluster Observability Operator; TP support-scope note |
| 2 | lokishowback-govern-llm.txt | §1.18.1 Models-as-a-Service usage monitoring | Dashboard embedded via Perses, queries Prometheus, restricted to cluster administrators; showback-grade not billing-grade — production chargeback uses the Limitador metrics endpoint directly; capabilities: overview metrics, filtering, time range (5 min–14 days + custom), token consumption details |
| 3 | lokishowback-govern-llm.txt | §1.18.2 Enable Kuadrant observability | `spec.observability.enable: true` on the `kuadrant` CR (console YAML or `oc patch` in `kuadrant-system`); creates a `PodMonitor` for Limitador metrics; verify `kuadrant-limitador-monitor` exists |
| 4 | lokishowback-govern-llm.txt | §1.18.3 Enable telemetry | Telemetry enabled on the Tenant CR (`tenants.maas.opendatahub.io`); `enabled`, `captureOrganization` (default true), `captureUser` (default false — privacy/cardinality), `captureGroup` (default false), `captureModelUsage` (default true); verify via `authorized_calls` query in Observe → Metrics |
| 5 | lokishowback-govern-llm.txt | §1.18.4 View the observability dashboard | *Observe & monitor* → *Dashboard* → *Usage* tab (Cluster/Models/Usage); Overview: Total Tokens, Total Requests, Total Errors, Success Rate, Active Users; Token Consumption by User table; sort + pagination |
| 6 | lokishowback-govern-llm.txt | §1.18.5 Export usage data | Requires Cluster Observability Operator; filters apply to export; hover Token Consumption by User table → *Export as CSV*; CSV is showback-grade, not billing-grade |
| 7 | lokishowback-govern-llm.txt | Prometheus metrics inventory | `authorized_hits_total` (tokens, labels `subscription`/`model`/`limitador_namespace`), `authorized_calls_total` (requests), `limited_calls_total` (HTTP 429), `istio_request_duration_milliseconds_bucket` (latency), `auth_server_authconfig_duration_seconds` (Authorino); `model` label only on `authorized_hits_total` (Kuadrant wasm-shim limitation); per-tenant `maas-api` metrics with `tenant_name` label and structured JSON logs carrying `tenant_name`, `tenant_namespace`, `gateway_name`, `gateway_namespace` |
| 8 | lokishowback-monitoring.txt | (whole book) | This is the "Monitoring your AI systems" book (TrustyAI fairness/drift metrics) — analyzed as the sibling observability book; contains no MaaS showback evidence |

## User Flows

### Flow 1: Enable the metrics pipeline (Module 01)

1. **Verify prerequisites** — MaaS CRDs, `openshift-user-workload-monitoring` namespace, Tenant `READY`/`Reconciled`, `observabilityDashboard: true` (§1.8, §1.9)
2. **Enable Kuadrant observability** — `spec.observability.enable: true` on `kuadrant` in `kuadrant-system`; verify `kuadrant-limitador-monitor` PodMonitor (§1.18.2)
3. **Enable MaaS telemetry** — patch the Tenant CR with `telemetry.enabled: true` + capture flags; verify `authorized_calls` (§1.18.3)

### Flow 2: Consume and export showback data (Module 02)

1. **Enable per-user metrics** — `captureUser: true` on the Tenant CR; generate MaaS traffic; verify `authorized_hits_total` per user
2. **Read the dashboard** — *Observe & monitor* → *Dashboard* → *Usage* tab; Overview metrics, filters, time ranges, Token Consumption by User table (§1.18.4)
3. **Export CSV** — hover the table → *Export as CSV* → save locally for finance teams (§1.18.5)

## Features and Concepts

### OpenShift Platform
- `OdhDashboardConfig`, `DSCInitialization`, PodMonitor resources, User Workload Monitoring, Cluster Observability Operator, Prometheus (*Observe* → *Metrics*)

### RHOAI / AI Platform
- MaaS observability dashboard (Perses-based, three tabs: Cluster/Models/Usage), Kuadrant CR observability, Tenant CR telemetry, Limitador + Authorino metrics, MaaS structured JSON logs (`maas-api`), OpenTelemetry tracing via `OTEL_EXPORTER_OTLP_ENDPOINT`

### AI/ML Fundamentals
- Token consumption metering, showback vs chargeback (billing-grade) distinction, metric cardinality cost of per-user labels

## Workshop Potential

- **Estimated modules**: 2 (getting started → hands-on dashboard + export)
- **Target audience**: cluster administrators operating Models-as-a-Service
- **Prerequisite knowledge**: OpenShift administration, MaaS basics
- **Estimated duration**: 60–90 minutes
- **Cluster requirements**: RHOAI 3.5, MaaS enabled with a published model, observability stack configured, Cluster Observability Operator for the CSV export

## Open Questions

- Loki-based log pipeline and user-scoped dashboards: release-notes-only in 3.5 (Technology Preview enhancement) — which release publishes the configuration commands
- Exact *Observe & monitor* → *Dashboard* nav label on a live console (doc-derived path)
- Whether the Loki pipeline configuration surface lands in the same component as the Tenant CR telemetry
