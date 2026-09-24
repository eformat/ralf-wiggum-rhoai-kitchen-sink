#!/usr/bin/env bash
# qa/run-lab.sh <slug> [--from NN] [--list] — run one lab's generated playbook.
# Logs: qa/runs/<slug>/NN.log (one per execute block) + run.log.
# Updates qa/status.yml on completion.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"; shift 2>/dev/null || true
FROM=0; LIST=0
while [ $# -gt 0 ]; do
  case "$1" in
    --from) FROM="$2"; shift 2 ;;
    --list) LIST=1; shift ;;
    *) shift ;;
  esac
done

[ -z "$SLUG" ] && { echo "usage: run-lab.sh <slug> [--from NN] [--list]"; exit 1; }
PB="$REPO/qa/generated/$SLUG.yml"
[ -f "$PB" ] || { echo "no playbook for $SLUG — run: python3 qa/tools/extract-exec-blocks.py $SLUG"; exit 1; }

if [ "$LIST" = "1" ]; then
  python3 "$REPO/qa/tools/extract-exec-blocks.py" "$SLUG" --print
  exit 0
fi

RUNS="$REPO/qa/runs/$SLUG"
mkdir -p "$RUNS"
export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}"

echo "== $SLUG (from block $FROM) | $(date -Is) | cluster: $(oc whoami --show-server 2>/dev/null || echo '?')"
START_ARGS=()
if [ "$FROM" -gt 0 ]; then
  FF=$(printf '%02d' "$FROM")
  FULL=$(grep -oE '"[0-9]{2} \|[^"]*"' "$PB" | sed 's/^"//; s/"$//' | grep "^$FF |" | grep -v "save log" | head -1)
  [ -z "$FULL" ] && { echo "no task starting with '$FF |' in playbook"; exit 1; }
  START_ARGS=(--start-at-task="$FULL")
fi
ansible-playbook -i localhost, "$PB" "${START_ARGS[@]}" 2>&1 | tee "$RUNS/run.log"
rc=${PIPESTATUS[0]}

state="pass"; [ "$rc" -ne 0 ] && state="fail"
"$REPO/qa/tools/update-status.sh" "$SLUG" "$state"

# Identify the failed block: last executed task named "NN | ..."
FAILED=$(grep -oE 'TASK \[[^]]*([0-9]{2} \| [^]]*)\]' "$RUNS/run.log" | tail -1 | sed 's/TASK \[//; s/\]//')
echo "== $SLUG -> $state (rc=$rc) | last block: ${FAILED:-?} | $(date -Is)"
exit "$rc"
