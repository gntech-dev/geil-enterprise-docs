---
title: MikroTik Windows Management Firewall Policy
document_id: GEIL-NET-MTK-WINMGMT-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-07-02
review_cycle: Quarterly
classification: Internal Confidential
---

# MikroTik Windows Management Firewall Policy

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-NET-MTK-WINMGMT-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-07-02 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose and scope

This document defines a practical MikroTik RouterOS firewall policy for controlling Windows administration traffic between VLANs in the GNTECH Windows infrastructure lab.

Windows Group Policy enables services such as RDP and WinRM on Windows systems. MikroTik controls whether those services are reachable across VLAN boundaries. Both layers are required. Canonical VLANs, subnets, and service-port expectations come from the [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md).

This guide complements:

- [MikroTik CHR HQ Foundation Implementation](../../platform/mikrotik-chr-hq-foundation-implementation.md)
- [Firewall Rule Matrix](../../platform/firewall-rule-matrix.md)
- [WinRM / PowerShell Remoting Baseline](../../microsoft-core/windows-server-management/winrm-powershell-remoting-baseline.md)
- [Enterprise WinRM Management](../../microsoft-core/administration/enterprise-winrm-management.md)
- [Windows Event Forwarding and Collector Baseline](../../microsoft-core/windows-monitoring/windows-event-forwarding-baseline.md)

## Management plane principle

- Management VLAN can administer servers and approved managed Windows endpoints.
- User VLANs should not administer infrastructure.
- IoT, CCTV, Guest, and untrusted VLANs should not reach Windows management ports.
- WAN must never expose RDP or WinRM directly.
- Cloudflare Tunnel / Browser Rendering access must terminate into controlled internal access paths and must not bypass VLAN firewall logic.

## Access matrix

| Source | Destination | Access | Ports |
|---|---|---|---|
| MGMT Workstation VLAN | Domain Controllers | Allow | 3389, 5985/5986, 445, 53, 88, 389, 636 |
| MGMT Workstation VLAN | Member Servers | Allow | 3389, 5985/5986, 445 |
| HOME VLAN | Domain Controllers | Limited | DNS/Kerberos/LDAP as required |
| HOME VLAN | Member Servers | Limited | Application-specific only |
| IoT VLAN | Domain Controllers | Deny | Windows management ports blocked |
| CCTV VLAN | Domain Controllers | Deny | Windows management ports blocked |
| Guest VLAN | Internal Infrastructure | Deny | All management ports blocked |

For the current GNTECH implementation, the Management VLAN is VLAN 10 (`172.20.10.0/24`), Servers are VLAN 20 (`172.20.20.0/24`), and Workstations are VLAN 30 (`172.20.30.0/24`). Actual CIDRs must come from the [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md).

## Windows management ports

| Service | Protocol | Port |
|---|---|---:|
| RDP | TCP | 3389 |
| WinRM HTTP | TCP | 5985 |
| WinRM HTTPS | TCP | 5986 |
| SMB / Admin shares | TCP | 445 |
| RPC Endpoint Mapper | TCP | 135 |
| Dynamic RPC range | TCP | 49152-65535 |
| DNS | TCP/UDP | 53 |
| Kerberos | TCP/UDP | 88 |
| LDAP | TCP/UDP | 389 |
| LDAPS | TCP | 636 |
| Global Catalog | TCP | 3268 / 3269 |
| NTP | UDP | 123 |

Dynamic RPC ports should be allowed only where truly required. Do not broadly allow TCP `49152-65535` between all VLANs.

## Address-list model

Use RouterOS address lists so rules are readable and maintainable.

Run on: `HQ-FW01`

When: before adding Windows management firewall rules.

Expected outcome: RouterOS address lists exist for management sources, AD servers, and member servers.

