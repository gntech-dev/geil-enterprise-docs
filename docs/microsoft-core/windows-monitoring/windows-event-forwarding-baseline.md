---
title: Windows Event Forwarding and Collector Baseline
document_id: GEIL-MSC-WINMON-WEF-001
owner: Infrastructure Engineering
status: Pilot Validated
version: Approved v1.1
last_reviewed: 2026-07-08
review_cycle: Quarterly
classification: Internal Confidential
---

# Windows Event Forwarding and Collector Baseline

!!! note "HQ-FW01 firewall source of truth"

    Authoritative MikroTik firewall rules are maintained in [HQ-FW01 Firewall Policy](../../network/mikrotik/hq-fw01-firewall-policy.md).


## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-WINMON-WEF-001 |
| Owner | Infrastructure Engineering |
| Status | Pilot Validated |
| Version | Approved v1.1 |
| Last Reviewed | 2026-07-08 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## 1. Purpose

This guide documents the pilot-validated Windows Event Forwarding architecture for GEIL using a dedicated Windows Event Collector server named `HQ-WEC01`.

The objective is native Windows event collection from managed Windows clients without introducing SIEM, log analytics, or observability platforms yet.

In scope:

- Windows Event Forwarding.
- Windows Event Collector.
- Source-initiated subscriptions.
- Group Policy client configuration.
- Validated pilot sources: `HQ-W11-001` and `HQ-MGMT01`.
- Validated event destination: `HQ-WEC01`.

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
- [Network and Active Directory Services Matrix](../../network/network-and-ad-services-matrix.md)
- [Windows Firewall Baseline](../windows-security/windows-firewall-baseline.md)
- [Enterprise WinRM Management](../administration/enterprise-winrm-management.md)
- [MikroTik Windows Management Firewall Policy](../../network/mikrotik/windows-management-firewall-policy.md)
- [Microsoft Defender Enterprise Baseline](../windows-security/microsoft-defender-baseline.md)
- [Windows LAPS Baseline](../windows-security/windows-laps-baseline.md)

## 2. Architecture

Architecture decision: use a dedicated Windows Event Collector server.

| Item | Validated value |
|---|---|
| Hostname | `HQ-WEC01` |
| IP address | `172.20.20.21` |
| Network | VLAN 20 Servers |
| Domain | `corp.gntech.me` |
| Active Directory placement | `OU=Servers,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me` |
| Role | Windows Event Collector |
| Purpose | Centralized Windows event collection from managed Windows clients |
| Validated event sources | `HQ-W11-001`, `HQ-MGMT01` |
| Validated event destination | `HQ-WEC01` |
| Subscription name | `GEIL-Workstation-Baseline` |
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
             ├─ TCP 5985 ─> HQ-WEC01 (172.20.20.21) ─> Forwarded Events
