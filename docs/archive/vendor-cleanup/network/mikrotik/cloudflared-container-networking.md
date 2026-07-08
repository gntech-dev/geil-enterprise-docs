---
title: Cloudflared Container Networking
document_id: GEIL-NET-MTK-CLOUDFLARED-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-07-08
review_cycle: Quarterly
classification: Internal Confidential
---

# Cloudflared Container Networking

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-NET-MTK-CLOUDFLARED-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-07-08 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This document defines the Network authority for Cloudflared container network access inside the GEIL lab.

The current operational firewall rule source of truth remains [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md). This page explains Cloudflared-specific boundaries so tunnel access does not become an implicit bypass around VLAN firewall policy.

## Access principles

- Cloudflared must not receive Any/Any access to internal networks.
- Cloudflared access must be constrained to explicit destination hosts and ports.
- Cloudflared Browser Rendering / IronRDP use must target approved RDP destinations only.
- Cloudflared rules must be reviewed with the same discipline as direct VLAN firewall rules.
- WAN must never expose RDP or WinRM directly.
- Authentication examples for Windows RDP must follow the Microsoft Core authentication standard.

## RouterOS validation

Run on: `HQ-FW01`

When: validating Cloudflared access after container deployment, IP changes, or firewall changes.

Expected outcome: Cloudflared source membership and firewall rules are explicit and narrow.

```routeros
/ip firewall address-list print where list="CloudflaredContainers"
/ip firewall filter print stats where src-address-list="CloudflaredContainers"
/ip firewall filter print where comment~"Cloudflared"
```

STOP if Cloudflared has unrestricted access to internal RFC1918 networks, broad management ports, Domain Controllers, or server VLANs.

## Related documents

- [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md)
- [HQ-FW01 RouterOS Baseline](hq-fw01-routeros-baseline.md)
- [Authentication Standards](../../microsoft-core/authentication-standards.md)
