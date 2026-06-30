---
title: Monitoring and Alerting
document_id: GEIL-OPS-MON-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Monitoring and Alerting

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-OPS-MON-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Define minimum monitoring coverage for GEIL infrastructure.

## Required monitors

- Domain controller availability, replication, disk, CPU, memory, and event logs.
- DNS and DHCP service health.
- Certificate and CRL expiry.
- MikroTik CHR WAN status, gateway latency, VPN status, and config changes.
- Proxmox host health, storage, backups, and VM status.
- Microsoft 365 sign-in risk, service health, and admin role changes.

## Validation commands

```powershell
repadmin /replsummary
dcdiag /test:dns
Get-EventLog -LogName System -EntryType Error -Newest 20
```

Expected result: no unexplained critical service errors.

## Alert handling

Every alert must have owner, severity, business impact, first response step, escalation path, and closure criteria.

## Rollback

If a monitor creates noise, tune threshold or scope; do not delete production monitoring without replacement coverage.
