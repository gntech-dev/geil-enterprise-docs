---
title: HQ-FW01 RouterOS Baseline
document_id: GEIL-NET-MTK-HQFW01-BASELINE-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-08
review_cycle: Quarterly
classification: Internal Confidential
---

# HQ-FW01 RouterOS Baseline

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-NET-MTK-HQFW01-BASELINE-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-07-08 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This document is the Network authority for the validated `HQ-FW01` RouterOS baseline. It captures the ongoing configuration intent after the platform deployment guide has been completed.

The detailed current firewall policy is maintained in [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md). The platform implementation guide remains deployment history and bootstrap context only.

## Baseline scope

This baseline covers:

- Router identity and management-plane hardening intent.
- Interface-list prerequisites.
- VLAN gateway ownership.
- NAT and forwarding prerequisites.
- DHCP relay boundary conditions.
- Evidence and validation commands.

It does not replace [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md) for operational firewall rule order.

## Baseline requirements

| Area | Validated requirement |
|---|---|
| Router identity | Device is identified as `HQ-FW01`. |
| WAN | WAN transit uses the validated GEILWAN path from the environment specification. |
| LAN VLANs | VLAN gateways are owned by `HQ-FW01` for the GEIL VLAN plan. |
| Interface lists | `WAN` and `LAN` interface lists exist before firewall rules reference them. |
| Internet access | Approved GEIL LAN networks have a LAN-to-WAN forward rule and NAT before default deny. |
| Guest isolation | Guest VLAN is denied to internal `172.20.0.0/16` networks before broad allows. |
| AD client access | Domain clients use least-privilege AD service paths defined in [Network and Active Directory Services Matrix](../network-and-ad-services-matrix.md). |
| Operational firewall | Current RouterOS firewall source of truth is [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md). |
| DHCP relay | Relay must remain disabled or absent until matching `HQ-DC01` DHCP scopes exist. VLAN70 Guest must never relay to AD DHCP. |

## Validation commands

Run on: `HQ-FW01`

When: validating RouterOS baseline health after deployment, firewall changes, or network changes.

Expected outcome: identity, interface lists, routes, NAT, and firewall rules are visible and match the Network authority documents.

```routeros
/system identity print
/interface list print
/interface list member print
/ip address print
/ip route print
/ip firewall nat print
/ip firewall filter print stats
/ip dhcp-relay print detail
```

## Stop conditions

STOP if:

- Firewall rules reference missing interface lists or address lists.
- Guest VLAN can reach internal `172.20.0.0/16` networks.
- LAN-to-WAN forwarding or NAT is missing for approved internal networks.
- DHCP relay is enabled before the matching Windows DHCP scope exists.
- VLAN70 Guest is configured to relay to AD DHCP.
- Operational firewall rules differ from [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md).
