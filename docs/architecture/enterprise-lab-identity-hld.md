---
title: Enterprise Lab Identity HLD
document_id: GEIL-ARCH-LAB-ID-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Enterprise Lab Identity HLD

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-ARCH-LAB-ID-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This document defines the identity, directory, DNS, DHCP, PKI, privileged access, and cloud identity High-Level Design for the GEIL Enterprise Lab Blueprint.

It is architecture only. Implementation documents for AD DS, DNS, DHCP, PKI, NPS, Microsoft 365, Entra ID, Intune, and privileged access must reference this HLD.

## Forest and domain design

| Design Element | Decision |
|---|---|
| Forest | `corp.gntech.me` |
| Domain | `corp.gntech.me` |
| NetBIOS | `CORP` |
| Initial DC | `HQ-DC01` |
| Future second DC | `HQ-DC02` |
| Forest strategy | Single forest, single domain for Phase 1 through small enterprise scale |
| Future expansion | Add AD sites and subnets before adding domains |

```mermaid
flowchart TD
    Forest[Forest: corp.gntech.me]
    Domain[Domain: corp.gntech.me / CORP]
    HQSite[AD Site: HQ]
    DC1[HQ-DC01]
    DC2[HQ-DC02 Future]
    FutureSites[Future AD Sites]
    Forest --> Domain
    Domain --> HQSite
    HQSite --> DC1
    HQSite --> DC2
    Domain --> FutureSites
```

## Active Directory site design

Phase 1 uses a single AD site named `HQ`. Future sites are added when routed networks and operational requirements justify site-aware authentication and replication.

| AD Site | Subnets | Domain Controllers | Purpose |
|---|---|---|---|
| `HQ` | `172.20.0.0/16` initially, refined to VLAN subnets as needed | `HQ-DC01`, future `HQ-DC02` | Primary authentication and service location |
| Future regional site | Future routed regional supernet | Only if survivability or latency requires it | Regional authentication and service locality |

## DNS architecture

```mermaid
flowchart TD
    Clients[Domain Clients]
    DnsZone[AD-Integrated Zone: corp.gntech.me]
    DC1[HQ-DC01 DNS]
    DC2[HQ-DC02 DNS Future]
    Forwarders[Approved External Forwarders]
    Public[Public DNS: gntech.me]

    Clients --> DC1
    Clients --> DC2
    DC1 --> DnsZone
    DC2 --> DnsZone
    DC1 --> Forwarders
    DC2 --> Forwarders
    Public -. separate public zone .-> Forwarders
```

DNS principles:

- `corp.gntech.me` is the internal AD-integrated DNS zone.
- `gntech.me` is the public Microsoft 365 tenant and public domain.
- Split-brain DNS is avoided unless an ADR approves it.
- Clients use domain controllers for internal DNS.
- Firewall rules must prevent uncontrolled client DNS egress.

## DHCP architecture

```mermaid
flowchart LR
    Scope30[WORKSTATIONS-HQ VLAN 30]
    Scope40[PRINTERS-HQ VLAN 40]
    Scope60[CORPWIFI-HQ VLAN 60]
    Scope70[GUESTWIFI-HQ VLAN 70]
    DHCP1[HQ-DC01 DHCP]
    DHCP2[HQ-DC02 DHCP Future]
    FW[HQ-FW01 Relay / Gateway]

    FW --> DHCP1
    FW --> DHCP2
    DHCP1 --> Scope30
    DHCP1 --> Scope40
    DHCP1 --> Scope60
    DHCP1 --> Scope70
    DHCP2 -. failover future .-> Scope30
```

DHCP principles:

- Infrastructure servers use static addresses.
- Workstations, corporate WiFi, guest WiFi, and printers use documented scopes.
- `HQ-DC02` is reserved for future DHCP failover.
- DHCP options must point domain devices to `HQ-DC01` and future `HQ-DC02` for DNS.

## PKI hierarchy

Target state is a two-tier PKI, even if Phase 1 bootstraps with constrained resources.

```mermaid
flowchart TD
    Root[Offline Root CA: GNTECH Root CA]
    Issuing[Enterprise Issuing CA: GNTECH-CORP-Issuing-CA01]
    Templates[Certificate Templates]
    DC[Domain Controller Certificates]
    NPS[NPS / 802.1X Certificates]
    Device[Device Certificates]
    Service[Service TLS Certificates]

    Root --> Issuing
    Issuing --> Templates
    Templates --> DC
    Templates --> NPS
    Templates --> Device
    Templates --> Service
```

PKI principles:

- Root CA is offline in target state.
- Issuing CA integrates with `corp.gntech.me`.
- Certificate templates are versioned and lifecycle-managed.
- CRL and AIA locations must be reachable by relying parties.
- PKI administrators are Tier 0.

## Identity architecture

```mermaid
flowchart TD
    AD[Active Directory: corp.gntech.me]
    Entra[Microsoft Entra ID: gntech.me]
    M365[Microsoft 365]
    Intune[Intune]
    Defender[Defender]
    WHFB[Windows Hello for Business]
    PAM[Privileged Access Model]

    AD --> Entra
    Entra --> M365
    Entra --> Intune
    Intune --> Defender
    Entra --> WHFB
    AD --> PAM
    Entra --> PAM
```

Identity design principles:

- AD DS is authoritative for initial on-premises identity.
- Entra ID is authoritative for cloud roles and SaaS access.
- Emergency cloud-only access is mandatory.
- Administrative accounts are tiered.
- Device identity becomes a policy signal for cloud and endpoint access.

## Domain and OU strategy

The OU design separates normal operations from administrative control.

| OU | Purpose |
|---|---|
| `OU=Admin,DC=corp,DC=gntech,DC=me` | Tiered administrative users, groups, workstations, and service accounts |
| `OU=Servers,DC=corp,DC=gntech,DC=me` | Member servers and infrastructure servers |
| `OU=Workstations,DC=corp,DC=gntech,DC=me` | Windows 11 Enterprise workstations |
| `OU=Groups,DC=corp,DC=gntech,DC=me` | Security and distribution groups |
| `OU=Service Accounts,DC=corp,DC=gntech,DC=me` | Traditional service accounts and gMSA organization |
| `OU=Disabled Objects,DC=corp,DC=gntech,DC=me` | Disabled users, computers, and retained objects |

## Cloud integration strategy

| Cloud Capability | Phase 1 HLD Decision | Future Target |
|---|---|---|
| Microsoft 365 | Tenant `gntech.me` | Full collaboration and messaging governance |
| Entra ID | Cloud identity plane | Conditional Access and privileged role governance |
| Intune | Endpoint control plane | Autopilot, compliance, app deployment, device lifecycle |
| Defender | Security signal and endpoint protection | Integrated detection and response |
| WHfB | Passwordless sign-in | Cloud Kerberos trust or approved equivalent |

## Cross-references

- [Enterprise Lab Blueprint HLD](enterprise-lab-blueprint.md)
- [Environment Specification](../project/environment-specification.md)
- [Identity Architecture](identity-architecture.md)
- [Active Directory Implementation](../microsoft-core/active-directory-implementation.md)
- [AD CS PKI](../microsoft-core/ad-cs-pki.md)
- [Privileged Access Model](../security/privileged-access-model.md)
