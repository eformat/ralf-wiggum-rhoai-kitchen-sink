---
schema_version: 1
id: RHAIBU-M33ESMN38B6C
type: requirement
---
# Module 02: Hands-on Exercise

## Problem

Learners need to work through the core Feature Store workflow end to end:
create a `FeatureStore` instance, initialize it with feature definitions via
`feast apply`, materialize features into the online store, and retrieve them
from a connected workbench. Without the hands-on pass, the registry/offline/
online split remains abstract.

## Requirements

- [REQ-021] Learner MUST be able to create a `FeatureStore` CR (`feast.dev/v1`) with `feastProject`, `feastProjectDir.git`, and the `feature-store-ui: enabled` label, then confirm `oc get feast` shows `Ready` and the `feast-` prefixed pod is `Running`
- [REQ-022] Learner MUST be able to exec into the online container (`oc exec -it deployments/<name> -c online`) and run `feast apply`, observing the `Created entity` / `Created feature view` output, then list objects with `feast entities list` and `feast feature-views list`
- [REQ-023] Learner MUST be able to materialize a time range with `feast materialize` (ISO 8601 timestamps) and run `feast materialize-incremental` without errors
- [REQ-024] Learner MUST be able to connect a workbench (Connected feature stores section), confirm the mounted config with `ls feast-configs/`, and retrieve features with `FeatureStore(fs_yaml_file=...)`, `get_online_features`, and a `curl` POST to the feature server REST API

## Success Metrics

Learner completes all four exercises with the documented expected output: the
instance is `Ready`, `feast apply` registers the tutorial objects, the
materialize progress bar completes, and both the SDK and REST retrieval return
the materialized feature values.

## Risks

- `feast apply` creates cloud infrastructure that may incur costs on non-local providers
- `feast apply` does not delete removed objects — `feast delete <object_name>` is required
- An empty online store at inference time is usually a missed materialization step

## Assumptions

- Learner has completed Module 01 (operator enabled, controller pod running)
- The tutorial feature repository in Git is reachable from the cluster

## Related Requirements

- RHAIBU-M33ESMMH5MB5

## Verified By

- features/feature-store-automl-autorag/feature-store-feast/content/modules/ROOT/pages/module-02-hands-on.adoc
