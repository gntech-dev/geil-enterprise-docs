---
title: Enterprise Port Reference
document_id: GEIL-PLAT-PORTS-001
owner: Infrastructure Engineering
status: Draft
version: 1.1
last_reviewed: 2026-06-30
review_cycle: Quarterly
classification: Internal Confidential
---

# Enterprise Port Reference

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-PLAT-PORTS-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.1 |
| Last Reviewed | 2026-06-30 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

!!! note "Canonical GNTECH values"

    Forest: `corp.gntech.me`; NetBIOS: `GNTECH`; primary UPN suffix: `gntech.me`; Microsoft 365 primary domain: `gntech.me`; hybrid identity plane: Microsoft Entra ID; primary firewall: MikroTik CHR `HQ-FW01`.


## Purpose

Document Microsoft Core and enterprise management ports required before firewall rules, host firewalls, monitoring, and troubleshooting workflows are finalized. Active Directory client-to-domain-controller firewall architecture is authoritative in [Active Directory Network Requirements](active-directory-network-requirements.md).

## Port table

| Service | Protocol | Ports | Direction | Purpose | Validation |
|---|---|---:|---|---|---|
| DNS | TCP/UDP | 53 | Clients to DC/DNS | Name resolution | `Resolve-DnsName corp.gntech.me` |
| DHCP | UDP | 67,68 | Clients/relay/server | Address assignment | `ipconfig /renew` |
| Kerberos | TCP/UDP | 88,464 | Clients to DC | Authentication/password change | Domain sign-in |
| LDAP | TCP/UDP | 389 | Clients to DC | Directory lookup | `nltest /dsgetdc:corp.gntech.me` |
| LDAPS | TCP | 636 | Clients to DC | Secure LDAP | `Test-NetConnection HQ-DC01 636` |
| Global Catalog | TCP | 3268,3269 | Clients to DC | Forest-wide lookup | AD query validates |
| SMB/SYSVOL/NETLOGON | TCP | 445 | Clients to DC/file | Domain join, GPO, file access | `Test-Path \corp.gntech.me\SYSVOL`; `Test-Path \corp.gntech.me\NETLOGON` |
| RPC endpoint mapper | TCP | 135 | Clients/admin to servers | RPC discovery | AD/GPO operations |
| RPC dynamic | TCP | 49152-65535 | Windows RPC | AD/GPO/management | Event logs/gpupdate |
| NTP | UDP | 123 | Clients to time source | Time sync | `w32tm /query /status` |
| WinRM HTTP/HTTPS | TCP | 5985,5986 | Admin to servers | PowerShell remoting | `Test-WSMan` |
| RDP | TCP/UDP | 3389 | Admin to servers | Remote admin | `Test-NetConnection` |
| NPS RADIUS | UDP | 1812,1813 | Network devices to NPS | Auth/accounting | NPS event logs |
| AD CS Web/CRL | TCP | 80,443 | Clients to CA/CDP | CRL/AIA/cert enrollment | `certutil -urlfetch -verify` |
| Entra Connect | TCP | 443 | Sync server to cloud | Identity sync | Entra Connect health |
| Monitoring | TCP/UDP | Tool-specific | Monitoring to targets | Telemetry | Alert test |
| MikroTik management | TCP | 8291,22,443 | Admin to `HQ-FW01` | RouterOS management | WinBox/SSH/HTTPS login |

## Why port references matter

Operators often troubleshoot symptoms at the wrong layer. This reference links each service to its required ports so firewall rules and Windows Defender Firewall can be validated intentionally.

## PowerShell validation bundle

Run on: `HQ-FW01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
$Targets = @("HQ-DC01.corp.gntech.me")
$Ports = 53,88,389,445,135,3268,3269
foreach ($Target in $Targets) {
    foreach ($Port in $Ports) {
        Test-NetConnection -ComputerName $Target -Port $Port | Select-Object ComputerName,RemotePort,TcpTestSucceeded
    }
}
```

## Stop conditions

STOP if required identity ports are blocked between domain clients and `HQ-DC01`. Do not continue to Group Policy, PKI, NPS, or Entra sync until AD DNS, Kerberos, LDAP, SMB, and RPC paths are validated.

## Rollback

If a firewall change breaks Microsoft Core, disable the last new rule first. Do not open Any/Any as a workaround; add the minimal required flow and validate.

## Evidence Collection

Capture port tests, RouterOS rule output, Windows Firewall rule output, and service-specific validation commands.

## Troubleshooting

| Symptom | Ports to check | Validation |
|---|---|---|
| GPO fails | 53,88,389,445,135,RPC | `gpupdate /force`, SYSVOL path. |
| Password change fails | 88,464 | Change test account password. |
| LDAPS fails | 636 | Check certificate and `Test-NetConnection`. |
| NPS auth fails | 1812,1813 | NPS logs and network-device shared secret. |

## Next Guide

Use this with [Firewall Rule Matrix](firewall-rule-matrix.md), [Active Directory Network Requirements](active-directory-network-requirements.md), and Microsoft Core implementation guides.
