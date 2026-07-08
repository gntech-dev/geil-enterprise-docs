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
- [MikroTik CHR HQ Foundation Implementation](../../platform/mikrotik-chr-hq-foundation-implementation.md)
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
