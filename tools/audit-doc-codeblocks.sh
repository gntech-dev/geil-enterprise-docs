#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
cd "$ROOT"

python3 - <<'PY'
from pathlib import Path
import re, sys, json

root = Path.cwd()
docs = root / "docs"
findings = []

CANONICAL_ALLOWED = (
    "corp.gntech.me", "gntech.me", "GNTECH", "HQ-DC01", "HQ-FW01",
    "172.20.", "172.31.255.", "GEILWAN", "GEILLAN", "WORKSTATIONS-HQ",
)
SUPERSEDED_PATH_HINTS = ("opnsense",)
IMPLEMENTATION_NAME_HINTS = (
    "implementation", "baseline", "foundation", "runbook", "golden-template",
    "nps-radius", "ad-cs-pki", "windows-admin-center", "entra", "intune",
    "hello", "defender", "backup", "monitoring", "security-operations",
)
REQUIRED_SECTIONS = (
    "Goal", "Why", "Prerequisites", "Starting state", "Commands", "Validation",
    "Expected", "Rollback", "Evidence", "Next",
)

def add(path, line, code, message):
    findings.append({"file": str(path.relative_to(root)), "line": line, "code": code, "message": message})

def line_no(text, idx):
    return text[:idx].count("\n") + 1

def code_blocks(text):
    for m in re.finditer(r"```([^\n`]*)\n(.*?)\n```", text, re.S):
        lang = (m.group(1) or "").strip().lower()
        yield m, lang, m.group(2)

def is_impl(path, text):
    rel = str(path.relative_to(docs)).lower()
    if any(part in rel for part in ("governance/", "project/", "architecture/", "index.md")) or rel.endswith("-lld.md") or rel.endswith("powershell-operations.md"):
        return False
    return (
        "## Step-by-Step Procedure" in text or
        "## Deployment Validation" in text or
        any(h in rel for h in IMPLEMENTATION_NAME_HINTS)
    )

def meaningful_active_opnsense_line(rel, line):
    low = line.lower()
    if any(h in rel.lower() for h in SUPERSEDED_PATH_HINTS):
        return False
    if any(w in low for w in ("superseded", "historical", "adr-0002", "replaced", "do not use", "not active", "no active", "obsolete", "alternative", "drift")):
        return False
    if "mikrotik" in low and "opnsense" in low:
        return False
    return True

def check_powershell_regex(path, text, block, start_line):
    # Detect obvious malformed regex literals in -match / -notmatch single or double quoted strings.
    for i, line in enumerate(block.splitlines(), start_line):
        if "-match" not in line and "-notmatch" not in line:
            continue
        for rx in re.findall(r"-(?:not)?match\s+['\"]([^'\"]+)['\"]", line):
            try:
                re.compile(rx)
            except re.error as exc:
                add(path, i, "PS001", f"Invalid PowerShell regex literal '{rx}': {exc}")

def check_fragmented_if_else(path, text):
    blocks = list(code_blocks(text))
    for idx, (m, lang, block) in enumerate(blocks[:-1]):
        if lang not in ("powershell", "ps1", ""):
            continue
        after = text[m.end():blocks[idx+1][0].start()]
        if re.search(r"^\s*else\b", after, re.M):
            add(path, line_no(text, m.start()), "PS003", "Fragmented interactive PowerShell if/else block; publish a complete executable block.")

def check_routeros_order(path, text):
    for m, lang, block in code_blocks(text):
        if lang != "routeros":
            continue
        start = line_no(text, m.start())
        lines = block.splitlines()
        seen_interface_list = set()
        seen_bridge = set()
        seen_vlan = set()
        for off, line in enumerate(lines):
            stripped = line.strip()
            if "/interface list add" in stripped and "name=" in stripped:
                name = re.search(r"name=([^\s]+)", stripped)
                if name: seen_interface_list.add(name.group(1))
            if "/interface bridge add" in stripped and "name=" in stripped:
                name = re.search(r"name=([^\s]+)", stripped)
                if name: seen_bridge.add(name.group(1))
            if "/interface vlan add" in stripped and "name=" in stripped:
                name = re.search(r"name=([^\s]+)", stripped)
                if name: seen_vlan.add(name.group(1))
            if "/interface vlan print" in stripped and "name=" in stripped:
                name = re.search(r"name=([^\s]+)", stripped)
                if name: seen_vlan.add(name.group(1))
            if "/interface list member add" in stripped:
                lst = re.search(r"list=([^\s]+)", stripped)
                if lst and lst.group(1) not in seen_interface_list and f"/interface list add name={lst.group(1)}" not in text:
                    add(path, start+off, "ROS001", f"RouterOS interface-list member references list before documented creation: {lst.group(1)}")
            if "/ip dhcp-relay add" in stripped:
                iface = re.search(r"interface=([^\s]+)", stripped)
                if iface and iface.group(1).startswith("vlan") and iface.group(1) not in seen_vlan and f"name={iface.group(1)}" not in text:
                    add(path, start+off, "ROS002", f"DHCP relay references VLAN interface before documented creation: {iface.group(1)}")

