# Observations: OGX remote::anthropic and remote::gemini providers (doc-derived)

## Summary

The `remote::anthropic` and `remote::gemini` inference providers are RHOAI
3.5 EA2's Developer Preview path for proxying OpenAI-compatible OGX requests
to the Anthropic and Google Gemini APIs. This observation document was
produced from the official RHOAI 3.5 product documentation (Working with OGX;
Release notes) because no live demo cluster was available at authoring time.
Every item below is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §4.2 3.5 EA2 Developer Preview features — remote::anthropic | `remote::anthropic` inference provider is available on OGX; enabled by setting the `ANTHROPIC_API_KEY` environment variable in your `config.yaml` file |
| 2 | ai-available-assets-release-notes.txt | §4.2 3.5 EA2 Developer Preview features — remote::gemini | `remote::gemini` inference provider is available on OGX; enabled by setting the `ENABLE_GEMINI` environment variable in your `config.yaml` file |
| 3 | ai-available-assets-release-notes.txt | §4.2 NOTE on provider availability | Some listed providers are not included in the default runtime `config.yaml` file and must be enabled by passing a custom `config.yaml` that includes the provider definitions |
| 4 | ogx-working-with-ogx.txt | OGX API provider support table (Inference API) | `remote::gemini` (enable via `ENABLE_GEMINI`) and `remote::anthropic` (enable via `ANTHROPIC_API_KEY`) listed among Inference API remote providers alongside `remote::vllm` (`VLLM_URL`), `remote::azure` (`AZURE_API_KEY`), `remote::bedrock` (`AWS_ACCESS_KEY_ID`), `remote::openai` (`OPENAI_API_KEY`), `remote::vertexai` (`VERTEX_AI_PROJECT`) |
| 5 | ogx-working-with-ogx.txt | §3 Security reference — egress destinations | OGX pods initiate all connections to remote providers and storage backends; no egress occurs unless a provider or storage type is configured. Destinations set via CRD fields (`spec.providers.inference.remote.<provider>[].endpoint`), environment variables (`${env.*}` in the default distribution `config.yaml`, set with Secrets or ConfigMaps), or a full custom `config.yaml` via `spec.overrideConfig` |
| 6 | ogx-working-with-ogx.txt | Operator tables (watch label, secret collection) | OGX Secrets carry the `ogx.io/watch: "true"` watch label; operator collects secret references and injects environment variables named `OGX_<PROVIDER_ID>_<FIELD>` (e.g. `OGX_REMOTE_OPENAI_API_KEY`); Secrets with the watch label trigger an immediate pod roll on rotation; Secrets are never stored in the OGXServer CR spec itself |

## User Flows

### Flow 1: Enable a remote provider (documented path)

1. **Store the credential** — create an Opaque Secret in the OGXServer namespace, labeled `ogx.io/watch: "true"` (§6, operator tables)
2. **Reference it from the OGXServer** — the operator collects the reference at reconciliation and injects it as `OGX_<PROVIDER_ID>_<FIELD>` (§6)
3. **Set the enablement variable** — `ANTHROPIC_API_KEY` (remote::anthropic) or `ENABLE_GEMINI` (remote::gemini) in the `config.yaml` (release notes §4.2)
4. **Observe** — pods roll; egress to `api.anthropic.com` or Google endpoints begins (§3 egress)

### Flow 2: Call the remote model through the OpenAI-compatible surface

1. **Point at the OGX service** — the OGX service exposes the OpenAI-compatible API on port `8321`
2. **List models** — `/v1/models` returns registered model IDs
3. **Chat completion** — `/v1/chat/completions` proxies the request to the remote API and back; existing OpenAI SDK clients work unchanged with only the `base_url` pointing at the OGX route with the `/v1` suffix

## Features and Concepts

### OpenShift Platform
- OGXServer CR (`ogxservers.ogx.io`), RHOAI operator-managed lifecycle, Secrets/ConfigMaps for `${env.*}` substitution, RBAC on Secret reads

### RHOAI / AI Platform
- OGX as a proxy between its APIs and backend model servers; inline vs remote provider flavors; API provider support matrix (Inference API); `spec.overrideConfig` custom `config.yaml` path; `ogx.io/watch` label secret collection mechanism

### AI/ML Fundamentals
- OpenAI-compatible inference APIs (`/v1/models`, `/v1/chat/completions`), third-party SaaS inference providers (Anthropic, Gemini), API-key vs feature-flag enablement

## Workshop Potential

- **Estimated modules**: 2 (concepts → hands-on enablement)
- **Target audience**: developers and platform engineers with OpenShift working knowledge
- **Prerequisite knowledge**: OpenShift basics, OGX enabled, external API keys (per feature matrix prerequisites: RHOAI operator installed, OGX enabled, External API keys)
- **Estimated duration**: 45–60 minutes
- **Cluster requirements**: RHOAI 3.5 EA2 with the RHOAI operator and OGX enabled; egress to `api.anthropic.com` / Google endpoints (no air-gapped support); per-request costs billed against the registered API key

## Open Questions

- Full provider schema (provider ID and config field names) for `remote::anthropic` and `remote::gemini` — the release notes document only the enablement variables; field names must be verified against the OGX documentation for the release being run
- Whether the docs describe a complete `remote::anthropic`/`remote::gemini` `config.yaml` example (the docs' remote provider configuration example covers Bedrock)
- Console screenshots deferred to the Act phase when a cluster is available
