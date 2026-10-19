# Deploy — maas-multi-provider-passthrough demo environment (cluster-qn8tx)

Repeatable manifests for the **Multi-provider API passthrough for external models
via MaaS** arcade demo (`maas-multi-provider-passthrough-demo.html`).

## HONEST-STATE SUBSTITUTION (documented, not hidden)

The workshop's module flow uses a **real external provider**
(`api.anthropic.com` + an Anthropic API key). No Anthropic credentials are
available for captures, and the demo must never fake success. The substitution:

- The `ExternalProvider` endpoint points at an **in-cluster stand-in server**
  (`01-mock-anthropic-messages-server.yaml`) that speaks the **Anthropic
  Messages API** (`POST /v1/messages` → native Anthropic Messages JSON with
  `content` array + `stop_reason: end_turn`). From the MaaS gateway's
  perspective the endpoint is **outside the translation pipeline** — the
  gateway still detects `/v1/messages`, matches it against
  `apiFormat: messages`, injects the provider API key from the secret, and
  forwards **unchanged** (true passthrough). Every step of the passthrough
  mechanism demonstrated in the video is real; only the upstream model is a
  stand-in (captions in the demo state this explicitly).
- The provider secret contains a **dummy placeholder key** — the stand-in
  ignores credentials; the gateway's key-injection behavior is unchanged.
- To reproduce with a real provider: edit `03-externalprovider.yaml` to
  `endpoint: api.anthropic.com`, put a real Anthropic key in the secret, and
  keep everything else identical.

## Apply order

```bash
export KUBECONFIG=/home/mike/.kube/config.fde
oc apply -f 00-namespace.yaml
oc apply -f 01-mock-anthropic-messages-server.yaml   # stand-in server
oc apply -f 02-provider-secret.yaml                 # DUMMY placeholder key
oc apply -f 03-externalprovider.yaml
oc apply -f 04-externalmodel.yaml
oc apply -f 05-maasmodelref.yaml
oc apply -f 06-maas-subscription.yaml
oc apply -f 07-maas-authpolicy.yaml
```

## Verify

```bash
oc get externalprovider anthropic-provider -n p2w15-llm   # PHASE Ready
oc get externalmodel claude-sonnet -n p2w15-llm           # PHASE Ready
oc get maasmodelref claude-sonnet -n p2w15-llm            # PHASE Ready (after 06+07 pair it)
oc get httproute,serviceentry,destinationrule -n p2w15-llm
oc get maassubscription p2w15-maas-external-demo -n models-as-a-service
```

The external model is governed by the dedicated subscription
(`p2w15-maas-external-demo`) + auth policy (`p2w15-maas-external-auth`)
(06 + 07) — the dashboard *MaaS governance* subscription Models list is the
UI equivalent of the subscription `modelRefs` pairing (module-02 exercise 2).
A MaaS API key minted from the dashboard exercises the passthrough call:

> **GOTCHA (live-cluster behavior, documented honestly):** the gateway's
> AuthPolicy (`maas-gateway-auth` in `openshift-ingress`) validates MaaS API
> keys ONLY from `request.headers.authorization` matching `^Bearer sk-oai-.*`.
> A request that presents the key via `x-api-key` alone falls through to the
> OpenShift-identities token review and returns **401**, even though the
> documentation exercise shows `x-api-key` for the Anthropic Messages format.
> The passthrough calls below therefore present the MaaS key via
> `Authorization: Bearer` (the `x-api-key` header is still what the provider
> receives after key injection from the ExternalProvider secret).

```bash
curl -X POST https://maas.apps.cluster-qn8tx.dyn.redhatworkshops.io/v1/messages \
  -H "Authorization: Bearer $MAAS_API_KEY" \
  -H "Content-Type: application/json" \
  -H "anthropic-version: 2023-06-01" \
  -d '{ "model": "claude-sonnet", "max_tokens": 100, "messages": [{"role": "user", "content": "Hello"}] }'
# HTTP 200 → Anthropic Messages JSON (content array, stop_reason end_turn,
# model claude-sonnet-4-20250514) — from the stand-in upstream.
```

This is also the **single-URL body-based routing** pattern (module-02
exercise 3, final step): one gateway URL, the model name in the request body
— the gateway resolves `claude-sonnet` from the `model` field and routes to
the matching `ExternalModel`.

## Teardown

```bash
oc delete maasmodelref claude-sonnet externalmodel claude-sonnet \
  externalprovider anthropic-provider -n p2w15-llm
oc delete secret anthropic-api-key -n p2w15-llm
oc delete maassubscription p2w15-maas-external-demo \
  maasauthpolicy p2w15-maas-external-auth -n models-as-a-service
oc delete -f 01-mock-anthropic-messages-server.yaml
oc delete project p2w15-llm
```
