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

Deploy or administer Windows Admin Center as a controlled management path for Windows infrastructure without turning Windows Server into a daily administrative workstation.

## Baseline

- `HQ-MGMT01` is a Windows 11 Enterprise management workstation / initial PAW, not a Windows Server.
- Do not use Windows Server as a daily admin workstation.
- Use `HQ-MGMT01` to administer Windows Admin Center and future Windows infrastructure.
- If Windows Admin Center is deployed as a gateway service, use an approved dedicated gateway host; do not redefine `HQ-MGMT01` as a server.
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
Test-NetConnection <WAC-GATEWAY-FQDN> -Port 443
Get-Service ServerManagementGateway
```

Expected result: the gateway service is running on the approved WAC host and is reachable only from approved management networks such as `HQ-MGMT01`.

## Rollback

Uninstall from Programs and Features or with MSI product code. Revoke the gateway certificate only if the private key was exposed.


## Deployment Validation

Validate Windows Admin Center only after DNS and firewall prerequisites exist.

```powershell
Test-NetConnection <WAC-GATEWAY-FQDN> -Port 443
```

Expected result:

```text
TcpTestSucceeded : True
```

If validation fails, STOP. Check DNS, Windows Firewall, certificate binding, and the Windows Admin Center service before continuing.

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
