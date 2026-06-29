---
title: Roadmap
document_id: GEIL-GOV-ROADMAP-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Roadmap

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-GOV-ROADMAP-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

The roadmap sequences GEIL from first usable internal documentation to full enterprise operating model.

## Phase 1: Documentation platform and baseline architecture

- MkDocs Material repository.
- Document standard, naming standard, ADR template.
- Reference network and identity architecture.
- Cloudflare Pages deployment procedure.

## Phase 2: Core on-premises foundation

- Proxmox VE hardened baseline.
- OPNsense WAN/LAN/VLAN/firewall/VPN baseline.
- Windows Server 2025 baseline.
- AD DS, DNS, DHCP, GPO implementation.

## Phase 3: Security services

- AD CS enterprise PKI.
- NPS RADIUS and 802.1X.
- Tiered administration model.
- Defender baseline.

## Phase 4: Microsoft cloud integration

- Microsoft 365 tenant foundation.
- Entra ID hybrid identity.
- Intune Windows 11 Enterprise enrollment.
- Windows Hello for Business.

## Phase 5: Operations and scale

- Monitoring and alerting.
- Backup and recovery.
- Troubleshooting runbooks.
- Multisite and multinational scaling model.

## Roadmap governance

Each phase must exit with:

1. Published docs.
2. Change evidence.
3. Validation results.
4. Backlog updates.
5. ADRs for deviations.
