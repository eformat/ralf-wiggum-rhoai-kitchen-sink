# cluster/ Makefile — helpers for the RHOAI workshop cluster configuration.
# The manifests are plain kustomize overlays (base + overlays/); the targets
# below only cover the imperative steps kustomize cannot express (dashboard
# flags patch, MaaS DB secrets, runtime enablement, verification).

SHELL := /bin/bash
CLUSTER_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: dashboard-flags maas-secrets enable-cpu-runtime enable-serving-runtimes cluster-verify build-check wait-csv gateway-status

# Patch every workshop dashboard flag onto the OdhDashboardConfig. Run after
# the rhods-operator CSV reaches Succeeded (the dashboard creates the CR).
dashboard-flags:
	oc patch odhdashboardconfig odh-dashboard-config -n redhat-ods-applications \
		--type merge --patch-file $(CLUSTER_DIR)base/dashboard/dashboard-flags-patch.yaml

# Create the MaaS DB secrets imperatively (they must not live in git).
# Idempotent: skips secrets that already exist.
maas-secrets:
	@if oc get secret postgres-creds -n redhat-ods-applications >/dev/null 2>&1; then \
		echo "postgres-creds exists — skipping"; \
	else \
		POSTGRES_PASSWORD=$$(openssl rand -base64 16 | tr -d '=+/'); \
		oc create secret generic postgres-creds -n redhat-ods-applications \
			--from-literal=POSTGRESQL_USER=maas \
			--from-literal=POSTGRESQL_PASSWORD="$$POSTGRES_PASSWORD" \
			--from-literal=POSTGRESQL_DATABASE=maas; \
		oc create secret generic maas-db-config -n redhat-ods-applications \
			--from-literal=DB_CONNECTION_URL="postgresql://maas:$$POSTGRES_PASSWORD@postgres:5432/maas?sslmode=disable"; \
	fi

# Enable the serving runtimes the labs use by creating them from their
# templates (what the dashboard "Settings → Serving runtimes" toggle does).
# On 3.5.1 fresh installs NO ServingRuntimes are pre-installed — only the
# templates. This creates the GPU KServe runtime (vllm-cuda-runtime), the
# CPU-only x86 runtime (vllm-cpu-x86-runtime), and the multinode template
# variant. Idempotent (oc apply).
enable-serving-runtimes:
	@set -e; for t in vllm-cuda-runtime-template vllm-cpu-x86-runtime-template vllm-multinode-runtime-template; do \
		echo "== enabling $$t"; \
		oc process -n redhat-ods-applications "$$t" | oc apply -n redhat-ods-applications -f - ; \
	done

# Enable the pre-installed vLLM CPU ServingRuntime (cpu-config variant).
# NOTE: on 3.5.1 the runtime must be created from its template first (see
# enable-serving-runtimes); on IBM Z / Power the runtime name differs — list with:
#   oc get servingruntimes -n redhat-ods-applications
enable-cpu-runtime:
	oc patch servingruntime vllm-cpu-x86-runtime -n redhat-ods-applications \
		--type merge -p '{"spec":{"enabled":true}}'

# Wait for a CSV to reach Succeeded (used between the two apply steps).
# Usage: make wait-csv NS=openshift-lws-operator PREFIX=leader-worker-set
wait-csv:
	@until [ "$$(oc get csv -n $(NS) -o name 2>/dev/null | grep -c "$(PREFIX)")" -gt 0 ] && \
		[ "$$(oc get csv -n $(NS) -o jsonpath='{range .items[?(@.metadata.name.startsWith("$(PREFIX)"))]}{.status.phase}{end}')" = "Succeeded" ]; do \
		echo "waiting for $(PREFIX) CSV in $(NS) ..."; sleep 15; \
	done
	@echo "$(PREFIX) CSV Succeeded"

# Patch the gateway Services' status.loadBalancer.ingress with their Route
# hostnames. On clusters WITHOUT a cloud LB provider the LB services stay
# <pending> externally; feeding the Route hostname in makes the Gateway report
# Programmed=True and exposes the external URL in gateway.status.addresses.
# Run AFTER both routes exist (maas overlay apply).
gateway-status:
	export CLUSTER_DOMAIN=$$(oc get ingress.config cluster -o jsonpath='{.spec.domain}'); \
	for pair in maas-default-gateway-data-science-gateway-class:maas \
	          openshift-ai-inference-data-science-gateway-class:inference; do \
		svc=$${pair%%:*}; host=$${pair##*:}; \
		oc patch service "$$svc" -n openshift-ingress --subresource=status --type merge \
			-p "{\"status\":{\"loadBalancer\":{\"ingress\":[{\"hostname\":\"$$host.$${CLUSTER_DOMAIN}\"}]}}}" || true; \
	done

# Run the wait-for-ready checks against the cluster.
cluster-verify:
	bash $(CLUSTER_DIR)verify/cluster-verify.sh

# Render + kustomize-build every overlay to catch YAML/patch errors before apply.
build-check:
	@set -e; for d in $(CLUSTER_DIR)base $(CLUSTER_DIR)overlays/*/; do \
		echo "== $$d"; \
		if command -v kustomize >/dev/null 2>&1; then kustomize build "$$d" >/dev/null; \
		else oc kustomize "$$d" >/dev/null; fi; \
	done; echo "All overlays build cleanly."
