---
title: Foundation
document_id: GEIL-FND-INDEX
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Foundation

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-FND-INDEX |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Virtualization, routing, firewalling, prerequisites, and site bootstrap.

## Required use

Before implementing changes in this area, read the applicable standard, confirm prerequisites, execute the documented validation steps, and record evidence in the change ticket.

## Documentation quality gate

- Implementation steps must include expected results.
- PowerShell must include validation and rollback where practical.
- Known GNTECH values must use the canonical values in the [Environment Specification](../project/environment-specification.md); only approved secret or deployment-unknown placeholders are permitted.
