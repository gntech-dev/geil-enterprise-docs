---
title: Environment Specification
document_id: GEIL-PRJ-ENV-001
owner: Infrastructure Engineering
status: Approved
version: 3.2
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
| Version | 3.2 |
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
| NetBIOS name | `GNTECH` |
| Primary user UPN suffix | `gntech.me` |
| Microsoft 365 verified domain | `gntech.me` |
| Default user sign-in | `username@gntech.me` |
| Legacy logon format | `GNTECH\username` |
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
| Management workstation / initial PAW | `HQ-MGMT01` | Windows 11 Enterprise dedicated privileged administration workstation; not a server |
| First Windows client | `HQ-W11-001` | Windows 11 Enterprise standard user/client validation VM |


## Management workstation architecture

`HQ-MGMT01` is the dedicated Windows 11 Enterprise management workstation and initial privileged access workstation (PAW) for GEIL. It is not a Windows Server. Windows Server must not be used as a daily administrative workstation. Servers host infrastructure roles; privileged administration originates from a hardened workstation.

| Host | Operating System | Purpose | VLAN/IP | Administrative role |
|---|---|---|---|---|
| `HQ-MGMT01` | Windows 11 Enterprise | Dedicated management workstation / initial PAW | VLAN 30, `172.20.30.10` | RSAT/admin tools, privileged administration of `HQ-DC01`, `HQ-FW01`, `PVE-HQ01`, and future servers |
| `HQ-W11-001` | Windows 11 Enterprise | Standard user and client validation VM | VLAN 30, DHCP reservation or dynamic lease | Validates DHCP, DNS, domain join, Group Policy, endpoint controls, Intune, and WHfB as a normal client |

Rationale:

- Remote administration from a hardened workstation reduces routine interactive server logons.
- Administrative tiering is easier to enforce when admin activity originates from a known endpoint.
- The model prepares for PAW hardening, LAPS, Windows Hello for Business, Microsoft Entra ID, Just-in-Time access, and Just Enough Administration.
- `HQ-MGMT01` is deployed from the Windows 11 golden template, attached to `GEILLAN` VLAN 30, validated for DHCP/DNS/domain-controller access, joined to `corp.gntech.me` after cloning, and then equipped with RSAT/admin tools.

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
| NetBIOS | `GNTECH` |
| Primary user UPN suffix | `gntech.me` |
| Production user sign-in | `username@gntech.me` |
| Legacy logon format | `GNTECH\username` |
| Disallowed production UPN pattern | `username@corp.gntech.me` except when explaining the default pre-suffix AD state |
| Managed organization root OU | `OU=GNTECH,DC=corp,DC=gntech,DC=me` |
| Admin root OU | `OU=Admin,OU=GNTECH,DC=corp,DC=gntech,DC=me` |
| Tier 0 admin OU | `OU=Tier 0,OU=Admin,OU=GNTECH,DC=corp,DC=gntech,DC=me` |
| Tier 1 admin OU | `OU=Tier 1,OU=Admin,OU=GNTECH,DC=corp,DC=gntech,DC=me` |
| Tier 2 admin OU | `OU=Tier 2,OU=Admin,OU=GNTECH,DC=corp,DC=gntech,DC=me` |
| Standard users OU | `OU=Standard,OU=Users,OU=GNTECH,DC=corp,DC=gntech,DC=me` |
| Groups security OU | `OU=Security,OU=Groups,OU=GNTECH,DC=corp,DC=gntech,DC=me` |
| Workstations OU | `OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me` |
| Servers OU | `OU=Servers,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me` |
| Service Accounts OU | `OU=Service Accounts,OU=GNTECH,DC=corp,DC=gntech,DC=me` |
| Disabled users OU | `OU=Disabled,OU=Users,OU=GNTECH,DC=corp,DC=gntech,DC=me` |

## Active Directory organizational foundation

The canonical managed OU root is `OU=GNTECH,DC=corp,DC=gntech,DC=me`. Naming, group, user lifecycle, service account, administrative tiering, firewall matrix, port reference, backup, and golden-template standards are required identity-foundation prerequisites. Create and validate this structure with [Active Directory Organizational Foundation](../microsoft-core/active-directory-organizational-foundation.md) before Group Policy, PKI, Entra ID sync, or production onboarding.

Initial users and service accounts use the primary UPN suffix `gntech.me`, for example `gnolasco@gntech.me`, `admin.gnolasco@gntech.me`, `svc-backup@gntech.me`, and `svc-monitoring@gntech.me`.

## Hybrid identity namespace

GEIL intentionally separates the Active Directory DNS namespace from the user authentication namespace.

| Identity Layer | Canonical Value | Purpose |
|---|---|---|
| Forest root domain | `corp.gntech.me` | Internal AD DS forest and DNS namespace |
| DNS namespace | `corp.gntech.me` | AD-integrated DNS records such as `HQ-DC01.corp.gntech.me` |
| NetBIOS domain | `GNTECH` | Legacy Windows logon and compatibility namespace |
| Primary user UPN suffix | `gntech.me` | Default user sign-in namespace |
| Microsoft 365 verified domain | `gntech.me` | Entra ID, Microsoft 365, Intune, WHfB, and cloud services |
| Default user sign-in | `username@gntech.me` | Production user authentication format |
| Legacy logon | `GNTECH\username` | Supported legacy Windows logon format |

Production user accounts must use `username@gntech.me`. Do not use `username@corp.gntech.me` for production logons except when explaining the default Active Directory state before the hybrid UPN suffix is configured. Server FQDNs and AD DNS records remain in `corp.gntech.me`.


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

This is the active GEIL firewall model. OPNsense material is retained only where documents explicitly state that it is historical or superseded. Active implementation, validation, acceptance, operations, and troubleshooting use MikroTik CHR / RouterOS on `HQ-FW01`.

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
| Internal issuing CA | `GNTECH-Issuing-CA01` |

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
