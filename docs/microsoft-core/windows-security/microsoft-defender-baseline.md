---
title: Microsoft Defender Enterprise Baseline
document_id: GEIL-MSC-WINSEC-DEF-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
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
| Status | Draft |
| Version | 1.0 |
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

| Control | Recommended setting | Why |
|---|---|---|
| Real-time protection | Enabled | Blocks malware activity as files and processes are accessed. |
| Behavior monitoring | Enabled | Detects suspicious behavior that may not match a static signature. |
| Cloud-delivered protection | Enabled | Improves detection using Microsoft cloud intelligence when internet access is available. |
| Automatic sample submission | Send safe samples automatically | Improves detection while avoiding unnecessary manual prompts for routine samples. |
| PUA Protection | Enabled | Blocks potentially unwanted applications often seen in browser/download abuse. |
| Network Protection | Audit mode | Records potential risky network destinations without blocking lab workflows during pilot validation. |
| Security intelligence updates | Enabled and automatic | Keeps signatures current without relying on manual operator action. |
| Scheduled quick scan | Daily | Provides routine lightweight endpoint coverage. |
| Scheduled full scan | Weekly or operationally scheduled | Provides deeper periodic coverage without disrupting daily use. |
| Tamper Protection | Document limitation | Tamper Protection is not fully controlled by on-premises GPO; use cloud management later if required. |

## Recommended policy values

| Policy area | Setting | Baseline value |
|---|---|---|
| Microsoft Defender Antivirus | Turn off Microsoft Defender Antivirus | Disabled |
| Real-time Protection | Turn off real-time protection | Disabled |
| Real-time Protection | Turn on behavior monitoring | Enabled |
| MAPS | Join Microsoft MAPS | Advanced MAPS |
| MAPS | Send file samples when further analysis is required | Send safe samples |
| Microsoft Defender Antivirus | Configure detection for potentially unwanted applications | Enabled / Block |
| Microsoft Defender Exploit Guard > Network Protection | Prevent users and apps from accessing dangerous websites | Audit mode |
| Security Intelligence Updates | Define the order of sources for updates | Microsoft Update, WSUS if later deployed |
| Scan | Check for the latest virus and spyware security intelligence before running a scheduled scan | Enabled |
| Scan | Specify the scan type to use for a scheduled scan | Quick scan for routine daily schedule |

## Tamper Protection limitations

Tamper Protection is important, but it is not a complete on-premises GPO control in this lab phase.

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
gpresult /r
```

STOP if `GP - Security - Microsoft Defender` does not appear in applied computer policy. Correct OU placement and GPO links before Defender validation.

## Validation commands

Run on: `HQ-W11-001`

When: after Group Policy applies.

Expected outcome: Microsoft Defender Antivirus is enabled, real-time protection is enabled, behavior monitoring is enabled, and signatures are current.

```powershell
Get-MpComputerStatus
```

Healthy output should show values similar to:

```text
AMServiceEnabled           : True
AntivirusEnabled           : True
BehaviorMonitorEnabled     : True
IoavProtectionEnabled      : True
NISEnabled                 : True
RealTimeProtectionEnabled  : True
AntispywareSignatureAge    : 0
AntivirusSignatureAge      : 0
```

Run on: `HQ-W11-001`

When: validating configured Defender preferences after Group Policy applies.

Expected outcome: preferences match the baseline, including PUA Protection enabled and Network Protection in Audit mode.

```powershell
Get-MpPreference |
    Select-Object DisableRealtimeMonitoring, DisableBehaviorMonitoring, PUAProtection, EnableNetworkProtection, SignatureScheduleDay, ScanScheduleDay, ScanParameters
```

Expected interpretation:

- `DisableRealtimeMonitoring` is `False`.
- `DisableBehaviorMonitoring` is `False`.
- `PUAProtection` indicates enabled/block mode.
- `EnableNetworkProtection` indicates Audit mode for the lab.
- Scheduled scan values are present.

Run on: `HQ-W11-001`

When: validating security intelligence update capability.

Expected outcome: security intelligence update completes or returns a clear update-source error that can be remediated.

```powershell
Update-MpSignature
Get-MpComputerStatus |
    Select-Object AntivirusSignatureLastUpdated, AntispywareSignatureLastUpdated, AntivirusSignatureAge, AntispywareSignatureAge
```

Healthy output should show recent signature timestamps and low signature ages.

## Operations

### Update security intelligence

Run on: `HQ-W11-001`

When: routine verification, after network changes, or before pilot acceptance.

Expected outcome: Defender security intelligence is current.

```powershell
Update-MpSignature
```

### Run a quick scan

Run on: `HQ-W11-001`

When: routine operational check or after policy deployment.

Expected outcome: quick scan starts and completes without Defender service errors.

```powershell
Start-MpScan -ScanType QuickScan
```

### Run a full scan

Run on: `HQ-W11-001`

When: deeper validation is required, after suspected compromise, or during a maintenance window.

Expected outcome: full scan starts successfully. Schedule during a maintenance window because it may affect user experience.

```powershell
Start-MpScan -ScanType FullScan
```

### Verify after GPO application

Run on: `HQ-W11-001`

When: after `gpupdate /force`, reboot, or OU/GPO changes.

Expected outcome: the GPO applies and Defender health remains enabled.

```powershell
gpupdate /force
gpresult /r
Get-MpComputerStatus |
    Select-Object AMServiceEnabled, AntivirusEnabled, RealTimeProtectionEnabled, BehaviorMonitorEnabled
