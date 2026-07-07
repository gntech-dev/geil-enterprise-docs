---
title: Network and Active Directory Services Matrix
document_id: GEIL-PRJ-NETAD-MATRIX-001
owner: Infrastructure Engineering
status: Approved
version: 1.1
last_reviewed: 2026-07-02
review_cycle: Quarterly
classification: Internal Confidential
---

# Network and Active Directory Services Matrix

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-PRJ-NETAD-MATRIX-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.1 |
| Last Reviewed | 2026-07-02 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This document defines the canonical reference for the GNTECH Windows Infrastructure Lab network, Active Directory service access, and Windows management access model.

Use this matrix as the source of truth for:

- VLANs.
- Subnets.
- Gateways.
- Server names.
- Management access paths.
- Active Directory service ports.
- Windows management ports.
- Firewall expectations between VLANs.

Other documents, including WinRM, RDP, Windows Firewall, MikroTik firewall policy, Windows LAPS, Microsoft Defender, and Windows Event Forwarding baselines, should reference this matrix instead of redefining port and VLAN assumptions separately.

GEIL is the documentation library and repository namespace. GNTECH is the canonical organization, lab, and environment identity. Implementation documents must use GNTECH environment values unless they are explicitly describing GEIL document IDs, the GEIL repository, or the GEIL documentation library.

## Naming standard

The repository uses a site-role-sequence naming pattern for implementation systems. Generic names such as `DC01` may appear in examples only when the text clearly identifies them as placeholders. Implementation documents should prefer canonical names such as `HQ-DC01`.

| Object Type | Canonical Example | Purpose |
|---|---|---|
| Domain Controller | `HQ-DC01` | Primary AD DS, DNS, Kerberos, and Group Policy server |
| Management Workstation | `HQ-MGMT01` | Privileged administration workstation |
| Windows Client | `HQ-W11-001` | Standard domain-joined Windows 11 workstation |
| Firewall | `HQ-FW01` | MikroTik routing/firewall device |
| File Server | `HQ-FS01` | Future member server file services role |
| Hypervisor | `PVE-HQ01` | Primary Proxmox VE host |
| Backup Server | `PBS-HQ01` | Proxmox Backup Server |

## VLAN and subnet matrix

The values below are confirmed in the current repository where specific GNTECH lab values exist. Rows marked `Placeholder` are not currently canonical GNTECH VLANs and must be confirmed before firewall rules are applied.

| VLAN / Zone | VLAN ID | Subnet/CIDR | Gateway | Purpose | Example Systems | Management Direction | Notes |
|---|---:|---|---|---|---|---|---|
| Management VLAN | 10 | `172.20.10.0/24` | `172.20.10.1` | Management workstations and infrastructure management interfaces | `HQ-MGMT01`, `HQ-FW01` gateway interface | Initiates administration to servers, clients, hypervisors, firewall, and approved infrastructure | Only approved management systems should initiate Windows administrative sessions. |
| Servers VLAN | 20 | `172.20.20.0/24` | `172.20.20.1` | Domain controllers and Windows infrastructure services | `HQ-DC01` (`172.20.20.11`), future `HQ-DC02`, future `HQ-FS01` | Receives management from Management VLAN; provides AD DS services to domain clients | Do not use as a daily administration workstation network. |
| Workstations VLAN | 30 | `172.20.30.0/24` | `172.20.30.1` | Windows 11 Enterprise clients | `HQ-W11-001` | Consumes AD DS services; does not administer infrastructure | No RDP/WinRM initiation to infrastructure. |
| Printers VLAN | 40 | `172.20.40.0/24` | `172.20.40.1` | Printers and MFPs | Future printers | No Windows administration | AD/DNS access only if a future print design requires it. |
| Voice VLAN | 50 | `172.20.50.0/24` | `172.20.50.1` | Voice devices | Future phones | No Windows administration | Placeholder for future voice design. |
| Corporate WiFi VLAN | 60 | `172.20.60.0/24` | `172.20.60.1` | 802.1X corporate wireless clients | Future domain or Entra-managed clients | Consumes only required AD DS services if domain joined | No RDP/WinRM to infrastructure. |
| Guest VLAN | 70 | `172.20.70.0/24` | `172.20.70.1` | Internet-only guest access | Guest devices | None | Must not reach internal infrastructure. |
| DMZ VLAN | 80 | `172.20.80.0/24` | `172.20.80.1` | Public-facing or isolated services | Future DMZ hosts | Managed only from Management VLAN if needed | Do not allow DMZ systems to administer internal systems. |
| Backup VLAN | 90 | `172.20.90.0/24` | `172.20.90.1` | Backup transport and storage services | `PBS-HQ01` | Managed from Management VLAN; backup flows as documented | Keep backup access explicit. |
| Hypervisors VLAN | 100 | `172.20.100.0/24` | `172.20.100.1` | Proxmox VE host management and cluster traffic | `PVE-HQ01` | Managed from Management VLAN | Do not expose hypervisor management to user VLANs. |
| HOME/User VLAN | Placeholder | Placeholder | Placeholder | Non-lab home/user client networks if present | Placeholder | No infrastructure administration | Not currently a canonical GNTECH VLAN; define before use. |
| IoT VLAN | Placeholder | Placeholder | Placeholder | IoT devices | Placeholder | No Windows administration | Block Windows management ports. |
| CCTV VLAN | Placeholder | Placeholder | Placeholder | Cameras/NVR | Placeholder | No Windows administration | Block Windows management ports. |
| WAN/Internet boundary | External | ISP-provided | ISP-provided | External boundary | Internet | No direct internal administration | Never expose RDP/WinRM directly from WAN. |

