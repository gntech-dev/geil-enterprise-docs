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
| GEIL-PRJ-ENV-001 | Environment Specification | Approved | `docs/project/environment-specification.md` | Canonical GNTECH domains, names, VLANs, IP ranges, DNS, certificates, shares, repository, and documentation URLs |
| GEIL-PRJ-BACKLOG-001 | Documentation Backlog | Draft | `docs/project/documentation-backlog.md` | Work queue and priorities |
| GEIL-PRJ-INDEX-001 | Document Index | Draft | `docs/project/document-index.md` | Authoritative register |
| GEIL-PRJ-ROADMAP-001 | Documentation Roadmap | Draft | `docs/project/documentation-roadmap.md` | Capability-first Epic/Release roadmap |
| GEIL-PRJ-ERA-001 | Epic and Release Architecture | Approved | `docs/project/epic-release-architecture.md` | Epics, Releases, document assignments, dependency graphs, and scale model |
| GEIL-PRJ-PROD-AUDIT-001 | Production Readiness Audit Report | Draft | `docs/project/production-readiness-audit-report.md` | Repository-wide engineering audit, code-block audit counts, corrected dependency/syntax/logic defects, remaining manual validation, and future quality-gate recommendations |
| GEIL-PRJ-DOCARCH-001 | Documentation Architecture Review | Draft | `docs/project/documentation-architecture-review.md` | Repository-wide single-source-of-truth audit, document classification register, merge/archive/future recommendations, proposed structure, and navigation simplification plan |

## Platform documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-PLT-INDEX | Platform | Draft | `docs/platform/index.md` | Documentation delivery platform section |
| GEIL-PLT-CFPAGES-001 | Cloudflare Pages Deployment Runbook | Draft | `docs/platform/cloudflare-pages-deployment.md` | Private MkDocs deployment to Cloudflare Pages |
| GEIL-PLAT-MTK-HQ-LLD-001 | MikroTik CHR HQ Foundation LLD | Approved | `docs/platform/mikrotik-chr-hq-foundation-lld.md` | Active `HQ-FW01` MikroTik CHR / RouterOS LLD replacing OPNsense for Phase 1 |
| GEIL-PLAT-MTK-HQ-IMPL-001 | MikroTik CHR HQ Foundation Implementation Guide | Approved | `docs/platform/mikrotik-chr-hq-foundation-implementation.md` | RouterOS CHR image import, hardening, VLAN gateways, NAT, firewall, DHCP relay preparation, validation, rollback, and evidence |
| GEIL-PLAT-OPN-HQ-LLD-001 | Superseded OPNsense HQ Foundation LLD | Superseded | `docs/platform/opnsense-hq-foundation-lld.md` | Historical OPNsense alternative superseded by ADR-0002 |
| GEIL-PLAT-OPN-HQ-IMPL-001 | Superseded OPNsense HQ Foundation Implementation Runbook | Superseded | `docs/platform/opnsense-hq-foundation-implementation.md` | Historical OPNsense implementation guide superseded by ADR-0002 |
| GEIL-PLAT-FW-MATRIX-001 | Firewall Rule Matrix | Draft | `docs/platform/firewall-rule-matrix.md` | Canonical MikroTik CHR firewall flow matrix for Microsoft Core and enterprise services |
| GEIL-PLAT-AD-NET-001 | Active Directory Network Requirements | Approved | `docs/platform/active-directory-network-requirements.md` | Authoritative address-list based client-to-domain-controller firewall architecture, required AD service ports, pilot finding, validation, rollback, and evidence |
| GEIL-PLAT-PORTS-001 | Enterprise Port Reference | Draft | `docs/platform/enterprise-port-reference.md` | Microsoft Core, NPS, PKI, Entra, WinRM, RDP, monitoring, and management port reference |
| GEIL-PLAT-WS2025-GOLD-001 | Windows Server 2025 Golden Template | Draft | `docs/platform/windows-server-2025-golden-template.md` | Proxmox Windows Server 2025 template build, update, drivers, security, Sysprep, clone, validation, and rollback |

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
| GEIL-SEC-INDEX | Security | Draft | `docs/security/index.md` | Cross-platform security architecture and controls |
| GEIL-SEC-PAM-001 | Privileged Access Model | Draft | `docs/security/privileged-access-model.md` | Tier 0/1/2 model, admin accounts, controlled group-based privileged membership, workstations, sign-in controls, emergency access |
| GEIL-SEC-TIER-001 | Enterprise Administrative Tiering | Draft | `docs/security/administrative-tiering.md` | Tier 0/1/2, PAWs, jump hosts, allowed/forbidden logons, and credential exposure controls |

