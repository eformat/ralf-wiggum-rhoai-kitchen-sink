#!/usr/bin/env bash
# Snapshot the DSC default-dsc component map (17 keys) before/after a patch.
# Usage: snapshot-dsc.sh [label]
set -euo pipefail
: "${KUBECONFIG:?export KUBECONFIG first}"
LABEL="${1:-snapshot}"
DIR="$(dirname "$0")/../../qa"
OUT="/tmp/opencode/p2w15-garak/dsc-${LABEL// /-}.json"
mkdir -p /tmp/opencode/p2w15-garak
oc get dsc default-dsc -o json \
  | python3 -c '
import json, sys
d = json.load(sys.stdin)
comps = d["spec"]["components"]
print(json.dumps({k: (v.get("managementState") if isinstance(v, dict) else v) for k, v in comps.items()}, indent=2))
' > "$OUT"
echo "component map (${LABEL}) -> $OUT"
cat "$OUT"
