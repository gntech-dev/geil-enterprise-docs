---
title: Documentation Architecture Review
document_id: GEIL-PRJ-DOCARCH-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# Documentation Architecture Review

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-PRJ-DOCARCH-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This review converts GEIL from a document-growth model to a single-source-of-truth documentation architecture. It is not a content reduction exercise. Technical knowledge must be preserved while duplicate explanations, premature implementation documents, and small single-purpose documents are consolidated into authoritative concept owners.

## Permanent documentation architecture principles

1. One concept has one authoritative document.
2. New Markdown documents may be created only for an entirely new platform, a major capability, a required section landing page, or an approved architecture/control-plane record.
3. If information naturally belongs in an existing document, update that document instead of creating another file.
4. Remove duplicated technical explanations by merging them into the authoritative owner.
5. Keep implementation, validation, troubleshooting, rollback, and pilot findings together whenever practical.
6. Roadmap items must not become operational documentation until implemented or explicitly moved from Future into the active laboratory sequence.
7. Before creating a Markdown document, search for the existing concept owner and update it if one exists.
8. The laboratory is the source of truth. Pilot findings update the existing authoritative document, not a new parallel report.

## Proposed repository structure

```text
docs/
  foundation/
  platform/
  microsoft-core/
  security/
  architecture/
  operations/
  project/
  future/
  archive/
```

## Recommended authoritative concept owners

| Concept | Authoritative owner | Merge sources |
|---|---|---|
| Overall enterprise architecture | Enterprise Blueprint | Enterprise reference architecture, capability model, technology matrix, implementation philosophy, principles, lab HLDs |
| Network architecture | Network Architecture | Network HLD, firewall matrix, AD network requirements, port reference, validation/acceptance network sections |
| Identity architecture | Identity Architecture | Identity HLD, AD organizational foundation references, tiering summaries |
| Identity and access standard | Proposed Identity and Access Standard | group strategy, naming standard, user lifecycle, service account standard, administrative tiering, privileged access model |
| DNS/DHCP | DNS and DHCP Implementation | DNS/DHCP architecture, implementation, validation, pilot findings, troubleshooting |
| MikroTik CHR | MikroTik CHR HQ Foundation Implementation | LLD, implementation, validation findings, firewall references where not broadly reusable |
| Proxmox | Proxmox HQ Foundation Implementation | Proxmox LLD, baseline, build plan, validation/acceptance content |
| Windows client lifecycle | Windows 11 template/domain/management guides | template, management workstation, domain join/GPO validation |
| Operations | Backup/Recovery, Troubleshooting, Security Operations | DC backup, scaling, monitoring details where appropriate |

## Security documentation consolidation recommendation

The following should become a single authoritative **Identity and Access Standard** after current pilot stabilization:

- `microsoft-core/active-directory-naming-standard.md`
- `microsoft-core/group-strategy.md`
- `microsoft-core/user-lifecycle.md`
- `microsoft-core/service-account-standard.md`
- `security/administrative-tiering.md`
- `security/privileged-access-model.md`

Required sections: Users, Groups, AGDLP, Service Accounts, Administrative Tiering, Privileged Access, Delegation, Naming Standards.

## Architecture consolidation recommendation

Prefer only these active architecture owners: Enterprise Blueprint, Network Architecture, and Identity Architecture. Other architecture documents should be merged or converted to historical/reference material once their unique content is moved into one of those three owners.

## Implementation guide rule

Each deployable technology should have one implementation guide that includes architecture summary, implementation, validation, pilot findings, troubleshooting, rollback, and evidence requirements. Separate LLD, validation, and acceptance documents may remain temporarily during Phase 1, but future pilot findings must update the implementation guide or concept owner.

## Future section rule

Documents for technologies not yet implemented remain in Future. Current Future candidates include Windows Hello for Business, Entra ID Hybrid, Intune, Microsoft 365, Microsoft Defender, PKI, and NPS. These are preserved but treated as planning material until the lab validates them.

## Navigation improvements applied in this change

- Top-level navigation now follows: Foundation, Platform, Microsoft Core, Security, Architecture, Operations, Project, Future, Archive.
- The previous Governance tab is folded under Project because governance is a project control-plane function.
- Cloud/endpoint and unimplemented trust/network-authentication materials are surfaced under Future.
- Superseded OPNsense documents are surfaced under Archive.
- Active implementation sections prioritize authoritative, pilot-validated documents.

