# Changelog

All notable changes to GEIL are documented in this file.

## 2026-06-29

### Added

- Added GEIL Enterprise Identity Foundation prerequisite documentation: Enterprise Naming Standard, Enterprise Group Strategy, Enterprise User Lifecycle, Enterprise Service Account Standard, Enterprise Administrative Tiering, Firewall Rule Matrix, Enterprise Port Reference, Domain Controller Backup and Recovery, Windows Server 2025 Golden Template, and Windows 11 Enterprise Golden Template.
- Added `GEIL-MSC-ADORG-001` Active Directory Organizational Foundation with canonical OU hierarchy, initial users, groups, service accounts, delegation boundaries, GPO readiness, Entra ID readiness, PowerShell implementation, validation, rollback, and evidence guidance.
- Added `GEIL-ADR-0003` Hybrid Identity Namespace and updated canonical identity architecture so AD remains `corp.gntech.me`, NetBIOS is `GNTECH`, and users sign in as `username@gntech.me`.
- Added `GEIL-GOV-DEPLOY-001` Deployment Style Guide as the canonical writing standard for GEIL deployment documentation.
- Added `GEIL-PROJ-DQI-001` Documentation Quality Report with quality scores, weaknesses, recommendations, and next refactoring target.
- Added `GEIL-PROJ-IMPL-AUDIT-001` Full implementation guide audit and correction report.

- Added `GEIL-ADR-0002` ADR-0002 Use MikroTik CHR for Phase 1 HQ Firewall.
- Added `GEIL-PLAT-MTK-HQ-LLD-001` MikroTik CHR HQ Foundation LLD.
- Added `GEIL-PLAT-MTK-HQ-IMPL-001` MikroTik CHR HQ Foundation Implementation Guide.
- Added MikroTik CHR implementation screenshot/evidence placeholder directory under `docs/assets/images/mikrotik-chr-hq-foundation-implementation/`.

- Added `GEIL-GOV-EDU-001` Educational Documentation Standard as a mandatory teaching-first methodology for implementation guides.
- Added screenshot placeholder directory for Windows Server 2025 Baseline under `docs/assets/images/windows-server-2025-baseline/`.

- Added `GEIL-GOV-IMPL-001` Implementation Guide Standard for Microsoft Learn-style deployment guides.
- Added screenshot placeholder directories under `docs/assets/images/` for existing implementation guides.

- Added local SVG architecture visuals under `docs/assets/diagrams/` for PKI hierarchy, security zones, enterprise reference architecture, enterprise lab network, enterprise lab identity, enterprise lab operations, RouterOS VLAN topology, and Proxmox bridge topology.
- Added diagram generation prompts under `docs/assets/diagram-prompts/` with expected WebP output paths for future image-generation/export tooling.

- Added `GEIL-PLAT-PH1-ACCEPT-001` Phase 1 Acceptance Package.

- Added `GEIL-PLAT-PVE-HQ-IMPL-001` Proxmox HQ Foundation Implementation Runbook.
- Added `GEIL-PLAT-MTK-HQ-IMPL-001` MikroTik CHR HQ Foundation Implementation Guide.

- Added `GEIL-GOV-VISUAL-001` Visual Documentation Standard.
- Added `docs/assets/diagrams/` as the canonical storage path for generated diagram assets.
- Identified existing high-complexity Mermaid diagrams that should be replaced with dedicated 16:9 visual assets.

- Added `GEIL-PLAT-PVE-HQ-LLD-001` Proxmox HQ Foundation LLD.
- Added `GEIL-PLAT-MTK-HQ-LLD-001` MikroTik CHR HQ Foundation LLD.
- Added `GEIL-PLAT-PH1-BUILD-001` Phase 1 Build Plan.
- Added `GEIL-PLAT-PH1-VAL-001` Phase 1 Validation Plan.
- Added Mermaid diagrams for Proxmox bridge topology, RouterOS interface/VLAN topology, Phase 1 deployment sequence, rollback checkpoints, and management access flow.

- Added `GEIL-ARCH-LAB-001` Enterprise Lab Blueprint HLD for Phase 1.
- Added `GEIL-ARCH-LAB-NET-001` Enterprise Lab Network HLD.
- Added `GEIL-ARCH-LAB-ID-001` Enterprise Lab Identity HLD.
- Added `GEIL-ARCH-LAB-OPS-001` Enterprise Lab Operations HLD.
- Added Mermaid diagrams for physical topology, logical topology, site topology, security zones, VLAN/IP allocation, WiFi, forest/domain design, DNS, DHCP, PKI, identity, storage, backup, monitoring, security operations, and disaster recovery.

- Added `GEIL-PRJ-MASTER-001` GEIL Master Plan as the North Star for the Enterprise Infrastructure Engineering Library.
- Added `GEIL-ARCH-CAP-001` Enterprise Capability Model.
- Added `GEIL-ARCH-ERA-001` Enterprise Reference Architecture.
- Added `GEIL-ARCH-TECH-001` Technology Selection Matrix.
- Added `GEIL-ARCH-IMPL-001` Implementation Philosophy.
- Added `GEIL-ARCH-PRINCIPLES-001` Architecture Principles.
- Added strategic Mermaid diagrams for capability dependencies, enterprise layers, maturity evolution, and architecture principles.

