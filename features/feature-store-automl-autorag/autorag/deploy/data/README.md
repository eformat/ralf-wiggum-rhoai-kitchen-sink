# AutoRAG Data Side — cluster-qn8tx (p2w14-data wave)

Data-side setup for the AutoRAG stack: the FED-AURA document corpus + evaluation
dataset staged into the AutoRAG document bucket, and the S3 connection the AutoRAG
wizard's Knowledge setup selects. Companion to the p2w13 stack (project
`p2w13-autorag`, DSPA READY with `managedPipelines: {}`).

## Wizard validation (batch p2w14, session arcade-p2w14-wizard, found live)

The AutoRAG wizard's storage filter requires data key `AWS_DEFAULT_REGION` in
the S3 connection Secret: without it the Knowledge setup step renders
"Required key \"AWS_DEFAULT_REGION\" is not set in this secret : error status"
and Create run stays disabled. Applied additively:

    oc patch secret p2w14-data-s3-connection -n p2w13-autorag --type=merge \
      -p '{"stringData":{"AWS_DEFAULT_REGION":"us-east-1"}}'

`s3-connection.yaml` now ships the key; verified after the patch: the BFF
storage filter lists the secret with all 5 AWS_* keys and the wizard validation
clears (Create run gate reachable).

## Data files (provenance)

Fetched from https://github.com/suhasvkashyap/fed-aura-autorag-demo
(`git clone --depth 1` — FED-AURA demo, Suhas Kashyap's team repo; fictitious
entity "Fed Aura Capital Bank"). Local copies are committed under `data/` so
re-runs need no network:

| File | Role | Size |
|---|---|---|
| `data/fed-aura-capital-bank-policy-compendium.md` | INPUT CORPUS — 6 European banking policies (DORA, MiFID II, CSRD, Third-Party ICT Risk, Risk Appetite, AML/KYC), 10,138 words | 68,927 B |
| `data/eval-dataset.json` | EVALUATION BENCHMARK — 25 question-answer pairs | 18,693 B |

The compendium embeds all 6 policies as one document, so the bucket layout stays a
single folder and every `correct_answer_document_ids` reference resolves to one file.

## Official test-data format (AutoRAG docs, Ch 2) and verification

The test data file must be a JSON array where each entry has:

- `question` — the question AutoRAG submits to each RAG configuration
- `correct_answers` — one or more expected answers (multiple phrasings help answer
  correctness evaluation)
- `correct_answer_document_ids` — **base file names** (no folder path, e.g.
  `policies.pdf` not `documents/policies.pdf`) that match the document set; used to
  prioritize sampling and evaluate context correctness

**Verification verdict (honest):** `data/eval-dataset.json` is fully compliant with
the Ch 2 contract — JSON array, 25 entries, exactly those three fields, valid JSON,
document IDs are base file names with no `/`, and the single referenced ID
(`fed-aura-capital-bank-policy-compendium.md`) matches the uploaded base file name
exactly. No transform was needed, so none was applied.

**Deltas (informational, not violations):** every entry carries exactly 1 phrasing in
`correct_answers` (contract requires "one or more" — satisfied) and 1 document ID.
Single-phrasing answers are within contract; multi-phrasing would only improve
correctness evaluation. AutoRAG auto-samples up to 1 GiB of relevant docs based on
test data — no pre-filtering of the bucket needed.

## Bucket layout (project p2w13-autorag, bucket `p2w13-autorag-pipelines`)

```
p2w13-autorag-pipelines/
└── fed-aura/
    ├── fed-aura-capital-bank-policy-compendium.md   INPUT CORPUS (68,927 B)
    └── eval-dataset.json                            EVAL BENCHMARK (18,693 B)
```

