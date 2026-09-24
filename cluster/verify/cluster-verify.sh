#!/usr/bin/env bash
# cluster/verify/cluster-verify.sh — wait-for-ready checks for the RHOAI
# workshop cluster configuration. Each check reports OK / FAIL / SKIP:
#   SKIP — the overlay owning the resource is not applied (marker absent)
#   FAIL — the overlay is applied but the expected state is not reached
# Base checks are mandatory; feature checks only fail when their overlay is applied.
#
# Usage: make cluster-verify   (or bash cluster/verify/cluster-verify.sh)
set -uo pipefail

OK=0; FAIL=0; SKIP=0
pass() { printf '  \033[32mOK\033[0m   %s\n' "$1"; OK=$((OK+1)); }
fail() { printf '  \033[31mFAIL\033[0m %s\n' "$1"; FAIL=$((FAIL+1)); }
skip() { printf '  \033[33mSKIP\033[0m %s\n' "$1"; SKIP=$((SKIP+1)); }

# exists <resource args...>
exists() { oc get "$@" >/dev/null 2>&1; }
# jp <jsonpath> <resource args...>
jp() { oc get "${@:2}" -o jsonpath="$1" 2>/dev/null; }
# csv_ok <namespace> <name-prefix> — 0 Succeeded, 1 not Succeeded, 2 not found
csv_ok() {
  local ns="$1" prefix="$2" names phase name
  names=$(oc get csv -n "$ns" -o name 2>/dev/null | grep "$prefix" || true)
  [ -z "$names" ] && return 2
  for name in $names; do
    phase=$(oc get "$name" -n "$ns" -o jsonpath='{.status.phase}' 2>/dev/null)
    if [ "$phase" != "Succeeded" ]; then return 1; fi
  done
  return 0
}
# dsc_managed <component> <expected>
dsc_managed() { [ "$(jp "{.spec.components.$1.managementState}" dsc default-dsc)" = "$2" ]; }
# gw_programmed <gateway-name>
gw_programmed() {
  [ "$(jp '{.status.conditions[?(@.type=="Programmed")].status}' gateway "$1" -n openshift-ingress)" = "True" ]
}

echo "== base =="
if ! exists namespace redhat-ods-operator; then
  fail "redhat-ods-operator namespace (apply cluster/base first)"
  echo; echo "Result: $OK ok, $FAIL failed, $SKIP skipped"; exit 1
fi
csv_ok redhat-ods-operator rhods-operator && pass "rhods-operator CSV Succeeded" \
  || { rc=$?; [ "$rc" -eq 2 ] && skip "rhods-operator CSV (not installed yet)" || fail "rhods-operator CSV not Succeeded"; }
dsci=$(jp '{.status.phase}' dscinitialization default-dsci)
[ "$dsci" = "Ready" ] && pass "DSCInitialization default-dsci Ready" || fail "DSCInitialization phase: ${dsci:-<none>}"
dsc=$(jp '{.status.phase}' dsc default-dsc)
[ "$dsc" = "Ready" ] && pass "DataScienceCluster default-dsc Ready" || fail "DataScienceCluster phase: ${dsc:-<none>}"
if exists odhdashboardconfig odh-dashboard-config -n redhat-ods-applications; then
  n=$(jp '{.spec.dashboardConfig.modelAsService}' odhdashboardconfig odh-dashboard-config -n redhat-ods-applications)
  [ "$n" = "true" ] && pass "dashboard flags patched" || fail "dashboard flags missing (make dashboard-flags)"
else skip "OdhDashboardConfig (dashboard not reconciled yet)"; fi

echo "== serving =="
if dsc_managed kserve Managed; then
  pass "kserve Managed"
  n=$(jp '{.items[*].metadata.name}' pods -n redhat-ods-applications | grep -c "kserve-controller-manager" || true)
  [ "$n" -gt 0 ] && pass "kserve controller pods present ($n)" || fail "no kserve controller pods in redhat-ods-applications"
else skip "kserve (overlays/serving not applied)"; fi

echo "== llmd =="
if exists gateway openshift-ai-inference -n openshift-ingress; then
  gw_programmed openshift-ai-inference && pass "openshift-ai-inference Gateway PROGRAMMED" \
    || fail "openshift-ai-inference Gateway not PROGRAMMED (LoadBalancer pending? external entry point?)"
else skip "openshift-ai-inference Gateway (overlays/llmd not applied)"; fi
if exists namespace openshift-lws-operator; then
  csv_ok openshift-lws-operator leader-worker-set && pass "LWS CSV Succeeded" || fail "LWS CSV not Succeeded"
  csv_ok openshift-jobset-operator jobset && pass "JobSet CSV Succeeded" || fail "JobSet CSV not Succeeded"
  if exists leaderworkersetoperators.operator.openshift.io cluster; then
    pass "LWS/JobSet activation CRs applied"
  else fail "activation CRs missing (oc apply -k cluster/overlays/llmd/activation)"; fi
