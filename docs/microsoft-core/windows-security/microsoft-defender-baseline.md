---
title: Microsoft Defender Enterprise Baseline
document_id: GEIL-MSC-WINSEC-DEF-001
owner: Infrastructure Engineering
status: Approved
version: 1.1
last_reviewed: 2026-07-07
review_cycle: Quarterly
classification: Internal Confidential
---

# Microsoft Defender Enterprise Baseline

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-WINSEC-DEF-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.1 |
| Last Reviewed | 2026-07-07 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This guide establishes Microsoft Defender Antivirus as the standard endpoint protection platform for Microsoft Core Windows client devices in the GNTECH lab.

This baseline is limited to the built-in Microsoft Defender Antivirus managed through Active Directory Group Policy. It does not configure Microsoft Defender for Endpoint, Microsoft Defender XDR, Intune, Microsoft 365 Defender, or cloud security portal policy.

## Scope

This baseline applies to:

- Standard Windows 11 Enterprise clients, starting with `HQ-W11-001`.
- Management workstations, starting with `HQ-MGMT01`.
- Future domain-joined Windows client devices managed by Microsoft Core Group Policy.

This baseline does not apply to:

- Microsoft Defender for Endpoint onboarding.
- Intune security baselines.
- Microsoft 365 Defender portal policy.
- Server-specific endpoint protection tuning.
- SIEM or XDR integration.

Related Microsoft Core documents:

- [Group Policy Baseline](../group-policy-baseline.md)
- [Windows Client Lifecycle](../windows-client-lifecycle/index.md)
- [Standard Windows Client - HQ-W11-001](../windows-client-lifecycle/standard-windows-client-hq-w11-001.md)
- [Windows Management Workstation - HQ-MGMT01](../windows-client-lifecycle/windows-11-management-workstation.md)
- [Windows Firewall Baseline](windows-firewall-baseline.md)
- [Windows LAPS Baseline](windows-laps-baseline.md)

## Architecture

Microsoft Defender Antivirus is the default endpoint protection layer for Windows client devices.

```text
Active Directory Group Policy
↓
GP - Security - Microsoft Defender
↓
Workstations and Management Workstations OUs
↓
Windows Defender Antivirus settings
↓
Client validation with PowerShell
```

Baseline goals:

- Keep Microsoft Defender Antivirus enabled on managed Windows clients.
- Enable real-time protection and behavior monitoring.
- Use cloud-delivered protection where internet access is available.
- Allow automatic sample submission in a controlled enterprise posture.
- Enable Potentially Unwanted Application protection.
- Run Network Protection in Audit mode during the lab phase.
- Keep security intelligence updated.
- Validate policy and health with PowerShell.

## Validated deployment workflow

The GEIL laboratory validated Microsoft Defender Antivirus on this infrastructure:

- `HQ-DC01`
- `HQ-MGMT01`
- `HQ-W11-001`

Validated implementation sequence:

| Order | Step | Validation checkpoint |
|---:|---|---|
| 1 | Create `GP - Security - Microsoft Defender` | GPO exists in Group Policy Management. |
| 2 | Link GPO | GPO is linked to Workstations and Management Workstations OUs. |
| 3 | Configure Defender policy | Defender Antivirus settings match the validated baseline. |
| 4 | Run `gpupdate /force` | Client processes updated computer policy. |
| 5 | Validate GPO | `gpresult /r /scope computer` shows the Defender GPO applied. |
| 6 | Validate Defender health | `Get-MpComputerStatus` shows Defender enabled and healthy. |
| 7 | Update signatures | `Update-MpSignature` completes successfully. |
| 8 | Enterprise Ready | Client passes endpoint protection validation before final workstation acceptance. |

Documentation now reflects the validated deployment sequence rather than a theoretical or manual-only deployment.

## Group Policy object

Create and link this GPO:

```text
GP - Security - Microsoft Defender
```

Validated targets:

