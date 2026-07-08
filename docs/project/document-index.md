---
title: Document Index
document_id: GEIL-PRJ-INDEX-001
owner: Infrastructure Engineering
status: Draft
version: 19.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Document Index

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-PRJ-INDEX-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 19.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

The document index is the authoritative register of GEIL documents, their ownership, status, and primary cross-references.

## Status definitions

| Status | Meaning |
|---|---|
| Approved | Ready for production use |
| Draft | Usable but still requires review or expansion |
| Retired | Superseded and no longer authoritative |

## Project documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-PRJ-CHARTER-001 | GEIL Project Charter | Approved | `docs/project/project-charter.md` | Scope, roles, quality rules |
| GEIL-PRJ-MASTER-001 | GEIL Master Plan | Approved | `docs/project/master-plan.md` | North Star vision, mission, long-term goals, roadmap, target architecture, and implementation philosophy |
| GEIL-PRJ-ENT-ROADMAP-001 | Enterprise Implementation Roadmap | Draft | `docs/project/enterprise-implementation-roadmap.md` | Authoritative high-level implementation phase roadmap and Microsoft Core document status model |
| GEIL-PRJ-ENV-001 | Environment Specification | Approved | `docs/project/environment-specification.md` | Canonical GNTECH domains, authentication formats, names, VLANs, IP ranges, DNS, certificates, shares, repository, and documentation URLs |
| GEIL-PRJ-NETAD-MATRIX-001 | Network and Active Directory Services Matrix | Approved | `docs/network/network-and-ad-services-matrix.md` | Network authority for canonical GNTECH VLANs, subnets, server names, AD service ports, Windows management ports, and inter-VLAN access expectations |
| GEIL-PRJ-BACKLOG-001 | Documentation Backlog | Draft | `docs/project/documentation-backlog.md` | Work queue and priorities |
| GEIL-PRJ-INDEX-001 | Document Index | Draft | `docs/project/document-index.md` | Authoritative register |
| GEIL-PRJ-ROADMAP-001 | Documentation Roadmap | Draft | `docs/project/documentation-roadmap.md` | Capability-first Epic/Release roadmap |
| GEIL-PRJ-ERA-001 | Epic and Release Architecture | Approved | `docs/project/epic-release-architecture.md` | Epics, Releases, document assignments, dependency graphs, and scale model |
| GEIL-PRJ-PROD-AUDIT-001 | Production Readiness Audit Report | Draft | `docs/project/production-readiness-audit-report.md` | Repository-wide engineering audit, code-block audit counts, corrected dependency/syntax/logic defects, remaining manual validation, and future quality-gate recommendations |
| GEIL-PRJ-DOCARCH-001 | Documentation Architecture Review | Draft | `docs/project/documentation-architecture-review.md` | Repository-wide single-source-of-truth audit, document classification register, merge/archive/future recommendations, proposed structure, and navigation simplification plan |

