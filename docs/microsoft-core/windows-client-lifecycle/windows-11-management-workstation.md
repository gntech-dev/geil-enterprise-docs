---
title: Windows 11 Management Workstation
document_id: GEIL-PLAT-W11-MGMT-001
owner: Infrastructure Engineering
status: Approved
version: 1.1
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
| Version | 1.1 |
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
- [Group Policy Baseline](../group-policy-baseline.md) reviewed. The future `GP - Baseline - Management Workstations` is architecture only until validated.
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
10. Validate applied GPOs.
11. Install RSAT and administration tools.
12. Final validation.

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

Confirm that `HQ-MGMT01` is in the correct OU, that expected baseline policies apply, and that future management-workstation policy is clearly understood as upcoming architecture.

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
- Expected baseline domain policies are visible in `gpresult`.
- No standard workstation-only policy is incorrectly applied to `HQ-MGMT01`.
- `GP - Baseline - Management Workstations` is noted as upcoming/future unless it has been explicitly validated and linked in a later change.
- `whoami /groups` shows expected domain identity context for the signed-in account.

### Stop Conditions

STOP if the computer remains in the default `Computers` container, lands in `OU=Workstations`, cannot read SYSVOL/NETLOGON, or receives standard workstation policy incorrectly.

### Evidence

Capture `gpresult /r`, `whoami /groups`, optional HTML GPResult, and AD distinguished name output.

## Step 11: Install RSAT and administration tools

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

## Step 12: Final validation

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

- Golden Template remains in Workgroup.
- Domain Join occurs only after cloning.
- Cloudbase-Init password injection validated.
- Management VLAN architecture adopted for `HQ-MGMT01`.
- Dedicated `OU=Management Workstations,OU=Computers,OU=GNTECH` introduced.
- Baseline privileged group assignment corrected so intended privileged accounts can administer as designed.
- Active Directory firewall rules required adjustment; DHCP/routing alone did not prove AD readiness.
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
- `gpresult /r` output and optional HTML GPResult.
- `whoami /groups` output.
- RSAT installed capability output.
- Remote administration validation output.

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
| Known caveats | Future PAW hardening, LAPS, WHfB, Entra ID, JIT, JEA, and `GP - Baseline - Management Workstations` controls should build on this model after validation. |