| Target OU | Purpose |
|---|---|
| `OU=Workstations,OU=Computers,OU=GNTECH,...` | Applies Defender Antivirus baseline to standard Windows clients such as `HQ-W11-001`. |
| `OU=Management Workstations,OU=Computers,OU=GNTECH,...` | Applies Defender Antivirus baseline to management workstations such as `HQ-MGMT01`. |

Do not link this GPO to Domain Controllers or member servers until server-specific Defender requirements are documented.

## GPMC configuration

Run on: `HQ-MGMT01`

When: after the Workstations and Management Workstations OUs exist and Group Policy Management is available.

Expected outcome: `GP - Security - Microsoft Defender` exists, is linked to the Workstations and Management Workstations OUs, and contains the configured Microsoft Defender Antivirus baseline.

1. Open **Group Policy Management**.
2. Create `GP - Security - Microsoft Defender` if it does not already exist.
3. Link it to:
   - `OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me`
   - `OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me`
4. Edit the GPO.
5. Configure Microsoft Defender Antivirus policy settings under **Computer Configuration > Administrative Templates > Microsoft Defender Antivirus**.
6. Configure Network Protection under **Microsoft Defender Antivirus > Microsoft Defender Exploit Guard > Network Protection**.
7. Close the editor and validate GPO links before testing a client.

## PowerShell GPO creation workflow

This workflow creates and links the GPO. Configure Defender policy settings in GPMC unless registry-backed settings have been separately validated in the lab.

Run on: `HQ-MGMT01 or HQ-DC01 during bootstrap`

When: before pilot validation on `HQ-W11-001`.

Expected outcome: `GP - Security - Microsoft Defender` exists and is linked to Workstations and Management Workstations OUs.

```powershell
Import-Module GroupPolicy

$GpoName = "GP - Security - Microsoft Defender"
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

Expected output includes:

```text
Created GPO: GP - Security - Microsoft Defender
Linked GP - Security - Microsoft Defender to OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me
Linked GP - Security - Microsoft Defender to OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me
DisplayName      : GP - Security - Microsoft Defender
GpoStatus        : AllSettingsEnabled
```

## Baseline configuration

Configure the following settings in `GP - Security - Microsoft Defender`.

| Control | Validated setting | Why |
|---|---|---|
| Microsoft Defender Antivirus | Enabled | Establishes built-in Microsoft endpoint protection as the default client protection layer. |
| Real-time protection | Enabled | Blocks malware activity as files and processes are accessed. |
| Behavior monitoring | Enabled | Detects suspicious behavior that may not match a static signature. |
| IOAV protection | Enabled | Scans downloaded files and attachments as they are accessed. |
| Cloud-delivered protection | Enabled | Improves detection using Microsoft cloud intelligence when internet access is available. |
| MAPS reporting | Advanced membership (`2`) | Enables enhanced cloud-delivered protection telemetry for Defender Antivirus. |
| Automatic sample submission | Safe samples (`1`) | Allows safe samples to be submitted automatically while limiting unnecessary operator prompts. |
| PUA Protection | Enabled (`1`) | Blocks potentially unwanted applications often seen in browser/download abuse. |
| Network Protection | Audit mode (`2`) | Records risky network destinations without blocking lab workflows during pilot validation. |
| Tamper Protection | Enabled | Validated as enabled on the pilot client; continue to record state because full enforcement is not an on-premises GPO-only control. |
| Security intelligence updates | Enabled and automatic | Keeps signatures current without relying on manual operator action. |
| Scheduled quick scan | Daily | Provides routine lightweight endpoint coverage. |
| Scheduled full scan | Weekly or operationally scheduled | Provides deeper periodic coverage without disrupting daily use. |

## Recommended policy values

| Policy area | Setting | Validated value |
|---|---|---|
| Microsoft Defender Antivirus | Turn off Microsoft Defender Antivirus | Disabled |
| Real-time Protection | Turn off real-time protection | Disabled |
| Real-time Protection | Turn on behavior monitoring | Enabled |
| Real-time Protection | Scan all downloaded files and attachments | Enabled |
| MAPS | Join Microsoft MAPS | Advanced membership (`2`) |
| MAPS | Send file samples when further analysis is required | Safe samples (`1`) |
| Microsoft Defender Antivirus | Configure detection for potentially unwanted applications | Enabled / Block (`1`) |
| Microsoft Defender Exploit Guard > Network Protection | Prevent users and apps from accessing dangerous websites | Audit mode (`2`) |
| Security Intelligence Updates | Define the order of sources for updates | Microsoft Update, WSUS if later deployed |
| Scan | Check for the latest virus and spyware security intelligence before running a scheduled scan | Enabled |
| Scan | Specify the scan type to use for a scheduled scan | Quick scan for routine daily schedule |

## Tamper Protection limitations

Tamper Protection validated as enabled on the pilot client. It remains important to document it as an observed endpoint protection state because complete Tamper Protection enforcement is not an on-premises GPO-only control in this lab phase.

Operational guidance:

- Document Tamper Protection state during validation.
- Do not claim this GPO fully enforces Tamper Protection.
- Do not introduce Intune, MDE, Defender XDR, or Microsoft 365 security services for this EPIC.
- Revisit Tamper Protection enforcement only when cloud endpoint management is explicitly in scope.

Run on: `HQ-W11-001 or HQ-MGMT01`

When: documenting endpoint protection posture after Group Policy applies.

Expected outcome: Defender status is visible; Tamper Protection state is recorded as an observed local/cloud-managed setting, not as an on-premises GPO guarantee.

```powershell
Get-MpComputerStatus |
    Select-Object AMServiceEnabled, AntivirusEnabled, RealTimeProtectionEnabled, IsTamperProtected