def check_text(path, text):
    rel = str(path.relative_to(root))
    if is_impl(path, text):
        if "## Deployment Verified" not in text:
            add(path, 1, "DQI001", "Implementation guide is missing mandatory 'Deployment Verified' section.")
    # active OPNsense references only; superseded/historical lines are allowed.
    for n, line in enumerate(text.splitlines(), 1):
        if "OPNsense" in line and meaningful_active_opnsense_line(rel, line):
            add(path, n, "ENV001", "Potential active obsolete OPNsense deployment reference; active Phase 1 must use MikroTik CHR unless explicitly superseded/historical.")
        if re.search(r"\b10\.10\.\d+\.\d+\b", line) and "existing" not in line.lower() and "non-geil" not in line.lower() and "do not" not in line.lower():
            add(path, n, "ENV002", "Legacy 10.10.x.x enterprise reference without explicit non-GEIL/historical context.")
    if re.search(r"Get-AD\w+\s+-Filter\s+['\"][^'\"\n]*\s-in\s", text):
        add(path, 1, "AD001", "Invalid AD -Filter expression uses PowerShell-style -in. Use LDAPFilter loop or valid AD filter syntax.")
    if re.search(r"Get-ADOrganizationalUnit\s+-Identity\s+\$", text):
        add(path, 1, "AD002", "Potential OU existence check with Get-ADOrganizationalUnit -Identity. Use parent validation plus LDAPFilter/OneLevel for missing OUs.")
    if "VLAN30-Workstations" in text:
        add(path, 1, "NAME001", "Potential DHCP scope name mismatch: use canonical WORKSTATIONS-HQ.")
    # Duplicate headings can create unstable anchors; ignore repeated low-level generic words in non-implementation refs only if same exact full heading.
    headings = {}
    for m in re.finditer(r"^(#{2,6})\s+(.+)$", text, re.M):
        h = re.sub(r"\s+¶$", "", m.group(2).strip())
        key = (len(m.group(1)), h.lower())
        headings.setdefault(key, []).append(line_no(text, m.start()))
    for (level, h), lines in headings.items():
        if len(lines) > 1 and not h.startswith(("goal —", "commands —", "rollback —", "expected result —", "validation —", "if validation fails —")):
            add(path, lines[1], "MD001", f"Duplicate heading may create duplicate anchors: '{h}'")

def check_blocks(path, text):
    check_fragmented_if_else(path, text)
    check_routeros_order(path, text)
    for m, lang, block in code_blocks(text):
        start = line_no(text, m.start())
        if lang in ("powershell", "ps1"):
            check_powershell_regex(path, text, block, start)
            if re.search(r"Get-AD\w+\s+-Filter\s+['\"][^'\"\n]*\s-in\s", block):
                add(path, start, "AD001", "Invalid AD -Filter expression uses PowerShell-style -in. Use LDAPFilter loop or valid AD filter syntax.")
            if re.search(r"Read-Host(?![^\n]*-AsSecureString)", block) and re.search(r"Password|credential|secret", block, re.I):
                add(path, start, "PS002", "Password/secret prompt lacks -AsSecureString.")

for path in sorted(docs.rglob("*.md")):
    text = path.read_text(encoding="utf-8", errors="ignore")
    check_text(path, text)
    check_blocks(path, text)

if findings:
    print("GEIL documentation code-block audit FAILED")
    for f in findings:
        print(f"{f['file']}:{f['line']} [{f['code']}] {f['message']}")
    print(json.dumps({"finding_count": len(findings)}, indent=2))
    sys.exit(1)

print(json.dumps({
    "status": "PASS",
    "markdown_files_audited": len(list(docs.rglob('*.md'))),
    "finding_count": 0
}, indent=2))
PY
