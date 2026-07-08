---
title: Enterprise Service Account Standard
document_id: GEIL-MSC-SVCACCT-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-30
review_cycle: Quarterly
classification: Internal Confidential
---

# Enterprise Service Account Standard

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-SVCACCT-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-30 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

!!! note "Canonical GNTECH values"

    Forest: `corp.gntech.me`; NetBIOS: `GNTECH`; primary UPN suffix: `gntech.me`; Microsoft 365 primary domain: `gntech.me`; hybrid identity plane: Microsoft Entra ID; primary firewall: MikroTik CHR `HQ-FW01`.


## Purpose

Define how GEIL creates, stores, rotates, validates, monitors, and retires non-human identities, including standard service accounts, group Managed Service Accounts, scheduled tasks, IIS, SQL, NPS, Entra Connect, backup, monitoring, scan, and print services.

## Architecture Overview

```mermaid
flowchart TD
    Request[Approved service need] --> Type[Choose gMSA or standard]
    Type --> OU[Place in Service Accounts OU]
    OU --> Rights[Grant least privilege]
    Rights --> Validate[Validate service function]
    Validate --> Monitor[Monitor and rotate]
```

## Account types

| Type | Use | Example | Preferred? |
|---|---|---|---|
| gMSA | Windows services supporting managed password | `gmsa-wac` | Yes, when supported. |
| Standard service account | Products that cannot use gMSA | `svc-backup` | Use only with controls. |
| Scheduled task account | Tasks requiring domain access | `svc-monitoring` | Prefer gMSA where supported. |
| Product-required account | Entra Connect or vendor-specific | `svc-entra-connect` | Follow vendor/Microsoft guidance. |

## Least privilege rules

- Never make service accounts Domain Admins by default.
- Deny interactive logon unless explicitly required.
- Store credentials only in the approved password manager.
- Assign permissions through groups where practical.
- Service accounts are not part of the pilot Tier 0 bootstrap membership model; never place service accounts in `GG-T0-Domain-Admins` or `Domain Admins`.
- Document owner, purpose, system, rotation interval, and rollback.

## PowerShell: create a standard service account

Run on: `HQ-MGMT01 unless this is an initial bootstrap step that explicitly requires HQ-DC01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Import-Module ActiveDirectory
$DomainDN = (Get-ADDomain).DistinguishedName

$CurrentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$CurrentGroups = foreach ($Sid in $CurrentIdentity.Groups) {
    try {
        $Sid.Translate([Security.Principal.NTAccount]).Value
    }
    catch {}
}

$AllowedGroupNames = @(
    "Domain Admins",
    "Enterprise Admins"
)

$CurrentGroupShortNames = $CurrentGroups | ForEach-Object {
    ($_ -split "\\")[-1]
}

if (-not ($CurrentGroupShortNames | Where-Object { $_ -in $AllowedGroupNames })) {
    throw "Current user '$($CurrentIdentity.Name)' lacks approved permissions. Required group short name: $($AllowedGroupNames -join ', ')."
}
$SvcOU = "OU=Standard,OU=Service Accounts,OU=GNTECH,$DomainDN"
$Password = Read-Host "Enter service account password" -AsSecureString

$ParentOU = $SvcOU -replace '^OU=[^,]+,',''
$SvcOUObject = Get-ADOrganizationalUnit `
    -LDAPFilter '(ou=Standard)' `
    -SearchBase $ParentOU `
    -SearchScope OneLevel `
    -ErrorAction Stop
if (-not $SvcOUObject) {
    throw "Required OU missing: $SvcOU. Complete the Organizational Foundation guide first."
}

$ExistingAccount = Get-ADUser -LDAPFilter '(sAMAccountName=svc-monitoring)' -ErrorAction Stop
if ($ExistingAccount) {
    Set-ADUser -Identity $ExistingAccount.DistinguishedName -PasswordNeverExpires $false
    [PSCustomObject]@{Status="Exists"; Sam="svc-monitoring"; DN=$ExistingAccount.DistinguishedName}
}
else {
    $NewAccount = New-ADUser -Name "svc-monitoring" -SamAccountName "svc-monitoring" -UserPrincipalName "svc-monitoring@gntech.me" `
        -Path $SvcOU -AccountPassword $Password -Enabled $true -Description "Monitoring service account; least privilege only" -PassThru
    Set-ADUser -Identity $NewAccount.DistinguishedName -PasswordNeverExpires $false
    [PSCustomObject]@{Status="Created"; Sam="svc-monitoring"; DN=$NewAccount.DistinguishedName}
}
```

## PowerShell: create a gMSA

Prerequisite: KDS root key exists. In a new lab, create it only after understanding replication timing.

Run on: `HQ-MGMT01 unless this is an initial bootstrap step that explicitly requires HQ-DC01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) { throw "Required module missing: ActiveDirectory" }
Import-Module ActiveDirectory -ErrorAction Stop