## Platform documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-PLT-INDEX | Platform | Draft | `docs/legacy/platform/index.md` | Documentation delivery platform section |
| GEIL-PLT-CFPAGES-001 | Cloudflare Pages Deployment Runbook | Draft | `docs/legacy/platform/cloudflare-pages-deployment.md` | Private MkDocs deployment to Cloudflare Pages |
| GEIL-PLAT-MTK-HQ-LLD-001 | MikroTik CHR HQ Foundation LLD | Approved | `docs/legacy/platform/mikrotik-chr-hq-foundation-lld.md` | Active `HQ-FW01` MikroTik CHR / RouterOS LLD replacing OPNsense for Phase 1 |
| GEIL-PLAT-MTK-HQ-IMPL-001 | MikroTik CHR HQ Foundation Implementation Guide | Approved | `docs/legacy/platform/mikrotik-chr-hq-foundation-implementation.md` | RouterOS CHR image import, hardening, VLAN gateways, NAT, firewall, DHCP relay preparation, validation, rollback, and evidence |
| GEIL-PLAT-OPN-HQ-LLD-001 | Superseded OPNsense HQ Foundation LLD | Superseded | `docs/legacy/platform/opnsense-hq-foundation-lld.md` | Historical OPNsense alternative superseded by ADR-0002 |
| GEIL-PLAT-OPN-HQ-IMPL-001 | Superseded OPNsense HQ Foundation Implementation Runbook | Superseded | `docs/legacy/platform/opnsense-hq-foundation-implementation.md` | Historical OPNsense implementation guide superseded by ADR-0002 |
| GEIL-PLAT-FW-MATRIX-001 | Firewall Rule Matrix | Draft | `docs/network/firewall-rule-matrix.md` | Network authority for cross-service firewall flow matrix and validation references |
| GEIL-PLAT-AD-NET-001 | Active Directory Network Requirements | Approved | `docs/legacy/platform/active-directory-network-requirements.md` | Authoritative address-list based client-to-domain-controller firewall architecture, required AD service ports, pilot finding, validation, rollback, and evidence |
| GEIL-PLAT-PORTS-001 | Enterprise Port Reference | Draft | `docs/legacy/platform/enterprise-port-reference.md` | Microsoft Core, NPS, PKI, Entra, WinRM, RDP, monitoring, and management port reference |
| GEIL-PLAT-WS2025-GOLD-001 | Windows Server 2025 Golden Template | Draft | `docs/legacy/platform/windows-server-2025-golden-template.md` | Proxmox Windows Server 2025 template build, update, drivers, security, Sysprep, clone, validation, and rollback |

## Governance documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-GOV-DOC-001 | Documentation Standard | Draft | `docs/governance/documentation-standard.md` | Authoring requirements |
| GEIL-GOV-VISUAL-001 | Visual Documentation Standard | Approved | `docs/governance/visual-documentation-standard.md` | Mermaid usage rules, complex diagram asset standards, and replacement candidates |
| GEIL-GOV-IMPL-001 | Implementation Guide Standard | Approved | `docs/governance/implementation-guide-standard.md` | Microsoft Learn-style implementation guide template, teaching requirements, validation, rollback, evidence, screenshots, and knowledge checks |
| GEIL-GOV-EDU-001 | Educational Documentation Standard | Approved | `docs/governance/educational-documentation-standard.md` | Teaching-first methodology for implementation guides, enterprise/implementation admonitions, visual learning, value explanations, FAQs, and key takeaways |
| GEIL-GOV-NAME-001 | Naming and Addressing Standard | Draft | `docs/governance/naming-addressing-standard.md` | Names, tiers, VLANs, DNS |
| GEIL-ADR-0001 | ADR-0001 MkDocs Material Documentation Platform | Draft | `docs/governance/adrs/ADR-0001-mkdocs-material.md` | Accepted static documentation platform decision |
| GEIL-ADR-0003 | ADR-0003 Hybrid Identity Namespace | Accepted | `docs/governance/adrs/ADR-0003-hybrid-identity-namespace.md` | Accepted hybrid identity namespace decision for `corp.gntech.me`, `gntech.me`, and `GNTECH` |
| GEIL-ADR-0002 | ADR-0002 Use MikroTik CHR for Phase 1 HQ Firewall | Approved | `docs/governance/adrs/ADR-0002-mikrotik-chr-phase-1-firewall.md` | Accepted implementation change from OPNsense to MikroTik CHR for `HQ-FW01` |

## Security documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-SEC-INDEX | Security | Draft | `docs/legacy/security/index.md` | Cross-platform security architecture and controls |
| GEIL-SEC-PAM-001 | Privileged Access Model | Draft | `docs/legacy/security/privileged-access-model.md` | Tier 0/1/2 model, admin accounts, controlled group-based privileged membership, workstations, sign-in controls, emergency access |
| GEIL-SEC-TIER-001 | Enterprise Administrative Tiering | Draft | `docs/legacy/security/administrative-tiering.md` | Tier 0/1/2, PAWs, jump hosts, allowed/forbidden logons, and credential exposure controls |

