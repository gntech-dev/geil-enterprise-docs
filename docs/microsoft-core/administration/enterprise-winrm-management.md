---
title: Enterprise WinRM Management
document_id: GEIL-MSC-ADMIN-WINRM-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-02
review_cycle: Quarterly
classification: Internal Confidential
---

# Enterprise WinRM Management

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-ADMIN-WINRM-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-07-02 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Document the validated GEIL WinRM management model for domain-joined Windows endpoints. WinRM is the baseline remote administration and automation channel from `HQ-MGMT01` to managed Windows clients and future Windows infrastructure servers. RDP remains available for approved interactive administration, but routine repeatable administration should use PowerShell Remoting over WinRM.

## Architecture

Validated management path:

```text
HQ-MGMT01
↓
PowerShell Remoting / WinRM TCP 5985
↓
Windows Defender Firewall on target
↓
MikroTik inter-VLAN firewall policy
↓
VLAN segmentation
↓
Kerberos authentication
↓
Managed Windows endpoint
```

Access control is not implemented by the WinRM listener address filter. Access control is enforced by:

1. Windows Defender Firewall on the target endpoint.
2. MikroTik firewall policy between VLANs.
3. VLAN segmentation.
4. Kerberos authentication and Windows authorization.

## Authentication

WinRM uses domain authentication. GEIL examples use the identity format from [Authentication Standards](../authentication-standards.md):

```text
GNTECH\admin.gnolasco
```

Kerberos is expected when both systems are domain joined, DNS resolves correctly, clocks are synchronized, and the SPN can be resolved through normal AD DS mechanisms.

## Kerberos

Kerberos provides mutual authentication inside the AD domain. The management workstation does not need local accounts on the target client when domain identity and authorization are configured correctly.

Validated implementation:

- `HQ-MGMT01` manages `HQ-W11-001` successfully.
- Kerberos authentication is used.
- `Test-WSMan` succeeds.
- `Invoke-Command` succeeds.
- PowerShell Remoting works correctly.

## Why HTTP 5985 is acceptable inside an AD domain

WinRM HTTP on TCP `5985` does not mean credentials are sent in clear text when Kerberos is used. In an AD domain, Kerberos authenticates the session and protects credentials. GEIL uses HTTP `5985` for domain-internal WinRM because it is simpler to operate, avoids unnecessary certificate dependencies at this phase, and aligns with common Windows domain administration practice.

## Why HTTPS is not required in this design

WinRM HTTPS on TCP `5986` is not required for the validated GEIL design because:

- The management path is internal to trusted GEIL networks.
- Kerberos is used for authentication.
- Network access is restricted by Windows Defender Firewall, MikroTik firewall rules, and VLAN segmentation.
- Certificate lifecycle for HTTPS listeners adds operational complexity that is not required for the validated pilot scenario.

Use WinRM HTTPS only if a future design requires cross-domain, workgroup, untrusted network, or certificate-based remoting scenarios.

## WinRM Listener

Validated listener setting:

| Setting | Value | Reason |
|---|---|---|
| `IPv4Filter` | `*` | WinRM must create listeners on local interfaces. This is not a source ACL. |
| `IPv6Filter` | empty | IPv6 is not in scope for the current GEIL pilot. |
| Transport | HTTP | Domain-internal Kerberos-protected remoting on TCP `5985`. |

!!! warning "IPv4Filter is not an access-control list"

    `IPv4Filter` defines the local interfaces where WinRM creates listeners. It does not restrict which remote source IPs may connect. A previous pilot note incorrectly documented `IPv4Filter = 172.20.10.0/24`; that is technically wrong because `172.20.10.0/24` is a source network, not a local listener interface selection. Use `IPv4Filter = *` and enforce source access with Windows Defender Firewall and MikroTik firewall policy.

## Windows Firewall

The target endpoint must allow inbound WinRM from the Management VLAN only.

| Setting | Value |
|---|---|
| Protocol | TCP |
| Port | `5985` |
| Profile | Domain |
| Allowed remote addresses | `172.20.10.0/24` |

