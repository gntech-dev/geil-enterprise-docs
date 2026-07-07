---
title: Windows Firewall Baseline
document_id: GEIL-MSC-WINSEC-FW-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-07-02
review_cycle: Quarterly
classification: Internal Confidential
---

# Windows Firewall Baseline

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-WINSEC-FW-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-07-02 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This guide defines the Windows Defender Firewall baseline for the GNTECH Windows Infrastructure Lab. It converts the network and service model into practical host-level firewall expectations for Domain Controllers, member servers, management workstations, and standard workstations.

Use the [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md) as the source of truth for VLANs, subnets, gateways, server names, Active Directory service ports, Windows management ports, and inter-VLAN firewall expectations. This guide does not duplicate the full matrix.

## Scope

This baseline applies to domain-joined Windows systems in the current lab phase:

- Domain Controllers, starting with `HQ-DC01`.
- Future member servers.
- Management workstations, starting with `HQ-MGMT01`.
- Standard Windows workstations, starting with `HQ-W11-001`.

This is not a full enterprise firewall architecture. It is the small-business-lab baseline that can later mature into role-specific firewall baselines, PAW tiering, Windows LAPS, Microsoft Defender, Windows Event Forwarding, and privileged access enforcement.

## Baseline principles

- Windows Defender Firewall must be enabled on Domain, Private, and Public profiles.
- Default inbound action should be `Block`.
- Default outbound action may remain `Allow` for the current lab phase.
- RDP TCP `3389` must be scoped to the Management VLAN only.
- WinRM TCP `5985` and `5986` must be scoped to the Management VLAN only.
- Active Directory Domain Services ports must be separated from administrative ports.
- Workstations may need DNS, Kerberos, LDAP, SMB/SYSVOL, and Group Policy access to Domain Controllers.
- Workstations must not initiate RDP or WinRM sessions to Domain Controllers.
- Guest, WAN, IoT, CCTV, and untrusted VLANs must not reach Windows management ports.
- MikroTik controls inter-VLAN routing exposure.
- Windows Defender Firewall controls host-level exposure.
- Both the network firewall and host firewall are required.

## Required firewall profiles

| Profile | Required state | Default inbound | Default outbound | Notes |
|---|---|---|---|---|
| Domain | Enabled | Block | Allow | Primary profile for domain-joined systems on trusted GNTECH VLANs. |
| Private | Enabled | Block | Allow | Keep enabled to prevent accidental exposure on misclassified networks. |
| Public | Enabled | Block | Allow | Most restrictive profile for unknown networks. |

Run on: `Windows Client, managed Windows Server, or HQ-DC01 during validation`

When: validating the host firewall baseline on any managed Windows system.

Expected outcome: all profiles are enabled, inbound defaults to `Block`, and outbound remains `Allow` for the current lab phase.

```powershell
Get-NetFirewallProfile |
    Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction
```

## Management access rules

Windows management access is allowed only from the Management VLAN defined in the [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md).

Current confirmed source:

| Source | VLAN | CIDR |
|---|---:|---|
| Management VLAN | 10 | `172.20.10.0/24` |

| Management function | Port | Source | Requirement |
|---|---:|---|---|
| RDP | TCP `3389` | Management VLAN only | Interactive administration. |
| WinRM HTTP | TCP `5985` | Management VLAN only | Kerberos-protected internal PowerShell Remoting. |
| WinRM HTTPS | TCP `5986` | Management VLAN only | Future certificate-backed remoting where required. |
| SMB/Admin shares | TCP `445` | Management VLAN where required | Also used by AD/GPO; do not treat every SMB flow as admin access. |
| RPC Endpoint Mapper | TCP `135` | Management VLAN where required | Scope tightly. |
| Dynamic RPC | TCP `49152-65535` | Management VLAN where explicitly required | Avoid broad exposure. |

## Domain Controller firewall expectations

Domain Controllers provide AD DS services to domain clients and receive administrative access only from approved management systems.