```

## Client policy application

Run on: `HQ-W11-001`

When: after creating, linking, and configuring `GP - Security - Microsoft Defender`.

Expected outcome: Group Policy refresh completes without errors.

```powershell
gpupdate /force
gpresult /r /scope computer
```

STOP if `GP - Security - Microsoft Defender` does not appear in applied computer policy. Correct OU placement and GPO links before Defender validation.

## Validation commands

Run on: `HQ-W11-001`

When: after `GP - Security - Microsoft Defender` is created, linked, configured, and `gpupdate /force` completes.

Expected outcome: the Defender GPO applies to the computer and the endpoint reports the validated healthy Defender state.

```powershell
gpupdate /force
gpresult /r /scope computer
Get-MpComputerStatus
Get-MpPreference
Update-MpSignature
```

Healthy `gpresult` output must include:

```text
Applied Group Policy Objects
-----------------------------
    GP - Security - Microsoft Defender
```

Healthy `Get-MpComputerStatus` output must include these values:

```text
AntivirusEnabled              : True
AntispywareEnabled            : True
RealTimeProtectionEnabled     : True
BehaviorMonitorEnabled        : True
IoavProtectionEnabled         : True
OnAccessProtectionEnabled     : True
DefenderSignaturesOutOfDate   : False
IsTamperProtected             : True
```

Healthy `Get-MpPreference` output must include these values:

```text
PUAProtection                 : 1
MAPSReporting                 : 2
SubmitSamplesConsent          : 1
EnableNetworkProtection       : 2
```

Run on: `HQ-W11-001`

When: validating only Defender health fields after policy is already known to apply.

Expected outcome: Microsoft Defender Antivirus, antispyware, real-time, behavior, IOAV, and on-access protection are enabled; signatures are not out of date; Tamper Protection is enabled.

```powershell
Get-MpComputerStatus |
    Select-Object AntivirusEnabled,
        AntispywareEnabled,
        RealTimeProtectionEnabled,
        BehaviorMonitorEnabled,
        IoavProtectionEnabled,
        OnAccessProtectionEnabled,
        DefenderSignaturesOutOfDate,
        IsTamperProtected
