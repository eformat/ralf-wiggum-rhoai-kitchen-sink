#!/usr/bin/env bash
# Delete every staged demo resource after recording. Read-only inspection first.
set -euo pipefail
: "${KUBECONFIG:?export KUBECONFIG first}"
NS="p2w13-autorag"
echo "--- before cleanup:"
oc get rolebinding p2w15-garak-default-edit -n "$NS" -o name 2>/dev/null || true
oc get workbench -n "$NS" 2>/dev/null | grep -i garak || true
oc get pod p2w15-garak-verify -n "$NS" -o name 2>/dev/null || true
oc delete rolebinding p2w15-garak-default-edit -n "$NS" --ignore-not-found
oc delete pod p2w15-garak-verify -n "$NS" --ignore-not-found
# The recorded workbench (garak-wb) + its ServingRuntime template wrapper:
for WB in $(oc get workbench -n "$NS" -o name 2>/dev/null | grep -i garak || true); do
  oc delete "$WB" -n "$NS" --ignore-not-found
done
# Staged demo KFP runs (intents-scan* display names):
for RUN in $(oc get wf -n "$NS" -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.labels.workflows\.argoproj\.io/display-name}{"\n"}{end}' 2>/dev/null | grep -iE "intents-scan|garak" | cut -f1 || true); do
  oc delete wf "$RUN" -n "$NS" --ignore-not-found || true
done
echo "--- after cleanup:"
oc get rolebinding,pod,workbench -n "$NS" 2>/dev/null | grep -iE "garak|p2w15" || echo "clean"
