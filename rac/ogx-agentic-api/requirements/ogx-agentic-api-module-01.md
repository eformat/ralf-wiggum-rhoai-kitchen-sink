---
schema_version: 1
id: RHAIBU-M33DSKJ7R2YW
type: requirement
---
# Module 01: OGX agentic API concepts

## Problem

Before driving the agentic APIs, learners need a mental model of the OGX
architecture (Operator, OGXServer CR, run.yaml provider configuration) and the
two API layers: native OGX APIs (Tool Runtime, Vector_IO) versus the
OpenAI-compatible surface (Responses, Conversations). Without this orientation,
later hands-on steps are copy-paste with no understanding of what is being
created.

## Requirements

- [REQ-011] Learner MUST be able to locate the `OGXServer` custom resource definition via the console `CustomResourceDefinitions` search for `ogxservers`
- [REQ-012] Learner MUST be able to verify the `ogx` component state with `oc get datasciencecluster` (`spec.components.ogx.managementState` prints `Managed`)
- [REQ-013] Learner MUST be able to confirm the `ogxservers.ogx.io` CRD is registered with `oc get crd ogxservers.ogx.io`
- [REQ-014] Learner MUST be able to list existing OGXServer resources in their project with `oc get ogxserver -n {guid}-{user}` and observe an empty list before deployment

## Success Metrics

Learner completes both exercises: the API-layer walkthrough (native vs
OpenAI-compatible table) and the cluster inspection commands, each producing
the documented expected output.

## Risks

- The OGX component must be enabled in the DSC; on clusters without it, exercise 2 must be adapted
- Native OGX API support levels are Developer Preview and may change between releases

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33DSKJ262BA

## Verified By

- features/agents-mcp/ogx-agentic-api/content/modules/ROOT/pages/module-01-concepts.adoc
