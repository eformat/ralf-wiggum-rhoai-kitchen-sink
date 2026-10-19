# Deploy: openshell-agent-sandboxing environment

Stages the environment the *OpenShell (secure agent sandboxing and policy
enforcement)* workshop needs: the ClusterRole `odh-dashboard-agent-ops` already
grants Sandboxes in `agents.x-k8s.io`, but the Sandbox surface (the CRD + the
sandbox controller) is not installed, and nothing enforces the controlled
network egress the workshop's beat needs. Everything here is additive —
nothing is patched or removed.

## Files

| File | What it is |
|------|------------|
| `01-agent-sandbox-manifest.yaml` | Upstream [kubernetes-sigs/agent-sandbox](https://github.com/kubernetes-sigs/agent-sandbox) `v0.5.0` manifest — installs the `sandboxes.agents.x-k8s.io` CRD (v1beta1), the `agent-sandbox-system` namespace, and the Sandbox controller (Deployment + RBAC + Service). |
| `02-sandbox.yaml` | One OpenShell-managed `Sandbox` custom resource (`osh15-agent-runtime`) in project `osh15-sandbox` — the running agent deployment the dashboard Deployments view lists. The pod runs a periodic egress probe against `https://example.com`. |
| `03-egress-control-pod.yaml` | Control pod (`osh15-egress-allowed`) in the same project WITHOUT the managed-by pod label — runs the identical egress probe and keeps full egress, giving the contrast in the pod logs. |
| `04-egress-networkpolicy.yaml` | The controlled-egress enforcement object: a `NetworkPolicy` (`osh15-controlled-egress`) selecting the sandboxed agent pod by the pod label and allowing egress to DNS only. OVN-Kubernetes enforces it for real. |

## Apply order

```bash
# 1. CRD + controller (wait ~40s for the controller pod to be 1/1)
oc apply -f 01-agent-sandbox-manifest.yaml
oc rollout status deploy/agent-sandbox-controller -n agent-sandbox-system

# 2. The agent deployment (Sandbox CR) + the control pod — need the working project
oc new-project osh15-sandbox   # skip if it exists
oc apply -f 02-sandbox.yaml
oc apply -f 03-egress-control-pod.yaml

# 3. Verify BEFORE applying the NetworkPolicy: both pods Running, the control
#    pod's probe succeeds (egress to the internet works from this cluster)
oc get pods -n osh15-sandbox
oc logs -n osh15-sandbox osh15-egress-allowed --tail=3      # expect HTTP 200

# 4. Apply the controlled-egress enforcement object
oc apply -f 04-egress-networkpolicy.yaml

# 5. Verify the payoff: the sandboxed agent pod's probe is denied, the control
#    pod still succeeds
oc logs -n osh15-sandbox <sandboxed-agent-pod> --tail=3     # expect BLOCKED (curl exit 28)
oc logs -n osh15-sandbox osh15-egress-allowed --tail=3      # still HTTP 200
```

## Dashboard flag

The `agentOps` flag is set in the workshop's Exercise 1 (documented step,
additive — already set on this cluster):

```bash
oc patch odhdashboardconfig odh-dashboard-config -n redhat-ods-applications \
  --type=merge -p '{"spec":{"dashboardConfig":{"agentOps":true}}}'
```

No dashboard pod restart is needed — `GET /api/config` with
`Cache-Control: no-cache` forces the flag re-read.

## Cleanup

```bash
oc delete -f 03-egress-control-pod.yaml
oc delete -f 02-sandbox.yaml
oc delete -f 04-egress-networkpolicy.yaml
oc delete -f 01-agent-sandbox-manifest.yaml
oc delete project osh15-sandbox
```
