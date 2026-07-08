---
title: Windows LAPS Baseline
document_id: GEIL-MSC-WINSEC-LAPS-001
owner: Infrastructure Engineering
status: Approved
version: 1.1
last_reviewed: 2026-07-02
review_cycle: Quarterly
classification: Internal Confidential
---

# Windows LAPS Baseline

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-WINSEC-LAPS-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.1 |
| Last Reviewed | 2026-07-02 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This guide implements Windows LAPS as the enterprise solution for local Administrator password management in the GNTECH Microsoft Core baseline.

Windows LAPS is required for all domain-joined Windows client devices. It provides unique, automatically rotated local Administrator passwords backed up to Active Directory. Password retrieval and rotation are performed from approved management workstations, starting with `HQ-MGMT01`.

!!! warning "Use Windows LAPS only"

    Do not introduce Microsoft Legacy LAPS. GEIL uses the built-in Windows LAPS included in Windows Server 2025 and Windows 11 Enterprise.

## Scope

This baseline applies to:

- Standard Windows 11 Enterprise clients, starting with `HQ-W11-001`.
- Management workstations, starting with `HQ-MGMT01`.
- Future domain-joined Windows clients.

This document covers:

- Active Directory schema extension.
- OU permissions.
- Group Policy.
- Validation.
- Operational procedures.
- Troubleshooting.
- Security model.
- Windows client lifecycle integration.

Related documents:

- [Network and Active Directory Services Matrix](../../network/network-and-ad-services-matrix.md)
- [Active Directory Organizational Foundation](../active-directory-organizational-foundation.md)
- [Group Policy Baseline](../group-policy-baseline.md)
- [Windows Management Workstation](../windows-client-lifecycle/windows-11-management-workstation.md)
- [Windows Firewall Baseline](windows-firewall-baseline.md)

## Architecture

Windows LAPS uses Active Directory as the password backup directory for the current GNTECH lab design.

```text
Windows Client
↓
Windows LAPS policy
↓
Local Administrator password rotation
↓
Password backup to Active Directory
↓
Delegated retrieval from HQ-MGMT01
```

The management model is:

- Every workstation owns a unique local Administrator password.
- Passwords are never shared across devices.
- Passwords are automatically rotated.
- Passwords are stored securely in Active Directory.
- Only delegated administrators may retrieve passwords.
- Retrieval and rotation are performed from `HQ-MGMT01` or a future approved PAW.

## Validated deployment sequence

Pilot implementation validated this deployment order. Follow it exactly; do not validate a client before the schema, OU permissions, GPO creation, GPO links, and policy settings exist.

| Order | Step | Validation checkpoint |
|---:|---|---|
| 1 | Extend AD schema | `Update-LapsADSchema` completes without error. |
| 2 | Validate schema | `msLAPS-*` schema attributes exist. |
| 3 | Delegate Self permissions | Workstations and Management Workstations OUs allow computer Self updates. |
| 4 | Create `GP - Security - Windows LAPS` | GPO exists before any client validation. |
| 5 | Link GPO | GPO is linked to Workstations and Management Workstations OUs. |
| 6 | Configure Windows LAPS policy | Backup Directory and password policy settings are configured. |
| 7 | Run `gpupdate /force` | Client receives current Group Policy. |
| 8 | Run `Invoke-LapsPolicyProcessing` | Client processes Windows LAPS immediately. |
| 9 | Run `Get-LapsDiagnostics` | Diagnostics report successful policy processing and backup. |
| 10 | Validate password retrieval | `Get-LapsADPassword -Identity HQ-W11-001 -AsPlainText` succeeds from `HQ-MGMT01`. |

## Active Directory schema

Windows LAPS requires Active Directory schema support before domain-joined computers can back up local Administrator passwords to AD DS.

The schema extension is a one-time forest-level deployment step. It adds Windows LAPS attributes that allow computer objects to store password metadata and password material according to the configured policy.

Important attributes include:

| Attribute | Purpose |
|---|---|
| `msLAPS-PasswordExpirationTime` | Stores the password expiration timestamp. |
| `msLAPS-Password` | Stores the Windows LAPS password data when plaintext AD backup is used. |
| `msLAPS-EncryptedPassword` | Supports encrypted password storage when encryption is configured. |
| `msLAPS-EncryptedPasswordHistory` | Supports encrypted password history when enabled. |
| `msLAPS-EncryptedDSRMPassword` | Supports DSRM password backup scenarios for domain controllers when configured. |
| `msLAPS-EncryptedDSRMPasswordHistory` | Supports DSRM encrypted password history when enabled. |

Security implications:

- Schema extension enables sensitive password attributes on computer objects.
- Password retrieval must be delegated intentionally.
- Domain Admins and explicitly delegated groups can retrieve passwords according to AD permissions.
- Do not grant broad read access to LAPS password attributes.
- Treat password retrieval as privileged activity.

## Schema implementation

Run on: `HQ-MGMT01 or HQ-DC01 during bootstrap`

When: before configuring Windows LAPS GPO or expecting any client password backup.

Expected outcome: the Windows LAPS AD schema extension completes successfully.

```powershell
Import-Module LAPS
Update-LapsADSchema
```

## Schema validation

Run on: `HQ-MGMT01 or HQ-DC01 during bootstrap`

When: immediately after `Update-LapsADSchema` completes.

Expected outcome: Windows LAPS schema attributes are present in the forest schema.

```powershell
$SchemaNamingContext = (Get-ADRootDSE).schemaNamingContext

Get-ADObject `
    -SearchBase $SchemaNamingContext `
    -LDAPFilter "(lDAPDisplayName=msLAPS-PasswordExpirationTime)" `
    -Properties lDAPDisplayName

Get-ADObject `
    -SearchBase $SchemaNamingContext `
    -LDAPFilter "(lDAPDisplayName=msLAPS-Password)" `
    -Properties lDAPDisplayName
```

STOP if the schema attributes are missing. Do not continue to GPO deployment until the schema extension is validated.

## OU permissions

Windows LAPS clients must be allowed to update their own LAPS attributes on their computer objects. This is why the computer objects require Self permissions on the OUs where Windows LAPS applies.

Configure Self permissions for:

- `OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me`
- `OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me`

## OU permission implementation

Run on: `HQ-MGMT01 or HQ-DC01 during bootstrap`

When: after the Windows LAPS schema is extended and before clients process Windows LAPS policy.

Expected outcome: computer objects in the Workstations and Management Workstations OUs can update their own Windows LAPS password attributes.

```powershell
Import-Module LAPS

$TargetOUs = @(
    "OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me",
    "OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me"
)

foreach ($OU in $TargetOUs) {
    Set-LapsADComputerSelfPermission -Identity $OU
}
```

## OU permission validation

Run on: `HQ-MGMT01 or HQ-DC01 during bootstrap`

When: after applying Windows LAPS computer Self permissions.

Expected outcome: delegated extended rights are visible for the target OUs and do not show unexpected broad retrieval delegation.

```powershell
$TargetOUs = @(
    "OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me",
    "OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me"
)

foreach ($OU in $TargetOUs) {
    Find-LapsADExtendedRights -Identity $OU
}
```

Review this output before delegating password retrieval rights. Self permissions allow clients to back up their own passwords; they do not mean every user can retrieve passwords.

## Group Policy baseline

The GPO must exist before client validation. The validated policy object is:

```text
GP - Security - Windows LAPS
```

Validated links:

| Target OU | Purpose |
|---|---|
| `OU=Workstations,OU=Computers,OU=GNTECH,...` | Applies Windows LAPS to standard Windows clients such as `HQ-W11-001`. |
| `OU=Management Workstations,OU=Computers,OU=GNTECH,...` | Applies Windows LAPS to management workstations such as `HQ-MGMT01`. |

Do not begin `HQ-W11-001` client validation until this GPO exists, is linked, and has Windows LAPS policy settings configured.

## Group Policy configuration

Configure these Windows LAPS policy settings in `GP - Security - Windows LAPS`:

