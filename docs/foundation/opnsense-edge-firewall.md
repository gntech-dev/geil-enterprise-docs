---
title: OPNsense Edge Firewall
document_id: GEIL-FND-OPN-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# OPNsense Edge Firewall

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-FND-OPN-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Implement OPNsense as the segmented edge firewall, router, VPN endpoint, and DHCP relay where required.

## Baseline configuration

- WAN uses ISP-provided static or DHCP addressing.
- LAN uses VLAN interfaces, not flat untagged networks, except temporary bootstrap.
- Default deny between internal VLANs.
- DNS forwarding allowed only to approved resolvers or AD DNS servers.
- Admin UI restricted to management VLAN and VPN admin group.
- Configuration backups encrypted and stored outside the firewall.

## Implementation steps

1. Install OPNsense and patch to current stable release.
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
Test-NetConnection HQ-DC01.<AD_DOMAIN_FQDN> -Port 53
Test-NetConnection HQ-NPS01.<AD_DOMAIN_FQDN> -Port 1812
```

Expected result: only approved paths succeed.

## Rollback

Use System > Configuration > Backups to restore the previous known-good configuration. Keep console access available for firewall rule mistakes.