## Architecture documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-ARCH-CAP-001 | Enterprise Capability Model | Approved | `docs/architecture/enterprise-capability-model.md` | Permanent enterprise capability model and dependencies |
| GEIL-ARCH-ERA-001 | Enterprise Reference Architecture | Approved | `docs/architecture/enterprise-reference-architecture.md` | High-level multinational architecture layers and diagrams |
| GEIL-ARCH-TECH-001 | Technology Selection Matrix | Approved | `docs/architecture/technology-selection-matrix.md` | Current technology choices, alternatives, pros, cons, and replacement strategy |
| GEIL-ARCH-IMPL-001 | Implementation Philosophy | Approved | `docs/architecture/implementation-philosophy.md` | Evolution from 15-user SMB to multinational corporation |
| GEIL-ARCH-PRINCIPLES-001 | Architecture Principles | Approved | `docs/architecture/architecture-principles.md` | Documentation First, Automation First, Zero Trust, scale, failure, and observability principles |
| GEIL-ARCH-LAB-001 | Enterprise Lab Blueprint HLD | Approved | `docs/architecture/enterprise-lab-blueprint.md` | Complete target enterprise HLD for implementation reference |
| GEIL-ARCH-LAB-NET-001 | Enterprise Lab Network HLD | Approved | `docs/architecture/enterprise-lab-network-hld.md` | Network, security zone, VLAN, IP addressing, WiFi, and routing HLD |
| GEIL-ARCH-LAB-ID-001 | Enterprise Lab Identity HLD | Approved | `docs/architecture/enterprise-lab-identity-hld.md` | Forest, domain, AD site, DNS, DHCP, PKI, identity, and cloud identity HLD |
| GEIL-ARCH-LAB-OPS-001 | Enterprise Lab Operations HLD | Approved | `docs/architecture/enterprise-lab-operations-hld.md` | Storage, backup, monitoring, DR, and operational readiness HLD |
| GEIL-ARCH-REF-001 | Reference Architecture | Draft | `docs/architecture/reference-architecture.md` | Overall platform architecture |
| GEIL-ARCH-TIER-001 | Environment Tiers | Draft | `docs/architecture/environment-tiers.md` | Lab, pilot, production, DR |
| GEIL-ARCH-ID-001 | Identity Architecture | Draft | `docs/architecture/identity-architecture.md` | Identity authorities and admin tiers |
| GEIL-ARCH-NET-001 | Network Architecture | Draft | `docs/architecture/network-architecture.md` | VLAN, management workstation, and firewall model |

## Foundation documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-FND-P0-001 | Phase 0 Prerequisites | Draft | `docs/foundation/phase-0-prerequisites.md` | Pre-implementation checklist |
| GEIL-FND-PVE-001 | Proxmox VE Baseline | Draft | `docs/foundation/proxmox-ve-baseline.md` | Virtualization baseline |
| GEIL-FND-OPN-001 | Superseded OPNsense Edge Firewall | Superseded | `docs/foundation/opnsense-edge-firewall.md` | Historical alternative edge firewall baseline superseded by ADR-0002 |

