---
title: Document Index
document_id: GEIL-PRJ-INDEX-001
owner: Infrastructure Engineering
status: Draft
version: 9.0
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
| Version | 9.0 |
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

## Platform documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-PLT-INDEX | Platform | Draft | `docs/platform/index.md` | Documentation delivery platform section |
| GEIL-PLT-CFPAGES-001 | Cloudflare Pages Deployment Runbook | Draft | `docs/platform/cloudflare-pages-deployment.md` | Private MkDocs deployment to Cloudflare Pages |

## Governance documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-GOV-DOC-001 | Documentation Standard | Draft | `docs/governance/documentation-standard.md` | Authoring requirements |
| GEIL-GOV-VISUAL-001 | Visual Documentation Standard | Approved | `docs/governance/visual-documentation-standard.md` | Mermaid usage rules, complex diagram asset standards, and replacement candidates |
| GEIL-GOV-NAME-001 | Naming and Addressing Standard | Draft | `docs/governance/naming-addressing-standard.md` | Names, tiers, VLANs, DNS |
| GEIL-ADR-0001 | ADR-0001 MkDocs Material Documentation Platform | Draft | `docs/governance/adrs/ADR-0001-mkdocs-material.md` | Accepted static documentation platform decision |

## Security documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-SEC-INDEX | Security | Draft | `docs/security/index.md` | Cross-platform security architecture and controls |
| GEIL-SEC-PAM-001 | Privileged Access Model | Draft | `docs/security/privileged-access-model.md` | Tier 0/1/2 model, admin accounts, groups, workstations, sign-in controls, emergency access |

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
| GEIL-ARCH-NET-001 | Network Architecture | Draft | `docs/architecture/network-architecture.md` | VLAN and firewall model |

## Foundation documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-FND-P0-001 | Phase 0 Prerequisites | Draft | `docs/foundation/phase-0-prerequisites.md` | Pre-implementation checklist |
| GEIL-FND-PVE-001 | Proxmox VE Baseline | Draft | `docs/foundation/proxmox-ve-baseline.md` | Virtualization baseline |
| GEIL-FND-OPN-001 | OPNsense Edge Firewall | Draft | `docs/foundation/opnsense-edge-firewall.md` | Edge segmentation baseline |

## Microsoft Core documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-MSC-WS2025-001 | Windows Server 2025 Baseline | Draft | `docs/microsoft-core/windows-server-2025-baseline.md` | Server baseline |
| GEIL-MSC-AD-001 | Active Directory Implementation | Draft | `docs/microsoft-core/active-directory-implementation.md` | AD DS forest and DC deployment |
| GEIL-MSC-DNSDHCP-001 | DNS and DHCP Implementation | Draft | `docs/microsoft-core/dns-dhcp-implementation.md` | Name and address services |
| GEIL-MSC-GPO-001 | Group Policy Baseline | Draft | `docs/microsoft-core/group-policy-baseline.md` | Baseline GPO model |
| GEIL-MSC-PKI-001 | AD CS PKI | Draft | `docs/microsoft-core/ad-cs-pki.md` | Enterprise PKI architecture |
| GEIL-MSC-NPS-001 | NPS RADIUS 802.1X | Draft | `docs/microsoft-core/nps-radius-8021x.md` | Network authentication |
| GEIL-MSC-WAC-001 | Windows Admin Center | Draft | `docs/microsoft-core/windows-admin-center.md` | Management gateway |
| GEIL-MSC-PS-001 | PowerShell Operations | Draft | `docs/microsoft-core/powershell-operations.md` | Safe scripting standard |

## Cloud and Endpoint documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-CLD-M365-001 | Microsoft 365 Tenant Foundation | Draft | `docs/cloud-endpoint/microsoft-365-tenant-foundation.md` | Tenant baseline |
| GEIL-CLD-ENTRA-001 | Entra ID Hybrid Identity | Draft | `docs/cloud-endpoint/entra-id-hybrid-identity.md` | Identity sync |
| GEIL-CLD-INTUNE-001 | Intune Windows 11 Enterprise | Draft | `docs/cloud-endpoint/intune-windows11-enterprise.md` | Endpoint management |
| GEIL-CLD-WHFB-001 | Windows Hello for Business | Draft | `docs/cloud-endpoint/windows-hello-for-business.md` | Passwordless sign-in |
| GEIL-CLD-DEF-001 | Microsoft Defender | Draft | `docs/cloud-endpoint/microsoft-defender.md` | Endpoint protection |

## Operations documents

| Document ID | Title | Status | Path | Notes |
|---|---|---|---|---|
| GEIL-OPS-MON-001 | Monitoring and Alerting | Draft | `docs/operations/monitoring-alerting.md` | Required monitoring coverage |
| GEIL-OPS-BACKUP-001 | Backup and Recovery | Draft | `docs/operations/backup-recovery.md` | Recovery requirements |
| GEIL-OPS-TS-001 | Troubleshooting | Draft | `docs/operations/troubleshooting.md` | Incident triage workflow |
| GEIL-OPS-SCALE-001 | Scaling Model | Draft | `docs/operations/scaling-model.md` | Growth triggers |
| GEIL-OPS-SEC-001 | Security Operations | Draft | `docs/operations/security-operations.md` | Security checks and response |


## Release assignment summary

The authoritative document-to-release mapping is maintained in [Epic and Release Architecture](epic-release-architecture.md). Every published document must appear exactly once in that register.

| Epic | Release | Current Document Count |
|---|---|---:|
| E00 | E00.R01 - Documentation governance foundation | 14 |
| E00 | E00.R02 - Documentation delivery platform | 2 |
| E01 | E01.R01 - Enterprise reference architecture | 5 |
| E01 | E01.R02 - Enterprise Architecture Vision | 6 |
| E02 | E02.R01 - Site foundation and edge platform | 5 |
| E02 | E02.R02 - Enterprise Lab Blueprint | 4 |
| E02 | E02.R03 - HQ Foundation Low-Level Design and Build Plan | 4 |
| E02 | E02.R04 - HQ Foundation Implementation Runbook | 2 |
| E02 | E02.R05 - HQ Foundation Evidence and Acceptance Package | 1 |
| E03 | E03.R01 - Core directory services | 6 |
| E03 | E03.R02 - Trust and network authentication | 2 |
| E03 | E03.R03 - Privileged access control plane | 2 |
| E04 | E04.R01 - Cloud identity and endpoint management | 6 |
| E05 | E05.R01 - Operations readiness | 7 |

## Index maintenance procedure

1. Add a row for every new production document.
2. Update status when a document moves from Draft to Approved or Retired.
3. Keep the path exact and relative to the repository root.
4. Keep related backlog and roadmap entries synchronized.
5. Keep the release assignment register synchronized so each document belongs to exactly one Release.
