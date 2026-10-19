# deploy/ — Automated Red Teaming (powered by Garak)

Repeatable deployment for the `automated-red-teaming-garak` feature demo
(cluster-qn8tx, RHOAI 3.5.1, CPU-only, OpenShift 4.22.18). Every `oc apply` in
the demo flow corresponds to a file in this directory.

## Environment delta (additive only)

| Change | How | File |
|--------|-----|------|
| DSC trustyai Removed -> Managed (docs Prerequisites + module-01 beat expect `Managed`) | `oc patch --type=merge` per component — NEVER `oc apply` a DSC manifest | `scripts/patch-trustyai-managed.sh` |
| 17-key component snapshot before/after | `scripts/snapshot-dsc.sh` | `scripts/snapshot-dsc.sh` |
| Temporary verification pod (notebook ImageStream, CA-bundle mount) | `oc apply` | `manifests/verify-pod.yaml` |
| Garak scan submission script (module-03 documented KFP SDK recipe) | ConfigMap — own file (CM-revert gotcha) | `manifests/garak-submit-script-cm.yaml` |
| Submit pod (runs the scan submission; read-only against served models) | `oc apply` | `manifests/garak-submit-pod.yaml` |

## Recorded-model hygiene (READ-ONLY — never touch)

Served models `p2w14-llama32-3b` (target) + `p2w14-qwen3-4b` (judge) and the
DSPA `p2w13-autorag` live in namespace `p2w13-autorag` (left by batch p2w14).
The demo references them **BY NAME** only — no ISVC/DSPA/ISVC-gateway edits.

## Live verdicts (2026-10-19, batch p2w15)

- Notebook image `image-registry.openshift-image-registry.svc:5000/redhat-ods-applications/s2i-generic-data-science-notebook:3.5`
  pullable cross-namespace with the default SA (verified test pod Running).
- Upstream registry.redhat.io notebook repos NOT authorized — always use the
  internal registry ImageStream.
- DSPA `p2w13-autorag` READY (`ManagedPipelineValid=True`); submitted KFP runs
  Succeed end-to-end; the S3 artifact x509 transfer failure (pipeline-runner
  pods lack the trusted-CA mount for the noobaa HTTPS cert) is NON-FATAL.
- No EvalHub deployed on this cluster: the documented module-02 EvalHub beats
  (tenant label, `/api/v1/evaluations/providers`, 202 job) cannot occur — the
  demo uses the documented module-03 standalone KFP SDK path instead.

## Cleanup

`scripts/cleanup.sh` deletes every staged demo resource (submit pod + script
ConfigMap + verify pod). The DSC trustyai patch is additive and stays (docs
Prerequisites); record nothing else.
