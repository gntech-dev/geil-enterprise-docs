---
title: HQ-FW01 Firewall Policy
document_id: GEIL-NET-MTK-HQFW01-POLICY-001
owner: Infrastructure Engineering
status: Pilot Validated
version: 1.0
last_reviewed: 2026-07-08
review_cycle: Quarterly
classification: Internal Confidential
---

# HQ-FW01 Firewall Policy

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-NET-MTK-HQFW01-POLICY-001 |
| Owner | Infrastructure Engineering |
| Status | Pilot Validated |
| Version | 1.0 |
| Last Reviewed | 2026-07-08 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This document is the authoritative operational source of truth for validated `HQ-FW01` MikroTik RouterOS firewall policy in the GEIL Enterprise laboratory.

Use this document when validating or changing current `HQ-FW01` firewall behavior. Other implementation documents may explain why a control exists, but current RouterOS rule intent, ordering, and validation live here.

Related documents:

- [Network and Active Directory Services Matrix](../network-and-ad-services-matrix.md)
- [MikroTik Windows Management Firewall Policy](windows-management-firewall-policy.md)
- [MikroTik CHR HQ Foundation Implementation](../../legacy/platform/mikrotik-chr-hq-foundation-implementation.md)
- [Firewall Rule Matrix](../firewall-rule-matrix.md)
- [Enterprise Windows Firewall Baseline](../../microsoft-core/windows-security/windows-firewall-baseline.md)
- [Windows Event Forwarding and Collector Baseline](../../microsoft-core/windows-monitoring/windows-event-forwarding-baseline.md)

## Current validated firewall intent

`HQ-FW01` enforces inter-VLAN authorization for the GNTECH lab. Windows host firewalls still control host-level exposure, but MikroTik controls whether traffic is allowed to cross VLAN boundaries.

Validated intent:

- Allow established and related forwarding before evaluating new traffic.
- Drop invalid forwarding early.
- Isolate Guest VLAN from internal `172.20.0.0/16` networks.
- Allow approved internal VLANs to reach the internet through WAN/NAT.
- Allow VLAN10 Management to administer approved infrastructure.
- Allow VLAN30 Workstations to consume required AD DS services from `HQ-DC01`.
- Deny VLAN30 Workstations from administering `HQ-DC01` over RDP or WinRM.
- Allow VLAN30 Workstations and VLAN10 Management to reach `HQ-WEC01` on TCP `5985` for source-initiated Windows Event Forwarding.
- Restrict Cloudflared container access to explicit approved internal destinations and ports.
- End with explicit default deny for unapproved forwarding.

## Validated hosts and networks

| Object | Value | Purpose |
|---|---|---|
| `HQ-FW01` | MikroTik CHR / RouterOS | Inter-VLAN firewall and routing. |
| VLAN10 Management | `172.20.10.0/24` | Management systems such as `HQ-MGMT01`. |
| VLAN20 Servers | `172.20.20.0/24` | Server systems such as `HQ-DC01` and `HQ-WEC01`. |
| VLAN30 Workstations | `172.20.30.0/24` | Standard workstation clients such as `HQ-W11-001`. |
| VLAN70 Guest | `172.20.70.0/24` | Internet-only guest clients. |
| `HQ-DC01` | `172.20.20.11` | Domain Controller, DNS, Kerberos, LDAP, SYSVOL/GPO. |
| `HQ-WEC01` | `172.20.20.21` | Windows Event Collector. |

## Address-list model

Run on: `HQ-FW01`

When: before applying or validating firewall rules.

Expected outcome: address lists exist before filter rules reference them.

