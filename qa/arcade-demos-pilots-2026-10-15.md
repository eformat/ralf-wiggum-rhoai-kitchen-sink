# Arcade demos — pilot phase complete (2026-10-15)

Phase 0 of the kitchen-sink arcade-demo plan: 2 pilots built end-to-end against
**cluster-lmg7d** (`KUBECONFIG=~/.kube/config.fde`, RHOAI 3.5.1 + MaaS) with the
`arcade-demo` skill (`~/.agents/skills/arcade-demo/`). Recipe locked; Mike to review.

## Pilots

| Feature | Demo | Recording | Cues | Player | Verified |
|---------|------|-----------|------|--------|----------|
| ai-available-assets | `ai-available-assets-demo.html` (0.26 MB) | 116s, console+dashboard before/after arc | 5 | lossy q90 | spotlight pixel-exact, stepping clean, console clean, loads from built site |
| maas-oidc-auth | `maas-oidc-auth-demo.html` (0.24 MB) | 109s, console CRD + Keycloak admin arc | 4 | lossy q90 | same |

- **ai-available-assets**: dashboard AI asset endpoints page (Models tab → empty MCP servers tab)
  → OpenShift console Import YAML (the workshop's `gen-ai-aa-mcp-servers` ConfigMap) → Create →
  dashboard refresh showing **GitHub-MCP-Server listed with Token Required status**. The demo's
  final frame was also extracted as `01-mcp-server-listed.png`, closing the stale
  `TODO(screenshot)` in module-01.
- **maas-oidc-auth**: console AITenant instances (models-as-a-service Ready) → AITenant YAML tab
  → Keycloak admin console (master realm → `keycloak` realm) → registered clients (idp-4-ocp).
  Pilot 2 pivot: validated-tool-calling-config was originally planned but the model catalog has
  an environment defect on lmg7d (below).

## Locked recipe (per feature)

1. **ENV** — verify/rebuild via the workshop's documented `cluster/` setup (additive only).
2. **RECORD** — dedicated `playwright-cli -s=recording` session (NEVER the default session —
   see gotchas), `video-start` → drive the flow → `video-stop` → `ffmpeg -c:v libopenh264
   -rc_mode quality -an -vf scale=1920:1080` webm→mp4 (no libx264 on this box).
3. **AUTHOR** — `<slug>-steps.json`, 5–14 cues `{t, target, caption, details}`; targets measured
   from grid-overlaid frame extracts (`drawgrid=w=100:h=100`), captions verified against the
   frames; timestamps confirmed with a `fps=1/6,scale=320,tile=5x4` thumbnail montage.
4. **BUILD** — `mp4_to_demo.py --video <mp4> --steps <steps.json> --lossy` (q90; ~0.25 MB/player;
   54 demos ≈ 12–15 MB total — fine as attachments).
5. **VALIDATE** — smoke test per the skill: spotlight lands on target, ArrowRight/Left/End/Home
   restore state exactly, console clean; visual screenshot check.
6. **INTEGRATE** — player → `features/<cat>/<slug>/content/modules/ROOT/attachments/<slug>-demo.html`;
   authoring source → `features/<cat>/<slug>/demos/<slug>-steps.json`; index.adoc gains
   `link:_attachments/<slug>-demo.html[▶ Watch the demo — interactive walkthrough,window=_blank]`.
7. **DEPLOY** — in-site: the showroom rebuilds from git (antora copies attachments). For review
   before commit: a preview app on the cluster (below).

## Gotchas learned (cost me real time — don't rediscover)

1. **Antora 3.1 + asciidoctor 2.2.9: `link:attachment$<file>` does NOT resolve** (emitted
   verbatim), and `modules/ROOT/_attachments/` is NOT scanned by the content classifier at all.
   The working path: file in `modules/ROOT/attachments/` (published to `www/<component>/_attachments/`)
   + relative link `link:_attachments/<file>` — deterministic because every page of a component
   is a sibling of `_attachments/` in the built site. Pass-through `+++` blocks aren't
   macro-resolved either, and `ifdef::backendhtml5[]` is a misspelling trap (`backend-html5`).
2. **The default playwright-cli session is the user's live browser panel** — navigation gets
   hijacked mid-flow (observed: session jumped to the confidential-agents demo on rhai-tmm.dev).
   Always use a dedicated `-s=recording` session for recordings and player tests.
3. **Console Import YAML**: paste via `window.monaco.editor.getModels()[0].setValue(yaml)` —
   then **wait ~2.5s** before clicking Create (React form state picks the value up late; clicking
   early silently does nothing, and a later click submits an EMPTY editor). First-ever console
   load shows welcome modals that swallow clicks — close them first
   (`.pf-v6-c-modal-box button[aria-label*="lose"]`).
4. **Keycloak creds on lmg7d**: the realm import Secret's `admin` password WORKS against the
   live realm (unlike cluster-44gxc where provisioning randomized it) — dashboard login OK. The
   Keycloak ADMIN console is a separate login: `temp-admin` from `keycloak-initial-admin`
   (master realm; `/admin/master/console/`, then Manage realms → keycloak — the
   `/admin/keycloak/console/` URL redirects to a realm-level login temp-admin can't pass).
5. **Environment defect (lmg7d, needs Mike/platform fix)**: the model-registry-ui pod dials the
   cluster's OWN route host (`rh-ai.apps.cluster-lmg7d...`) resolved to its EXTERNAL IP
   (148.62.104.205:443) and times out → dashboard Models catalog shows "Model catalog source
   load error" forever. Blocks recording any catalog-flow feature (validated-tool-calling-config,
   agent-catalog-ai-hub, csv-export-model-catalog, model-registry-catalog) until fixed.
6. **Deployment name on lmg7d is `rhods-dashboard`** (not `odh-dashboard`) — dashboard restart:
   `oc rollout restart deploy/rhods-dashboard -n redhat-ods-applications`. dashboardConfig flag
   changes need the restart; the Models→Catalog tab showed a transient load error right after
   restarting that cleared on reload.
7. **Image-read discipline (4MiB gateway limit)**: full-res reads accumulate in the session's
   stored history; this session read ~10 (grid frames/montages/validate screenshots, 150–340KB
   base64 each). Any further frame verification must use downscaled thumbnails
   (`ffmpeg scale=640:-1 -q:v 5`, 10–37KB) — the established repair playbook is in memory if it
   bites anyway.

## Environment changes on lmg7d (for review — additive/revertible)

- `redhat-ods-applications`: ConfigMap `gen-ai-aa-mcp-servers` (the workshop's exact resource —
  pilot 1's demonstrated outcome, left applied so the asset endpoints page keeps its state).
- `redhat-ods-applications`: OdhDashboardConfig `toolCalling: true` patch (validated-tool-calling
  pivot prep) + `rhods-dashboard` rollout restart. The catalog is still broken (defect 5) so this
  patch currently has no visible effect; left set (harmless, documented workshop step).
- Nothing deleted; no other resources touched.

## Next (Phase 1 batch)

- Mike reviews the 2 pilots (built site or cluster preview) → then batch features with working
  environments: MaaS suite (maas-core hands-on still needs a published model — none exist on
  lmg7d), dashboard features, mlflow-experiment-tracking (needs MLflow env re-run).
- Catalog-flow features wait on the lmg7d route-hairpin fix (defect 5).
- CLI features (midojo, metering, evalhub) become terminal recordings in Phase 3.
