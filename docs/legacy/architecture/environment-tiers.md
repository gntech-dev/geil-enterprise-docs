---
title: Environment Tiers
document_id: GEIL-ARCH-TIER-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Environment Tiers

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-ARCH-TIER-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Define how GEIL separates lab, pilot, production, and disaster recovery environments.

## Tiers

| Tier | Purpose | Data Classification | Change Control |
|---|---|---|---|
| Lab | Validate procedures and train engineers | Synthetic only | Lightweight |
| Pilot | Validate production settings with limited users | Limited real data | Standard change ticket |
| Production | Serve business workloads | Business data | Approved change window |
| DR | Recover production services | Replicated business data | DR runbook and test schedule |

## Promotion rule

No configuration moves from lab to production until it is documented, reviewed, and validated in pilot.

## Validation PowerShell

```powershell
Get-ADDomain | Select-Object DNSRoot,DomainMode
Get-ADForest | Select-Object ForestMode,GlobalCatalogs
```

Expected result: the target environment name and domain mode match the approved architecture packet.

## Rollback

If a pilot configuration fails validation, remove the pilot policy, group, or application assignment before editing the production design.
