---
name: ralf-wiggum-loop
description: >
  Iterate over the RHOAI feature matrix and scaffold or enrich workshop content
  for every feature. Mode 1: bulk scaffold all unscaffolded features into Antora
  components. Mode 2: enrich a specific feature with real, tested exercises. Mode 3:
  version bump for a new RHOAI release (e.g. 3.6). Mode 4: batch arcade demo
  production per feature as self-correcting sub-agents. Use when asked to "run the ralf
  wiggum loop", "scaffold all features", "bulk scaffold", "enrich feature X",
  "bump to 3.6", "arcade demo batch", or "kitchen sink loop".
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
  feature to `features:` in `feature-overlays.yml`, then run
  `make -C cluster lab-blocks` to regenerate the home hub
  `cluster-setup.adoc` per-lab blocks — do not put base config into lab content.
- `cluster/README.md` documents the apply flow, two-step overlays, and ordering
  constraints; `make -C cluster cluster-verify` checks the state labs assume.
- Labs must NOT scaffold what `cluster/` already provides (operator, DSC
  components, dashboard flags, gateways). Per-lab CRs stay exercises.
- Mode 3 (version bump, e.g. 3.6): bump `cluster/base/operator/subscription.yaml`
  channel to `stable-3.6`, add `-36`-suffixed manifest variants where behavior
  changed, and update `feature-overlays.yml` (`rhoai_version`) — same two-tier
  pattern as the content. Check the RHBoK ≤1.3 Trainer-v2 constraint before
  bumping (see `cluster/overlays/distributed/dsc-patch.yaml`).

## Mode 4: Arcade demo batch

Produce an interactive arcade demo (`arcade-demo` skill,
`~/.agents/skills/arcade-demo/`) for every feature in the batch, as
self-correcting sub-agents. Recipe and gotchas live in
`qa/arcade-demos-pilots-2026-10-15.md` (pilots complete, Mike-reviewed); demo
state is tracked in `qa/demo-status.yml` (`pending | pass | rebuild | blocked |
skip`), which makes the loop idempotent like Modes 1–3.

### 1. Orient — lock the batch list

Read `qa/demo-status.yml`; the batch is every feature marked `pending`. Verify
environment availability per feature against `qa/runs/<slug>/` and the cluster
(`KUBECONFIG=~/.kube/config.fde`): mark features whose env is broken
(catalog-flow features blocked on the lmg7d route-hairpin defect,
inference-dependent features with no model serving) as `blocked` with a reason
comment. Report: "N features to demo, M blocked."

### 2. Waves of sub-agents (3 per wave)

Each feature gets ONE sub-agent (agent type `general`) that owns the full
locked recipe: ENV → RECORD → AUTHOR → BUILD → VALIDATE → INTEGRATE. Spawn with
the subagent tool from the repo root; keep waves to 3 so cluster-side env
rebuilds stay serialized enough.

**Sub-agent prompt template** — include ALL of this:

```
Arcade demo for feature <slug> (ralf-wiggum-loop Mode 4).
session-tag: arcade-<batch>-<slug>-<unix-ts>     <- unique, never reused

Work in ~/git/ralf-wiggum-rhoai-kitchen-sink. Follow the locked recipe in
qa/arcade-demos-pilots-2026-10-15.md (steps 1-7 + gotchas 1-7). Quality recipe
overrides: RECORD with the playwright viewport resized to 1920x1080 BEFORE
video-start (ffprobe the webm — if it is smaller than 1920x1080, STOP and
re-record, never upscale); BUILD with mp4_to_demo.py DEFAULT lossless WebP at
native width (never --lossy); extract frames from the webm source.

MaaS gateway 4MiB hygiene (mandatory — see SKILL.md section):
- NEVER read a full-res image: downscale first
  (ffmpeg -i in.png -vf scale=640:-1 -q:v 5 out.jpg, read only the <=40KB jpg)
- <= 20 thumbnail reads this session; prefer text (ffmpeg cut reports,
  playwright JS-state assertions) over screenshots
- BEFORE each image read and after each recipe phase run:
    python3 qa/tools/session-guard.py --find-tag <session-tag> --check
  exit 0 -> proceed; exit 2 -> python3 qa/tools/session-guard.py --find-tag
  <session-tag> --strip (automatic), continue with thumbnails only; exit 3 ->
  strip, stop image reads, finish with text assertions
- never re-read a stripped placeholder — regenerate a downscaled thumbnail

Use your own named playwright session (-s=recording-<slug>), NEVER the default.
Login before recording starts; no credentials on screen. Final response: at
most 30 lines of text — artifact paths + verdicts only, NEVER base64 or
screenshots.
```

### 3. Between waves — orchestrator guard check

The orchestrator knows each child's sessionID (subagent tool result). After
each wave completes:

```bash
python3 qa/tools/session-guard.py check --session <child-id>
```

If a child returned an error or 500'd, run `--strip` on its session and continue
it with the subagent tool (pass its sessionID) and a short resumption note.
Never start the next wave with a child over the soft limit.

### 4. Update state + running list

After each wave: set the feature's state in `qa/demo-status.yml` (`pass` +
demo path, `skip` + reason, `blocked` + reason) and append one line per
completed demo to the running list at the bottom of `qa/demo-status.yml`.
Housekeeping per wave: close `-s=recording-*` playwright sessions, kill stray
http servers, scrub /tmp frame dirs.

## MaaS gateway 4MiB hygiene (all modes)

Any opencode session whose stored history exceeds 4 MiB fails every model call
with an empty-body HTTP 500 (RHOAIENG-99765 — the gateway's payload processor
has a hard-coded 4 MiB gRPC receive limit; the full history replays per
request). Images are the only realistic way to get there. Hard rules:

1. **Never `read` a full-res image.** Downscale first:
   `ffmpeg -i in.png -vf scale=640:-1 -q:v 5 out.jpg` (10–40 KB) and read only
   the JPEG. Full-res reads are 150–750 KB of base64 each and accumulate.
2. **Budget ~20 thumbnail reads per session.** With the 2.0 MiB soft limit that
   leaves ample margin for text history.
3. **Text before pixels.** ffmpeg cut/detect reports, playwright JS-state
   assertions (`getBoundingClientRect`, `classList`, `textContent`) over
   screenshots; screenshot only the 2–3 frames that genuinely need eyes.
4. **Guard before image reads in long sessions.**
   `qa/tools/session-guard.py --find-tag <tag> --check` → exit 0 proceed,
   exit 2 `--strip` then continue, exit 3 strip + no more images. The strip is
   fully automatic: one-shot backup to `/tmp/opencode/`, data: file items
   replaced by text placeholders pointing at the on-disk originals. Never
   re-read a placeholder — regenerate a downscaled thumbnail instead.
5. **Sub-agents return compact text.** Their final response lands in the
   orchestrator's history — never base64, never screenshots.

If RHOAIENG-99765 (product-side fix raising the gRPC receive limit) ever lands,
the guard simply never fires — keep it in place as a safety net either way.