## Architecture documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-ARCH-CAP-001 | Enterprise Capability Model | Approved | `docs/legacy/architecture/enterprise-capability-model.md` | Permanent enterprise capability model and dependencies |
| GEIL-ARCH-ERA-001 | Enterprise Reference Architecture | Approved | `docs/legacy/architecture/enterprise-reference-architecture.md` | High-level multinational architecture layers and diagrams |
| GEIL-ARCH-TECH-001 | Technology Selection Matrix | Approved | `docs/legacy/architecture/technology-selection-matrix.md` | Current technology choices, alternatives, pros, cons, and replacement strategy |
| GEIL-ARCH-IMPL-001 | Implementation Philosophy | Approved | `docs/legacy/architecture/implementation-philosophy.md` | Evolution from 15-user SMB to multinational corporation |
| GEIL-ARCH-PRINCIPLES-001 | Architecture Principles | Approved | `docs/legacy/architecture/architecture-principles.md` | Documentation First, Automation First, Zero Trust, scale, failure, and observability principles |
| GEIL-ARCH-LAB-001 | Enterprise Lab Blueprint HLD | Approved | `docs/legacy/architecture/enterprise-lab-blueprint.md` | Complete target enterprise HLD for implementation reference |
| GEIL-ARCH-LAB-NET-001 | Enterprise Lab Network HLD | Approved | `docs/legacy/architecture/enterprise-lab-network-hld.md` | Network, security zone, VLAN, IP addressing, WiFi, and routing HLD |
| GEIL-ARCH-LAB-ID-001 | Enterprise Lab Identity HLD | Approved | `docs/legacy/architecture/enterprise-lab-identity-hld.md` | Forest, domain, AD site, DNS, DHCP, PKI, identity, and cloud identity HLD |
| GEIL-ARCH-LAB-OPS-001 | Enterprise Lab Operations HLD | Approved | `docs/legacy/architecture/enterprise-lab-operations-hld.md` | Storage, backup, monitoring, DR, and operational readiness HLD |
| GEIL-ARCH-REF-001 | Reference Architecture | Draft | `docs/legacy/architecture/reference-architecture.md` | Overall platform architecture |
| GEIL-ARCH-TIER-001 | Environment Tiers | Draft | `docs/legacy/architecture/environment-tiers.md` | Lab, pilot, production, DR |
| GEIL-ARCH-ID-001 | Identity Architecture | Draft | `docs/legacy/architecture/identity-architecture.md` | Identity authorities and admin tiers |
| GEIL-ARCH-NET-001 | Network Architecture | Draft | `docs/network/network-architecture.md` | Network architecture, VLAN, management workstation, and firewall model |

## Foundation documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-FND-P0-001 | Phase 0 Prerequisites | Draft | `docs/legacy/foundation/phase-0-prerequisites.md` | Pre-implementation checklist |
| GEIL-FND-PVE-001 | Proxmox VE Baseline | Draft | `docs/legacy/foundation/proxmox-ve-baseline.md` | Virtualization baseline |
| GEIL-FND-OPN-001 | Superseded OPNsense Edge Firewall | Superseded | `docs/legacy/foundation/opnsense-edge-firewall.md` | Historical alternative edge firewall baseline superseded by ADR-0002 |

## Microsoft Core documents