```

Run on: `HQ-W11-001`

When: validating configured Defender preferences after Group Policy applies.

Expected outcome: PUA Protection is enabled, MAPS reporting is Advanced, automatic sample submission is Safe Samples, and Network Protection is in Audit mode.

```powershell
Get-MpPreference |
    Select-Object PUAProtection,
        MAPSReporting,
        SubmitSamplesConsent,
        EnableNetworkProtection
```

Run on: `HQ-W11-001`

When: validating security intelligence update capability.

Expected outcome: security intelligence update completes and signatures are not out of date.

```powershell
Update-MpSignature
Get-MpComputerStatus |
    Select-Object AntivirusSignatureLastUpdated,
        AntispywareSignatureLastUpdated,
        AntivirusSignatureAge,
        AntispywareSignatureAge,
        DefenderSignaturesOutOfDate
```

Healthy output should show recent signature timestamps, low signature ages, and `DefenderSignaturesOutOfDate` set to `False`.

## Operations

### Update signatures

Run on: `HQ-W11-001` or another managed Windows client

When: routine verification, after network changes, before pilot acceptance, or when signatures appear stale.

Expected outcome: Defender security intelligence updates successfully and signatures are not out of date.

```powershell
Update-MpSignature
Get-MpComputerStatus |
    Select-Object AntivirusSignatureLastUpdated,
        AntivirusSignatureAge,
        DefenderSignaturesOutOfDate
```

### Quick scan

Run on: `HQ-W11-001` or another managed Windows client

When: routine operational check, after policy deployment, or after remediation.

Expected outcome: quick scan starts and completes without Defender service errors.

```powershell
Start-MpScan -ScanType QuickScan
```

### Full scan

Run on: `HQ-W11-001` or another managed Windows client

When: deeper validation is required, after suspected compromise, or during a maintenance window.

Expected outcome: full scan starts successfully. Schedule during a maintenance window because it may affect user experience.

```powershell
Start-MpScan -ScanType FullScan
```

### Health verification

Run on: `HQ-W11-001` or another managed Windows client

When: after reboot, before final workstation validation, before privileged use of a management workstation, or during periodic operations review.

Expected outcome: Defender services and protection layers remain enabled.

```powershell
Get-MpComputerStatus |
    Select-Object AntivirusEnabled,
        AntispywareEnabled,
        RealTimeProtectionEnabled,
        BehaviorMonitorEnabled,
        IoavProtectionEnabled,
        OnAccessProtectionEnabled,
        DefenderSignaturesOutOfDate,
        IsTamperProtected
```

### Policy verification

Run on: `HQ-W11-001` or another managed Windows client

When: after `gpupdate /force`, OU changes, GPO edits, or troubleshooting.

Expected outcome: `GP - Security - Microsoft Defender` appears in applied computer policy and Defender preferences match the validated baseline.

```powershell
gpupdate /force
gpresult /r /scope computer
Get-MpPreference |
    Select-Object PUAProtection,
        MAPSReporting,
        SubmitSamplesConsent,
        EnableNetworkProtection
```

### Recommended periodic validation

Perform this check during monthly workstation health review, before closing endpoint-protection change tickets, and after major GPO changes.

Run on: representative Workstations and Management Workstations clients

When: monthly, after baseline changes, and before declaring a new workstation enterprise-ready.

Expected outcome: GPO applies, Defender health is enabled, signatures are current, and preferences match the validated baseline.

```powershell
gpresult /r /scope computer
Get-MpComputerStatus |
    Select-Object AntivirusEnabled,
        RealTimeProtectionEnabled,
        BehaviorMonitorEnabled,
        DefenderSignaturesOutOfDate,
        IsTamperProtected
Get-MpPreference |
    Select-Object PUAProtection,
        MAPSReporting,
        SubmitSamplesConsent,
        EnableNetworkProtection
