---
title: Windows 11 Management Workstation
document_id: GEIL-PLAT-W11-MGMT-001
owner: Infrastructure Engineering
status: Approved
version: 1.2
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# Windows 11 Management Workstation

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-PLAT-W11-MGMT-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.2 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

!!! note "Canonical GNTECH values"

    `HQ-MGMT01` is the Windows 11 Enterprise management workstation / initial privileged access workstation on the Management network, VLAN 10. `HQ-W11-001` is the standard Windows 11 Enterprise client validation VM on the Workstations network, VLAN 30. They have different security purposes and must not share the same workstation security boundary.

!!! warning "Do not use Windows Server as a daily admin workstation"

    Windows Server hosts infrastructure roles. Routine administration must originate from `HQ-MGMT01` or a future approved PAW/jump path. Avoid routine interactive logons to `HQ-DC01` and future servers except for bootstrap, recovery, or approved break-glass work.

## Purpose

Deploy `HQ-MGMT01` from the Windows 11 Enterprise golden template as the dedicated management workstation and initial PAW for GEIL. This guide follows the validated pilot lifecycle from clone, Cloudbase-Init first boot, network validation, domain join, Management Workstations OU placement, Group Policy validation, administrative tooling installation, and final remote-administration validation.

## Design decision

Pilot deployment established this model:

| Host | Operating System | Network | Active Directory placement | Intended use |
|---|---|---|---|---|
| `HQ-MGMT01` | Windows 11 Enterprise | VLAN 10 Management | `OU=Management Workstations,OU=Computers,OU=GNTECH,...` | Dedicated management workstation / initial PAW with RSAT/admin tools |
| `HQ-W11-001` | Windows 11 Enterprise | VLAN 30 Workstations | `OU=Workstations,OU=Computers,OU=GNTECH,...` | Standard client validation, DHCP, domain join, GPO, endpoint policy |

`HQ-MGMT01` is not Windows Server and is not a standard user workstation. It is a hardened Management VLAN workstation used to administer `HQ-DC01`, `HQ-FW01`, `PVE-HQ01`, switches, file servers, and future infrastructure services remotely. Only management workstations belong on VLAN 10; standard user workstations remain on VLAN 30.

## Rationale

- Remote administration from a hardened workstation reduces routine interactive logons to servers.
- The model supports administrative tiering by giving privileged accounts a known administrative endpoint.
- It prepares GEIL for PAW hardening, LAPS, Windows Hello for Business, Microsoft Entra ID, Just-in-Time access, and Just Enough Administration.
- It keeps `HQ-W11-001` and future user workstations on VLAN 30 as standard clients instead of overloading them with privileged tooling.
- Pilot validation demonstrated that a dedicated management workstation should be isolated from user networks and prepared for future PAW implementation.

## RDP authentication standard

Validated RDP authentication format for Microsoft Remote Desktop, Cloudflare Browser Rendering / IronRDP, and future GEIL RDP examples is the NetBIOS domain format:

```text
GNTECH\admin.gnolasco
```

Use this format when signing in to Windows systems through RDP unless that specific client has been separately validated for UPN authentication. Do not use `admin.gnolasco@gntech.me` in RDP examples unless the client-specific validation evidence exists. See [Authentication Standards](../authentication-standards.md).

## Cloudbase-Init lifecycle

`HQ-MGMT01` is created from the workgroup-only [Windows 11 Enterprise Golden Template](windows-11-enterprise-golden-template.md). The template remains generalized and never joins `corp.gntech.me`.

Cloudbase-Init runs only after cloning. During the first boot of the clone, Cloudbase-Init applies clone-specific metadata such as hostname, injected local Administrator password, and initial network configuration. Domain join never occurs inside the template.

The authoritative template build and Cloudbase-Init configuration details remain in:

- [Windows 11 Enterprise Golden Template](windows-11-enterprise-golden-template.md)
- [Cloudbase-Init for Proxmox](cloudbase-init-for-proxmox.md)

## Prerequisites

