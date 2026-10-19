#!/usr/bin/env bash
# Enable the TrustyAI component (deploys the TrustyAI operator + EvalHub CRD).
# DSC changes: oc patch --type=merge per component ONLY — never oc apply a DSC
# manifest (clobbers sibling components on shared clusters).
set -euo pipefail
export KUBECONFIG=/home/mike/.kube/config.fde
echo "--- DSC trustyai before:"
oc get dsc default-dsc -o jsonpath='{.spec.components.trustyai}{"\n"}'
oc patch dsc default-dsc --type=merge \
  -p '{"spec":{"components":{"trustyai":{"managementState":"Managed"}}}}'
echo "--- DSC trustyai after:"
oc get dsc default-dsc -o jsonpath='{.spec.components.trustyai}{"\n"}'
