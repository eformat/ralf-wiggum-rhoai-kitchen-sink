---
name: ralf-wiggum-loop
description: >
  Iterate over the RHOAI feature matrix and scaffold or enrich workshop content
  for every feature. Mode 1: bulk scaffold all unscaffolded features into Antora
  components. Mode 2: enrich a specific feature with real, tested exercises. Mode 3:
  version bump for a new RHOAI release (e.g. 3.6). Use when asked to "run the ralf
  wiggum loop", "scaffold all features", "bulk scaffold", "enrich feature X",
  "bump to 3.6", or "kitchen sink loop".
---

# Ralf Wiggum Loop

Drive workshop generation for every active RHOAI feature listed in
`feature-matrix.yml` (source: https://micytao.github.io/rhoai-version-tracker/matrix.html).
Deprecated features are excluded; GA, TP, and DP are all covered.

The loop is idempotent: it skips features already marked `scaffolded: true`, so it
can be re-run after each release or interruption.

## Mode 1: Bulk Scaffold

### 1. Read the matrix

Parse `feature-matrix.yml`. Filter to features where `scaffolded: false`.
Report: "N features to scaffold across M categories."

### 2. Scaffold each feature

For each unscaffolded feature, create
`features/<category-slug>/<feature-slug>/content/` with:

**antora.yml** — component descriptor:

```yaml
name: <feature-slug>
title: "<Feature Name>"
version: ~
nav:
  - modules/ROOT/nav.adoc

asciidoc:
  attributes:
    source-highlighter: highlight.js
    experimental: true
    page-pagination: true
    rhoai_version: "3.5"
    feature_maturity: "<GA|TP|DP>"
    lab_name: "<Feature Name> Workshop"
    guid: abc123
    user: user1
    password: "%password%"
    openshift_api_url: "https://api.cluster.example.com:6443"
    openshift_console_url: https://console-openshift-console.apps.cluster.example.com
    openshift_cluster_ingress_domain: apps.cluster.example.com
```

`version: ~` is required — the RHDP theme's pagination nav breaks with fixed versions.

**modules/ROOT/nav.adoc** — link index, getting-connected, all modules, conclusion
under dot-prefixed headers (`.Workshop`, `.Modules`, `.Wrap-up`).

**modules/ROOT/pages/index.adoc** — welcome page:

- Title with maturity banner via `ifeval` on `feature_maturity`:

```asciidoc
ifeval::["{feature_maturity}" == "TP"]
WARNING: This feature is a *Technology Preview*. Technology Preview features are
not supported with Red Hat production service-level agreements (SLAs) and might
not be functionally complete.
endif::[]

ifeval::["{feature_maturity}" == "DP"]
WARNING: This feature is a *Developer Preview*. Developer Preview features are
provided as-is with no support and no guarantee of future availability.
endif::[]
```

- What you will learn (from the feature's `description` + `tags`)
- Prerequisites (from the feature's `prerequisites`)
- Estimated time

**modules/ROOT/pages/getting-connected.adoc** — login, project setup, environment
verification, using `{openshift_api_url}` / `{openshift_console_url}` attributes.

**modules/ROOT/pages/module-01-<topic>.adoc … module-N** — one stub per
`modules_estimate`. Maturity determines depth:

| Maturity | Content pattern |
|----------|----------------|
| GA | Full exercises with `[source,bash,role="execute",subs="attributes"]` blocks, `=== Verify` sections, complete module flow |
| TP | Full exercises + TP disclaimers + notes about possible API changes between releases |
| DP | Guided tour — more descriptive, fewer execute blocks, focused on showing what the feature does |

Each module page follows the zt-rhaibu structure (see
`~/git/zt-rhaibu/skills/docs/WORKSHOP-COMMON-RULES.md`): title with
`:navtitle:`, learning objectives, numbered `== Exercise N:` sections with
execute-role code blocks, `=== Verify` after each exercise, `== Module summary`
with `**What you accomplished:**` (3 past-tense bullets), `**Key takeaways:**`
(3 present-tense bullets), `**Next steps:**` (prose).

Stub exercises use TODO comments marking where real commands/manifests go during
enrichment — but keep them buildable and plausible.

**modules/ROOT/pages/conclusion.adoc** — per-module summary, resources.

**modules/ROOT/assets/images/** — create the (empty) directory with a `.gitkeep`.

Then set `scaffolded: true` for that feature in `feature-matrix.yml`.

### 3. Regenerate the master playbook

After scaffolding, regenerate `site-<rhoai_version_nodot>.yml` (e.g. `site-35.yml`):
one content source per scaffolded feature, preserving the `home` component and
the `ui`/`asciidoc`/`antora`/`output` blocks:

```yaml
content:
  sources:
    - url: .
      start_path: home/content
    - url: .
      start_path: features/<category>/<slug>/content
    # ... one per scaffolded feature ...
```

Update the `site.yml` symlink to point at the current version's playbook.

### 4. Build and validate

`make build` — fix any Antora errors (duplicate component names, missing nav
files, broken xrefs) until the build is clean. Report the scaffold summary:
features scaffolded, categories covered, build result.

## Mode 2: Enrich a feature

Accept a feature slug. Run the full OODA pipeline against it:

1. Read the feature's stub content and its `feature-matrix.yml` entry.
2. Write real content: actual `oc` commands, real CRs and manifests, actual
   console navigation. Draw RHOAI domain knowledge from the
   `openshift-ai-3-3-expert` skill (closest available) and Red Hat docs at
   `https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/{rhoai_version}`.
3. Where version-specific behavior exists, use paired `ifeval` blocks:
   ```asciidoc
   ifeval::["{rhoai_version}" == "3.5"]
   ...3.5-specific command...
   endif::[]
   ```
   Version-specific manifests get `-35`/`-36` suffixes (pattern from
   `~/git/ph-deploy-configure-rhoai/manifests/`).
4. Build the site; verify the feature's pages render.
5. Set `enriched: true` in `feature-matrix.yml`.

Prioritize GA features first, then TP, then DP.

## Mode 3: Version bump (e.g. 3.5 → 3.6)

1. Check the feature tracker matrix for the new release. Create
   `feature-matrix-36.yml`: copy the current matrix, add net-new features
   (`scaffolded: false`), update maturity promotions (TP→GA etc.), drop
   deprecated features.
2. Create `site-36.yml` with `rhoai_version: "3.6"` and only the attributes
   that changed (pattern: `~/git/ph-deploy-configure-rhoai/site-35.yml`
   overriding `rhoai_version`, `maas_api_namespace`, `dsc_maas_condition`).
3. Add `build-36`/`serve-36` Makefile targets if not present.
4. Run Mode 1 against `feature-matrix-36.yml` to scaffold net-new features.
5. For changed behavior, add `ifeval` blocks and `-36`-suffixed manifests to
   existing features.
6. Update the `site.yml` symlink to `site-36.yml`.

## Conventions

- Slugs: lowercase, hyphenated, unique across the matrix, ≤40 chars.
- Every code block containing `{attributes}` uses `subs="attributes"`.
- Never hardcode secrets; use `%password%`-style placeholders resolved at deploy time.
- The catalog hub (`home` component) lists every feature with maturity badge and
  `xref:<slug>::index.adoc[...]` links — regenerate its tables after scaffolding.

## RAC Binding (Observe + Orient retrofit)

Every feature also has a Requirements-as-Code corpus at `rac/<feature-slug>/`
inside this monorepo — one `decided` corpus per feature (`decided init --key RHAIBU`).

Structure per corpus:

```
rac/<slug>/
  requirements/<slug>.md                  # workshop-level, [REQ-NNN] acceptance criteria
  requirements/<slug>-module-<NN>.md      # per-module, one per lab module, with ## Verified By pointing at the module page
  decisions/*.md                          # content-format + docs-first-enrichment + feature-specific
  designs/<slug>-architecture.md          # module flow, constraints, parameter inventory
  assets/observations-<slug>.md           # doc-derived observations (labeled as doc evidence, not UI evidence)
```

Rules learned from the pilot:

- Run `decided schema <type>` first; never invent sections or frontmatter fields.
- Link with bare artifact IDs only (one per line) — descriptive suffixes break resolution.
- `decided new` scaffolds the file; Read it before Writing full content.
- Do NOT use `Applies To` in decisions — decided existence-checks those paths from
  the corpus directory itself and cannot reach monorepo paths.
- Acceptance criteria are lifted from the lab's `=== Verify` sections (testable,
  doc-grounded) — do not invent criteria the content doesn't verify.
- Each corpus must pass `decided validate .` and `decided relationships . --validate` (exit 0).

Mode 3 (version bump) reads `rac/<slug>/designs/` for parameter inventory and
module flow when adding `ifeval` blocks for a new release. The pilot corpus is
`rac/llmd-core/` — use it as the template.

## Cluster Config Binding (Act phase for cluster setup)

The base RHOAI cluster configuration lives in `cluster/` (base + overlays +
`feature-overlays.yml`). It is the Act layer for "no cluster to run the labs
on": labs assume the state base + their mapped overlays provide.

- `cluster/feature-overlays.yml` maps every `feature-matrix.yml` slug to the
  overlays beyond base. When scaffolding a NEW feature (Mode 1) or enriching
  (Mode 2), check whether its cluster-side needs are covered: if not, add the
  feature to `features:` in `feature-overlays.yml` and the home hub
  `cluster-setup.adoc` mapping table — do not put base config into lab content.
- `cluster/README.md` documents the apply flow, two-step overlays, and ordering
  constraints; `make -C cluster cluster-verify` checks the state labs assume.
- Labs must NOT scaffold what `cluster/` already provides (operator, DSC
  components, dashboard flags, gateways). Per-lab CRs stay exercises.
- Mode 3 (version bump, e.g. 3.6): bump `cluster/base/operator/subscription.yaml`
  channel to `stable-3.6`, add `-36`-suffixed manifest variants where behavior
  changed, and update `feature-overlays.yml` (`rhoai_version`) — same two-tier
  pattern as the content. Check the RHBoK ≤1.3 Trainer-v2 constraint before
  bumping (see `cluster/overlays/distributed/dsc-patch.yaml`).
