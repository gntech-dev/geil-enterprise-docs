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

!!! note "Adaptation"

    This document uses canonical GNTECH values from the [Environment Specification](../project/environment-specification.md). Organizations adapting this design should change the environment specification first, then update all affected DNS zones, certificates, PowerShell commands, Group Policies, VLANs, firewall rules, and service configurations.

## Purpose

Define the standard segmented network design for GEIL deployments.

## Default VLAN model

| VLAN | Name | Gateway Example | Internet | Server Access |
|---:|---|---|---|---|
| 10 | Management | `172.20.10.1` | Restricted | Admin only |
| 20 | Servers | `172.20.20.1` | Restricted | Infrastructure services |
| 30 | Workstations | `172.20.30.1` | Allowed | AD/DNS/DHCP/PKI/NPS only |
| 40 | Printers | `172.20.40.1` | Restricted | Print services only |
| 50 | Voice | `172.20.50.1` | Restricted | Voice services only |
| 60 | Corporate WiFi | `172.20.60.1` | Allowed | Same as Workstations after 802.1X |
| 70 | Guest WiFi | `172.20.70.1` | Allowed | Denied |
| 80 | DMZ | `172.20.80.1` | Restricted | Explicit published services only |
| 90 | Backup | `172.20.90.1` | Denied by default | Backup targets only |
| 100 | Hypervisors | `172.20.100.1` | Restricted | Management and cluster services only |

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
Test-NetConnection HQ-DC01.corp.gntech.me -Port 53
Test-NetConnection HQ-DC01.corp.gntech.me -Port 88
Test-NetConnection HQ-DC01.corp.gntech.me -Port 445
```

Expected result: required ports succeed; unrelated server ports fail from client VLANs.

## Rollback

Export the RouterOS configuration before rule changes. If authentication or DNS breaks, restore the previous firewall alias/rule set and reload filters.
