#!/usr/bin/env python3
"""Extract [source,bash,role="execute"] blocks from workshop labs into Ansible
playbooks, modeled on ph-deploy-configure-rhoai/qa-automation/e2e.yml.

Per lab: read nav.adoc for page order, walk each page, capture execute-role
code blocks, substitute antora attributes, skip Optional/Cleanup/read-only/
watch-only blocks, emit qa/generated/<slug>.yml.

Usage:
  extract-exec-blocks.py <slug>            # generate one lab's playbook
  extract-exec-blocks.py <slug> --print    # list blocks without writing
  extract-exec-blocks.py --all             # generate every lab
"""
import argparse
import glob
import json
import re
import subprocess
import sys
from pathlib import Path

import yaml

REPO = Path(__file__).resolve().parent.parent.parent
FEATURES = REPO / "features"
GENERATED = REPO / "qa" / "generated"

# Attribute defaults; dynamic ones are refreshed from the live cluster.
DEFAULT_ATTRS = {
    "guid": "abc123",
    "user": "user1",
    "rhoai_version": "3.5",
    "lab_name": "Workshop",
    "feature_maturity": "GA",
}
DYNAMIC_ATTRS = {
    "openshift_api_url": "oc get infrastructure cluster -o jsonpath='{.status.apiServerURL}'",
    "openshift_console_url": "oc get infrastructure cluster -o jsonpath='{.status.consoleURL}'",
    "openshift_cluster_ingress_domain": "oc get ingress.config cluster -o jsonpath='{.spec.domain}'",
}
# Attributes that are asciidoc prose references, not values to substitute.
PROSE_ATTRS = {"maas", "rhcl", "guid", "user"}

READ_ONLY = re.compile(r"^\s*(cat|ls|grep|head|tail|less|more|tree|find|echo|true|false|pwd)\b")
WATCH = re.compile(r"(^|\s)((oc|kubectl)\s+\S+.*\s-w(\s|$)|oc\s+logs\s+.*\s-f(\s|$)|^watch\s)")
LOGIN = re.compile(r"^\s*oc\s+login\b")
# Unresolved doc placeholders: <inference_endpoint_url>, <your-realm>, <tenant_name>
PLACEHOLDER = re.compile(r"<[a-z][a-z0-9_.-]*(\.[a-z0-9-]+)*( [a-z0-9_-]+)?>")
# RHDP-theme percent placeholders: %maas-api-key%, %model-name%
PERCENT_PLACEHOLDER = re.compile(r"%[a-z][a-z0-9-]*%")


def cluster_attrs():
    attrs = dict(DEFAULT_ATTRS)
    for name, cmd in DYNAMIC_ATTRS.items():
        try:
            val = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=15).stdout.strip()
            if val:
                attrs[name] = val
        except Exception:
            pass
    return attrs


def page_order(slug_dir: Path):
    """Pages in nav order."""
    nav = slug_dir / "content" / "modules" / "ROOT" / "nav.adoc"
    pages = []
    if nav.exists():
        for line in nav.read_text().splitlines():
            m = re.match(r"\*\s*xref:([^:\[\]]+)\.(adoc|html)\[", line.strip())
            if m:
                pages.append(m.group(1) + ".adoc")
    pages_dir = slug_dir / "content" / "modules" / "ROOT" / "pages"
    for p in sorted(pages_dir.glob("*.adoc")):
        if p.name not in pages:
            pages.append(p.name)
    return [pages_dir / p for p in pages]


def lab_attrs(slug_dir: Path):
    attrs = {}
    antora = slug_dir / "content" / "antora.yml"
    if antora.exists():
        doc = yaml.safe_load(antora.read_text()) or {}
        attrs.update((doc.get("asciidoc") or {}).get("attributes") or {})
    return {k: str(v) for k, v in attrs.items() if v is not None}


