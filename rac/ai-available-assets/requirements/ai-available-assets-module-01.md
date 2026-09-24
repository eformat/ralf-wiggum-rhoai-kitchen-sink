---
schema_version: 1
id: RHAIBU-M33CTVMB23E3
type: requirement
---
# Module 01: Discover AI assets in the dashboard

## Problem

Before consuming AI assets, learners need to know where the AI Available Assets
page lives in the dashboard navigation, what its two asset categories (Models,
MCP Server) contain, and how platform-level configuration such as the
`gen-ai-aa-mcp-servers` ConfigMap flows into the page. Without this
orientation, later hands-on steps are copy-paste with no understanding of where
assets come from.

## Requirements

- [REQ-011] Learner MUST be able to navigate to the AI asset endpoints page via `Gen AI studio → AI asset endpoints` and select their working project (`{guid}-{user}`)
- [REQ-012] Learner MUST be able to identify the Models and MCP Server asset categories and the three model sources (project deployments designated as available assets, custom endpoints, MaaS models)
- [REQ-013] Learner MUST be able to apply the `gen-ai-aa-mcp-servers` ConfigMap to `redhat-ods-applications` and confirm its creation with `oc get configmap gen-ai-aa-mcp-servers -n redhat-ods-applications -o yaml | grep GitHub-MCP-Server`
- [REQ-014] Learner MUST be able to confirm the published MCP server appears in the *MCP servers* tab of the AI asset endpoints page

## Success Metrics

Learner completes both exercises: the page tour (both tabs browsed, project
scoped) and the MCP server publication (ConfigMap applied, key confirmed, server
visible in the dashboard tab).

## Risks

- An empty AI asset endpoints page is a valid starting state; learners must understand this is not a failure
- The ConfigMap apply requires write access to `redhat-ods-applications`

## Assumptions

- Learner has completed Getting Connected (cluster login, working project, dashboard opened)

## Related Requirements

- RHAIBU-M33CTVKS1W3G

## Verified By

- features/agents-mcp/ai-available-assets/content/modules/ROOT/pages/module-01-getting-started.adoc