```routeros
/ip firewall address-list
add list=ManagementNetworks address=172.20.10.0/24 comment="VLAN10 Management"
add list=AD-DomainControllers address=172.20.20.11 comment="HQ-DC01 domain controller"
add list=WEC-Collectors address=172.20.20.21 comment="HQ-WEC01 Windows Event Collector"
add list=AD-ClientNetworks address=172.20.30.0/24 comment="VLAN30 Workstations domain clients"
add list=GuestNetworks address=172.20.70.0/24 comment="VLAN70 Guest"
add list=InternalNetworks address=172.20.0.0/16 comment="GEIL internal networks"
add list=CloudflaredContainers address=0.0.0.0 disabled=yes comment="PLACEHOLDER - replace with validated Cloudflared container IP"
```

Do not create rules that reference an address list before the list exists.

## Required forward-chain rule order

The validated policy depends on rule order. Specific drops must appear before broad allows, and all approved allows must appear before the default deny.

Required order:

1. Accept established and related forwarding.
2. Drop invalid forwarding.
3. Drop Guest VLAN to internal networks.
4. Allow Guest VLAN to WAN only.
5. Allow approved LAN to WAN.
6. Allow VLAN10 Management to approved infrastructure management targets.
7. Allow VLAN10 Management to `HQ-DC01` admin ports.
8. Allow VLAN10 Management to `HQ-WEC01` TCP `3389` and TCP `5985`.
9. Drop VLAN30 Workstations to `HQ-DC01` TCP `3389` and TCP `5985`.
10. Allow VLAN30 Workstations to `HQ-DC01` required AD DS ports.
11. Allow VLAN30 Workstations to `HQ-WEC01` TCP `5985` for WEF.
12. Allow Cloudflared container to only explicit approved internal destinations and ports.
13. Drop unapproved forwarding.

Do not place a broad VLAN30-to-`HQ-DC01` allow rule before the VLAN30-to-`HQ-DC01` admin-port drop rule.

## Validated rule intent matrix

| Source | Destination | Ports | Action | Purpose |
|---|---|---|---|---|
| VLAN10 Management | `HQ-DC01` | TCP `3389`, `5985`, `5986`, `445`, `135`; required AD DS ports | Allow | Approved Domain Controller administration from management systems. |
| VLAN10 Management | `HQ-WEC01` | TCP `3389`, `5985` | Allow | Approved collector administration and WEF validation from management systems. |
| VLAN30 Workstations | `HQ-DC01` | TCP/UDP `53`, `88`, `389`; TCP `445`; UDP `123`; required AD DS support ports | Allow | Domain client DNS, Kerberos, LDAP, SYSVOL, Group Policy, and time. |
| VLAN30 Workstations | `HQ-DC01` | TCP `3389`, `5985` | Deny | Workstations must not administer Domain Controllers. |
| VLAN30 Workstations | `HQ-WEC01` | TCP `5985` | Allow | Source-initiated Windows Event Forwarding to collector. |
| Cloudflared container | Approved internal targets | Explicit approved ports only | Allow | Private access path for approved Cloudflare Browser Rendering / Tunnel use cases. |
| VLAN70 Guest | Internal `172.20.0.0/16` | Any | Deny | Guest isolation. |
| VLAN70 Guest | WAN | DNS/HTTP/HTTPS as approved | Allow | Internet-only guest access. |
| Any unapproved source | Any internal destination | Any | Deny | Default deny. |

## RouterOS policy template

This template documents the validated rule behavior. Review current `HQ-FW01` rule comments and counters before applying changes.

Run on: `HQ-FW01`

When: after address lists and interface lists exist, and before the default deny rule is enforced.

Expected outcome: approved traffic matches explicit allow rules and unapproved traffic reaches default deny.