def extract_blocks(page: Path, attrs: dict):
    """Yield (ordinal_hint, title, script, skipped, reason) per execute block."""
    lines = page.read_text().splitlines()
    blocks = []
    in_block = False
    header = None
    role = False
    lang = "bash"
    buf = []
    skip_ctx = None  # reason string when inside an Optional/Cleanup section
    for line in lines:
        stripped = line.strip()
        # Exercise/section headings reset skip context
        m_head = re.match(r"^(=+)\s+(.*)$", stripped)
        if m_head and not in_block:
            level, title = m_head.group(1), m_head.group(2)
            if len(level) == 2:  # == Exercise N / == Verify
                if re.search(r"\(Optional\)|\(optional\)|Cleanup", title):
                    skip_ctx = title
                else:
                    skip_ctx = None
            header = title
        if re.match(r"^----\s*$", stripped):
            if in_block:
                script = "\n".join(buf).strip("\n")
                if role:
                    blocks.append((header or page.stem, script, skip_ctx, lang))
                in_block = False
                buf = []
                role = False
                lang = "bash"
            else:
                in_block = True
                buf = []
            continue
        if in_block:
            buf.append(line)
        else:
            m = re.match(r"^\[source,(\w+)(,[^\]]*)?\]", stripped)
            if m:
                lang = m.group(1)
                role = "execute" in (m.group(2) or "")
    out = []
    n = 0
    for title, script, skip_ctx, lang in blocks:
        n += 1
        # Substitute attributes
        def sub(m):
            key = m.group(1)
            return attrs.get(key, m.group(0))
        script = re.sub(r"\{([a-z_][a-z0-9_]*)\}", sub, script)
        # Filter watch lines
        kept = [l for l in script.splitlines() if not WATCH.search(l)]
        dropped_watch = len(kept) != len(script.splitlines())
        script = "\n".join(kept).strip("\n")
        # Skip rules
        reason = None
        if skip_ctx:
            reason = f"optional/cleanup section: {skip_ctx}"
        elif lang != "bash":
            reason = f"non-bash block ({lang}) — needs a workbench; resolve interactively"
        elif not script.strip():
            reason = "watch-only block"
        elif all(LOGIN.match(l) for l in script.splitlines() if l.strip() and not l.strip().startswith("#")):
            reason = "oc login (session authenticated via KUBECONFIG)"
        elif PLACEHOLDER.search(script):
            m = PLACEHOLDER.search(script)
            reason = f"unresolved placeholder {m.group(0)} — resolve interactively"
        elif PERCENT_PLACEHOLDER.search(script):
            m = PERCENT_PLACEHOLDER.search(script)
            reason = f"unresolved percent placeholder {m.group(0)} — resolve interactively"
        else:
            cmds = [l for l in script.splitlines() if l.strip() and not l.strip().startswith("#")]
            if cmds and all(READ_ONLY.match(c) for c in cmds):
                reason = "read-only block"
        out.append((n, title, script, reason, dropped_watch))
    return out


def task_yml(idx, page_name, title, script):
    desc = re.sub(r"[^A-Za-z0-9 _/.|-]", "", title)[:60].strip()
    # Collect export lines so later blocks can source them (blocks run in
    # separate shells; labs export vars in one block and use them in the next).
    # Multiline exports (trailing backslash continuations) are joined.
    lines = script.splitlines()
    export_lines = []
    i = 0
    while i < len(lines):
        l = lines[i]
        if re.match(r"^\s*export\s", l) or re.match(r"^\s*[A-Z_][A-Z0-9_]*=", l):
            full = l.rstrip()
            while full.endswith("\\") and i + 1 < len(lines):
                i += 1
                full = full[:-1].rstrip() + " " + lines[i].strip()
            export_lines.append(full)
        i += 1
    exports = "\n".join(export_lines)
    persist = ""
    if exports:
        persist = f"""        - name: "{idx:02d} | persist exports"
          ansible.builtin.shell: |
            cat > "{{{{ logdir }}}}/exports-{idx:02d}.sh" <<'QAENV'
{indent(exports, 12)}
            QAENV
            cat "{{{{ logdir }}}}/exports-{idx:02d}.sh" >> "{{{{ logdir }}}}/env"
          changed_when: false
"""
    return f"""    - block:
        - name: "{idx:02d} | {page_name} | {desc}"
          ansible.builtin.shell: |
            set -a
            [ -f "{{{{ logdir }}}}/env" ] && . "{{{{ logdir }}}}/env"
            set +a
{indent(script, 12)}
          args:
            executable: /bin/bash
            chdir: "{{{{ workdir }}}}"
          register: r{idx:02d}
          changed_when: false
          failed_when:
            - r{idx:02d}.rc != 0
            - "'AlreadyExists' not in (r{idx:02d}.stderr | default(''))"
            - "'already exists' not in (r{idx:02d}.stderr | default(''))"
            - "'NotFound' not in (r{idx:02d}.stderr | default(''))"
{persist}      always:
        - name: "{idx:02d} | save log"
          ansible.builtin.copy:
            content: |
              # {page_name} — {title}
              {{{{ r{idx:02d}.rc | default('?') }}}}
              {{{{ r{idx:02d}.stdout | default('') }}}}
              {{{{ r{idx:02d}.stderr | default('') }}}}
            dest: "{{{{ logdir }}}}/{idx:02d}.log"
"""


