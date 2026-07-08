---
title: HQ-FW01 RouterOS Baseline
document_id: GEIL-NET-MTK-HQFW01-BASELINE-001
owner: Infrastructure Engineering
status: Pilot Validated
version: 1.1
last_reviewed: 2026-07-08
review_cycle: Per validated export
classification: Internal Confidential
---

# HQ-FW01 RouterOS Baseline

## Purpose

This document is the Network authority for the validated `HQ-FW01` RouterOS baseline. It is synchronized to the current validated RouterOS export in [HQ-FW01 RouterOS Export - Current Validated Snapshot](hq-fw01-routeros-export-current.md).

The export wins over older documentation unless a Pilot Finding explicitly explains a temporary or transitional difference.

## Router identity and version

| Item | Current value |
|---|---|
| Router identity | `HQ-FW01` |
| RouterOS version | `7.21.4` |
| WAN interface | `ether1` |
| VLAN trunk interface | `ether2` |
| Container bridge | `containers` |
| Cloudflared veth | `veth-cloudflared` |
| Cloudflared container IP | `172.17.0.2/24` |
| Container gateway | `172.17.0.1` |

## Current VLANs

| VLAN ID | Interface | Parent |
|---:|---|---|
| 10 | `vlan10-mgmt` | `ether2` |
| 20 | `vlan20-servers` | `ether2` |
| 30 | `vlan30-workstations` | `ether2` |
| 40 | `vlan40-printers` | `ether2` |
| 50 | `vlan50-voice` | `ether2` |
| 60 | `vlan60-corpwifi` | `ether2` |
| 70 | `vlan70-guestwifi` | `ether2` |
| 80 | `vlan80-dmz` | `ether2` |
| 90 | `vlan90-backup` | `ether2` |
| 100 | `vlan100-hypervisor` | `ether2` |

## Current IP addressing

| Interface | Address | Network | Comment |
|---|---|---|---|
| `ether1` | `172.31.255.2/30` | `172.31.255.0` | GEILWAN CHR WAN |
| `vlan10-mgmt` | `172.20.10.1/24` | `172.20.10.0` | VLAN10 Management gateway |
| `vlan100-hypervisor` | `172.20.100.1/24` | `172.20.100.0` | VLAN100 Hypervisors gateway |
| `vlan90-backup` | `172.20.90.1/24` | `172.20.90.0` | VLAN90 Backup gateway |
| `vlan20-servers` | `172.20.20.1/24` | `172.20.20.0` | VLAN20 Servers gateway |
| `vlan30-workstations` | `172.20.30.1/24` | `172.20.30.0` | VLAN30 Workstations gateway |
| `vlan40-printers` | `172.20.40.1/24` | `172.20.40.0` | VLAN40 Printers gateway |
| `vlan50-voice` | `172.20.50.1/24` | `172.20.50.0` | VLAN50 Voice gateway |
| `vlan60-corpwifi` | `172.20.60.1/24` | `172.20.60.0` | VLAN60 Corporate WiFi gateway |
| `vlan70-guestwifi` | `172.20.70.1/24` | `172.20.70.0` | VLAN70 Guest WiFi gateway |
| `vlan80-dmz` | `172.20.80.1/24` | `172.20.80.0` | VLAN80 DMZ gateway |
| `containers` | `172.17.0.1/24` | `172.17.0.0` | Gateway for containers |

## Current interface lists

| Interface list | Member interface |
|---|---|
| `WAN` | `ether1` |
| `LAN` | `vlan100-hypervisor` |
| `MGMT` | `vlan10-mgmt` |
| `SERVERS` | `vlan20-servers` |
| `WORKSTATIONS` | `vlan30-workstations` |
| `GUEST` | `vlan70-guestwifi` |
| `LAN` | `vlan10-mgmt` |
| `LAN` | `vlan20-servers` |
| `LAN` | `vlan30-workstations` |
| `LAN` | `vlan40-printers` |
| `LAN` | `vlan50-voice` |
| `LAN` | `vlan60-corpwifi` |
| `LAN` | `vlan80-dmz` |
| `LAN` | `vlan90-backup` |
| `MGMT` | `vlan100-hypervisor` |

