---
schema_version: 1
id: RHAIBU-M33DZJ8RFSS3
type: requirement
---
# OGX File Processors API Workshop

## Problem

Platform engineers and ML practitioners evaluating RHOAI 3.5 need hands-on
experience with the OGX File Processors API — the Developer Preview
document-ingestion step of RAG workflows built on OGX — before they can
recommend or operate it. The API surface (`/v1alpha/file-processors` and its
extraction-backend providers) is documented but ships no direct request
examples, so learners must otherwise reverse-engineer the provider enablement
model and the document-processing path from product documentation alone. This
workshop targets RHOAI users with working knowledge of OpenShift and RAG
concepts.

## Requirements

- [REQ-001] Learner MUST be able to log into the OpenShift cluster and create a personal working project (`oc new-project {guid}-{user}`)
- [REQ-002] Learner MUST be able to name the File Processors API endpoint (`/v1alpha/file-processors`), its Developer Preview support level, and at least two of its extraction backends
- [REQ-003] Learner MUST be able to verify the OGX Operator is enabled (`ogx.managementState: Managed`), the OGXServer CRD is registered, and OGX servers are listed in their project
- [REQ-004] Learner MUST be able to explain the three document-flow stages (upload → extraction → indexing) and identify the OGX service (port `8321`) that hosts the File Processors API
- [REQ-005] Learner MUST be able to upload a document via the Files API (`client.files.create`) and index it into a vector store with a chunking strategy, polling until the file status is `completed`
- [REQ-006] Learner SHOULD be able to run the Docling pipeline and verify that a `file_search`-backed query returns an answer grounded in the ingested document content

## Success Metrics

All six acceptance criteria are demonstrated by the learner during the lab;
the indexed file reaches `File status: completed` in module 02 and the
`file_search`-backed query returns a document-grounded answer.

## Risks

- The File Processors API is Developer Preview in 3.5; the endpoint and provider set may change between releases
- The 3.5 docs publish no direct request example for the alpha endpoint — the lab must tour documented workflows only, without inventing payloads
- Workshop clusters must have OGX enabled in the DSC, plus a reachable embedding model and vector store provider (for example Milvus) for the hands-on exercises

## Assumptions

- RHOAI 3.5 is installed with the OGX component enabled in the DSC
- Learners have `oc` CLI access and workshop credentials (`{user}`, `{guid}`)
- An OGX server is running with its service exposing port `8321`, and an inference plus embedding model are deployed and reachable

## Related Designs

- RHAIBU-M33DZJ9E2Q5V

## Related Decisions

- RHAIBU-M33DZJ96YYJ4
- RHAIBU-M33DZJ9ANMZK

## Related Requirements

- RHAIBU-M33DZJ8XH5JA
- RHAIBU-M33DZJ913MYJ