## Estimated document-count reduction

Current Markdown documents audited: 95

| Category | Count | Meaning |
|---|---:|---|

| KEEP | 51 | Remain active authoritative/control-plane docs. |
| MERGE | 29 | Preserve content but consolidate into authoritative owners. |
| MOVE TO FUTURE | 9 | Planning docs, not current operations. |
| ARCHIVE | 6 | Historical/superseded docs retained for traceability. |
| REMOVE | 0 | No deletion recommended in this review. |


If the recommended merges are completed, GEIL can reduce active document count by approximately **19** documents without deleting technical knowledge. Additional active-count reduction comes from moving **9** Future documents and **6** Archive documents out of the operational path.

## Document classification register

| Path | Title | Decision | Rationale |
|---|---|---|---|

| `architecture/architecture-principles.md` | Architecture Principles | MERGE | Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material. |
| `architecture/enterprise-capability-model.md` | Enterprise Capability Model | MERGE | Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material. |
| `architecture/enterprise-lab-blueprint.md` | Enterprise Lab Blueprint HLD | MERGE | Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material. |
| `architecture/enterprise-lab-identity-hld.md` | Enterprise Lab Identity HLD | MERGE | Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material. |
| `architecture/enterprise-lab-network-hld.md` | Enterprise Lab Network HLD | MERGE | Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material. |
| `architecture/enterprise-lab-operations-hld.md` | Enterprise Lab Operations HLD | MERGE | Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material. |
| `architecture/enterprise-reference-architecture.md` | Enterprise Reference Architecture | MERGE | Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material. |
| `architecture/environment-tiers.md` | Environment Tiers | MERGE | Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material. |
| `architecture/identity-architecture.md` | Identity Architecture | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `architecture/implementation-philosophy.md` | Implementation Philosophy | MERGE | Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material. |
| `architecture/index.md` | Architecture | KEEP | Section landing page required for MkDocs navigation. |
| `network/network-architecture.md` | Network Architecture | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `architecture/reference-architecture.md` | Reference Architecture | MERGE | Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material. |
| `architecture/technology-selection-matrix.md` | Technology Selection Matrix | MERGE | Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material. |
| `archive/index.md` | Archive | ARCHIVE | Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path. |
| `cloud-endpoint/entra-id-hybrid-identity.md` | Entra ID Hybrid Identity | MOVE TO FUTURE | Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it. |
| `cloud-endpoint/index.md` | Cloud and Endpoint | MOVE TO FUTURE | Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it. |
| `cloud-endpoint/intune-windows11-enterprise.md` | Intune Windows 11 Enterprise | MOVE TO FUTURE | Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it. |
| `cloud-endpoint/microsoft-365-tenant-foundation.md` | Microsoft 365 Tenant Foundation | MOVE TO FUTURE | Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it. |
| `cloud-endpoint/microsoft-defender.md` | Microsoft Defender | MOVE TO FUTURE | Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it. |
| `cloud-endpoint/windows-hello-for-business.md` | Windows Hello for Business | MOVE TO FUTURE | Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it. |
| `foundation/index.md` | Foundation | KEEP | Section landing page required for MkDocs navigation. |
| `foundation/opnsense-edge-firewall.md` | Superseded OPNsense Edge Firewall | ARCHIVE | Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path. |
| `foundation/phase-0-prerequisites.md` | Phase 0 Prerequisites | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `foundation/proxmox-ve-baseline.md` | Proxmox VE Baseline | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `future/index.md` | Future | MOVE TO FUTURE | Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it. |
| `governance/adrs/ADR-0001-mkdocs-material.md` | ADR-0001 MkDocs Material Documentation Platform | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `governance/adrs/ADR-0002-mikrotik-chr-phase-1-firewall.md` | ADR-0002 Use MikroTik CHR for Phase 1 HQ Firewall | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `governance/adrs/ADR-0003-hybrid-identity-namespace.md` | ADR-0003 Hybrid Identity Namespace | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `governance/adrs/index.md` | Architecture Decision Records | KEEP | Section landing page required for MkDocs navigation. |
| `governance/backlog.md` | Backlog | ARCHIVE | Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path. |
| `governance/code-block-quality-standard.md` | Code Block Quality Standard | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `governance/deployment-style-guide.md` | Deployment Style Guide | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `governance/documentation-standard.md` | Documentation Standard | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `governance/educational-documentation-standard.md` | Educational Documentation Standard | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `governance/implementation-guide-standard.md` | Implementation Guide Standard | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `governance/index.md` | Governance | KEEP | Section landing page required for MkDocs navigation. |
| `governance/naming-addressing-standard.md` | Naming and Addressing Standard | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `governance/roadmap.md` | Roadmap | ARCHIVE | Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path. |
| `governance/visual-documentation-standard.md` | Visual Documentation Standard | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `index.md` | GEIL Home | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `microsoft-core/active-directory-implementation.md` | Active Directory Implementation | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `microsoft-core/active-directory-naming-standard.md` | Enterprise Naming Standard | MERGE | Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost. |
| `microsoft-core/active-directory-organizational-foundation.md` | Active Directory Organizational Foundation | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `microsoft-core/ad-cs-pki.md` | AD CS PKI | MOVE TO FUTURE | Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it. |
| `microsoft-core/dns-dhcp-implementation.md` | DNS and DHCP Implementation | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `microsoft-core/group-policy-baseline.md` | Group Policy Baseline | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `microsoft-core/group-strategy.md` | Enterprise Group Strategy | MERGE | Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost. |
| `microsoft-core/index.md` | Microsoft Core | KEEP | Section landing page required for MkDocs navigation. |
| `microsoft-core/nps-radius-8021x.md` | NPS RADIUS 802.1X | MOVE TO FUTURE | Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it. |
| `microsoft-core/powershell-operations.md` | PowerShell Operations | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `microsoft-core/service-account-standard.md` | Enterprise Service Account Standard | MERGE | Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost. |
| `microsoft-core/user-lifecycle.md` | Enterprise User Lifecycle | MERGE | Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost. |
| `microsoft-core/windows-admin-center.md` | Windows Admin Center | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `microsoft-core/windows-server-2025-baseline.md` | Windows Server 2025 Baseline | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `operations/backup-recovery.md` | Backup and Recovery | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `operations/domain-controller-backup.md` | Domain Controller Backup and Recovery | MERGE | Fold into the primary operations guide for the concept: Backup/Recovery, Troubleshooting, or Security Operations. |
| `operations/index.md` | Operations | KEEP | Section landing page required for MkDocs navigation. |
| `operations/monitoring-alerting.md` | Monitoring and Alerting | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `operations/scaling-model.md` | Scaling Model | MERGE | Fold into the primary operations guide for the concept: Backup/Recovery, Troubleshooting, or Security Operations. |
| `operations/security-operations.md` | Security Operations | MERGE | Fold into the primary operations guide for the concept: Backup/Recovery, Troubleshooting, or Security Operations. |
| `operations/troubleshooting.md` | Troubleshooting | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `platform/active-directory-network-requirements.md` | Active Directory Network Requirements | MERGE | Fold design/validation/reference content into the authoritative platform implementation guide where practical. |
| `platform/cloudflare-pages-deployment.md` | Cloudflare Pages Deployment Runbook | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `platform/enterprise-port-reference.md` | Enterprise Port Reference | MERGE | Fold design/validation/reference content into the authoritative platform implementation guide where practical. |
| `network/firewall-rule-matrix.md` | Firewall Rule Matrix | MERGE | Fold design/validation/reference content into the authoritative platform implementation guide where practical. |
| `platform/index.md` | Platform | KEEP | Section landing page required for MkDocs navigation. |
| `platform/mikrotik-chr-hq-foundation-implementation.md` | MikroTik CHR HQ Foundation Implementation Guide | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `platform/mikrotik-chr-hq-foundation-lld.md` | MikroTik CHR HQ Foundation LLD | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `platform/opnsense-hq-foundation-implementation.md` | OPNsense HQ Foundation Implementation Runbook | ARCHIVE | Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path. |
| `platform/opnsense-hq-foundation-lld.md` | OPNsense HQ Foundation LLD | ARCHIVE | Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path. |
| `platform/phase-1-acceptance-package.md` | Phase 1 Acceptance Package | MERGE | Fold design/validation/reference content into the authoritative platform implementation guide where practical. |
| `platform/phase-1-build-plan.md` | Phase 1 Build Plan | MERGE | Fold design/validation/reference content into the authoritative platform implementation guide where practical. |
| `platform/phase-1-validation-plan.md` | Phase 1 Validation Plan | MERGE | Fold design/validation/reference content into the authoritative platform implementation guide where practical. |
| `platform/proxmox-hq-foundation-implementation.md` | Proxmox HQ Foundation Implementation Runbook | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `platform/proxmox-hq-foundation-lld.md` | Proxmox HQ Foundation LLD | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `microsoft-core/windows-client-lifecycle/windows-11-domain-join-gpo-validation.md` | Windows 11 Domain Join and GPO Validation | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `microsoft-core/windows-client-lifecycle/windows-11-enterprise-golden-template.md` | Windows 11 Enterprise Golden Template | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `microsoft-core/windows-client-lifecycle/windows-11-management-workstation.md` | Windows 11 Management Workstation | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `platform/windows-server-2025-golden-template.md` | Windows Server 2025 Golden Template | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `project/document-index.md` | Document Index | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `project/documentation-architecture-review.md` | Documentation Architecture Review | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `project/documentation-backlog.md` | Documentation Backlog | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `project/documentation-quality-report.md` | Documentation Quality Report | MERGE | Historical audit/report content; retain as evidence but stop creating new parallel reports for future pilot findings. |
| `project/documentation-roadmap.md` | Documentation Roadmap | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `project/environment-specification.md` | Environment Specification | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `project/epic-release-architecture.md` | Epic and Release Architecture | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `project/implementation-guide-audit-report.md` | Implementation Guide Audit Report | MERGE | Historical audit/report content; retain as evidence but stop creating new parallel reports for future pilot findings. |
| `project/index.md` | Project Management | KEEP | Section landing page required for MkDocs navigation. |
| `project/master-plan.md` | GEIL Master Plan | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `project/production-readiness-audit-report.md` | Production Readiness Audit Report | MERGE | Historical audit/report content; retain as evidence but stop creating new parallel reports for future pilot findings. |
| `project/project-charter.md` | GEIL Project Charter | KEEP | Current authoritative document or required control-plane/implementation guide. |
| `security/administrative-tiering.md` | Enterprise Administrative Tiering | MERGE | Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost. |
| `security/index.md` | Security | KEEP | Section landing page required for MkDocs navigation. |
| `security/privileged-access-model.md` | Privileged Access Model | MERGE | Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost. |