## Microsoft Core documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-MSC-WS2025-001 | Windows Server 2025 Baseline | Draft | `docs/microsoft-core/windows-server-2025-baseline.md` | Server baseline |
| GEIL-MSC-AD-001 | Active Directory Implementation | Draft | `docs/microsoft-core/active-directory-implementation.md` | Microsoft Learn-style AD DS forest and first domain controller implementation guide |
| GEIL-MSC-ADORG-001 | Active Directory Organizational Foundation | Draft | `docs/microsoft-core/active-directory-organizational-foundation.md` | OU hierarchy including Management Workstations, users, groups, baseline memberships, pilot Tier 0 bootstrap nesting, delegation, service accounts, GPO readiness, Entra ID readiness, validation, and rollback |
| GEIL-MSC-NAME-001 | Enterprise Naming Standard | Draft | `docs/microsoft-core/active-directory-naming-standard.md` | Naming standards for users, computers, servers, groups, service accounts, GPOs, DNS, DFS, certificates, hypervisors, Proxmox, and MikroTik |
| GEIL-MSC-GROUP-001 | Enterprise Group Strategy | Draft | `docs/microsoft-core/group-strategy.md` | AGDLP, AGUDLP, RBAC, baseline membership model, group nesting, naming convention, examples, PowerShell, and validation |
| GEIL-MSC-USERLIFE-001 | Enterprise User Lifecycle | Draft | `docs/microsoft-core/user-lifecycle.md` | New hire, termination, department change, privilege elevation, contractors, guests, password reset, lockout, and offboarding |
| GEIL-MSC-SVCACCT-001 | Enterprise Service Account Standard | Draft | `docs/microsoft-core/service-account-standard.md` | Standard service accounts, gMSA, scheduled tasks, IIS, SQL, NPS, Entra Connect, backup, monitoring, rotation, and least privilege |
| GEIL-MSC-DNSDHCP-001 | DNS and DHCP Implementation | Draft | `docs/microsoft-core/dns-dhcp-implementation.md` | Microsoft Learn-style AD DNS, DNS forwarder, DHCP scope, and relay implementation guide |
| GEIL-MSC-GPO-001 | Group Policy Baseline | Draft | `docs/microsoft-core/group-policy-baseline.md` | Baseline GPO model, including future Management Workstations GPO architecture |
| GEIL-MSC-WCL-INDEX | Windows Client Lifecycle | Approved | `docs/microsoft-core/windows-client-lifecycle/index.md` | Phase 3 Windows Client Lifecycle entry point and deployment order |
| GEIL-PLAT-W11-GOLD-001 | Windows 11 Enterprise Golden Template | Approved | `docs/microsoft-core/windows-client-lifecycle/windows-11-enterprise-golden-template.md` | Workgroup-only Proxmox Windows 11 template build with VirtIO, QEMU Guest Agent, Cloudbase-Init, Sysprep, and template conversion; domain join explicitly excluded |
| GEIL-PLAT-W11-MGMT-001 | Windows 11 Management Workstation | Approved | `docs/microsoft-core/windows-client-lifecycle/windows-11-management-workstation.md` | Deploy `HQ-MGMT01` as Windows 11 Enterprise management workstation / initial PAW on Management VLAN 10 with domain join after cloning, Management Workstations OU placement, RSAT/admin tools, and remote administration model |
| GEIL-PLAT-W11-DOMJOIN-001 | Windows 11 Domain Join and GPO Validation | Approved | `docs/microsoft-core/windows-client-lifecycle/windows-11-domain-join-gpo-validation.md` | Clone standard clients from template, attach VLAN30, validate DHCP/DNS/DC firewall, join `corp.gntech.me`, move computer object, and validate `GP - Baseline - Workstations` |
| GEIL-MSC-WAC-001 | Windows Admin Center | Draft | `docs/microsoft-core/windows-admin-center.md` | Management gateway |
| GEIL-MSC-PS-001 | PowerShell Operations | Draft | `docs/microsoft-core/powershell-operations.md` | Safe scripting standard |

## Cloud and Endpoint / Future documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-FUT-INDEX | Future | Draft | `docs/future/index.md` | Planning section for technologies and capabilities not yet laboratory-validated |
| GEIL-CLD-M365-001 | Microsoft 365 Tenant Foundation | Future | `docs/cloud-endpoint/microsoft-365-tenant-foundation.md` | Tenant baseline planning; promote only after implementation |
| GEIL-CLD-ENTRA-001 | Entra ID Hybrid Identity | Future | `docs/cloud-endpoint/entra-id-hybrid-identity.md` | Identity sync planning; promote only after implementation |
| GEIL-CLD-INTUNE-001 | Intune Windows 11 Enterprise | Future | `docs/cloud-endpoint/intune-windows11-enterprise.md` | Endpoint management planning; promote only after implementation |
| GEIL-CLD-WHFB-001 | Windows Hello for Business | Future | `docs/cloud-endpoint/windows-hello-for-business.md` | Passwordless sign-in planning; promote only after implementation |
| GEIL-CLD-DEF-001 | Microsoft Defender | Future | `docs/cloud-endpoint/microsoft-defender.md` | Endpoint protection planning; promote only after implementation |
| GEIL-MSC-PKI-001 | AD CS PKI | Future | `docs/microsoft-core/ad-cs-pki.md` | Enterprise PKI planning; promote only after implementation |
| GEIL-MSC-NPS-001 | NPS RADIUS 802.1X | Future | `docs/microsoft-core/nps-radius-8021x.md` | Network authentication planning; promote only after implementation |

