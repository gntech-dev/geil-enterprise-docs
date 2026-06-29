---
title: Technology Selection Matrix
document_id: GEIL-ARCH-TECH-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Technology Selection Matrix

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-ARCH-TECH-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

The Technology Selection Matrix documents why GEIL currently uses specific technologies to implement enterprise capabilities. The matrix does not make technologies permanent. It makes selection rationale explicit and defines replacement strategies.

Technologies are implementations. Capabilities are permanent.

## Selection criteria

| Criterion | Meaning |
|---|---|
| Capability fit | How well the technology supports the required enterprise capability. |
| Security | Ability to support secure configuration, identity integration, logging, and least privilege. |
| Operability | Ease of monitoring, troubleshooting, backup, recovery, and lifecycle management. |
| Cost | Licensing, support, hardware, training, and operational cost. |
| Scalability | Ability to grow from HQ to regional and multinational patterns. |
| Replaceability | Ability to migrate away without invalidating the capability architecture. |

## Technology matrix

| Technology | Capability Implemented | Business Justification | Alternatives Considered | Pros | Cons | Future Replacement Strategy |
|---|---|---|---|---|---|---|
| Proxmox VE | Enterprise Compute | Provides cost-effective virtualization for GNTECH infrastructure workloads at HQ. | VMware vSphere, Hyper-V, Azure Stack HCI, bare metal. | Cost-effective, flexible, supports clustering and VM lifecycle, strong fit for initial scale. | Smaller enterprise ecosystem than VMware, requires disciplined operational standards. | Abstract compute capability; document VM requirements, backup, network, and recovery so workloads can migrate to VMware, Hyper-V, or cloud infrastructure. |
| OPNsense | Enterprise Networking | Provides firewall, routing, VPN, and segmentation for HQ. | pfSense, Fortinet, Palo Alto, Cisco, cloud SASE. | Flexible, transparent, cost-effective, suitable for VLAN segmentation. | Requires careful configuration governance; support model differs from large commercial firewalls. | Preserve network architecture as policy requirements; firewall rules, zones, and flows can be reimplemented on enterprise firewall or SASE platforms. |
| Windows Server 2025 | Enterprise Identity and Server Platform | Provides AD DS, DNS, DHCP, GPO, PKI, NPS, and Windows infrastructure services. | Windows Server 2022, Samba AD, cloud-only identity, Linux DNS/DHCP. | Native Microsoft enterprise integration, mature AD capabilities, broad admin skill availability. | Licensing, patching, and legacy protocol exposure require discipline. | Separate identity/service capability requirements from host OS; migrate roles to newer Windows Server or cloud-native services when justified. |
| Windows 11 Enterprise | Enterprise Endpoint Management | Provides managed endpoint platform for GNTECH users and administrators. | Windows 11 Pro, macOS, Linux desktops, virtual desktops. | Enterprise security controls, Intune integration, Defender, BitLocker, WHfB. | Licensing and hardware requirements; endpoint drift without management. | Maintain endpoint capability requirements; support alternate endpoint platforms through equivalent management and security baselines. |
| Microsoft 365 | Enterprise Messaging and Collaboration | Provides email, collaboration, identity integration, productivity, and retention capabilities. | Google Workspace, self-hosted Exchange, Nextcloud, mixed SaaS. | Mature enterprise services, Entra integration, security and compliance ecosystem. | Licensing complexity and tenant dependency. | Treat messaging/collaboration as capabilities; document data ownership, identity, retention, and export paths to enable future SaaS transition if required. |
| Microsoft Entra ID | Enterprise Cloud Identity | Provides cloud identity, authentication, SSO, device registration, and Conditional Access. | Okta, Ping, Google Cloud Identity, AD-only. | Deep Microsoft 365 and Intune integration, strong Conditional Access ecosystem. | Tenant lock-in and licensing considerations. | Keep identity architecture provider-neutral at capability level; preserve federation, lifecycle, and authorization requirements for future IdP migration. |
| Microsoft Intune | Enterprise Endpoint Management | Provides cloud endpoint configuration, compliance, application deployment, and device lifecycle. | Group Policy only, MECM, Workspace ONE, Jamf, ManageEngine. | Strong Windows integration, Autopilot, compliance integration with Entra. | Policy complexity and cloud dependency. | Document endpoint state requirements; future tools must satisfy compliance, configuration, inventory, and remote action requirements. |
| Microsoft Defender | Enterprise Security | Provides endpoint protection, EDR foundation, and Microsoft security signal integration. | CrowdStrike, SentinelOne, Sophos, Huntress, ESET. | Native Windows integration, cloud telemetry, strong Microsoft ecosystem. | Licensing tiers and tuning complexity. | Preserve detection and response requirements; evaluate future EDR replacement against telemetry, response, and integration needs. |
| Cloudflare | Enterprise Edge and Documentation Protection | Provides DNS, Pages hosting, Access protection, and edge security controls for documentation publishing. | GitHub Pages, Azure Static Web Apps, Netlify, self-hosted reverse proxy. | Fast static hosting, DNS integration, Access controls, low operational overhead. | External dependency and Access policy complexity. | Keep publishing architecture static-site compatible; migrate to another static hosting and access-control platform if business requirements change. |
| MkDocs Material | Enterprise Documentation Platform | Provides navigable, searchable, versionable internal engineering documentation. | Docusaurus, Sphinx, GitBook, Backstage, SharePoint. | Markdown-first, Git-friendly, strong navigation, Mermaid support, static output. | Static site limitations and no native page-level authorization. | Preserve Markdown source and information architecture; migrate renderer if search, authorization, or portal integration requirements outgrow MkDocs. |

## Technology replacement principles

1. Replacements must preserve or improve the capability they implement.
2. Replacement decisions require an ADR.
3. Implementation documents must be updated after the capability architecture is reviewed.
4. Operational controls must be equivalent before production migration.
5. Rollback and coexistence requirements must be documented before replacement.

## Cross-references

- [Enterprise Capability Model](enterprise-capability-model.md)
- [Enterprise Reference Architecture](enterprise-reference-architecture.md)
- [Architecture Principles](architecture-principles.md)
- [Epic and Release Architecture](../project/epic-release-architecture.md)
