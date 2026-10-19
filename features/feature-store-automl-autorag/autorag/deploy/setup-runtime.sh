#!/usr/bin/env bash
# Instantiate the pre-installed vLLM CPU (x86) ServingRuntime template into the
# AutoRAG project and stamp the template-origin annotations the dashboard expects.
#
# KServe resolves spec.predictor.runtime from the deployment's own namespace, so
# the runtime must exist in the project before the model ISVCs are applied.
#
# Run order: run this BEFORE models-toolcalling.yaml / embedding-model.yaml.
#
# Usage: KUBECONFIG=/path/to/kubeconfig ./setup-runtime.sh <project>
set -euo pipefail

PROJECT="${1:?usage: setup-runtime.sh <project>}"

echo ">> instantiating vllm-cpu-x86-runtime template into project ${PROJECT}"
oc process -n redhat-ods-applications vllm-cpu-x86-runtime-template \
  | oc apply -n "${PROJECT}" -f -

echo ">> stamping template-origin annotations"
oc annotate servingruntime vllm-cpu-x86-runtime -n "${PROJECT}" \
  opendatahub.io/template-name=vllm-cpu-x86-runtime-template \
  "opendatahub.io/template-display-name=vLLM CPU (x86) ServingRuntime for KServe" \
  --overwrite

echo ">> verify:"
oc get servingruntime vllm-cpu-x86-runtime -n "${PROJECT}"
