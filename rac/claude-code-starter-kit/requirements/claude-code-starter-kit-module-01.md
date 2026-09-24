---
schema_version: 1
id: RHAIBU-M33D1QNAV38F
type: requirement
---
# Module 01: Getting Started

## Problem

Before working with the Claude Code agent starter kit, learners need a mental
model of what the kit provides — a pre-configured Containerfile and Kustomize
manifests for deploying the Anthropic Claude Code agent on OpenShift AI — and
how its three validated inference paths differ. Without this orientation, the
later guided tour of configuration, observability, and security is terminology
with no understanding of what the kit actually does.

## Requirements

- [REQ-011] Learner MUST be able to confirm workshop connectivity with `oc whoami && oc project` (username plus working project from Getting Connected)
- [REQ-012] Learner MUST be able to name the six capabilities of the starter kit as documented in the RHOAI 3.5 release notes
- [REQ-013] Learner MUST be able to compare the three validated inference paths (direct Anthropic API, self-hosted models through vLLM, vLLM through the OGX gateway) and identify which requires Anthropic API access
- [REQ-014] Learner MUST be able to explain that the inference-path choice is a deploy-time decision made through the Kustomize manifests rather than a post-deploy reconfiguration

## Success Metrics

Learner completes both exercises: the capability tour of the starter kit and the
inference-path comparison table, each producing the documented understanding and
the connectivity command showing the expected output.

## Risks

- Developer Preview status means the deployment interface taught here may change between releases
- Environments without Anthropic credentials can only exercise the vLLM-based paths

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33D1QN2BXKW

## Verified By

- features/agents-mcp/claude-code-starter-kit/content/modules/ROOT/pages/module-01-getting-started.adoc