- [Windows 11 Enterprise Golden Template](windows-11-enterprise-golden-template.md) completed and validated as workgroup-only.
- Cloudbase-Init is installed and validated in the template.
- [Active Directory Network Requirements](../../platform/active-directory-network-requirements.md) implemented.
- [Active Directory Organizational Foundation](../active-directory-organizational-foundation.md) completed, including `OU=Management Workstations,OU=Computers,OU=GNTECH`.
- [Authentication Standards](../authentication-standards.md) reviewed. RDP and Windows sign-in examples use `GNTECH\username`, for example `GNTECH\admin.gnolasco`.
- [Group Policy Baseline](../group-policy-baseline.md) completed through creation and linking of `GP - Baseline - Management Workstations`. This GPO is separate from `GP - Baseline - Workstations`.
- Management VLAN 10 addressing, DNS, and domain-controller access are operational for `HQ-MGMT01`.
- Domain join credentials are approved for the change window.

## Deployment sequence

1. Clone from Windows 11 Enterprise Golden Template.
2. Allow Cloudbase-Init first boot to set hostname, password, and initial network configuration.
3. Validate DHCP or reserved addressing.
4. Validate DNS.
5. Validate Active Directory network connectivity.
6. Join `corp.gntech.me`.
7. Reboot.
8. Move computer to `OU=Management Workstations,OU=Computers,OU=GNTECH`.
9. Force Group Policy.
10. Validate applied GPOs, including `GP - Baseline - Management Workstations`.
11. Validate Remote Desktop and Network Level Authentication policy state without broadly exposing RDP.
12. Validate Remote Desktop service, Windows Firewall rules, and TCP 3389 listener.
13. Validate WinRM / PowerShell Remoting to `HQ-W11-001`.
14. Install RSAT and administration tools.
15. Final validation.

## Step 1: Clone from Windows 11 Enterprise Golden Template

### Purpose

Create the `HQ-MGMT01` VM from the generalized, workgroup-only Windows 11 Enterprise template and attach it to Management VLAN 10.

### Commands

Run from `PVE-HQ01`:

Run on: `PVE-HQ01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```bash
qm clone 9201 120 --name HQ-MGMT01 --full true
qm set 120 --net0 virtio,bridge=GEILLAN,tag=10
qm set 120 --agent enabled=1
qm start 120
qm config 120
```

### Expected Result

`qm config 120` includes:

```text
name: HQ-MGMT01
net0: virtio=...,bridge=GEILLAN,tag=10
agent: enabled=1
```

### Stop Conditions

STOP if the VM is attached to VLAN 30, if the template is not workgroup-only, or if QEMU Guest Agent is not enabled.

### Evidence

Capture `qm config 120` showing `name: HQ-MGMT01`, `bridge=GEILLAN`, and `tag=10`.

## Step 2: Cloudbase-Init first boot

### Purpose

Allow the cloned VM to complete its first boot and consume Cloudbase-Init metadata before any domain operation occurs.

### Commands

Run inside `HQ-MGMT01` after first sign-in:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
$Computer = Get-CimInstance Win32_ComputerSystem
$Computer | Select-Object Name,Domain,PartOfDomain

Get-Service cloudbase-init -ErrorAction SilentlyContinue |
    Select-Object Name,Status,StartType

Get-Content 'C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\cloudbase-init.log' -Tail 80
```

### Expected Result

- Computer name is `HQ-MGMT01` or is ready to be renamed to `HQ-MGMT01` before domain join.
- `PartOfDomain` is `False`.
- Domain/workgroup state is still workgroup-only.
- Cloudbase-Init service exists.
- Cloudbase-Init log shows first-boot execution without fatal errors.
- Local Administrator password injection has been validated through the approved password path.

### Stop Conditions

STOP if the clone is already domain-joined, if the computer contains production user profiles, if Cloudbase-Init has fatal first-boot errors, or if the injected local Administrator password was not validated.

### Evidence

Capture computer system output, Cloudbase-Init service status, and sanitized Cloudbase-Init log tail.

## Step 3: Validate DHCP or reserved addressing

### Purpose

Validate that `HQ-MGMT01` receives or uses the correct Management VLAN addressing before DNS, domain join, or administration tooling is attempted.

### Commands