```

## Windows client lifecycle integration

Microsoft Defender Baseline is part of final endpoint readiness for Windows client devices.

```text
Golden Image
↓
Clone and Cloudbase-Init
↓
Domain Join
↓
Move to Workstations or Management Workstations OU
↓
Apply baseline GPOs
↓
Apply Windows Firewall Baseline
↓
Apply Windows LAPS Baseline
↓
Validate WinRM
↓
Apply Microsoft Defender Baseline
↓
Enterprise Validation
```

Lifecycle rules:

- Do not domain join the golden template.
- Do not validate Defender GPO state in the golden template.
- Apply this baseline only after the cloned client is domain joined and moved to the correct OU.
- Validate Microsoft Defender after Windows Firewall, Windows LAPS, and WinRM validation, and before Enterprise Validation.
- Use [Standard Windows Client - HQ-W11-001](../windows-client-lifecycle/standard-windows-client-hq-w11-001.md) as the pilot client.

## Pilot Findings

The Microsoft Defender Enterprise Baseline was successfully validated on `HQ-W11-001` in the GEIL lab.

Validated infrastructure:

- `HQ-DC01`
- `HQ-MGMT01`
- `HQ-W11-001`

Validated GPO:

```text
GP - Security - Microsoft Defender
```

Validated GPO links:

- Workstations OU.
- Management Workstations OU.

Validated deployment sequence:

1. Create GPO.
2. Link GPO.
3. Configure policy.
4. Run `gpupdate /force`.
5. Validate GPO with `gpresult /r /scope computer`.
6. Validate Defender health with `Get-MpComputerStatus`.
7. Update signatures with `Update-MpSignature`.
8. Mark endpoint as Enterprise Ready.

Validated Defender state:

| Setting | Validated value |
|---|---|
| Microsoft Defender Antivirus | Enabled |
| Real-time Protection | Enabled |
| Behavior Monitoring | Enabled |
| IOAV Protection | Enabled |
| Cloud-delivered Protection | Enabled |
| MAPS Reporting | Advanced membership (`2`) |
| Automatic Sample Submission | Safe samples (`1`) |
| PUA Protection | Enabled (`1`) |
| Network Protection | Audit mode (`2`) |
| Tamper Protection | Enabled |

The baseline is no longer theoretical. It reflects the validated Active Directory Group Policy deployment used in the GEIL lab.

## Security considerations

- Microsoft Defender Antivirus is the baseline endpoint protection control, not the full endpoint detection and response platform.
- Do not disable Defender to work around application or performance issues; document and approve exclusions instead.
- Keep exclusions minimal, specific, and justified.
- Treat Management Workstations as higher-risk administrative endpoints and validate Defender health before privileged use.
- Network Protection starts in Audit mode so the lab can observe impact before blocking.
- Future Defender for Endpoint, XDR, Intune, and Microsoft 365 security integrations require separate architecture decisions.

## Troubleshooting

| Issue | Symptoms | Validation commands | Expected output | Resolution |
|---|---|---|---|---|
| GPO not applied | Defender preferences do not match baseline; `GP - Security - Microsoft Defender` is missing from computer policy | `gpresult /r /scope computer`; `Get-GPInheritance -Target <OU DN>` | `GP - Security - Microsoft Defender` appears under applied computer policy and is linked to the correct OU | Move the client to the correct OU, link the GPO, wait for replication, then run `gpupdate /force`. |
| Policies missing | Defender is enabled but MAPS, sample submission, PUA, or Network Protection values are not correct | `Get-MpPreference` | `PUAProtection = 1`, `MAPSReporting = 2`, `SubmitSamplesConsent = 1`, `EnableNetworkProtection = 2` | Correct GPO settings, confirm ADMX availability, and refresh Group Policy. |
| Third-party AV installed | Defender reports passive/disabled behavior or Windows Security shows another provider | `Get-MpComputerStatus`; Windows Security UI | Microsoft Defender Antivirus is active for this baseline | Remove or formally approve the third-party product before relying on this baseline. |
| Signatures outdated | `DefenderSignaturesOutOfDate` is true or signature ages are high | `Update-MpSignature`; `Get-MpComputerStatus` | `DefenderSignaturesOutOfDate = False` and recent signature timestamps | Restore internet/update connectivity or configure an approved update source. |
| Real-time protection disabled | `RealTimeProtectionEnabled` is false | `Get-MpComputerStatus`; `Get-MpPreference` | `RealTimeProtectionEnabled = True`; `DisableRealtimeMonitoring = False` | Reapply policy, investigate local administrative changes, and remove conflicting controls. |
| Network Protection not configured | Network Protection does not report Audit mode | `Get-MpPreference` | `EnableNetworkProtection = 2` | Configure Network Protection to Audit mode in `GP - Security - Microsoft Defender`, then run `gpupdate /force`. |
| Tamper Protection not enabled | `IsTamperProtected` is false | `Get-MpComputerStatus` | `IsTamperProtected = True` for the validated pilot state | Record the deviation; do not claim GPO-only enforcement. Revisit cloud management only when MDE/Intune is in scope. |

## Troubleshooting command reference

Run on: `HQ-W11-001`

When: troubleshooting Defender health, policy, or update state.

Expected outcome: command output identifies whether the issue is service state, policy state, update state, or GPO application.

```powershell
Get-Service WinDefend
Get-MpComputerStatus
Get-MpPreference
gpresult /r /scope computer
Update-MpSignature
```

Run on: `HQ-MGMT01 or HQ-DC01 during GPO troubleshooting`

When: validating GPO links for Workstations and Management Workstations OUs.

Expected outcome: `GP - Security - Microsoft Defender` appears on both target OUs.

```powershell
$GpoName = "GP - Security - Microsoft Defender"
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

