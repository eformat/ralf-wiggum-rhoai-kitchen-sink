# Submit stack — AutoRAG stack re-triage (cluster-qn8tx, batches p2w13 + p2w14)

Deployment code for the KFP submit stack that re-triages the AutoRAG stack:
a tiny `hello_mlflow` pipeline submitted through the project DSPA
(p2w13-autorag) with the DATA SCIENCE NOTEBOOK image as the step's base image
— the "datascience notebook through the pipeline" verification arc.

Project: p2w13-autorag. Collision-free names prefixed `p2w13-`/`p2w14-`.

## Files

- `sa.yaml` — SA p2w13-autorag-submit + `edit` RoleBinding (APPLIED)
- `submit-script-cm.yaml` — ConfigMap p2w13-autorag-submit-script
  (`setup.sh` + `submit-incluster.py`) — own file, NOT inside the pod manifest
  (a CM defined inside a Pod manifest reverts on every pod apply) (APPLIED)
- `submit-pod.yaml` — python:3.9-slim submit pod with the CM + the
  odh-trusted-ca-bundle CA mount (APPLIED)
- `submit-incluster.py` — the pipeline definition (same content as the CM key)

## Run order

```sh
export KUBECONFIG=/home/mike/.kube/config.fde
oc apply -f sa.yaml
oc apply -f submit-script-cm.yaml
# clean stale failed submit pods/workflow pods before re-running
oc delete pod p2w13-autorag-submit -n p2w13-autorag --ignore-not-found
oc apply -f submit-pod.yaml
oc logs -n p2w13-autorag -f pod/p2w13-autorag-submit        # -> "run: <id>"
oc get pods -n p2w13-autorag | grep hello                    # watch the impl pod
oc logs -n p2w13-autorag -c main <impl-pod>                  # step output
```

## Notebook image DELTA (batch p2w14, 2026-10-19) — the unblock

The p2w13 runs failed on the step-container image pull: upstream
`registry.redhat.io/rhoai/odh-generic-data-science-notebook` is NOT authorized
with this cluster's pull secret ("unauthorized: access to the requested
resource is not authorized" — pipelines repos ARE pullable, this notebook repo
is not; SA imagePullSecrets linking of the cluster pull secret was tried in
p2w13 and was insufficient).

FIX (live-verified): pull the CLUSTER-INTERNAL registry image instead. The
platform imports the workbench image as ImageStream
`s2i-generic-data-science-notebook` (redhat-ods-applications, tags
2025.1/2025.2/3.4/3.5):

```sh
oc get is -n redhat-ods-applications s2i-generic-data-science-notebook
# -> image-registry.openshift-image-registry.svc:5000/redhat-ods-applications/s2i-generic-data-science-notebook
```

A test pod in p2w13-autorag (default SA, cross-namespace internal pull) pulled
`image-registry.openshift-image-registry.svc:5000/redhat-ods-applications/s2i-generic-data-science-notebook:3.5`
and reached Running — no extra image-puller RoleBinding required. The 3.5 tag
resolves to the `odh-workbench-jupyter-datascience-cpu-py312-rhel9` upstream
digest, imported by the operator with its own entitlement.

The submit script now uses `base_image="image-registry.openshift-image-registry.svc:5000/redhat-ods-applications/s2i-generic-data-science-notebook:3.5"`.

## Live verdicts (batch p2w14, 2026-10-19)

- **The hello workflow SUCCEEDED** (`p2w13-autorag-hello-kht9r`, 101s): the
  internal notebook image was pulled, the step container ran, exitCode 0.
  The p2w13 blocker (impl pod ImagePullBackOff) is FIXED.
- The platform MLflow/KFP injection is visible in the step env:
  `KFP_MLFLOW_CONFIG = {"endpoint":"https://mlflow.redhat-ods-applications.svc:8443/mlflow","workspacesEnabled":true,"workspace":"p2w13-autorag",...}`.
- **HONEST MLflow limit (persisted)**: the in-process `mlflow.start_run()` in
  the step wrote to a LOCAL store, not the platform MLflow — the user-step env
  has NO `MLFLOW_TRACKING_URI` (`tracking uri: None`; `KFP_MLFLOW_CONFIG` is
  the driver config, not a user env — the driver skips user env injection,
  p2w13 defect). Direct verification: experiments search with
  `X-MLflow-Workspace: p2w13-autorag` → 200, **count: 0** — no experiment was
  created in the platform MLflow.
- **S3 artifact upload still fails** (persisted): `tls: failed to verify
  certificate: x509: certificate signed by unknown authority` against
  https://s3.openshift-storage.svc:443 (pipeline-runner pods lack the
  trusted-CA mount). The workflow still Succeeds (upload is a warning; the
  task completed).
- **Launcher CA bundle path**: the launcher looks for
  /etc/ssl/certs/ca-certificates.crt (debian path) — the RHEL-based notebook
  image has no such file (`launcher_v2.go:746` warning).
- **Driver task-end mlflow handler still fails** (persisted):
  `dispatcher.go:111: Failed to complete task-level mlflow handler: runID is
  required to update nested MLflow run`.

## Honest limits (unchanged by this fix)

- The step's `mlflow.start_run()` logging depends on the injected MLflow env;
  the known driver/workspace layer defects are captured in
  `qa/demo-status.yml` (autorag entry) and are NOT fixed by the image change.
- The optimization pipeline's separate defects (S3 x509 on artifact download,
  driver-image MLflow plugin) are likewise unchanged.