Get-MpPreference |
    Select-Object PUAProtection, EnableNetworkProtection
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
Apply Microsoft Defender Baseline
↓
Validate final workstation readiness
```

Lifecycle rules:

- Do not domain join the golden template.
- Do not validate Defender GPO state in the golden template.
- Apply this baseline only after the cloned client is domain joined and moved to the correct OU.
- Validate Microsoft Defender before final workstation acceptance.
- Use [Standard Windows Client - HQ-W11-001](../windows-client-lifecycle/standard-windows-client-hq-w11-001.md) as the pilot client.

## Pilot validation plan

This EPIC will be validated on `HQ-W11-001`.

Run on: `HQ-W11-001`

When: after `GP - Security - Microsoft Defender` is created, linked, configured, and Group Policy has refreshed.

Expected outcome: the endpoint reports healthy Microsoft Defender Antivirus state and baseline preferences.

```powershell
gpupdate /force
gpresult /r
Get-MpComputerStatus
Get-MpPreference |
    Select-Object DisableRealtimeMonitoring, DisableBehaviorMonitoring, PUAProtection, EnableNetworkProtection
Update-MpSignature
Get-MpComputerStatus |
    Select-Object AntivirusSignatureLastUpdated, AntivirusSignatureAge, RealTimeProtectionEnabled
```

Expected healthy results:

- `GP - Security - Microsoft Defender` appears in applied computer policy.
- `AMServiceEnabled` is `True`.
- `AntivirusEnabled` is `True`.
- `RealTimeProtectionEnabled` is `True`.
- `BehaviorMonitorEnabled` is `True`.
- PUA Protection is enabled.
- Network Protection is in Audit mode for the lab.
- Signature update succeeds or the update error is documented and remediated.

## Security considerations

- Microsoft Defender Antivirus is the baseline endpoint protection control, not the full endpoint detection and response platform.
- Do not disable Defender to work around application or performance issues; document and approve exclusions instead.
- Keep exclusions minimal, specific, and justified.
- Treat Management Workstations as higher-risk administrative endpoints and validate Defender health before privileged use.
- Network Protection starts in Audit mode so the lab can observe impact before blocking.
- Future Defender for Endpoint, XDR, Intune, and Microsoft 365 security integrations require separate architecture decisions.

## Troubleshooting

| Issue | Likely cause | Validation commands | Fix |
|---|---|---|---|
| Defender service disabled | Local service change, third-party AV, or policy conflict | `Get-MpComputerStatus`; `Get-Service WinDefend` | Remove conflicting control, verify no third-party AV owns protection, reapply GPO. |
| Signatures outdated | No internet/update path, proxy issue, or update source issue | `Update-MpSignature`; `Get-MpComputerStatus` signature fields | Restore update connectivity or configure an approved update source. |
| GPO not applied | Computer in wrong OU or GPO link missing | `gpresult /r`; `Get-GPInheritance -Target <OU DN>` | Move client to correct OU and link `GP - Security - Microsoft Defender`. |
| Third-party AV detected | Another endpoint protection product registered with Windows Security Center | `Get-MpComputerStatus`; Windows Security UI | Remove or formally approve the third-party product before relying on this baseline. |
| Real-time protection disabled | Local tampering, policy conflict, or troubleshooting change | `Get-MpComputerStatus`; `Get-MpPreference` | Reapply policy, investigate administrative changes, and document any exception. |
| Network Protection blocks expected workflow | Policy accidentally set to block instead of audit | `Get-MpPreference`; review Network Protection setting | Set Network Protection to Audit mode for the lab pilot. |

## Troubleshooting command reference

Run on: `HQ-W11-001`

When: troubleshooting Defender health, policy, or update state.

Expected outcome: command output identifies whether the issue is service state, policy state, update state, or GPO application.

```powershell
Get-Service WinDefend
Get-MpComputerStatus
Get-MpPreference
gpresult /r
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
- [ ] `HQ-W11-001` pilot validation completed before broad rollout.

## Future improvements

Future work may include:

- Server-specific Microsoft Defender Antivirus baselines.
- Event forwarding for Defender operational and security events.
- Microsoft Defender for Endpoint onboarding.
- Intune security baseline comparison.
- Microsoft Defender XDR integration.
- Centralized reporting and SIEM correlation.

These items are intentionally outside this EPIC.
