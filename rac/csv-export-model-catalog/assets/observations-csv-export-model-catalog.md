# Observations: CSV Export for Model Catalog Data (doc-derived)

## Summary

CSV export for Model Catalog data is a Developer Preview capability in RHOAI 3.5
that packages model catalog metadata as RFC 4180-compliant CSV via a standalone
Python CLI script. This observation document was produced from the official
RHOAI 3.5 product documentation (release notes; Working with the model catalog)
because no live demo cluster was available at authoring time. Every item below
is doc evidence, not UI evidence.

## Sources Analyzed

| # | Source (extracted text) | Section | Key Observations |
|---|--------------------------|---------|------------------|
| 1 | ai-available-assets-release-notes.txt | §4.2 3.5 EA2 Developer Preview features — CSV export for model catalog data | Standalone Python CLI script queries the Model Catalog REST API, paginates the full result set, produces RFC 4180-compliant CSV with all model metadata and custom properties |
| 2 | ai-available-assets-release-notes.txt | §4.2 (same entry) | Script requires Python 3.10+ with no additional dependencies; writes atomically to prevent partial output on failure |
| 3 | ai-available-assets-release-notes.txt | §4.2 (same entry) | Options: `--source` (filter by catalog source), `--limit` (output count), `--header` (authorization header); installation, authentication, and usage documented in the external *CSV Exporter for Model Catalog* guide |
| 4 | registry-working-with-model-catalog.txt | §2 Discover models in the model catalog | Dashboard navigation: `AI hub → Models → Catalog`; Catalog page shows model category, name, description, and labels such as task, license, provider; performance benchmark data for third-party validated models |
| 5 | registry-working-with-model-catalog.txt | §2 (categories) | Menu-bar categories: All models, Red Hat AI models, Red Hat AI validated models, Other/custom categories from administrator-configured catalog sources |
| 6 | registry-working-with-model-catalog.txt | §2 (search, filters, details) | Search by name/description/provider; filter by task, provider, license, language, tensor type; model details page shows model description, Model card information, and key model properties |

## User Flows

### Flow 1: Run the CSV export

1. **Confirm Python** — Python 3.10+, no additional dependencies (release notes §4.2)
2. **Install the script** — installation steps live in the external *CSV Exporter for Model Catalog* guide
3. **Run the export** — `--source`, `--limit`, `--header` options against the Model Catalog REST API
4. **Verify** — script exits without errors, reports the CSV path, and never leaves a partial file (atomic write)

### Flow 2: Validate the export

1. **Inspect the header row** — single line of comma-separated column names
2. **Check rows** — one row per model from the catalog result set; metadata plus custom properties present
3. **Check options respected** — rows match `--limit`, or the full result set; `--source` restricts to a single catalog source

### Flow 3: Locate the data being exported (doc-derived dashboard path)

1. **Open the catalog** — `AI hub → Models → Catalog` (model catalog docs §2)
2. **Browse categories and filters** — categories, search, task/provider/license/language/tensor-type filters
3. **Open a model details page** — description, Model card information, key model properties: the metadata the CSV export packages

## Features and Concepts

### OpenShift Platform
- RHOAI operator installed; model registry component enabled (catalog prerequisite)

### RHOAI / AI Platform
- Model Catalog in the AI hub (catalog sources, categories, validated-model benchmark data), Model Catalog REST API, standalone CSV export CLI script (Developer Preview)

### AI/ML Fundamentals
- Model metadata (description, provider, labels, model card, performance metrics, custom properties) as structured, exportable data

## Workshop Potential

- **Estimated modules**: 1 (guided tour: locate data → run export → validate CSV)
- **Target audience**: data scientists and AI engineers with OpenShift working knowledge
- **Prerequisite knowledge**: model catalog concepts, `oc` CLI basics, Python 3.10+
- **Estimated duration**: about 45 minutes
- **Cluster requirements**: RHOAI 3.5 installed with the Model Catalog accessible

## Open Questions

- Exact script name, installation steps, and authentication details come from the external *CSV Exporter for Model Catalog* guide, not the downloaded RHOAI documentation
- Model catalog page screenshot deferred to the Act phase on a live cluster
