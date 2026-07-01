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

## Identity namespace prerequisite

The Microsoft 365 verified domain `gntech.me` is the production user authentication namespace. Active Directory uses `corp.gntech.me` for the forest and DNS, but users sign in to Microsoft 365 as `username@gntech.me`.

## Deployment Verified

| Field | Value |
|---|---|
| Validated on | Not yet field validated. Must pass this guide, the code-block audit, and clean-environment review before production execution. |
| Windows Server version | Not yet field validated |
| RouterOS version | Not applicable unless the guide explicitly configures RouterOS |
| Proxmox version | Not applicable unless the guide explicitly configures Proxmox |
| Deployment date | Not yet field validated |
| Deployment notes | Not yet field validated. Must pass this guide, the code-block audit, and clean-environment review before production execution. |
| Known caveats | Treat as documentation-ready but not field-proven until deployment evidence is captured. |
