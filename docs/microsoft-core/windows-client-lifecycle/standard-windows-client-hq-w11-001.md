---
title: Standard Windows Client - HQ-W11-001
document_id: GEIL-MSC-WCL-STANDARD-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# Standard Windows Client - HQ-W11-001

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-WCL-STANDARD-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Define the standard Windows 11 Enterprise client role represented by `HQ-W11-001`.

## Architecture

| Item | Value |
|---|---|
| Host | `HQ-W11-001` |
| Operating system | Windows 11 Enterprise |
| Network | VLAN 30 Workstations |
| Active Directory OU | `OU=Workstations,OU=Computers,OU=GNTECH,...` |
| Role | Standard user/client validation VM |
| GPO target | `GP - Baseline - Workstations` |

`HQ-W11-001` is not the management workstation. It must not contain privileged administration tooling or become an infrastructure management endpoint.

## Deployment source

The clone, VLAN30 validation, domain join, OU placement, `gpupdate`, `gpresult`, SYSVOL, NETLOGON, and workstation GPO validation procedure remains in:

[Windows Domain Join and GPO Validation](windows-11-domain-join-gpo-validation.md)

## Validation requirements

- VLAN 30 addressing succeeds.
- DNS points to `HQ-DC01` after DHCP is available.
- Required AD service ports are reachable.
- The computer object is in `OU=Workstations,OU=Computers,OU=GNTECH,...`.
- `GP - Baseline - Workstations` appears in `gpresult`.
- `GP - Security - Microsoft Defender` appears in applied computer policy after the Defender baseline is implemented.
- Microsoft Defender Baseline is applied before final workstation validation.
- `Get-MpComputerStatus` reports Microsoft Defender Antivirus and real-time protection enabled.

## Related documents

- [Windows 11 Enterprise Golden Template](windows-11-enterprise-golden-template.md)
- [Windows Domain Join and GPO Validation](windows-11-domain-join-gpo-validation.md)
- [Group Policy Baseline](../group-policy-baseline.md)
- [Microsoft Defender Enterprise Baseline](../windows-security/microsoft-defender-baseline.md)
