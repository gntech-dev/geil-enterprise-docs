---
title: Entra ID Hybrid Identity
document_id: GEIL-CLD-ENTRA-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Entra ID Hybrid Identity

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-CLD-ENTRA-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Synchronize approved Active Directory identities to Microsoft Entra ID.

## Design requirements

- Define OU synchronization scope.
- Normalize UPN suffixes to routable verified domains.
- Document sourceAnchor behavior.
- Exclude Tier 0 privileged accounts unless specifically required and approved.

## Implementation outline

1. Prepare AD users with valid UPNs.
2. Install Entra Cloud Sync agent or Entra Connect Sync on approved server.
3. Configure OU filtering.
4. Enable password hash sync unless prohibited by policy.
5. Validate pilot user sync before broad scope.

## Validation PowerShell

```powershell
Connect-MgGraph -Scopes "User.Read.All"
Get-MgUser -UserId "<USER_UPN>" | Select Id,UserPrincipalName,OnPremisesSyncEnabled
```

Expected result: pilot users show `OnPremisesSyncEnabled=True`.

## Rollback

Disable sync scope for the affected OU, wait for export, and verify cloud objects. Do not delete synced cloud users until source authority and mailbox impact are reviewed.
