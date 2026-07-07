---
title: Windows Client Lifecycle
document_id: GEIL-MSC-WCL-INDEX
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# Phase 3 - Windows Client Lifecycle

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-WCL-INDEX |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This section is the Microsoft Core entry point for Windows 11 Enterprise client lifecycle deployment in GEIL. It makes the Windows client sequence visible inside Microsoft Core instead of leaving it only under Platform.

## Phase 3 deployment order

1. [Windows 11 Enterprise Golden Template](windows-11-enterprise-golden-template.md)
2. [Cloudbase-Init for Proxmox](cloudbase-init-for-proxmox.md)
3. Domain Join after cloning
4. Move to the correct OU
5. Apply GPO
6. Apply Windows LAPS
7. Validate password backup
8. Apply Microsoft Defender Baseline
9. Validate Defender health
10. Validate RDP
11. Validate WinRM
12. Ready for Enterprise Management

Implementation documents:

1. [Windows 11 Enterprise Golden Template](windows-11-enterprise-golden-template.md)
2. [Cloudbase-Init for Proxmox](cloudbase-init-for-proxmox.md)
3. [Windows Management Workstation - HQ-MGMT01](windows-11-management-workstation.md)
4. [Windows Domain Join and GPO Validation](windows-11-domain-join-gpo-validation.md)
5. [Standard Windows Client - HQ-W11-001](standard-windows-client-hq-w11-001.md)
6. [Enterprise WinRM Management](../administration/enterprise-winrm-management.md)
7. [Windows LAPS Baseline](../windows-security/windows-laps-baseline.md)
8. [Microsoft Defender Enterprise Baseline](../windows-security/microsoft-defender-baseline.md)

## Architecture rules

| Component | Network | Active Directory placement | Purpose |
|---|---|---|---|
| Golden Template | None after generalization | None | Workgroup-only generalized source template; never domain-joined |
| `HQ-MGMT01` | VLAN 10 Management | `OU=Management Workstations,OU=Computers,OU=GNTECH,...` | Windows 11 Enterprise management workstation / initial PAW |
| `HQ-W11-001` | VLAN 30 Workstations | `OU=Workstations,OU=Computers,OU=GNTECH,...` | Standard Windows 11 Enterprise client validation VM |
| Future user workstations | VLAN 30 Workstations | `OU=Workstations,OU=Computers,OU=GNTECH,...` | Standard user endpoints |

## Non-negotiable template rule

The Windows 11 Enterprise Golden Template must remain:

- Workgroup-only.
- Generalized.
- Not domain-joined.
- Not assigned to any OU.
- Not subject to GPO state.
- Free of production user sign-ins and privileged credentials.

Domain join, OU placement, and GPO validation happen only after cloning.

## Related documents

- [Environment Specification](../../project/environment-specification.md)
- [Active Directory Organizational Foundation](../active-directory-organizational-foundation.md)
- [Group Policy Baseline](../group-policy-baseline.md)
- [Windows LAPS Baseline](../windows-security/windows-laps-baseline.md)
- [Microsoft Defender Enterprise Baseline](../windows-security/microsoft-defender-baseline.md)
- [Active Directory Network Requirements](../../platform/active-directory-network-requirements.md)