Single folder per the official Ch 3 rule ("if you store multiple documents in S3,
they are in a single folder"); the eval JSON lives in the same folder. The wizard's
evaluation dataset step accepts an S3 JSON file, and Knowledge setup accepts
Markdown (supported formats: PDF, DOCX, PPTX, Markdown, HTML, TXT; max 32 MiB per
uploaded file — both files are far under).

## Upload commands (repeatable)

One-shot (steps 1–4: prerequisites → port-forward + upload → connection → verify):

```bash
export KUBECONFIG=/home/mike/.kube/config.fde
./setup-data.sh            # add --dry-run to preview
```

Manual equivalent of step 2 (upload via boto3 — the p2w13 submit-stack precedent:
port-forward svc/s3 + s3v4 + path addressing_style; the `nb` CLI is absent):

```bash
oc port-forward svc/s3 6001:80 -n openshift-storage &
export AWS_ACCESS_KEY_ID="$(oc get secret noobaa-creds-p2w13 -n p2w13-autorag -o jsonpath='{.data.AWS_ACCESS_KEY_ID}' | base64 -d)"
export AWS_SECRET_ACCESS_KEY="$(oc get secret noobaa-creds-p2w13 -n p2w13-autorag -o jsonpath='{.data.AWS_SECRET_ACCESS_KEY}' | base64 -d)"
python3 upload-data.py --endpoint http://localhost:6001 --bucket p2w13-autorag-pipelines
```

`upload-data.py` uploads both files under `fed-aura/` and verifies with
`list_objects_v2` + byte sizes (exit 0 = verified).

## S3 connection (wizard's Knowledge setup → S3 connection select)

Manifest: `s3-connection.yaml` — Secret `p2w14-data-s3-connection` in project
`p2w13-autorag`, stringData:

- `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` — substituted at apply time from
  secret `noobaa-creds-p2w13` (envsubst in `setup-data.sh` step 3) — **no S3
  credential values are stored in this tree**
- `AWS_S3_ENDPOINT` — `http://s3.openshift-storage.svc:80`
- `AWS_S3_BUCKET` — `p2w13-autorag-pipelines`

**Kind note (honest):** neither `data-science-connection` nor `DataConnection` exists
on this build (`oc get crd | grep -i connection` → only `cephconnections.csi.ceph.io`).
The RHOAI Data Connection on this build is a Secret annotated
`opendatahub.io/connection-type: s3` — verified against the autorag-ui BFF binary,
which references that annotation and exactly these four `AWS_*` field names. The
wizard's Knowledge setup "S3 connection" dropdown lists this project's connection
secrets.

**Endpoint delta (honest):** the DSPA's external storage uses
`https://s3.openshift-storage.svc:443` (scheme https, secure true, cABundle empty).
This connection points at the same NooBaa S3 service over http port 80 to avoid
self-signed-TLS/CA issues for the wizard's bucket browse from any project pod.

## Directory contents / run order

```
deploy/data/
├── README.md          this file (format contract, verdicts, deltas)
├── setup-data.sh      run order 1..4 (prereqs → upload → connection → verify)
├── upload-data.py     boto3 uploader + list verification
├── s3-connection.yaml  Secret template (credential placeholders only)
└── data/
    ├── fed-aura-capital-bank-policy-compendium.md
    └── eval-dataset.json
```

## Verified state (2026-10-19 run)

- Bucket `p2w13-autorag-pipelines`: both objects present under `fed-aura/` with exact
  sizes (boto3 `list_objects_v2`) — 68,927 B compendium, 18,693 B eval dataset.
- Connection secret `p2w14-data-s3-connection` exists in `p2w13-autorag` with
  `connection-type: s3` annotation and the four `AWS_*` fields (values redacted).
- DSPA `p2w13-autorag` ObjectStoreAvailable=True (pre-existing, p2w13).

**Wizard prerequisites not covered here (honest):** the optimization run additionally
needs the OGX instance with foundation/embedding models, vLLM tool-calling model
args, a remote vector DB registered as vector I/O provider, and the OGX connection
in the project — handled separately (other agent owns OGX). AutoRAG is Technology
Preview in RHOAI 3.5.
