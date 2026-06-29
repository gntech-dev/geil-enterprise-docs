---
title: Documentation Roadmap
document_id: GEIL-PRJ-ROADMAP-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
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
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

The documentation roadmap sequences GEIL from a usable internal documentation foundation to a complete enterprise operations library.

## Phase 1: Documentation platform and baseline architecture

| Deliverable | Status | Evidence |
|---|---|---|
| MkDocs Material repository | Done | `mkdocs.yml`, `requirements.txt`, strict build validation |
| Project charter | Done | [GEIL Project Charter](project-charter.md) |
| Document standard | Done | [Documentation Standard](../governance/documentation-standard.md) |
| Naming standard | Done | [Naming and Addressing Standard](../governance/naming-addressing-standard.md) |
| Document index | Done | [Document Index](document-index.md) |
| Documentation backlog | Done | [Documentation Backlog](documentation-backlog.md) |
| Reference network and identity architecture | Done | Architecture section |
| Cloudflare Pages deployment procedure | Done | [Cloudflare Pages Deployment Runbook](../platform/cloudflare-pages-deployment.md) |

## Phase 2: Core on-premises foundation

| Deliverable | Status | Evidence |
|---|---|---|
| Proxmox VE hardened baseline | Done | [Proxmox VE Baseline](../foundation/proxmox-ve-baseline.md) |
| OPNsense WAN/LAN/VLAN/firewall baseline | Done | [OPNsense Edge Firewall](../foundation/opnsense-edge-firewall.md) |
| Windows Server 2025 baseline | Done | [Windows Server 2025 Baseline](../microsoft-core/windows-server-2025-baseline.md) |
| AD DS, DNS, DHCP, and GPO implementation | Done | Microsoft Core section |
| Privileged access model | Open | Backlog `DOC-002` |

## Phase 3: Security services

| Deliverable | Status | Evidence |
|---|---|---|
| AD CS enterprise PKI | Done | [AD CS PKI](../microsoft-core/ad-cs-pki.md) |
| NPS RADIUS and 802.1X | Done | [NPS RADIUS 802.1X](../microsoft-core/nps-radius-8021x.md) |
| Tiered administration model | Open | Backlog `DOC-002` |
| Defender baseline | Done | [Microsoft Defender](../cloud-endpoint/microsoft-defender.md) |
| Certificate lifecycle runbook | Open | Backlog `DOC-003` |

## Phase 4: Microsoft cloud integration

| Deliverable | Status | Evidence |
|---|---|---|
| Microsoft 365 tenant foundation | Done | [Microsoft 365 Tenant Foundation](../cloud-endpoint/microsoft-365-tenant-foundation.md) |
| Entra ID hybrid identity | Done | [Entra ID Hybrid Identity](../cloud-endpoint/entra-id-hybrid-identity.md) |
| Intune Windows 11 Enterprise enrollment | Done | [Intune Windows 11 Enterprise](../cloud-endpoint/intune-windows11-enterprise.md) |
| Windows Hello for Business | Done | [Windows Hello for Business](../cloud-endpoint/windows-hello-for-business.md) |
| Conditional Access baseline | Open | Backlog `DOC-004` |

## Phase 5: Operations and scale

| Deliverable | Status | Evidence |
|---|---|---|
| Monitoring and alerting | Done | [Monitoring and Alerting](../operations/monitoring-alerting.md) |
| Backup and recovery | Done | [Backup and Recovery](../operations/backup-recovery.md) |
| Troubleshooting runbooks | In Progress | [Troubleshooting](../operations/troubleshooting.md) plus future service runbooks |
| Multisite scaling model | Done | [Scaling Model](../operations/scaling-model.md) |
| Multinational data residency | Open | Backlog `DOC-005` |

## Roadmap governance

Each phase exits only when:

1. Published documents are linked in navigation.
2. Validation evidence exists.
3. Backlog rows are updated.
4. Required ADRs are created or explicitly deferred.
5. `mkdocs build --strict` succeeds.