```routeros
/ip firewall filter
add chain=forward connection-state=established,related action=accept comment="Accept established/related forwarding"
add chain=forward connection-state=invalid action=drop comment="Drop invalid forwarding"
add chain=forward src-address-list=GuestNetworks dst-address-list=InternalNetworks action=drop comment="Block guest to internal GEIL"
add chain=forward src-address-list=GuestNetworks out-interface-list=WAN action=accept comment="Allow guest to internet only"
add chain=forward in-interface-list=LAN out-interface-list=WAN action=accept comment="Allow GEIL LAN to internet"
add chain=forward src-address-list=ManagementNetworks dst-address-list=AD-DomainControllers protocol=tcp dst-port=3389,5985,5986,445,135 action=accept comment="Allow MGMT to HQ-DC01 admin TCP"
add chain=forward src-address-list=ManagementNetworks dst-address-list=AD-DomainControllers protocol=tcp dst-port=53,88,389,636,3268,3269 action=accept comment="Allow MGMT to HQ-DC01 AD TCP"
add chain=forward src-address-list=ManagementNetworks dst-address-list=AD-DomainControllers protocol=udp dst-port=53,88,123,389 action=accept comment="Allow MGMT to HQ-DC01 AD UDP"
add chain=forward src-address-list=ManagementNetworks dst-address-list=WEC-Collectors protocol=tcp dst-port=3389,5985 action=accept comment="Allow MGMT to HQ-WEC01 admin and WEF"
add chain=forward src-address-list=AD-ClientNetworks dst-address-list=AD-DomainControllers protocol=tcp dst-port=3389,5985 action=drop comment="Drop VLAN30 to HQ-DC01 admin ports"
add chain=forward src-address-list=AD-ClientNetworks dst-address-list=AD-DomainControllers protocol=tcp dst-port=53,88,389,445,135,49152-65535,3268,3269 action=accept comment="Allow VLAN30 to HQ-DC01 AD TCP"
add chain=forward src-address-list=AD-ClientNetworks dst-address-list=AD-DomainControllers protocol=udp dst-port=53,88,389,123 action=accept comment="Allow VLAN30 to HQ-DC01 AD UDP"
add chain=forward src-address-list=AD-ClientNetworks dst-address-list=AD-DomainControllers protocol=tcp dst-port=636 action=accept disabled=yes comment="Optional VLAN30 to HQ-DC01 LDAPS if enabled"
add chain=forward src-address-list=AD-ClientNetworks dst-address-list=WEC-Collectors protocol=tcp dst-port=5985 action=accept comment="Allow VLAN30 to HQ-WEC01 WEF"
add chain=forward src-address-list=CloudflaredContainers dst-address=172.20.10.10 protocol=tcp dst-port=3389 action=accept comment="Allow Cloudflared to approved RDP target"
add chain=forward action=drop comment="Default deny unapproved forwarding"
```

The `CloudflaredContainers` address-list member must be replaced with the actual validated container IP before use. Do not use this as a broad tunnel-to-internal allow rule.

## Cloudflared container access rules

Cloudflared access is allowed only when the destination and port are explicitly approved.

Validated intent:

- Cloudflared must not bypass VLAN firewall policy.
- Cloudflared must not receive Any/Any access to internal networks.
- Cloudflared access must terminate into controlled internal access paths.
- Cloudflared Browser Rendering / IronRDP use must target approved RDP destinations only.
- RDP authentication examples must use the validated NetBIOS format documented in Microsoft Core authentication guidance.

Run on: `HQ-FW01`

When: validating Cloudflared container access rules.

Expected outcome: Cloudflared rules are explicit, narrow, and above default deny.

```routeros
/ip firewall address-list print where list="CloudflaredContainers"
/ip firewall filter print stats where src-address-list="CloudflaredContainers"
/ip firewall filter print where comment~"Cloudflared"
```

STOP if Cloudflared has broad access to internal RFC1918 networks or unrestricted management ports.

## Validation commands

### Validate rule order

Run on: `HQ-FW01`

When: after firewall policy changes and before continuing endpoint validation.

Expected outcome: specific permits and denies appear before `Default deny unapproved forwarding`.

```routeros
/ip firewall filter print stats
/ip firewall address-list print
```

### Validate VLAN10 Management to HQ-DC01

Run on: `HQ-MGMT01`

When: after HQ-FW01 policy is in place and `HQ-DC01` is online.

Expected outcome: approved management and AD DS ports succeed.

