---
title: PowerShell Operations
document_id: GEIL-MSC-PS-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# PowerShell Operations

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-PS-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Standardize safe PowerShell execution for GEIL operations.

## Standards

- Use PowerShell 7 where supported; use Windows PowerShell only for modules that require it.
- Use `-WhatIf` before destructive changes when supported.
- Capture transcript for approved changes.
- Prefer idempotent scripts.
- Never hard-code secrets.

## Change transcript pattern

```powershell
$Transcript = "C:\ChangeLogs\CHG-20260629-001-$(Get-Date -Format yyyyMMdd-HHmmss).log"
Start-Transcript -Path $Transcript
# Run approved commands here.
Stop-Transcript
```

Expected result: transcript file exists and is attached to the change record.

## Validation pattern

Every script must include:

```powershell
try {
    # implementation
}
catch {
    Write-Error $_
    throw
}
```

## Rollback pattern

Record pre-change state before modifying objects:

```powershell
Get-ADUser j.smith -Properties * | Export-Clixml C:\ChangeLogs\j.smith-before.xml
```

If rollback is needed, use the exported state to restore changed attributes manually or via reviewed script.