- Added `GEIL-PRJ-ERA-001` Epic and Release Architecture.
- Added capability-first Epic, Release, and Document hierarchy for scaling GEIL beyond 1,000 pages.
- Added capability dependency graph, release dependency graph, and document dependency graph.
- Added a release assignment register requiring every document to belong to exactly one Release.
- Added `GEIL-PRJ-ENV-001` Environment Specification as the canonical source of truth for the real GNTECH implementation.
- Added canonical GNTECH values for `gntech.me`, `corp.gntech.me`, `GNTECH`, `docs.gntechlabs.me`, `geil-enterprise-docs`, HQ infrastructure names, VLANs, IP ranges, DNS naming, certificate naming, share naming, and repository URLs.

### Changed

- Fixed Active Directory Organizational Foundation PowerShell blocks to use idempotent LDAP-filter existence checks, parent-container validation, clear prerequisite failures, and `Created`/`Exists` deployment output for UPN suffix, OU, group, user, and service-account creation.
- Updated Microsoft Core dependency graph and existing AD, Windows Server, DNS/DHCP, Group Policy, PKI, NPS, security, environment, roadmap, backlog, document index, release assignment, and navigation references for the Enterprise Identity Foundation sequence.
- Active Directory Implementation now routes operators to the organizational foundation before DNS/DHCP, Group Policy, PKI, Entra ID sync, or production onboarding. Updated GPO, privileged access, environment specification, roadmap, backlog, document index, release assignments, and navigation for the new AD foundation gate.
- Audited GEIL after MikroTik CHR and Hybrid UPN architecture changes; corrected stale active firewall, RouterOS export, diagram, document-control, roadmap, backlog, and canonical identity references.
- Improved existing Platform and Microsoft Core implementation guides from Phase 1 field validation lessons: LAN-to-WAN firewall allowance, disabled DHCP relay until scopes exist, RouterOS Safe Mode sequencing, protected Proxmox networking, Windows pre-AD internet/DNS validation, and stop-condition deployment gates.
- Corrected MkDocs rendered-code behavior so fenced code blocks render as real block-level code instead of visible inline language text such as `bash`, `powershell`, or `routeros`; added rendered-site code readability CSS for desktop and mobile copy/paste safety.
- Performed a mandatory release quality gate audit across all 75 Markdown files under `docs/`, correcting duplicate headings, a broken table row, and structural Markdown issues found by custom code-fence/link/table/admonition checks before strict build validation.
- Launched the Documentation Quality Initiative: shifted priority from creating more documents to improving quality, reproducibility, educational value, validation, rollback, and operator experience across existing deployment guides.
- Added DQI operator workflow upgrades to six priority guides: Proxmox, MikroTik CHR, Windows Server 2025, Active Directory, DNS/DHCP, and Group Policy.
- Expanded MikroTik CHR and Windows Server 2025 deployment walkthroughs with first-time operator detail, Proxmox VM settings, image/driver handling, Safe Mode workflow, validation gates, evidence expectations, and do-not-proceed criteria.
- Corrected implementation guide execution order and safety gates across scoped Platform, Microsoft Core, Foundation, Security, and Operations guidance, with major corrections to MikroTik CHR, DHCP relay, AD DS validation, Group Policy order, and Proxmox safety notes.

- Changed active Phase 1 firewall implementation from OPNsense to MikroTik CHR / RouterOS while preserving the Enterprise Edge Security / Enterprise Networking capability.
- Updated Environment Specification, Enterprise Lab Network HLD, Phase 1 build/validation/acceptance documents, Technology Selection Matrix, roadmap, backlog, document index, release assignment register, MASTER_PLAN, and MkDocs navigation for MikroTik CHR.
- Marked OPNsense Phase 1 LLD/implementation and foundation edge firewall material as superseded/historical alternative references.

- Enhanced Windows Server 2025 Baseline, Proxmox HQ Foundation Implementation, MikroTik CHR HQ Foundation Implementation, Active Directory Implementation, and DNS/DHCP Implementation with educational enterprise context, internal workflows, GEIL design decisions, alternatives, security/performance/scalability/operational considerations, FAQs, and key takeaways.
- Updated Implementation Guide Standard to reference the Educational Documentation Standard and document `enterprise` / `implementation` admonition usage.
- Updated navigation, document index, roadmap, backlog, and release assignment register for the educational documentation methodology.

- Refactored existing implementation guides for Proxmox, MikroTik CHR, Active Directory, and DNS/DHCP with learning objectives, architecture overview, background knowledge, expected results, validation, rollback, evidence collection, knowledge checks, and next-guide links.
- Updated document index, roadmap, backlog, release assignment register, and MkDocs navigation for the Implementation Guide Standard.

