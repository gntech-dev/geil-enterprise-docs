---
title: Scaling Model
document_id: GEIL-OPS-SCALE-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Scaling Model

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-OPS-SCALE-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Define how GEIL grows from SMB to multinational operations without redesigning every layer.

## Scale triggers

| Trigger | Required Action |
|---|---|
| 50 users | Add second DC, formalize monitoring, implement Intune baseline |
| 100 users | Separate PKI/NPS/WAC roles, document help desk tiering |
| 250 users | Add redundant firewall/WAN, formal backup restore schedule |
| 500 users | Regional AD Sites and Services design, SIEM integration |
| 1,000+ users | Dedicated identity, endpoint, network, and security engineering ownership |

## Multisite design

- Create AD site for each network-connected office.
- Map subnets accurately.
- Place DCs only where latency, autonomy, or survivability requires them.
- Use DFS/modern cloud storage design by workload, not by habit.

## Validation PowerShell

```powershell
Get-ADReplicationSite -Filter *
Get-ADReplicationSubnet -Filter *
Get-ADDomainController -Filter * | Select HostName,Site
```

Expected result: domain controllers and subnets map to approved sites.

## Rollback

If a new site mapping causes authentication issues, remove the subnet mapping or reassign to the previous site while investigating replication and firewall paths.
