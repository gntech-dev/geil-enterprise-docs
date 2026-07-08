---
title: Windows Event Forwarding and Collector Baseline
document_id: GEIL-MSC-WINMON-WEF-001
owner: Infrastructure Engineering
status: Pilot In Progress
version: 1.0
last_reviewed: 2026-07-08
review_cycle: Quarterly
classification: Internal Confidential
---

# Windows Event Forwarding and Collector Baseline

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-WINMON-WEF-001 |
| Owner | Infrastructure Engineering |
| Status | Pilot In Progress |
| Version | 1.0 |
| Last Reviewed | 2026-07-08 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## 1. Purpose

This guide designs the pilot Windows Event Forwarding architecture for GEIL using a dedicated Windows Event Collector server named `HQ-WEC01`.

The objective is native Windows event collection from managed Windows clients without introducing SIEM, log analytics, or observability platforms yet.

In scope:

- Windows Event Forwarding.
- Windows Event Collector.
- Source-initiated subscriptions.
- Group Policy client configuration.
- Initial pilot sources: `HQ-W11-001` and `HQ-MGMT01`.
- Initial destination: `HQ-WEC01`.

Out of scope for this EPIC:

- Loki.
- Grafana.
- Sentinel.
- Splunk.
- Elastic.
- Sysmon deployment.
- Microsoft Defender for Endpoint or Microsoft Defender XDR integration.
- Long-term SIEM retention architecture.

Related documents:

- [Enterprise Implementation Roadmap](../../project/enterprise-implementation-roadmap.md)
- [Deployment Style Guide](../../governance/deployment-style-guide.md)
- [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md)
- [Windows Firewall Baseline](../windows-security/windows-firewall-baseline.md)
- [Enterprise WinRM Management](../administration/enterprise-winrm-management.md)
- [Microsoft Defender Enterprise Baseline](../windows-security/microsoft-defender-baseline.md)
- [Windows LAPS Baseline](../windows-security/windows-laps-baseline.md)

## 2. Architecture

Architecture decision: use a dedicated Windows Event Collector server.

| Item | Value |
|---|---|
| Hostname | `HQ-WEC01` |
| Network | VLAN 20 Servers |
| Role | Windows Event Collector |
| Purpose | Centralized Windows event collection from managed Windows clients |
| Initial event sources | `HQ-W11-001`, `HQ-MGMT01` |
| Initial event destination | `HQ-WEC01` |
| Subscription model | Source-initiated |
| Transport | WinRM HTTP over TCP `5985` inside the lab |

Rationale:

- Separates event collection from Domain Controller duties.
- Avoids placing monitoring workload on `HQ-DC01`.
- Matches enterprise architecture patterns.
- Prepares future SIEM integration without committing to a SIEM platform in this EPIC.

### Event forwarding flow

```text
HQ-W11-001  ─┐
             ├─ TCP 5985 ─> HQ-WEC01 ─> Forwarded Events
HQ-MGMT01  ──┘
```

Source-initiated WEF means clients initiate the connection to the collector. The collector does not pull events from clients.

### Network and firewall model

| Source | Destination | Port | Direction | Purpose |
|---|---|---:|---|---|
| VLAN 30 Workstations | `HQ-WEC01` on VLAN 20 | TCP `5985` | Client to collector | `HQ-W11-001` forwards events to WEC. |
| VLAN 10 Management | `HQ-WEC01` on VLAN 20 | TCP `5985` | Client to collector | `HQ-MGMT01` forwards events to WEC. |

Firewall interpretation:

- Allow clients to reach `HQ-WEC01` on TCP `5985` for WEF subscription delivery.
- Do not use `HQ-DC01` as the event collector.
- Do not open broad workstation-to-server administrative access to make WEF work.
- Keep RDP and administrative WinRM scoping separate from WEF client-to-collector flows.
- Apply host firewall and MikroTik inter-VLAN policy consistently with the [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md).