| Setting | Required value | Why |
|---|---|---|
| Backup Directory | Active Directory | Stores Windows LAPS password data in AD DS for domain-joined systems. |
| Password Length | 20 characters | Provides strong local Administrator passwords without creating unnecessary operational friction. |
| Password Complexity | Uppercase, lowercase, numbers, and special characters | Prevents weak or predictable local Administrator passwords. |
| Password Age | 30 days | Forces regular rotation without excessive churn. |
| Administrator Account | Built-in local Administrator account unless renamed in the Golden Image | Windows LAPS can manage the built-in Administrator account even if renamed. If a separate local admin account is created in the image, explicitly configure that account name. |
| Post Authentication Actions | Reset password and log off managed account | Reduces exposure after a retrieved password is used. |
| Post Authentication Action Delay | 8 hours | Allows emergency support work while ensuring the password is rotated after use. |

!!! note "Renamed local Administrator account"

    If the Golden Image renames the built-in local Administrator account, document the approved name in the Golden Template guide and configure the Windows LAPS policy accordingly. Do not create undocumented local admin account names.

## GPMC configuration

Run on: `HQ-MGMT01`

When: after schema extension and OU Self permissions are validated.

Expected outcome: `GP - Security - Windows LAPS` exists, is linked to the Workstations and Management Workstations OUs, and contains the validated Windows LAPS settings.

1. Open **Group Policy Management**.
2. Create `GP - Security - Windows LAPS` if it does not already exist.
3. Link it to:
   - `OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me`
   - `OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me`
4. Edit the GPO.
5. Navigate to **Computer Configuration > Administrative Templates > System > LAPS**.
6. Configure backup to Active Directory.
7. Configure password length, complexity, age, and post-authentication actions according to this baseline.
8. Close the editor and validate GPO links before testing a client.

## Validated PowerShell GPO workflow

This workflow creates and links the GPO. Use GPMC or a validated ADMX-backed method to configure the policy settings themselves; do not assume policy exists before this step.

Run on: `HQ-MGMT01 or HQ-DC01 during bootstrap`

When: after schema and OU permissions are complete and before client validation.

Expected outcome: `GP - Security - Windows LAPS` exists and is linked to the Workstations and Management Workstations OUs.

```powershell
Import-Module GroupPolicy

$GpoName = "GP - Security - Windows LAPS"
$Targets = @(
    "OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me",
    "OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me"
)

$Gpo = Get-GPO -Name $GpoName -ErrorAction SilentlyContinue
if (-not $Gpo) {
    $Gpo = New-GPO -Name $GpoName
    Write-Host "Created GPO: $GpoName"
}
else {
    Write-Host "GPO already exists: $GpoName"
}

foreach ($Target in $Targets) {
    $Links = (Get-GPInheritance -Target $Target).GpoLinks.DisplayName
    if ($Links -notcontains $GpoName) {
        New-GPLink -Name $GpoName -Target $Target -LinkEnabled Yes | Out-Null
        Write-Host "Linked $GpoName to $Target"
    }
    else {
        Write-Host "Link already exists: $Target"
    }
}

Get-GPO -Name $GpoName
```

Expected output includes the created or existing GPO and link status, for example:

```text
Created GPO: GP - Security - Windows LAPS
Linked GP - Security - Windows LAPS to OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me
Linked GP - Security - Windows LAPS to OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me
DisplayName      : GP - Security - Windows LAPS
GpoStatus        : AllSettingsEnabled
```

Run on: `HQ-MGMT01 or HQ-DC01 during bootstrap`

When: after creating and linking the GPO.

Expected outcome: both target OUs show `GP - Security - Windows LAPS` as a linked GPO.

```powershell
$GpoName = "GP - Security - Windows LAPS"
$Targets = @(
    "OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me",
    "OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me"
)

foreach ($Target in $Targets) {
    Get-GPInheritance -Target $Target |
        Select-Object -ExpandProperty GpoLinks |
        Where-Object { $_.DisplayName -eq $GpoName }
}
```

STOP if the GPO is missing or not linked. Correct Group Policy before running `gpupdate /force`, `Invoke-LapsPolicyProcessing`, or `Get-LapsDiagnostics` on a client.

## Security model

Windows LAPS changes local Administrator password management from a shared-secret model to a per-device secret model:

