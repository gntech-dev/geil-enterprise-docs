---
title: Backlog
document_id: GEIL-GOV-BACKLOG-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Backlog

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-GOV-BACKLOG-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

The backlog tracks missing or future documentation work. Items are documentation work, not infrastructure tasks.

## Priority definitions

| Priority | Meaning |
|---|---|
| P0 | Blocks safe production implementation |
| P1 | Required before broad rollout |
| P2 | Improves operations or scale |
| P3 | Enhancement or optional depth |

## Current backlog

| ID | Priority | Item | Acceptance Criteria |
|---|---:|---|---|
| DOC-001 | P0 | Add Cloudflare Pages deployment runbook | Repository connected, build command documented, rollback documented |
| DOC-002 | P0 | Add privileged access model | Tier 0/1/2 OU, group, workstation, and sign-in controls documented |
| DOC-003 | P1 | Add certificate lifecycle runbook | Renewal, template versioning, CRL validation, and emergency revocation included |
| DOC-004 | P1 | Add Entra Conditional Access baseline | Break-glass exclusions, MFA, device compliance, and risk policies documented |
| DOC-005 | P2 | Add multinational data residency model | Region ownership, tenant strategy, naming, and compliance assumptions documented |

## Backlog maintenance procedure

1. Add new documentation gaps immediately when discovered.
2. Reference affected pages.
3. Promote P0/P1 items to the roadmap.
4. Remove items only after merged documentation satisfies acceptance criteria.