## Active Directory service port matrix

These are not all administrative ports. Some are required for domain join, authentication, DNS, Group Policy, password changes, time synchronization, and directory lookup. Firewall rules must separate domain service access from administrative access.

| Service | Protocol | Port | Purpose | Notes |
|---|---|---:|---|---|
| DNS | TCP/UDP | 53 | Name resolution | Required by domain clients |
| Kerberos | TCP/UDP | 88 | Authentication | Required for domain authentication |
| NTP | UDP | 123 | Time synchronization | Required for Kerberos reliability |
| RPC Endpoint Mapper | TCP | 135 | RPC service discovery | Scope carefully |
| LDAP | TCP/UDP | 389 | Directory queries | Required by domain clients |
| SMB | TCP | 445 | SYSVOL, NETLOGON, Group Policy, admin shares | Do not treat all SMB use as admin access |
| Kerberos password change | TCP/UDP | 464 | Password changes | Required for domain password operations |
| LDAPS | TCP | 636 | LDAP over TLS | Future or certificate-backed scenarios |
| Global Catalog | TCP | 3268 | Forest-wide directory queries | Needed in larger AD environments |
| Global Catalog SSL | TCP | 3269 | Global Catalog over TLS | Future or certificate-backed scenarios |
| Dynamic RPC | TCP | 49152-65535 | AD/RPC operations | Do not broadly open unless required |

Dynamic RPC should be allowed only where required and scoped as narrowly as practical. Do not broadly open TCP `49152-65535` between all VLANs.

## Windows management port matrix

| Management Function | Protocol | Port | Approved Source | Notes |
|---|---|---:|---|---|
| RDP | TCP | 3389 | Management VLAN only | Interactive administration |
| WinRM HTTP | TCP | 5985 | Management VLAN only | Kerberos-protected internal PowerShell Remoting |
| WinRM HTTPS | TCP | 5986 | Management VLAN only | Future certificate-based transport |
| SMB/Admin shares | TCP | 445 | Management VLAN where required | Also used by AD/GPO, so document carefully |
| RPC Endpoint Mapper | TCP | 135 | Management VLAN where required | Scope tightly |
| Dynamic RPC | TCP | 49152-65535 | Management VLAN where required | Avoid broad inter-VLAN exposure |

RDP and WinRM should originate only from the Management VLAN. HOME/User, Workstations, IoT, CCTV, Guest, and WAN should not initiate Windows administrative sessions. Group Policy can enable services, but exposure is controlled by Windows Defender Firewall and MikroTik firewall policy.

## Inter-VLAN access matrix

| Source VLAN | Destination | Allowed | Purpose | Notes |
|---|---|---|---|---|
| Management VLAN | Domain Controllers | Yes | RDP, WinRM, AD administration | Restricted to admin systems such as `HQ-MGMT01`. |
| Management VLAN | Member Servers | Yes | RDP, WinRM, SMB admin | Restricted to admin systems. |
| Management VLAN | Workstations | Limited | WinRM/RDP only where justified for management | Current pilot validates `HQ-MGMT01` to `HQ-W11-001` WinRM. |
| Workstations VLAN | Domain Controllers | Limited | DNS, Kerberos, LDAP, GPO | No RDP/WinRM. |
| HOME/User VLAN | Domain Controllers | Limited | Only if domain-joined systems exist there | Placeholder; no RDP/WinRM. |
| IoT VLAN | Domain Controllers | No or highly restricted | Avoid AD dependency | Block admin ports. |
| CCTV VLAN | Domain Controllers | No or highly restricted | Cameras/NVR should not administer AD | Block admin ports. |
| Guest VLAN | Internal infrastructure | No | Internet-only access | Block internal management. |
| WAN | Internal infrastructure | No direct access | VPN/tunnel/access controls only | Never expose RDP/WinRM. |


## Validated VLAN30 to HQ-DC01 access