HQ-MGMT01  ──┘
```

Source-initiated WEF means clients initiate the connection to the collector. The collector does not pull events from clients.

### Network and firewall model

| Source | Destination | Port | Direction | Purpose |
|---|---|---:|---|---|
| VLAN 30 Workstations (`172.20.30.0/24`) | `HQ-WEC01` (`172.20.20.21`) on VLAN 20 | TCP `5985` | Client to collector | `HQ-W11-001` forwards events to WEC. |
| VLAN 10 Management (`172.20.10.0/24`) | `HQ-WEC01` (`172.20.20.21`) on VLAN 20 | TCP `5985` | Client to collector | `HQ-MGMT01` forwards events to WEC. |

Validated firewall finding:

- Windows Firewall was not the issue during pilot validation.
- Missing connectivity was caused by MikroTik inter-VLAN forwarding rules.
- The required routing is:
  - Management VLAN `172.20.10.0/24` to `HQ-WEC01` TCP `5985`.
  - Workstations VLAN `172.20.30.0/24` to `HQ-WEC01` TCP `5985`.
- This flow is client-to-collector WEF traffic, not collector-to-client traffic.
- This flow must not be implemented by allowing broad workstation-to-server administrative access.

## 3. Prerequisites

Infrastructure prerequisites:

- `HQ-DC01` is healthy and provides AD DS, DNS, Kerberos, and Group Policy.
- `HQ-WEC01` is deployed as a Windows Server on VLAN 20 Servers.
- `HQ-WEC01` has static IP address `172.20.20.21`.
- `HQ-WEC01` is joined to `corp.gntech.me`.
- `HQ-WEC01` is placed in `OU=Servers,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me`.
- `HQ-W11-001` exists in the Workstations OU.
- `HQ-MGMT01` exists in the Management Workstations OU.
- `HQ-WEC01.corp.gntech.me` resolves from both pilot clients.
- TCP `5985` from VLAN 10 and VLAN 30 to `HQ-WEC01` is allowed by MikroTik inter-VLAN forwarding policy and the collector host firewall.

Administrative prerequisites:

- Group Policy Management is available on `HQ-MGMT01`.
- The operator has permission to create and link GPOs.
- The operator has local administrative access on `HQ-WEC01`.
- WinRM/Event Collector configuration is approved for the pilot.

## 4. Deployment Workflow

The validated deployment sequence is:

1. Deploy `HQ-WEC01` as Windows Server.
2. Assign static IP `172.20.20.21`.
3. Join `HQ-WEC01` to `corp.gntech.me`.
4. Move `HQ-WEC01` to `OU=Servers,OU=Computers,OU=GNTECH,DC=corp,DC=gntech,DC=me`.
5. Validate GPO processing.
6. Enable Windows Event Collector with `wecutil qc`.
7. Validate `WinRM` and `Wecsvc` services.
8. Create the source-initiated subscription `GEIL-Workstation-Baseline`.
9. Create `GP - Security - Windows Event Forwarding`.
10. Link the GPO to:
    - Workstations OU.
    - Management Workstations OU.
11. Validate client policy with `gpupdate /force` and `gpresult /r /scope computer`.
12. Validate TCP connectivity:
    - `HQ-W11-001` to `HQ-WEC01` TCP `5985`.
    - `HQ-MGMT01` to `HQ-WEC01` TCP `5985`.
13. Validate subscription runtime with `wecutil gr GEIL-Workstation-Baseline`.
14. Validate forwarded events in `ForwardedEvents` on `HQ-WEC01`.

STOP if `HQ-WEC01` is not domain joined or cannot be resolved by DNS. Do not configure WEF around name-resolution or domain-membership failures.

## 5. PowerShell Automation

### Enable Windows Event Collector prerequisites

Run on: `HQ-WEC01`

When: after `HQ-WEC01` is domain joined and placed in the Servers OU.

Expected outcome: Windows Event Collector and WinRM prerequisites are configured and running.

```powershell
wecutil qc
Get-Service WinRM
Get-Service Wecsvc
```

Expected healthy output:

```text
Status   Name               DisplayName
------   ----               -----------
Running  WinRM              Windows Remote Management (WS-Management)
Running  Wecsvc             Windows Event Collector
```

### Validate collector subscriptions

Run on: `HQ-WEC01`

When: after creating `GEIL-Workstation-Baseline`.

Expected outcome: the subscription exists and can be queried.

```powershell
wecutil es
wecutil gs GEIL-Workstation-Baseline
wecutil gr GEIL-Workstation-Baseline
```

Expected healthy output includes:

```text
RunTimeStatus: Active
LastError: 0
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

Expected outcome: the source-initiated subscription `GEIL-Workstation-Baseline` exists for the pilot sources.

Use Event Viewer:

| Field | Value |
|---|---|
| Console | Event Viewer |
| Path | Subscriptions |
| Subscription name | `GEIL-Workstation-Baseline` |
| Subscription type | Source computer initiated |
| Destination log | Forwarded Events |
| Collector | `HQ-WEC01` |
| Validated sources | `HQ-W11-001`, `HQ-MGMT01` |

Do not use `HQ-DC01` as the collector.

## 7. Validation Workflow

### Validate collector configuration

Run on: `HQ-WEC01`

When: after running `wecutil qc` and creating the initial subscription.

Expected outcome: Event Collector and WinRM services are running and subscriptions can be enumerated.

```powershell
wecutil qc
Get-Service WinRM
Get-Service Wecsvc
wecutil es
```

Expected healthy output:

```text
WinRM   Running
Wecsvc  Running
GEIL-Workstation-Baseline
```

### Validate subscription configuration and runtime status

Run on: `HQ-WEC01`

When: after creating the source-initiated subscription.

Expected outcome: `GEIL-Workstation-Baseline` exists, is active, and reports no runtime error.

```powershell
wecutil gs GEIL-Workstation-Baseline
wecutil gr GEIL-Workstation-Baseline
```

Validated healthy output includes:

```text
RunTimeStatus: Active
LastError: 0
```

Validated event sources:

```text
HQ-W11-001
RunTimeStatus: Active

HQ-MGMT01
RunTimeStatus: Active
```

### Validate client GPO and connectivity

Run on: `HQ-W11-001` and `HQ-MGMT01`

When: after linking `GP - Security - Windows Event Forwarding`.

Expected outcome: the GPO applies and the client can reach `HQ-WEC01` on TCP `5985`.

```powershell
gpupdate /force
gpresult /r /scope computer
Test-NetConnection HQ-WEC01 -Port 5985
```

