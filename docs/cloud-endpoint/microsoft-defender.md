---
title: Microsoft Defender
document_id: GEIL-CLD-DEF-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Microsoft Defender

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-CLD-DEF-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Deploy Microsoft Defender controls for endpoint protection and security operations.

## Baseline

- Defender Antivirus real-time protection enabled.
- Cloud-delivered protection enabled.
- Tamper protection enabled.
- Attack surface reduction rules staged in audit mode before block mode.
- Endpoint detection and response onboarded where licensed.

## Validation PowerShell

```powershell
Get-MpComputerStatus | Select AMServiceEnabled,AntivirusEnabled,RealTimeProtectionEnabled,IsTamperProtected
Get-MpPreference | Select MAPSReporting,SubmitSamplesConsent
```

Expected result: Defender services are enabled and reporting policy matches baseline.

## Rollback

Move ASR rules from block to audit mode before disabling. If Defender onboarding causes business impact, isolate by device group and open a security exception with expiry.

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
