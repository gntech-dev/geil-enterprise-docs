---
title: Windows Security Baselines
document_id: GEIL-MSC-WINSEC-INDEX
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-07-02
review_cycle: Quarterly
classification: Internal Confidential
---

# Windows Security Baselines

## Purpose

This section contains Microsoft Core host security baselines for the GNTECH Windows Infrastructure Lab.

These baselines are intentionally incremental. They start with host firewall and local Administrator password controls, then support later Microsoft Defender, Windows Event Forwarding, and privileged access maturity work.

## Baselines

| Order | Document | Purpose |
|---:|---|---|
| 1 | [Windows Firewall Baseline](windows-firewall-baseline.md) | Defines Windows Defender Firewall profile defaults, management-port scoping, role expectations, validation, and troubleshooting. |
| 2 | [Windows LAPS Baseline](windows-laps-baseline.md) | Implements built-in Windows LAPS for local Administrator password management across domain-joined Windows systems. |

## Source of truth

Use the [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md) for canonical VLANs, subnets, AD service ports, Windows management ports, and inter-VLAN firewall expectations.