Pilot validation from `HQ-W11-001` in VLAN 30 confirmed this final access state to `HQ-DC01`:

| Source | Destination | Service | Port | Expected result | Purpose |
|---|---|---|---:|---|---|
| VLAN 30 Workstations | `HQ-DC01` | DNS | TCP `53` | Allowed | Domain name resolution. |
| VLAN 30 Workstations | `HQ-DC01` | Kerberos | TCP `88` | Allowed | Domain authentication. |
| VLAN 30 Workstations | `HQ-DC01` | LDAP | TCP `389` | Allowed | Directory lookup and domain operations. |
| VLAN 30 Workstations | `HQ-DC01` | SMB/SYSVOL | TCP `445` | Allowed | SYSVOL, NETLOGON, and Group Policy access. |
| VLAN 30 Workstations | `HQ-DC01` | RDP | TCP `3389` | Denied | Workstations must not interactively administer Domain Controllers. |
| VLAN 30 Workstations | `HQ-DC01` | WinRM HTTP | TCP `5985` | Denied | Workstations must not remotely administer Domain Controllers. |

This distinction is intentional: VLAN 30 requires domain service access, not Domain Controller administration access.

## Firewall interpretation rules

- AD service access is not the same as administrative access.
- A workstation may need DNS, Kerberos, LDAP, and SMB to function as a domain member.
- Domain-member service access does not mean the workstation should be allowed to RDP or WinRM into Domain Controllers.
- Management ports must be limited to the Management VLAN.
- MikroTik controls inter-VLAN routing exposure.
- Windows Defender Firewall controls host-level exposure.
- Both layers are required.
- WinRM `IPv4Filter` is not a source ACL; source restriction belongs in Windows Defender Firewall, MikroTik firewall policy, VLAN segmentation, and Kerberos authorization.

## Validation commands

### From Management Workstation

Run on: `HQ-MGMT01`

When: validating management and AD service access from the Management VLAN.

Expected outcome: DNS, Kerberos, LDAP, SMB, RDP, and WinRM validation succeeds where the host and firewall baselines allow them.

```powershell
Resolve-DnsName HQ-DC01
Test-NetConnection HQ-DC01 -Port 53
Test-NetConnection HQ-DC01 -Port 88
Test-NetConnection HQ-DC01 -Port 389
Test-NetConnection HQ-DC01 -Port 445
Test-NetConnection HQ-DC01 -Port 3389
Test-NetConnection HQ-DC01 -Port 5985
Test-WSMan HQ-DC01
Invoke-Command -ComputerName HQ-DC01 -ScriptBlock { hostname }
Invoke-Command -ComputerName HQ-DC01 -ScriptBlock { whoami }
```

### From normal workstation VLAN

Run on: `Windows Client`

When: validating that domain services work but administrative ports are blocked from non-management sources.

Expected outcome: DNS, Kerberos, LDAP, and SMB may succeed where required for domain functionality; RDP and WinRM fail from non-management VLANs.

```powershell
Resolve-DnsName HQ-DC01
Test-NetConnection HQ-DC01 -Port 53
Test-NetConnection HQ-DC01 -Port 88
Test-NetConnection HQ-DC01 -Port 389
Test-NetConnection HQ-DC01 -Port 445
Test-NetConnection HQ-DC01 -Port 3389
Test-NetConnection HQ-DC01 -Port 5985
```

Expected result:

- DNS, Kerberos, LDAP, and SMB may succeed where required for domain functionality.
- RDP and WinRM should fail from non-management VLANs.
- RDP and WinRM should succeed only from the Management VLAN.

### From MikroTik

Run on: `HQ-FW01`

When: validating address lists, rule counters, and active connections during network testing.

Expected outcome: address lists match this matrix, firewall rule counters increment on the intended rules, and connections to server VLAN destinations are visible when tests run.

```routeros
/ip firewall address-list print
/ip firewall filter print stats
/ip firewall connection print where dst-address~"172.20.20."
```

## Baseline checklist

- [ ] VLANs documented.
- [ ] Subnets documented.
- [ ] Gateways documented.
- [ ] Domain Controller names documented.
- [ ] Management workstation name documented.
- [ ] AD DS service ports documented.
- [ ] Windows management ports documented.
- [ ] Management VLAN is the only approved source for RDP/WinRM.
- [ ] Non-management VLANs are blocked from RDP/WinRM.
- [ ] MikroTik firewall policy references this matrix.
- [ ] WinRM baseline references this matrix.
- [ ] Future Windows Firewall baseline will reference this matrix.

## Future improvements

As the lab matures, consider:

- Privileged Access Workstation tiering.
- Just Enough Administration.
- WinRM HTTPS with certificates.
- Dedicated admin jump host.
- Separate server admin and domain admin roles.
- More granular server role destination lists.
- Multi-site firewall object standards.
