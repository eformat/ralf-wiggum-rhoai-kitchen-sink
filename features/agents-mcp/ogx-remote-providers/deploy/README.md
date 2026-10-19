# Deploy — ogx-remote-providers (OGX remote::anthropic + remote::gemini environment)

Repeatable staging for the documented workshop flow (module-01 Exercises 1–3 →
module-02 Exercises 1–3). Every cluster change corresponds to a file here.
Apply order is numeric. Target cluster family: RHOAI 3.5.1, OpenShift 4.22,
CPU-only x86, `ogx` component already `Managed`.

## Honest-state note (no real external keys)

This environment is staged with **placeholder credentials**. The OGX machinery
is real: the providers register, the OGXServer deploys, the merged config.yaml
is served, and the OGX pods egress to `api.anthropic.com` /
`generativelanguage.googleapis.com` (verified 401 in 0.18s from an in-cluster
pod). Calls through the remote providers **fail closed with auth errors** —
never fake success. Real grounded responses require real external API keys
(the workshop's Prerequisites) — retry condition: a real `ANTHROPIC_API_KEY` /
`GEMINI_API_KEY` in the Secrets → chat completions return `Earth`.

## Prereq decisions (documented + verified)

- **DSC `ogx` component** must be `Managed`. It already is on the target
  cluster (17-key snapshot, only `kueue`/`llamastackoperator`/`ray`/
  `sparkoperator`/`trainer`/`trainingoperator` `Removed`) — no patch here.
  When staging elsewhere: `oc patch --type=merge` per component ONLY, never
  `oc apply` a DSC manifest.
- **Providers must be declared under `providers.<name>`** in the OGX
  `config.yaml` (top-level keys are ignored by the OGX base-config merge).
- **`spec.baseConfig` (labeled ConfigMap) takes precedence** over the
  operator's OCI resolution (operator OCI resolution 401s on this cluster —
  the labeled ConfigMap is the working config path).
- **Remote provider sections in the OGXServer CRD** support
  `azure/bedrock/custom/openai/vertexai/vllm/watsonx` — `remote::anthropic`
  and `remote::gemini` are enabled via the config.yaml declaration +
  environment variables (`ANTHROPIC_API_KEY`, `GEMINI_API_KEY`), per the
  release notes. `workload.overrides.env` wires the Secret-backed credential
  injection (the documented enablement path).
- **CRD-structured secretRefs** (`providers.inference.inline.custom[]`)
  were not needed: the baseConfig + workload-overrides path is the
  documented Path 1 + Path 2 combined and is proven here.

## Files

| File | Cluster change |
|------|----------------|
| `00-namespace.yaml` | `Namespace p2w15-ogxrp` (replaces the docs' `oc new-project`) |
| `10-secrets.yaml` | `Secret anthropic-creds` + `Secret gemini-creds` — placeholder `api-key` values, label `ogx.io/watch: "true"` |
| `20-base-config.yaml` | `ConfigMap p2w15-ogxrp-base-config` — `config.yaml` declaring `providers.inference` with `remote::anthropic` + `remote::gemini` |
| `30-ogxserver.yaml` | `OGXServer p2w15-ogxrp` — `spec.baseConfig` + `distribution rh-dev` + `workload.overrides.env` secretKeyRefs |

## Apply order

```bash
oc apply -f 00-namespace.yaml
oc apply -f 10-secrets.yaml -n p2w15-ogxrp
oc apply -f 20-base-config.yaml -n p2w15-ogxrp
oc apply -f 30-ogxserver.yaml -n p2w15-ogxrp
# wait for Ready (~2 min):
oc get ogxserver p2w15-ogxrp -n p2w15-ogxrp
```

Then verify (module-02 Ex 3 flow):

```bash
oc exec -n p2w15-ogxrp deploy/p2w15-ogxrp -- cat /etc/ogx/config.yaml | grep -A3 'remote::'
curl -s "http://p2w15-ogxrp-service.p2w15-ogxrp.svc.cluster.local:8321/v1/models"
curl -s -X POST "http://p2w15-ogxrp-service.p2w15-ogxrp.svc.cluster.local:8321/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{"model": "<model_id>", "messages": [{"role": "user", "content": "Which planet do humans live on?"}]}'
```

## Revert

```bash
oc delete ogxserver p2w15-ogxrp -n p2w15-ogxrp --ignore-not-found
oc delete secret anthropic-creds gemini-creds -n p2w15-ogxrp --ignore-not-found
oc delete configmap p2w15-ogxrp-base-config -n p2w15-ogxrp --ignore-not-found
oc delete namespace p2w15-ogxrp --ignore-not-found   # only when its workloads are gone
```

## Notes

- The OGXServer CR + labeled ConfigMap/Secrets carry `ogx.io/watch: "true"` —
  the operator only watches LABELED resources.
- `persistence` inside provider configs must be FLAT `{backend, namespace}`.
- The OGX base-config merge DROPS built-in inline providers — declare
  everything the arc needs in the custom `config.yaml`; only enable APIs
  whose providers are explicitly configured (a missing provider KeyErrors
  the OGX lifespan and the stack will not start).
- Upstream `registry.redhat.io` notebook repos are not authorized on this
  cluster; the internal registry
  `image-registry.openshift-image-registry.svc:5000/redhat-ods-applications/s2i-generic-data-science-notebook:3.5`
  is the working image for probe pods.
