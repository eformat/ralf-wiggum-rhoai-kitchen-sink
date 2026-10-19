#!/usr/bin/env bash
# Caller token for the evaluation job (model.auth.secret_ref): a Secret whose
# `token` key holds a credential the MODEL ENDPOINT accepts. The run reuses the
# staged qwen25-05b ISVC (kserve route, OpenShift bearer-token auth) read-only,
# so the caller credential is the current user's OpenShift token.
# Model URL for the job: https://qwen25-05b-rhoai-deploy.apps.cluster-qn8tx.dyn.redhatworkshops.io/v1
set -euo pipefail
export KUBECONFIG=/home/mike/.kube/config.fde
: "${EVALHUB_NS:=p2w15-evalhub}"
TOKEN="$(oc whoami -t)"
[ -n "$TOKEN" ] || { echo "no token: run oc login first" >&2; exit 1; }
oc create secret generic qwen-caller-token -n "$EVALHUB_NS" \
  --from-literal=token="$TOKEN" \
  --dry-run=client -o yaml | oc apply -f -
echo "--- qwen-caller-token created (token key for model.auth.secret_ref)"