## 3. Prerequisites

Infrastructure prerequisites:

- `HQ-DC01` is healthy and provides AD DS, DNS, Kerberos, and Group Policy.
- `HQ-WEC01` is deployed as a Windows Server on VLAN 20 Servers.
- `HQ-WEC01` is joined to `corp.gntech.me`.
- `HQ-WEC01` is placed in the correct Servers OU.
- `HQ-W11-001` exists in the Workstations OU.
- `HQ-MGMT01` exists in the Management Workstations OU.
- `HQ-WEC01.corp.gntech.me` resolves from both pilot clients.
- TCP `5985` from VLAN 10 and VLAN 30 to `HQ-WEC01` is allowed by the network and host firewall policy.

Administrative prerequisites:

- Group Policy Management is available on `HQ-MGMT01`.
- The operator has permission to create and link GPOs.
- The operator has local administrative access on `HQ-WEC01`.
- WinRM/Event Collector configuration is approved for the pilot.

## 4. Deployment Workflow

The validated target deployment sequence is:

1. Deploy `HQ-WEC01` as Windows Server.
2. Join `HQ-WEC01` to `corp.gntech.me`.
3. Move `HQ-WEC01` to the correct Servers OU.
4. Enable Windows Event Collector service.
5. Configure WinRM/Event Collector prerequisites.
6. Create source-initiated event subscription.
7. Create `GP - Security - Windows Event Forwarding`.
8. Link the GPO to:
   - Workstations OU.
   - Management Workstations OU.
9. Validate event forwarding from:
   - `HQ-W11-001`.
   - `HQ-MGMT01`.
10. Confirm events arrive in **Forwarded Events** on `HQ-WEC01`.

STOP if `HQ-WEC01` is not domain joined or cannot be resolved by DNS. Do not configure WEF around name-resolution or domain-membership failures.

## 5. PowerShell Automation

### Enable Windows Event Collector prerequisites

Run on: `HQ-WEC01`

When: after `HQ-WEC01` is domain joined and placed in the Servers OU.

Expected outcome: Windows Event Collector and WinRM prerequisites are configured and running.

```powershell
wecutil qc /q
Set-Service Wecsvc -StartupType Automatic
Start-Service Wecsvc
Set-Service WinRM -StartupType Automatic
Start-Service WinRM
Get-Service Wecsvc
Get-Service WinRM
```

Expected healthy output:

```text
Status   Name               DisplayName
------   ----               -----------
Running  Wecsvc             Windows Event Collector
Running  WinRM              Windows Remote Management (WS-Management)
```

### Create and link the client GPO

Run on: `HQ-MGMT01`

When: after Group Policy Management tools are available and the target OUs exist.

Expected outcome: `GP - Security - Windows Event Forwarding` exists and is linked to Workstations and Management Workstations OUs.

```powershell
Import-Module GroupPolicy

$GpoName = "GP - Security - Windows Event Forwarding"
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
DisplayName      : GP - Security - Windows Event Forwarding
GpoStatus        : AllSettingsEnabled
```

## 6. GUI / GPMC Implementation

Configure client subscription manager policy in Group Policy Management.

Run on: `HQ-MGMT01`

When: after `GP - Security - Windows Event Forwarding` is created and linked.

Expected outcome: WEF clients receive the subscription manager URL for `HQ-WEC01`.

GPMC path:

| Field | Value |
|---|---|
| Console | Group Policy Management |
| GPO | `GP - Security - Windows Event Forwarding` |
| Path | Computer Configuration > Policies > Administrative Templates > Windows Components > Event Forwarding |
| Policy | Configure target Subscription Manager |
| State | Enabled |
| Subscription Manager | `Server=http://HQ-WEC01.corp.gntech.me:5985/wsman/SubscriptionManager/WEC,Refresh=60` |

Link the GPO to:

- `OU=Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me`
- `OU=Management Workstations,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me`

