---
title: Enterprise Implementation Roadmap
document_id: GEIL-PRJ-ENT-ROADMAP-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-07-08
review_cycle: Quarterly
classification: Internal Confidential
---

# Enterprise Implementation Roadmap

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-PRJ-ENT-ROADMAP-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-07-08 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This document is the high-level implementation roadmap for the GEIL Enterprise project. It gives implementers a single navigation view for the order in which enterprise infrastructure capabilities should be designed, implemented, validated, and operationalized.

This roadmap is governance documentation. It does not replace the detailed implementation guides, and it does not change existing Microsoft Core implementations. Detailed deployment steps remain in the authoritative capability documents linked from the [Documentation Roadmap](documentation-roadmap.md), [Epic and Release Architecture](epic-release-architecture.md), and Microsoft Core section indexes.

## How to use this roadmap

Use this roadmap to answer four questions before starting implementation work:

1. Which enterprise phase owns the capability?
2. What is the current implementation status?
3. Which prerequisite capabilities should already exist?
4. Which existing documents should be updated when the capability is implemented or pilot-validated?

When an implementation reaches pilot validation, update the existing authoritative document for that EPIC. Do not create duplicate implementation guides or refactor unrelated documentation.

Related governance documents:

- [Documentation Roadmap](documentation-roadmap.md)
- [Epic and Release Architecture](epic-release-architecture.md)
- [Deployment Style Guide](../governance/deployment-style-guide.md)

## Roadmap summary

| Phase | Name | Purpose | Status |
|---:|---|---|---|
| 1 | Enterprise Foundation | Establish a secure and manageable Windows enterprise foundation. | Pilot Validated / In Progress |
| 2 | Security Monitoring | Centralized auditing and security visibility. | Planned |
| 3 | Enterprise Hardening | Reduce attack surface. | Planned |
| 4 | Enterprise Operations | Operational management. | Planned |
| 5 | Enterprise Monitoring & Automation | Monitoring, observability, and automation. | Planned |

## Phase 1 - Enterprise Foundation

Purpose: establish a secure and manageable Windows enterprise foundation.

Status: Pilot Validated / In Progress.

Phase 1 provides the baseline identity, management, client, firewall, local administrator password, and endpoint protection controls required before broader enterprise services are added.

| Capability | Current status | Primary document or reference |
|---|---|---|
| Active Directory | Pilot Validated / In Progress | [Active Directory Implementation](../microsoft-core/active-directory-implementation.md) |
| DNS | Pilot Validated / In Progress | [DNS and DHCP Implementation](../microsoft-core/dns-dhcp-implementation.md) |
| DHCP | Pilot Validated / In Progress | [DNS and DHCP Implementation](../microsoft-core/dns-dhcp-implementation.md) |
| Organizational Units | Pilot Validated / In Progress | [Active Directory Organizational Foundation](../microsoft-core/active-directory-organizational-foundation.md) |
| Tier Model | Draft / In Progress | [Privileged Access Model](../security/privileged-access-model.md), [Enterprise Administrative Tiering](../security/administrative-tiering.md) |
| Group Policy Framework | Pilot Validated / In Progress | [Group Policy Baseline](../microsoft-core/group-policy-baseline.md) |
| `HQ-MGMT01` | Pilot Validated | [Windows Management Workstation - HQ-MGMT01](../microsoft-core/windows-client-lifecycle/windows-11-management-workstation.md) |
| `HQ-W11-001` | Pilot Validated | [Standard Windows Client - HQ-W11-001](../microsoft-core/windows-client-lifecycle/standard-windows-client-hq-w11-001.md) |
| Windows Firewall | Pilot Validated / In Progress | [Windows Firewall Baseline](../microsoft-core/windows-security/windows-firewall-baseline.md) |
| WinRM | Pilot Validated / In Progress | [Enterprise WinRM Management](../microsoft-core/administration/enterprise-winrm-management.md), [WinRM / PowerShell Remoting Baseline](../microsoft-core/windows-server-management/winrm-powershell-remoting-baseline.md) |
| Windows LAPS | Pilot Validated | [Windows LAPS Baseline](../microsoft-core/windows-security/windows-laps-baseline.md) |
| Microsoft Defender | Pilot Validated | [Microsoft Defender Enterprise Baseline](../microsoft-core/windows-security/microsoft-defender-baseline.md) |

Phase 1 acceptance intent:

- Domain services are functional.
- Standard and management workstation lifecycle is documented and validated.
- Administrative access is constrained to approved management paths.
- Local Administrator passwords are managed by Windows LAPS.
- Microsoft Defender Antivirus is active and policy-managed.
- Windows Firewall and MikroTik policy separate domain service access from administrative access.

## Phase 2 - Security Monitoring

Purpose: provide centralized auditing and security visibility.

Status: Planned.

Phase 2 builds on Phase 1 by collecting important security and operational events from domain controllers, workstations, and management systems.

