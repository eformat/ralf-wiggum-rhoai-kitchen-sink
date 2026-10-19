# Deploy: view-agent-deployments environment

Stages the environment the *View running agent deployments in dashboard* workshop
needs on a cluster where the RHOAI dashboard has the `agentOps` flag set but the
OpenShell Agent Sandbox surface is not installed (only the `agent-ops-ui` backend
is Running). Everything here is additive — nothing is patched or removed.

## Files

| File | What it is |
|------|------------|
| `01-agent-sandbox-manifest.yaml` | Upstream [kubernetes-sigs/agent-sandbox](https://github.com/kubernetes-sigs/agent-sandbox) `v0.4.6` manifest — installs the `sandboxes.agents.x-k8s.io` CRD, the `agent-sandbox-system` namespace, and the Sandbox controller (Deployment + RBAC + Service). |
| `02-sandbox.yaml` | One OpenShell-managed `Sandbox` custom resource (`p2w15-agent-runtime`) in project `p2w15-view` — the running agent deployment the dashboard Deployments view lists. The pod runs a long-running HTTP echoserver so the deployment is verifiably Running. |

## Apply order

```bash
# 1. CRD + controller (wait ~40s for the controller pod to be 1/1)
oc apply -f 01-agent-sandbox-manifest.yaml
oc rollout status deploy/agent-sandbox-controller -n agent-sandbox-system

# 2. The agent deployment (Sandbox CR) — needs the working project
oc new-project p2w15-view   # skip if it exists
oc apply -f 02-sandbox.yaml

# 3. Verify the pod the controller created is Running
oc get sandbox p2w15-agent-runtime -n p2w15-view
oc get pods -n p2w15-view
```

## Dashboard flag

The workshop's Exercise 1 patches the flag (documented step, additive):

```bash
oc patch odhdashboardconfig odh-dashboard-config -n redhat-ods-applications \
  --type=merge -p '{"spec":{"dashboardConfig":{"agentOps":true}}}'
```

No dashboard pod restart is needed — `GET /api/config` with
`Cache-Control: no-cache` forces the flag re-read.

## Cleanup

```bash
oc delete -f 02-sandbox.yaml
oc delete -f 01-agent-sandbox-manifest.yaml
```