Run inside `HQ-MGMT01`:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
ipconfig /renew
ipconfig /all
Get-NetIPConfiguration
```

### Expected Result

- IPv4 address is `172.20.10.10` by reservation/static assignment or another approved VLAN10 management address during staging.
- Default gateway is `172.20.10.1`.
- Interface is connected to Management VLAN 10.

### Stop Conditions

STOP if `HQ-MGMT01` receives a VLAN30 address, has no gateway, or cannot reach the Management VLAN gateway.

### Evidence

Capture `ipconfig /all` and `Get-NetIPConfiguration` output.

## Step 4: Validate DNS

### Purpose

Confirm that `HQ-MGMT01` can resolve the AD DS namespace and discover `HQ-DC01` before domain join.

### Commands

Run inside `HQ-MGMT01`:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Resolve-DnsName corp.gntech.me -Server 172.20.20.11
Resolve-DnsName HQ-DC01.corp.gntech.me -Server 172.20.20.11
Resolve-DnsName _ldap._tcp.dc._msdcs.corp.gntech.me -Type SRV -Server 172.20.20.11
```

### Expected Result

- `corp.gntech.me` resolves through `172.20.20.11`.
- `HQ-DC01.corp.gntech.me` resolves.
- AD DS SRV lookup discovers the domain controller.

### Stop Conditions

STOP if DNS resolution fails. Do not join the domain until DNS is corrected.

### Evidence

Capture DNS and SRV lookup output.

## Step 5: Validate Active Directory network connectivity

### Purpose

Confirm that the Management VLAN firewall policy allows required AD DS services from `HQ-MGMT01` to `HQ-DC01`.

### Commands

Run inside `HQ-MGMT01`:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
ping 172.20.20.11
Test-NetConnection HQ-DC01.corp.gntech.me -Port 53
Test-NetConnection HQ-DC01.corp.gntech.me -Port 88
Test-NetConnection HQ-DC01.corp.gntech.me -Port 389
Test-NetConnection HQ-DC01.corp.gntech.me -Port 445
Test-NetConnection HQ-DC01.corp.gntech.me -Port 135
Test-NetConnection HQ-DC01.corp.gntech.me -Port 3268
nltest /dsgetdc:corp.gntech.me
```

### Expected Result

Domain-controller services are reachable through the address-list based firewall policy and `nltest` discovers `HQ-DC01`.

### Stop Conditions

STOP if DHCP/addressing works but DNS, Kerberos, LDAP, SMB/SYSVOL, RPC Endpoint Mapper, Global Catalog, or DC discovery fails. Return to [Active Directory Network Requirements](../../platform/active-directory-network-requirements.md).

### Evidence

Capture `Test-NetConnection` and `nltest` output.

## Step 6: Join `corp.gntech.me`

### Purpose

Join `HQ-MGMT01` to the AD DS domain only after Cloudbase-Init, addressing, DNS, and AD network connectivity validate.

### Commands

Run inside `HQ-MGMT01`:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
$DesiredName = "HQ-MGMT01"
if ($env:COMPUTERNAME -ne $DesiredName) {
    Rename-Computer -NewName $DesiredName -Restart
}
else {
    [PSCustomObject]@{Status="Existing"; Name=$env:COMPUTERNAME}
}
```

After any required rename reboot, run:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
$DomainName = "corp.gntech.me"
$ComputerInfo = Get-CimInstance Win32_ComputerSystem
if ($ComputerInfo.PartOfDomain -and $ComputerInfo.Domain -eq $DomainName) {
    [PSCustomObject]@{Status="Existing"; Domain=$ComputerInfo.Domain; Computer=$env:COMPUTERNAME}
}
else {
    Add-Computer -DomainName $DomainName -Restart
}
```

### Expected Result

The computer joins `corp.gntech.me` and restarts.

### Stop Conditions

STOP if the hostname is incorrect, domain join prompts cannot locate a domain controller, credentials are not approved, or the clone appears to have inherited domain state from the template.

### Evidence

Capture the command transcript and restart/change ticket reference.

## Step 7: Reboot and confirm domain membership

### Purpose

Confirm the domain join completed after restart before moving the computer object or installing administration tooling.

### Commands

Run after restart:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
$ComputerInfo = Get-CimInstance Win32_ComputerSystem
$ComputerInfo | Select-Object Name,Domain,PartOfDomain
nltest /dsgetdc:corp.gntech.me
```