def indent(text, n):
    return "\n".join(" " * n + l if l.strip() else "" for l in text.splitlines())


def generate(slug, attrs, do_print=False):
    matches = list(FEATURES.glob(f"*/{slug}"))
    if len(matches) != 1:
        print(f"ERROR: slug '{slug}' matched {len(matches)} labs", file=sys.stderr)
        return 1
    slug_dir = matches[0]
    all_attrs = {**attrs, **lab_attrs(slug_dir)}
    # antora.yml sometimes uses placeholder attrs that must not override cluster values
    all_attrs["rhoai_version"] = attrs.get("rhoai_version", "3.5")

    blocks = []
    for page in page_order(slug_dir):
        for n, title, script, reason, dw in extract_blocks(page, all_attrs):
            blocks.append((page.name, title, script, reason, dw))

    skipped = [(p, t, r) for p, t, s, r, _ in blocks if r]
    runnable = [(p, t, s) for p, t, s, r, _ in blocks if not r]

    if do_print:
        for i, (p, t, s) in enumerate(runnable, 1):
            first = s.splitlines()[0][:80]
            print(f"{i:02d} | {p} | {t} | {first}")
        for p, t, r in skipped:
            print(f"-- | {p} | {t} | SKIP: {r}")
        return 0

    GENERATED.mkdir(parents=True, exist_ok=True)
    tasks = "".join(task_yml(i, p, t, s) for i, (p, t, s) in enumerate(runnable, 1))
    playbook = f"""# GENERATED by qa/tools/extract-exec-blocks.py — do not edit; re-run the extractor.
# Lab: {slug} ({len(runnable)} runnable blocks, {len(skipped)} skipped)
- name: "Lab {slug}"
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    workdir: "{{{{ playbook_dir }}}}/../runs/{slug}/work"
    logdir: "{{{{ playbook_dir }}}}/../runs/{slug}"
  environment:
    KUBECONFIG: "{{{{ lookup('env', 'KUBECONFIG') }}}}"
  tasks:
    - name: "prep workdir"
      ansible.builtin.file:
        path: "{{{{ item }}}}"
        state: directory
        mode: "0755"
      loop:
        - "{{{{ workdir }}}}"
        - "{{{{ logdir }}}}"
    - name: "prep env file"
      ansible.builtin.copy:
        content: ""
        dest: "{{{{ logdir }}}}/env"
        force: false
        mode: "0644"
{tasks}"""
    out = GENERATED / f"{slug}.yml"
    out.write_text(playbook)
    print(f"{slug}: {len(runnable)} runnable, {len(skipped)} skipped -> {out}")
    for p, t, r in skipped:
        print(f"  SKIP {p} | {t} | {r}")
    return 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("slug", nargs="?")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--print", action="store_true")
    args = ap.parse_args()
    attrs = cluster_attrs()
    if args.all:
        labs = sorted({d.name for d in (REPO / "rac").iterdir() if d.is_dir()})
        for lab in labs:
            generate(lab, attrs, args.print)
        return 0
    if not args.slug:
        ap.error("slug or --all required")
    return generate(args.slug, attrs, args.print)


if __name__ == "__main__":
    sys.exit(main())