| Phase | Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|---|
| Phase 1 - Identity Foundation | GEIL-MSC-WS2025-001 | Windows Server 2025 Baseline | Draft | `docs/microsoft-core/windows-server-2025-baseline.md` | Server baseline |
| Phase 1 - Identity Foundation | GEIL-MSC-AD-001 | Active Directory Implementation | Draft | `docs/microsoft-core/active-directory-implementation.md` | Microsoft Learn-style AD DS forest and first domain controller implementation guide |
| Phase 1 - Identity Foundation | GEIL-MSC-ADORG-001 | Active Directory Organizational Foundation | Draft | `docs/microsoft-core/active-directory-organizational-foundation.md` | OU hierarchy including Management Workstations, users, groups, baseline memberships, pilot Tier 0 bootstrap nesting, delegation, service accounts, GPO readiness, Entra ID readiness, validation, and rollback |
| Phase 1 - Identity Foundation | GEIL-MSC-NAME-001 | Enterprise Naming Standard | Draft | `docs/microsoft-core/active-directory-naming-standard.md` | Naming standards for users, computers, servers, groups, service accounts, GPOs, DNS, DFS, certificates, hypervisors, Proxmox, and MikroTik |
| Phase 1 - Identity Foundation | GEIL-MSC-AUTHSTD-001 | Authentication Standards | Approved | `docs/microsoft-core/authentication-standards.md` | Validated identity formats for Windows sign-in, RDP, PowerShell Remoting, Microsoft 365 / Entra ID, and cloud applications |
| Phase 2 - Core Infrastructure Services | GEIL-MSC-DNSDHCP-001 | DNS and DHCP Implementation | Draft | `docs/microsoft-core/dns-dhcp-implementation.md` | Microsoft Learn-style AD DNS, DNS forwarder, DHCP scope, and relay implementation guide |
| Phase 2 - Core Infrastructure Services | GEIL-MSC-GPO-001 | Group Policy Baseline | Draft | `docs/microsoft-core/group-policy-baseline.md` | Baseline GPO model, including `GP - Baseline - Workstations` and validated `GP - Baseline - Management Workstations` linked only to the Management Workstations OU with Remote Desktop, NLA, and PowerShell Script Block Logging settings |
| Phase 3 - Windows Client Lifecycle | GEIL-MSC-WCL-INDEX | Windows Client Lifecycle | Approved | `docs/microsoft-core/windows-client-lifecycle/index.md` | Phase 3 Windows Client Lifecycle entry point and deployment order |
| Phase 3 - Windows Client Lifecycle | GEIL-PLAT-W11-GOLD-001 | Windows 11 Enterprise Golden Template | Approved | `docs/microsoft-core/windows-client-lifecycle/windows-11-enterprise-golden-template.md` | Workgroup-only Proxmox Windows 11 template build with VirtIO, QEMU Guest Agent, Cloudbase-Init, Sysprep, and template conversion; domain join explicitly excluded |
| Phase 3 - Windows Client Lifecycle | GEIL-MSC-WCL-CLOUDBASE-001 | Cloudbase-Init for Proxmox | Approved | `docs/microsoft-core/windows-client-lifecycle/cloudbase-init-for-proxmox.md` | Cloudbase-Init lifecycle reference for Proxmox Windows 11 clones |
| Phase 3 - Windows Client Lifecycle | GEIL-PLAT-W11-MGMT-001 | Windows Management Workstation - HQ-MGMT01 | Approved | `docs/microsoft-core/windows-client-lifecycle/windows-11-management-workstation.md` | Deploy `HQ-MGMT01` as Windows 11 Enterprise management workstation / initial PAW on Management VLAN 10 with domain join after cloning, Management Workstations OU placement, RSAT/admin tools, and remote administration model |
| Phase 3 - Windows Client Lifecycle | GEIL-PLAT-W11-DOMJOIN-001 | Windows Domain Join and GPO Validation | Approved | `docs/microsoft-core/windows-client-lifecycle/windows-11-domain-join-gpo-validation.md` | Clone standard clients from template, attach VLAN30, validate DHCP/DNS/DC firewall, join `corp.gntech.me`, move computer object, and validate `GP - Baseline - Workstations` |
| Phase 3 - Windows Client Lifecycle | GEIL-MSC-WCL-STANDARD-001 | Standard Windows Client - HQ-W11-001 | Approved | `docs/microsoft-core/windows-client-lifecycle/standard-windows-client-hq-w11-001.md` | Standard Windows 11 client role on VLAN30 and the Workstations OU |
| Phase 4 - Administration | GEIL-MSC-PS-001 | PowerShell Operations | Draft | `docs/microsoft-core/powershell-operations.md` | Safe scripting standard |
| Phase 4 - Administration | GEIL-MSC-ADMIN-RSAT-001 | RSAT / Remote Administration | Approved | `docs/microsoft-core/administration/rsat-remote-administration.md` | RSAT and remote administration tooling on `HQ-MGMT01` |
| Phase 4 - Administration | GEIL-MSC-ADMIN-WSRM-001 | Windows Server Remote Management | Approved | `docs/microsoft-core/administration/windows-server-remote-management.md` | Remote server administration model from approved management workstations |
| Phase 4 - Administration | GEIL-MSC-ADMIN-WINRM-001 | Enterprise WinRM Management | Approved | `docs/microsoft-core/administration/enterprise-winrm-management.md` | Kerberos-based WinRM / PowerShell Remoting management model, including listener, firewall, MikroTik, VLAN segmentation, validation, and pilot findings |
| Phase 4 - Administration | GEIL-MSC-WSMGMT-WINRM-001 | WinRM / PowerShell Remoting Baseline | Draft | `docs/microsoft-core/windows-server-management/winrm-powershell-remoting-baseline.md` | Practical WinRM / PowerShell Remoting baseline for the GNTECH AD lab, including Kerberos, TrustedHosts guidance, GPO settings, validation, troubleshooting, and checklist |
| Windows Security Baselines | GEIL-MSC-WINSEC-INDEX | Windows Security Baselines | Draft | `docs/microsoft-core/windows-security/index.md` | Microsoft Core Windows security baseline section index |
| Windows Security Baselines | GEIL-MSC-WINSEC-FW-001 | Windows Firewall Baseline | Draft | `docs/microsoft-core/windows-security/windows-firewall-baseline.md` | Host-based Windows Defender Firewall baseline for Domain Controllers, member servers, management workstations, and standard workstations |
| Windows Security Baselines | GEIL-MSC-WINSEC-LAPS-001 | Windows LAPS Baseline | Draft | `docs/microsoft-core/windows-security/windows-laps-baseline.md` | Built-in Windows LAPS baseline for AD schema, OU permissions, GPO, retrieval, rotation, validation, operations, and troubleshooting |
| Windows Security Baselines | GEIL-MSC-WINSEC-DEF-001 | Microsoft Defender Enterprise Baseline | Approved | `docs/microsoft-core/windows-security/microsoft-defender-baseline.md` | Built-in Microsoft Defender Antivirus baseline managed through Active Directory Group Policy for Microsoft Core Windows clients |
| Windows Monitoring | GEIL-MSC-WINMON-INDEX | Windows Monitoring | Pilot Validated | `docs/microsoft-core/windows-monitoring/index.md` | Microsoft Core Windows monitoring section index |
| Windows Monitoring | GEIL-MSC-WINMON-WEF-001 | Windows Event Forwarding and Collector Baseline | Pilot Validated | `docs/microsoft-core/windows-monitoring/windows-event-forwarding-baseline.md` | Native Windows Event Forwarding architecture using dedicated collector `HQ-WEC01` |
| Phase 5 - File Services (Future) | GEIL-MSC-FILE-FS-001 | File Server | Future | `docs/microsoft-core/file-services/file-server.md` | Future file server capability placeholder; not active deployment guidance |
| Phase 5 - File Services (Future) | GEIL-MSC-FILE-DFS-001 | DFS | Future | `docs/microsoft-core/file-services/dfs.md` | Future DFS capability placeholder; not active deployment guidance |
| Phase 5 - File Services (Future) | GEIL-MSC-FILE-SMB-001 | SMB Shares and Permissions | Future | `docs/microsoft-core/file-services/smb-shares-permissions.md` | Future SMB permissions capability placeholder; not active deployment guidance |
| Phase 5 - File Services (Future) | GEIL-MSC-FILE-AGDLP-001 | AGDLP Access Model | Future | `docs/microsoft-core/file-services/agdlp-access-model.md` | Future file-services AGDLP application; not active deployment guidance |
| Phase 6 - Future Identity Expansion | GEIL-MSC-PKI-001 | PKI | Future | `docs/microsoft-core/ad-cs-pki.md` | Enterprise PKI planning; promote only after implementation |
| Phase 6 - Future Identity Expansion | GEIL-MSC-NPS-001 | NPS / RADIUS | Future | `docs/microsoft-core/nps-radius-8021x.md` | Network authentication planning; promote only after implementation |
| Phase 6 - Future Identity Expansion | GEIL-CLD-ENTRA-001 | Entra Hybrid | Future | `docs/legacy/cloud-endpoint/entra-id-hybrid-identity.md` | Identity sync planning; promote only after implementation |
| Phase 6 - Future Identity Expansion | GEIL-CLD-WHFB-001 | Windows Hello for Business | Future | `docs/legacy/cloud-endpoint/windows-hello-for-business.md` | Passwordless sign-in planning; promote only after implementation |
| Phase 6 - Future Identity Expansion | GEIL-MSC-WAC-001 | Windows Admin Center | Future | `docs/microsoft-core/windows-admin-center.md` | Management gateway planning; promote only after implementation |
| Identity and Access Reference | GEIL-MSC-GROUP-001 | Enterprise Group Strategy | Draft | `docs/microsoft-core/group-strategy.md` | Reference pending consolidation into Identity and Access Standard; not a loose deployment step |
| Identity and Access Reference | GEIL-MSC-USERLIFE-001 | Enterprise User Lifecycle | Draft | `docs/microsoft-core/user-lifecycle.md` | Reference pending consolidation into Identity and Access Standard; not a loose deployment step |
| Identity and Access Reference | GEIL-MSC-SVCACCT-001 | Enterprise Service Account Standard | Draft | `docs/microsoft-core/service-account-standard.md` | Reference pending consolidation into Identity and Access Standard; not a loose deployment step |

