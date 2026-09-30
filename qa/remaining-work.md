# Remaining real work — CLOSED OUT (2026-09-30)

Superseded by `qa/quality-triage.md` (source of truth). All 12 items from the
2026-09-25 list are resolved; only the standing deferrals and the
capture-when-available bucket remain.

## NARRATIVE-ONLY fixes (6) — all applied
| # | Workshop | Score | Disposition |
|---|----------|-------|-------------|
| 1 | model-registry-catalog | 6 | DONE — exercise code applied; residual = design |
| 2 | mcp-gateway-operator | 5 | DONE — operator install + Gateway/MCPGatewayExtension manifests applied; narrative design |
| 3 | csv-export-model-catalog | 5 | DONE — exporter deploy/run commands applied; residual flags are false-positive placeholders |
| 4 | vllm-cpu-ibm-z-power | 5 | DONE — ServingRuntime manifests applied; images recaptured 2026-09-30 |
| 5 | mcp-catalog-admin | 3 | DONE — catalog source ConfigMap admin code applied; settings page 404s in 3.5.1 (TODO'd with drift reason) |
| 6 | rhai-fast-release-images | 3 | DONE — fast-release image deployment applied (fast-1 template created on cluster); images recaptured 2026-09-30 |

## Topical captures (6 runtime-demo gaps) — all resolved
| # | Workshop | Score | Disposition |
|---|----------|-------|-------------|
| 7 | kuberay | 5 | DONE — clean (score 0) in the 2026-09-30 triage |
| 8 | evalhub | 7 | CLOSED — live-flow evidence 2026-09-25 (submission accepted, benchmark Jobs Running); prose fixes applied 2026-09-30 (`{"id":...}` request format, module-03 walkthrough de-drifted — see qa/runs/evalhub/quality.md) |
| 9 | maas-multi-tenancy | 7 | DONE — no runtime-demo gap remains; residual flags are false-positive placeholders (2026-09-30 triage) |
| 10 | garak | 7 | BLOCKED — standing deferral (needs garai CLI + GPU-capable model) |
| 11 | feature-store-feast | 8 | DONE — clean (score 0); the workflow-diagram TODO is resolved |
| 12 | claude-code-starter-kit | 8 | BLOCKED — standing deferral (needs Anthropic credentials; never embedded per security rules) |

## Still open (tracked in quality-triage.md)
- `nemo-guardrails-mcp-gateway` — the one `fail` in qa/status.yml: Service Mesh install
  for this one lab vs documented observe-only exception (user decision pending)
- `autorag` — upstream driver-image bug (mlflow plugin omits the X-MLflow-Workspace
  header) to report to RHOAI
- `llmd-priority-flow-control` screenshot + the 11 `TODO(screenshot)` items — re-capture
  when their cluster environments return (capture-when-available bucket)