## Documents to merge

- `architecture/architecture-principles.md` — Architecture Principles: Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material.
- `architecture/enterprise-capability-model.md` — Enterprise Capability Model: Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material.
- `architecture/enterprise-lab-blueprint.md` — Enterprise Lab Blueprint HLD: Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material.
- `architecture/enterprise-lab-identity-hld.md` — Enterprise Lab Identity HLD: Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material.
- `architecture/enterprise-lab-network-hld.md` — Enterprise Lab Network HLD: Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material.
- `architecture/enterprise-lab-operations-hld.md` — Enterprise Lab Operations HLD: Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material.
- `architecture/enterprise-reference-architecture.md` — Enterprise Reference Architecture: Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material.
- `architecture/environment-tiers.md` — Environment Tiers: Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material.
- `architecture/implementation-philosophy.md` — Implementation Philosophy: Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material.
- `architecture/reference-architecture.md` — Reference Architecture: Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material.
- `architecture/technology-selection-matrix.md` — Technology Selection Matrix: Consolidate into Enterprise Blueprint, Network Architecture, or Identity Architecture; current file remains source material.
- `microsoft-core/active-directory-naming-standard.md` — Enterprise Naming Standard: Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost.
- `microsoft-core/group-strategy.md` — Enterprise Group Strategy: Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost.
- `microsoft-core/service-account-standard.md` — Enterprise Service Account Standard: Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost.
- `microsoft-core/user-lifecycle.md` — Enterprise User Lifecycle: Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost.
- `operations/domain-controller-backup.md` — Domain Controller Backup and Recovery: Fold into the primary operations guide for the concept: Backup/Recovery, Troubleshooting, or Security Operations.
- `operations/scaling-model.md` — Scaling Model: Fold into the primary operations guide for the concept: Backup/Recovery, Troubleshooting, or Security Operations.
- `operations/security-operations.md` — Security Operations: Fold into the primary operations guide for the concept: Backup/Recovery, Troubleshooting, or Security Operations.
- `platform/active-directory-network-requirements.md` — Active Directory Network Requirements: Fold design/validation/reference content into the authoritative platform implementation guide where practical.
- `platform/enterprise-port-reference.md` — Enterprise Port Reference: Fold design/validation/reference content into the authoritative platform implementation guide where practical.
- `network/firewall-rule-matrix.md` — Firewall Rule Matrix: Fold design/validation/reference content into the authoritative platform implementation guide where practical.
- `platform/phase-1-acceptance-package.md` — Phase 1 Acceptance Package: Fold design/validation/reference content into the authoritative platform implementation guide where practical.
- `platform/phase-1-build-plan.md` — Phase 1 Build Plan: Fold design/validation/reference content into the authoritative platform implementation guide where practical.
- `platform/phase-1-validation-plan.md` — Phase 1 Validation Plan: Fold design/validation/reference content into the authoritative platform implementation guide where practical.
- `project/documentation-quality-report.md` — Documentation Quality Report: Historical audit/report content; retain as evidence but stop creating new parallel reports for future pilot findings.
- `project/implementation-guide-audit-report.md` — Implementation Guide Audit Report: Historical audit/report content; retain as evidence but stop creating new parallel reports for future pilot findings.
- `project/production-readiness-audit-report.md` — Production Readiness Audit Report: Historical audit/report content; retain as evidence but stop creating new parallel reports for future pilot findings.
- `security/administrative-tiering.md` — Enterprise Administrative Tiering: Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost.
- `security/privileged-access-model.md` — Privileged Access Model: Merge into proposed Identity and Access Standard; keep temporarily until merged so no technical knowledge is lost.