```routeros
/ip firewall address-list
add list=MGMT_SUBNETS address=172.20.10.0/24 comment="Management VLAN"
add list=AD_SERVERS address=172.20.20.11 comment="HQ-DC01"
add list=AD_SERVERS address=172.20.20.12 comment="HQ-DC02 future"
add list=MEMBER_SERVERS address=172.20.20.0/24 comment="Member servers - adjust when dedicated server hosts exist"
add list=WEC_SERVERS address=172.20.20.21 comment="HQ-WEC01 - Windows Event Collector"
add list=WORKSTATION_SUBNETS address=172.20.30.0/24 comment="Windows workstation VLAN"
```

If adapting this document, replace example subnets with the actual VLAN plan from the canonical matrix before applying rules.

## RouterOS rule examples

Rules must be placed before broad drop rules. Existing `established,related` accept rules should remain near the top. Do not blindly paste into production without reviewing current firewall order.

Run on: `HQ-FW01`

When: after address lists exist and before the default deny inter-VLAN rule.

Expected outcome: Management VLAN can reach approved Windows management ports; non-management VLANs cannot reach RDP or WinRM on infrastructure.

```routeros
/ip firewall filter
add chain=forward action=accept src-address-list=MGMT_SUBNETS dst-address-list=AD_SERVERS protocol=tcp dst-port=3389,5985,5986,445,135 comment="Allow MGMT to AD servers - Windows management TCP"
add chain=forward action=accept src-address-list=MGMT_SUBNETS dst-address-list=AD_SERVERS protocol=udp dst-port=53,88,123,389 comment="Allow MGMT to AD servers - AD UDP services"
add chain=forward action=accept src-address-list=MGMT_SUBNETS dst-address-list=AD_SERVERS protocol=tcp dst-port=53,88,389,636,3268,3269 comment="Allow MGMT to AD servers - AD TCP services"
add chain=forward action=accept src-address-list=MGMT_SUBNETS dst-address-list=MEMBER_SERVERS protocol=tcp dst-port=3389,5985,5986,445 comment="Allow MGMT to member servers - Windows management"
add chain=forward action=accept src-address-list=MGMT_SUBNETS dst-address-list=WORKSTATION_SUBNETS protocol=tcp dst-port=5985 comment="Allow MGMT to workstations - WinRM"
add chain=forward action=accept src-address-list=MGMT_SUBNETS dst-address-list=WEC_SERVERS protocol=tcp dst-port=5985 comment="Allow MGMT clients to HQ-WEC01 - WEF"
add chain=forward action=accept src-address-list=WORKSTATION_SUBNETS dst-address-list=WEC_SERVERS protocol=tcp dst-port=5985 comment="Allow workstation clients to HQ-WEC01 - WEF"
add chain=forward action=drop src-address-list=WORKSTATION_SUBNETS dst-address-list=AD_SERVERS protocol=tcp dst-port=3389,5985 comment="Drop Workstations VLAN to AD admin ports before broad allows"
add chain=forward action=drop dst-address-list=AD_SERVERS protocol=tcp dst-port=3389,5985,5986 comment="Block non-MGMT Windows admin access to AD servers"
add chain=forward action=drop dst-address-list=MEMBER_SERVERS protocol=tcp dst-port=3389,5985,5986,445,135 comment="Block non-MGMT Windows admin access to member servers"
```


!!! info "Windows Event Forwarding to HQ-WEC01"

    WEF source-initiated subscriptions require clients to connect to `HQ-WEC01` on TCP `5985`. Pilot validation found that Windows Firewall was not the issue; missing connectivity was caused by MikroTik inter-VLAN forwarding rules. Allow VLAN 10 (`172.20.10.0/24`) and VLAN 30 (`172.20.30.0/24`) to `HQ-WEC01` (`172.20.20.21`) on TCP `5985` without opening broad workstation-to-server administrative access.

!!! warning "VLAN30 broad allow rule order"

    Pilot validation found that a broad or temporary VLAN30-to-`HQ-DC01` allow rule can accidentally permit TCP `3389` and TCP `5985`. Place the Workstations VLAN to AD admin-port drop rule before any broad VLAN30-to-`HQ-DC01` allow rule. VLAN 30 should reach required AD DS ports such as TCP `53`, `88`, `389`, and `445`, but must not administer Domain Controllers over RDP or WinRM.