### Expected Result

- `Name` is `HQ-MGMT01`.
- `Domain` is `corp.gntech.me`.
- `PartOfDomain` is `True`.
- Domain controller discovery succeeds.

### Stop Conditions

STOP if the computer is not domain-joined or cannot discover a domain controller after reboot.

### Evidence

Capture domain membership and `nltest` output.

## Step 8: Move computer to Management Workstations OU

### Purpose

Place `HQ-MGMT01` under the dedicated Management Workstations OU so future management workstation policy can target it without affecting standard clients.

### Commands

Run from `HQ-MGMT01` with RSAT AD tools available, from `HQ-DC01`, or from another approved administrative endpoint:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Import-Module ActiveDirectory
$DomainDN = (Get-ADDomain).DistinguishedName
$TargetOU = "OU=Management Workstations,OU=Computers,OU=GNTECH,$DomainDN"
$Computer = Get-ADComputer -Identity "HQ-MGMT01"

if ($Computer.DistinguishedName -notlike "*$TargetOU") {
    Move-ADObject -Identity $Computer.DistinguishedName -TargetPath $TargetOU
    [PSCustomObject]@{Status="Moved"; Computer="HQ-MGMT01"; TargetOU=$TargetOU}
}
else {
    [PSCustomObject]@{Status="Existing"; Computer="HQ-MGMT01"; TargetOU=$TargetOU}
}

Get-ADComputer -Identity "HQ-MGMT01" -Properties DistinguishedName |
    Select-Object Name,DistinguishedName
```

### Expected Result

The distinguished name contains:

```text
OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me
```

### Stop Conditions

STOP if `OU=Management Workstations` does not exist, if the AD module is unavailable, or if the account lacks rights to move the computer object.

### Evidence

Capture the `Moved` or `Existing` output and final distinguished name.

## Step 9: Force Group Policy

### Purpose

Force initial Group Policy processing after domain join and OU placement.

### Commands

Run inside `HQ-MGMT01`:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
gpupdate /force
```

### Expected Result

Computer and user policy update completes successfully. A reboot may be requested if policy requires it.

### Stop Conditions

STOP if Group Policy cannot contact the domain, SYSVOL is inaccessible, or authentication fails.

### Evidence

Capture `gpupdate /force` output.

## Step 10: Validate applied GPOs

### Purpose

Confirm that `HQ-MGMT01` is in the correct OU and applies `GP - Baseline - Management Workstations`, not the standard `GP - Baseline - Workstations` intended for user endpoints.

### Commands

Run inside `HQ-MGMT01`:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
gpresult /r
whoami /groups
```

Optionally capture an HTML result for evidence:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
gpresult /h C:\Windows\Temp\gpresult-HQ-MGMT01.html /f
```

From an approved administrative endpoint, confirm OU placement:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Import-Module ActiveDirectory
Get-ADComputer -Identity "HQ-MGMT01" -Properties DistinguishedName |
    Select-Object Name,DistinguishedName
```

### Expected Result

- Computer object is in `OU=Management Workstations,OU=Computers,OU=GNTECH,...`.
- `GP - Baseline - Management Workstations` appears in applied computer policies.
- `GP - Baseline - Workstations` does not apply to `HQ-MGMT01` as a standard user-workstation baseline.
- Remote Desktop, Network Level Authentication, and PowerShell Script Block Logging settings are in scope for the Management Workstations GPO.
- `whoami /groups` shows expected domain identity context for the signed-in account.

### Stop Conditions

STOP if the computer remains in the default `Computers` container, lands in `OU=Workstations`, cannot read SYSVOL/NETLOGON, fails to apply `GP - Baseline - Management Workstations`, or receives standard workstation policy incorrectly.

### Evidence

Capture `gpresult /r`, `whoami /groups`, optional HTML GPResult, and AD distinguished name output.

## Step 11: Management Workstation Baseline Validation

### Purpose

Confirm the initial Management Workstations GPO settings are present while reinforcing that RDP exposure is controlled by firewall and network policy, not by broad access.

### Commands

Run on: `HQ-MGMT01`

When: after `gpupdate /force` and `gpresult /r` show `GP - Baseline - Management Workstations` applied.

Expected outcome: Remote Desktop is enabled, Network Level Authentication is required, access remains restricted to approved management paths, and RDP sign-in uses `GNTECH\admin.gnolasco`.

```powershell
# Remote Desktop