| Previous risk | Windows LAPS control |
|---|---|
| Shared local Administrator password across devices | Unique password per workstation. |
| Manual password rotation | Automatic policy-driven rotation. |
| Password reuse after support session | Post-authentication action resets password after use. |
| Unclear retrieval path | Delegated retrieval from `HQ-MGMT01`. |
| Excessive standing knowledge of passwords | Passwords are retrieved only when needed. |

Password retrieval should be delegated to a controlled administrative group. Helpdesk retrieval and Domain Admin retrieval must remain separate as the environment matures.

## Management workstation operations

`HQ-MGMT01` is the standard workstation used to retrieve and rotate Windows LAPS local Administrator passwords.

Run as:

```text
GNTECH\admin.gnolasco
```

Use [Authentication Standards](../authentication-standards.md) for identity format guidance.

### Retrieve password

Run on: `HQ-MGMT01`

When: a delegated administrator needs emergency or support access to a managed workstation.

Expected outcome: password metadata and password source are returned for the target computer.

```powershell
Get-LapsADPassword -Identity HQ-W11-001 -AsPlainText
```

Expected fields include:

- Password.
- Expiration Time.
- Source.

### Rotate password

Run on: `HQ-MGMT01`

When: a password was retrieved, exposed, used for emergency access, or needs immediate rotation.

Expected outcome: the target processes Windows LAPS policy and backs up a new password.

```powershell
Reset-LapsPassword -Identity HQ-W11-001
Invoke-LapsPolicyProcessing
Get-LapsADPassword -Identity HQ-W11-001 -AsPlainText
```

### Force local policy processing

Run on: `HQ-W11-001`

When: validating that the Windows LAPS client can process policy and back up a password.

Expected outcome: Windows LAPS policy processing completes and diagnostics show successful backup.

```powershell
gpupdate /force
Invoke-LapsPolicyProcessing
Get-LapsDiagnostics
```

## Windows client lifecycle integration

Windows LAPS becomes part of the Microsoft Core client lifecycle.

```text
Golden Image
↓
Cloudbase-Init
↓
Domain Join
↓
Move to OU
↓
Apply GPO
↓
Apply Windows LAPS
↓
Password Backup
↓
Validation
↓
Enterprise Ready
```

Lifecycle rules:

- The Golden Image remains workgroup-only.
- Do not domain join the Golden Image.
- Do not rely on a shared local Administrator password after domain join.
- Windows LAPS applies only after the computer is domain joined, moved to the correct OU, and receives `GP - Security - Windows LAPS`.
- `HQ-MGMT01` retrieves and rotates local Administrator passwords for managed clients.

## Validation on HQ-W11-001

Run on: `HQ-W11-001`

When: after domain join, OU placement, Self permissions, GPO creation, GPO link, and Windows LAPS policy configuration are complete.

Expected outcome: Group Policy refresh succeeds, Windows LAPS processes policy immediately, diagnostics show successful processing, and the password is backed up to Active Directory.

```powershell
gpupdate /force
Invoke-LapsPolicyProcessing
Get-LapsDiagnostics
```

Expected output includes successful Group Policy processing and Windows LAPS diagnostics without schema, permission, policy, or backup errors. The exact diagnostic text can vary by Windows build, but the result must show that policy was found and password backup succeeded.

Expected interpretation:

- `gpupdate /force` completes without policy processing errors.
- `Invoke-LapsPolicyProcessing` returns without error.
- `Get-LapsDiagnostics` shows Windows LAPS policy is applied.
- `Get-LapsDiagnostics` does not report missing schema attributes.
- `Get-LapsDiagnostics` does not report missing computer Self permissions.
- `Get-LapsDiagnostics` does not report missing or unconfigured policy.

STOP if diagnostics show that no Windows LAPS policy is configured. The GPO must exist and be linked before client validation.

## Validation from HQ-MGMT01

Run on: `HQ-MGMT01`

When: after `HQ-W11-001` reports successful Windows LAPS policy processing and password backup.

Expected outcome: delegated retrieval succeeds and returns the Windows LAPS password from Active Directory.

```powershell
Get-LapsADPassword -Identity HQ-W11-001 -AsPlainText
```

Expected output includes fields similar to:

```text
ComputerName        : HQ-W11-001
DistinguishedName   : CN=HQ-W11-001,OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me
Account             : Administrator
Password            : <managed-password>
ExpirationTimestamp : <timestamp>
Source              : EncryptedPassword or Password
```

