---
title: Architecture
document_id: GEIL-ARCH-INDEX
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Architecture

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-ARCH-INDEX |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Target-state designs and scale patterns.

## Required use

Before implementing changes in this area, read the applicable standard, confirm prerequisites, execute the documented validation steps, and record evidence in the change ticket.

## Documentation quality gate

- Implementation steps must include expected results.
- PowerShell must include validation and rollback where practical.
- Known GNTECH values must use the canonical values in the [Environment Specification](../project/environment-specification.md); only approved secret or deployment-unknown placeholders are permitted.


## Strategic architecture foundation

The following documents define the permanent enterprise architecture foundation for GEIL:

- [Enterprise Capability Model](enterprise-capability-model.md)
- [Enterprise Reference Architecture](enterprise-reference-architecture.md)
- [Technology Selection Matrix](technology-selection-matrix.md)
- [Implementation Philosophy](implementation-philosophy.md)
- [Architecture Principles](architecture-principles.md)

Implementation documents must support one or more capabilities from the Enterprise Capability Model.
