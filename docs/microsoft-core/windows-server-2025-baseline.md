---
title: Windows Server 2025 Baseline
document_id: GEIL-MSC-WS2025-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Windows Server 2025 Baseline

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-WS2025-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Standardize Windows Server 2025 build settings before installing infrastructure roles.

## Build procedure

1. Deploy from approved ISO or image template.
2. Assign static IP, DNS, and host name.
3. Install latest cumulative updates.
4. Enable Windows Defender and firewall.
5. Install management tooling.
6. Join domain only after DNS and time are correct.

## PowerShell implementation

```powershell
Rename-Computer -NewName "HQ-DC01" -Restart
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "10.10.20.11" -PrefixLength 24 -DefaultGateway "10.10.20.1"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "10.10.20.11","10.10.20.12"
Install-WindowsFeature -Name RSAT-AD-PowerShell,RSAT-DNS-Server -IncludeAllSubFeature
```

Expected result: server reboots with correct name, IP configuration, and tools installed.

## Validation

```powershell
Get-ComputerInfo | Select CsName,WindowsProductName,OsHardwareAbstractionLayer
Get-NetIPAddress -AddressFamily IPv4
Get-DnsClientServerAddress -AddressFamily IPv4
```

## Rollback

Use VM snapshot only before domain promotion or role installation. After production role installation, use role-specific rollback and system-state backup, not arbitrary snapshots.
