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

- AD CS issuing CA operational.
- Computer/user certificate templates published.
- Network switches and wireless controllers support RADIUS.
- NPS server certificate includes Server Authentication EKU.

## Install NPS

```powershell
Install-WindowsFeature NPAS -IncludeManagementTools
netsh nps add registeredserver
```

Expected result: NPS role is installed and registered in Active Directory.

## Add RADIUS clients

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

```powershell
Get-WinEvent -LogName Security -MaxEvents 20 | Where-Object {$_.Id -in 6272,6273}
```

Expected result: Event 6272 for allowed authentication or 6273 with clear denial reason.

## Rollback

Disable the switch port or SSID 802.1X enforcement and return to the previous access mode during the change window. Remove or disable the NPS policy if it causes unintended grants.
