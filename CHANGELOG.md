# Changelog
## 2026-07-01 - Pilot Deployment 001 Group Policy Foundation validation

- Validated the initial Group Policy foundation on `HQ-DC01`.
- Confirmed the domain initially contained only `Default Domain Policy` and `Default Domain Controllers Policy`.
- Confirmed `OU=GNTECH` and child computer OUs had no GEIL GPO links before pilot linking.
- Validated `dcdiag /test:sysvolcheck`, `dcdiag /test:netlogons`, and `gpupdate /force`.
- Added Central Store creation guidance for `\\corp.gntech.me\SYSVOL\corp.gntech.me\Policies\PolicyDefinitions`.
- Replaced old `GEIL-*` GPO names with the pilot-validated `GP - ...` naming convention.
- Documented creation of pilot GPO shells and the validated link from `GP - Baseline - Workstations` to the Workstations OU.
- Documented PowerShell Script Block Logging validation through `Get-GPRegistryValue`.
- Reinforced copy/paste-safe PowerShell patterns without fragile regex or fragmented `if/else` examples.
- Refined the Windows 11 Management Workstation guide to match the validated `HQ-MGMT01` pilot lifecycle: clone, Cloudbase-Init first boot, DHCP/DNS/AD connectivity validation, domain join/reboot, Management Workstations OU placement, Group Policy validation, RSAT/admin tooling, final validation, pilot findings, and roadmap-oriented next steps.
- Added and documented `GP - Baseline - Management Workstations`, linked to `OU=Management Workstations,OU=Computers,OU=GNTECH`, with initial validated settings for Remote Desktop, Network Level Authentication, and PowerShell Script Block Logging; reinforced that RDP is restricted by firewall/network policy and `HQ-MGMT01` must not remain in `OU=Workstations`.
- Added Microsoft Core Authentication Standards and documented the validated RDP identity format `GNTECH\\admin.gnolasco` for Microsoft Remote Desktop, Cloudflare Browser Rendering / IronRDP, and future RDP examples; retained `username@gntech.me` for Microsoft 365, Entra ID, and cloud applications.
- Promoted Enterprise WinRM Management to a Microsoft Core administration component, documenting validated Kerberos-based PowerShell Remoting from `HQ-MGMT01` to `HQ-W11-001`, the corrected `IPv4Filter = *` listener model, Windows/MikroTik firewall controls, VLAN segmentation, and WinRM validation commands.
- Added the Network and Active Directory Services Matrix as the canonical GNTECH reference for VLANs, subnets, host names, AD service ports, Windows management ports, and inter-VLAN firewall expectations; aligned WinRM and MikroTik Windows management firewall guidance to use it as source of truth.
- Added the Windows Infrastructure Lab Deployment roadmap for Enterprise WinRM Management, Windows Firewall Baseline, Windows LAPS, Microsoft Defender Baseline, Windows Event Forwarding, and Enterprise Identity / Privileged Access Tier 0/1/2, including implementation order, dependencies, release grouping, and validation checkpoints.
- Added the Windows Firewall Baseline as the first Host Firewall and Local Admin Protection deliverable, defining Windows Defender Firewall profile defaults, role expectations, RDP/WinRM Management VLAN scoping, GPO guidance, validation commands, troubleshooting, and future role-specific baseline split points.
- Added the Microsoft Defender Enterprise Baseline for built-in Microsoft Defender Antivirus managed by Active Directory Group Policy, including GPO creation, recommended client settings, validation, operations, troubleshooting, and Windows client lifecycle integration.
- Added the Pilot Validated documentation model to the Deployment Style Guide so future implemented Microsoft Core EPICs use the standard structure: Purpose, Architecture, Prerequisites, Deployment Workflow, PowerShell Automation, GUI/GPMC Implementation, Validation Workflow, Pilot Findings, Operations, Troubleshooting, and Acceptance Criteria.
- Added the Enterprise Implementation Roadmap as the high-level authoritative phase navigation document for GEIL implementation and defined the Microsoft Core document status model from Draft through Production Ready.
- Added the Windows Event Forwarding pilot architecture using dedicated collector `HQ-WEC01`, source-initiated subscriptions, `GP - Security - Windows Event Forwarding`, and initial pilot sources `HQ-W11-001` and `HQ-MGMT01`.
- Validated Windows Event Forwarding with `HQ-WEC01` (`172.20.20.21`), source-initiated subscription `GEIL-Workstation-Baseline`, sources `HQ-W11-001` and `HQ-MGMT01`, Event ID `111`, and MikroTik inter-VLAN forwarding for TCP `5985`.
- Added [HQ-FW01 Firewall Policy](docs/network/mikrotik/hq-fw01-firewall-policy.md) as the authoritative operational source of truth for validated MikroTik inter-VLAN firewall rules.
- Validated the Microsoft Defender Enterprise Baseline on `HQ-W11-001`, confirming `GP - Security - Microsoft Defender`, Defender health, PUA Protection, MAPS reporting, Safe Samples submission, Network Protection audit mode, signature updates, and Tamper Protection observed enabled.
- Added the Windows LAPS Baseline for built-in Windows LAPS, covering AD schema extension, OU Self permissions, `GP - Security - Windows LAPS`, password retrieval and rotation from `HQ-MGMT01`, validation, operations, troubleshooting, and client lifecycle integration.
- Added the permanent command execution context standard: operator-facing command blocks now identify where they run, when to execute them, and the expected outcome; Microsoft Core, Platform, and Security implementation guides were annotated with explicit execution contexts such as `HQ-MGMT01`, `HQ-DC01`, `PVE-HQ01`, and `HQ-FW01`.