## Baseline checklist

- [ ] `GP - Security - Microsoft Defender` created.
- [ ] GPO linked to Workstations OU.
- [ ] GPO linked to Management Workstations OU.
- [ ] Real-time protection enabled.
- [ ] Behavior monitoring enabled.
- [ ] Cloud-delivered protection enabled.
- [ ] Automatic sample submission configured.
- [ ] PUA Protection enabled.
- [ ] Network Protection configured in Audit mode for the lab.
- [ ] Security intelligence updates validated.
- [ ] Scheduled quick scan configured.
- [ ] Full scan operational guidance documented.
- [ ] Tamper Protection limitation documented.
- [ ] `Get-MpComputerStatus` shows healthy Defender state.
- [ ] `Get-MpPreference` matches baseline settings.
- [ ] `Update-MpSignature` succeeds or update-source issue is documented.
- [ ] `gpresult /r /scope computer` shows the Defender GPO applied.
- [ ] `AntivirusEnabled = True`.
- [ ] `AntispywareEnabled = True`.
- [ ] `RealTimeProtectionEnabled = True`.
- [ ] `BehaviorMonitorEnabled = True`.
- [ ] `IoavProtectionEnabled = True`.
- [ ] `OnAccessProtectionEnabled = True`.
- [ ] `DefenderSignaturesOutOfDate = False`.
- [ ] `PUAProtection = 1`.
- [ ] `MAPSReporting = 2`.
- [ ] `SubmitSamplesConsent = 1`.
- [ ] `EnableNetworkProtection = 2`.
- [ ] `IsTamperProtected = True`.
- [ ] `HQ-W11-001` pilot validation completed.

## Future improvements

Future work may include:

- Server-specific Microsoft Defender Antivirus baselines.
- Event forwarding for Defender operational and security events.
- Microsoft Defender for Endpoint onboarding.
- Intune security baseline comparison.
- Microsoft Defender XDR integration.
- Centralized reporting and SIEM correlation.

These items are intentionally outside this EPIC.
