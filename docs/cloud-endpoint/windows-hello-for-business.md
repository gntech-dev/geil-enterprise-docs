---
title: Windows Hello for Business
document_id: GEIL-CLD-WHFB-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Windows Hello for Business

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-CLD-WHFB-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Implement phishing-resistant Windows sign-in using Windows Hello for Business.

## Recommended model

Use cloud Kerberos trust for hybrid environments unless a documented constraint requires key trust or certificate trust.

## Prerequisites

- Entra ID hybrid identity operational.
- Intune device management operational.
- Domain controllers patched to support cloud Kerberos trust requirements.
- Users protected by MFA before WHfB provisioning.

## Validation PowerShell

```powershell
dsregcmd /status
certutil -store My
klist cloud_debug
```

Expected result: device registration is healthy and WHfB sign-in obtains access to on-premises resources.

## Rollback

Disable WHfB assignment for pilot group in Intune. Users can continue password sign-in unless passwordless-only policy has been separately enforced.