## Network documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-NET-INDEX | Network | Draft | `docs/network/index.md` | Entry point for practical network policy documents |
| GEIL-NET-MTK-WINMGMT-001 | MikroTik Windows Management Firewall Policy | Draft | `docs/network/mikrotik/windows-management-firewall-policy.md` | RouterOS firewall policy for Windows administration traffic between VLANs, including RDP, WinRM, AD services, validation, and checklist |

## Cloud and Endpoint / Future documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-FUT-INDEX | Future | Draft | `docs/legacy/future/index.md` | Planning section for technologies and capabilities not yet laboratory-validated |
| GEIL-CLD-M365-001 | Microsoft 365 Tenant Foundation | Future | `docs/legacy/cloud-endpoint/microsoft-365-tenant-foundation.md` | Tenant baseline planning; promote only after implementation |
| GEIL-CLD-INTUNE-001 | Intune Windows 11 Enterprise | Future | `docs/legacy/cloud-endpoint/intune-windows11-enterprise.md` | Endpoint management planning; promote only after implementation |
| GEIL-CLD-DEF-001 | Microsoft Defender | Future | `docs/legacy/cloud-endpoint/microsoft-defender.md` | Endpoint protection planning; promote only after implementation |

## Archive documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-ARC-INDEX | Archive | Draft | `docs/legacy/archive/index.md` | Superseded and historical references retained for traceability |
| GEIL-PLAT-OPN-HQ-LLD-001 | Superseded OPNsense HQ Foundation LLD | Superseded | `docs/legacy/platform/opnsense-hq-foundation-lld.md` | Historical OPNsense alternative superseded by ADR-0002 |
| GEIL-PLAT-OPN-HQ-IMPL-001 | Superseded OPNsense HQ Foundation Implementation Runbook | Superseded | `docs/legacy/platform/opnsense-hq-foundation-implementation.md` | Historical OPNsense implementation guide superseded by ADR-0002 |
| GEIL-FND-OPN-001 | Superseded OPNsense Edge Firewall | Superseded | `docs/legacy/foundation/opnsense-edge-firewall.md` | Historical alternative edge firewall baseline superseded by ADR-0002 |