## Documents to move to Future

- `cloud-endpoint/entra-id-hybrid-identity.md` — Entra ID Hybrid Identity: Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it.
- `cloud-endpoint/index.md` — Cloud and Endpoint: Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it.
- `cloud-endpoint/intune-windows11-enterprise.md` — Intune Windows 11 Enterprise: Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it.
- `cloud-endpoint/microsoft-365-tenant-foundation.md` — Microsoft 365 Tenant Foundation: Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it.
- `cloud-endpoint/microsoft-defender.md` — Microsoft Defender: Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it.
- `cloud-endpoint/windows-hello-for-business.md` — Windows Hello for Business: Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it.
- `future/index.md` — Future: Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it.
- `microsoft-core/ad-cs-pki.md` — AD CS PKI: Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it.
- `microsoft-core/nps-radius-8021x.md` — NPS RADIUS 802.1X: Not yet fully laboratory-implemented; preserve content as future planning until the lab validates it.

## Documents to archive

- `archive/index.md` — Archive: Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path.
- `foundation/opnsense-edge-firewall.md` — Superseded OPNsense Edge Firewall: Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path.
- `governance/backlog.md` — Backlog: Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path.
- `governance/roadmap.md` — Roadmap: Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path.
- `platform/opnsense-hq-foundation-implementation.md` — OPNsense HQ Foundation Implementation Runbook: Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path.
- `platform/opnsense-hq-foundation-lld.md` — OPNsense HQ Foundation LLD: Superseded, historical, or legacy control-plane document; retain for traceability but remove from active implementation path.

## Documents to remove

No documents are recommended for deletion in this pass. This is a simplification and maintainability initiative, not a content deletion exercise.

## Execution sequence for future merge work

1. Merge Identity and Access content first because it has the most duplicate explanations.
2. Merge architecture content into Enterprise Blueprint, Network Architecture, and Identity Architecture.
3. Collapse platform LLD/validation/acceptance duplication into technology implementation guides after Phase 1 acceptance evidence is stable.
4. Move Future documents into active sections only when the laboratory implements them.
5. Archive superseded/historical documents only after the document index identifies the active replacement.

## Validation requirements

Every architecture simplification change must run:

```bash
./tools/audit-doc-codeblocks.sh
. .venv/bin/activate && mkdocs build --strict
```

Do not commit if either command fails.
