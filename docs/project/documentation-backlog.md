---
title: Documentation Backlog
document_id: GEIL-PRJ-BACKLOG-001
owner: Infrastructure Engineering
status: Draft
version: 8.0
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
| Version | 8.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

The documentation backlog tracks missing or future GEIL documentation work. Items are documentation deliverables, not infrastructure execution tasks. Every backlog item is assigned to one capability Epic and one target Release.

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
| Done | Documentation exists, is indexed, assigned to a release, and passes strict build |
| Deferred | Valid need, intentionally delayed |

## Current backlog

| ID | Priority | Epic | Release | Status | Item | Acceptance Criteria | Output |
|---|---:|---|---|---|---|---|---|
| DOC-001 | P0 | E00 | E00.R02 | Done | Add Cloudflare Pages deployment runbook | Repository connected, build command documented, private access documented, rollback documented | [Cloudflare Pages Deployment Runbook](../platform/cloudflare-pages-deployment.md) |
| DOC-002 | P0 | E03 | E03.R03 | Done | Add privileged access model | Tier 0/1/2 OU, group, workstation, sign-in, and emergency access controls documented | [Privileged Access Model](../security/privileged-access-model.md) |
| DOC-011 | P0 | E00 | E00.R01 | Done | Add canonical GNTECH environment specification | Domains, forest, NetBIOS, server names, VLANs, IP addressing, DNS, certificate naming, share naming, repository, and documentation URLs documented | [Environment Specification](environment-specification.md) |
| DOC-012 | P0 | E00 | E00.R01 | Done | Add capability-first epic/release architecture | Epics, releases, document assignments, capability dependency graph, and document dependency graph documented | [Epic and Release Architecture](epic-release-architecture.md) |
| DOC-015 | P0 | E01 | E01.R02 | Done | Add enterprise architecture vision foundation | Master Plan, capability model, reference architecture, technology matrix, implementation philosophy, and architecture principles documented with diagrams and cross-references | [GEIL Master Plan](master-plan.md) |
| DOC-016 | P0 | E02 | E02.R02 | Done | Add Enterprise Lab Blueprint HLD | Physical, logical, site, datacenter, AD site, forest, domain, DNS, DHCP, PKI, WiFi, identity, storage, backup, monitoring, security zone, VLAN, IP addressing, naming, regional expansion, DR, and cloud integration architecture documented | [Enterprise Lab Blueprint HLD](../architecture/enterprise-lab-blueprint.md) |
| DOC-017 | P0 | E02 | E02.R03 | Done | Add HQ Foundation LLD and Phase 1 build plan | Proxmox bridge/VLAN design, OPNsense VM/interfaces/gateways/rules, HQ VM specifications, routing/DHCP relay decisions, management access path, rollback checkpoints, deployment sequence, and validation checklist documented | [Phase 1 Build Plan](../platform/phase-1-build-plan.md) |
| DOC-018 | P0 | E00 | E00.R01 | Done | Add visual documentation standard | Mermaid usage policy, complex diagram asset path, 16:9 dark visual style, source/export requirements, page requirements, and existing replacement candidates documented | [Visual Documentation Standard](../governance/visual-documentation-standard.md) |
| DOC-020 | P0 | E02 | E02.R04 | Done | Add HQ Foundation Implementation Runbooks | Proxmox and OPNsense implementation runbooks include prerequisites, required access/files, exact configuration steps, bridge/VLAN/gateway/firewall/DNS/DHCP relay decisions, validation commands, rollback, troubleshooting, and evidence capture | [Proxmox HQ Foundation Implementation](../platform/proxmox-hq-foundation-implementation.md) |
| DOC-021 | P0 | E02 | E02.R05 | Done | Add HQ Foundation Evidence and Acceptance Package | Evidence rules, screenshot requirements, command outputs, Proxmox/OPNsense/VLAN/firewall/routing/DNS/DHCP/snapshot/rollback evidence, exceptions register, acceptance criteria, sign-off, and remediation workflow documented | [Phase 1 Acceptance Package](../platform/phase-1-acceptance-package.md) |
| DOC-003 | P1 | E03 | E03.R04 | Open | Add certificate lifecycle runbook | Renewal, template versioning, CRL validation, monitoring, and emergency revocation included | Target: `docs/microsoft-core/certificate-lifecycle-runbook.md` |
| DOC-004 | P1 | E04 | E04.R02 | Open | Add Entra Conditional Access baseline | Break-glass exclusions, MFA, device compliance, risk policies, report-only testing, and rollback documented | Target: `docs/cloud-endpoint/conditional-access-baseline.md` |
| DOC-007 | P1 | E03 | E03.R05 | Open | Add privileged access request and approval runbook | Request workflow, approvals, expiration, evidence, rollback, and review documented | Target: `docs/security/privileged-access-request-runbook.md` |
| DOC-008 | P1 | E03 | E03.R05 | Open | Add emergency access account test and recovery runbook | Quarterly test, alert validation, lockout recovery, evidence, and credential handling documented | Target: `docs/security/emergency-access-runbook.md` |
| DOC-009 | P2 | E03 | E03.R05 | Open | Add Privileged Access Workstation build runbook | Windows 11 Enterprise build, Intune policies, Defender controls, browser restrictions, validation, and rollback documented | Target: `docs/security/privileged-access-workstation-build.md` |
| DOC-010 | P2 | E03 | E03.R06 | Open | Add service account lifecycle and gMSA runbook | Creation, ownership, delegation, gMSA preference, monitoring, rotation, and retirement documented | Target: `docs/security/service-account-lifecycle.md` |
| DOC-006 | P2 | E00 | E00.R03 | Open | Add Cloudflare Access policy runbook | Identity provider, application policy, emergency bypass, logging, and rollback documented | Target: `docs/platform/cloudflare-access-runbook.md` |
| DOC-013 | P2 | E00 | E00.R03 | Open | Add GitHub repository security baseline | Branch protection, CODEOWNERS, secret scanning, required reviews, and CI checks documented | Target: `docs/platform/github-repository-security.md` |
| DOC-014 | P2 | E00 | E00.R04 | Open | Add glossary and authoring templates | Glossary, acronyms, document templates, runbook template, and ADR template published | Target: `docs/reference/glossary.md` and `templates/` |
| DOC-019 | P1 | E00 | E00.R04 | Open | Replace high-complexity Mermaid diagrams with dedicated visual assets | P0/P1 replacement candidates from Visual Documentation Standard have source files and exported PNG/WebP/SVG assets under `docs/assets/diagrams/` | Target: complex diagram asset migration |
| DOC-005 | P2 | E07 | E07.R01 | Open | Add multinational data residency model | Region ownership, tenant strategy, naming, compliance assumptions, and ADR triggers documented | Target: `docs/architecture/multinational-data-residency.md` |

## Next highest-priority item

The next highest-priority open item is `DOC-003`, delivered by release **E03.R04 Certificate lifecycle management**, after confirming the E02.R05 HQ foundation acceptance package is approved or approved with accepted exceptions.

## Backlog maintenance procedure

1. Add documentation gaps immediately when discovered.
2. Assign each item to exactly one Epic and exactly one Release.
3. Assign a priority, status, target path, and acceptance criteria.
4. Promote P0 and P1 items into the roadmap.
5. Mark items Done only after navigation, index, release assignment, changelog, and strict build validation are complete.
6. Never delete completed backlog rows unless the document is retired through the document index.
