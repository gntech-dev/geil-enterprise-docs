---
title: Cloudflared Container Networking
document_id: GEIL-NET-MTK-CLOUDFLARED-001
owner: Infrastructure Engineering
status: Pilot Validated
version: 1.1
last_reviewed: 2026-07-08
review_cycle: Per validated export
classification: Internal Confidential
---

# Cloudflared Container Networking

## Purpose

This document defines the Network authority for Cloudflared container network access inside the GEIL lab. It is synchronized to the current validated `HQ-FW01` RouterOS export.

Sensitive tunnel token values are never documented. The sanitized export uses `[REDACTED_TUNNEL_TOKEN]`.

## Current container configuration

| Item | Current export value |
|---|---|
| Container name | `cloudflared` |
| Image | `cloudflare/cloudflared:latest` |
| Command | `tunnel --no-autoupdate run` |
| Hostname | `cloudflared` |
| Interface | `veth-cloudflared` |
| VETH address | `172.17.0.2/24` |
| VETH gateway | `172.17.0.1` |
| Container bridge | `containers` |
| Container DNS | `1.1.1.1` |
| Environment list | `ENV_CLOUDFLARED` |
| Tunnel token | Redacted; not documented |
| Start on boot | `yes` |

## Current Cloudflared firewall access

| Direction | Current export rule |
|---|---|
| Container to WAN | `Allow containers outbound to Internet` for `172.17.0.0/24` out `WAN` |
| Cloudflared to VLAN20 Servers | `Allow cloudflared to VLAN20 Servers` from `172.17.0.2` to `172.20.20.0/24` |
| Cloudflared to VLAN80 DMZ | `Allow cloudflared to VLAN80 DMZ` from `172.17.0.2` to `172.20.80.0/24` |
| Cloudflared to VLAN10 Management | `Allow cloudflared to VLAN10 Management` from `172.17.0.2` to `172.20.10.0/24` |
| Cloudflared to router SSH | `Allow cloudflared container to SSH CHR` from `172.17.0.2` to router TCP `22` |

Pilot finding: earlier documentation described narrower destination-specific Cloudflared access. The current export allows Cloudflared to VLAN20, VLAN80, and VLAN10 subnets plus SSH to the CHR. The export is authoritative for the current pilot snapshot.

## Validation commands

Run on: `HQ-FW01`

When: validating Cloudflared container networking against the current export.

Expected outcome: container, VETH, NAT, and firewall rules match the current snapshot.

```routeros
/container print detail
/interface veth print detail
/interface bridge port print where bridge=containers
/ip firewall filter print stats where src-address=172.17.0.2
/ip firewall nat print where src-address=172.17.0.0/24
/ip service print where name=ssh
```
