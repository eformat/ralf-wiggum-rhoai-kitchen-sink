---
schema_version: 1
id: RHAIBU-M33DZJ913MYJ
type: requirement
---
# Module 02: Walk the document-processing path

## Problem

After mapping the API surface, learners need to trace how a document flows
from upload through an extraction backend to vector-ready chunks, and drive
the documented upload-and-index workflow that the File Processors API backs.
Without this walk-through, the API remains an abstract endpoint with no
understanding of the extraction stage it exposes.

## Requirements

- [REQ-021] Learner MUST be able to explain the three stages of the document flow (upload → extraction → indexing) and identify the OGX service (port `8321`) that hosts the APIs
- [REQ-022] Learner MUST be able to upload a document through the Files API with `client.files.create` and receive a `file_info` object with a file `id`
- [REQ-023] Learner MUST be able to index the uploaded file into a vector store with a `chunking_strategy` and poll until `File status: completed`
- [REQ-024] Learner SHOULD be able to run the Docling pipeline and verify that a `file_search`-backed query returns an answer grounded in the ingested document content

## Success Metrics

Learner completes all three exercises: the flow trace, the upload-and-index
workflow (file status `completed`), and the Docling pipeline run with a
grounded `file_search` answer.

## Risks

- The first indexing run can take several minutes; a `failed` status usually means an unreachable embedding model or an unconfigured vector store provider (for example Milvus)
- The 3.5 docs publish no direct request example for the alpha endpoint — payloads must not be invented for `/v1alpha/file-processors`

## Assumptions

- Learner has completed Module 01 (OGX environment verified)
- An OGX server is running with port `8321` exposed, and inference plus embedding models are deployed
- `ogx-client` version 0.3.1 or later is installed in the workbench environment

## Related Requirements

- RHAIBU-M33DZJ8RFSS3

## Verified By

- features/agents-mcp/ogx-file-processors/content/modules/ROOT/pages/module-02-hands-on.adoc