The pilot validated successful password retrieval from `HQ-MGMT01` using:

```powershell
Get-LapsADPassword -Identity HQ-W11-001 -AsPlainText
```

## Rotation validation

Run on: `HQ-MGMT01`

When: validating that delegated administrators can force password rotation.

Expected outcome: password rotation is requested for the target computer.

```powershell
Reset-LapsPassword -Identity HQ-W11-001
```

Run on: `HQ-W11-001`

When: after rotation is requested from `HQ-MGMT01`.

Expected outcome: policy processing completes and the new password is backed up.

```powershell
Invoke-LapsPolicyProcessing
Get-LapsDiagnostics
```

Run on: `HQ-MGMT01`

When: after `HQ-W11-001` processes LAPS policy.

Expected outcome: password expiration metadata changes and retrieval still succeeds.

```powershell
Get-LapsADPassword -Identity HQ-W11-001 -AsPlainText
```

## Operations

### Retrieve password

Use `Get-LapsADPassword` from `HQ-MGMT01` when a delegated administrator needs local Administrator access for a specific managed computer.

### Rotate password

Use `Reset-LapsPassword` and `Invoke-LapsPolicyProcessing` after a password is retrieved, used, or suspected of exposure.

### Emergency access

Windows LAPS is the approved emergency local Administrator password source for domain-joined Windows clients. Use retrieval only when domain credentials, WinRM, RDP, or normal support paths are unavailable or insufficient.

### Password expiration

The baseline password age is 30 days. Emergency retrieval should be followed by rotation rather than waiting for normal expiration.

### Audit

Record password retrieval in the change ticket or incident record. As the environment matures, integrate Windows LAPS retrieval events into Windows Event Forwarding and SIEM monitoring.

### Recovery scenarios

Use Windows LAPS for:

- Lost domain trust troubleshooting.
- Network isolation recovery.
- Broken GPO or remote management recovery.
- Emergency access to a specific workstation.

Do not use Windows LAPS to create a routine shared local admin workflow.

## Troubleshooting

| Issue | Likely cause | Validation commands | Fix |
|---|---|---|---|
| Schema not updated | `Update-LapsADSchema` not run or failed | `Get-ADObject` schema queries for `msLAPS-*` attributes | Run `Update-LapsADSchema` and validate schema replication. |
| Self permissions missing | `Set-LapsADComputerSelfPermission` not run for target OU | `Find-LapsADExtendedRights -Identity <OU DN>` | Apply Self permissions to Workstations and Management Workstations OUs. |
| Password not backed up | GPO missing, permissions missing, client not processing policy, or wrong OU | `gpresult /r`; `Get-LapsDiagnostics`; `Get-ADComputer HQ-W11-001 -Properties msLAPS-PasswordExpirationTime` | Correct OU/GPO/permissions, then run `gpupdate /force` and `Invoke-LapsPolicyProcessing`. |
| GPO not applied | Computer in wrong OU or GPO link missing | `gpresult /r`; `Get-GPInheritance -Target <OU DN>` | Move computer to correct OU and link `GP - Security - Windows LAPS`. |
| Client not processing LAPS policy | Windows LAPS policy not configured, client build issue, or policy refresh pending | `Get-LapsDiagnostics`; Event Viewer LAPS logs | Correct policy and rerun `Invoke-LapsPolicyProcessing`. |
| Retrieval denied | Administrator lacks delegated rights | `Find-LapsADExtendedRights -Identity <OU DN>` | Delegate retrieval to the approved admin group; do not grant broad read access. |
| Wrong local admin account managed | Golden Image renamed account but policy does not specify it | Review local users and GPO setting for Administrator Account | Configure the approved local Administrator account name in policy. |

## Troubleshooting command reference

Run on: `HQ-MGMT01 or HQ-DC01 during bootstrap`

When: troubleshooting schema, OU permissions, or AD object state.

Expected outcome: schema attributes, extended rights, and computer password metadata can be inspected.

