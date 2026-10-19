# MCP Catalog administrative interface — cluster staging (feature: mcp-catalog-admin)

Additive, repeatable cluster changes used to stage the *MCP Catalog administrative
interface* (Developer Preview) on a RHOAI 3.5 cluster. Two phases: enablement (oc
patch per component — never `oc apply` a DSC manifest) and the old-way contrast
resource (`oc apply` of the workshop's ConfigMap).

## 1. Enable the MCP Lifecycle Operator (oc patch per component)

Snapshot the components map before and after — the only key that changes is
`mcplifecycleoperator` (`<unset>` → `Managed`):

```bash
oc get datasciencecluster default-dsc -o jsonpath='{.spec.components}'   # before
oc patch datasciencecluster default-dsc --type=merge \
  -p '{"spec":{"components":{"mcplifecycleoperator":{"managementState":"Managed"}}}}'
oc get datasciencecluster default-dsc -o jsonpath='{.spec.components}'   # after
```

Verify:

```bash
# Pod 1/1 (two deployments: module provisioner + operand controller)
oc get pods -n redhat-ods-applications | grep mcp
# CRDs (both created on install)
oc get crd | grep -E 'mcplifecycleoperators|mcpservers'
# Operator CR instance (the authoritative check — DSC status.installedComponents
# stays EMPTY on this build even when Managed)
oc get mcplifecycleoperators default \
  -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}'   # True
oc get datasciencecluster default-dsc \
  -o jsonpath='{.status.conditions[?(@.type=="MCPLifecycleOperatorReady")].status}'  # True
```

## 2. Surface the `mcpCatalog` dashboard flag (oc patch, no pod restart)

```bash
oc patch odhdashboardconfig odh-dashboard-config -n redhat-ods-applications \
  --type=merge -p '{"spec":{"dashboardConfig":{"mcpCatalog":true}}}'
oc get odhdashboardconfig odh-dashboard-config -n redhat-ods-applications \
  -o jsonpath='{.spec.dashboardConfig.mcpCatalog}'   # true
```

No dashboard pod patch/restart: `GET /api/config` with `Cache-Control: no-cache`
forces the dashboard to re-read flags.

The feature then lives at *Settings* → *MCP resources* → *MCP catalog sources*
(route `/settings/mcp-resources/mcp-catalog`).

## 3. The old-way contrast (oc apply — the round trip this feature replaces)

```bash
oc apply -f gen-ai-aa-mcp-servers.yaml
oc get configmap gen-ai-aa-mcp-servers -n redhat-ods-applications \
  -o yaml | grep GitHub-MCP-Server   # GitHub-MCP-Server: |
```

`deploy/gen-ai-aa-mcp-servers.yaml` is the exact resource documented in
module-01 ("The old way: manual ConfigMap edits"). One entry per MCP server,
applied by a cluster administrator, state tracked by hand — the contrast the
dashboard's YAML-based Add source flow eliminates.

## Cleanup (after recording)

```bash
oc delete configmap gen-ai-aa-mcp-servers -n redhat-ods-applications
# Optional revert (additive-only staging; ArgoCD/ACM clusters: change the GitOps
# source instead and let it sync):
oc patch datasciencecluster default-dsc --type=merge \
  -p '{"spec":{"components":{"mcplifecycleoperator":{"managementState":"Removed"}}}}'
oc patch odhdashboardconfig odh-dashboard-config -n redhat-ods-applications \
  --type=merge -p '{"spec":{"dashboardConfig":{"mcpCatalog":false}}}'
```
