#!/usr/bin/env bash
# qa/tools/update-status.sh <slug> <state> — upsert lab state into qa/status.yml.
# State: pending | pass | fail | observe-only | skip
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SLUG="$1"; STATE="$2"
STATUS="$REPO/qa/status.yml"
touch "$STATUS"
if grep -q "^  $SLUG:" "$STATUS" 2>/dev/null; then
  sed -i "s|^  $SLUG:.*|  $SLUG: $STATE|" "$STATUS"
else
  printf '  %s: %s\n' "$SLUG" "$STATE" >> "$STATUS"
fi
sort -o "$STATUS" "$STATUS" 2>/dev/null || true
