---
title: Documentation Roadmap
document_id: GEIL-PRJ-ROADMAP-001
owner: Infrastructure Engineering
status: Draft
version: 19.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Documentation Roadmap

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-PRJ-ROADMAP-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 19.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

The [Enterprise Implementation Roadmap](enterprise-implementation-roadmap.md) is the high-level phase navigation document for GEIL implementation. This document remains the detailed documentation execution roadmap and should not duplicate the enterprise phase roadmap.

The roadmap organizes GEIL by enterprise capability Epics, Releases, and Documents. It intentionally avoids technology-first sequencing so the library can scale beyond 1,000 pages without restructuring.

## Roadmap model

```mermaid
flowchart LR
    Epic --> Release --> Document
    Document --> Validation
    Document --> Operations
    Document --> CrossReference[Cross References]
```

Rules:

1. Every Release belongs to exactly one Epic.
2. Every Document belongs to exactly one Release.
3. Dependencies are shown in [Epic and Release Architecture](epic-release-architecture.md).
4. New documents are not considered published until the release assignment register is updated.


## Canonical architecture checkpoint

The current canonical model after ADR-0002 and ADR-0003 is: firewall `HQ-FW01` runs MikroTik CHR / RouterOS; forest and server FQDNs use `corp.gntech.me`; NetBIOS is `GNTECH`; primary user UPN suffix is `gntech.me`; users sign in as `username@gntech.me`; legacy logon remains `GNTECH\username`. OPNsense and old identity examples may appear only in historical or explicitly superseded explanations.

## Production readiness checkpoint

GEIL implementation-phase documentation must pass engineering validation as well as MkDocs validation. The current repository-wide checkpoint is recorded in [Production Readiness Audit Report](production-readiness-audit-report.md). Future implementation guide changes must treat field deployment issues as engineering bugs, correct all affected documents, and avoid committing LOW-confidence deployment logic.

## Command execution context checkpoint

Pilot validation established that every operator-facing command block must state where it runs, when it runs, and the expected outcome. Routine administration should originate from `HQ-MGMT01` whenever possible; direct domain-controller execution is limited to initial deployment, bootstrap, disaster recovery, break-glass, or Microsoft-required local execution. This rule is now part of the Deployment Style Guide and Implementation Guide Standard.

## Microsoft Core navigation checkpoint

Microsoft Core navigation is phase-based: Phase 1 Identity Foundation, Phase 2 Core Infrastructure Services, Phase 3 Windows Client Lifecycle, Phase 4 Administration, Phase 5 File Services Future, and Phase 6 Future Identity Expansion. Group Strategy, User Lifecycle, and Service Account Standard are references pending Identity and Access Standard consolidation, not loose deployment steps.

## Windows client lifecycle checkpoint

Microsoft Core now exposes **Phase 3 - Windows Client Lifecycle** as the authoritative deployment sequence for Windows 11 Enterprise clients: golden template, Cloudbase-Init for Proxmox, `HQ-MGMT01`, domain join/GPO validation, and `HQ-W11-001`. The implementation files live under `docs/microsoft-core/windows-client-lifecycle/`.

## Management workstation architecture checkpoint

Pilot validation established that `HQ-MGMT01` now belongs to Management VLAN 10 and `OU=Management Workstations,OU=Computers,OU=GNTECH`. `HQ-W11-001` and future user workstations remain on VLAN 30 and `OU=Workstations,OU=Computers,OU=GNTECH`. Group Policy documentation prepares `GP - Baseline - Management Workstations` as future architecture only; settings are not implemented until validated.

## Documentation architecture checkpoint

GEIL now follows a single-source-of-truth architecture recorded in [Documentation Architecture Review](documentation-architecture-review.md). Active navigation is organized around Foundation, Platform, Microsoft Core, Security, Architecture, Operations, Project, Future, and Archive. New Markdown documents require a new platform, major capability, required section index, or approved control-plane/architecture record. Pilot findings update the existing authoritative document instead of creating parallel reports.

## Capability-first roadmap