| Capability | Target status | Notes |
|---|---|---|
| Windows Event Forwarding | Pilot In Progress | Source-initiated event forwarding to dedicated collector `HQ-WEC01`. |
| Windows Event Collector | Pilot In Progress | Dedicated collector `HQ-WEC01` on VLAN 20 Servers. |
| Advanced Audit Policy | Planned | Domain and workstation audit settings for meaningful event collection. |
| PowerShell Logging | Planned | Script block, module, and transcript logging where appropriate. |
| Security Event Collection | Planned | Security-relevant event IDs for authentication, privilege use, and policy change. |
| Sysmon | Future | Future endpoint telemetry option after native Windows logging is understood. |

Phase 2 should not begin broad deployment until Phase 1 management and security baseline behavior is stable.

## Phase 3 - Enterprise Hardening

Purpose: reduce attack surface.

Status: Planned.

Phase 3 introduces endpoint and protocol hardening after the core client lifecycle, firewall model, LAPS, Defender, and monitoring paths are understood.

| Capability | Target status | Notes |
|---|---|---|
| BitLocker | Planned | Disk encryption and recovery-key handling. |
| Credential Guard | Planned | Credential isolation for supported Windows clients. |
| LSA Protection | Planned | Local Security Authority hardening. |
| SMB Hardening | Planned | SMB signing, legacy protocol restrictions, and administrative share controls. |
| Attack Surface Reduction | Planned | Defender ASR evaluation after Defender baseline is stable. |
| AppLocker / WDAC | Planned | Application control after operational impact is understood. |

## Phase 4 - Enterprise Operations

Purpose: operational management.

Status: Planned.

Phase 4 adds day-2 operational services after the identity, client, security baseline, and monitoring foundations are in place.

| Capability | Target status | Notes |
|---|---|---|
| Windows Update | Planned | Patch management model for Microsoft Core systems. |
| WSUS or Windows Update for Business | Planned | Update control path selected according to lab maturity. |
| File Services | Planned | File server and access model implementation. |
| Print Services | Planned | Print services if business requirements justify them. |
| Time Service | Planned | Enterprise time synchronization review and operational checks. |
| DFS | Planned | Namespace design when file services require it. |
| DFS-R | Planned | Replication design after file services are validated. |

## Phase 5 - Enterprise Monitoring & Automation

Purpose: monitoring, observability, and automation.

Status: Planned.

Phase 5 expands operational visibility and repeatability after the core enterprise controls are stable.

| Capability | Target status | Notes |
|---|---|---|
| Prometheus | Planned | Infrastructure metrics collection. |
| Grafana | Planned | Dashboards and visualization. |
| Loki | Planned | Log aggregation where appropriate. |
| Alerting | Planned | Operational alert routing and threshold policy. |
| Windows Event integration | Planned | Integration with Phase 2 Windows event collection. |
| PowerShell Automation | Planned | Repeatable administrative workflows. |
| Desired State Configuration | Future | Future configuration compliance and drift management. |

## Microsoft Core document status model

The following lifecycle applies to Microsoft Core documents and other implementation documents that follow the Pilot Validated model.

| Status | Meaning | Use when |
|---|---|---|
| Draft | The document is usable for planning or early implementation but has not completed design review or pilot validation. | Content exists, but implementation details may still change. |
| Design Complete | The architecture and intended configuration are known, but the implementation has not started or has not reached pilot execution. | The document is ready to guide a pilot, but no lab validation evidence exists yet. |
| Pilot In Progress | The implementation is actively being executed in the lab. | Operators are deploying, testing, and correcting the guide. |
| Pilot Validated | The implementation completed successfully in the lab and the document reflects the validated deployment workflow, validation workflow, pilot findings, operations, troubleshooting, and acceptance criteria. | The EPIC passed lab validation on named systems such as `HQ-DC01`, `HQ-MGMT01`, or `HQ-W11-001`. |
| Production Ready | The pilot-validated implementation has sufficient operational controls, rollback guidance, evidence, and repeatability for production-style reuse. | The document is suitable for controlled production or production-equivalent deployment. |

Status rules:

- Do not mark future concepts as Pilot In Progress or Pilot Validated.
- Do not mark a document Pilot Validated until the actual lab implementation has completed.
- When a pilot changes the implementation approach, update the existing document and record the correction in Pilot Findings.
- Production Ready requires more than a successful pilot; it requires operational confidence, repeatability, and supportability.

## Governance rules

- This roadmap is authoritative for high-level phase navigation.
- The [Epic and Release Architecture](epic-release-architecture.md) remains authoritative for release assignment and published document ownership.
- The [Documentation Roadmap](documentation-roadmap.md) remains the detailed documentation execution roadmap.
- The [Deployment Style Guide](../governance/deployment-style-guide.md) defines the required Pilot Validated document structure for implemented EPICs.
- Do not update documents for EPICs that have not yet been implemented.
- Only migrate documents to the Pilot Validated structure when an EPIC is actively implemented or validated.
