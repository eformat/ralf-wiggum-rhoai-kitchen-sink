---
schema_version: 1
id: RHAIBU-M33DZJ8XH5JA
type: requirement
---
# Module 01: Tour the File Processors API

## Problem

Before walking the document-processing path, learners need a mental model of
the File Processors API surface — the `/v1alpha/file-processors` endpoint, its
Developer Preview status, and the five extraction-backend providers — and
verification of the OGX environment (operator, CRD, servers) it runs in.
Without this orientation, later hands-on steps are copy-paste with no
understanding of what is being created.

## Requirements

- [REQ-011] Learner MUST be able to name the File Processors API endpoint (`/v1alpha/file-processors`), its Developer Preview support level, and at least two of its extraction backends
- [REQ-012] Learner MUST be able to confirm the OGX component is enabled with `oc get datasciencecluster <dsc-name> -o jsonpath='{.spec.components.ogx.managementState}'` printing `Managed`
- [REQ-013] Learner MUST be able to confirm the OGXServer CRD is registered with `oc get crd ogxservers.ogx.io`
- [REQ-014] Learner MUST be able to list OGX servers in their project with `oc get ogxserver -n {guid}-{user}` (an empty list means no server exists in the project yet)

## Success Metrics

Learner completes both exercises: the API tour (endpoint, support level,
provider table) and the cluster inspection commands, each producing the
documented expected output.

## Risks

- OGX resources only exist after the OGX component is enabled; on clusters without it, exercise 2 must be adapted

## Assumptions

- Learner has completed Getting Connected (cluster login, working project)

## Related Requirements

- RHAIBU-M33DZJ8RFSS3

## Verified By

- features/agents-mcp/ogx-file-processors/content/modules/ROOT/pages/module-01-getting-started.adoc