| Epic | Release | Capability | Status | Evidence / Primary Documents |
|---|---|---|---|---|
| E00 Documentation Governance and Publishing | E00.R01 | Governance foundation | Done | [Project Charter](project-charter.md), [Environment Specification](environment-specification.md), [Document Index](document-index.md), [Documentation Backlog](documentation-backlog.md), [Epic and Release Architecture](epic-release-architecture.md), [Production Readiness Audit Report](production-readiness-audit-report.md) |
| E00 Documentation Governance and Publishing | E00.R01 | Visual documentation standard | Done | [Visual Documentation Standard](../governance/visual-documentation-standard.md) |
| E00 Documentation Governance and Publishing | E00.R01 | Implementation guide standard | Done | [Implementation Guide Standard](../governance/implementation-guide-standard.md) |
| E00 Documentation Governance and Publishing | E00.R01 | Educational documentation standard | Done | [Educational Documentation Standard](../governance/educational-documentation-standard.md) |
| E00 Documentation Governance and Publishing | E00.R02 | Publishing platform | Done | [Cloudflare Pages Deployment Runbook](../platform/cloudflare-pages-deployment.md) |
| E01 Enterprise Architecture | E01.R01 | Reference architecture | Done | [Reference Architecture](../architecture/reference-architecture.md), [Identity Architecture](../architecture/identity-architecture.md), [Network Architecture](../architecture/network-architecture.md) |
| E01 Enterprise Architecture | E01.R02 | Enterprise Architecture Vision | Done | [GEIL Master Plan](master-plan.md), [Enterprise Capability Model](../architecture/enterprise-capability-model.md), [Enterprise Reference Architecture](../architecture/enterprise-reference-architecture.md), [Technology Selection Matrix](../architecture/technology-selection-matrix.md), [Implementation Philosophy](../architecture/implementation-philosophy.md), [Architecture Principles](../architecture/architecture-principles.md) |
| E02 Enterprise Foundation | E02.R01 | HQ site foundation | Done | [Phase 0 Prerequisites](../foundation/phase-0-prerequisites.md), [Proxmox VE Baseline](../foundation/proxmox-ve-baseline.md), [Superseded OPNsense Edge Firewall](../foundation/opnsense-edge-firewall.md) |
| E02 Enterprise Foundation | E02.R02 | Enterprise Lab Blueprint | Done | [Enterprise Lab Blueprint HLD](../architecture/enterprise-lab-blueprint.md), [Enterprise Lab Network HLD](../architecture/enterprise-lab-network-hld.md), [Enterprise Lab Identity HLD](../architecture/enterprise-lab-identity-hld.md), [Enterprise Lab Operations HLD](../architecture/enterprise-lab-operations-hld.md) |
| E02 Enterprise Foundation | E02.R03 | HQ Foundation Low-Level Design and Build Plan | Done | [Proxmox HQ Foundation LLD](../platform/proxmox-hq-foundation-lld.md), [MikroTik CHR HQ Foundation LLD](../platform/mikrotik-chr-hq-foundation-lld.md), [Phase 1 Build Plan](../platform/phase-1-build-plan.md), [Phase 1 Validation Plan](../platform/phase-1-validation-plan.md), [Firewall Rule Matrix](../platform/firewall-rule-matrix.md), [Active Directory Network Requirements](../platform/active-directory-network-requirements.md), [Enterprise Port Reference](../platform/enterprise-port-reference.md) |
| E02 Enterprise Foundation | E02.R04 | HQ Foundation Implementation Runbook | Done | [Proxmox HQ Foundation Implementation](../platform/proxmox-hq-foundation-implementation.md), [MikroTik CHR HQ Foundation Implementation](../platform/mikrotik-chr-hq-foundation-implementation.md), [Windows Server 2025 Golden Template](../platform/windows-server-2025-golden-template.md), [Windows 11 Enterprise Golden Template](../microsoft-core/windows-client-lifecycle/windows-11-enterprise-golden-template.md), [Windows 11 Management Workstation](../microsoft-core/windows-client-lifecycle/windows-11-management-workstation.md), [Windows 11 Domain Join and GPO Validation](../microsoft-core/windows-client-lifecycle/windows-11-domain-join-gpo-validation.md), [ADR-0002](../governance/adrs/ADR-0002-mikrotik-chr-phase-1-firewall.md) |
| E02 Enterprise Foundation | E02.R04 | Implementation Detail Upgrade | Done | Operator-grade detail added to Proxmox, MikroTik CHR, build, validation, and acceptance documents; expanded operator walkthroughs added for MikroTik CHR and Windows Server deployment |
| E02 Enterprise Foundation | E02.R05 | HQ Foundation Evidence and Acceptance Package | Done | [Phase 1 Acceptance Package](../platform/phase-1-acceptance-package.md) |
| E03 Identity, Trust, and Access | E03.R01 | Core directory services | Done | [Windows Server 2025 Baseline](../microsoft-core/windows-server-2025-baseline.md), [Active Directory Implementation](../microsoft-core/active-directory-implementation.md), [Active Directory Organizational Foundation](../microsoft-core/active-directory-organizational-foundation.md), [Enterprise Naming Standard](../microsoft-core/active-directory-naming-standard.md), [Enterprise Group Strategy](../microsoft-core/group-strategy.md), [Enterprise User Lifecycle](../microsoft-core/user-lifecycle.md), [Enterprise Service Account Standard](../microsoft-core/service-account-standard.md), [DNS and DHCP Implementation](../microsoft-core/dns-dhcp-implementation.md), [Group Policy Baseline](../microsoft-core/group-policy-baseline.md) |
| E03 Identity, Trust, and Access | E03.R02 | Trust and network authentication | Done | [AD CS PKI](../microsoft-core/ad-cs-pki.md), [NPS RADIUS 802.1X](../microsoft-core/nps-radius-8021x.md) |
| E03 Identity, Trust, and Access | E03.R03 | Privileged access control plane | Done | [Privileged Access Model](../security/privileged-access-model.md), [Enterprise Administrative Tiering](../security/administrative-tiering.md) |
| E04 Cloud and Endpoint Management | E04.R01 | Cloud identity and endpoint management | Done | [Microsoft 365 Tenant Foundation](../cloud-endpoint/microsoft-365-tenant-foundation.md), [Entra ID Hybrid Identity](../cloud-endpoint/entra-id-hybrid-identity.md), [Intune Windows 11 Enterprise](../cloud-endpoint/intune-windows11-enterprise.md), [Windows Hello for Business](../cloud-endpoint/windows-hello-for-business.md), [Microsoft Defender](../cloud-endpoint/microsoft-defender.md) |
| E05 Operations and Resilience | E05.R01 | Operations readiness | Done | [Monitoring and Alerting](../operations/monitoring-alerting.md), [Backup and Recovery](../operations/backup-recovery.md), [Domain Controller Backup and Recovery](../operations/domain-controller-backup.md), [Troubleshooting](../operations/troubleshooting.md), [Scaling Model](../operations/scaling-model.md), [Security Operations](../operations/security-operations.md) |
| E03 Identity, Trust, and Access | E03.R04 | Certificate lifecycle management | Open | DOC-003 |
| E04 Cloud and Endpoint Management | E04.R02 | Conditional Access and device compliance | Open | DOC-004 |
| E03 Identity, Trust, and Access | E03.R05 | Privileged access operations | Open | DOC-007, DOC-008, DOC-009 |
| E03 Identity, Trust, and Access | E03.R06 | Service account lifecycle | Open | DOC-010 |
| E00 Documentation Governance and Publishing | E00.R03 | Repository security and branch protection | Open | Future repository security runbook |
| E00 Documentation Governance and Publishing | E00.R04 | Documentation quality and visual asset migration | In Progress | Visual asset migration completed for priority complex diagrams; glossary, templates, and CI quality gates remain open |
| E07 Scale and Expansion | E07.R01 | Multinational data residency | Open | DOC-005 |
| E05 Operations and Resilience | E05.R02 | Monitoring deep dives | Open | AD, certificate, and Microsoft 365 monitoring runbooks |
| E06 Security Assurance and Compliance | E06.R01 | Security assurance evidence | Open | Control mapping and exception governance |
| E07 Scale and Expansion | E07.R02 | Regional operations model | Open | Multi-site delegated operations |
| E05 Operations and Resilience | WIN.R01 | Secure Remote Administration Foundation | In Progress | [Windows Management Workstation](../microsoft-core/windows-client-lifecycle/windows-11-management-workstation.md), [WinRM / PowerShell Remoting Baseline](../microsoft-core/windows-server-management/winrm-powershell-remoting-baseline.md), [MikroTik Windows Management Firewall Policy](../network/mikrotik/windows-management-firewall-policy.md), [Network and AD Services Matrix](network-and-ad-services-matrix.md) |
| E06 Security Assurance and Compliance | WIN.R02 | Host Firewall and Local Admin Protection | In Progress | [Windows Firewall Baseline](../microsoft-core/windows-security/windows-firewall-baseline.md); [Windows LAPS Baseline](../microsoft-core/windows-security/windows-laps-baseline.md) |
| E06 Security Assurance and Compliance | WIN.R03 | Endpoint Protection and Monitoring | In Progress | [Microsoft Defender Enterprise Baseline](../microsoft-core/windows-security/microsoft-defender-baseline.md); future Windows Event Forwarding document |
| E03 Identity, Trust, and Access | WIN.R04 | Privileged Access Maturity | Planned | [Privileged Access Model](../security/privileged-access-model.md), [Enterprise Administrative Tiering](../security/administrative-tiering.md), future Tier 0/1/2 Microsoft Core model |



