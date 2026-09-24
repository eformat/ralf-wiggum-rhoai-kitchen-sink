---
schema_version: 1
id: RHAIBU-M33DDPJS2ZZW
type: requirement
---
# Module 01: Getting Started

## Problem

Before working with cache-aware routing, learners need a mental model of
hierarchical KV cache tiering, the llm-d Endpoint Picker layers and default
scorer profile, and the cluster surfaces where the feature lives. Without this
orientation, later hands-on steps are copy-paste with no understanding of what
is being created.

## Requirements

- [REQ-011] Learner MUST be able to explain why prefix reuse reduces redundant computation for multi-turn workloads, and that operators configure the cache tiers while placement happens automatically at runtime
- [REQ-012] Learner MUST be able to locate the `llm-d routing configurations` and `llm-d topology configurations` pages under dashboard Settings (administrator access) and note the columns shown
- [REQ-013] Learner MUST be able to run read-only `oc get llmisvc -n {guid}-{user}` and `oc get llminferenceserviceconfig -A` commands without errors
- [REQ-014] Learner MUST be able to locate the Advanced routing section of the model deployment wizard and observe the pre-selected `Default optimized routing` option

## Success Metrics

Learner completes all three exercises: the tiering walkthrough, the Endpoint
Picker layers/scorer profile review, and the cluster inspection commands, each
producing the documented expected output.

## Risks

- The llm-d settings pages and wizard surfaces require administrator access; guided-tour learners without it must observe via facilitator
- On clusters without the Distributed Inference with llm-d component, `oc get llmisvc` fails with `the server doesn't have a resource type`

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33DDPJHFZQQ

## Verified By

- features/agents-mcp/llmd-kv-cache-tiering/content/modules/ROOT/pages/module-01-getting-started.adoc
