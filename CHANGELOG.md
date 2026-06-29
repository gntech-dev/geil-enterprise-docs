# Changelog

All notable changes to GEIL are documented in this file.

## 2026-06-29

### Added


- Added `GEIL-PRJ-ERA-001` Epic and Release Architecture.
- Added capability-first Epic, Release, and Document hierarchy for scaling GEIL beyond 1,000 pages.
- Added capability dependency graph, release dependency graph, and document dependency graph.
- Added a release assignment register requiring every document to belong to exactly one Release.
- Added `GEIL-PRJ-ENV-001` Environment Specification as the canonical source of truth for the real GNTECH implementation.
- Added canonical GNTECH values for `gntech.me`, `corp.gntech.me`, `CORP`, `docs.gntechlabs.me`, `geil-enterprise-docs`, HQ infrastructure names, VLANs, IP ranges, DNS naming, certificate naming, share naming, and repository URLs.

### Changed


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