### Create source-initiated subscription

Run on: `HQ-WEC01`

When: after Event Collector prerequisites are enabled and client GPO is ready.

Expected outcome: a source-initiated subscription exists for the initial pilot clients or their pilot groups.

Use Event Viewer:

| Field | Value |
|---|---|
| Console | Event Viewer |
| Path | Subscriptions |
| Subscription type | Source computer initiated |
| Destination log | Forwarded Events |
| Collector | `HQ-WEC01` |
| Initial sources | `HQ-W11-001`, `HQ-MGMT01` or a controlled pilot computer group |

Do not add Domain Controllers as initial sources until the WEF pilot is validated for clients.

## 7. Validation Workflow

### Validate collector configuration

Run on: `HQ-WEC01`

When: after running `wecutil qc` and creating the initial subscription.

Expected outcome: Event Collector and WinRM services are running and subscriptions can be enumerated.

```powershell
wecutil qc
wecutil es
Get-Service Wecsvc
Get-Service WinRM
```

Expected healthy output:

```text
Wecsvc  Running
WinRM   Running
```

### Validate subscription configuration

Run on: `HQ-WEC01`

When: after creating the source-initiated subscription.

Expected outcome: the subscription exists and displays the expected configuration.

```powershell
$SubscriptionName = "GEIL Windows Client Events"
wecutil gs $SubscriptionName
```

Expected result:

- Subscription exists.
- Subscription type is source-initiated.
- Destination log is `ForwardedEvents`.
- Subscription is enabled.

### Validate client GPO and connectivity

Run on: `HQ-W11-001` and `HQ-MGMT01`

When: after linking `GP - Security - Windows Event Forwarding`.

Expected outcome: the GPO applies and the client can reach `HQ-WEC01` on TCP `5985`.

```powershell
gpupdate /force
gpresult /r /scope computer
Test-NetConnection HQ-WEC01 -Port 5985
wecutil gr
```

Expected healthy output:

```text
GP - Security - Windows Event Forwarding
TcpTestSucceeded : True
```

Expected result:

- GPO applies.
- Client can reach `HQ-WEC01` on TCP `5985`.
- Subscription appears on the client.

### Validate forwarded events

Run on: `HQ-WEC01`

When: after client GPO refresh and subscription registration.

Expected outcome: forwarded events arrive in the `ForwardedEvents` log.

```powershell
Get-WinEvent -LogName "ForwardedEvents" -MaxEvents 10
```

Expected result:

- Events are returned from `ForwardedEvents`.
- Source computers include `HQ-W11-001` and/or `HQ-MGMT01` after the pilot clients register and generate matching events.

## 8. Pilot Findings

Status: pending pilot validation.

This section must be updated after real deployment.

Initial pilot questions:

- Does `HQ-WEC01` receive events from `HQ-W11-001`?
- Does `HQ-WEC01` receive events from `HQ-MGMT01`?
- Does the GPO apply cleanly to both Workstations and Management Workstations OUs?
- Does TCP `5985` from VLAN 10 and VLAN 30 to `HQ-WEC01` work without opening broad administrative access?
- Are forwarded events visible in the `ForwardedEvents` log?
- Are subscription errors present in Event Viewer on either source or collector?

Record final findings here after pilot implementation completes.

## 9. Operations

### Check collector health

Run on: `HQ-WEC01`

When: daily during pilot validation and after collector or GPO changes.

Expected outcome: WEC and WinRM are running and subscriptions are visible.

```powershell
Get-Service Wecsvc
Get-Service WinRM
wecutil es
```

### Check forwarded events

Run on: `HQ-WEC01`

When: after pilot clients refresh Group Policy or during monitoring checks.

Expected outcome: recent events are present in the `ForwardedEvents` log.

```powershell
Get-WinEvent -LogName "ForwardedEvents" -MaxEvents 10
```

### Check client subscription state

