#!/usr/bin/env python3
"""Upload the FED-AURA data into the AutoRAG document bucket and verify it.

Target (cluster-qn8tx, p2w14-data wave):
  bucket p2w13-autorag-pipelines in project p2w13-autorag (DSPA external storage).

Bucket layout (official docs, Ch 3: multiple documents go in a single folder):
    fed-aura/fed-aura-capital-bank-policy-compendium.md   INPUT CORPUS
    fed-aura/eval-dataset.json                            EVALUATION BENCHMARK

Credentials are passed via the environment (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY)
by setup-data.sh — never printed, never stored in this file.

Repeatable run:
    python3 upload-data.py [--endpoint http://localhost:6001] [--bucket p2w13-autorag-pipelines]
Requires the port-forward from setup-data.sh step 2 (svc/s3 -> localhost:6001).
"""

import argparse
import os
import sys
from pathlib import Path

import boto3
from botocore.config import Config

# The two data files (base names must match correct_answer_document_ids in the
# evaluation dataset, which reference fed-aura-capital-bank-policy-compendium.md).
FILES = [
    "fed-aura-capital-bank-policy-compendium.md",
    "eval-dataset.json",
]
DEFAULT_PREFIX = "fed-aura/"


def client_for(endpoint: str):
    secure = endpoint.startswith("https")
    return boto3.client(
        "s3",
        endpoint_url=endpoint,
        aws_access_key_id=os.environ["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key=os.environ["AWS_SECRET_ACCESS_KEY"],
        verify=secure,  # http through the port-forward needs no TLS verify
        config=Config(
            signature_version="s3v4",
            retries={"max_attempts": 5},
            s3={"addressing_style": "path"},  # required for NooBaa via port-forward
        ),
    )


def main() -> int:
    here = Path(__file__).resolve().parent
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--endpoint", default="http://localhost:6001")
    ap.add_argument("--bucket", default="p2w13-autorag-pipelines")
    ap.add_argument("--prefix", default=DEFAULT_PREFIX)
    ap.add_argument("--data-dir", default=str(here / "data"),
                    help="dir containing the source data files (default: ./data)")
    args = ap.parse_args()

    data_dir = Path(args.data_dir)
    s3 = client_for(args.endpoint)

    missing = [f for f in FILES if not (data_dir / f).is_file()]
    if missing:
        print(f"ERROR: missing data files in {data_dir}: {missing}")
        return 1

    print(f"endpoint : {args.endpoint}")
    print(f"bucket   : {args.bucket}")
    print(f"prefix   : {args.prefix}")
    for name in FILES:
        src = data_dir / name
        key = f"{args.prefix}{name}"
        s3.upload_file(str(src), args.bucket, key)
        head = s3.head_object(Bucket=args.bucket, Key=key)
        print(f"uploaded : {key}  ({head['ContentLength']:,} bytes)")

    # Verification: list + sizes
    print("\nverification (list_objects_v2, prefix-filtered):")
    resp = s3.list_objects_v2(Bucket=args.bucket, Prefix=args.prefix)
    found = {obj["Key"]: obj["Size"] for obj in resp.get("Contents", [])}
    for name in FILES:
        key = f"{args.prefix}{name}"
        if key in found:
            print(f"  OK {key}  {found[key]:,} bytes")
        else:
            print(f"  MISSING {key}")
            return 2
    print(f"\n{len(found)} object(s) under {args.prefix} — all expected files present")
    return 0


if __name__ == "__main__":
    sys.exit(main())
