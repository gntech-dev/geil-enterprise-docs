---
title: Documentation Backlog
document_id: GEIL-PRJ-BACKLOG-001
owner: Infrastructure Engineering
status: Draft
version: 1.1
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Documentation Backlog

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-PRJ-BACKLOG-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.1 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

The documentation backlog tracks missing or future GEIL documentation work. Items are documentation deliverables, not infrastructure execution tasks.

## Priority definitions

| Priority | Meaning |
|---|---|
| P0 | Blocks safe production implementation |
| P1 | Required before broad rollout |
| P2 | Improves operations, maintainability, or scale |
| P3 | Enhancement, optional depth, or later optimization |

## Status definitions

| Status | Meaning |
|---|---|
| Open | Not started |
| In Progress | Actively being authored or reviewed |
| Done | Documentation exists, is indexed, and passes strict build |
| Deferred | Valid need, intentionally delayed |

## Current backlog

| ID | Priority | Status | Item | Acceptance Criteria | Output |
|---|---:|---|---|---|---|
| DOC-001 | P0 | Done | Add Cloudflare Pages deployment runbook | Repository connected, build command documented, private access documented, rollback documented | [Cloudflare Pages Deployment Runbook](../platform/cloudflare-pages-deployment.md) |
| DOC-002 | P0 | Done | Add privileged access model | Tier 0/1/2 OU, group, workstation, sign-in, and emergency access controls documented | [Privileged Access Model](../security/privileged-access-model.md) |
| DOC-003 | P1 | Open | Add certificate lifecycle runbook | Renewal, template versioning, CRL validation, monitoring, and emergency revocation included | Target: `docs/microsoft-core/certificate-lifecycle-runbook.md` |
| DOC-004 | P1 | Open | Add Entra Conditional Access baseline | Break-glass exclusions, MFA, device compliance, risk policies, report-only testing, and rollback documented | Target: `docs/cloud-endpoint/conditional-access-baseline.md` |
| DOC-005 | P2 | Open | Add multinational data residency model | Region ownership, tenant strategy, naming, compliance assumptions, and ADR triggers documented | Target: `docs/architecture/multinational-data-residency.md` |
| DOC-006 | P2 | Open | Add Cloudflare Access policy runbook | Identity provider, application policy, emergency bypass, logging, and rollback documented | Target: `docs/platform/cloudflare-access-runbook.md` |
| DOC-007 | P1 | Open | Add privileged access request and approval runbook | Request workflow, approvals, expiration, evidence, rollback, and review documented | Target: `docs/security/privileged-access-request-runbook.md` |
| DOC-008 | P1 | Open | Add emergency access account test and recovery runbook | Quarterly test, alert validation, lockout recovery, evidence, and credential handling documented | Target: `docs/security/emergency-access-runbook.md` |
| DOC-009 | P2 | Open | Add Privileged Access Workstation build runbook | Windows 11 Enterprise build, Intune policies, Defender controls, browser restrictions, validation, and rollback documented | Target: `docs/security/privileged-access-workstation-build.md` |
| DOC-010 | P2 | Open | Add service account lifecycle and gMSA runbook | Creation, ownership, delegation, gMSA preference, monitoring, rotation, and retirement documented | Target: `docs/security/service-account-lifecycle.md` |

## Next highest-priority item

The next highest-priority open item is `DOC-003`, the certificate lifecycle runbook.

## Backlog maintenance procedure

1. Add documentation gaps immediately when discovered.
2. Assign a priority, status, target path, and acceptance criteria.
3. Promote P0 and P1 items into the roadmap.
4. Mark items Done only after navigation, index, changelog, and strict build validation are complete.
5. Never delete completed backlog rows unless the document is retired through the document index.
