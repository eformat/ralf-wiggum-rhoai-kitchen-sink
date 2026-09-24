---
schema_version: 1
id: RHAIBU-M33DZQ7QYQ7W
type: requirement
---
# Module 01: Getting Started

## Problem

Before touring the OpenClaw agent starter kit, learners need a working
namespace and a mental model of what the kit provides: the seven capabilities
from the RHOAI 3.5 release notes, the two deployment options, and the
OGX/vLLM model connection. Without this orientation, the later guided tour of
observability, access control, persistence, and security is abstract labels
with no understanding of the components behind them.

## Requirements

- [REQ-011] Learner MUST be able to confirm their workshop connection with `oc whoami && oc project` (execute-role block in exercise 1)
- [REQ-012] Learner MUST be able to name the seven starter kit capabilities: deployment, model connection, observability, access control, persistence, validation, and security
- [REQ-013] Learner MUST be able to compare the two deployment options — validated Kustomize manifests and the automated OpenClaw installer — and state when to choose each
- [REQ-014] Learner MUST be able to describe how the agent connects to self-hosted models through vLLM via the OGX inference gateway with an OpenAI-compatible API

## Success Metrics

Learner completes both exercises: the capabilities walkthrough (including the
`oc whoami && oc project` connection check) and the deployment-options and
model-connection comparison, each matching the documented module summary.

## Risks

- As a Developer Preview, the deployment interface described in this module may change between releases; the module explicitly directs learners to focus on concepts rather than memorizing commands

## Assumptions

- Learner has completed Getting Connected (cluster login via `oc login`, working project `oc new-project {guid}-{user}`, RHOAI dashboard access)

## Related Requirements

- RHAIBU-M33DZQ7G95Q9

## Verified By

- features/agents-mcp/openclaw-starter-kit/content/modules/ROOT/pages/module-01-getting-started.adoc
