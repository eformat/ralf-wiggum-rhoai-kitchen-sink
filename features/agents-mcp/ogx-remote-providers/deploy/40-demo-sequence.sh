#!/bin/bash
# ogx-remote-providers demo sequence — module-02 Exercises 2-3, the documented
# curl flow against the OGX OpenAI-compatible surface on port 8321.
# Runs in the ogxrp-demo-sequence probe pod; output is captured by the
# console pod Logs view. With placeholder credentials the calls FAIL CLOSED
# with real auth errors — never fake success (honest-state note in README.md).
set -u
OGX_URL="http://p2w15-ogxrp-service.p2w15-ogxrp.svc.cluster.local:8321"

sleep 20   # settle window so the console Logs view is reached live

echo "=== ogx-remote-providers demo sequence — module-02 Ex 2-3 ==="
echo
echo "--- Exercise 3: explore the remote model through the OpenAI-compatible surface ---"
echo "\$ export OGX_URL=\"http://p2w15-ogxrp-service.p2w15-ogxrp.svc.cluster.local:8321\""
echo
echo "\$ curl -s \"\$OGX_URL/v1/models\" | jq -r '.data[].id'"
sleep 3
curl -s --max-time 30 "$OGX_URL/v1/models"
echo
echo
echo "NOTE: with placeholder credentials, model discovery fails closed — the"
echo "remote providers are registered, but no models are listed yet."
sleep 4
echo
echo "--- Select a model backed by the remote provider and send a chat completion ---"
echo "\$ curl -s -X POST \"\$OGX_URL/v1/chat/completions\" -H \"Content-Type: application/json\" \\"
echo "  -d '{\"model\": \"anthropic-inference/claude-sonnet-4-5\", ...}'"
sleep 3
curl -s --max-time 40 -X POST "$OGX_URL/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{"model": "anthropic-inference/claude-sonnet-4-5", "messages": [{"role": "user", "content": "Which planet do humans live on?"}], "stream": false}'
echo
echo
echo "Module-02 verify: if the call fails with an authentication error, re-check"
echo "that the Secret is labeled ogx.io/watch: \"true\" and that the pods rolled."
sleep 4
echo
echo "--- Same call through the Gemini provider ---"
echo "\$ ... \"model\": \"gemini-inference/gemini-2.5-flash\" ..."
sleep 3
curl -s --max-time 40 -X POST "$OGX_URL/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{"model": "gemini-inference/gemini-2.5-flash", "messages": [{"role": "user", "content": "Which planet do humans live on?"}], "stream": false}'
echo
echo
echo "=== demo sequence complete — calls fail closed with real auth errors ==="
echo "=== real grounded responses need real external API keys (workshop Prerequisites) ==="