Get-ItemProperty `
    -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" `
    -Name fDenyTSConnections

Get-ItemProperty `
    -Path "HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services" `
    -Name UserAuthentication

# PowerShell Script Block Logging

Get-ItemProperty `
    -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" `
    -Name EnableScriptBlockLogging
```

### Expected Result

- `fDenyTSConnections` is `0`.
- `UserAuthentication` is `1`.
- `EnableScriptBlockLogging` is `1`.
- RDP access is limited by Management VLAN and firewall policy. The GPO enables Remote Desktop, but exposure is controlled by VLAN segmentation and firewall policy.
- Remote Desktop is not broadly accessible from workstation, guest, or untrusted networks.
- RDP authentication examples use `GNTECH\admin.gnolasco`, not `admin.gnolasco@gntech.me`, unless a specific RDP client is separately validated for UPN authentication.

## Step 12: Validate Remote Desktop service, firewall rules, and listener

### Purpose

Confirm the operating system is actually ready to accept approved RDP sessions after the Management Workstations GPO applies.

### Commands

Run on: `HQ-MGMT01`

When: after Step 11 confirms Remote Desktop, NLA, and Script Block Logging policy values.

Expected outcome: Remote Desktop Services is running, Windows Firewall Remote Desktop rules are enabled, and TCP 3389 responds locally.

```powershell
Get-Service TermService

Get-NetFirewallRule -DisplayGroup "Remote Desktop" |
    Select DisplayName, Enabled

Test-NetConnection localhost -Port 3389
```

### Expected Result

- `TermService` status is `Running`.
- Remote Desktop firewall rules are `Enabled`.
- TCP port `3389` responds successfully.
- Microsoft Remote Desktop and Cloudflare Browser Rendering / IronRDP authenticate with `GNTECH\admin.gnolasco`.

### Stop Conditions

STOP if RDP is reachable from broad user or guest networks, if NLA is not required, if Script Block Logging is not enabled, if `TermService` is not running, if firewall rules are disabled, or if TCP 3389 does not respond locally.

### Evidence

Capture registry policy output, `TermService` state, Windows Firewall Remote Desktop rule state, local TCP 3389 validation, firewall/network validation evidence showing RDP is constrained to approved management paths, and sign-in evidence using `GNTECH\admin.gnolasco`.

## Step 13: Validate WinRM / PowerShell Remoting

### Purpose

Confirm that `HQ-MGMT01` can administer `HQ-W11-001` using Kerberos-based WinRM / PowerShell Remoting. This validates the enterprise automation path after RDP is available for interactive administration.

### Commands

Run on: `HQ-MGMT01`

When: after `HQ-W11-001` has applied `GP - Security - WinRM`, Windows Defender Firewall allows TCP `5985` from `172.20.10.0/24`, and MikroTik allows Management VLAN to Workstations TCP `5985`.

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

### Expected Result

- `Test-NetConnection` returns `TcpTestSucceeded : True`.
- `Test-WSMan` returns a WSMan response.
- `Invoke-Command` returns `HQ-W11-001` and the authenticated domain identity.
- `Enter-PSSession` opens an interactive PowerShell session.

### Stop Conditions

STOP if DNS resolution fails, TCP `5985` is blocked, `Test-WSMan` fails, Kerberos authentication fails, or the command falls back to an unapproved authentication method.

### Evidence

Capture `Test-NetConnection`, `Test-WSMan`, `Invoke-Command`, and `Enter-PSSession` output. See [Enterprise WinRM Management](../administration/enterprise-winrm-management.md) for the full WinRM architecture.

## Step 14: Install RSAT and administration tools

### Purpose

Install the management tools required for `HQ-MGMT01` to administer Microsoft Core and infrastructure remotely.

### Commands

Run inside `HQ-MGMT01` after domain join and GPO validation:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
$Capabilities = @(
    "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0",
    "Rsat.Dns.Tools~~~~0.0.1.0",
    "Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0",
    "Rsat.ServerManager.Tools~~~~0.0.1.0"
)
foreach ($Capability in $Capabilities) {
    Add-WindowsCapability -Online -Name $Capability
}
Get-WindowsCapability -Online | Where-Object Name -like "Rsat*" | Select-Object Name,State

$WingetPackages = @(
    "Microsoft.PowerShell",
    "Microsoft.WindowsTerminal",
    "Microsoft.VisualStudioCode",
    "Git.Git"
)
foreach ($Package in $WingetPackages) {
    winget install --id $Package --source winget --accept-package-agreements --accept-source-agreements --silent
}
```

