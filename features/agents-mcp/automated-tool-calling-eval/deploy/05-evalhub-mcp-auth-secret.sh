#!/usr/bin/env bash
# evalhub-mcp server auth (deployment prerequisite, missing from workshop
# content): the evalhub-mcp server needs a Secret with a `token` key holding a
# token the EvalHub API accepts — the MCP server's own service-account token
# is rejected with 401 by the EvalHub API. Uses the current user's token
# (expires — re-run this script to refresh).
set -euo pipefail
export KUBECONFIG=/home/mike/.kube/config.fde
: "${EVALHUB_NS:=p2w15-evalhub}"
TOKEN="$(oc whoami -t)"
[ -n "$TOKEN" ] || { echo "no token: run oc login first" >&2; exit 1; }
oc create secret generic evalhub-mcp-auth -n "$EVALHUB_NS" \
  --from-literal=token="$TOKEN" \
  --dry-run=client -o yaml | oc apply -f -
echo "--- evalhub-mcp-auth created (token key, user token refreshed $(date -Iseconds))"