## Operations documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-OPS-MON-001 | Monitoring and Alerting | Draft | `docs/legacy/operations/monitoring-alerting.md` | Required monitoring coverage |
| GEIL-OPS-BACKUP-001 | Backup and Recovery | Draft | `docs/legacy/operations/backup-recovery.md` | Recovery requirements |
| GEIL-OPS-DCBACKUP-001 | Domain Controller Backup and Recovery | Draft | `docs/legacy/operations/domain-controller-backup.md` | DC snapshots, System State, Bare Metal, authoritative/non-authoritative restore, and DR guidance |
| GEIL-OPS-TS-001 | Troubleshooting | Draft | `docs/legacy/operations/troubleshooting.md` | Incident triage workflow |
| GEIL-OPS-SCALE-001 | Scaling Model | Draft | `docs/legacy/operations/scaling-model.md` | Growth triggers |
| GEIL-OPS-SEC-001 | Security Operations | Draft | `docs/legacy/operations/security-operations.md` | Security checks and response |



## Windows Infrastructure Lab Deployment roadmap tracking

| Epic | Status | Current documents | Future documents |
|---|---|---|---|
| Enterprise WinRM Management | In progress | `docs/microsoft-core/windows-client-lifecycle/windows-11-management-workstation.md`; `docs/microsoft-core/windows-server-management/winrm-powershell-remoting-baseline.md`; `docs/network/mikrotik/windows-management-firewall-policy.md`; `docs/network/network-and-ad-services-matrix.md`; `docs/network/mikrotik/hq-fw01-firewall-policy.md` | GPO/Windows Firewall refinements as implementation matures |
| Windows Firewall Baseline | In progress | `docs/microsoft-core/windows-security/windows-firewall-baseline.md`; Network and AD services matrix; MikroTik Windows management firewall policy | Future role-specific documents: docs/microsoft-core/windows-security/domain-controller-firewall-baseline.md; docs/microsoft-core/windows-security/member-server-firewall-baseline.md |
| Windows LAPS | In progress | `docs/microsoft-core/windows-security/windows-laps-baseline.md`; Active Directory baseline; Management Workstation baseline; privileged access references | Future delegated retrieval group refinements |
| Microsoft Defender Baseline | In progress | `docs/microsoft-core/windows-security/microsoft-defender-baseline.md`; Windows Firewall Baseline; Windows LAPS Baseline; Group Policy Baseline | Future Windows Event Forwarding monitoring integration |
| Windows Event Forwarding | Pilot Validated | `docs/microsoft-core/windows-monitoring/windows-event-forwarding-baseline.md`; Enterprise WinRM Management; Windows Firewall Baseline; Microsoft Defender Baseline | Future SIEM/observability integration after WEF pilot validation |
| Enterprise Identity & Privileged Access Tier 0/1/2 | Planned | `docs/legacy/security/privileged-access-model.md`; `docs/legacy/security/administrative-tiering.md`; Management Workstation baseline | docs/microsoft-core/identity/privileged-access-tier-model.md |

