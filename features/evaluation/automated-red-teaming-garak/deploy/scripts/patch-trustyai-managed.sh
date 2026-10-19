#!/usr/bin/env bash
# Enable the TrustyAI component on DSC default-dsc (docs Prerequisites: trustyai Managed).
# Additive per-component merge patch — NEVER oc apply a DSC manifest (DSC v2 rejects
# strategic merge; a full manifest would clobber the 17-key component map).
set -euo pipefail
: "${KUBECONFIG:?export KUBECONFIG first}"
oc patch dsc default-dsc --type=merge -p '{"spec":{"components":{"trustyai":{"managementState":"Managed"}}}}'
oc get dsc default-dsc -o jsonpath='{.spec.components.trustyai.managementState}'; echo
