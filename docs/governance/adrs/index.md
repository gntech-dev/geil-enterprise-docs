---
title: Architecture Decision Records
document_id: GEIL-ADR-INDEX
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Architecture Decision Records

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-ADR-INDEX |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

ADRs record approved deviations, major choices, and long-lived tradeoffs.

## Required use

Before implementing changes in this area, read the applicable standard, confirm prerequisites, execute the documented validation steps, and record evidence in the change ticket.

## Documentation quality gate

- Implementation steps must include expected results.
- PowerShell must include validation and rollback where practical.
- Known GNTECH values must use the canonical values in the [Environment Specification](../../project/environment-specification.md); only approved secret or deployment-unknown placeholders are permitted.

## Accepted ADRs

- [ADR-0001 MkDocs Material](ADR-0001-mkdocs-material.md)
- [ADR-0002 Use MikroTik CHR for Phase 1 HQ Firewall](ADR-0002-mikrotik-chr-phase-1-firewall.md)
- [ADR-0003 Hybrid Identity Namespace](ADR-0003-hybrid-identity-namespace.md)
