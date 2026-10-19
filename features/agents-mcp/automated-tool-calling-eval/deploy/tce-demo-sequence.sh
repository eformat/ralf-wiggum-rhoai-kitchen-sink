#!/bin/sh
# The demo's own artifact: the full documented datageneration sequence
# (module-02 flow) driven through the LIVE EvalHub MCP server via the
# Streamable-HTTP transport: initialize -> tools/list -> discover_providers ->
# submit_evaluation -> get_job_status polls. Authenticated with the EvalHub
# namespace service-account token (passes the evalhub-mcp route).
set -eu
MCP_URL="https://evalhub-mcp-p2w15-evalhub.apps.cluster-qn8tx.dyn.redhatworkshops.io"
TENANT="p2w15-evalhub"
TOKEN="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
HDRS="-H \"Authorization: Bearer $TOKEN\""
json() { grep "^data:" | sed "s/^data: //"; }

echo "=== [1] initialize (Streamable-HTTP handshake, Authorization + x-tenant headers) ==="
RESP=$(curl -sk -D /tmp/tce-hdrs.txt -X POST "$MCP_URL" \
  -H "Authorization: Bearer $TOKEN" -H "x-tenant: $TENANT" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"claude-code","version":"2.0"}}}')
echo "$RESP"
SID=$(grep -i "mcp-session-id" /tmp/tce-hdrs.txt | tr -d '\r' | awk '{print $2}')
echo "session id: $SID"

curl -sk -o /dev/null -X POST "$MCP_URL" \
  -H "Authorization: Bearer $TOKEN" -H "x-tenant: $TENANT" -H "mcp-session-id: $SID" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'

echo "=== [2] tools/list — the four MCP surfaces ==="
curl -sk -X POST "$MCP_URL" \
  -H "Authorization: Bearer $TOKEN" -H "x-tenant: $TENANT" -H "mcp-session-id: $SID" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' | json \
  | grep -o '"name":"[a-z_]*"' | head -4

echo "=== [3] discover_providers — match intent to agent metadata ==="
curl -sk -X POST "$MCP_URL" \
  -H "Authorization: Bearer $TOKEN" -H "x-tenant: $TENANT" -H "mcp-session-id: $SID" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"discover_providers","arguments":{"target_type":"model","evaluates":["safety"]}}}' | json \
  | sed 's/","structuredContent.*//;s/.*"text":"//'

echo "=== [4] submit_evaluation — garak quick benchmark (agent constructs the job from hints) ==="
SUBJ=$(curl -sk -X POST "$MCP_URL" \
  -H "Authorization: Bearer $TOKEN" -H "x-tenant: $TENANT" -H "mcp-session-id: $SID" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"submit_evaluation","arguments":{"name":"tce15-quick-safety-scan","model":{"url":"https://qwen25-05b-rhoai-deploy.apps.cluster-qn8tx.dyn.redhatworkshops.io/v1","name":"qwen25-05b","auth":{"secret_ref":"qwen-caller-token"}},"benchmarks":[{"id":"quick","provider_id":"garak"}]}}}' | json)
echo "$SUBJ" | sed 's/","structuredContent.*//;s/.*"text":"//'
JID=$(echo "$SUBJ" | grep -o '"job_id":"[0-9a-f-]*"' | cut -d'"' -f4)
echo "job id: $JID"

echo "=== [5] get_job_status — tracking pending -> running -> terminal ==="
i=0
while [ $i -lt 14 ]; do
  i=$((i+1))
  ST=$(curl -sk -X POST "$MCP_URL" \
    -H "Authorization: Bearer $TOKEN" -H "x-tenant: $TENANT" -H "mcp-session-id: $SID" \
    -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
    -d "{\"jsonrpc\":\"2.0\",\"id\":5,\"method\":\"tools/call\",\"params\":{\"name\":\"get_job_status\",\"arguments\":{\"job_id\":\"$JID\"}}}" | json \
    | grep -o '"state":"[a-z_]*"' | head -1 | cut -d'"' -f4)
  echo "poll $i: job state = $ST"
  case "$ST" in
    completed|failed|partially_failed|cancelled) break ;;
  esac
  sleep 9
done

echo "=== [6] get_job_status terminal response — result_interpretation from agent metadata ==="
curl -sk -X POST "$MCP_URL" \
  -H "Authorization: Bearer $TOKEN" -H "x-tenant: $TENANT" -H "mcp-session-id: $SID" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d "{\"jsonrpc\":\"2.0\",\"id\":6,\"method\":\"tools/call\",\"params\":{\"name\":\"get_job_status\",\"arguments\":{\"job_id\":\"$JID\"}}}" | json \
  | sed 's/.*"content":\[//' | head -c 700

echo ""
echo ""
echo "=== [7] done — the REST/CLI assertion of the same job store runs from the workstation (deploy/README.md) ==="
