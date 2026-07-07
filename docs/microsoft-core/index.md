---
title: Microsoft Core
document_id: GEIL-MSC-INDEX
owner: Infrastructure Engineering
status: Draft
version: 1.2
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
| Version | 1.2 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Windows Server, Active Directory, DNS, DHCP, Group Policy, Windows client lifecycle, administration, future file services, future identity expansion, and PowerShell operations.

## Required use

Before implementing changes in this area, read the applicable standard, confirm prerequisites, execute the documented validation steps, and record evidence in the change ticket.

## Microsoft Core deployment phases

### Phase 1 - Identity Foundation

| Order | Document | Purpose |
|---:|---|---|
| 1 | [Windows Server 2025 Baseline](windows-server-2025-baseline.md) | Prepare the Windows Server baseline for Microsoft Core roles. |
| 2 | [Active Directory Implementation](active-directory-implementation.md) | Create the forest, domain, DNS-integrated AD DS foundation, and first domain controller. |
| 3 | [Active Directory Organizational Foundation](active-directory-organizational-foundation.md) | Create canonical OUs, baseline users, groups, memberships, service-account containers, and computer placement. |
| 4 | [Enterprise Naming Standard](active-directory-naming-standard.md) | Define naming standards for identities, computers, groups, GPOs, DNS, certificates, and infrastructure objects. |
| 5 | [Authentication Standards](authentication-standards.md) | Define validated identity formats for Windows sign-in, RDP, PowerShell Remoting, Microsoft 365 / Entra ID, and cloud applications. |

### Phase 2 - Core Infrastructure Services

| Order | Document | Purpose |
|---:|---|---|
| 1 | [DNS and DHCP Implementation](dns-dhcp-implementation.md) | Implement Microsoft DNS and DHCP after AD DS is healthy. |
| 2 | [Group Policy Baseline](group-policy-baseline.md) | Create Central Store, baseline GPO shells, `GP - Baseline - Workstations`, and `GP - Baseline - Management Workstations` with validated initial management workstation settings. |

### Phase 3 - Windows Client Lifecycle

This phase owns the Windows 11 Enterprise client lifecycle inside Microsoft Core.

| Order | Document | Purpose |
|---:|---|---|
| 1 | [Windows 11 Enterprise Golden Template](windows-client-lifecycle/windows-11-enterprise-golden-template.md) | Build the generalized, workgroup-only Windows 11 Enterprise source template. |
| 2 | [Cloudbase-Init for Proxmox](windows-client-lifecycle/cloudbase-init-for-proxmox.md) | Prepare clone metadata support without baking identity into the template. |
| 3 | [Windows Management Workstation - HQ-MGMT01](windows-client-lifecycle/windows-11-management-workstation.md) | Deploy the Windows 11 Enterprise management workstation / initial PAW on VLAN 10. |
| 4 | [Windows Domain Join and GPO Validation](windows-client-lifecycle/windows-11-domain-join-gpo-validation.md) | Validate VLAN30 clients, join `corp.gntech.me`, move objects, and validate GPO. |
| 5 | [Standard Windows Client - HQ-W11-001](windows-client-lifecycle/standard-windows-client-hq-w11-001.md) | Define the standard Windows 11 client validation VM on VLAN 30 and the Workstations OU. |

Architecture rules:

| Component | Network | Active Directory placement | Purpose |
|---|---|---|---|
| Golden Template | None after generalization | None | Workgroup-only generalized source template; never domain-joined |
| `HQ-MGMT01` | VLAN 10 Management | `OU=Management Workstations,OU=Computers,OU=GNTECH,...` | Windows 11 Enterprise management workstation / initial PAW |
| `HQ-W11-001` | VLAN 30 Workstations | `OU=Workstations,OU=Computers,OU=GNTECH,...` | Standard Windows 11 Enterprise client validation VM |
| Future user workstations | VLAN 30 Workstations | `OU=Workstations,OU=Computers,OU=GNTECH,...` | Standard user endpoints |

The golden template must never be domain-joined. Domain join, OU placement, and GPO validation happen only after cloning.

### Phase 4 - Administration