All notable changes to GEIL are documented in this file.

## 2026-06-29

### Added

- Added `GEIL-PRJ-PROD-AUDIT-001` Production Readiness Audit Report, recording the implementation-phase repository-wide engineering audit, code-block counts, corrected defects, confidence gate, and remaining field-validation recommendations.
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

- Reorganized Microsoft Core navigation into explicit phases: Identity Foundation, Core Infrastructure Services, Windows Client Lifecycle, Administration, File Services Future, and Future Identity Expansion; removed loose Group Strategy/User Lifecycle/Service Account deployment-step entries by moving them under Security identity/access references.
- Moved Windows 11 client lifecycle implementation guides into Microsoft Core Phase 3 under `docs/microsoft-core/windows-client-lifecycle/`, added a clear Windows Client Lifecycle entry point, and updated navigation/control-plane references for golden template, Cloudbase-Init, `HQ-MGMT01`, domain join/GPO validation, and `HQ-W11-001`.
- Moved `HQ-MGMT01` to the Management VLAN 10 architecture and the new `OU=Management Workstations,OU=Computers,OU=GNTECH` placement; clarified that `HQ-W11-001` and future user workstations remain on VLAN 30, and prepared future `GP - Baseline - Management Workstations` architecture without implementing unvalidated settings.
- Completed the GEIL documentation architecture review: added a repository-wide classification report, permanent single-source-of-truth rules, Future and Archive sections, and reorganized MkDocs navigation around Foundation, Platform, Microsoft Core, Security, Architecture, Operations, Project, Future, and Archive.
- Added baseline Active Directory group-membership assignment to the Organizational Foundation guide: `admin.gnolasco -> GG-T0-Domain-Admins`, `gnolasco -> GG-IT-Operations`, optional VPN/WiFi memberships, and pilot/bootstrap-only `GG-T0-Domain-Admins -> Domain Admins` nesting without direct user membership in `Domain Admins`.
- Corrected HQ-MGMT01 architecture: documented `HQ-MGMT01` as a Windows 11 Enterprise management workstation / initial PAW, separated it from `HQ-W11-001` standard client validation, added RSAT/admin-tool deployment from the golden template after VLAN30/DHCP/DNS/DC validation and domain join, and clarified that Windows Server must not be used as a daily admin workstation.
- Separated Windows 11 golden-template documentation from domain-join/GPO validation: the template guide is now workgroup-only with Cloudbase-Init/Sysprep/template conversion, and a new clone-stage Windows 11 Domain Join and GPO Validation guide covers VLAN30, DHCP, DNS, AD firewall validation, `corp.gntech.me` join, Workstations OU placement, `gpupdate`, `gpresult`, SYSVOL/NETLOGON, and `GP - Baseline - Workstations`.
- Established the shared address-list based Active Directory network architecture: created Active Directory Network Requirements, refactored MikroTik/firewall/validation/Windows/AD/GPO references to use the standard, and replaced per-VLAN/per-host domain-controller firewall guidance with reusable RouterOS address lists.
- Incorporated validated pilot finding that DHCP relay alone is not sufficient for Active Directory deployments: added least-privilege VLAN30-to-HQ-DC01 domain-controller service firewall rules, temporary-vs-production rule guidance, DNS/domain-join validation, and deployment checklist updates.
- Incorporated real Active Directory Organizational Foundation deployment validation: OU hierarchy, sample users, and security groups were successfully created; exact user/service-account validation now uses per-account LDAP-filter loops instead of invalid PowerShell-style `-in` filtering, and the optional default-container review step was de-duplicated/clarified.
- Reviewed and documented Active Directory Organizational Foundation OU script production-readiness limitations for domain-controller versus RSAT execution, Domain Admins/Enterprise Admins permission checks, future delegated OU creation, DN validation limits, future `SupportsShouldProcess`/`-WhatIf`, and helper-function reuse.
- Refactored group, user, service account, GPO, DNS, and DHCP PowerShell examples toward the canonical GEIL Enterprise PowerShell object-creation pattern with module/context/permission checks, parent or container validation, safe existence checks, structured output, summary status, clear failures, verbose-capable script structure, and idempotent behavior where practical.
- Refactored the Active Directory Organizational Foundation OU deployment script into the canonical GEIL Enterprise PowerShell object-creation pattern with module/domain/permission checks, parent-DN validation, helper functions, verbose logging, structured output, summary counts, failure aggregation, and non-zero termination on failures.
- Updated PowerShell Operations to require the canonical GEIL Enterprise PowerShell object-creation pattern for future AD automation covering OUs, groups, users, service accounts, computers, GPOs, DNS objects, DHCP objects, and related object creation scripts.
- Completed repository-wide production readiness audit across `docs/`, `MASTER_PLAN.md`, and `CHANGELOG.md`; corrected high-confidence AD PowerShell dependency/idempotency defects in group strategy, user lifecycle, service account, administrative tiering, and privileged access examples.
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

