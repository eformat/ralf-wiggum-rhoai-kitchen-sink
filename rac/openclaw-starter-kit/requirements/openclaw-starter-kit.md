---
schema_version: 1
id: RHAIBU-M33DZQ7G95Q9
type: requirement
---
# OpenClaw agent starter kit Workshop

## Problem

Platform engineers and agent operators evaluating RHOAI 3.5 need hands-on
experience with the OpenClaw agent starter kit — the Developer Preview path for
deploying and managing OpenClaw, an open-source general-purpose agent, on Red
Hat OpenShift AI using validated Kustomize manifests and an automated installer.
Without a structured workshop, learners must piece together the deployment
options, OGX/vLLM model connection, MLflow tracing, and RBAC-backed access
control from the release notes alone. This workshop targets RHOAI users with
working knowledge of OpenShift. Because the feature is Developer Preview, the
lab is an honest guided tour of what the kit provides rather than a
deployment walkthrough with fabricated commands.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and confirm their identity with `oc whoami`
- [REQ-002] Learner MUST be able to create a personal working project (`oc new-project {guid}-{user}`) and confirm it is the current namespace with `oc project`
- [REQ-003] Learner MUST be able to verify their workshop connection with `oc whoami && oc project` before starting the tour
- [REQ-004] Learner MUST be able to identify the two deployment options (validated Kustomize manifests and the automated OpenClaw installer) and when to choose each
- [REQ-005] Learner MUST be able to describe how the agent connects to self-hosted models through vLLM via the OGX inference gateway with an OpenAI-compatible API
- [REQ-006] Learner MUST be able to describe what the diagnostics-otel plugin captures in MLflow: model calls, tool executions, and context assembly spans
- [REQ-007] Learner MUST be able to explain how browser-based access control is enforced with the OAuth proxy backed by OpenShift RBAC
- [REQ-008] Learner SHOULD be able to observe the running agent workload with `oc get pods -n {guid}-{user}` as an observation rather than a fixed output
- [REQ-009] Learner SHOULD be able to summarize the workspace persistence, restricted-v2 SCC security posture, and the included model compatibility matrix and troubleshooting guide

## Success Metrics

All nine acceptance criteria are demonstrated by the learner during the lab:
the Getting Connected verifies (`oc whoami`, `oc project`) pass in the
bookend module, the module-01 execute check (`oc whoami && oc project`)
confirms the working namespace, and the module-02 `oc get pods` observation
shows the deployed agent pod when the starter kit is deployed to a shared
namespace. Guided-tour criteria (REQ-004 through REQ-007, REQ-009) are met
when the learner can state the capability without prompting.

## Risks

- The feature is Developer Preview in 3.5 and is provided as-is with no support and no guarantee of future availability, so the deployment interface may change between releases
- The `oc get pods` observation in module 02 depends on a facilitator having deployed the starter kit into a shared namespace; without it the exercise is adapted to discussion only
- Guided-tour criteria are conceptual and cannot be verified by machine-checkable command output alone

## Assumptions

- RHOAI 3.5 is installed via the RHOAI operator
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`, `{openshift_api_url}`)
- The OGX inference gateway and vLLM backends are available cluster-side if the facilitator deploys the kit for observation

## Related Designs

- RHAIBU-M33DZQ8MRM2B

## Related Decisions

- RHAIBU-M33DZQ85954V
- RHAIBU-M33DZQ8BRHS9

## Related Requirements

- RHAIBU-M33DZQ7QYQ7W
- RHAIBU-M33DZQ7Y1W5P
