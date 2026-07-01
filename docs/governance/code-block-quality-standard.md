---
title: Code Block Quality Standard
document_id: GEIL-GOV-CODE-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# Code Block Quality Standard

## Purpose

This standard prevents broken copy/paste commands from being published in GEIL implementation, validation, and operations guides.

GEIL code blocks are treated as production code. A successful MkDocs build only proves that the documentation renders; it does not prove that PowerShell, RouterOS, Linux, Windows, or Proxmox commands are operationally correct.

## Mandatory rule

No implementation guide may be considered deployment-ready until every code block has passed:

- Syntax review.
- Dependency review.
- Execution-order review.
- Clean-environment mental deployment simulation.
- Idempotency review where practical.
- Rollback review.
- End-state validation review.
- Evidence review.

## Code block requirements

Every command block must be directly executable in the documented sequence. Illustrative examples are allowed only when they are commented out and clearly labeled as examples.

A code block must not reference an object before the guide creates or validates it. Examples include:

- An OU before the parent OU exists.
- A group before the target OU exists.
- A GPO before it exists.
- A DHCP relay before the DHCP scope exists.
- A RouterOS interface list before it is created.
- A VLAN interface before its parent interface exists.

## PowerShell rules

PowerShell code blocks must:

- Import required modules before using module cmdlets.
- Validate required permissions without hardcoded NetBIOS prefixes.
- Prefer short-name group checks or SID-based checks over fragile regex.
- Avoid fragmented interactive `if`/`else` examples in implementation blocks.
- Prefer independent validation `if` blocks for copy/paste safety.
- Avoid invalid Active Directory `-Filter` syntax such as `SamAccountName -in`.
- Avoid `Get-ADOrganizationalUnit -Identity` for existence checks against objects that may not exist.
- Use `LDAPFilter`, `Get-ADObject`, `SearchBase`, or safe `try`/`catch` patterns for idempotent existence checks.

## RouterOS rules

RouterOS code blocks must:

- Create interface lists before referencing them.
- Add interface-list members before restricting services to those lists.
- Validate interface names before assigning IP addresses or firewall rules.
- Use Safe Mode guidance before management restrictions or firewall lockout-risk changes.
- Keep management access validation before hardening steps.

## Linux and Proxmox rules

Linux and Proxmox code blocks must:

- Preserve existing production or remote-management access.
- Validate paths before writing files.
- Back up configuration files before network changes.
- Use `docker compose` instead of legacy `docker-compose` syntax.
- Include rollback for risky network or service changes.

## Known bad patterns

The repository audit tools fail on known patterns that have already caused deployment issues, including:

- Fragile PowerShell permission regex using escaped parenthesis groups.
- Invalid AD filter patterns using `SamAccountName -in`.
- `Get-ADOrganizationalUnit -Identity` used for existence checks.
- RouterOS management restrictions that reference `MGMT` before the list is created.

## Required validation commands

Every change set touching implementation commands must run:

```bash
mkdocs build --strict
./tools/audit-doc-codeblocks.sh .
```

On Windows, run:

```powershell
.\tools\audit-doc-codeblocks.ps1 -Root .
```

Both gates must pass before committing.

## Deployment Verified status

A guide can be labeled **Deployment Verified** only after it has been executed in a clean or controlled pilot environment exactly as written, without undocumented corrections.

If a pilot deployment discovers an issue, treat it as an engineering bug:

1. Correct every affected guide.
2. Update troubleshooting and implementation notes.
3. Update validation steps.
4. Update the production readiness audit report.
5. Record the lesson in the changelog.