### Expected Result

- Required RSAT capabilities show `Installed`.
- PowerShell 7, Windows Terminal, Visual Studio Code, and Git are available for approved administration and documentation workflows.

### Stop Conditions

STOP if Windows capability installation fails, Windows Update/FoD source is unavailable, or `winget` package installation is blocked without an approved alternate source.

### Evidence

Capture RSAT capability output and installed tool validation.

## Step 15: Final validation

### Purpose

Validate that `HQ-MGMT01` is ready to act as the initial PAW and remote administration origin.

### Commands

Run inside `HQ-MGMT01` with approved privileged credentials:

Run on: `HQ-MGMT01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Get-Command Get-ADDomain
Get-Command Get-GPO
Resolve-DnsName HQ-DC01.corp.gntech.me
Test-NetConnection HQ-DC01.corp.gntech.me -Port 3389
Test-NetConnection HQ-DC01.corp.gntech.me -Port 5985
Test-NetConnection 172.20.100.11 -Port 8006
Test-NetConnection 172.20.10.1 -Port 8291
```

### Expected Result

- RSAT cmdlets are available.
- DNS resolves `HQ-DC01.corp.gntech.me`.
- Approved management ports are reachable when enabled by policy.
- Proxmox and MikroTik management paths validate from VLAN 10.
- Routine administration no longer requires interactive logon to `HQ-DC01`.

### Stop Conditions

STOP if RSAT cmdlets are missing, management targets are unreachable, or administrators must use Windows Server as a daily admin workstation.

### Evidence

Capture command output for RSAT, DNS, and management path validation.

## Pilot Findings

Validated pilot lessons incorporated into this guide:

- Golden Image remains in Workgroup.
- Domain Join occurs only after Cloudbase-Init completes on the clone.
- Cloudbase-Init successfully injects the local Administrator password.
- Management Workstations use a dedicated OU: `OU=Management Workstations,OU=Computers,OU=GNTECH,...`.
- Management Workstations use a dedicated GPO: `GP - Baseline - Management Workstations`.
- Management Workstations are deployed in the Management VLAN.
- MikroTik firewall and DHCP relay were validated for the pilot path.
- Active Directory firewall rules were validated; DHCP/routing alone did not prove AD readiness.
- RDP connectivity was validated from `HQ-DC01` during pilot testing.
- RDP authentication was validated with the NetBIOS format `GNTECH\admin.gnolasco`.
- Cloudflare Browser Rendering / IronRDP was successfully validated with `GNTECH\admin.gnolasco`.
- `HQ-MGMT01` successfully manages `HQ-W11-001` using WinRM.
- Kerberos authentication is used for PowerShell Remoting.
- `Test-WSMan`, `Invoke-Command`, and `Enter-PSSession` succeed.
- `IPv4Filter` is not an ACL; WinRM listener configuration is different from access authorization.
- Windows Defender Firewall, MikroTik firewall policy, VLAN segmentation, and Kerberos control WinRM access.
- RDP remains available for interactive administration while WinRM is preferred for remote administration and automation.
- Baseline privileged group assignment corrected so intended privileged accounts can administer as designed.
- `HQ-MGMT01` established as the initial Privileged Access Workstation.

Pilot findings belong in this implementation guide when they affect the deployment sequence or stop conditions. Do not create separate pilot documents for these lessons.

## Stop conditions

STOP if:

