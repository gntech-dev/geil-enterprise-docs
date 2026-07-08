---
title: Network
document_id: GEIL-NET-INDEX
owner: Infrastructure Engineering
status: Approved
version: 1.1
last_reviewed: 2026-07-08
review_cycle: Quarterly
classification: Internal Confidential
---

# Network

## Purpose

This section is the authoritative home for current GEIL network configuration, VLANs, service paths, and MikroTik firewall policy.

Network configuration authority now lives under `docs/network/`. Project, Platform, and Microsoft Core documents should link here instead of owning current network rule truth.

## Authoritative documents

| Order | Document | Authority |
|---:|---|---|
| 1 | [Network Architecture](network-architecture.md) | Current network architecture and design context. |
| 2 | [VLAN and Subnet Plan](vlan-and-subnet-plan.md) | Canonical VLAN IDs, subnets, gateways, and example systems. |
| 3 | [Network and Active Directory Services Matrix](network-and-ad-services-matrix.md) | Canonical service ports, AD DS paths, Windows management paths, and inter-VLAN service expectations. |
| 4 | [Firewall Rule Matrix](firewall-rule-matrix.md) | Cross-service firewall rule matrix and validation references. |
| 5 | [HQ-FW01 Firewall Policy](mikrotik/hq-fw01-firewall-policy.md) | Authoritative operational MikroTik firewall policy and rule order. |
| 6 | [HQ-FW01 RouterOS Baseline](mikrotik/hq-fw01-routeros-baseline.md) | RouterOS baseline and post-deployment network authority. |
| 7 | [Cloudflared Container Networking](mikrotik/cloudflared-container-networking.md) | Cloudflared container network boundaries and validation. |
| 8 | [MikroTik Windows Management Firewall Policy](mikrotik/windows-management-firewall-policy.md) | Windows management firewall context; current rule truth links to HQ-FW01 Firewall Policy. |

## Related deployment context

- [MikroTik CHR HQ Foundation Implementation](../legacy/platform/mikrotik-chr-hq-foundation-implementation.md)
- [Enterprise WinRM Management](../microsoft-core/administration/enterprise-winrm-management.md)