This allows `HQ-MGMT01` and future approved management workstations to administer domain-joined clients while preventing broad workstation, guest, or untrusted network access.

## MikroTik Firewall

MikroTik is responsible for inter-VLAN authorization. Required policy:

| Source | Destination | Protocol/Port | Action | Purpose |
|---|---|---|---|---|
| Management VLAN `172.20.10.0/24` | Workstations VLAN `172.20.30.0/24` | TCP `5985` | Allow | WinRM management from `HQ-MGMT01` to domain clients |

This rule belongs before the default inter-VLAN deny rule and should be as specific as practical. Do not allow guest or untrusted networks to reach WinRM.

## VLAN segmentation

VLAN segmentation limits where management traffic can originate. `HQ-MGMT01` is on VLAN 10 Management. `HQ-W11-001` and future standard clients are on VLAN 30 Workstations. WinRM management flows from VLAN 10 to VLAN 30 only through documented firewall policy.

## PowerShell Remoting

PowerShell Remoting uses WinRM as its transport. Use it for repeatable administration, inventory, validation, and automation.

## Validation

### Client-side validation

Run on: `Windows Client`

When: after the client is domain joined, moved to the correct OU, and `GP - Security - WinRM` has applied.

Expected outcome: Group Policy applies, WinRM restarts, and the listener shows HTTP with `IPv4Filter = *` and no IPv6 filter.

```powershell
gpupdate /force
Restart-Service WinRM
winrm enumerate winrm/config/listener
```

Expected listener evidence:

```text
Transport = HTTP
Port = 5985
IPv4Filter = *
IPv6Filter =
```

### Management workstation validation

Run on: `HQ-MGMT01`

When: after client-side validation succeeds and DNS resolves the target client.

Expected outcome: TCP `5985`, WSMan, one-shot remoting, and interactive remoting all succeed using Kerberos.

```powershell
Test-NetConnection HQ-W11-001 -Port 5985
Test-WSMan HQ-W11-001
Invoke-Command -ComputerName HQ-W11-001 -ScriptBlock {
    hostname
    whoami
}
Enter-PSSession HQ-W11-001
```

Expected results:

- `Test-NetConnection` returns `TcpTestSucceeded : True`.
- `Test-WSMan` returns a WSMan response from `HQ-W11-001`.
- `Invoke-Command` returns hostname `HQ-W11-001` and the authenticated domain identity.
- `Enter-PSSession` opens an interactive remote session.

## Security considerations

- WinRM is for remote administration and automation.
- RDP remains available for approved interactive administration.
- Restrict WinRM with Windows Defender Firewall remote address scope and MikroTik inter-VLAN policy.
- Do not use WinRM listener filters as source ACLs.
- Use Kerberos in-domain; avoid Basic authentication.
- Keep management workstations in the Management VLAN and standard clients in the Workstations VLAN.

## Common mistakes

| Mistake | Impact | Correction |
|---|---|---|
| Setting `IPv4Filter = 172.20.10.0/24` | Listener may not bind as intended; source filtering is misunderstood | Use `IPv4Filter = *`; restrict sources with firewall policy. |
| Allowing TCP 5985 from all VLANs | WinRM exposed too broadly | Restrict Windows Firewall remote addresses and MikroTik inter-VLAN rules. |
| Testing by IP only | Kerberos may not be used as expected | Test by DNS name such as `HQ-W11-001`. |
| Using local accounts for routine remoting | Weakens domain audit and authorization model | Use domain identity such as `GNTECH\admin.gnolasco`. |

## Pilot findings

- `HQ-MGMT01` successfully manages `HQ-W11-001` using WinRM.
- Kerberos authentication is used.
- `Test-WSMan` succeeds.
- `Invoke-Command` succeeds.
- `Enter-PSSession` succeeds.
- PowerShell Remoting works correctly.
- RDP remains available for interactive administration.
- WinRM is intended for remote administration and automation.
- `IPv4Filter` is not an ACL.
- Listener configuration is different from access authorization.
- Firewall policy controls access.
- Management workstations administer clients primarily through WinRM.