Expected model for `HQ-DC01`:

| Traffic category | Source | Allowed services | Notes |
|---|---|---|---|
| Domain services | Workstations VLAN and other approved domain client networks | DNS, Kerberos, LDAP, SMB/SYSVOL, password change, time, and other required AD DS services | Required for domain join, authentication, Group Policy, and directory lookup. |
| Administrative access | Management VLAN only | RDP, WinRM, SMB admin, tightly scoped RPC where required | Use `HQ-MGMT01` and approved admin accounts. |
| Guest / untrusted access | Guest, WAN, IoT, CCTV, untrusted networks | None | Block management and internal infrastructure access. |

Do not allow standard workstations to RDP or WinRM into Domain Controllers. Domain service access is not administrative access.

## Member Server firewall expectations

Member servers should follow the same management-source rule as Domain Controllers:

- RDP and WinRM are allowed only from the Management VLAN.
- Application ports are allowed only from documented client networks.
- SMB/Admin shares are scoped to the Management VLAN unless the server role explicitly requires user SMB access.
- Dynamic RPC is allowed only when a documented workload requires it.
- Server-specific application rules must be documented in that server role guide.

Future role-specific baselines should split this into member-server and application-server details. Do not create broad any-to-any server rules for convenience.

## Management Workstation firewall expectations

`HQ-MGMT01` is the privileged administration workstation / initial PAW. It initiates management traffic to approved targets. It should not expose unnecessary inbound services.

Expected model:

- Windows Defender Firewall enabled on all profiles.
- Inbound RDP allowed only if required and scoped to approved management paths.
- Inbound WinRM only if the workstation itself must be administered remotely.
- PowerShell Script Block Logging remains enabled.
- Daily-driver user access should not be allowed to weaken management workstation firewall posture.

The management workstation is a source of administration, not a general-purpose server.

## Standard Workstation firewall expectations

Standard workstations such as `HQ-W11-001` consume domain services but do not administer infrastructure.

Expected model:

- Windows Defender Firewall enabled on all profiles.
- Default inbound action is `Block`.
- RDP is disabled or scoped to Management VLAN only when explicitly enabled for support.
- WinRM is disabled unless required for management, validation, or automation.
- If WinRM is enabled, inbound TCP `5985` is scoped to Management VLAN only.
- Standard workstations must not initiate RDP or WinRM to Domain Controllers.

## GPO implementation guidance

Use Group Policy to make the host firewall baseline consistent and auditable.

Recommended GPO structure for the current phase:

| GPO | Target | Purpose |
|---|---|---|
| `GP - Security - Windows Firewall` | Domain-joined Windows systems | Common firewall profile defaults. |
| `GP - Security - WinRM` | Managed Windows systems where remoting is required | WinRM service/listener and firewall scope. |
| `GP - Baseline - Management Workstations` | Management Workstations OU | Management workstation baseline settings. |
| `GP - Baseline - Workstations` | Workstations OU | Standard workstation baseline settings. |

Implementation guidance:

- Enable Windows Defender Firewall for Domain, Private, and Public profiles.
- Configure default inbound action as `Block`.
- Keep default outbound action as `Allow` for the current lab phase.
- Configure RDP inbound rules only where RDP is required.
- Scope RDP and WinRM inbound rules to `172.20.10.0/24`.
- Keep AD DS service-port access separate from administrative access.
- Document every exception with source, destination, port, purpose, and owner.

## PowerShell inspection commands

Run on: `Windows Client, managed Windows Server, or HQ-DC01 during validation`

When: checking whether Windows Defender Firewall profile defaults and management rule groups match the baseline.

Expected outcome: firewall profiles are enabled; Remote Desktop and Windows Remote Management rules are visible for scope review.

