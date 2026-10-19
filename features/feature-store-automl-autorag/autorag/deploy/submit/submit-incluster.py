import kfp
from kfp import dsl, compiler

# Notebook image DELTA (batch p2w14, 2026-10-19): upstream
# registry.redhat.io/rhoai/odh-generic-data-science-notebook is NOT authorized
# with this cluster's pull secret ("unauthorized: access to the requested
# resource is not authorized" — pipelines repos ARE pullable, this notebook
# repo is not). The platform imports the workbench image into the
# CLUSTER-INTERNAL registry as ImageStream s2i-generic-data-science-notebook
# (redhat-ods-applications, tags 2025.1/2025.2/3.4/3.5) — pull that internal
# image instead (live-verified pullable from p2w13-autorag with the default SA).
@dsl.component(base_image="image-registry.openshift-image-registry.svc:5000/redhat-ods-applications/s2i-generic-data-science-notebook:3.5")
def hello_mlflow():
    import os
    for k in sorted(os.environ):
        if "MLFLOW" in k or "MLMD" in k or "KFP" in k:
            print("ENV", k, "=", os.environ.get(k))
    import mlflow
    print("tracking uri:", os.environ.get("MLFLOW_TRACKING_URI"))
    with mlflow.start_run():
        mlflow.log_param("greeting", "hello")
        mlflow.log_metric("metric1", 1.0)
    print("mlflow logging done")

@dsl.pipeline(name="p2w13-autorag-hello")
def p2w13_autorag_hello():
    hello_mlflow()

compiler.Compiler().compile(p2w13_autorag_hello, "/tmp/hello.yaml")
print("compiled")

kfp_client = kfp.Client(
    host="https://ds-pipeline-p2w13-autorag.p2w13-autorag.svc.cluster.local:8443",
    existing_token=open("/var/run/secrets/kubernetes.io/serviceaccount/token").read(),
    verify_ssl=False,
    namespace="p2w13-autorag",
)
run = kfp_client.create_run_from_pipeline_func(
    p2w13_autorag_hello,
    run_name="p2w13-autorag-hello",
)
print("run:", run.run_id)