Expected healthy output:

```text
GP - Security - Windows Event Forwarding
TcpTestSucceeded : True
```

### Validate client subscription state

Run on: `HQ-W11-001` and `HQ-MGMT01`

When: after Group Policy refresh and network connectivity validation.

Expected outcome: the client reports the `GEIL-Workstation-Baseline` subscription state.

```powershell
wecutil gr GEIL-Workstation-Baseline
```

Expected healthy output includes:

```text
RunTimeStatus: Active
LastError: 0
```

### Validate forwarded events

Run on: `HQ-WEC01`

When: after client GPO refresh and subscription registration.

Expected outcome: forwarded events arrive in the `ForwardedEvents` log.

```powershell
Get-WinEvent -LogName ForwardedEvents -MaxEvents 20
```

Validated result:

- `ForwardedEvents` successfully receives forwarded events.
- Event ID `111` generated by `Microsoft-Windows-EventForwarder` was observed and confirms event forwarding is operational.

## 8. Pilot Findings

Status: Pilot Validated.

Validated infrastructure:

| Role | System | Validated result |
|---|---|---|
| Collector | `HQ-WEC01` (`172.20.20.21`) | Dedicated Windows Event Collector on VLAN 20 Servers. |
| Source | `HQ-W11-001` | Runtime status active. |
| Source | `HQ-MGMT01` | Runtime status active. |
| Domain | `corp.gntech.me` | GPO-based source-initiated WEF validated. |

Pilot findings:

- `HQ-WEC01` is preferred over using `HQ-DC01` as the collector.
- A dedicated collector better separates Identity from Monitoring.
- The collector only requires TCP `5985` from approved management/client VLANs.
- Successful forwarding was confirmed from `HQ-W11-001`.
- Successful forwarding was confirmed from `HQ-MGMT01`.
- Windows Firewall was not the issue after the correct MikroTik forwarding rules were implemented.
- The missing pilot connectivity was caused by MikroTik inter-VLAN forwarding rules.
- Source-initiated subscriptions require clients to connect to `HQ-WEC01`; the collector never initiates connections to clients.
- Event ID `111` from `Microsoft-Windows-EventForwarder` was observed as confirmation that forwarding is operational.

Validated deployment sequence:

1. Deploy `HQ-WEC01`.
2. Assign static IP `172.20.20.21`.
3. Join `HQ-WEC01` to `corp.gntech.me`.
4. Move `HQ-WEC01` to the Servers OU.
5. Validate GPO processing.
6. Enable Windows Event Collector with `wecutil qc`.
7. Validate `WinRM` and `Wecsvc`.
8. Create source-initiated subscription `GEIL-Workstation-Baseline`.
9. Create `GP - Security - Windows Event Forwarding`.
10. Link GPO to Workstations and Management Workstations OUs.
11. Validate client GPO application.
12. Validate TCP `5985` connectivity to `HQ-WEC01`.
13. Validate subscription runtime status.
14. Validate events in `ForwardedEvents`.

## 9. Operations

### Check collector health

Run on: `HQ-WEC01`

When: daily during pilot validation and after collector or GPO changes.

Expected outcome: WEC and WinRM are running and subscriptions are visible.

```powershell
Get-Service WinRM
Get-Service Wecsvc
wecutil es
```

### Check subscriptions

Run on: `HQ-WEC01`

When: after subscription changes or during periodic monitoring checks.

Expected outcome: `GEIL-Workstation-Baseline` exists and is enabled.

```powershell
wecutil es
wecutil gs GEIL-Workstation-Baseline
```

### Check source status

Run on: `HQ-WEC01`

When: validating source registration and runtime health.

Expected outcome: `HQ-W11-001` and `HQ-MGMT01` show active runtime status.

```powershell
wecutil gr GEIL-Workstation-Baseline
```

### Check heartbeat

Run on: `HQ-WEC01`

When: confirming source-initiated clients continue reporting after initial registration.

Expected outcome: subscription runtime remains active and no last error is reported.

```powershell
wecutil gr GEIL-Workstation-Baseline
```

Expected healthy output:

```text
RunTimeStatus: Active
LastError: 0
```

### Check Forwarded Events

Run on: `HQ-WEC01`

When: after pilot clients refresh Group Policy or during monitoring checks.

Expected outcome: recent events are present in the `ForwardedEvents` log.

```powershell
Get-WinEvent -LogName ForwardedEvents -MaxEvents 20
```

### Check client policy and connectivity

Run on: `HQ-W11-001` and `HQ-MGMT01`

When: after `gpupdate /force`, reboot, GPO change, subscription change, or network firewall change.

