---
title: RSAT / Remote Administration
document_id: GEIL-MSC-ADMIN-RSAT-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# RSAT / Remote Administration

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-ADMIN-RSAT-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Define where RSAT and remote administration tools belong in the GEIL Microsoft Core deployment.

## Architecture

`HQ-MGMT01` is the Windows 11 Enterprise management workstation / initial PAW. RSAT and administrative tooling are installed on `HQ-MGMT01`, not on standard user workstations and not by using Windows Server as a daily workstation.

## Tooling baseline

Install and validate:

- RSAT Active Directory DS/LDS tools.
- RSAT DNS tools.
- RSAT Group Policy Management tools.
- RSAT Server Manager tools.
- PowerShell 7.
- Windows Terminal.
- Visual Studio Code.
- Git.

## Implementation source

The current implementation procedure is maintained in:

[Windows Management Workstation - HQ-MGMT01](../windows-client-lifecycle/windows-11-management-workstation.md)

## Validation

From `HQ-MGMT01`, validate that administration can occur remotely:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Get-Command Get-ADDomain
Get-Command Get-GPO
Resolve-DnsName HQ-DC01.corp.gntech.me
Test-NetConnection HQ-DC01.corp.gntech.me -Port 5985
Test-WSMan HQ-W11-001
```

## Related documents

- [Windows Management Workstation - HQ-MGMT01](../windows-client-lifecycle/windows-11-management-workstation.md)
- [PowerShell Operations](../powershell-operations.md)
- [Enterprise WinRM Management](enterprise-winrm-management.md)
- [Privileged Access Model](../../security/privileged-access-model.md)