```powershell
$SchemaNamingContext = (Get-ADRootDSE).schemaNamingContext
Get-ADObject -SearchBase $SchemaNamingContext -LDAPFilter "(lDAPDisplayName=msLAPS-PasswordExpirationTime)"

Find-LapsADExtendedRights -Identity "OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me"
Find-LapsADExtendedRights -Identity "OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me"

Get-ADComputer HQ-W11-001 -Properties msLAPS-PasswordExpirationTime
```

Run on: `HQ-W11-001`

When: troubleshooting local policy processing.

Expected outcome: Group Policy and Windows LAPS diagnostics identify whether policy applied and password backup succeeded.

```powershell
gpupdate /force
gpresult /r
Invoke-LapsPolicyProcessing
Get-LapsDiagnostics
```

Run on: `HQ-MGMT01`

When: troubleshooting retrieval or rotation.

Expected outcome: delegated retrieval and rotation either succeed or return an authorization/policy error that identifies the failed layer.

```powershell
Get-LapsADPassword -Identity HQ-W11-001 -AsPlainText
Reset-LapsPassword -Identity HQ-W11-001
```

## Pilot Findings

- Windows LAPS replaces legacy Microsoft LAPS.
- The Windows LAPS module is present by default on Windows Server 2025.
- Active Directory schema extension is a one-time forest-level operation.
- The pilot successfully created the `msLAPS-*` schema attributes.
- Self permissions are mandatory before clients can back up passwords.
- Self permissions were validated for the Workstations and Management Workstations OUs.
- `GP - Security - Windows LAPS` must exist before any client validation.
- The GPO was validated when linked to the Workstations and Management Workstations OUs.
- `HQ-W11-001` successfully processed policy with `gpupdate /force` and `Invoke-LapsPolicyProcessing`.
- `Get-LapsDiagnostics` is the primary client-side validation command for policy and backup troubleshooting.
- `HQ-W11-001` successfully backed up its local Administrator password to Active Directory.
- `HQ-MGMT01` successfully retrieved the password with `Get-LapsADPassword -Identity HQ-W11-001 -AsPlainText`.
- Documentation now reflects the validated deployment sequence instead of assuming a pre-existing policy.
- Every workstation receives a unique local Administrator password.
- Password retrieval is performed from `HQ-MGMT01`.
- No manual password management is required after deployment.
- Windows LAPS belongs in the Microsoft Core baseline for all Windows client devices.
- The Golden Image can use a local Administrator password during staging, but domain-joined clones must transition to Windows LAPS after OU placement and GPO application.

## Baseline checklist

- [ ] Windows LAPS schema extension completed with `Update-LapsADSchema`.
- [ ] Schema attributes validated.
- [ ] Self permissions applied to Workstations OU.
- [ ] Self permissions applied to Management Workstations OU.
- [ ] `GP - Security - Windows LAPS` created.
- [ ] GPO linked to Workstations OU.
- [ ] GPO linked to Management Workstations OU.
- [ ] Backup Directory set to Active Directory.
- [ ] Password length set to 20 characters.
- [ ] Password complexity includes uppercase, lowercase, numbers, and special characters.
- [ ] Password age set to 30 days.
- [ ] Administrator account handling documented for renamed Golden Image accounts.
- [ ] Post-authentication actions configured to reset password and log off after 8 hours.
- [ ] `gpupdate /force` completed on `HQ-W11-001`.
- [ ] `Invoke-LapsPolicyProcessing` completed on `HQ-W11-001`.
- [ ] `Get-LapsDiagnostics` shows successful Windows LAPS policy processing.
- [ ] `HQ-W11-001` successfully backs up a Windows LAPS password.
- [ ] `HQ-MGMT01` can retrieve the password with `Get-LapsADPassword -Identity HQ-W11-001 -AsPlainText`.
- [ ] `HQ-MGMT01` can retrieve and rotate the password using delegated rights.

## Future improvements

As the lab matures, add:

- Dedicated delegated retrieval groups for helpdesk and workstation administrators.
- Formal audit event forwarding for password retrieval.
- Integration with Windows Event Forwarding.
- Tier-specific retrieval roles.
- Entra ID / hybrid Windows LAPS scenarios if cloud backup is later adopted.
- Privileged Access Workstation enforcement for all retrieval activity.
