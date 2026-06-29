---
title: Windows Admin Center
document_id: GEIL-MSC-WAC-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Windows Admin Center

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-WAC-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

!!! note "Adaptation"

    This document uses canonical GNTECH values from the [Environment Specification](../project/environment-specification.md). Organizations adapting this design should change the environment specification first, then update all affected DNS zones, certificates, PowerShell commands, Group Policies, VLANs, firewall rules, and service configurations.

## Purpose

Deploy Windows Admin Center as a controlled management gateway for Windows infrastructure.

## Baseline

- Install on dedicated server `HQ-MGMT01`.
- Require TLS certificate from enterprise PKI.
- Restrict access to admin workstations and VPN.
- Use role-based access where feasible.

## Implementation

Download the current Windows Admin Center MSI from Microsoft and install in gateway mode.

```powershell
msiexec /i WindowsAdminCenter.msi /qn /L*v C:\Temp\WACInstall.log SME_PORT=443 SSL_CERTIFICATE_OPTION=installed SME_THUMBPRINT=<CERTIFICATE_THUMBPRINT>
```

## Validation

```powershell
Test-NetConnection HQ-MGMT01.corp.gntech.me -Port 443
Get-Service ServerManagementGateway
```

Expected result: service is running and reachable only from approved management networks.

## Rollback

Uninstall from Programs and Features or with MSI product code. Revoke the gateway certificate only if the private key was exposed.
