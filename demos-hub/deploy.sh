#!/usr/bin/env bash
# deploy.sh — build the demos ConfigMap from the working tree and deploy the
# preview hub to the current cluster. One key per demo player + index.html.
#
# Usage: KUBECONFIG=~/.kube/config.fde ./deploy.sh [namespace]   (default: arcade-demos)
#
# The pilots fit in one ConfigMap (~0.5 MB; the ~1 MiB ConfigMap limit holds
# ~3-4 players at lossy q90). Beyond that, switch to the chunked-ConfigMap
# pattern from ~/git/coco-confidential-agents/deploy/ (chunks + initContainer
# assembly into an emptyDir).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
NS="${1:-arcade-demos}"

export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config.fde}"

if ! command -v oc >/dev/null 2>&1; then
    echo "oc not found" >&2; exit 1
fi

oc get namespace "$NS" >/dev/null 2>&1 || oc create namespace "$NS"

# Rebuild the ConfigMap from scratch (idempotent)
oc -n "$NS" delete configmap arcade-demos-site --ignore-not-found

FROM_FILES=(--from-file="index.html=$SCRIPT_DIR/index.html")
COUNT=0
while IFS= read -r f; do
    FROM_FILES+=(--from-file="$(basename "$f")=$f")
    COUNT=$((COUNT+1))
done < <(find "$REPO_DIR/features" -path '*attachments*' -name '*-demo.html' | sort)

oc -n "$NS" create configmap arcade-demos-site "${FROM_FILES[@]}"
echo "packed $COUNT demo players into configmap/arcade-demos-site"

oc apply -n "$NS" -f "$SCRIPT_DIR/k8s/app.yaml" --server-side --force-conflicts
oc -n "$NS" rollout status "deployment/arcade-demos" --timeout=180s

if ! oc -n "$NS" get route arcade-demos >/dev/null 2>&1; then
    oc -n "$NS" create route edge --service=arcade-demos >/dev/null
fi
ROUTE_HOST="$(oc -n "$NS" get route arcade-demos -o jsonpath='{.spec.host}')"

echo
echo "demos hub deployed — namespace=$NS"
echo "  route: https://$ROUTE_HOST"
