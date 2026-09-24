---
schema_version: 1
id: RHAIBU-M33CVWSM5ZFG
type: requirement
---
# Module 03: Advanced Usage

## Problem

After connecting the MCP server, learners need to extend automated
tool-calling evaluation-data generation to their own providers: install the
EvalHub agent skills plugin as a scripted alternative to the MCP server, make a
custom provider agent-discoverable with an `agent` metadata block, and generate
auditable evaluation cards through MLflow experiment or OCI export
configuration.

## Requirements

- [REQ-031] Learner MUST be able to install the EvalHub agent skills plugin (`claude plugin install evalhub@evalhub`) and verify scripted discovery with `evalhub_providers.py --agent` returning JSON with agent metadata
- [REQ-032] Learner MUST be able to add an `agent` metadata block (`evaluates`, `recommended_when`, `target_type`, `summary`, `hints`, `result_interpretation`) to a custom provider and confirm it appears in the provider API response
- [REQ-033] Learner MUST be able to generate an evaluation card by including an MLflow experiment configuration and retrieve it with `evalhub eval status <job_id> --format=json | jq '.artifacts'`, confirming `generated_at` and `generator` metadata
- [REQ-034] Learner SHOULD be able to explain that a job submitted without an MLflow experiment or OCI export produces no card, by comparing a job that includes the `experiment` block with one that omits it

## Success Metrics

Learner completes all three exercises: the agent skills verification returning
provider JSON, the `agent` block confirmed in the provider response, and the
evaluation card retrieved from `.artifacts` with its metadata fields.

## Risks

- OpenShift tokens expire; `401 Unauthorized` errors require refreshing `EVALHUB_TOKEN`
- Clusters with self-signed certificates require `EVALHUB_INSECURE=true` for agent skills scripts
- A custom provider without an `agent` block is excluded from filtered `discover_providers` results

## Assumptions

- Learner has completed Module 02 (an MCP connection and a submitted job exist to compare against)
- Python 3.11+ and `uv` are installed for agent skills scripts

## Related Requirements

- RHAIBU-M33CVWQY6RCD

## Verified By

- features/agents-mcp/automated-tool-calling-eval/content/modules/ROOT/pages/module-03-advanced.adoc
