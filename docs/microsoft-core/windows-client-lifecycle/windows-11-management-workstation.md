---
title: Windows 11 Management Workstation
document_id: GEIL-PLAT-W11-MGMT-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
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
| Version | 1.0 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

!!! note "Canonical GNTECH values"

    `HQ-MGMT01` is the Windows 11 Enterprise management workstation / initial privileged access workstation on the Management network, VLAN 10. `HQ-W11-001` is the standard Windows 11 Enterprise client validation VM on the Workstations network, VLAN 30. They have different security purposes and must not share the same workstation security boundary.

!!! warning "Do not use Windows Server as a daily admin workstation"

    Windows Server hosts infrastructure roles. Routine administration must originate from `HQ-MGMT01` or a future approved PAW/jump path. Avoid routine interactive logons to `HQ-DC01` and future servers except for bootstrap, recovery, or approved break-glass work.

## Purpose

Deploy `HQ-MGMT01` from the Windows 11 Enterprise golden template as the dedicated management workstation and initial PAW for GEIL. This guide defines how `HQ-MGMT01` differs from `HQ-W11-001`, how it joins the domain after cloning, and how RSAT/admin tools are installed for remote administration.

## Design decision

Pilot deployment established this model:

| Host | Operating System | Role | Intended use |
|---|---|---|---|
| `HQ-MGMT01` | Windows 11 Enterprise | Dedicated management workstation / initial PAW | VLAN 10 management endpoint for privileged administration with RSAT/admin tools |
| `HQ-W11-001` | Windows 11 Enterprise | Standard client validation VM | VLAN 30 user/client validation, DHCP, domain join, GPO, endpoint policy |

`HQ-MGMT01` is not Windows Server and is not a standard user workstation. It is a hardened Management VLAN workstation used to administer `HQ-DC01`, `HQ-FW01`, `PVE-HQ01`, switches, file servers, and future infrastructure services remotely. Only management workstations belong on VLAN 10; standard user workstations remain on VLAN 30.

## Rationale

- Remote administration from a hardened workstation reduces routine interactive logons to servers.
- The model supports administrative tiering by giving privileged accounts a known administrative endpoint.
- It prepares GEIL for PAW hardening, LAPS, Windows Hello for Business, Microsoft Entra ID, Just-in-Time access, and Just Enough Administration.
- It keeps `HQ-W11-001` and future user workstations on VLAN 30 as standard clients instead of overloading them with privileged tooling.
- Pilot validation demonstrated that a dedicated management workstation should be isolated from user networks and prepared for future PAW implementation.

## Prerequisites

- [Windows 11 Enterprise Golden Template](windows-11-enterprise-golden-template.md) completed and validated as workgroup-only.
- [Active Directory Network Requirements](../../platform/active-directory-network-requirements.md) implemented.
- [Windows 11 Domain Join and GPO Validation](windows-11-domain-join-gpo-validation.md) reviewed for common clone/domain-join validation flow.
- VLAN 10 Management network addressing, DNS, and domain-controller access are operational for `HQ-MGMT01`.
- Domain join credentials are approved for the change window.

## Deployment sequence

1. Clone `HQ-MGMT01` from `TPL-W11-ENT-GOLD`.
2. Attach the clone to `GEILLAN` VLAN 10.
3. Validate DHCP, DNS, and domain-controller access.
4. Confirm or set hostname `HQ-MGMT01`.
5. Join `corp.gntech.me` after cloning and validation.
6. Move the computer object to `OU=Management Workstations,OU=Computers,OU=GNTECH`.
7. Install RSAT/admin tools plus PowerShell 7, Windows Terminal, Visual Studio Code, and Git.
8. Use `HQ-MGMT01` for remote administration of `HQ-DC01`, future servers, `HQ-FW01`, `PVE-HQ01`, switches, and infrastructure services.

## Step 1: Clone from the golden template

Run from `PVE-HQ01`:

```bash
qm clone 9201 120 --name HQ-MGMT01 --full true
qm set 120 --net0 virtio,bridge=GEILLAN,tag=10
qm set 120 --agent enabled=1
qm start 120
```

Validate:

```bash
qm config 120
```

Expected result: `name: HQ-MGMT01`, `bridge=GEILLAN`, and `tag=10`.

## Step 2: Validate Management VLAN 10 addressing and DNS

Run inside `HQ-MGMT01` before domain join:

```powershell
ipconfig /renew
ipconfig /all
Resolve-DnsName corp.gntech.me -Server 172.20.20.11
Resolve-DnsName _ldap._tcp.dc._msdcs.corp.gntech.me -Type SRV -Server 172.20.20.11
```

Expected result:

- IPv4 address is `172.20.10.10` by reservation/static assignment or a valid VLAN10 management lease during staging.
- Default gateway is `172.20.10.1`.
- DNS server is `172.20.20.11`.
- SRV lookup discovers `HQ-DC01`.

STOP if DHCP or DNS fails. Do not join the domain until network validation passes.

## Step 3: Validate domain-controller firewall access

Run inside `HQ-MGMT01`:

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

Expected result: domain-controller services are reachable through the address-list based firewall policy.

## Step 4: Confirm hostname and join domain

Run inside `HQ-MGMT01`:

```powershell
$DesiredName = "HQ-MGMT01"
if ($env:COMPUTERNAME -ne $DesiredName) {
    Rename-Computer -NewName $DesiredName -Restart
}
else {
    [PSCustomObject]@{Status="Existing"; Name=$env:COMPUTERNAME}
}
```

After restart, join the domain:

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

## Step 5: Install RSAT and administration tools

After domain join, move `HQ-MGMT01` into the dedicated Management Workstations OU from `HQ-MGMT01` or another approved administrative endpoint:

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
```

Run inside `HQ-MGMT01` after domain join:

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

Expected result: required RSAT capabilities show `Installed`, and PowerShell 7, Windows Terminal, Visual Studio Code, and Git are available for approved administration and documentation workflows.

## Step 6: Validate remote administration

Run inside `HQ-MGMT01` with approved privileged credentials:

```powershell
Get-Command Get-ADDomain
Get-Command Get-GPO
Resolve-DnsName HQ-DC01.corp.gntech.me
Test-NetConnection HQ-DC01.corp.gntech.me -Port 3389
Test-NetConnection HQ-DC01.corp.gntech.me -Port 5985
Test-NetConnection 172.20.100.11 -Port 8006
Test-NetConnection 172.20.10.1 -Port 8291
```

Expected result: RSAT cmdlets are available, DNS resolves, and approved management ports are reachable when enabled by policy.

## Stop conditions

STOP if:

- `HQ-MGMT01` is not Windows 11 Enterprise.
- The VM was built as Windows Server.
- The VM is attached to VLAN 30 instead of VLAN 10.
- The golden template was domain joined before cloning.
- DHCP/static addressing, DNS, or domain-controller reachability fails.
- RSAT tools do not install.
- Administration requires routine interactive logon to `HQ-DC01` instead of remote administration from `HQ-MGMT01`.

## Evidence Collection

Capture:

- Proxmox `qm config 120` showing `tag=10`.
- `ipconfig /all` showing Management VLAN addressing.
- DNS/SRV lookup output.
- Domain-controller connectivity output.
- Domain membership output.
- RSAT installed capability output.
- Remote administration validation output.

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `HQ-MGMT01` is Windows Server | Wrong architecture applied | Rebuild from Windows 11 golden template. |
| Domain join fails | DNS or AD firewall path missing from Management VLAN | Validate Active Directory Network Requirements and ManagementNetworks access to domain-controller services. |
| RSAT install fails | Windows Update/FoD source unavailable | Restore internet/update access or provide approved FoD source. |
| Admins still log on to servers interactively | Operational habit or missing tooling | Install RSAT/admin tools on `HQ-MGMT01` and document remote workflow. |

## Next Guide

Use `HQ-MGMT01` to administer Microsoft Core guides such as Active Directory organizational foundation, DNS/DHCP, Group Policy, PKI, NPS, and Windows Admin Center.

## Deployment Verified

| Field | Value |
|---|---|
| Validated on | Pilot decision incorporated: `HQ-MGMT01` is Windows 11 Enterprise on Management VLAN 10, not Windows Server and not a standard user workstation. |
| Windows Server version | Not applicable; Windows Server is not the management workstation OS |
| RouterOS version | RouterOS v7 target through `HQ-FW01` |
| Proxmox version | Proxmox VE 9 target |
| Deployment date | 2026-07-01 pilot decision incorporated |
| Deployment notes | `HQ-MGMT01` is the initial PAW, Management Workstations OU member, and remote administration origin. |
| Known caveats | Future PAW hardening, LAPS, WHfB, Entra ID, JIT, and JEA controls should build on this model. |