!!! warning "Do not expose management ports from WAN"

    Do not allow RDP, WinRM, SMB, or RPC from WAN. If Cloudflare Tunnel / Browser Rendering is used, it must still terminate into controlled internal access paths and must not bypass VLAN firewall logic.

## Rule ordering guidance

- Keep `established,related` accept near the top.
- Drop invalid traffic near the top.
- Add specific management allows before broad deny rules.
- Add non-management blocks before generic LAN-to-LAN allows if such broad rules exist.
- Keep Guest-to-internal deny rules explicit.
- Review existing comments and counters before inserting new rules.
- Export the firewall configuration before changes.

Run on: `HQ-FW01`

When: before editing a production or pilot firewall rule set.

Expected outcome: an export exists for rollback and current rule order is visible.

```routeros
/export file=pre-windows-management-firewall-policy
/ip firewall filter print stats
/ip firewall address-list print
```

## Validation from Management Workstation

Run on: `HQ-MGMT01`

When: after MikroTik rules are placed, Windows Firewall rules are applied, and the destination host is online.

Expected outcome: Management VLAN succeeds for RDP and WinRM where policy allows.

```powershell
Test-NetConnection HQ-DC01 -Port 3389
Test-NetConnection HQ-DC01 -Port 5985
Test-WSMan HQ-DC01
```

Generic names such as `DC01` are placeholders only. For implementation, use canonical names such as `HQ-DC01` or `HQ-W11-001` according to the validation being performed.

## Validation from non-management VLAN test client

Run on: `Windows Client`

When: after Management VLAN validation succeeds.

Expected outcome: non-management VLAN clients fail to reach RDP and WinRM on infrastructure targets.

```powershell
Test-NetConnection HQ-DC01 -Port 3389
Test-NetConnection HQ-DC01 -Port 5985
```

Expected result:

- Management VLAN succeeds.
- Non-management VLAN fails for RDP/WinRM.
- Guest, IoT, CCTV, and untrusted VLANs cannot reach Windows management ports.

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Management workstation cannot reach WinRM | Rule missing, wrong address list, Windows Firewall scope mismatch | Validate `MGMT_SUBNETS`, destination list, TCP `5985`, and Windows Firewall remote address scope. |
| Non-management VLAN reaches RDP/WinRM | Broad allow rule before deny | Move specific blocks before broad inter-VLAN permits. |
| DNS works but WinRM fails | AD service rules exist but management rules do not | Add or correct Management VLAN to destination TCP `5985`. |
| RDP works but WinRM fails | WinRM GPO or Windows Firewall missing | Validate `GP - Security - WinRM` and target Windows Firewall rules. |
| Rule counters do not increment | Traffic using different target, route, or address list | Validate DNS resolution, route, and address-list membership. |

## Firewall Validation Checklist

- [ ] Firewall export captured before changes.
- [ ] Address lists match the [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md).
- [ ] Management VLAN can reach approved Windows management ports.
- [ ] User VLANs cannot administer infrastructure.
- [ ] IoT, CCTV, Guest, and untrusted VLANs cannot reach Windows management ports.
- [ ] WAN does not expose RDP, WinRM, SMB, RPC, LDAP, or Kerberos.
- [ ] Rules are above broad drop rules where required.
- [ ] Established/related rules remain near the top.
- [ ] Dynamic RPC range is not broadly allowed between all VLANs.
- [ ] Cloudflare Tunnel / Browser Rendering does not bypass internal firewall policy.

## Future improvements

As the lab matures, consider:

- More granular PAW source lists.
- Separate server role destination lists.
- Certificate-based WinRM HTTPS where required.
- Just Enough Administration.
- Automated rule validation and configuration drift checks.
- Multi-site address-list standards.
