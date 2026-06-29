---
title: Microsoft 365 Tenant Foundation
document_id: GEIL-CLD-M365-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Microsoft 365 Tenant Foundation

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-CLD-M365-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Establish the Microsoft 365 tenant baseline for secure identity, licensing, and administration.

## Baseline controls

- Create at least two cloud-only emergency access accounts.
- Require MFA for all normal users.
- Use named admin accounts; no shared global admin use.
- Configure verified public domains.
- Disable user consent to unapproved applications unless an ADR permits it.
- Configure audit logging and retention according to license capability.

## Validation PowerShell

Use Microsoft Graph PowerShell from an admin workstation.

```powershell
Connect-MgGraph -Scopes "Directory.Read.All","RoleManagement.Read.Directory"
Get-MgDirectoryRole | Select DisplayName
Get-MgDomain | Select Id,IsVerified,AuthenticationType
```

Expected result: tenant roles and verified domains match design.

## Rollback

Do not delete emergency access accounts. For bad role assignments, remove the role assignment and revoke sessions for the affected principal.
