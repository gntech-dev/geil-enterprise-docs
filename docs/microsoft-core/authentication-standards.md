---
title: Authentication Standards
document_id: GEIL-MSC-AUTHSTD-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# Authentication Standards

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-AUTHSTD-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Define the canonical identity formats used across GEIL Microsoft Core, Windows administration, Remote Desktop, PowerShell Remoting, Microsoft 365, Entra ID, and cloud applications.

This document removes ambiguity between the internal Active Directory namespace `corp.gntech.me`, the NetBIOS domain `GNTECH`, and the primary user UPN suffix `gntech.me`.

## Authentication format summary

| Scenario | Required or recommended format | Example | Rationale |
|---|---|---|---|
| Interactive Windows sign-in | `GNTECH\username` | `GNTECH\admin.gnolasco` | NetBIOS format is consistently accepted by Windows logon UI and avoids ambiguity between AD DNS namespace and UPN suffix. |
| Remote Desktop | `GNTECH\username` | `GNTECH\admin.gnolasco` | Validated with Microsoft Remote Desktop and Cloudflare Browser Rendering / IronRDP. Use this format unless a specific RDP client has been separately validated for UPN sign-in. |
| PowerShell Remoting | `GNTECH\username`; UPN supported where applicable | `GNTECH\admin.gnolasco` | NetBIOS format is the baseline for Windows remoting examples. UPN may work with some flows, but examples should state the required format explicitly. |
| Microsoft 365 / Entra ID | `username@gntech.me` | `admin.gnolasco@gntech.me` | Cloud sign-in uses the verified primary domain and aligns with Entra ID / Microsoft 365 identity expectations. |
| Cloud applications | `username@gntech.me` | `gnolasco@gntech.me` | SaaS and cloud applications should use the public, routable primary sign-in namespace. |
| AD DS object creation | `SamAccountName` plus UPN `username@gntech.me` | `admin.gnolasco`, `admin.gnolasco@gntech.me` | AD objects retain a SAM account for legacy/domain logon and a UPN for cloud-aligned identity. |

## Remote Desktop authentication standard

When authenticating to Windows systems using Microsoft Remote Desktop, Cloudflare Browser Rendering / IronRDP, or future documented RDP examples, use the NetBIOS domain format:

```text
GNTECH\username
```

Example:

```text
GNTECH\admin.gnolasco
```

Do not use the UPN format for RDP examples unless that specific client has been explicitly validated:

```text
admin.gnolasco@gntech.me
```

## Credential documentation rule

Whenever GEIL documentation shows credentials, it must explicitly document the required identity format.

Use examples such as:

```text
Run as: GNTECH\admin.gnolasco
```

```text
Sign in using: GNTECH\admin.gnolasco
```

```text
Cloud sign-in: admin.gnolasco@gntech.me
```

Do not show only `admin.gnolasco` without stating the domain or sign-in format.

## Pilot findings

Windows Management Workstation pilot validation established the following authentication findings:

- Microsoft Remote Desktop accepted the NetBIOS domain format `GNTECH\admin.gnolasco`.
- Cloudflare Browser Rendering / IronRDP accepted the NetBIOS domain format `GNTECH\admin.gnolasco`.
- UPN authentication such as `admin.gnolasco@gntech.me` must not be used in RDP examples unless the specific client has been validated for that format.
- Documentation must state the identity format next to credential examples so operators do not guess between SAM, NetBIOS, UPN, and cloud identity formats.

## Related standards

- [Environment Specification](../project/environment-specification.md)
- [Active Directory Organizational Foundation](active-directory-organizational-foundation.md)
- [Windows 11 Management Workstation](windows-client-lifecycle/windows-11-management-workstation.md)
- [Windows 11 Domain Join and GPO Validation](windows-client-lifecycle/windows-11-domain-join-gpo-validation.md)