- Expanded Phase 1 HQ foundation implementation documents with operator-grade deployment detail, copy/paste blocks, validation evidence, rollback commands, common errors, and acceptance criteria.
- Added deployment operator notes for the discovered Proxmox state: `eno1` direct use, protected `VSW4001`/`PROD`/`TEST` objects, GEIL `172.20.0.0/16`, `GEILWAN` `172.31.255.1/30`, and `HQ-FW01` WAN `172.31.255.2/30`.

- Updated complex HLD/LLD pages to include readable visual asset sections, alt text, architecture explanations, adaptation notes, and simplified Mermaid retention where useful.
- Expanded the Visual Documentation Standard with naming convention, readability requirements, minimum font-size guidance, maximum text-per-node guidance, and alt text requirements.
- Updated backlog, roadmap, and release architecture to reflect completion of the priority visual asset migration pass.

- Added release `E02.R05 HQ Foundation Evidence and Acceptance Package` to roadmap, backlog, document index, and release assignment register.
- Updated MASTER_PLAN and MkDocs navigation with the Phase 1 acceptance gate before Microsoft identity services.

- Added release `E02.R04 HQ Foundation Implementation Runbook` to roadmap, backlog, document index, and release assignment register.
- Updated MASTER_PLAN and MkDocs navigation with HQ foundation implementation runbooks.

- Updated the Documentation Standard to limit Mermaid to simple diagrams, workflows, and dependency graphs.
- Updated backlog, roadmap, document index, navigation, and release assignments for the visual documentation standard.

- Added release `E02.R03 HQ Foundation Low-Level Design and Build Plan` to roadmap, backlog, document index, and release assignment register.
- Updated MASTER_PLAN with Phase 1 LLD reference requirements.
- Updated MkDocs navigation with Phase 1 HQ foundation LLD and validation documents.

- Added release `E02.R02 Enterprise Lab Blueprint` to roadmap, backlog, document index, and release assignment register.
- Updated MASTER_PLAN with Phase 1 HLD reference requirements.
- Updated MkDocs navigation with Enterprise Lab Blueprint HLD documents.

- Updated roadmap, backlog, document index, project charter, navigation, and release assignments for the Enterprise Architecture Vision release.
- Established release `E01.R02` as the strategic enterprise architecture foundation before additional Microsoft implementation work.

- Replaced the technology-first roadmap with a capability-first Epic/Release roadmap.
- Updated backlog items with Epic and Release ownership.
- Updated the project charter and document index to require release assignment for every published document.
- Updated MkDocs navigation to include the Epic and Release Architecture page.
- Replaced generic known-value placeholders with canonical GNTECH values across existing implementation documentation.
- Updated MkDocs site URL and repository metadata to use `docs.gntechlabs.me` and `gntech-dev/geil-enterprise-docs`.
- Updated network examples from the previous generic `10.10.0.0/16` style ranges to the canonical `172.20.0.0/16` GNTECH baseline.
- Added adaptation notes to documents that now explicitly use canonical GNTECH values.
- Updated project charter, document index, backlog, roadmap, and navigation for the canonical environment specification.

### Added

- Added Security section for cross-platform security architecture and controls.
- Added `GEIL-SEC-PAM-001` Privileged Access Model.
- Added Tier 0, Tier 1, and Tier 2 privileged access architecture diagram.
- Added privileged access request workflow sequence diagram.
- Added implementation-ready PowerShell for administrative OU, group, user, and membership setup.
- Added emergency access, administrative workstation, service account, monitoring, access review, rollback, and containment guidance.
- Added Project section with charter, document index, documentation backlog, and documentation roadmap.
- Added Platform section for documentation delivery platform operations.
- Added `GEIL-PLT-CFPAGES-001` Cloudflare Pages Deployment Runbook.
- Added Cloudflare Pages architecture and deployment workflow Mermaid diagrams.
- Added production deployment, validation, rollback, troubleshooting, and security procedures for private GEIL publication.

### Changed

- Updated `mkdocs.yml` navigation to include the Security section and Privileged Access Model.
- Marked backlog item `DOC-002` as Done in the authoritative documentation backlog.
- Updated roadmap Phase 2 and Phase 3 to show privileged access and tiered administration as Done.
- Updated document index with Security documents.
- Added follow-up backlog items for privileged access request, emergency access, PAW build, and service account lifecycle runbooks.
- Updated `mkdocs.yml` navigation to include Project and Platform sections.
- Marked backlog item `DOC-001` as Done in the authoritative documentation backlog.
- Updated roadmap Phase 1 to show Cloudflare Pages deployment procedure as Done.
- Repointed legacy Governance backlog and roadmap pages to the authoritative Project documents.

### Required follow-up

- Create `DOC-003` certificate lifecycle runbook as the next highest-priority document.
- Add a privileged access request and approval runbook.
- Add an emergency access account test and recovery runbook.
- Add a Privileged Access Workstation build runbook.
- Add a service account lifecycle and gMSA runbook.
- Add a future Cloudflare Access policy administration runbook.
- Add a future GitHub branch protection and repository security baseline runbook.
