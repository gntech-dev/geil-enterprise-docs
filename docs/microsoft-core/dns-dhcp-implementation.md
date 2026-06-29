---
title: DNS and DHCP Implementation
document_id: GEIL-MSC-DNSDHCP-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# DNS and DHCP Implementation

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-DNSDHCP-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Implement reliable internal name resolution and address assignment for domain-joined and infrastructure systems.

## DNS implementation

AD-integrated DNS zones are created with the forest. Configure secure dynamic updates only.

```powershell
Set-DnsServerPrimaryZone -Name "<AD_DOMAIN_FQDN>" -DynamicUpdate Secure
Add-DnsServerForwarder -IPAddress 1.1.1.1,1.0.0.1
Get-DnsServerForwarder
```

Expected result: internal zone accepts secure updates, and forwarders are configured.

## DHCP implementation

Install DHCP on two servers where possible and configure failover.

```powershell
Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerInDC -DnsName "HQ-DC01.<AD_DOMAIN_FQDN>" -IPAddress 10.10.20.11
Add-DhcpServerv4Scope -Name "CLIENT-HQ" -StartRange 10.10.30.50 -EndRange 10.10.30.250 -SubnetMask 255.255.255.0
Set-DhcpServerv4OptionValue -ScopeId 10.10.30.0 -Router 10.10.30.1 -DnsServer 10.10.20.11,10.10.20.12 -DnsDomain "<AD_DOMAIN_FQDN>"
```

## Validation

```powershell
Resolve-DnsName _ldap._tcp.dc._msdcs.<AD_DOMAIN_FQDN> -Type SRV
Get-DhcpServerInDC
Get-DhcpServerv4Scope
ipconfig /renew
ipconfig /all
```

Expected result: SRV records resolve, DHCP server is authorized, client receives correct gateway and DNS.

## Rollback

Remove bad DHCP scopes with `Remove-DhcpServerv4Scope` before clients renew. Remove incorrect DNS records with `Remove-DnsServerResourceRecord` after confirming they are stale.
