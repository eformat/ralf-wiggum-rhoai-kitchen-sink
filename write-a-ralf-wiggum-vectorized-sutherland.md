# Ralf Wiggum Loop: RHOAI Kitchen Sink Workshop Catalog

## Context

RHOAI 3.5 has 55 active features (26 GA, 11 TP, 18 DP) across 11 categories. We need a workshop for each one, all scaffolded under a single monorepo at `~/git/ralf-wiggum-rhoai-kitchen-sink/`. The "ralf wiggum loop" is a Claude Code skill that iterates over a feature matrix and drives batch scaffolding, with version support for future releases (3.6+) baked in from day one.

The design reuses three proven patterns:
- **zt-rhaibu** OODA pipeline and showroom structure (3 repos per workshop, Antora/AsciiDoc)
- **ph-deploy-configure-rhoai** versioning (two-tier Antora attributes + `ifeval` conditionals)
- **p-zero-lessons** multi-component Antora catalog (one component per lesson, shared hub)

---

## Architecture: Category-Organized Multi-Component Antora Monorepo

```
ralf-wiggum-rhoai-kitchen-sink/
  CLAUDE.md                              # monorepo context & conventions
  feature-matrix.yml                     # machine-readable feature list (drives everything)
  site.yml -> site-35.yml               # symlink to current version
  site-35.yml                            # master Antora playbook (generated from matrix)
  Makefile                               # build-35, serve, clean, build-<slug>
  package.json                           # @antora/cli + @antora/site-generator
  .gitignore                             # node_modules/, www/, www-*/, .cache/

  shared/                                # one copy of shared assets
    supplemental-ui/
      css/site-extra.css
      js/buttons.js
      img/favicon.svg
      partials/head-meta.hbs, head-icons.hbs
    lib/inject-buttons.js

  home/content/                          # catalog hub component
    antora.yml                           # name: home
    modules/ROOT/
      nav.adoc
      pages/index.adoc                   # feature grid with maturity badges + xref links

  features/
    agents-mcp/
      ai-available-assets/content/       # one Antora component per feature
        antora.yml                       # name: ai-available-assets, feature_maturity: GA
        modules/ROOT/
          nav.adoc
          pages/index.adoc, getting-connected.adoc, module-01-*.adoc, conclusion.adoc
          assets/images/
      opencode-coding-agent/content/...
      mcp-lifecycle-operator/content/...
      ...
    distributed-training/
      kuberay/content/...
      kueue/content/...
      kubeflow-trainer-v2/content/...
    evaluation/...
    feature-store-automl-autorag/...
    guardrails/...
    mlops/...
    maas/...
    model-registry/...
    model-serving/...
    ogx/...
    platform-gateway/...

  .claude/skills/ralf-wiggum-loop/SKILL.md   # THE LOOP
```

---

## Key Design Decisions

### 1. Monorepo, not 55 repos
All features live under `features/<category>/<slug>/content/`. Each feature is its own Antora component (matching the p-zero-lessons pattern where each lesson is `name: <slug>`). A master `site-35.yml` registers all components as content sources.

### 2. feature-matrix.yml drives the loop
A YAML file at repo root lists all 55 features with: `slug`, `name`, `category`, `maturity` (GA/TP/DP), `scaffolded` (bool), `enriched` (bool), `modules_estimate`, `description`, `prerequisites`, `version_introduced`, `tags`. The loop reads this, filters to `scaffolded: false`, and scaffolds each one.

### 3. Version support via two-tier Antora attributes + ifeval
- **Tier 1**: Each feature's `antora.yml` sets base defaults including `rhoai_version: "3.5"`
- **Tier 2**: `site-36.yml` overrides only what changes for future versions
- **In content**: `ifeval::["{rhoai_version}" == "3.5"]` blocks for version-specific commands/manifests
- **Manifests**: version-suffixed files (`subscription-35.yaml`, `subscription-36.yaml`)

### 4. Maturity-driven content templates
Each feature's `antora.yml` sets `feature_maturity: GA|TP|DP`. Content templates use this:
- **GA**: Full hands-on exercises with `[source,role="execute"]` blocks and verify sections
- **TP**: Full exercises with TP disclaimer banner and notes about possible API changes
- **DP**: Lighter guided-tour — more descriptive, fewer execute blocks, focused on showing what the feature does

### 5. The loop is a Claude Code skill, not a shell script
Generating contextually appropriate module titles, learning objectives, and exercise stubs per feature requires Claude's intelligence. The skill reads `feature-matrix.yml`, scaffolds content for each unscaffolded feature, then regenerates `site-35.yml`.

---

## Implementation Sequence

### Phase 0: Monorepo Bootstrap

Create these files in the empty repo:

