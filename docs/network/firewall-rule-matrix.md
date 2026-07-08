---
title: Firewall Rule Matrix
document_id: GEIL-PLAT-FW-MATRIX-001
owner: Infrastructure Engineering
status: Pilot Validated
version: 2.1
last_reviewed: 2026-07-08
review_cycle: Per validated export
classification: Internal Confidential
---

# Firewall Rule Matrix

## Purpose

This matrix summarizes current `HQ-FW01` firewall flows from the validated RouterOS export. Operational rule order and exact rules are authoritative in [HQ-FW01 Firewall Policy](mikrotik/hq-fw01-firewall-policy.md).

## Source of truth

| Source | Authority |
|---|---|
| Current RouterOS snapshot | [HQ-FW01 RouterOS Export - Current Validated Snapshot](mikrotik/hq-fw01-routeros-export-current.md) |
| Operational firewall policy | [HQ-FW01 Firewall Policy](mikrotik/hq-fw01-firewall-policy.md) |
| VLANs and subnets | [VLAN and Subnet Plan](vlan-and-subnet-plan.md) |
| AD and Windows service paths | [Network and Active Directory Services Matrix](network-and-ad-services-matrix.md) |

## Current flow matrix

| Source | Destination | Ports / protocol | Export action | Notes |
|---|---|---|---|---|
| Established/related | Any | Existing sessions | Allow | First forward rule. |
| Invalid | Any | Invalid state | Drop | Before new traffic allows. |
| VLAN70 Guest `172.20.70.0/24` | Internal `172.20.0.0/16` | Any | Drop | Guest isolation. |
| VLAN70 Guest `172.20.70.0/24` | WAN | Any permitted by upstream | Allow | Guest internet only. |
| `HQ-MGMT01` `172.20.10.10` | Proxmox `172.20.100.11` | TCP `8006` | Allow | Proxmox management. |
| `HQ-MGMT01` `172.20.10.10` | `HQ-DC01` `172.20.20.11` | Any | Allow | Current management prep rule from export. |
| Interface list `LAN` | WAN | New connections | Allow | Approved internal VLAN internet. |
| Containers `172.17.0.0/24` | WAN | Any | Allow | Container internet. |
| Cloudflared `172.17.0.2` | VLAN20 Servers | Any | Allow | Current export. |
| Cloudflared `172.17.0.2` | VLAN80 DMZ | Any | Allow | Current export. |
| Cloudflared `172.17.0.2` | VLAN10 Management | Any | Allow | Current export. |
| VLAN30 Workstations | `HQ-DC01` | TCP `3389,5985` | Drop | Must remain before broad VLAN30-to-DC allow. |
| VLAN30 Workstations | `HQ-DC01` | Any | Temporary allow | `TEMP ALLOW VLAN30 clients to HQ-DC01`. |
| `HQ-DC01` | `HQ-MGMT01` | TCP `3389` | Temporary allow | `TEMP allow HQ-DC01 to RDP HQ-MGMT01`. |
| Management VLAN | Workstations VLAN | TCP `5985` | Allow | WinRM management to workstations. |
| Management VLAN | `HQ-WEC01` | TCP `3389,5985` | Allow | WEC admin ports. |
| Workstations VLAN | `HQ-WEC01` | TCP `5985` | Allow | WEF source-initiated clients. |
| Management VLAN | `HQ-WEC01` | TCP `5985` | Allow | WEF from management source. |
| Unapproved forwarding | Any | Any | Drop | Default deny. |

## Validation commands

Run on: `HQ-FW01`

When: validating matrix against export and current router state.

Expected outcome: counters increment on the matching rules and default deny remains last.

```routeros
/ip firewall filter print stats
/ip firewall nat print
/ip route print
```