Expected outcome: client applies the GPO and can reach the collector.

```powershell
gpresult /r /scope computer
Test-NetConnection HQ-WEC01 -Port 5985
wecutil gr GEIL-Workstation-Baseline
```

### Operational boundaries

- Keep `HQ-WEC01` dedicated to event collection during this phase.
- Do not move the collector role to `HQ-DC01`.
- Do not integrate SIEM or observability platforms until the native WEF pilot remains stable.
- Do not broaden firewall policy beyond the required client-to-collector TCP `5985` flow.

## 10. Troubleshooting

| Issue | Symptoms | Validation commands | Resolution |
|---|---|---|---|
| Subscription exists but no sources | `wecutil es` lists the subscription, but `wecutil gr GEIL-Workstation-Baseline` does not show `HQ-W11-001` or `HQ-MGMT01` | `wecutil gr GEIL-Workstation-Baseline`; client `gpresult /r /scope computer` | Confirm GPO application, source computer scope, subscription manager URL, and client network connectivity. |
| Source cannot reach collector | `Test-NetConnection HQ-WEC01 -Port 5985` fails | `Test-NetConnection HQ-WEC01 -Port 5985`; DNS lookup for `HQ-WEC01` | Fix DNS or MikroTik inter-VLAN forwarding from the source VLAN to `172.20.20.21` TCP `5985`. |
| Collector service stopped | No incoming events; subscription runtime may fail | `Get-Service Wecsvc`; `wecutil es` | Start Wecsvc and set startup type to Automatic if needed. |
| WinRM stopped | Clients cannot register with collector | `Get-Service WinRM`; `Test-NetConnection HQ-WEC01 -Port 5985` | Start WinRM and confirm TCP `5985` listener and firewall policy. |
| GPO not applied | Client does not receive subscription manager URL | `gpresult /r /scope computer` | Confirm OU placement, GPO link, security filtering, and AD replication. |
| Forwarded Events empty | Source is active but no events appear in `ForwardedEvents` | `Get-WinEvent -LogName ForwardedEvents -MaxEvents 20`; `wecutil gr GEIL-Workstation-Baseline` | Confirm subscription query, generate matching events, wait for refresh, and verify source runtime status. |
| MikroTik forwarding rule missing | Windows Firewall appears correct, but clients cannot reach `HQ-WEC01` on TCP `5985` | Client `Test-NetConnection HQ-WEC01 -Port 5985`; MikroTik firewall counters | Add/repair forward-chain rules allowing VLAN 10 and VLAN 30 to `HQ-WEC01` TCP `5985` before broad denies. |
| Wrong collector used | GPO or documentation points to `HQ-DC01` | GPO setting check; `gpresult /r /scope computer` | Correct the subscription manager to `HQ-WEC01.corp.gntech.me`. This EPIC does not use `HQ-DC01` as collector. |

## 11. Acceptance Criteria

This EPIC is complete when all criteria below are met:

- [x] `HQ-WEC01` is deployed as a Windows Server on VLAN 20 Servers.
- [x] `HQ-WEC01` uses static IP `172.20.20.21`.
- [x] `HQ-WEC01` is joined to `corp.gntech.me`.
- [x] `HQ-WEC01` is placed in the Servers OU.
- [x] Windows Event Collector service is enabled and running.
- [x] WinRM is enabled and running on `HQ-WEC01`.
- [x] Source-initiated subscription `GEIL-Workstation-Baseline` exists on `HQ-WEC01`.
- [x] `GP - Security - Windows Event Forwarding` exists.
- [x] GPO is linked to Workstations OU.
- [x] GPO is linked to Management Workstations OU.
- [x] Subscription manager points to `Server=http://HQ-WEC01.corp.gntech.me:5985/wsman/SubscriptionManager/WEC,Refresh=60`.
- [x] `HQ-W11-001` applies the GPO.
- [x] `HQ-MGMT01` applies the GPO.
- [x] `HQ-W11-001` reaches `HQ-WEC01` on TCP `5985`.
- [x] `HQ-MGMT01` reaches `HQ-WEC01` on TCP `5985`.
- [x] `wecutil gr GEIL-Workstation-Baseline` reports `RunTimeStatus: Active` and `LastError: 0`.
- [x] `ForwardedEvents` on `HQ-WEC01` receives events from the pilot sources.
- [x] Event ID `111` from `Microsoft-Windows-EventForwarder` was observed.
- [x] Pilot Findings are updated with real deployment results.

!!! note "Network configuration authority"

    Network configuration authority now lives under `docs/network/`. Use [Network](../../network/index.md) for current network, VLAN, firewall, DNS, DHCP, and service-path authority.
