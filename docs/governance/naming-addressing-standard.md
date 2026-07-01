---
title: Naming and Addressing Standard
document_id: GEIL-GOV-NAME-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Naming and Addressing Standard

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-GOV-NAME-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

!!! note "Adaptation"

    This document uses canonical GNTECH values from the [Environment Specification](../project/environment-specification.md). Organizations adapting this design should change the environment specification first, then update all affected DNS zones, certificates, PowerShell commands, Group Policies, VLANs, firewall rules, and service configurations.

## Purpose

This standard creates consistent names for sites, servers, clients, service accounts, groups, VLANs, DNS records, and certificates.

## Site codes

Use three to five uppercase characters per site.

| Site Type | Example | Notes |
|---|---|---|
| Headquarters | `HQ` | Primary administrative site |
| Branch | `NYC01` | City plus sequence |
| Datacenter | `DC01` | Physical or colocation datacenter |
| Cloud region | `AZEUS` | Azure East US if used later |

## Server names

Format: `{SITE}-{ROLE}{NN}` where GEIL uses the canonical site code `HQ` unless the environment specification is updated.

Examples:

- `HQ-DC01` domain controller
- `HQ-DC02` domain controller
- `HQ-DC01` certificate authority
- `HQ-DC01` initial RADIUS/NPS role during bootstrap until a dedicated NPS host is added to the environment specification
- `HQ-MGMT01` Windows Admin Center gateway

## Administrative accounts

| Tier | Format | Example | Use |
|---|---|---|---|
| Tier 0 | `adm0.<username>` | `adm0.j.smith` | AD DS, PKI, Entra Connect, domain controllers |
| Tier 1 | `adm1.<username>` | `adm1.j.smith` | Servers and infrastructure applications |
| Tier 2 | `adm2.<username>` | `adm2.j.smith` | Workstations and endpoint support |

## VLAN and subnet baseline

| VLAN | Name | Example CIDR | Purpose |
|---:|---|---|---|
| 10 | Management | `172.20.10.0/24` | Firewall, switch, and management interfaces |
| 20 | Servers | `172.20.20.0/24` | Windows servers and infrastructure services |
| 30 | Workstations | `172.20.30.0/24` | Windows 11 Enterprise clients |
| 40 | Printers | `172.20.40.0/24` | Printers and MFPs |
| 50 | Voice | `172.20.50.0/24` | Voice devices |
| 60 | Corporate WiFi | `172.20.60.0/24` | 802.1X corporate wireless |
| 70 | Guest WiFi | `172.20.70.0/24` | Internet-only guest wireless |
| 80 | DMZ | `172.20.80.0/24` | Public-facing or isolated services |
| 90 | Backup | `172.20.90.0/24` | Backup transport and storage services |
| 100 | Hypervisors | `172.20.100.0/24` | Proxmox VE host management and cluster traffic |

## DNS names

- Internal AD DNS: `corp.gntech.me`.
- Public DNS: managed separately in Cloudflare.
- Avoid using the same DNS zone internally and externally unless split-brain DNS is intentionally documented.

## Validation

Before implementation, confirm that names are unique:

```powershell
Resolve-DnsName HQ-DC01.corp.gntech.me -ErrorAction SilentlyContinue
Get-ADComputer -Filter "Name -eq 'HQ-DC01'"
```

Expected result: no existing DNS or AD object for the new name.

## Rollback

If a name collision is found before production use, rename the object before joining it to the domain. If already domain joined, use `Rename-Computer`, reboot, and validate DNS scavenging.
