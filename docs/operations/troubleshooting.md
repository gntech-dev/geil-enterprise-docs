---
title: Troubleshooting
document_id: GEIL-OPS-TS-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Troubleshooting

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-OPS-TS-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

!!! note "Adaptation"

    This document uses canonical GNTECH values from the [Environment Specification](../project/environment-specification.md). Organizations adapting this design should change the environment specification first, then update all affected DNS zones, certificates, PowerShell commands, Group Policies, VLANs, firewall rules, and service configurations.

## Purpose

Provide first-response troubleshooting workflow for GEIL infrastructure incidents.

## Incident triage order

1. Scope: one user, one device, one site, or global.
2. Identity: sign-in, MFA, token, account lockout, replication.
3. Network: DNS, DHCP, routing, firewall, VPN.
4. Endpoint: Intune policy, Defender, Windows update, certificate state.
5. Service: Microsoft 365 service health, server event logs, application logs.

## AD health commands

```powershell
dcdiag /e /c /v
repadmin /replsummary
Get-ADReplicationFailure -Scope Forest
```

## DNS commands

```powershell
Resolve-DnsName corp.gntech.me
Resolve-DnsName _ldap._tcp.dc._msdcs.corp.gntech.me -Type SRV
ipconfig /displaydns
```

## Expected result

The failing layer is identified with evidence before remediation begins.

## Rollback

If a fix worsens impact, revert the last change, restore previous firewall/GPO/policy configuration, and escalate to incident command.
