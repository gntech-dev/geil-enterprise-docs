---
title: Network Architecture
document_id: GEIL-ARCH-NET-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Network Architecture

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-ARCH-NET-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Define the standard segmented network design for GEIL deployments.

## Default VLAN model

| VLAN | Name | Gateway Example | Internet | Server Access |
|---:|---|---|---|---|
| 10 | MGMT | `10.10.10.1` | Restricted | Admin only |
| 20 | SERVER | `10.10.20.1` | Restricted | Required services |
| 30 | CLIENT | `10.10.30.1` | Allowed | AD/DNS/DHCP/PKI/NPS only |
| 50 | WIFI-CORP | `10.10.50.1` | Allowed | Same as CLIENT after 802.1X |
| 60 | WIFI-GUEST | `10.10.60.1` | Allowed | Denied |
| 70 | IOT | `10.10.70.1` | Restricted | Print and update services only |

## Required firewall policy

Default deny between VLANs. Add explicit rules for:

- DNS: clients to domain controllers TCP/UDP 53.
- Kerberos: TCP/UDP 88.
- LDAP/LDAPS: TCP/UDP 389, TCP 636 as required.
- SMB to domain controllers: TCP 445 for SYSVOL/NETLOGON.
- NTP: UDP 123 to approved time source.
- RADIUS: UDP 1812/1813 from network devices to NPS.

## Validation

From a Windows client:

```powershell
Test-NetConnection HQ-DC01.<AD_DOMAIN_FQDN> -Port 53
Test-NetConnection HQ-DC01.<AD_DOMAIN_FQDN> -Port 88
Test-NetConnection HQ-DC01.<AD_DOMAIN_FQDN> -Port 445
```

Expected result: required ports succeed; unrelated server ports fail from client VLANs.

## Rollback

Export the OPNsense configuration before rule changes. If authentication or DNS breaks, restore the previous firewall alias/rule set and reload filters.