## Windows Infrastructure Lab Deployment roadmap

This roadmap tracks the security and management layers that turn the Windows lab from functional infrastructure into a manageable, defensible operating environment. It is intentionally incremental: the lab should not jump straight to a full enterprise PAW/JEA/PAM model before the foundational controls are documented, validated, and maintainable.

### Recommended implementation order

| Order | Epic | Status | Why this order matters |
|---:|---|---|---|
| 1 | Network and AD services matrix | In progress | Defines canonical GNTECH VLANs, subnets, host names, AD DS ports, Windows management ports, and firewall expectations before downstream baselines depend on them. |
| 2 | Enterprise WinRM Management | In progress | Standardizes secure command-based administration from `HQ-MGMT01` using Kerberos, WinRM, PowerShell Remoting, Windows Firewall scoping, and MikroTik segmentation. |
| 3 | Windows Firewall Baseline | In progress | Converts the network matrix and WinRM model into host-based firewall baselines by system role. |
| 4 | Windows LAPS | In progress | Secures local Administrator credentials after remote administration and firewall scope are understood. |
| 5 | Microsoft Defender Baseline | Done | Establishes practical endpoint protection after firewall behavior and local admin control are defined. |
| 6 | Windows Event Forwarding | Done | Centralizes events using dedicated collector `HQ-WEC01` once WinRM and firewall dependencies are in place. |
| 7 | Enterprise Identity & Privileged Access Tier 0/1/2 | Planned | Matures role separation, admin accounts, PAW usage, and tiering after the operational controls exist. |