## Archive documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-ARC-INDEX | Archive | Draft | `docs/archive/index.md` | Superseded and historical references retained for traceability |
| GEIL-PLAT-OPN-HQ-LLD-001 | Superseded OPNsense HQ Foundation LLD | Superseded | `docs/platform/opnsense-hq-foundation-lld.md` | Historical OPNsense alternative superseded by ADR-0002 |
| GEIL-PLAT-OPN-HQ-IMPL-001 | Superseded OPNsense HQ Foundation Implementation Runbook | Superseded | `docs/platform/opnsense-hq-foundation-implementation.md` | Historical OPNsense implementation guide superseded by ADR-0002 |
| GEIL-FND-OPN-001 | Superseded OPNsense Edge Firewall | Superseded | `docs/foundation/opnsense-edge-firewall.md` | Historical alternative edge firewall baseline superseded by ADR-0002 |

## Operations documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-OPS-MON-001 | Monitoring and Alerting | Draft | `docs/operations/monitoring-alerting.md` | Required monitoring coverage |
| GEIL-OPS-BACKUP-001 | Backup and Recovery | Draft | `docs/operations/backup-recovery.md` | Recovery requirements |
| GEIL-OPS-DCBACKUP-001 | Domain Controller Backup and Recovery | Draft | `docs/operations/domain-controller-backup.md` | DC snapshots, System State, Bare Metal, authoritative/non-authoritative restore, and DR guidance |
| GEIL-OPS-TS-001 | Troubleshooting | Draft | `docs/operations/troubleshooting.md` | Incident triage workflow |
| GEIL-OPS-SCALE-001 | Scaling Model | Draft | `docs/operations/scaling-model.md` | Growth triggers |
| GEIL-OPS-SEC-001 | Security Operations | Draft | `docs/operations/security-operations.md` | Security checks and response |


## Release assignment summary

The authoritative document-to-release mapping is maintained in [Epic and Release Architecture](epic-release-architecture.md). Every published document must appear exactly once in that register.

| Epic | Release | Current Document Count |
|---|---|---:|
| E00 | E00.R01 - Documentation governance foundation | 27 |
| E00 | E00.R02 - Documentation delivery platform | 2 |
| E01 | E01.R01 - Enterprise reference architecture | 5 |
| E01 | E01.R02 - Enterprise Architecture Vision | 6 |
| E02 | E02.R01 - Site foundation and edge platform | 5 |
| E02 | E02.R02 - Enterprise Lab Blueprint | 4 |
| E02 | E02.R03 - HQ Foundation Low-Level Design and Build Plan | 8 |
| E02 | E02.R04 - HQ Foundation Implementation Runbook | 7 |
| E02 | E02.R05 - HQ Foundation Evidence and Acceptance Package | 1 |
| E03 | E03.R01 - Core directory services | 12 |
| E03 | E03.R02 - Trust and network authentication | 2 |
| E03 | E03.R03 - Privileged access control plane | 3 |
| E04 | E04.R01 - Cloud identity and endpoint management | 6 |
| E05 | E05.R01 - Operations readiness | 8 |

## Index maintenance procedure

1. Add a row for every new production document.
2. Update status when a document moves from Draft to Approved or Retired.
3. Keep the path exact and relative to the repository root.
4. Keep related backlog and roadmap entries synchronized.
5. Keep the release assignment register synchronized so each document belongs to exactly one Release.

| GEIL-GOV-CODE-001 | Code Block Quality Standard | Approved | `docs/governance/code-block-quality-standard.md` | Mandatory quality gate for production-ready code blocks and copy/paste deployment commands |