Run on: `HQ-W11-001` and `HQ-MGMT01`

When: after `gpupdate /force`, reboot, GPO change, or subscription change.

Expected outcome: client reports subscription manager configuration and can reach the collector.

```powershell
gpresult /r /scope computer
wecutil gr
Test-NetConnection HQ-WEC01 -Port 5985
```

### Operational boundaries

- Keep `HQ-WEC01` dedicated to event collection during the pilot.
- Do not move the collector role to `HQ-DC01`.
- Do not integrate SIEM or observability platforms until the native WEF pilot is stable.
- Do not broaden firewall policy beyond the required client-to-collector TCP `5985` flow.

## 10. Troubleshooting

| Issue | Symptoms | Validation commands | Expected output | Resolution |
|---|---|---|---|---|
| GPO not applied | Client does not know about the subscription manager | `gpresult /r /scope computer` | `GP - Security - Windows Event Forwarding` appears in applied computer policy | Confirm client OU placement, GPO links, security filtering, and replication. |
| Client cannot reach collector | `Test-NetConnection` fails | `Test-NetConnection HQ-WEC01 -Port 5985` | `TcpTestSucceeded : True` | Fix DNS, Windows Firewall, or MikroTik inter-VLAN rule for client-to-collector TCP `5985`. |
| Collector service stopped | No subscriptions or no incoming events | `Get-Service Wecsvc`; `wecutil es` | `Wecsvc` is running and subscriptions enumerate | Start Wecsvc and set startup type to Automatic. |
| WinRM stopped on collector | Clients cannot register with the collector | `Get-Service WinRM`; `Test-NetConnection HQ-WEC01 -Port 5985` | `WinRM` is running and TCP `5985` succeeds | Start WinRM and confirm firewall allows the listener. |
| Subscription missing | `wecutil es` does not list expected subscription | `wecutil es`; `wecutil gs <SubscriptionName>` | Subscription exists and is enabled | Recreate or correct the source-initiated subscription on `HQ-WEC01`. |
| No forwarded events | Subscription exists but `ForwardedEvents` is empty | `Get-WinEvent -LogName "ForwardedEvents" -MaxEvents 10`; client `wecutil gr` | Events appear after client registration and matching events are generated | Confirm client is in subscription scope, refresh GPO, wait for registration, and generate matching events. |
| Wrong collector used | Documentation or GPO points to `HQ-DC01` | GPO setting check; `gpresult /h` if needed | Subscription manager points to `HQ-WEC01.corp.gntech.me` | Correct the GPO. This EPIC does not use `HQ-DC01` as collector. |

## 11. Acceptance Criteria

This EPIC is complete only when all criteria below are met:

- [ ] `HQ-WEC01` is deployed as a Windows Server on VLAN 20 Servers.
- [ ] `HQ-WEC01` is joined to `corp.gntech.me`.
- [ ] `HQ-WEC01` is placed in the correct Servers OU.
- [ ] Windows Event Collector service is enabled and running.
- [ ] WinRM is enabled and running on `HQ-WEC01`.
- [ ] A source-initiated subscription exists on `HQ-WEC01`.
- [ ] `GP - Security - Windows Event Forwarding` exists.
- [ ] GPO is linked to Workstations OU.
- [ ] GPO is linked to Management Workstations OU.
- [ ] Subscription manager points to `Server=http://HQ-WEC01.corp.gntech.me:5985/wsman/SubscriptionManager/WEC,Refresh=60`.
- [ ] `HQ-W11-001` applies the GPO.
- [ ] `HQ-MGMT01` applies the GPO.
- [ ] `HQ-W11-001` reaches `HQ-WEC01` on TCP `5985`.
- [ ] `HQ-MGMT01` reaches `HQ-WEC01` on TCP `5985`.
- [ ] `ForwardedEvents` on `HQ-WEC01` receives events from the pilot sources.
- [ ] Pilot Findings are updated with real deployment results.
