---
title: Security Operations
document_id: GEIL-OPS-SEC-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Security Operations

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-OPS-SEC-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Define security operations requirements for identity, endpoint, network, and infrastructure administration.

## Daily checks

- Entra risky users and sign-ins.
- Defender active alerts.
- Domain controller critical events.
- Backup job failures.
- Firewall configuration changes.

## Weekly checks

- Privileged group membership changes.
- Certificate expiry under 60 days.
- Patch compliance.
- Intune policy failure trends.

## PowerShell validation

```powershell
Get-ADGroupMember "Domain Admins"
Get-ADGroupMember "Enterprise Admins"
Get-EventLog -LogName Security -Newest 50
```

Expected result: privileged membership matches approved access records.

## Incident response

1. Preserve logs.
2. Disable compromised account or device access.
3. Revoke sessions and rotate credentials.
4. Determine blast radius.
5. Restore trusted state.
6. Document lessons learned and update GEIL if procedure changes.

## Rollback

Security exceptions require owner, expiry, compensating control, and approval. Expired exceptions must be removed.
