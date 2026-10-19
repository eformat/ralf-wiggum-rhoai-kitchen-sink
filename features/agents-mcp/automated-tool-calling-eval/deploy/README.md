# Deploy — automated-tool-calling-eval (EvalHub MCP environment)

Repeatable staging for the documented workshop flow (module-01 Exercise 2 →
module-02 Exercises 1–4). Every cluster change corresponds to a file here.
Apply order is numeric. Target cluster family: RHOAI 3.5.1, CPU-only x86,
`trustsai` component initially `Removed`.

## Prereq decisions (documented + verified)

- **TrustyAI component** must be `Managed` before the `EvalHub` CRD exists.
  Enabled via `oc patch --type=merge` per component ONLY (snapshot the DSC
  component map before/after — never `oc apply` a DSC manifest, that clobbers
  sibling components on shared clusters).
- **`spec.mcp.authSecret`** is a real deployment prerequisite (not in the
  workshop content): the evalhub-mcp server needs a Secret with a `token` key
  holding a token the EvalHub API accepts — the MCP server's own
  service-account token is rejected with 401 by the EvalHub API.
  `05-evalhub-mcp-auth-secret.sh` creates it from the current user token.
- **`database.type`** doc-vs-CRD drift (verified): the workshop example uses
  `postgresql`, but the CRD requires a PRE-COMPOSED `db-url` key in the
  referenced secret (an external PostgreSQL — the operator does not deploy
  one). Without it the server pod fails `FailedMount: references non-existent
  secret key: db-url` and the CR stays `Pending/False` (the same state the
  2026-09-23 run recorded). `sqlite` is the CRD's documented lightweight path
  and the proven-Ready backend — `04-evalhub-cr.yaml` uses it.
- **Model endpoint** for the evaluation job: any Ready OpenAI-compatible
  endpoint. The run reuses the staged `qwen25-05b` ISVC (kserve route,
  OpenShift bearer-token auth) read-only — `06-caller-token-secret.sh` stores
  a caller token for `model.auth.secret_ref`.

## Files

| File | Cluster change |
|------|----------------|
| `01-trustyai-component.patch.sh` | `oc patch dsc default-dsc --type=merge` — `trustyai.managementState: Managed` |
| `02-namespace.yaml` | `Namespace p2w15-evalhub` (replaces the docs' `oc new-project`) |
| `03-evalhub-db-credentials.secret.yaml` | `Secret evalhub-db-credentials` (PostgreSQL credentials for the EvalHub CR) |
| `04-evalhub-cr.yaml` | `EvalHub evalhub` — `spec.mcp {enabled, transport http, port 3001, authSecret}` |
| `05-evalhub-mcp-auth-secret.sh` | `Secret evalhub-mcp-auth` (`token` key = current user token; expires — re-run to refresh) |
| `06-caller-token-secret.sh` | `Secret qwen-caller-token` (`token` key = OpenShift bearer token for the model endpoint) |

## Apply order

```bash
bash 01-trustyai-component.patch.sh        # DSC trustyai → Managed (oc patch --type=merge)
# wait for the TrustyAI operator + evalhubs CRD:
oc get crd | grep -i evalhub
oc apply -f 02-namespace.yaml
oc apply -f 03-evalhub-db-credentials.secret.yaml
bash 05-evalhub-mcp-auth-secret.sh
bash 06-caller-token-secret.sh
oc apply -f 04-evalhub-cr.yaml -n p2w15-evalhub
```

Then verify (module-01/mo-02 flow): `oc get evalhub -n p2w15-evalhub`,
pods (`server=true`, `mcp=true`), routes (`evalhub`, `evalhub-mcp`).

## Revert

```bash
oc delete evalhub evalhub -n p2w15-evalhub --ignore-not-found
oc delete secret evalhub-db-credentials evalhub-mcp-auth qwen-caller-token -n p2w15-evalhub --ignore-not-found
oc delete namespace p2w15-evalhub --ignore-not-found   # only when its workloads are gone
oc patch dsc default-dsc --type=merge -p '{"spec":{"components":{"trustyai":{"managementState":"Removed"}}}}'
```

## Notes

- DSC component map at staging: 17 keys — snapshot before/after, ONLY
  `trustyai.managementState` may change.
- Upstream `github.com/eval-hub` skills repo is not always reachable; the
  plugin install step (`claude plugin install evalhub@evalhub`) failed in the
  2026-09-23 run with "Plugin not found in marketplace" — the MCP-server and
  tool-call arcs do not depend on it.
- Completed-results table (module-02 Ex 4): the 2026-09-30 run on
  cluster-44gxc hit an upstream evalhub runner/model-proxy auth defect (garak
  runner 401s at the model call despite a verified-correct secret token).
  Retry condition: garak runner receives the secret credential → job
  `completed` with `attack_success_rate`.
