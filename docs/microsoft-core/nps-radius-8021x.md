---
title: NPS RADIUS 802.1X
document_id: GEIL-MSC-NPS-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# NPS RADIUS 802.1X

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-NPS-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

!!! note "Adaptation"

    This document uses canonical GNTECH values from the [Environment Specification](../project/environment-specification.md). Organizations adapting this design should change the environment specification first, then update all affected DNS zones, certificates, PowerShell commands, Group Policies, VLANs, firewall rules, and service configurations.

## Purpose

Implement certificate-backed network authentication for wired and wireless access.

## Prerequisites

- [Enterprise Port Reference](../platform/enterprise-port-reference.md), [Firewall Rule Matrix](../platform/firewall-rule-matrix.md), [Enterprise Group Strategy](group-strategy.md), and [Enterprise Service Account Standard](service-account-standard.md) reviewed.


- AD CS issuing CA operational.
- Computer/user certificate templates published.
- Network switches and wireless controllers support RADIUS.
- NPS server certificate includes Server Authentication EKU.

## Install NPS

Run on: `HQ-MGMT01 unless this is an initial bootstrap step that explicitly requires HQ-DC01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Install-WindowsFeature NPAS -IncludeManagementTools
netsh nps add registeredserver
```

Expected result: NPS role is installed and registered in Active Directory.

## Add RADIUS clients

Run on: `HQ-FW01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
netsh nps add client name="HQ-FW01" address="172.20.10.1" sharedsecret="<PASSWORD>" vendor=RADIUS_Standard
```

Replace `<PASSWORD>` with the generated RADIUS shared secret for HQ-FW01. Store the value in the approved password manager, not in Git.

## Policy model

- Connection request policy: local NPS authentication.
- Network policy for domain computers with certificate authentication.
- Separate policy for user authentication only if business requirement exists.
- Guest access must never authenticate against AD.

## Validation

On NPS:

Run on: `HQ-FW01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Get-WinEvent -LogName Security -MaxEvents 20 | Where-Object {$_.Id -in 6272,6273}
```

Expected result: Event 6272 for allowed authentication or 6273 with clear denial reason.

## Rollback

Disable the switch port or SSID 802.1X enforcement and return to the previous access mode during the change window. Remove or disable the NPS policy if it causes unintended grants.


## Deployment Validation

Validate NPS only after AD DS, DNS, PKI, and firewall reachability are healthy.

Run on: `HQ-FW01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Get-WinEvent -LogName Security -MaxEvents 20 | Where-Object {$_.Id -in 6272,6273}
```

Expected result:

```text
6272 = access granted for approved test
6273 = access denied for rejected test
```

If neither event appears during testing, STOP. Check RADIUS client IP, shared secret, firewall rules, and certificate trust before continuing.

## Deployment Verified

| Field | Value |
|---|---|
| Validated on | Not yet field validated. Must pass this guide, the code-block audit, and clean-environment review before production execution. |
| Windows Server version | Not yet field validated |
| RouterOS version | Not applicable unless the guide explicitly configures RouterOS |
| Proxmox version | Not applicable unless the guide explicitly configures Proxmox |
| Deployment date | Not yet field validated |
| Deployment notes | Not yet field validated. Must pass this guide, the code-block audit, and clean-environment review before production execution. |
| Known caveats | Treat as documentation-ready but not field-proven until deployment evidence is captured. |
