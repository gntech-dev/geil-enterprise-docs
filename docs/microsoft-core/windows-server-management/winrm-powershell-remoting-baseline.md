---
title: WinRM / PowerShell Remoting Baseline
document_id: GEIL-MSC-WSMGMT-WINRM-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-07-02
review_cycle: Quarterly
classification: Internal Confidential
---

# WinRM / PowerShell Remoting Baseline

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-WSMGMT-WINRM-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-07-02 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose and scope

This guide defines the practical WinRM / PowerShell Remoting baseline for the GNTECH Active Directory lab. Network names, VLANs, and allowed source subnets come from the [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md). It explains how domain-joined Windows systems are managed from the Management VLAN, how to validate the remoting path, and where firewall controls belong.

This document is intentionally practical. It does not redesign the validated deployment. It layers secure command-based administration on top of the existing Microsoft Core baseline.

Authoritative detailed architecture is also documented in [Enterprise WinRM Management](../administration/enterprise-winrm-management.md).

## Why WinRM is required

WinRM provides the Windows remote management transport used by PowerShell Remoting. It is required for repeatable, auditable, command-based administration from the management workstation without opening a full interactive desktop session.

Use the following model:

| Administration method | Use case | Notes |
|---|---|---|
| RDP | Interactive administration, GUI-only tasks, emergency troubleshooting | Keep available, but restrict with VLAN and firewall policy. |
| WinRM / PowerShell Remoting | Command-based administration, validation, automation, inventory, repeatable operations | Preferred for routine remote administration where possible. |

RDP remains available for interactive administration. WinRM is the baseline for remote administration and automation.

## Recommended ports

| Protocol | Port | Use |
|---|---:|---|
| WinRM HTTP | TCP `5985` | Recommended baseline inside trusted/internal AD domain networks. |
| WinRM HTTPS | TCP `5986` | Use when certificate-based encrypted transport is required, such as workgroup, cross-domain, or untrusted network scenarios. |

Inside a domain environment, Kerberos already protects authentication. WinRM HTTP on TCP `5985` does not mean credentials are sent in clear text when Kerberos is used.

WinRM HTTPS is not required for the current GNTECH lab baseline because domain Kerberos, Windows Firewall scoping, MikroTik firewall policy, and VLAN segmentation already define the validated control model. HTTPS can be introduced later when certificate lifecycle, cross-domain administration, or non-domain endpoints require it.

## Authentication and TrustedHosts

Use Kerberos for normal domain-joined management. Run commands against DNS names, not raw IP addresses, so Kerberos can resolve the service principal correctly.

Do not use `TrustedHosts` for normal domain-joined management. `TrustedHosts` is for specific non-domain, workgroup, or cross-boundary scenarios where Kerberos is not available and the risk has been explicitly accepted.

Identity format follows [Authentication Standards](../authentication-standards.md):

```text
GNTECH\admin.gnolasco
```

## Recommended source VLAN

Only the Management VLAN / management workstation subnet should initiate WinRM sessions to servers, domain controllers, and managed clients.

Current GNTECH value:

| Source | VLAN | CIDR |
|---|---:|---|
| Management workstations | VLAN 10 Management | `172.20.10.0/24` |

## Recommended destinations

WinRM can be enabled for:

- Domain Controllers, where justified for approved administration.
- Member servers.
- Administrative workstations where justified.
- Standard workstations only when explicitly required for management, validation, or automation.

Do not expose WinRM to HOME, IoT, CCTV, Guest, WAN, or untrusted VLANs.

## Security baseline

- Use dedicated administrative accounts.
- Avoid daily-driver user accounts for administration.
- Require Windows Defender Firewall scoping.
- Scope WinRM inbound access to the Management VLAN only.
- Keep PowerShell Script Block Logging enabled.
- Prefer Just Enough Administration later as the lab matures.
- Continue PAW / management workstation tiering as the environment grows.
- Do not expose WinRM from WAN.

## GPO configuration guidance

Configure WinRM through Group Policy so the baseline is consistent and auditable.

Recommended GPO:

```text
GP - Security - WinRM
```

Baseline settings:

| Area | Setting | Recommended value |
|---|---|---|
| Service | WinRM service startup | Automatic |
| Service | Allow remote server management through WinRM | Enabled |
| Listener | IPv4 filter | `*` |
| Listener | IPv6 filter | Empty unless IPv6 is intentionally deployed |
| Authentication | Kerberos | Enabled/default for domain clients |
| Firewall | Inbound WinRM HTTP | TCP `5985`, Domain Profile, remote address scoped to Management subnet |
| Logging | PowerShell Script Block Logging | Enabled |

