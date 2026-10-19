#!/usr/bin/env bash
# Enable the RHOAI dashboard for the p2w13-autorag namespace (additive label per
# the documented RHOAI env step). NEVER oc apply a Namespace manifest (would
# clobber labels) — merge patch only.
set -euo pipefail
: "${KUBECONFIG:?export KUBECONFIG first}"
oc patch namespace p2w13-autorag --type=merge \
  -p '{"metadata":{"labels":{"opendatahub.io/dashboard":"true"}}}'
oc get namespace p2w13-autorag \
  -o jsonpath='{.metadata.labels.opendatahub\.io/dashboard}'; echo