```powershell
Test-NetConnection HQ-DC01 -Port 53
Test-NetConnection HQ-DC01 -Port 88
Test-NetConnection HQ-DC01 -Port 389
Test-NetConnection HQ-DC01 -Port 445
Test-NetConnection HQ-DC01 -Port 3389
Test-NetConnection HQ-DC01 -Port 5985
```

### Validate VLAN10 Management to HQ-WEC01

Run on: `HQ-MGMT01`

When: after `HQ-WEC01` is online and WEF has been configured.

Expected outcome: TCP `3389` and TCP `5985` succeed from the Management VLAN.

```powershell
Test-NetConnection HQ-WEC01 -Port 3389
Test-NetConnection HQ-WEC01 -Port 5985
```

### Validate VLAN30 Workstations to HQ-DC01

Run on: `HQ-W11-001`

When: after VLAN30 workstation policy is applied.

Expected outcome: AD DS ports succeed; Domain Controller admin ports fail.

```powershell
Test-NetConnection HQ-DC01 -Port 53
Test-NetConnection HQ-DC01 -Port 88
Test-NetConnection HQ-DC01 -Port 389
Test-NetConnection HQ-DC01 -Port 445
Test-NetConnection HQ-DC01 -Port 3389
Test-NetConnection HQ-DC01 -Port 5985
```

Expected results:

- TCP `53`: success.
- TCP `88`: success.
- TCP `389`: success.
- TCP `445`: success.
- TCP `3389`: failed.
- TCP `5985`: failed.

### Validate VLAN30 Workstations to HQ-WEC01

Run on: `HQ-W11-001`

When: after WEF GPO applies.

Expected outcome: TCP `5985` succeeds to `HQ-WEC01`.

```powershell
Test-NetConnection HQ-WEC01 -Port 5985
```

### Validate Guest isolation

Run on: `Guest VLAN test client`

When: after Guest VLAN policy is in place.

Expected outcome: internal access fails and internet-only access works where approved.

```powershell
Test-NetConnection 172.20.20.11 -Port 53
Test-NetConnection 172.20.20.21 -Port 5985
Test-NetConnection 1.1.1.1 -Port 443
```

Expected results:

- Internal tests fail.
- Internet test succeeds only if guest WAN access is intentionally enabled.

## Pilot findings

- `HQ-FW01` is the authoritative enforcement point for inter-VLAN access.
- Windows Defender Firewall controls host-level exposure; MikroTik controls inter-VLAN authorization.
- VLAN30 Workstations require AD DS ports to `HQ-DC01`, but must not reach `HQ-DC01` on TCP `3389` or TCP `5985`.
- If `HQ-W11-001` can reach `HQ-DC01` on TCP `3389` or TCP `5985`, check MikroTik rule order first.
- Windows Event Forwarding uses source-initiated subscriptions. Clients connect to `HQ-WEC01` on TCP `5985`; `HQ-WEC01` does not pull events from clients.
- WEF pilot validation found that Windows Firewall was not the issue. Missing connectivity was caused by MikroTik inter-VLAN forwarding rules.
- Guest isolation must be explicit and must remain above broad allows.
- Cloudflared access must be explicit and must not bypass validated internal firewall policy.
- Default deny must remain the final rule for unapproved forwarding.

## Acceptance criteria

- [x] VLAN10 Management can administer `HQ-DC01` on approved management ports.
- [x] VLAN10 Management can reach `HQ-WEC01` on TCP `3389` and TCP `5985`.
- [x] VLAN30 Workstations can reach `HQ-DC01` on AD DS service ports.
- [x] VLAN30 Workstations cannot reach `HQ-DC01` on TCP `3389` or TCP `5985`.
- [x] VLAN30 Workstations can reach `HQ-WEC01` on TCP `5985` for WEF.
- [x] Guest VLAN is isolated from internal networks.
- [x] Cloudflared access is constrained to explicit approved destinations and ports.
- [x] Default deny remains in place for unapproved forwarding.
