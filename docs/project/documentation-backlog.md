---
title: Documentation Backlog
document_id: GEIL-PRJ-BACKLOG-001
owner: Infrastructure Engineering
status: Draft
version: 21.0
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
| Version | 21.0 |
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
| DOC-001 | P0 | E00 | E00.R02 | Done | Add Cloudflare Pages deployment runbook | Repository connected, build command documented, private access documented, rollback documented | [Cloudflare Pages Deployment Runbook](../legacy/platform/cloudflare-pages-deployment.md) |
| DOC-002 | P0 | E03 | E03.R03 | Done | Add privileged access model | Tier 0/1/2 OU, group, workstation, sign-in, and emergency access controls documented | [Privileged Access Model](../legacy/security/privileged-access-model.md) |
| DOC-011 | P0 | E00 | E00.R01 | Done | Add canonical GNTECH environment specification | Domains, forest, NetBIOS, UPN suffix, server names, VLANs, IP addressing, DNS, certificate naming, share naming, repository, and documentation URLs documented | [Environment Specification](environment-specification.md) |
| DOC-012 | P0 | E00 | E00.R01 | Done | Add capability-first epic/release architecture | Epics, releases, document assignments, capability dependency graph, and document dependency graph documented | [Epic and Release Architecture](epic-release-architecture.md) |
| DOC-015 | P0 | E01 | E01.R02 | Done | Add enterprise architecture vision foundation | Master Plan, capability model, reference architecture, technology matrix, implementation philosophy, and architecture principles documented with diagrams and cross-references | [GEIL Master Plan](master-plan.md) |
| DOC-016 | P0 | E02 | E02.R02 | Done | Add Enterprise Lab Blueprint HLD | Physical, logical, site, datacenter, AD site, forest, domain, DNS, DHCP, PKI, WiFi, identity, storage, backup, monitoring, security zone, VLAN, IP addressing, naming, regional expansion, DR, and cloud integration architecture documented | [Enterprise Lab Blueprint HLD](../legacy/architecture/enterprise-lab-blueprint.md) |
| DOC-017 | P0 | E02 | E02.R03 | Done | Add HQ Foundation LLD and Phase 1 build plan | Proxmox bridge/VLAN design, MikroTik CHR VM/interfaces/gateways/rules, HQ VM specifications, routing/DHCP relay decisions, management access path, rollback checkpoints, deployment sequence, and validation checklist documented | [Phase 1 Build Plan](../legacy/platform/phase-1-build-plan.md) |
| DOC-018 | P0 | E00 | E00.R01 | Done | Add visual documentation standard | Mermaid usage policy, complex diagram asset path, 16:9 dark visual style, source/export requirements, page requirements, and existing replacement candidates documented | [Visual Documentation Standard](../governance/visual-documentation-standard.md) |
| DOC-020 | P0 | E02 | E02.R04 | Done | Add HQ Foundation Implementation Runbooks | Proxmox and MikroTik CHR implementation guides include prerequisites, required access/files, exact configuration steps, bridge/VLAN/gateway/firewall/DNS/DHCP relay decisions, validation commands, rollback, troubleshooting, and evidence capture | [Proxmox HQ Foundation Implementation](../legacy/platform/proxmox-hq-foundation-implementation.md) |
| DOC-021 | P0 | E02 | E02.R05 | Done | Add HQ Foundation Evidence and Acceptance Package | Evidence rules, screenshot requirements, command outputs, Proxmox/MikroTik CHR/VLAN/firewall/routing/DNS/DHCP/snapshot/rollback evidence, exceptions register, acceptance criteria, sign-off, and remediation workflow documented | [Phase 1 Acceptance Package](../legacy/platform/phase-1-acceptance-package.md) |
| DOC-022 | P0 | E02 | E02.R04 | Done | Upgrade Phase 1 implementation documents to operator-grade detail | Priority implementation, build, validation, and acceptance documents include exact objectives, prerequisites, assumptions, access/files, starting/ending states, copy/paste blocks, GUI paths, validation after major steps, rollback commands, common errors, troubleshooting, evidence, and acceptance criteria | [Proxmox HQ Foundation Implementation](../legacy/platform/proxmox-hq-foundation-implementation.md) |
| DOC-023 | P0 | E00 | E00.R01 | Done | Add Implementation Guide Standard and refactor existing guides | Standard defines Microsoft Learn-style guide structure; existing Proxmox, MikroTik CHR, Active Directory, and DNS/DHCP implementation guides include learning objectives, background knowledge, step validation, rollback, evidence, screenshot placeholders, knowledge checks, and next-guide links | [Implementation Guide Standard](../governance/implementation-guide-standard.md) |
| DOC-024 | P0 | E00 | E00.R01 | Done | Add Educational Documentation Standard and demonstrate methodology | Standard defines teaching-before-instruction principles, required educational sections, enterprise and implementation admonitions, visual learning requirements, value explanation depth, FAQs, and key takeaways; five implementation guides demonstrate the methodology | [Educational Documentation Standard](../governance/educational-documentation-standard.md) |
| DOC-025 | P0 | E02 | E02.R04 | Done | Change Phase 1 firewall implementation to MikroTik CHR | ADR-0002 accepted; canonical environment, HLD/LLD, build, validation, acceptance, technology matrix, navigation, roadmap, backlog, and active implementation guide updated from OPNsense to MikroTik CHR; OPNsense retained as alternative/superseded reference | [MikroTik CHR HQ Foundation Implementation](../legacy/platform/mikrotik-chr-hq-foundation-implementation.md) |
| DOC-026 | P0 | E00 | E00.R01 | Done | Full implementation guide audit and correction | Audited 32 scoped guides; corrected MikroTik CHR command order, DHCP relay sequence, AD validation gates, Group Policy order, Proxmox safety notes, and missing implementation-guide structure sections | [Implementation Guide Audit Report](implementation-guide-audit-report.md) |
| DOC-027 | P0 | E02/E03 | E02.R04 / E03.R01 | Done | Expand MikroTik CHR and Windows Server deployment detail | MikroTik CHR guide includes image preparation, Proxmox VM settings, first login, Safe Mode workflow, WinBox evidence, and do-not-proceed gates; Windows Server guide includes Proxmox VM settings, edition choice, VirtIO driver workflow, first-login checklist, static IP detail, patch loop, pre-role snapshot, and do-not-proceed gates | [MikroTik CHR HQ Foundation Implementation](../legacy/platform/mikrotik-chr-hq-foundation-implementation.md), [Windows Server 2025 Baseline](../microsoft-core/windows-server-2025-baseline.md) |
| DOC-028 | P0 | E00 | E00.R01 | Done | Launch Documentation Quality Initiative | Created Deployment Style Guide, audited 32 scoped guides, improved six priority guides with DQI operator workflow blocks, and published quality scores/recommendations | [Documentation Quality Report](documentation-quality-report.md) |
| DOC-029 | P0 | E00 | E00.R01 | Done | Mandatory release quality gate audit | Audited all 75 Markdown files under `docs/`; corrected broken table structure and duplicate procedural headings; verified code fences, language identifiers, links, images, admonitions, navigation, release assignments, and strict build | [Documentation Quality Report](documentation-quality-report.md) |
| DOC-030 | P0 | E00 | E00.R01 | Done | Audit canonical MikroTik CHR and Hybrid UPN architecture | Repository audited after ADR-0002 and ADR-0003; active firewall, forest, NetBIOS, UPN, legacy logon, server FQDNs, diagrams, implementation guides, operations, roadmap, backlog, document index, and changelog validated against canonical model | [Environment Specification](environment-specification.md) |
| DOC-031 | P0 | E03 | E03.R01 | Done | Add Active Directory organizational foundation | Canonical OU hierarchy, initial users, groups, service accounts, delegation boundaries, GPO readiness, Entra ID readiness, PowerShell implementation, validation, rollback, navigation, index, roadmap, changelog, and strict build completed | [Active Directory Organizational Foundation](../microsoft-core/active-directory-organizational-foundation.md) |
| DOC-032 | P0 | E03 | E03.R01 | Done | Complete Enterprise Identity Foundation prerequisite documentation | Naming standard, group strategy, user lifecycle, service account standard, administrative tiering, firewall matrix, port reference, domain controller backup, and golden-template documents created; existing Microsoft Core dependency references updated | [Enterprise Naming Standard](../microsoft-core/active-directory-naming-standard.md) |
| DOC-033 | P0 | E02 | E02.R03/E02.R04 | Done | Add golden image and firewall dependency references | Windows Server 2025 and Windows 11 Enterprise golden templates, firewall rule matrix, and enterprise port reference documented for Microsoft Core readiness | [Windows Server 2025 Golden Template](../legacy/platform/windows-server-2025-golden-template.md) |
| DOC-034 | P0 | E05 | E05.R01 | Done | Add domain controller backup and recovery foundation | System State, snapshots, bare metal, authoritative and non-authoritative restore, and DR guidance documented before PKI/NPS/Entra Connect | [Domain Controller Backup and Recovery](../legacy/operations/domain-controller-backup.md) |
| DOC-035 | P0 | E00 | E00.R01 | Done | Complete repository production readiness audit | All `docs/` documents plus `MASTER_PLAN.md` and `CHANGELOG.md` audited for deployability; PowerShell, RouterOS, Linux/Bash, Windows/CMD, Mermaid, dependency-order, canonical-value, and rendered-output gates run; high-confidence AD dependency/idempotency defects corrected | [Production Readiness Audit Report](production-readiness-audit-report.md) |
| DOC-038 | P0 | E02/E03 | E02.R04 / E03.R01 | Done | Separate Windows 11 template from domain join validation | Golden template guide is workgroup-only with VirtIO, QEMU Guest Agent, Cloudbase-Init, Sysprep, and template conversion; domain join and `GP - Baseline - Workstations` validation moved to a separate clone-stage guide | [Windows 11 Domain Join and GPO Validation](../microsoft-core/windows-client-lifecycle/windows-11-domain-join-gpo-validation.md) |
| DOC-039 | P0 | E02/E03 | E02.R04 / E03.R01 | Done | Correct HQ-MGMT01 management workstation architecture | `HQ-MGMT01` documented as Windows 11 Enterprise management workstation / initial PAW; Windows Server is explicitly not a daily admin workstation; deployment sequence includes clone, VLAN30, DHCP/DNS/DC validation, domain join, RSAT, and remote administration | [Windows 11 Management Workstation](../microsoft-core/windows-client-lifecycle/windows-11-management-workstation.md) |
| DOC-040 | P0 | E03 | E03.R01/E03.R03 | Done | Add AD baseline group membership assignment | Organizational Foundation now assigns required memberships after user/group creation, including group-based Tier 0 bootstrap nesting without direct user membership in Domain Admins; related group, privilege, tiering, lifecycle, and service-account docs updated | [Active Directory Organizational Foundation](../microsoft-core/active-directory-organizational-foundation.md) |
| DOC-041 | P0 | E00 | E00.R01 | Done | Complete documentation architecture review | Repository-wide classification completed; single-source-of-truth rules added; Future and Archive sections added; navigation reorganized around Foundation, Platform, Microsoft Core, Security, Architecture, Operations, Project, Future, and Archive | [Documentation Architecture Review](documentation-architecture-review.md) |
| DOC-042 | P0 | E02/E03 | E02.R03 / E02.R04 / E03.R01 | Done | Correct HQ-MGMT01 Management VLAN and OU architecture | `HQ-MGMT01` moved to Management VLAN 10 and Management Workstations OU; `HQ-W11-001` remains VLAN30 standard client; future `GP - Baseline - Management Workstations` architecture prepared without unvalidated settings | [Windows 11 Management Workstation](../microsoft-core/windows-client-lifecycle/windows-11-management-workstation.md) |
| DOC-043 | P0 | E03 | E03.R01 / E05.R01 | Done | Fix Microsoft Core phase navigation | Microsoft Core navigation and index now show Phase 1 Identity Foundation, Phase 2 Core Infrastructure Services, Phase 3 Windows Client Lifecycle, Phase 4 Administration, Phase 5 File Services Future, and Phase 6 Future Identity Expansion; identity/access reference docs moved out of loose deployment-step navigation | [Microsoft Core](../microsoft-core/index.md) |
| DOC-044 | P0 | E00 | E00.R01 | Done | Add command execution context standard | Deployment Style Guide and Implementation Guide Standard now require every operator-facing command block to identify run location, timing, and expected outcome; Microsoft Core, Platform, and Security implementation guides annotated with execution context | [Deployment Style Guide](../governance/deployment-style-guide.md) |
| DOC-003 | P1 | E03 | E03.R04 | Open | Add certificate lifecycle runbook | Renewal, template versioning, CRL validation, monitoring, and emergency revocation included | Target: `docs/microsoft-core/certificate-lifecycle-runbook.md` |
| DOC-004 | P1 | E04 | E04.R02 | Open | Add Entra Conditional Access baseline | Break-glass exclusions, MFA, device compliance, risk policies, report-only testing, and rollback documented | Target: `docs/legacy/cloud-endpoint/conditional-access-baseline.md` |
| DOC-007 | P1 | E03 | E03.R05 | Open | Add privileged access request and approval runbook | Request workflow, approvals, expiration, evidence, rollback, and review documented | Target: `docs/legacy/security/privileged-access-request-runbook.md` |
| DOC-008 | P1 | E03 | E03.R05 | Open | Add emergency access account test and recovery runbook | Quarterly test, alert validation, lockout recovery, evidence, and credential handling documented | Target: `docs/legacy/security/emergency-access-runbook.md` |
| DOC-009 | P2 | E03 | E03.R05 | Open | Add Privileged Access Workstation build runbook | Windows 11 Enterprise build, Intune policies, Defender controls, browser restrictions, validation, and rollback documented | Target: `docs/legacy/security/privileged-access-workstation-build.md` |
| DOC-010 | P2 | E03 | E03.R06 | Open | Add service account lifecycle and gMSA runbook | Creation, ownership, delegation, gMSA preference, monitoring, rotation, and retirement documented | Target: `docs/legacy/security/service-account-lifecycle.md` |
| DOC-006 | P2 | E00 | E00.R03 | Open | Add Cloudflare Access policy runbook | Identity provider, application policy, emergency bypass, logging, and rollback documented | Target: `docs/legacy/platform/cloudflare-access-runbook.md` |
| DOC-013 | P2 | E00 | E00.R03 | Open | Add GitHub repository security baseline | Branch protection, CODEOWNERS, secret scanning, required reviews, and CI checks documented | Target: `docs/legacy/platform/github-repository-security.md` |
| DOC-014 | P2 | E00 | E00.R04 | Open | Add glossary and authoring templates | Glossary, acronyms, document templates, runbook template, and ADR template published | Target: `docs/reference/glossary.md` and `templates/` |
| DOC-019 | P1 | E00 | E00.R04 | Done | Replace high-complexity Mermaid diagrams with dedicated visual assets | P0/P1 replacement candidates from Visual Documentation Standard have source files, local SVG architecture assets, and WebP generation prompts under `docs/assets/diagram-prompts/` | [Visual Documentation Standard](../governance/visual-documentation-standard.md) |
| DOC-005 | P2 | E07 | E07.R01 | Open | Add multinational data residency model | Region ownership, tenant strategy, naming, compliance assumptions, and ADR triggers documented | Target: `docs/legacy/architecture/multinational-data-residency.md` |

## Next highest-priority item

The next highest-priority open item is `DOC-003`, delivered by release **E03.R04 Certificate lifecycle management**, after confirming the E02.R05 HQ foundation acceptance package is approved or approved with accepted exceptions.

## Backlog maintenance procedure

1. Add documentation gaps immediately when discovered.
2. Assign each item to exactly one Epic and exactly one Release.
3. Assign a priority, status, target path, and acceptance criteria.
4. Promote P0 and P1 items into the roadmap.
5. Mark items Done only after navigation, index, release assignment, changelog, and strict build validation are complete.
6. Never delete completed backlog rows unless the document is retired through the document index.

| DOC-026 | P0 | E00 | E00.R01 | Done | Add code block quality standard and audit tools | Added mandatory code-block quality standard plus PowerShell/Bash audit tools after pilot deployment found executable documentation defects | [Code Block Quality Standard](../governance/code-block-quality-standard.md) |