- Reorganized Microsoft Core navigation into explicit phases: Identity Foundation, Core Infrastructure Services, Windows Client Lifecycle, Administration, File Services Future, and Future Identity Expansion; removed loose Group Strategy/User Lifecycle/Service Account deployment-step entries by moving them under Security identity/access references.
- Moved Windows 11 client lifecycle implementation guides into Microsoft Core Phase 3 under `docs/microsoft-core/windows-client-lifecycle/`, added a clear Windows Client Lifecycle entry point, and updated navigation/control-plane references for golden template, Cloudbase-Init, `HQ-MGMT01`, domain join/GPO validation, and `HQ-W11-001`.
- Moved `HQ-MGMT01` to the Management VLAN 10 architecture and the new `OU=Management Workstations,OU=Computers,OU=GNTECH` placement; clarified that `HQ-W11-001` and future user workstations remain on VLAN 30, and prepared future `GP - Baseline - Management Workstations` architecture without implementing unvalidated settings.
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

## 2026-07-01 - Pilot deployment code-block quality corrections

- Added `docs/governance/code-block-quality-standard.md`.
- Added `tools/audit-doc-codeblocks.sh` and `tools/audit-doc-codeblocks.ps1`.
- Replaced fragile PowerShell permission regex patterns with short-name group validation.
- Replaced DNS/DHCP secure dynamic update and DNS forwarder blocks with pilot-validated copy/paste-safe versions.
- Updated DHCP authorization and VLAN 30 scope blocks to avoid fragile regex and fragmented `if`/`else` patterns.
- Corrected privileged-access validation that used unsafe AD existence/filter patterns.
- Updated the Production Readiness Audit Report with pilot deployment findings.

## 2026-07-01 - Pilot DHCP relay correction

- Updated MikroTik CHR DHCP relay guidance based on pilot deployment validation.
- Documented that RouterOS DHCP relay requires `chain=input` firewall allowances because the relay process is local to `HQ-FW01`.
- Corrected DNS/DHCP Step 6 to remove duplicate `relay-vlan30`, use `local-address=172.20.30.1`, keep VLAN 40/60 relay disabled until scopes exist, and never relay VLAN 70 Guest WiFi to AD DHCP.
- Updated MikroTik CHR implementation and LLD guidance to place DHCP relay rules before `Default deny unapproved traffic to router`.
- Added Linux client validation with `dhclient`, route, resolver, and Windows DHCP lease verification commands.