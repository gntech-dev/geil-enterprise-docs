---
title: GEIL Project Charter
document_id: GEIL-PRJ-CHARTER-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# GEIL Project Charter

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-PRJ-CHARTER-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

The GEIL project creates private internal engineering documentation for designing, implementing, operating, securing, monitoring, troubleshooting, and scaling GNTECH enterprise infrastructure.

GEIL is not a public blog, homelab notebook, or tutorial collection. GEIL is the authoritative implementation library for production-style Microsoft enterprise infrastructure.

## Mission

Create implementation-ready documentation that allows GNTECH Infrastructure Engineering to deploy and operate a secure Microsoft-centered enterprise platform from a 15-user SMB environment through multi-site and multinational scale.

## Primary stack

| Area | Standard Technology |
|---|---|
| Documentation platform | MkDocs Material |
| Source control | GitHub private repository |
| Static hosting | Cloudflare Pages protected by Cloudflare Access |
| Virtualization | Proxmox VE |
| Edge firewall | OPNsense |
| Server operating system | Windows Server 2025 |
| Endpoint operating system | Windows 11 Enterprise |
| Directory services | Active Directory Domain Services |
| Name/address services | DNS and DHCP |
| Policy | Group Policy and Intune |
| PKI | AD CS |
| Network authentication | NPS, RADIUS, and 802.1X |
| Cloud identity | Microsoft Entra ID |
| SaaS productivity | Microsoft 365 |
| Endpoint management | Microsoft Intune |
| Passwordless authentication | Windows Hello for Business |
| Endpoint protection | Microsoft Defender |
| Operations automation | PowerShell |

## Non-negotiable documentation rules

1. Documentation first, infrastructure second.
2. No placeholder-only pages.
3. Every production document must be implementation-ready.
4. Every production document must include Document Control.
5. Unknown real values must use explicit placeholders such as `<TENANT_NAME>`, `<PUBLIC_IP>`, `<ADMIN_USER>`, and `<AD_DOMAIN_FQDN>`.
6. PowerShell examples must include explanation, expected result, validation, and rollback where practical.
7. Microsoft best practices are the default; deviations require an ADR recommendation or approved ADR.
8. Related index, backlog, roadmap, navigation, and changelog files must be updated in the same change set.
9. Secrets, private keys, exported certificates, tenant IDs, real IP inventories, recovery codes, and passwords must never be committed.

## Definition of done

A GEIL documentation change is complete only when:

- The document is linked from `mkdocs.yml`.
- The document is listed in `docs/project/document-index.md`.
- The documentation backlog is updated.
- The documentation roadmap is updated if the work changes phase progress.
- `CHANGELOG.md` records the change.
- Required ADRs, runbooks, diagrams, and cross-references are identified.
- `mkdocs build --strict` succeeds.

## Roles

| Role | Responsibility |
|---|---|
| Documentation Architect | Structure, consistency, navigation, roadmap, backlog, and quality gate |
| Infrastructure Engineering | Technical authorship, validation, and operational ownership |
| Security Reviewer | Secret scanning, unsafe defaults review, identity and access review |
| Change Approver | Production applicability and rollout approval |

## Out of scope

- Publishing secrets or customer-specific sensitive data.
- Replacing vendor documentation where GEIL can link to a vendor source and add internal implementation requirements.
- Unapproved production changes outside the documented change process.

## Related documents

- [Documentation Standard](../governance/documentation-standard.md)
- [Documentation Backlog](documentation-backlog.md)
- [Documentation Roadmap](documentation-roadmap.md)
- [Document Index](document-index.md)