else skip "serving-path operators (overlays/llmd not applied)"; fi

echo "== gpu-config / cpu-config =="
if exists namespace openshift-nfd; then
  csv_ok openshift-nfd nfd && pass "NFD CSV Succeeded" || fail "NFD CSV not Succeeded"
  # 3.5 ground truth: AcceleratorProfile replaced by HardwareProfile
  # (infrastructure.opendatahub.io/v1); fall back to the 2.x CRD check
  if exists hardwareprofile nvidia-gpu -n redhat-ods-applications; then
    pass "HardwareProfile nvidia-gpu exists (3.5 pattern)"
  elif exists acceleratorprofile nvidia-gpu -n redhat-ods-applications; then
    pass "AcceleratorProfile nvidia-gpu exists (2.x pattern)"
  else
    fail "GPU profile missing (HardwareProfile nvidia-gpu / AcceleratorProfile)"
  fi
  exists nodefeaturediscovery nfd-instance -n openshift-nfd \
    && pass "NodeFeatureDiscovery nfd-instance exists" \
    || fail "NodeFeatureDiscovery missing (oc apply -k cluster/overlays/gpu-config/activation)"
else skip "gpu-config (not applied)"; fi
if dsc_managed kserve Managed; then
  exists servingruntime vllm-cpu-x86 -n redhat-ods-applications \
    && pass "vLLM CPU ServingRuntime present" \
    || skip "vLLM CPU ServingRuntime not found (IBM Z/Power name may differ)"
else skip "cpu-config (kserve not enabled)"; fi

echo "== monitoring =="
if exists configmap cluster-monitoring-config -n openshift-monitoring; then
  grep -q "enableUserWorkload: true" <<< "$(jp '{.data.config\.yaml}' configmap cluster-monitoring-config -n openshift-monitoring)" \
    && pass "User Workload Monitoring enabled" || fail "cluster-monitoring-config lacks enableUserWorkload"
else skip "monitoring (not applied)"; fi
if exists namespace openshift-cluster-observability-operator; then
  csv_ok openshift-cluster-observability-operator cluster-observability \
    && pass "Cluster Observability Operator CSV Succeeded" || fail "COO CSV not Succeeded"
else skip "observability operators (not applied)"; fi

echo "== gateway =="
if exists subscription rhcl-operator -n openshift-operators; then
  csv_ok openshift-operators rhcl && pass "RHCL CSV Succeeded" || fail "RHCL CSV not Succeeded"
  if exists kuadrant kuadrant -n kuadrant-system; then
    k=$(jp '{.status.conditions[?(@.type=="Ready")].status}' kuadrant kuadrant -n kuadrant-system)
    [ "$k" = "True" ] && pass "Kuadrant Ready" || fail "Kuadrant not Ready"
  else fail "Kuadrant CR missing (oc apply -k cluster/overlays/gateway/activation)"; fi
else skip "gateway (not applied)"; fi

echo "== maas =="
if dsc_managed aigateway Managed; then
  pass "aigateway Managed (MaaS flipped)"
  if [ "$(jp '{.spec.components.aigateway.modelsAsAService.managementState}' dsc default-dsc)" = "Managed" ]; then
    pass "aigateway.modelsAsAService Managed"
  else fail "aigateway.modelsAsAService not Managed"
  fi
  gw_programmed maas-default-gateway && pass "maas-default-gateway PROGRAMMED" \
    || fail "maas-default-gateway not PROGRAMMED"
  t=$(jp '{.status.conditions[?(@.type=="Ready")].status}' tenant default-tenant -n models-as-a-service)
  [ "$t" = "True" ] && pass "default-tenant READY" || skip "default-tenant not READY yet (controller bootstraps it)"
  exists deploy postgres -n redhat-ods-applications && \
    oc rollout status deploy/postgres -n redhat-ods-applications --timeout=10s >/dev/null 2>&1 \
    && pass "MaaS PostgreSQL Available" || fail "MaaS PostgreSQL not Available"
  exists secret maas-db-config -n redhat-ods-applications \
    && pass "maas-db-config secret exists" || fail "maas-db-config secret missing (make maas-secrets)"
else skip "maas (not flipped)"; fi

echo "== component overlays =="
for comp in trustyai ogx mcplifecycleoperator modelregistry mlflowoperator feastoperator ray trainer trainingoperator; do
  dsc_managed "$comp" Managed && pass "$comp Managed" || skip "$comp (overlay not applied)"
done

echo
echo "Result: $OK ok, $FAIL failed, $SKIP skipped"
[ "$FAIL" -eq 0 ]
