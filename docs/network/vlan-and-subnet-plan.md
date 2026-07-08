---
title: VLAN and Subnet Plan
document_id: GEIL-NET-VLAN-SUBNET-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-08
review_cycle: Quarterly
classification: Internal Confidential
---

# VLAN and Subnet Plan

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-NET-VLAN-SUBNET-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-07-08 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This document is the authoritative VLAN and subnet plan for the current GNTECH lab network.

Detailed service ports and inter-VLAN service expectations are maintained in [Network and Active Directory Services Matrix](network-and-ad-services-matrix.md). Current operational MikroTik firewall policy is maintained in [HQ-FW01 Firewall Policy](mikrotik/hq-fw01-firewall-policy.md).

## VLAN and subnet matrix

| VLAN / Zone | VLAN ID | Subnet/CIDR | Gateway | Purpose | Example systems |
|---|---:|---|---|---|---|
| Management VLAN | 10 | `172.20.10.0/24` | `172.20.10.1` | Management workstations and infrastructure administration | `HQ-MGMT01`, `HQ-FW01` gateway interface |
| Servers VLAN | 20 | `172.20.20.0/24` | `172.20.20.1` | Domain controllers and Windows infrastructure services | `HQ-DC01` (`172.20.20.11`), `HQ-WEC01` (`172.20.20.21`) |
| Workstations VLAN | 30 | `172.20.30.0/24` | `172.20.30.1` | Windows 11 Enterprise clients | `HQ-W11-001` |
| Printers VLAN | 40 | `172.20.40.0/24` | `172.20.40.1` | Printers and MFPs | Future printers |
| Voice VLAN | 50 | `172.20.50.0/24` | `172.20.50.1` | Voice devices | Future phones |
| Corporate WiFi VLAN | 60 | `172.20.60.0/24` | `172.20.60.1` | 802.1X corporate wireless clients | Future domain or Entra-managed clients |
| Guest VLAN | 70 | `172.20.70.0/24` | `172.20.70.1` | Internet-only guest access | Guest devices |
| DMZ VLAN | 80 | `172.20.80.0/24` | `172.20.80.1` | Public-facing or isolated services | Future DMZ hosts |
| Backup VLAN | 90 | `172.20.90.0/24` | `172.20.90.1` | Backup transport and storage services | `PBS-HQ01` |
| Hypervisors VLAN | 100 | `172.20.100.0/24` | `172.20.100.1` | Proxmox VE host management and cluster traffic | `PVE-HQ01` |
| GEIL WAN transit | Transit | `172.31.255.0/30` | `172.31.255.1` | Proxmox-to-firewall WAN transit | `HQ-FW01` WAN `172.31.255.2` |

## Authority rules

- Network addressing changes must update this document first.
- Service-port and AD access expectations must update [Network and Active Directory Services Matrix](network-and-ad-services-matrix.md).
- RouterOS firewall rules must update [HQ-FW01 Firewall Policy](mikrotik/hq-fw01-firewall-policy.md).
- Platform deployment guides may reference this plan but must not become the authoritative VLAN source of truth.