- `HQ-MGMT01` is not Windows 11 Enterprise.
- The VM was built as Windows Server.
- The VM is attached to VLAN 30 instead of VLAN 10.
- The golden template was domain joined before cloning.
- Cloudbase-Init first boot did not complete or password injection was not validated.
- DHCP/static addressing, DNS, or domain-controller reachability fails.
- Domain join occurs before network validation.
- The computer object is not in the Management Workstations OU.
- Group Policy cannot update or `gpresult` cannot be generated.
- RSAT tools do not install.
- Administration requires routine interactive logon to `HQ-DC01` instead of remote administration from `HQ-MGMT01`.

## Evidence Collection

Capture:

- Proxmox `qm config 120` showing `tag=10`.
- Cloudbase-Init service status and sanitized log tail.
- `ipconfig /all` showing Management VLAN addressing.
- DNS/SRV lookup output.
- Domain-controller connectivity output.
- Domain membership output.
- Management Workstations OU distinguished name output.
- `gpupdate /force` output.
- `gpresult /r` output and optional HTML GPResult showing `GP - Baseline - Management Workstations`.
- `whoami /groups` output.
- Registry policy output for Remote Desktop, NLA, and Script Block Logging.
- `TermService` status output.
- Windows Firewall Remote Desktop rule output.
- `Test-NetConnection localhost -Port 3389` output.
- WinRM validation output: `Test-NetConnection HQ-W11-001 -Port 5985`, `Test-WSMan HQ-W11-001`, `Invoke-Command`, and `Enter-PSSession`.
- Firewall/network evidence showing RDP is restricted to approved management paths.
- RSAT installed capability output.
- Remote administration validation output.
- RDP sign-in evidence using `GNTECH\admin.gnolasco`.
- Cloudflare Browser Rendering / IronRDP validation evidence when used.

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `HQ-MGMT01` is Windows Server | Wrong architecture applied | Rebuild from Windows 11 golden template. |
| Clone is already domain-joined | Template was joined or reused incorrectly | Rebuild the template as workgroup-only and generalized. |
| Cloudbase-Init did not set expected state | Metadata, ConfigDrive, or Cloudbase-Init plugin issue | Return to the Golden Template and Cloudbase-Init guides before domain join. |
| VLAN30 address assigned | VM NIC tag is wrong | Correct Proxmox NIC to `GEILLAN,tag=10`. |
| Domain join fails | DNS or AD firewall path missing from Management VLAN | Validate Active Directory Network Requirements and `ManagementNetworks` access to domain-controller services. |
| Computer lands in default Computers container | OU move step skipped or failed | Move to `OU=Management Workstations,OU=Computers,OU=GNTECH`. |
| Standard workstation GPO applies | Computer in wrong OU or GPO linked too broadly | Correct OU placement and GPO links before continuing. |
| `GP - Baseline - Management Workstations` does not apply | GPO missing, not linked, or computer remains in wrong OU | Create/link the GPO, move `HQ-MGMT01` to the Management Workstations OU, then run `gpupdate /force`. |
| RDP reachable too broadly | Firewall or network policy exposes management access outside approved paths | Restrict RDP at firewall/network layer; do not expose RDP to user, guest, or untrusted networks. |
| RSAT install fails | Windows Update/FoD source unavailable | Restore internet/update access or provide approved FoD source. |
| Admins still log on to servers interactively | Operational habit or missing tooling | Install RSAT/admin tools on `HQ-MGMT01` and document remote workflow. |

## Next Steps

Continue Microsoft Core deployment:

DNS / DHCP

↓

Group Policy

↓

File Services

↓

PKI

↓

NPS

↓

Entra Hybrid

## Deployment Verified

| Field | Value |
|---|---|
| Validated on | Pilot decision incorporated: `HQ-MGMT01` is Windows 11 Enterprise on Management VLAN 10, not Windows Server and not a standard user workstation. |
| Windows Server version | Not applicable; Windows Server is not the management workstation OS |
| RouterOS version | RouterOS v7 target through `HQ-FW01` |
| Proxmox version | Proxmox VE 9 target |
| Deployment date | 2026-07-01 pilot decision incorporated |
| Deployment notes | `HQ-MGMT01` is the initial PAW, Management Workstations OU member, and remote administration origin. |
| Known caveats | Future PAW hardening, LAPS, WHfB, Entra ID, JIT, JEA, Credential Guard, administrative hardening, and management firewall refinements should build on the validated `GP - Baseline - Management Workstations` model. |
