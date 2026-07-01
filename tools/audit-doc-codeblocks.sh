#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-.}"
python3 - "$ROOT" <<'PY'
from pathlib import Path
import re, sys
root=Path(sys.argv[1])
findings=[]
for path in (root/'docs').rglob('*.md'):
    lines=path.read_text(encoding='utf-8').splitlines()
    in_fence=False; lang=''; fence=[]; start=0
    for idx,line in enumerate(lines, start=1):
        if line.startswith('```'):
            if not in_fence:
                in_fence=True; lang=line[3:].strip().lower(); fence=[]; start=idx+1
            else:
                body='\n'.join(fence)
                rel=path.relative_to(root)
                if 'powershell' in lang or 'ps1' in lang:
                    checks=[
                        (r"-match '\\\(.*\)\$'", 'PS001', 'Fragile escaped group regex in permission validation.'),
                        (r"SamAccountName\s+-in", 'PS002', 'Invalid AD -Filter style using -in.'),
                        (r"Get-ADOrganizationalUnit\s+.*-Identity", 'PS003', 'Do not use Get-ADOrganizationalUnit -Identity for existence checks.'),
                        (r"Get-ADGroup\s+-Filter\s+'Name\s+-in", 'PS004', 'Invalid Get-ADGroup -Filter -in pattern.'),
                    ]
                    for pat,rule,msg in checks:
                        for m in re.finditer(pat, body):
                            line_no=start + body[:m.start()].count('\n')
                            findings.append((str(rel), line_no, rule, msg))
                if 'routeros' in lang:
                    pos=body.find('discover-interface-list=MGMT')
                    pos2=body.find('allowed-interface-list=MGMT')
                    positions=[p for p in [pos,pos2] if p>=0]
                    for p in positions:
                        if ('/interface/list/add name=MGMT' not in '\n'.join(lines[:idx-1]) and '/interface list add name=MGMT' not in '\n'.join(lines[:idx-1])):
                            findings.append((str(rel), start + body[:p].count('\n'), 'ROS001', 'MGMT list referenced before creation earlier in the document.'))
                in_fence=False; lang=''; fence=[]
            continue
        if in_fence:
            fence.append(line)
if findings:
    for f in findings:
        print(f"{f[0]}:{f[1]} {f[2]} {f[3]}")
    raise SystemExit(f"GEIL code block audit failed with {len(findings)} finding(s).")
print('GEIL code block audit passed. No known bad code patterns found.')
PY
