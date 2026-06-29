---
title: Intune Windows 11 Enterprise
document_id: GEIL-CLD-INTUNE-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Intune Windows 11 Enterprise

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-CLD-INTUNE-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Enroll and manage Windows 11 Enterprise endpoints with Microsoft Intune.

## Baseline policies

- Compliance policy requiring supported OS, BitLocker, Secure Boot, TPM, Defender healthy state.
- Configuration profiles for security baseline, firewall, update rings, OneDrive, and Edge.
- Endpoint security policies for antivirus, attack surface reduction, disk encryption, and account protection.
- Autopilot profile for corporate-owned devices.

## Validation PowerShell on client

```powershell
dsregcmd /status
Get-BitLockerVolume
Get-MpComputerStatus | Select AMServiceEnabled,AntivirusEnabled,RealTimeProtectionEnabled
```

Expected result: device is Entra joined or hybrid joined as designed, BitLocker protected, Defender healthy.

## Rollback

Remove device from assignment group or exclude from policy. For Autopilot issues, remove the hardware hash from Autopilot only after confirming ownership and reset plan.
