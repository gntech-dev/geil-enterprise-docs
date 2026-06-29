---
title: Group Policy Baseline
document_id: GEIL-MSC-GPO-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Group Policy Baseline

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-GPO-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

!!! note "Adaptation"

    This document uses canonical GNTECH values from the [Environment Specification](../project/environment-specification.md). Organizations adapting this design should change the environment specification first, then update all affected DNS zones, certificates, PowerShell commands, Group Policies, VLANs, firewall rules, and service configurations.

## Purpose

Implement baseline Group Policy for security, operations, and Windows client consistency.

## Baseline GPOs

| GPO | Link | Purpose |
|---|---|---|
| `GEIL-DC-Security-Baseline` | Domain Controllers OU | Domain controller hardening |
| `GEIL-Server-Security-Baseline` | Servers OU | Server firewall, audit, Defender |
| `GEIL-Workstation-Security-Baseline` | Workstations OU | Windows 11 security settings |
| `GEIL-Admin-Tier0-Restrictions` | Admin OU | Restrict Tier 0 interactive logon |
| `GEIL-Certificate-Autoenrollment` | Domain root or scoped OUs | PKI autoenrollment |

## Implementation PowerShell

```powershell
New-GPO -Name "GEIL-Workstation-Security-Baseline"
New-GPLink -Name "GEIL-Workstation-Security-Baseline" -Target "OU=Workstations,DC=corp,DC=gntech,DC=me"
Set-GPRegistryValue -Name "GEIL-Workstation-Security-Baseline" `
  -Key "HKLM\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" `
  -ValueName EnableScriptBlockLogging -Type DWord -Value 1
```

Expected result: GPO exists, is linked to the correct OU, and enables PowerShell script block logging.

## Validation

```powershell
Get-GPO -Name "GEIL-Workstation-Security-Baseline"
gpresult /h C:\Temp\gpresult.html
```

Expected result: GPO appears in applied policies for a test workstation.

## Rollback

Unlink first; do not delete until impact is understood.

```powershell
Remove-GPLink -Name "GEIL-Workstation-Security-Baseline" -Target "OU=Workstations,DC=corp,DC=gntech,DC=me"
```
