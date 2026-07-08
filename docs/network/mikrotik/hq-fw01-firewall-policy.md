---
title: HQ-FW01 Firewall Policy
document_id: GEIL-NET-MTK-HQFW01-POLICY-001
owner: Infrastructure Engineering
status: Pilot Validated
version: 1.1
last_reviewed: 2026-07-08
review_cycle: Per validated export
classification: Internal Confidential
---

# HQ-FW01 Firewall Policy

## Purpose

This document is the authoritative operational source of truth for validated `HQ-FW01` MikroTik RouterOS firewall policy in the current pilot.

It is synchronized to [HQ-FW01 RouterOS Export - Current Validated Snapshot](hq-fw01-routeros-export-current.md). Where previous documentation differs from the export, the export wins unless a Pilot Finding explicitly explains the difference.

## Current firewall rule order

| Order | Chain | Action | Comment |
|---:|---|---|---|
| 1 | `input` | `accept` | Accept established/related to router |
| 2 | `input` | `drop` | Drop invalid to router |
| 3 | `input` | `accept` | Allow management VLAN to router |
| 4 | `input` | `accept` | Allow HQ-MGMT01 to router |
| 5 | `forward` | `accept` | Accept established/related forwarding |
| 6 | `forward` | `drop` | Drop invalid forwarding |
| 7 | `forward` | `drop` | Block guest to internal GEIL |
| 8 | `forward` | `accept` | Allow guest to internet only |
| 9 | `forward` | `accept` | Allow HQ-MGMT01 to Proxmox |
| 10 | `forward` | `accept` | Allow HQ-MGMT01 to HQ-DC01 management prep |
| 11 | `forward` | `accept` | Allow approved internal VLANs to Internet |
| 12 | `forward` | `accept` | Allow containers outbound to Internet |
| 13 | `forward` | `accept` | Allow cloudflared to VLAN20 Servers |
| 14 | `forward` | `accept` | Allow cloudflared to VLAN80 DMZ |
| 15 | `forward` | `drop` | Block VLAN30 Workstations to HQ-DC01 admin ports |
| 16 | `forward` | `accept` | TEMP ALLOW VLAN30 clients to HQ-DC01 |
| 17 | `forward` | `accept` | Allow cloudflared to VLAN10 Management |
| 18 | `forward` | `accept` | TEMP allow HQ-DC01 to RDP HQ-MGMT01 |
| 19 | `forward` | `accept` | Allow Management VLAN to WinRM Workstations |
| 20 | `forward` | `accept` | Allow Management VLAN to HQ-WEC01 admin ports |
| 21 | `forward` | `accept` | Allow Workstations VLAN to WEF collector HQ-WEC01 |
| 22 | `forward` | `accept` | Allow Management VLAN to WEF collector HQ-WEC01 |
| 23 | `forward` | `drop` | Default deny unapproved forwarding |
| 24 | `input` | `accept` | Allow cloudflared container to SSH CHR |
| 25 | `input` | `accept` | ALLOW DHCP client requests VLAN30 to CHR relay |
| 26 | `input` | `accept` | ALLOW DHCP server replies to CHR relay |
| 27 | `input` | `accept` | ALLOW DHCP client requests VLAN10 to CHR relay |
| 28 | `input` | `accept` | ALLOW DHCP server replies to CHR relay VLAN10 |
| 29 | `input` | `drop` | Default deny unapproved traffic to router |

## Current NAT rule order

| Order | Chain | Action | Comment |
|---:|---|---|---|
| 1 | `srcnat` | `masquerade` | GEIL outbound masquerade to GEILWAN |
| 2 | `srcnat` | `masquerade` | NAT for RouterOS containers |

## Current validated intent by rule group

| Rule group | Current export behavior |
|---|---|
| Router input baseline | Accept established/related, drop invalid, allow Management VLAN and `HQ-MGMT01`, then later allow specific DHCP relay and Cloudflared SSH input before default input deny. |
| Guest isolation | Drop VLAN70 Guest WiFi `172.20.70.0/24` to internal `172.20.0.0/16`; allow Guest only to WAN. |
| Internet access | Allow approved internal VLANs in interface list `LAN` to WAN; allow containers `172.17.0.0/24` to WAN. |
| Proxmox management | Allow `HQ-MGMT01` `172.20.10.10` to `172.20.100.11` TCP `8006`. |
| Domain Controller management prep | Allow `HQ-MGMT01` to `HQ-DC01` `172.20.20.11`. This is broad in the current export and retained as a validated pilot rule. |
| Cloudflared forwarding | Allow Cloudflared `172.17.0.2` to VLAN20 Servers, VLAN80 DMZ, and VLAN10 Management. |
| VLAN30 to Domain Controller admin ports | Drop VLAN30 Workstations to `HQ-DC01` TCP `3389,5985` before broad VLAN30 allow. |
| Pilot temporary VLAN30 to Domain Controller | Current export includes `TEMP ALLOW VLAN30 clients to HQ-DC01` after the admin-port drop. This preserves AD DS reachability while denying RDP/WinRM. |
| Temporary reverse RDP | Current export includes `TEMP allow HQ-DC01 to RDP HQ-MGMT01` from `172.20.20.11` to `172.20.10.10` TCP `3389`. |
| Management to Workstations WinRM | Allow Management VLAN `172.20.10.0/24` to Workstations `172.20.30.0/24` TCP `5985`. |
| Management to WEC | Allow Management VLAN to `HQ-WEC01` `172.20.20.21` TCP `3389,5985`; an additional WEF-specific TCP `5985` rule also exists. |
| Workstations to WEC | Allow Workstations VLAN `172.20.30.0/24` to `HQ-WEC01` TCP `5985` for WEF. |
| Default deny | Final forward rule drops unapproved forwarding; final input rule drops unapproved traffic to router. |

## Pilot temporary rules

The current export contains pilot temporary rules and they are documented as current because the export is authoritative:

- `TEMP ALLOW VLAN30 clients to HQ-DC01`
- `TEMP allow HQ-DC01 to RDP HQ-MGMT01`

Pilot finding: the VLAN30 temporary allow is safe only because the prior rule drops VLAN30 to `HQ-DC01` TCP `3389,5985` first. Do not move the temporary allow above the admin-port drop.

## Validation commands

Run on: `HQ-FW01`

When: validating firewall order against the current export.

Expected outcome: rule order and comments match this document.

```routeros
/ip firewall filter print stats
/ip firewall nat print
/ip firewall filter print where comment~"TEMP|Default deny|HQ-WEC01|cloudflared|VLAN30"
```
