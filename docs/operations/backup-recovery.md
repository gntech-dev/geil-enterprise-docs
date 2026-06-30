---
title: Backup and Recovery
document_id: GEIL-OPS-BACKUP-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Backup and Recovery

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-OPS-BACKUP-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Ensure infrastructure can be recovered from operator error, hardware failure, ransomware, and site outage.

## Backup requirements

- Domain controllers: system state and VM-level backup where supported.
- Certificate authorities: CA database, private keys, registry configuration, and CRL configuration.
- MikroTik CHR: encrypted configuration export after every approved change.
- Proxmox: scheduled VM backups and host configuration documentation.
- Microsoft 365: retention policies and third-party backup decision documented by ADR.

## Validation PowerShell

```powershell
wbadmin get versions
Get-WindowsFeature Windows-Server-Backup
```

Expected result: recent backup versions exist for protected Windows servers.

## Restore testing

Quarterly restore test must include:

1. Restore a non-production VM.
2. Restore a file from backup.
3. Validate AD object recovery procedure.
4. Validate CA backup readability.
5. Record time to recover.

## Rollback

A failed restore test is a P0 operational defect. Freeze expansion work until backup reliability is restored.
