# qa/ — lab test harness

Runs the repo's workshop labs against a live cluster and tracks per-lab state.

## Cluster

Labs assume `KUBECONFIG=$HOME/.kube/config` unless already
set in the environment. `run-lab.sh` uses `KUBECONFIG` if exported, otherwise
falls back to that default.

## Running a single lab

```bash
qa/run-lab.sh <slug>                # run one lab end-to-end
qa/run-lab.sh <slug> --from NN      # resume from block NN (after a fix)
qa/run-lab.sh <slug> --list         # list the lab's execute blocks, run nothing
```

Examples:

```bash
qa/run-lab.sh mlflow-experiment-tracking
qa/run-lab.sh mlflow-experiment-tracking --from 11
qa/run-lab.sh mlflow-experiment-tracking --list
```

## Regenerating playbooks

Playbooks live in `qa/generated/<slug>.yml` and are extracted from each lab's
`.adoc` pages (`[source,bash,role="execute"]` blocks). Regenerate one lab
after editing its docs:

```bash
python3 qa/tools/extract-exec-blocks.py <slug>
```

Attributes are substituted at extraction time (`{guid}`=abc123, `{user}`=user1,
`{rhoai_version}`=3.5, `{openshift_*}` from the cluster). Skip rules follow the
e2e.yml conventions: `oc login`, disconnected module 2, "(Optional)"/"Cleanup"
exercises, read-only `cat`/`ls`, and watch commands (replaced with polling).

## State tracking

- `qa/status.yml` — per-lab state: `pending` / `pass` / `fail` / `observe-only`.
  Updated automatically by `run-lab.sh` on completion; can also be set manually:

  ```bash
  qa/tools/update-status.sh <slug> <state>
  ```

- `qa/runs/<slug>/` — per-lab evidence:
  - `NN.log` — one log per execute block
  - `run.log` — full ansible output of the last run
  - `env`, `work/` — block environment and scratch space
  - `fixes.md` — diagnosed failures and fixes applied
