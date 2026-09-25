---
schema_version: 1
type: asset
---
# Screenshot Evidence: GenAI Studio saved agents (genai-studio-saved-agent)

## Capture Summary

- **Date:** 2026-09-24
- **Cluster:** cluster-44gxc.dyn.redhatworkshops.io (RHOAI 3.5.1)
- **Captured:** 1/1 shots
- **Failed:** 0
- **Cluster work performed** (per the gold-standard flow in
  `~/git/ph-deploy-configure-rhoai/manifests/05-maas/enable/`):
  1. DSC patched via `dsc-genai-patch-35.yaml` — `ogx: Managed`,
     `llamastackoperator: Removed`, trustyai Managed (OGX powers the playground
     backend in 3.5; OGXReady = True).
  2. Dashboard flags via `dashboard-genai-patch.yaml` (genAiStudio + modelAsService
     were already set).
  3. CPU model deployed per `manifests/04-vllm/qwen25-05b/`: InferenceService
     `qwen25-05b` (Qwen2.5-0.5B-Instruct on the vLLM CPU runtime, OCI modelcar,
     token auth via ServiceAccount/Role/RoleBinding) in project `abc123-user1`,
     with the `opendatahub.io/genai-asset: "true"` label; `vllm-cpu-x86-runtime`
     ServingRuntime copied into the project. Ready with external route.
  4. Playground created via the dashboard ("Create playground" → qwen25-05b
     selected) — provisions the `lsd-genai-playground` OGX server + genai-pgvector
     DB in the project.
  5. Save-agent flow exercised: playground header kebab → "Save as new agent".

## Evidence Map

| Screenshot | Page | Requirement | Criterion | Status |
|------------|------|-------------|-----------|--------|
| 02-save-agent-dialog.png | module-02-hands-on.adoc:60 | (module-02 Exercise 1) — Save agent dialog showing a summary of the captured playground configuration (agent name, model qwen25-05b, auto-created prompt, knowledge/MCP sections) | captured (live dialog with agent name `support-triage-baseline` filled) |

## Uncovered Criteria

- Loaded-agent header display and variant copies (Exercise 2+) — require further
  exercise execution.
