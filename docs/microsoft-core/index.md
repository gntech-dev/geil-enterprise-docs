---
title: Microsoft Core
document_id: GEIL-MSC-INDEX
owner: Infrastructure Engineering
status: Draft
version: 1.1
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# Microsoft Core

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-INDEX |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.1 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Windows Server, Active Directory, DNS, DHCP, Group Policy, Windows client lifecycle, Windows Admin Center, and PowerShell operations.

## Required use

Before implementing changes in this area, read the applicable standard, confirm prerequisites, execute the documented validation steps, and record evidence in the change ticket.

## Deployment phases

### Phase 1 - Windows Server and Directory Foundation

- [Windows Server 2025 Baseline](windows-server-2025-baseline.md)
- [Active Directory Implementation](active-directory-implementation.md)
- [Active Directory Organizational Foundation](active-directory-organizational-foundation.md)
- [DNS and DHCP Implementation](dns-dhcp-implementation.md)

### Phase 2 - Policy and Administration Foundation

- [Group Policy Baseline](group-policy-baseline.md)
- [Windows Admin Center](windows-admin-center.md)
- [PowerShell Operations](powershell-operations.md)

### Phase 3 - Windows Client Lifecycle

This phase owns the Windows 11 Enterprise client lifecycle inside Microsoft Core. The implementation guides are located under [Windows Client Lifecycle](windows-client-lifecycle/index.md).

Deployment order:

1. [Windows 11 Enterprise Golden Template](windows-client-lifecycle/windows-11-enterprise-golden-template.md)
2. [Cloudbase-Init for Proxmox](windows-client-lifecycle/windows-11-enterprise-golden-template.md#step-4-install-and-configure-cloudbase-init)
3. [Windows Management Workstation - HQ-MGMT01](windows-client-lifecycle/windows-11-management-workstation.md)
4. [Windows Domain Join and GPO Validation](windows-client-lifecycle/windows-11-domain-join-gpo-validation.md)
5. [Standard Windows Client - HQ-W11-001](windows-client-lifecycle/windows-11-domain-join-gpo-validation.md)

Architecture rules:

| Component | Network | Active Directory placement | Purpose |
|---|---|---|---|
| Golden Template | None after generalization | None | Workgroup-only generalized source template; never domain-joined |
| `HQ-MGMT01` | VLAN 10 Management | `OU=Management Workstations,OU=Computers,OU=GNTECH,...` | Windows 11 Enterprise management workstation / initial PAW |
| `HQ-W11-001` | VLAN 30 Workstations | `OU=Workstations,OU=Computers,OU=GNTECH,...` | Standard Windows 11 Enterprise client validation VM |
| Future user workstations | VLAN 30 Workstations | `OU=Workstations,OU=Computers,OU=GNTECH,...` | Standard user endpoints |

The golden template must never be domain-joined. Domain join, OU placement, and GPO validation happen only after cloning.

## Documentation quality gate

- Implementation steps must include expected results.
- PowerShell must include validation and rollback where practical.
- Known GNTECH values must use the canonical values in the [Environment Specification](../project/environment-specification.md); only approved secret or deployment-unknown placeholders are permitted.