!!! warning "IPv4Filter is not a source ACL"

    `IPv4Filter` controls which local interfaces WinRM listens on. It does not control who can connect. Source control belongs in Windows Defender Firewall, MikroTik firewall rules, VLAN segmentation, and Kerberos authorization.

Exact subnet values must match the [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md). For the current GNTECH lab, the Management VLAN is `172.20.10.0/24`.

## Registry and policy validation

Expected policy values on a domain-joined target where `GP - Security - WinRM` applies:

```text
HKLM\Software\Policies\Microsoft\Windows\WinRM\Service\AllowAutoConfig = 1
HKLM\Software\Policies\Microsoft\Windows\WinRM\Service\IPv4Filter = *
HKLM\Software\Policies\Microsoft\Windows\WinRM\Service\IPv6Filter =
```

Run on: `Windows Client or managed Windows Server`

When: after Group Policy has applied and before remote administration validation.

Expected outcome: WinRM policy values exist, the WinRM service is running, and the HTTP listener is present.

```powershell
gpupdate /force
Restart-Service WinRM
winrm enumerate winrm/config/listener
Get-Service WinRM
Get-ItemProperty `
    -Path "HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service" `
    -Name AllowAutoConfig,IPv4Filter,IPv6Filter
```

## Validation commands

Run on: `HQ-MGMT01`

When: after the destination system is domain joined, DNS is working, Group Policy has applied, and firewall rules permit the Management VLAN to reach TCP `5985`.

Expected outcome: TCP `5985` responds, WSMan responds, interactive remoting opens, and command remoting returns expected identity and hostname output.

```powershell
Test-NetConnection HQ-DC01 -Port 5985
Test-WSMan HQ-DC01
Enter-PSSession HQ-DC01
Invoke-Command -ComputerName HQ-DC01 -ScriptBlock { hostname }
Invoke-Command -ComputerName HQ-DC01 -ScriptBlock { whoami }
```

Generic examples such as `DC01` are placeholders only. For implementation, use canonical names such as `HQ-DC01` or substitute `HQ-W11-001` for workstation validation when appropriate.

## Troubleshooting

| Symptom | Likely cause | Corrective action |
|---|---|---|
| WinRM service not running | GPO did not apply, service disabled, or local policy conflict | Run `gpupdate /force`, check `Get-Service WinRM`, validate `GP - Security - WinRM`. |
| TCP `5985` blocked | Windows Firewall or MikroTik policy missing | Validate Windows Firewall scope and MikroTik Management VLAN to destination rule. |
| DNS resolution issue | Wrong hostname, DNS registration missing, client not using AD DNS | Resolve the target hostname and validate DNS client settings. |
| Kerberos failure | Connecting by IP, time skew, SPN/DNS issue | Use hostname, check time sync, validate domain membership. |
| Time synchronization issue | Client clock differs from domain controller | Validate NTP/domain time and resync. |
| Wrong VLAN source | Test initiated outside Management VLAN | Re-test from `HQ-MGMT01` or approved management subnet. |
| Local Administrator context | Using local account instead of domain admin context | Use a dedicated domain administrative account such as `GNTECH\admin.gnolasco`. |
| TrustedHosts required unexpectedly | Endpoint is not using domain Kerberos | Stop and validate domain join/DNS/Kerberos before adding TrustedHosts. |

## Baseline Validation Checklist

- [ ] Target is domain joined.
- [ ] Target is in the correct OU.
- [ ] `GP - Security - WinRM` applies.
- [ ] WinRM service is running.
- [ ] WinRM listener exists on TCP `5985`.
- [ ] `IPv4Filter = *`.
- [ ] Windows Defender Firewall allows TCP `5985` only from the Management subnet defined in the [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md).
- [ ] MikroTik allows Management VLAN to destination TCP `5985` using CIDRs from the canonical matrix.
- [ ] Non-management VLANs cannot reach WinRM.
- [ ] `Test-WSMan` succeeds from `HQ-MGMT01`.
- [ ] `Invoke-Command` succeeds from `HQ-MGMT01`.
- [ ] Script Block Logging remains enabled.

## Future improvements

As the lab matures, consider:

- Just Enough Administration.
- Certificate-based WinRM HTTPS for scenarios that require it.
- Stronger PAW tiering.
- Dedicated management groups and constrained delegation.
- Centralized PowerShell logging and alerting.
