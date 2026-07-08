---
title: Superseded OPNsense Edge Firewall
document_id: GEIL-FND-OPN-001
owner: Infrastructure Engineering
status: Superseded
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Superseded OPNsense Edge Firewall

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-FND-OPN-001 |
| Owner | Infrastructure Engineering |
| Status | Superseded |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

!!! note "Adaptation"

    This document uses canonical GNTECH values from the [Environment Specification](../../project/environment-specification.md). Organizations adapting this design should change the environment specification first, then update all affected DNS zones, certificates, PowerShell commands, Group Policies, VLANs, firewall rules, and service configurations.

## Purpose

This historical foundation document described OPNsense as the edge firewall. It is superseded by ADR-0002 and retained only as alternative-implementation context. The active Phase 1 firewall is MikroTik CHR / RouterOS documented in the Platform section.

## Baseline configuration

- WAN uses ISP-provided static or DHCP addressing.
- LAN uses VLAN interfaces, not flat untagged networks, except temporary bootstrap.
- Default deny between internal VLANs.
- DNS forwarding allowed only to approved resolvers or AD DNS servers.
- Admin UI restricted to management VLAN and VPN admin group.
- Configuration backups encrypted and stored outside the firewall.

## Implementation steps

1. Historical OPNsense implementation steps are superseded; use MikroTik CHR Platform implementation guides for active deployment.
2. Change default admin password and create named admin accounts.
3. Define VLAN interfaces for MGMT, SERVER, CLIENT, WIFI-CORP, WIFI-GUEST, and IOT.
4. Create aliases for domain controllers, NPS servers, management workstations, and Microsoft service endpoints where needed.
5. Create outbound NAT using automatic or hybrid mode.
6. Create inter-VLAN rules from least privilege requirements.
7. Export configuration.

## Validation

From each VLAN:

```powershell
Test-NetConnection 1.1.1.1 -Port 443
Test-NetConnection HQ-DC01.corp.gntech.me -Port 53
Test-NetConnection HQ-DC01.corp.gntech.me -Port 1812
```

Expected result: only approved paths succeed.

## Rollback

For active deployment rollback, use the MikroTik CHR implementation guide and RouterOS exports/snapshots. Historical OPNsense restore guidance is no longer active for GEIL Phase 1.

## Deployment Verified

| Field | Value |
|---|---|
| Validated on | Not yet field validated. Must pass this guide, the code-block audit, and clean-environment review before production execution. |
| Windows Server version | Not yet field validated |
| RouterOS version | Not applicable unless the guide explicitly configures RouterOS |
| Proxmox version | Not applicable unless the guide explicitly configures Proxmox |
| Deployment date | Not yet field validated |
| Deployment notes | Not yet field validated. Must pass this guide, the code-block audit, and clean-environment review before production execution. |
| Known caveats | Treat as documentation-ready but not field-proven until deployment evidence is captured. |
