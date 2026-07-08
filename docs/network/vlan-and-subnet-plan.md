---
title: VLAN and Subnet Plan
document_id: GEIL-NET-VLAN-SUBNET-001
owner: Infrastructure Engineering
status: Pilot Validated
version: 1.1
last_reviewed: 2026-07-08
review_cycle: Per validated export
classification: Internal Confidential
---

# VLAN and Subnet Plan

## Purpose

This document is the authoritative VLAN and subnet plan for the current GNTECH lab network. It is synchronized to [HQ-FW01 RouterOS Export - Current Validated Snapshot](mikrotik/hq-fw01-routeros-export-current.md).

## Current VLAN and subnet matrix

| VLAN / Zone | VLAN ID | Subnet/CIDR | Gateway | RouterOS interface | Status |
|---|---:|---|---|---|---|
| Management VLAN | 10 | `172.20.10.0/24` | `172.20.10.1` | `vlan10-mgmt` | Current export |
| Servers VLAN | 20 | `172.20.20.0/24` | `172.20.20.1` | `vlan20-servers` | Current export |
| Workstations VLAN | 30 | `172.20.30.0/24` | `172.20.30.1` | `vlan30-workstations` | Current export |
| Printers VLAN | 40 | `172.20.40.0/24` | `172.20.40.1` | `vlan40-printers` | Current export |
| Voice VLAN | 50 | `172.20.50.0/24` | `172.20.50.1` | `vlan50-voice` | Current export |
| Corporate WiFi VLAN | 60 | `172.20.60.0/24` | `172.20.60.1` | `vlan60-corpwifi` | Current export |
| Guest WiFi VLAN | 70 | `172.20.70.0/24` | `172.20.70.1` | `vlan70-guestwifi` | Current export |
| DMZ VLAN | 80 | `172.20.80.0/24` | `172.20.80.1` | `vlan80-dmz` | Current export |
| Backup VLAN | 90 | `172.20.90.0/24` | `172.20.90.1` | `vlan90-backup` | Current export |
| Hypervisors VLAN | 100 | `172.20.100.0/24` | `172.20.100.1` | `vlan100-hypervisor` | Current export |
| Container network | Internal | `172.17.0.0/24` | `172.17.0.1` | `containers` bridge / `veth-cloudflared` | Current export |
| GEIL WAN transit | Transit | `172.31.255.0/30` | Peer `172.31.255.1`; `HQ-FW01` `172.31.255.2` | `ether1` | Current export |

## Authority rules

- RouterOS interface, IP addressing, DHCP relay, DNS, NAT, firewall, and service restrictions must match the current validated export.
- Service-port and AD access expectations are maintained in [Network and Active Directory Services Matrix](network-and-ad-services-matrix.md).
- Operational RouterOS firewall rules are maintained in [HQ-FW01 Firewall Policy](mikrotik/hq-fw01-firewall-policy.md).