The Tier 0/1/2 model can be introduced early as a concept, especially for account naming and administrative behavior. Strict enforcement should mature gradually as the lab grows from small business scale toward multi-site and multinational operations.

### Epic tracking

| Epic | Purpose | Status | Dependencies | Required / expected documents | Validation checkpoints |
|---|---|---|---|---|---|
| Enterprise WinRM Management | Standardize secure remote administration using WinRM / PowerShell Remoting. | In progress | Management Workstation baseline; Network and AD services matrix; MikroTik Windows management firewall policy; GPO-based WinRM enablement; Windows Firewall scoping to Management VLAN. | [Windows Management Workstation](../microsoft-core/windows-client-lifecycle/windows-11-management-workstation.md); [WinRM / PowerShell Remoting Baseline](../microsoft-core/windows-server-management/winrm-powershell-remoting-baseline.md); [MikroTik Windows Management Firewall Policy](../network/mikrotik/windows-management-firewall-policy.md); [Network and AD Services Matrix](network-and-ad-services-matrix.md). | `Test-NetConnection`, `Test-WSMan`, `Enter-PSSession`, `Invoke-Command`; confirm WinRM succeeds from Management VLAN and fails from non-management VLANs. |
| Windows Firewall Baseline | Create host-based Windows Firewall baselines by system role. | In progress | Network and AD services matrix; Enterprise WinRM Management; MikroTik firewall policy. | [Windows Firewall Baseline](../microsoft-core/windows-security/windows-firewall-baseline.md). Future role-specific documents: docs/microsoft-core/windows-security/domain-controller-firewall-baseline.md; docs/microsoft-core/windows-security/member-server-firewall-baseline.md. | Role-based firewall profiles; inbound management rules scoped to Management VLAN; separation of AD DS service ports, Windows management ports, and application-specific ports. |
| Windows LAPS | Secure local Administrator passwords across domain-joined Windows systems. | In progress | Active Directory baseline; Management Workstation baseline; Privileged access model. | [Windows LAPS Baseline](../microsoft-core/windows-security/windows-laps-baseline.md). | GPO configuration; AD-backed password storage; permissions model; recovery workflow; validation commands; separation of helpdesk access from domain admin access. |
| Microsoft Defender Baseline | Create a practical Microsoft Defender Antivirus baseline for small business Windows infrastructure. | Done | Windows Firewall Baseline; Windows LAPS Baseline; Group Policy Baseline; Windows Event Forwarding for later monitoring. | [Microsoft Defender Enterprise Baseline](../microsoft-core/windows-security/microsoft-defender-baseline.md). | Defender Antivirus state; cloud-delivered protection; Tamper Protection limitations; PUA Protection; Network Protection audit mode; exclusions; PowerShell validation; operational checks. |
| Windows Event Forwarding | Centralize important Windows security and operational events using dedicated collector `HQ-WEC01`. | Done | Enterprise WinRM Management; Windows Firewall Baseline; Microsoft Defender Baseline; Windows LAPS Baseline. | [Windows Event Forwarding and Collector Baseline](../microsoft-core/windows-monitoring/windows-event-forwarding-baseline.md). | WEC collector design; source-initiated subscriptions; `HQ-W11-001` and `HQ-MGMT01` pilot sources; client-to-collector TCP `5985`; Forwarded Events validation; future SIEM integration. |
| Enterprise Identity & Privileged Access Tier 0/1/2 | Define a scalable privileged access model as the lab grows from small business to multi-site / multinational design. | Planned | Management Workstation baseline; Windows LAPS; WinRM Management; Event Forwarding; Defender baseline. | Existing references: [Privileged Access Model](../security/privileged-access-model.md), [Enterprise Administrative Tiering](../security/administrative-tiering.md). Future: docs/microsoft-core/identity/privileged-access-tier-model.md. | Tier 0/1/2 definitions; dedicated admin accounts; no daily-driver admin use; PAW model; admin logon restrictions; GPO delegation; future JEA/JIT/PAM. |