```powershell
Get-NetFirewallProfile |
    Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction

Get-NetFirewallRule -DisplayGroup "Remote Desktop" |
    Select-Object DisplayName, Enabled, Direction, Action

Get-NetFirewallRule -DisplayGroup "Windows Remote Management" |
    Select-Object DisplayName, Enabled, Direction, Action
```

Run on: `Windows Client, managed Windows Server, or HQ-DC01 during validation`

When: validating remote-address scoping for RDP and WinRM firewall rules.

Expected outcome: enabled inbound management rules are scoped to the Management VLAN, currently `172.20.10.0/24`.

```powershell
$ManagementRuleGroups = @(
    "Remote Desktop",
    "Windows Remote Management"
)

foreach ($Group in $ManagementRuleGroups) {
    Get-NetFirewallRule -DisplayGroup $Group |
        Where-Object { $_.Enabled -eq "True" -and $_.Direction -eq "Inbound" } |
        Get-NetFirewallAddressFilter |
        Select-Object InstanceID, RemoteAddress
}
```

## Example local rule scoping

These commands are examples for local validation or controlled pilot correction. Prefer GPO for durable configuration.

Run on: `Windows Client or managed Windows Server`

When: a pilot system requires local scoping for RDP and WinRM before the permanent GPO is corrected.

Expected outcome: enabled RDP and WinRM inbound rules accept traffic only from the Management VLAN.

```powershell
$ManagementSubnet = "172.20.10.0/24"

Get-NetFirewallRule -DisplayGroup "Remote Desktop" |
    Where-Object { $_.Direction -eq "Inbound" } |
    Set-NetFirewallRule -RemoteAddress $ManagementSubnet

Get-NetFirewallRule -DisplayGroup "Windows Remote Management" |
    Where-Object { $_.Direction -eq "Inbound" } |
    Set-NetFirewallRule -RemoteAddress $ManagementSubnet
```

## Validation from Management VLAN

Run on: `HQ-MGMT01`

When: validating administrative access from the approved Management VLAN.

Expected outcome: DNS resolves, RDP and WinRM reach `HQ-DC01` if those services are intentionally enabled, WSMan responds, and PowerShell Remoting works where authorized.

```powershell
Resolve-DnsName HQ-DC01
Test-NetConnection HQ-DC01 -Port 3389
Test-NetConnection HQ-DC01 -Port 5985
Test-WSMan HQ-DC01
Invoke-Command -ComputerName HQ-DC01 -ScriptBlock { hostname }
```

## Validation from Workstations VLAN

Run on: `HQ-W11-001`

When: validating that standard workstations can use required domain services but cannot administer Domain Controllers.

Expected outcome: DNS, Kerberos, LDAP, and SMB may succeed where required for domain functionality. RDP and WinRM fail from the Workstations VLAN.

```powershell
Resolve-DnsName HQ-DC01
Test-NetConnection HQ-DC01 -Port 53
Test-NetConnection HQ-DC01 -Port 88
Test-NetConnection HQ-DC01 -Port 389
Test-NetConnection HQ-DC01 -Port 445
Test-NetConnection HQ-DC01 -Port 3389
Test-NetConnection HQ-DC01 -Port 5985
```

Expected interpretation:

- DNS/Kerberos/LDAP/SMB may succeed where required for domain functionality.
- RDP should fail from Workstations VLAN.
- WinRM should fail from Workstations VLAN.
- RDP/WinRM should succeed only from Management VLAN.


## Pilot finding: VLAN30 administrative-port block

Pilot validation from `HQ-W11-001` in VLAN 30 confirmed the desired final state:

| Source | Destination | Port | Result | Interpretation |
|---|---|---:|---|---|
| `HQ-W11-001` / VLAN 30 | `HQ-DC01` | TCP `53` | Success | DNS/domain service access allowed. |
| `HQ-W11-001` / VLAN 30 | `HQ-DC01` | TCP `88` | Success | Kerberos/domain service access allowed. |
| `HQ-W11-001` / VLAN 30 | `HQ-DC01` | TCP `389` | Success | LDAP/domain service access allowed. |
| `HQ-W11-001` / VLAN 30 | `HQ-DC01` | TCP `445` | Success | SMB/SYSVOL/Group Policy access allowed. |
| `HQ-W11-001` / VLAN 30 | `HQ-DC01` | TCP `3389` | Failed | RDP administration blocked. |
| `HQ-W11-001` / VLAN 30 | `HQ-DC01` | TCP `5985` | Failed | WinRM administration blocked. |

Endpoint Windows Defender Firewall controls local inbound exposure. MikroTik controls inter-VLAN authorization. Both are required.

If `HQ-W11-001` can reach `HQ-DC01` on TCP `3389` or TCP `5985`, check MikroTik rule order first. VLAN 30 must be allowed to use required AD DS ports, but it must not administer Domain Controllers. The required MikroTik behavior is to drop VLAN 30 Workstations to `HQ-DC01` TCP `3389,5985` before any broad or temporary VLAN30-to-`HQ-DC01` allow rule.

## Troubleshooting

| Symptom | Likely cause | Corrective action |
|---|---|---|
| RDP works from Workstations VLAN | MikroTik rule order permits VLAN30-to-`HQ-DC01` admin ports, or the Windows Firewall rule has broad remote address scope | Check MikroTik rule order first; drop VLAN30 to `HQ-DC01` TCP `3389` before broad VLAN30 allow rules, then verify host firewall scope. |
| WinRM works from Workstations VLAN | MikroTik rule order permits VLAN30-to-`HQ-DC01` admin ports, or the Windows Firewall rule has broad remote address scope | Check MikroTik rule order first; drop VLAN30 to `HQ-DC01` TCP `5985` before broad VLAN30 allow rules, then validate `GP - Security - WinRM`. |
| Domain join fails but RDP/WinRM is blocked correctly | AD DS service ports are too restrictive | Review the AD service port matrix; allow required DNS/Kerberos/LDAP/SMB/GPO flows to Domain Controllers. |
| Management workstation cannot reach WinRM | Windows Firewall scope, MikroTik policy, DNS, or WinRM service issue | Validate `Test-NetConnection`, `Test-WSMan`, WinRM service state, and firewall address filters. |
| Firewall rule appears enabled but traffic fails | Wrong profile, wrong remote address scope, or upstream MikroTik block | Check active profile, address filters, and MikroTik counters. |
| Public profile is active on domain network | Network Location Awareness or domain connectivity issue | Validate DNS, domain controller reachability, and NLA state before weakening firewall rules. |

## Baseline checklist

- [ ] Domain, Private, and Public firewall profiles are enabled.
- [ ] Default inbound action is `Block`.
- [ ] Default outbound action remains `Allow` for the current lab phase.
- [ ] RDP TCP `3389` is scoped to Management VLAN only.
- [ ] WinRM TCP `5985` is scoped to Management VLAN only.
- [ ] WinRM TCP `5986` is blocked or scoped to Management VLAN until certificate-based HTTPS is implemented.
- [ ] AD DS service ports are documented separately from administrative ports.
- [ ] Workstations can reach required AD DS services.
- [ ] Workstations cannot RDP or WinRM to Domain Controllers.
- [ ] Guest, WAN, IoT, CCTV, and untrusted VLANs cannot reach Windows management ports.
- [ ] MikroTik inter-VLAN policy aligns with this host firewall baseline.
- [ ] Future role-specific baselines will reference the network matrix.

## Future improvements

As the lab matures, add role-specific firewall baseline documents for:

- Domain Controllers.
- Member Servers.
- Management Workstations.
- Standard Workstations.

Future maturity items:

- Windows LAPS integration.
- Microsoft Defender baseline integration.
- Windows Event Forwarding firewall dependencies.
- PAW tiering.
- Just Enough Administration.
- Certificate-based WinRM HTTPS.
- Separate server admin and domain admin roles.