$DomainDN = (Get-ADDomain).DistinguishedName
$GmsaOU = "OU=gMSA,OU=Service Accounts,OU=GNTECH,$DomainDN"
$GmsaName = "gmsa-wac"
$AllowedGroup = "GG-T1-Server-Admins"
$Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssK"

$CurrentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$CurrentGroups = foreach ($Sid in $CurrentIdentity.Groups) {
    try {
        $Sid.Translate([Security.Principal.NTAccount]).Value
    }
    catch {}
}

$AllowedGroupNames = @(
    "Domain Admins",
    "Enterprise Admins"
)

$CurrentGroupShortNames = $CurrentGroups | ForEach-Object {
    ($_ -split "\\")[-1]
}

if (-not ($CurrentGroupShortNames | Where-Object { $_ -in $AllowedGroupNames })) {
    throw "Current user '$($CurrentIdentity.Name)' lacks approved permissions. Required group short name: $($AllowedGroupNames -join ', ')."
}

if (-not (Get-ADObject -Identity $GmsaOU -ErrorAction SilentlyContinue)) {
    throw "Required OU missing: $GmsaOU. Complete the Organizational Foundation guide first."
}
if (-not (Get-ADGroup -LDAPFilter "(sAMAccountName=$AllowedGroup)" -ErrorAction Stop)) {
    throw "Required group missing: $AllowedGroup. Complete group strategy before creating this gMSA."
}
if (-not (Get-KdsRootKey)) {
    throw "KDS root key is missing. Create it under approved change control and allow normal replication before creating production gMSAs."
}

$Existing = Get-ADServiceAccount -LDAPFilter "(sAMAccountName=$GmsaName`$)" -ErrorAction Stop
if ($Existing) {
    [PSCustomObject]@{Status="Existing"; Name=$GmsaName; DistinguishedName=$Existing.DistinguishedName; Parent=$GmsaOU; Timestamp=$Timestamp}
}
else {
    $New = New-ADServiceAccount -Name $GmsaName -DNSHostName "$GmsaName.corp.gntech.me" `
        -PrincipalsAllowedToRetrieveManagedPassword $AllowedGroup `
        -Path $GmsaOU `
        -PassThru
    [PSCustomObject]@{Status="Created"; Name=$GmsaName; DistinguishedName=$New.DistinguishedName; Parent=$GmsaOU; Timestamp=$Timestamp}
}
```

## Service-specific guidance

| Service | Recommended identity | Notes |
|---|---|---|
| IIS app pool | gMSA | Bind to approved web servers only. |
| SQL service | gMSA where supported | Coordinate SPNs. |
| NPS | Built-in service or gMSA if required | Do not overprivilege. |
| Entra Connect | Microsoft guidance | Treat as Tier 0. |
| Backup | gMSA if product supports it | Otherwise `svc-backup` with scoped rights. |
| Monitoring | gMSA or `svc-monitoring` | Read-only where possible. |
| Scheduled Tasks | gMSA where supported | Avoid storing passwords in task XML. |
| Scan/print | `svc-scan`, `svc-print` only if required | Restrict logon and permissions. |

## Validation

Run on: `HQ-MGMT01 unless this is an initial bootstrap step that explicitly requires HQ-DC01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Get-ADUser -Filter 'SamAccountName -like "svc-*"' -SearchBase "OU=Service Accounts,OU=GNTECH,$((Get-ADDomain).DistinguishedName)" `
    -Properties Enabled,PasswordLastSet,PasswordNeverExpires,Description |
    Select-Object SamAccountName,Enabled,PasswordLastSet,PasswordNeverExpires,Description
Get-ADServiceAccount -Filter * -SearchBase "OU=gMSA,OU=Service Accounts,OU=GNTECH,$((Get-ADDomain).DistinguishedName)" |
    Select-Object Name,Enabled,DistinguishedName
```

## Expected result

Service accounts are in the Service Accounts OU, use `@gntech.me`, have documented descriptions, and have no unnecessary privileged group membership.

## Stop conditions

STOP if a service account requires Domain Admin, interactive logon, broad file access, or password never expires without documented approval.

## Rollback

Disable first:

Run on: `HQ-MGMT01 unless this is an initial bootstrap step that explicitly requires HQ-DC01`

When: execute at this point in the procedure after the stated prerequisites are true and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms the change.

```powershell
Disable-ADAccount -Identity "svc-monitoring"
```

Delete only after confirming no service, scheduled task, SPN, ACL, certificate enrollment, sync connector, or monitoring probe depends on it.

## Evidence Collection

Capture account properties, group membership, service owner, service binding, rotation record, and validation output. Do not capture passwords.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Service fails after password rotation | Credential not updated or gMSA unsupported | Update credential or migrate to supported gMSA. |
| Kerberos fails | Missing SPN | Register correct SPN under change control. |
| Excessive privileges found | Emergency shortcut became permanent | Remove membership and document replacement permission. |

## Next Guide

Continue to [Enterprise Administrative Tiering](../legacy/security/administrative-tiering.md).