1. `git init`
2. **CLAUDE.md** — monorepo conventions, links to zt-rhaibu patterns, loop instructions
3. **feature-matrix.yml** — all 55 features with metadata (see slug table below)
4. **.gitignore** — `node_modules/`, `www/`, `www-*/`, `.cache/`
5. **package.json** — `@antora/cli`, `@antora/site-generator-default`
6. **shared/supplemental-ui/** — copy from `~/git/zt-workbench-create-showroom/content/supplemental-ui/`
7. **shared/lib/inject-buttons.js** — copy from `~/git/zt-workbench-create-showroom/content/lib/inject-buttons.js`
8. **home/content/** — catalog hub component (`antora.yml` + `nav.adoc` + `index.adoc`)
9. **Makefile** — `install`, `build`/`build-35`, `serve`, `clean` targets (port 8887)
10. **site-35.yml** — initial playbook with just `home` component
11. **.claude/skills/ralf-wiggum-loop/SKILL.md** — the loop skill

### Phase 1: Bulk Scaffold (first loop run)

The ralf wiggum loop skill does this for each unscaffolded feature:

1. Create `features/<category>/<slug>/content/antora.yml`:
   ```yaml
   name: <slug>
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

2. Create `nav.adoc`, `index.adoc` (with maturity banner), `getting-connected.adoc`, `module-01` through `module-N` stubs, `conclusion.adoc`

3. Mark `scaffolded: true` in feature-matrix.yml

4. After all features: regenerate `site-35.yml` with all 55 content sources, rebuild

### Phase 2: Catalog Hub

Build the `home` component's `index.adoc` as a feature grid:
- Organized by category with maturity badges
- Each entry xrefs to its component: `xref:<slug>::index.adoc[Feature Name]`

### Phase 3: Iterative Enrichment (ongoing, per-feature)

For priority features (GA first), run Mode 2 of the loop:
- Use zt-rhaibu's `workshop-orient` patterns to write real requirements
- Write real exercises, real `oc` commands, real manifests
- Test with Playwright via `workshop-act` patterns
- Mark `enriched: true`

### Phase 4: Version Bump (when 3.6 drops)

1. Create `feature-matrix-36.yml` — add new features, update maturity promotions
2. Create `site-36.yml` with `rhoai_version: "3.6"` override
3. Add `ifeval` blocks where 3.6 behavior differs
4. Run the loop for net-new 3.6 features
5. Update symlink: `site.yml -> site-36.yml`

---

## Feature Matrix: Complete Slug Table (55 features)

| Category | Feature | Slug | Maturity |
|----------|---------|------|----------|
| agents-mcp | AI Available Assets page | `ai-available-assets` | GA |
| agents-mcp | Automated tool-calling eval-data gen for MCP servers | `automated-tool-calling-eval` | GA |
| agents-mcp | OpenCode coding-agent deployment | `opencode-coding-agent` | TP |
| agents-mcp | Validated tool-calling config in Model Catalog | `validated-tool-calling-config` | TP |
| agents-mcp | MCP Catalog support-tier labeling | `mcp-catalog-support-tier` | TP |
| agents-mcp | MCP Lifecycle Operator | `mcp-lifecycle-operator` | TP |
| agents-mcp | MCP gateway Operator | `mcp-gateway-operator` | TP |
| agents-mcp | OGX-native agentic API surface | `ogx-agentic-api` | TP |
| agents-mcp | Agent Catalog in AI Hub | `agent-catalog-ai-hub` | DP |
| agents-mcp | CSV export for Model Catalog data | `csv-export-model-catalog` | DP |
| agents-mcp | Claude Code agent starter kit | `claude-code-starter-kit` | DP |
| agents-mcp | Gen AI Studio saved-agent configuration | `genai-studio-saved-agent` | DP |
| agents-mcp | Kale JupyterLab extension | `kale-jupyterlab` | DP |
| agents-mcp | MiDojo adversarial testing engine | `midojo-adversarial-testing` | DP |
| agents-mcp | OpenClaw agent starter kit | `openclaw-starter-kit` | DP |
| agents-mcp | OpenShell (secure agent sandboxing) | `openshell-agent-sandboxing` | DP |
| agents-mcp | Text-mode training for multimodal models | `text-mode-multimodal-training` | DP |
| agents-mcp | View running agent deployments | `view-agent-deployments` | DP |
| agents-mcp | MCP Catalog administrative interface | `mcp-catalog-admin` | DP |
| agents-mcp | OGX File Processors API | `ogx-file-processors` | DP |
| agents-mcp | OGX remote::anthropic and remote::gemini | `ogx-remote-providers` | DP |
| agents-mcp | External metering integration for MaaS | `external-metering-maas` | DP |
| agents-mcp | External metering per-user token usage | `external-metering-per-user` | DP |
| agents-mcp | Hierarchical KV Cache Tiering (llm-d) | `llmd-kv-cache-tiering` | DP |
| agents-mcp | Latency-aware routing for llm-d | `llmd-latency-routing` | DP |
| agents-mcp | LoRA-aware routing for llm-d | `llmd-lora-routing` | DP |
| distributed-training | KubeRay | `kuberay` | GA |
| distributed-training | Kueue | `kueue` | GA |
| distributed-training | Kubeflow Trainer v2 | `kubeflow-trainer-v2` | GA |
| evaluation | Automated Red Teaming (Garak) | `automated-red-teaming-garak` | GA |
| evaluation | EvalHub | `evalhub` | GA |
| feature-store-automl-autorag | Feature Store (Feast-based) | `feature-store-feast` | GA |
| feature-store-automl-autorag | AutoML | `automl` | TP |
| feature-store-automl-autorag | AutoRAG | `autorag` | TP |
| guardrails | NeMo Guardrails | `nemo-guardrails` | GA |
| guardrails | NeMo Guardrails + MCP Gateway integration | `nemo-guardrails-mcp-gateway` | TP |
| mlops | MLflow experiment tracking | `mlflow-experiment-tracking` | GA |
| maas | MaaS-specific external OIDC auth | `maas-oidc-auth` | GA |
| maas | Models-as-a-Service core | `maas-core` | GA |
| maas | Loki-based showback dashboards | `maas-loki-showback` | TP |
| maas | MaaS deployment with llm-d | `maas-llmd-deployment` | TP |
| maas | MaaS multi-tenancy | `maas-multi-tenancy` | TP |
| maas | Multi-provider API passthrough | `maas-multi-provider-passthrough` | TP |
| maas | vLLM deployment through MaaS | `maas-vllm-deployment` | TP |
| model-registry | Model registry and model catalog | `model-registry-catalog` | GA |
| model-serving | Distributed Inference with llm-d (core) | `llmd-core` | GA |
| model-serving | llm-d priority-based flow control | `llmd-priority-flow-control` | GA |
| model-serving | LLMInferenceService / LLMInferenceServiceConfig | `llminferenceservice-config` | GA |
| model-serving | Red Hat AI Inference fast-release images | `rhai-fast-release-images` | GA |
| model-serving | vLLM CPU ServingRuntime on IBM Z / Power | `vllm-cpu-ibm-z-power` | GA |
| model-serving | vLLM ServingRuntime for KServe | `vllm-serving-runtime-kserve` | GA |
| ogx | Llama Stack / OGX core | `llama-stack-ogx-core` | GA |
| platform-gateway | Gateway API and RHCL | `gateway-api-rhcl` | GA |
| platform-gateway | Platform-wide direct OIDC authentication | `platform-oidc-auth` | GA |

---

## Critical Files to Create/Modify

| File | Purpose |
|------|---------|
| `feature-matrix.yml` | Machine-readable feature list; drives the loop |
| `.claude/skills/ralf-wiggum-loop/SKILL.md` | The loop skill itself |
| `site-35.yml` | Master Antora playbook (generated from matrix) |
| `CLAUDE.md` | Monorepo context, conventions, versioning rules |
| `Makefile` | Build targets (`build-35`, `serve`, `clean`) |
| `package.json` | Antora dependencies |
| `shared/supplemental-ui/*` | Copied from zt-workbench-create-showroom |
| `shared/lib/inject-buttons.js` | Copied from zt-workbench-create-showroom |
| `home/content/*` | Catalog hub component |
| `features/<cat>/<slug>/content/*` | 55 feature workshop components (scaffolded by loop) |

Reuse from existing repos:
- **Supplemental UI + inject-buttons.js**: copy from `~/git/zt-workbench-create-showroom/content/supplemental-ui/` and `content/lib/`
- **Antora component template**: based on `~/git/zt-workbench-create-showroom/content/antora.yml`
- **Site playbook template**: based on `~/git/zt-workbench-create-showroom/site.yml`
- **Version override pattern**: based on `~/git/ph-deploy-configure-rhoai/site-35.yml`
- **Showroom page structure**: from `~/git/zt-rhaibu/skills/docs/WORKSHOP-COMMON-RULES.md`

---

## Verification

1. **Build test**: `make build-35` succeeds with zero Antora errors
2. **Serve test**: `make serve` at localhost:8887 shows the catalog hub with all 55 features linked
3. **Navigation test**: clicking a feature xref loads that feature's workshop with correct maturity banner
4. **Version test**: create a minimal `site-36.yml`, run `make build-36`, verify `ifeval` blocks switch correctly
5. **Loop idempotency**: re-running the loop with all features `scaffolded: true` makes no changes
