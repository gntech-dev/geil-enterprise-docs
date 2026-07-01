---
title: AD CS PKI
document_id: GEIL-MSC-PKI-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# AD CS PKI

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-PKI-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Implement enterprise PKI for domain authentication, device certificates, 802.1X, TLS, and future enterprise trust services.

## Architecture

Use a two-tier PKI for production:

- Offline standalone root CA.
- Online enterprise issuing CA joined to the domain.

A single-tier enterprise CA requires an ADR and is acceptable only for constrained SMB bootstrap with a migration plan.

## Implementation outline

1. Build offline root CA VM, disconnected except during ceremonies.
2. Install standalone root CA.
3. Publish root certificate and CRL to documented locations.
4. Build issuing CA `HQ-DC01`.
5. Install enterprise subordinate CA.
6. Configure certificate templates.
7. Enable autoenrollment by GPO.

## Validation PowerShell

```powershell
certutil -config "HQ-DC01\GNTECH-Issuing-CA01" -ping
certutil -urlfetch -verify C:\Temp\issued-test.cer
Get-CertificationAuthority | Select Name,ComputerName
```

Expected result: CA responds, certificate chain validates, CRL locations are reachable.

## Rollback

If templates are wrong, supersede template versions instead of editing blindly. If issuing CA installation fails before issuing certificates, remove the CA role, clean AD objects only after backup, and reinstall.

## Security considerations

- Private keys must be export-protected unless documented for HSM or backup process.
- Root CA remains offline.
- CA admins are Tier 0.
- Monitor CA certificate and CRL expiry.


## Deployment Validation

Validate PKI only after AD DS and DNS health are proven.

```powershell
certutil -config "HQ-DC01\GNTECH-Issuing-CA01" -ping
```

Expected result:

```text
CertUtil: -ping command completed successfully.
```

If validation fails, STOP. Do not issue production certificates until CA reachability, templates, CRL, and AIA publication validate.

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
