---
title: Windows Server Remote Management
document_id: GEIL-MSC-ADMIN-WSRM-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# Windows Server Remote Management

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-ADMIN-WSRM-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Define the GEIL model for administering Windows Server systems remotely.

## Architecture

Windows Server hosts infrastructure roles. It is not a daily administrative workstation. Routine administration originates from `HQ-MGMT01` or a future approved PAW/jump path.

## Approved source

| Source | Network | Purpose |
|---|---|---|
| `HQ-MGMT01` | VLAN 10 Management | Initial management workstation / PAW |
| Future PAWs | VLAN 10 Management | Dedicated privileged administration endpoints |

## Remote management methods

Use remote methods instead of routine console or interactive server sign-in:

- RSAT consoles from `HQ-MGMT01`.
- PowerShell remoting where enabled and approved. See [Enterprise WinRM Management](enterprise-winrm-management.md).
- Windows Admin Center when implemented.
- RDP only for approved administrative scenarios where no safer remote method is practical.

## Validation

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Test-NetConnection HQ-DC01.corp.gntech.me -Port 5985
Test-WSMan HQ-DC01.corp.gntech.me
Test-NetConnection HQ-DC01.corp.gntech.me -Port 3389
```

Expected result: approved management ports are reachable from `HQ-MGMT01` only when enabled by policy. Standard workstations must not be used as server administration endpoints.

## Related documents

- [Windows Server 2025 Baseline](../windows-server-2025-baseline.md)
- [Windows Management Workstation - HQ-MGMT01](../windows-client-lifecycle/windows-11-management-workstation.md)
- [Enterprise WinRM Management](enterprise-winrm-management.md)
- [Windows Admin Center](../../legacy/microsoft-core/windows-admin-center.md)
