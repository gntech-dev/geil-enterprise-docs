---
title: Environment Specification
document_id: GEIL-PRJ-ENV-001
owner: Infrastructure Engineering
status: Approved
version: 2.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Environment Specification

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-PRJ-ENV-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 2.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This document is the single source of truth for canonical GNTECH environment values used throughout GEIL. GEIL documents the real GNTECH enterprise implementation; it is not a generic reference architecture.

Before writing or updating any GEIL document, review this specification and use these canonical values consistently. If a canonical value changes, update this document first, then identify and update every affected document.

!!! note "Adaptation"

    This implementation uses GNTECH's real enterprise values, including **corp.gntech.me**, **gntech.me**, **HQ-DC01**, and the **172.20.0.0/16** network. Organizations adapting this library should replace these values with their own approved environment values and review all DNS zones, certificates, PowerShell commands, Group Policies, network scopes, firewall rules, and service configurations.

## Real values policy

Do not use generic placeholders for values that are already known in this document. GEIL implementation documents must use the canonical GNTECH values below.

## Allowed placeholders

Only use placeholders when the value cannot be known before deployment or must not be committed.

| Placeholder | Replacement Requirement |
|---|---|
| `<PUBLIC_IP>` | Replace with the ISP-assigned public IPv4 or IPv6 address for the relevant WAN service. |
| `<AZURE_TENANT_ID>` | Replace with the Microsoft Entra tenant ID for GNTECH after tenant verification. |
| `<SUBSCRIPTION_ID>` | Replace with the Azure subscription ID when Azure resources are introduced. |
| `<CLIENT_SECRET>` | Replace with the generated application secret value and store it in the approved password manager, never in Git. |
| `<PASSWORD>` | Replace with a unique generated secret stored in the approved password manager, never in Git. |
| `<CERTIFICATE_THUMBPRINT>` | Replace with the certificate thumbprint from the issued certificate store. |
| `<SERIAL_NUMBER>` | Replace with the hardware, certificate, or vendor serial number being documented. |
| `<API_KEY>` | Replace with the generated API key and store it in the approved password manager, never in Git. |

## Organization and tenant values

| Item | Canonical Value |
|---|---|
| Organization | GNTECH |
| Public domain | `gntech.me` |
| Microsoft 365 tenant | `gntech.me` |
| Internal Active Directory forest | `corp.gntech.me` |
| Internal Active Directory domain | `corp.gntech.me` |
| NetBIOS name | `CORP` |
| Primary site | `HQ` |
| Primary datacenter | `HQ` |
| Documentation site | `docs.gntechlabs.me` |
| Repository | `geil-enterprise-docs` |

## Core infrastructure names

| Role | Canonical Name | Notes |
|---|---|---|
| Virtualization platform | Proxmox VE | Standard hypervisor platform |
| Primary hypervisor | `PVE-HQ01` | Primary Proxmox VE host |
| Backup server | `PBS-HQ01` | Proxmox Backup Server |
| Firewall | `HQ-FW01` | MikroTik CHR / RouterOS firewall |
| Primary domain controller | `HQ-DC01` | First Windows Server 2025 domain controller |
| Future secondary domain controller | `HQ-DC02` | Future second domain controller |
| Management workstation | `HQ-MGMT01` | Administrative workstation |
| First Windows client | `HQ-W11-001` | First Windows 11 Enterprise client |

## DNS naming

| Zone or Record Type | Canonical Value |
|---|---|
| AD DNS zone | `corp.gntech.me` |
| Public DNS zone | `gntech.me` |
| Documentation FQDN | `docs.gntechlabs.me` |
| Primary DC FQDN | `HQ-DC01.corp.gntech.me` |
| Secondary DC FQDN | `HQ-DC02.corp.gntech.me` |
| Management workstation FQDN | `HQ-MGMT01.corp.gntech.me` |
| First Windows client FQDN | `HQ-W11-001.corp.gntech.me` |

## Active Directory naming

| Item | Canonical Value |
|---|---|
| Forest | `corp.gntech.me` |
| Domain | `corp.gntech.me` |
| Distinguished name | `DC=corp,DC=gntech,DC=me` |
| NetBIOS | `CORP` |
| Admin root OU | `OU=Admin,DC=corp,DC=gntech,DC=me` |
| Servers OU | `OU=Servers,DC=corp,DC=gntech,DC=me` |
| Workstations OU | `OU=Workstations,DC=corp,DC=gntech,DC=me` |
| Groups OU | `OU=Groups,DC=corp,DC=gntech,DC=me` |
| Service Accounts OU | `OU=Service Accounts,DC=corp,DC=gntech,DC=me` |
| Disabled Objects OU | `OU=Disabled Objects,DC=corp,DC=gntech,DC=me` |

## Network baseline

