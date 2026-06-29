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

Format: `<SITE>-<ROLE><NN>`

Examples:

- `HQ-DC01` domain controller
- `HQ-DC02` domain controller
- `HQ-PKI01` certificate authority
- `HQ-NPS01` RADIUS server
- `HQ-WAC01` Windows Admin Center gateway

## Administrative accounts

| Tier | Format | Example | Use |
|---|---|---|---|
| Tier 0 | `adm0.<username>` | `adm0.j.smith` | AD DS, PKI, Entra Connect, domain controllers |
| Tier 1 | `adm1.<username>` | `adm1.j.smith` | Servers and infrastructure applications |
| Tier 2 | `adm2.<username>` | `adm2.j.smith` | Workstations and endpoint support |

## VLAN and subnet baseline

| VLAN | Name | Example CIDR | Purpose |
|---:|---|---|---|
| 10 | MGMT | `10.10.10.0/24` | Proxmox, OPNsense management, switch management |
| 20 | SERVER | `10.10.20.0/24` | Windows servers |
| 30 | CLIENT | `10.10.30.0/24` | Windows 11 clients |
| 40 | VOICE | `10.10.40.0/24` | Voice devices |
| 50 | WIFI-CORP | `10.10.50.0/24` | 802.1X corporate wireless |
| 60 | WIFI-GUEST | `10.10.60.0/24` | Internet-only guest wireless |
| 70 | IOT | `10.10.70.0/24` | Printers, scanners, non-domain devices |

## DNS names

- Internal AD DNS: `<AD_DOMAIN_FQDN>` such as `corp.<TENANT_NAME>.internal`.
- Public DNS: managed separately in Cloudflare.
- Avoid using the same DNS zone internally and externally unless split-brain DNS is intentionally documented.

## Validation

Before implementation, confirm that names are unique:

```powershell
Resolve-DnsName HQ-DC01.<AD_DOMAIN_FQDN> -ErrorAction SilentlyContinue
Get-ADComputer -Filter "Name -eq 'HQ-DC01'"
```

Expected result: no existing DNS or AD object for the new name.

## Rollback

If a name collision is found before production use, rename the object before joining it to the domain. If already domain joined, use `Rename-Computer`, reboot, and validate DNS scavenging.