### Practical release grouping

| Release | Theme | Includes | Status |
|---|---|---|---|
| Release 1: Secure Remote Administration Foundation | Establish trusted management paths before expanding security controls. | Management Workstation baseline; RDP validation; WinRM / PowerShell Remoting baseline; MikroTik Windows management firewall policy; Network and AD services matrix. | In progress |
| Release 2: Host Firewall and Local Admin Protection | Lock down host-level exposure and local Administrator credentials. | Windows Firewall Baseline; Windows LAPS. | In progress |
| Release 3: Endpoint Protection and Monitoring | Add endpoint security and centralized visibility. | Microsoft Defender Baseline; Windows Event Forwarding. | In progress |
| Release 4: Privileged Access Maturity | Mature administrative boundaries without over-engineering the early lab. | Tier 0/1/2 model; PAW refinement; JEA; role-based administration; future certificate-based WinRM HTTPS. | Planned |

## Enterprise Identity Foundation dependency graph

```mermaid
flowchart TD
    INFRA[Infrastructure: Proxmox + MikroTik CHR + Networking]
    WSB[Windows Server Baseline]
    AD[Active Directory]
    ORG[Organizational Foundation]
    NAME[Naming Standard]
    GROUP[Group Strategy]
    GPO[Group Policy]
    PKI[PKI]
    NPS[NPS]
    ENTRA[Entra Connect / Entra ID]
    INTUNE[Intune]
    WHFB[Windows Hello for Business]

    INFRA --> WSB --> AD --> ORG
    ORG --> NAME --> GROUP --> GPO --> PKI --> NPS --> ENTRA --> INTUNE --> WHFB
```

## Release exit criteria

A release is Done only when:

1. Every required document is linked in navigation.
2. Every document appears in the document index.
3. Every document appears exactly once in the release assignment register.
4. Required diagrams and dependency links are present.
5. Backlog status is updated.
6. `mkdocs build --strict` succeeds.

## Next recommended release

The next recommended guide is **Group Policy Baseline** after Active Directory Organizational Foundation validation. Active Directory Organizational Foundation validation now includes baseline group membership assignment: `admin.gnolasco -> GG-T0-Domain-Admins`, `gnolasco -> GG-IT-Operations`, optional VPN/WiFi groups, and pilot/bootstrap-only `GG-T0-Domain-Admins -> Domain Admins` nesting without direct user membership in `Domain Admins`. The next recommended new release remains **E03.R04 Certificate lifecycle management**, delivered by backlog item `DOC-003`. All E03.R04 documents must reference the Enterprise Lab Blueprint HLD and the E02.R03/E02.R04/E02.R05 HQ Foundation design, implementation, and acceptance baseline before defining implementation details.


## Documentation Quality Initiative

The primary roadmap objective is now improving existing deployment guides to Microsoft Learn / VMware / Cisco / Red Hat / HashiCorp quality before creating new implementation documents. The first DQI report is [Documentation Quality Report](documentation-quality-report.md).

- **Completed:** Code Block Quality Standard and audit tools added after Pilot Deployment 001 exposed copy/paste command defects.