| VLAN | Name | CIDR | Gateway Convention | Primary Use |
|---:|---|---|---|---|
| 10 | Management | `172.20.10.0/24` | `172.20.10.1` | Firewall, switch, and management interfaces |
| 20 | Servers | `172.20.20.0/24` | `172.20.20.1` | Windows servers and infrastructure services |
| 30 | Workstations | `172.20.30.0/24` | `172.20.30.1` | Windows 11 Enterprise clients |
| 40 | Printers | `172.20.40.0/24` | `172.20.40.1` | Printers and MFPs |
| 50 | Voice | `172.20.50.0/24` | `172.20.50.1` | Voice devices |
| 60 | Corporate WiFi | `172.20.60.0/24` | `172.20.60.1` | 802.1X corporate wireless clients |
| 70 | Guest WiFi | `172.20.70.0/24` | `172.20.70.1` | Internet-only guest wireless |
| 80 | DMZ | `172.20.80.0/24` | `172.20.80.1` | Public-facing or isolated services |
| 90 | Backup | `172.20.90.0/24` | `172.20.90.1` | Backup transport and storage services |
| 100 | Hypervisors | `172.20.100.0/24` | `172.20.100.1` | Proxmox VE host management and cluster traffic |

Supernet: `172.20.0.0/16`.

## Firewall platform baseline

| Item | Canonical Value |
|---|---|
| Active firewall platform | MikroTik CHR / RouterOS |
| Firewall host | `HQ-FW01` |
| WAN interface | `ether1` connected to `GEILWAN` |
| LAN trunk interface | `ether2` connected to `GEILLAN` |
| GEILWAN transit | `172.31.255.0/30` |
| Proxmox GEILWAN endpoint | `172.31.255.1/30` |
| CHR WAN endpoint | `172.31.255.2/30` |
| CHR default route | `172.31.255.1` |

## Baseline infrastructure IP assignments

| Host | Interface Network | Canonical IP |
|---|---|---|
| `HQ-FW01` | VLAN 10 Management gateway | `172.20.10.1` |
| `HQ-DC01` | VLAN 20 Servers | `172.20.20.11` |
| `HQ-DC02` | VLAN 20 Servers | `172.20.20.12` |
| `HQ-MGMT01` | VLAN 30 Workstations | `172.20.30.10` |
| `HQ-W11-001` | VLAN 30 Workstations | DHCP reservation or dynamic lease in `172.20.30.0/24` |
| `PBS-HQ01` | VLAN 90 Backup | `172.20.90.10` |
| `PVE-HQ01` | VLAN 100 Hypervisors | `172.20.100.11` |

## DHCP scope baseline

| Scope | VLAN | Range | Router | DNS Servers | DNS Suffix |
|---|---:|---|---|---|---|
| `WORKSTATIONS-HQ` | 30 | `172.20.30.50`-`172.20.30.250` | `172.20.30.1` | `172.20.20.11`, `172.20.20.12` | `corp.gntech.me` |
| `PRINTERS-HQ` | 40 | `172.20.40.50`-`172.20.40.200` | `172.20.40.1` | `172.20.20.11`, `172.20.20.12` | `corp.gntech.me` |
| `CORPWIFI-HQ` | 60 | `172.20.60.50`-`172.20.60.250` | `172.20.60.1` | `172.20.20.11`, `172.20.20.12` | `corp.gntech.me` |
| `GUESTWIFI-HQ` | 70 | `172.20.70.50`-`172.20.70.250` | `172.20.70.1` | Public resolver policy via `HQ-FW01` | None |

## Certificate naming

| Certificate Type | Canonical Subject / SAN Requirement |
|---|---|
| Domain controller certificate | Subject or SAN includes `HQ-DC01.corp.gntech.me` and later `HQ-DC02.corp.gntech.me` |
| Windows Admin Center certificate | Subject/SAN for `HQ-MGMT01.corp.gntech.me` if hosted there, or the approved WAC host FQDN |
| NPS server certificate | Subject/SAN for the NPS host FQDN when NPS is deployed |
| Documentation site certificate | Public certificate for `docs.gntechlabs.me` via Cloudflare |
| Internal issuing CA | `GNTECH-CORP-Issuing-CA01` |

## Share naming

| Share | UNC Path | Purpose |
|---|---|---|
| Infrastructure tools | `\HQ-DC01\Infrastructure$` | Internal bootstrap and administrative tooling if hosted on the primary DC during initial build |
| Change logs | `\HQ-DC01\ChangeLogs$` | Temporary initial location for implementation transcripts before a dedicated file service exists |
| Backup staging | `\PBS-HQ01\BackupStaging$` | Backup staging when SMB access is explicitly configured |

Avoid placing long-term file services on domain controllers after the initial bootstrap phase.

## Repository and documentation URLs

| Item | Canonical Value |
|---|---|
| Repository name | `geil-enterprise-docs` |
| Repository remote | `https://github.com/gntech-dev/geil-enterprise-docs.git` |
| Documentation production URL | `https://docs.gntechlabs.me` |
| MkDocs site URL | `https://docs.gntechlabs.me/` |

## Change procedure for canonical values

1. Open a documentation change request.
2. Update this environment specification first.
3. Search the repository for the old value.
4. Update every affected document, command, diagram, DNS reference, GPO reference, certificate reference, and cross-reference.
5. Run `mkdocs build --strict`.
6. Commit and push only after the build passes.