## Release assignment summary

The authoritative document-to-release mapping is maintained in [Epic and Release Architecture](epic-release-architecture.md). Every published document must appear exactly once in that register.

| Epic | Release | Current Document Count |
|---|---|---:|
| E00 | E00.R01 - Documentation governance foundation | 28 |
| E00 | E00.R02 - Documentation delivery platform | 2 |
| E01 | E01.R01 - Enterprise reference architecture | 5 |
| E01 | E01.R02 - Enterprise Architecture Vision | 6 |
| E02 | E02.R01 - Site foundation and edge platform | 5 |
| E02 | E02.R02 - Enterprise Lab Blueprint | 4 |
| E02 | E02.R03 - HQ Foundation Low-Level Design and Build Plan | 15 |
| E02 | E02.R04 - HQ Foundation Implementation Runbook | 7 |
| E02 | E02.R05 - HQ Foundation Evidence and Acceptance Package | 1 |
| E03 | E03.R01 - Core directory services | 15 |
| E03 | E03.R02 - Trust and network authentication | 2 |
| E03 | E03.R03 - Privileged access control plane | 3 |
| E03 | E03.R06 - Service account lifecycle | 4 |
| E04 | E04.R01 - Cloud identity and endpoint management | 6 |
| E05 | E05.R01 - Operations readiness | 12 |
| E06 | WIN.R02 - Host Firewall and Local Admin Protection | 3 |
| E06 | WIN.R03 - Endpoint Protection and Monitoring | 3 |

## Index maintenance procedure

1. Add a row for every new production document.
2. Update status when a document moves from Draft to Approved or Retired.
3. Keep the path exact and relative to the repository root.
4. Keep related backlog and roadmap entries synchronized.
5. Keep the release assignment register synchronized so each document belongs to exactly one Release.

| GEIL-GOV-CODE-001 | Code Block Quality Standard | Approved | `docs/governance/code-block-quality-standard.md` | Mandatory quality gate for production-ready code blocks and copy/paste deployment commands |
