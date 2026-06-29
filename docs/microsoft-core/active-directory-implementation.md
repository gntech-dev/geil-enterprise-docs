---
title: Active Directory Implementation
document_id: GEIL-MSC-AD-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Active Directory Implementation

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-AD-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Deploy a production Active Directory forest for GEIL environments.

## Prerequisites

- Approved AD DNS namespace `<AD_DOMAIN_FQDN>`.
- Static IP addresses for at least two domain controllers.
- Windows Server 2025 baseline complete.
- Time source identified.
- Tier 0 admin account available.

## Forest creation

Run only on the first domain controller.

```powershell
Install-WindowsFeature AD-Domain-Services,DNS -IncludeManagementTools
Install-ADDSForest `
  -DomainName "<AD_DOMAIN_FQDN>" `
  -DomainNetbiosName "<NETBIOS_NAME>" `
  -ForestMode WinThreshold `
  -DomainMode WinThreshold `
  -InstallDNS `
  -NoRebootOnCompletion:$false
```

Expected result: server reboots as the first domain controller and hosts AD-integrated DNS.

## Add second domain controller

```powershell
Install-WindowsFeature AD-Domain-Services,DNS -IncludeManagementTools
Install-ADDSDomainController `
  -DomainName "<AD_DOMAIN_FQDN>" `
  -InstallDns `
  -NoGlobalCatalog:$false `
  -NoRebootOnCompletion:$false
```

## Organizational unit baseline

```powershell
$Base = "DC=<DOMAIN_COMPONENTS>"
"Admin","Servers","Workstations","Groups","Service Accounts","Disabled Objects" | ForEach-Object {
    New-ADOrganizationalUnit -Name $_ -Path $Base -ProtectedFromAccidentalDeletion $true
}
```

## Validation

```powershell
dcdiag /v
repadmin /replsummary
Get-ADDomainController -Filter * | Select HostName,Site,IsGlobalCatalog
Get-ADDomain | Select DNSRoot,DomainMode,PDCEmulator,RIDMaster,InfrastructureMaster
```

Expected result: no critical DCDIAG failures, replication successful, and FSMO roles identified.

## Rollback

If first DC promotion fails before production use, rebuild the VM and recreate the forest. If a second DC promotion fails, demote using `Uninstall-ADDSDomainController`, remove stale metadata if required, fix DNS/time, then retry.

## Security considerations

- Rename or disable default Administrator only after emergency access is confirmed.
- Use separate Tier 0 accounts.
- Do not browse the internet from domain controllers.
- Do not install non-infrastructure applications on domain controllers.