| Order | Document | Purpose |
|---:|---|---|
| 1 | [PowerShell Operations](powershell-operations.md) | Define safe PowerShell execution, object-creation patterns, validation, and rollback expectations. |
| 2 | [RSAT / Remote Administration](administration/rsat-remote-administration.md) | Define RSAT and admin-tool placement on `HQ-MGMT01`. |
| 3 | [Windows Server Remote Management](administration/windows-server-remote-management.md) | Define remote server administration from `HQ-MGMT01` instead of daily server logons. |
| 4 | [Enterprise WinRM Management](administration/enterprise-winrm-management.md) | Define Kerberos-based WinRM / PowerShell Remoting from `HQ-MGMT01` to managed Windows clients and future servers. |
| 5 | [WinRM / PowerShell Remoting Baseline](windows-server-management/winrm-powershell-remoting-baseline.md) | Practical implementation baseline for enabling and validating WinRM / PowerShell Remoting in the GNTECH AD lab. |

### Windows Security Baselines

See [Windows Security Baselines](windows-security/index.md) for the section index.

These baselines translate the security and management roadmap into practical Microsoft Core controls. They are introduced incrementally after the remote administration foundation is documented and validated.

| Order | Document | Purpose |
|---:|---|---|
| 1 | [Windows Firewall Baseline](windows-security/windows-firewall-baseline.md) | Define host-based firewall expectations for Domain Controllers, member servers, management workstations, and standard workstations. |
| 2 | [Windows LAPS Baseline](windows-security/windows-laps-baseline.md) | Implement built-in Windows LAPS for local Administrator password management across domain-joined Windows client devices. |

### Phase 5 - File Services (Future)

These items are future planning entries, not active deployment steps.

| Order | Document | Status |
|---:|---|---|
| 1 | [File Server](file-services/file-server.md) | Future |
| 2 | [DFS](file-services/dfs.md) | Future |
| 3 | [SMB Shares and Permissions](file-services/smb-shares-permissions.md) | Future |
| 4 | [AGDLP Access Model](file-services/agdlp-access-model.md) | Future |

### Phase 6 - Future Identity Expansion

These items are future planning entries unless explicitly promoted after laboratory validation.

| Order | Document | Status |
|---:|---|---|
| 1 | [PKI](ad-cs-pki.md) | Future |
| 2 | [NPS / RADIUS](nps-radius-8021x.md) | Future |
| 3 | [Entra Hybrid](../cloud-endpoint/entra-id-hybrid-identity.md) | Future |
| 4 | [Windows Hello for Business](../cloud-endpoint/windows-hello-for-business.md) | Future |
| 5 | [Windows Admin Center](windows-admin-center.md) | Future |


## Windows Infrastructure Lab Deployment security and management roadmap

The current Windows Infrastructure Lab Deployment roadmap is tracked in [Epic and Release Architecture](../project/epic-release-architecture.md) and [Documentation Roadmap](../project/documentation-roadmap.md). Microsoft Core implementation should follow this order:

1. [Network and Active Directory Services Matrix](../project/network-and-ad-services-matrix.md).
2. Enterprise WinRM Management.
3. [Windows Firewall Baseline](windows-security/windows-firewall-baseline.md).
4. [Windows LAPS Baseline](windows-security/windows-laps-baseline.md).
5. Microsoft Defender Baseline.
6. Windows Event Forwarding.
7. Enterprise Identity & Privileged Access Tier 0/1/2.

Introduce Tier 0/1/2 concepts early for naming, admin-account behavior, and management-workstation usage. Enforce strict tiering gradually as the lab matures.

## Identity and Access references

Group Strategy, User Lifecycle, and Service Account Standard are not loose Microsoft Core deployment steps. They are identity and access references pending consolidation into the future Identity and Access Standard:

- [Enterprise Group Strategy](group-strategy.md)
- [Enterprise User Lifecycle](user-lifecycle.md)
- [Enterprise Service Account Standard](service-account-standard.md)

## Network and service access reference

Use the [Network and Active Directory Services Matrix](../project/network-and-ad-services-matrix.md) for canonical GNTECH VLANs, subnets, administrative access paths, AD DS service ports, Windows management ports, and firewall expectations.

## Authentication standard

GEIL Windows and RDP examples use the validated NetBIOS format `GNTECH\username`, for example `GNTECH\admin.gnolasco`, unless a specific client has explicitly validated UPN authentication. Microsoft 365, Entra ID, and cloud applications use `username@gntech.me`. See [Authentication Standards](authentication-standards.md).

## Documentation quality gate

- Implementation steps must include expected results.
- PowerShell must include validation and rollback where practical.
- Known GNTECH values must use the canonical values in the [Environment Specification](../project/environment-specification.md); only approved secret or deployment-unknown placeholders are permitted.
