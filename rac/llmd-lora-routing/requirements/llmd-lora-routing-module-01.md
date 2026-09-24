---
schema_version: 1
id: RHAIBU-M33DE6QWQY7X
type: requirement
---
# Module 01: Getting Started

## Problem

Before observing adapter-aware routing, learners need a mental model of the
cold-load latency problem, where LoRA-aware routing decisions happen in the
llm-d serving stack (Endpoint Picker flow control and scheduling layers), and
confirmation that the llm-d serving resources exist in their cluster. Without
this orientation, the later metrics observation is copy-paste with no
understanding of what the labels mean.

## Requirements

- [REQ-011] Learner MUST be able to explain why a request pays cold-load latency when it lands on a pod without the target adapter and what happens when no pod with the adapter is available (fallback to standard routing)
- [REQ-012] Learner MUST be able to verify `LLMInferenceService` resources are recognized with `oc get llmisvc -n {guid}-{user}` — a list with URL and READY status or `No resources found`, both acceptable
- [REQ-013] Learner MUST be able to list the `LLMInferenceServiceConfig` templates behind the wizard with `oc get llminferenceserviceconfig -A` and note their namespaces
- [REQ-014] Learner SHOULD be able to open the `llm-d routing configurations` and `llm-d topology configurations` pages under dashboard Settings and observe the Default optimized routing pre-selection in the wizard's Advanced routing section

## Success Metrics

Learner completes all three exercises: the LoRA-aware routing walkthrough, the
llm-d serving stack mapping, and the read-only cluster inspection commands,
each producing the documented expected output.

## Risks

- If `oc get llmisvc` fails with `the server doesn't have a resource type`, the Distributed Inference with llm-d component is not enabled and the facilitator must be consulted
- The `llm-d` admin settings pages require administrator access, which not every learner may have

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33DE6QRF0A2

## Verified By

- features/agents-mcp/llmd-lora-routing/content/modules/ROOT/pages/module-01-getting-started.adoc