## DHCP relay configuration

| Relay | Interface | DHCP server | Local address | Export state |
|---|---|---|---|---|
| `relay-vlan40` | `vlan40-printers` | `172.20.20.11` | `not set` | Enabled |
| `relay-vlan60` | `vlan60-corpwifi` | `172.20.20.11` | `not set` | Enabled |
| `relay-vlan30` | `vlan30-workstations` | `172.20.20.11` | `172.20.30.1` | Enabled |
| `relay-vlan10` | `vlan10-mgmt` | `172.20.20.11` | `172.20.10.1` | Enabled |

Pilot finding: the current export shows DHCP relay entries for VLAN10, VLAN30, VLAN40, and VLAN60. VLAN10 and VLAN30 include explicit `local-address` values. VLAN40 and VLAN60 are present in the export without explicit `disabled=yes`, so they are documented as enabled in the current snapshot.

## DNS configuration

| Setting | Current value |
|---|---|
| `allow-remote-requests` | `yes` |
| Upstream servers | `1.1.1.1`, `1.0.0.1` |

## Container networking

| Component | Current value |
|---|---|
| Bridge | `containers` |
| VETH | `veth-cloudflared` |
| VETH address | `172.17.0.2/24` |
| VETH gateway | `172.17.0.1` |
| Container image | `cloudflare/cloudflared:latest` |
| Container name | `cloudflared` |
| Start on boot | `yes` |
| DNS | `1.1.1.1` |
| Environment list | `ENV_CLOUDFLARED` with tunnel token redacted in documentation |

## NAT

| Order | Chain | Action | Comment |
|---:|---|---|---|
| 1 | `srcnat` | `masquerade` | GEIL outbound masquerade to GEILWAN |
| 2 | `srcnat` | `masquerade` | NAT for RouterOS containers |

## Static routes

| Destination | Gateway | Comment |
|---|---|---|
| `0.0.0.0/0` | `172.31.255.1` | Default route via GEILWAN Proxmox peer |

## Router services restrictions

| Service | Export setting |
|---|---|
| `ftp` | `set ftp disabled=yes` |
| `ssh` | `set ssh address=172.20.10.0/24,172.17.0.2/32` |
| `telnet` | `set telnet disabled=yes` |
| `www` | `set www disabled=yes` |
| `winbox` | `set winbox address=172.20.10.0/24` |
| `api` | `set api disabled=yes` |
| `api-ssl` | `set api-ssl disabled=yes` |

## Router management hardening

| Setting | Current value |
|---|---|
| Neighbor discovery | `discover-interface-list=MGMT` |
| MAC server | `allowed-interface-list=MGMT` |
| MAC WinBox | `allowed-interface-list=MGMT` |

## Current validation status

- Router identity is set to `HQ-FW01`.
- VLAN interfaces for VLAN10 through VLAN100 exist on `ether2`.
- WAN uses `172.31.255.2/30` with default route to `172.31.255.1`.
- Container bridge and Cloudflared VETH exist.
- DNS remote requests are enabled with public upstream resolvers.
- DHCP relay is present for VLAN10, VLAN30, VLAN40, and VLAN60 in the current export.
- Firewall and NAT rule order are documented in [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md).

## Validation commands

Run on: `HQ-FW01`

When: validating that the running RouterOS baseline matches this document.

Expected outcome: output matches the current export snapshot.

```routeros
/system identity print
/interface vlan print
/interface list print
/interface list member print
/ip address print
/ip dhcp-relay print detail
/ip dns print
/container print detail
/ip firewall filter print stats
/ip firewall nat print
/ip route print
/ip service print
/tool mac-server print
/tool mac-server mac-winbox print
```
