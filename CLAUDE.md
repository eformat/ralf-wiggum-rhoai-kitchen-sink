# ralf-wiggum-rhoai-kitchen-sink

Monorepo holding a hands-on workshop for **every active feature in RHOAI**, organized
by epic with GA/TP/DP maturity badges. One Antora component per feature; a `home`
hub component catalogs them all.

## The Loop

The **ralf-wiggum-loop** skill (`.claude/skills/ralf-wiggum-loop/SKILL.md`) drives
everything. It reads `feature-matrix.yml` and operates in three modes:

- **Mode 1 — Bulk scaffold**: create a workshop component for every
  `scaffolded: false` feature, then regenerate `site-35.yml` and build.
- **Mode 2 — Enrich**: flesh out one feature with real commands, CRs, and tested exercises.
- **Mode 3 — Version bump**: on a new RHOAI release (e.g. 3.6), create
  `feature-matrix-36.yml` + `site-36.yml`, scaffold net-new features, add
  `ifeval` blocks where behavior changed.

The loop is idempotent — it skips `scaffolded: true` entries.

## Feature Matrix

`feature-matrix.yml` is the source of truth. Derived from
https://micytao.github.io/rhoai-version-tracker/matrix.html (GA, TP, DP for the
current release; deprecated excluded). Each entry: `slug`, `name`, `maturity`,
`scaffolded`, `enriched`, `modules_estimate`, `description`, `prerequisites`,
`version_introduced`, `tags`.

## Structure

```
feature-matrix.yml        ← drives the loop
site.yml → site-35.yml    ← symlink to current playbook
shared/                   ← supplemental-ui + inject-buttons.js (one copy, referenced by playbook)
home/content/             ← catalog hub component (incl. cluster-setup.adoc: cluster config + per-lab overlays)
features/<category>/<slug>/content/   ← one Antora component per feature
rac/<slug>/               ← one decided RAC corpus per feature (requirements, decisions, designs, observations)
cluster/                  ← base RHOAI cluster config (kustomize base + overlays)
```

## Cluster Config (Act phase)

`cluster/` holds the base RHOAI configuration the labs assume: `base/` +
fine-grained `overlays/` (serving, llmd, gpu-config, cpu-config, maas,
monitoring, gateway, trustyai, ogx, mcp, registry, mlflow, feature-store,
distributed, oidc) + `feature-overlays.yml` (feature → overlay map) +
`verify/cluster-verify.sh`. Every overlay includes base; stacking is
cumulative/idempotent. Apply flow, two-step overlays, and ordering constraints
(MaaS flip last, llamastackoperator Removed before ogx, RHBoK ≤1.3, no Service
Mesh) are documented in `cluster/README.md`. Labs do NOT scaffold base config —
per-lab CRs stay exercises. See the ralf-wiggum-loop skill (Cluster Config
Binding) for the loop rules.

## RAC (Observe + Orient)

Each feature has a `decided` RAC corpus at `rac/<slug>/` — the Observe + Orient
layers of the zt-rhaibu OODA pipeline, retrofitted from the enriched content.
Requirements lift acceptance criteria from the lab's `=== Verify` sections;
designs capture module flow + parameter inventory (Mode 3 consumes these on a
version bump). Every corpus passes `decided validate` and
`decided relationships --validate`. See the ralf-wiggum-loop skill for the full
RAC rules (pilot template: `rac/llmd-core/`).

## Versioning

Two-tier Antora attributes (pattern from `ph-deploy-configure-rhoai`):

- Tier 1: each feature's `content/antora.yml` sets base defaults
  (`rhoai_version: "3.5"`, `feature_maturity`).
- Tier 2: `site-36.yml` overrides only what changes for a new release.
- Content branches with `ifeval::["{rhoai_version}" == "3.5"] ... endif::[]`.
- Version-specific manifests use `-35`/`-36` suffixes.

## Builds

- `make build` / `make build-35` — build the full catalog to `www/`
- `make build-36` — build the 3.6 variant to `www-36/`
- `make serve` — build + serve on localhost:8887

## Patterns sourced from

- `~/git/zt-rhaibu` — OODA workshop factory; showroom structure, page
  conventions (`skills/docs/WORKSHOP-COMMON-RULES.md`)
- `~/git/ph-deploy-configure-rhoai` — ifeval versioning technique
- `~/git/zt-workbench-create-showroom` — antora.yml / site.yml / supplemental-ui exemplar
