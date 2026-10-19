#!/usr/bin/env bash
# AutoRAG DATA-SIDE setup for cluster-qn8tx (ralf-wiggum-loop batch p2w14).
#
# Stages the FED-AURA data into the AutoRAG document bucket and creates the S3
# connection the AutoRAG wizard's Knowledge setup selects. Additive env only —
# no DSC writes, no dashboard pod changes.
#
# RUN ORDER (from the repo, anyone can re-run):
#   1. Prerequisites  — project p2w13-autorag Active, DSPA ObjectStoreAvailable,
#                       secret noobaa-creds-p2w13 present.
#   2. Bucket upload  — port-forward svc/s3 (openshift-storage) 6001->80, then
#                       upload-data.py (boto3, s3v4, path addressing_style).
#   3. S3 connection  — envsubst template s3-connection.yaml (creds pulled from
#                       noobaa-creds-p2w13 at runtime) | oc apply.
#   4. Verify         — boto3 list + connection secret field check.
#
# Usage:   ./setup-data.sh [--dry-run]
# Requires: oc authenticated as cluster admin (KUBECONFIG=/home/mike/.kube/config.fde),
#           python3 with boto3, envsubst.
set -euo pipefail

NAMESPACE=p2w13-autorag
STORAGE_NS=openshift-storage
BUCKET=p2w13-autorag-pipelines
PF_PORT=6001
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ "${1:-}" == "--dry-run" ]] && DRY=1 || DRY=0
run() { if [[ $DRY -eq 1 ]]; then echo "[dry-run] $*"; else "$@"; fi; }

echo "=== 1. prerequisites ==="
run oc get project "$NAMESPACE"
run oc wait --for=condition=ObjectStoreAvailable "dspa/p2w13-autorag" -n "$NAMESPACE" --timeout=60s
run oc get secret noobaa-creds-p2w13 -n "$NAMESPACE" -o name
echo "prerequisites OK"

echo
echo "=== 2. bucket upload (port-forward svc/s3 ${PF_PORT}->80) ==="
run oc get svc s3 -n "$STORAGE_NS" -o name
if [[ $DRY -eq 1 ]]; then
  echo "[dry-run] oc port-forward svc/s3 ${PF_PORT}:80 -n $STORAGE_NS &"
else
  oc port-forward svc/s3 "${PF_PORT}:80" -n "$STORAGE_NS" >/dev/null 2>&1 &
  PF_PID=$!
  trap 'kill $PF_PID 2>/dev/null || true' EXIT
  for i in $(seq 1 30); do
    if (echo >/dev/tcp/127.0.0.1/"$PF_PORT") 2>/dev/null; then break; fi
    sleep 0.5
  done
  echo "port-forward up (pid $PF_PID)"
fi

# Credentials pulled at runtime — exported for boto3, never printed.
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
AWS_ACCESS_KEY_ID="$(oc get secret noobaa-creds-p2w13 -n "$NAMESPACE" -o jsonpath='{.data.AWS_ACCESS_KEY_ID}' | base64 -d)"
AWS_SECRET_ACCESS_KEY="$(oc get secret noobaa-creds-p2w13 -n "$NAMESPACE" -o jsonpath='{.data.AWS_SECRET_ACCESS_KEY}' | base64 -d)"

run python3 "$HERE/upload-data.py" --endpoint "http://localhost:${PF_PORT}" --bucket "$BUCKET"

echo
echo "=== 3. S3 connection (Secret template -> envsubst -> oc apply) ==="
AK="$(oc get secret noobaa-creds-p2w13 -n "$NAMESPACE" -o jsonpath='{.data.AWS_ACCESS_KEY_ID}' | base64 -d)"
SK="$(oc get secret noobaa-creds-p2w13 -n "$NAMESPACE" -o jsonpath='{.data.AWS_SECRET_ACCESS_KEY}' | base64 -d)"
if [[ $DRY -eq 1 ]]; then
  echo "[dry-run] env AK=*** SK=*** envsubst '\$AK \$SK' < $HERE/s3-connection.yaml | oc apply -n $NAMESPACE -f -"
else
  env AK="$AK" SK="$SK" envsubst '$AK $SK' < "$HERE/s3-connection.yaml" | oc apply -n "$NAMESPACE" -f -
fi

echo
echo "=== 4. verify ==="
run oc get secret p2w14-data-s3-connection -n "$NAMESPACE" -o name
if [[ $DRY -eq 1 ]]; then
  echo "[dry-run] oc get secret p2w14-data-s3-connection -n $NAMESPACE -o jsonpath='{.data}' | base64-decode fields"
else
  oc get secret p2w14-data-s3-connection -n "$NAMESPACE" -o jsonpath='{.data}' \
    | python3 -c "
import json, sys, base64
d = json.load(sys.stdin)
print({k: base64.b64decode(v).decode() if k.endswith(('BUCKET', 'ENDPOINT')) else '<redacted>' for k, v in d.items()})
"
  oc get secret p2w14-data-s3-connection -n "$NAMESPACE" \
    -o jsonpath='connection-type annotation: {.metadata.annotations.opendatahub\.io/connection-type}{"\n"}'
fi
echo
echo "data-side setup complete: FED-AURA data in bucket $BUCKET/fed-aura/ + connection p2w14-data-s3-connection in $NAMESPACE"
