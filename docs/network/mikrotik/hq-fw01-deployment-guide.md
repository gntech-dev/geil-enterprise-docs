---
title: HQ-FW01 Deployment Guide
document_id: GEIL-NET-MTK-HQFW01-DEPLOY-001
owner: Infrastructure Engineering
status: Pilot Validated
version: 1.0
last_reviewed: 2026-07-08
review_cycle: Per validated export
classification: Internal Confidential
---

# HQ-FW01 Deployment Guide

## Purpose

This guide deploys `HQ-FW01`, the MikroTik RouterOS firewall/router for the GEIL Enterprise Lab, from factory defaults to the validated pilot configuration.

The validated reference is the RouterOS export stored at `/home/gntech/geil/mikrotik-export.txt` and published as the sanitized [HQ-FW01 RouterOS Export - Current Validated Snapshot](hq-fw01-routeros-export-current.md). This guide does not copy the export. It derives the implementation workflow from the validated configuration and explains the order, purpose, expected outcome, and validation gates for a clean deployment.

Use this guide when building a new `HQ-FW01` instance or rebuilding the pilot router after factory reset.

## Document relationships

| Document | Responsibility |
|---|---|
| This deployment guide | How to build `HQ-FW01` from factory defaults to the validated pilot configuration. |
| [HQ-FW01 RouterOS Baseline](hq-fw01-routeros-baseline.md) | Design standard and current RouterOS baseline values. |
| [HQ-FW01 RouterOS Export - Current Validated Snapshot](hq-fw01-routeros-export-current.md) | Sanitized current configuration snapshot from the validated pilot export. |
| [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md) | Firewall intent, validated rule order, and temporary pilot firewall rules. |
| [Cloudflared Container Networking](cloudflared-container-networking.md) | Cloudflared container network boundaries and operational validation. |
| [VLAN and Subnet Plan](../vlan-and-subnet-plan.md) | Canonical VLAN IDs, subnets, gateways, and example systems. |
| [Network and AD Services Matrix](../network-and-ad-services-matrix.md) | Canonical service paths for AD DS, Windows management, WEF, and inter-VLAN expectations. |

## Architecture

`HQ-FW01` is the RouterOS CHR firewall and routing boundary for the current GEIL Enterprise Lab pilot. It provides:

- `GEILWAN` transit connectivity using `ether1` and `172.31.255.2/30`.
- VLAN gateway interfaces on `ether2` for Management, Servers, Workstations, Printers, Voice, Corporate WiFi, Guest WiFi, DMZ, Backup, and Hypervisor networks.
- DHCP relay from selected VLANs to `HQ-DC01` at `172.20.20.11`.
- RouterOS DNS forwarding for lab clients where required.
- RouterOS container networking for the Cloudflared tunnel container.
- Cloudflared container support for private access paths.
- Inter-VLAN firewall policy with default deny forwarding.
- WinRM support for validated Windows management paths.
- WEF support for source-initiated forwarding to `HQ-WEC01` at `172.20.20.21`.

High-level traffic model:

```text
GEILWAN / Proxmox peer
↓
HQ-FW01 ether1
↓
HQ-FW01 VLAN gateways on ether2
↓
Management, Servers, Workstations, Guest, DMZ, Backup, Hypervisor networks
```

## Prerequisites

| Requirement | Current validated value |
|---|---|
| RouterOS version | `7.21.4` |
| Router identity | `HQ-FW01` |
| WAN interface | `ether1` |
| VLAN trunk interface | `ether2` |
| WAN / GEILWAN address | `172.31.255.2/30` |
| WAN / GEILWAN peer gateway | `172.31.255.1` |
| Domain Controller / DHCP server | `HQ-DC01`, `172.20.20.11` |
| Management workstation | `HQ-MGMT01`, `172.20.10.10` |
| WEF collector | `HQ-WEC01`, `172.20.20.21` |
| Proxmox management target | `172.20.100.11`, TCP `8006` |
| Container subnet | `172.17.0.0/24` |
| Cloudflared container IP | `172.17.0.2` |

Before deployment:

- Confirm the CHR VM or physical RouterOS instance has `ether1` connected to GEILWAN and `ether2` connected to the lab VLAN trunk.
- Confirm VLANs and subnets in [VLAN and Subnet Plan](../vlan-and-subnet-plan.md).
- Confirm service paths in [Network and AD Services Matrix](../network-and-ad-services-matrix.md).
- Confirm firewall intent in [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md).
- Confirm Cloudflared prerequisites and token handling in [Cloudflared Container Networking](cloudflared-container-networking.md).
- Confirm Windows infrastructure exists for DHCP relay, WinRM, and WEF validation.

!!! warning "Safe Mode"

    Enter RouterOS Safe Mode before applying management service restrictions or default-deny firewall rules. Do not continue if you do not have a working console or recovery path.

## Deployment workflow

### Phase 1: Initial RouterOS preparation

#### Purpose

Prepare a factory-default RouterOS instance for deterministic deployment without relying on inherited configuration.

#### Configuration

Run on: `HQ-FW01 console`

When: after first boot, before applying any routed firewall or service restrictions.

Expected outcome: the operator has console access, Safe Mode is active, and the router is ready for baseline configuration.

```routeros
/system resource print
/system package print
/export terse
```

If the router contains previous configuration, reset it only when you have console access and the change window permits a rebuild.

#### Expected outcome

- RouterOS is reachable through console or an approved bootstrap management path.
- RouterOS version is confirmed as `7.21.4` or an approved newer version.
- No unknown inherited configuration remains.

### Phase 2: Identity

#### Purpose

Set the router identity so logs, exports, monitoring, and troubleshooting clearly identify this device as `HQ-FW01`.

#### Configuration

Run on: `HQ-FW01`

When: after initial RouterOS preparation.

Expected outcome: system identity is set to `HQ-FW01`.

```routeros
/system identity set name=HQ-FW01
/system identity print
```

#### Expected outcome

`/system identity print` shows `HQ-FW01`.

### Phase 3: Interface lists

#### Purpose

Create interface lists before firewall rules, management service limits, MAC server limits, or neighbor discovery restrictions reference them.

#### Configuration

Run on: `HQ-FW01`

When: before VLAN membership, firewall, neighbor discovery, or service restriction configuration.

Expected outcome: the required interface lists exist.

```routeros
/interface list add name=WAN comment="External/transit interfaces"
/interface list add name=LAN comment="Internal non-guest interfaces"
/interface list add name=MGMT comment="Approved firewall management interfaces"
/interface list add name=SERVERS comment="Server VLAN interfaces"
/interface list add name=WORKSTATIONS comment="Workstation VLAN interfaces"
/interface list add name=GUEST comment="Guest-only VLAN interfaces"
/interface list print
```

#### Expected outcome

Lists `WAN`, `LAN`, `MGMT`, `SERVERS`, `WORKSTATIONS`, and `GUEST` exist.

### Phase 4: VLAN interfaces

#### Purpose

Create VLAN gateway interfaces on the validated trunk interface `ether2`.

#### Configuration

Run on: `HQ-FW01`

When: after interface lists exist and before IP addressing.

Expected outcome: VLAN interfaces exist on `ether2` for the current pilot VLAN plan.

```routeros
/interface vlan add interface=ether2 name=vlan10-mgmt vlan-id=10
/interface vlan add interface=ether2 name=vlan20-servers vlan-id=20
/interface vlan add interface=ether2 name=vlan30-workstations vlan-id=30
/interface vlan add interface=ether2 name=vlan40-printers vlan-id=40
/interface vlan add interface=ether2 name=vlan50-voice vlan-id=50
/interface vlan add interface=ether2 name=vlan60-corpwifi vlan-id=60
/interface vlan add interface=ether2 name=vlan70-guestwifi vlan-id=70
/interface vlan add interface=ether2 name=vlan80-dmz vlan-id=80
/interface vlan add interface=ether2 name=vlan90-backup vlan-id=90
/interface vlan add interface=ether2 name=vlan100-hypervisor vlan-id=100
/interface vlan print
```

#### Expected outcome

All VLAN interfaces from VLAN10 through VLAN100 exist and use parent interface `ether2`.

### Phase 5: IP addressing and interface-list membership

#### Purpose

Assign GEILWAN and VLAN gateway addresses, then place interfaces into the correct lists for firewall and service controls.

#### Configuration

Run on: `HQ-FW01`

When: after VLAN interfaces exist.

Expected outcome: `HQ-FW01` owns the validated gateway IPs and interface-list memberships.

```routeros
/ip address add address=172.31.255.2/30 interface=ether1 comment="GEILWAN CHR WAN"
/ip address add address=172.20.10.1/24 interface=vlan10-mgmt comment="VLAN10 Management gateway"
/ip address add address=172.20.20.1/24 interface=vlan20-servers comment="VLAN20 Servers gateway"
/ip address add address=172.20.30.1/24 interface=vlan30-workstations comment="VLAN30 Workstations gateway"
/ip address add address=172.20.40.1/24 interface=vlan40-printers comment="VLAN40 Printers gateway"
/ip address add address=172.20.50.1/24 interface=vlan50-voice comment="VLAN50 Voice gateway"
/ip address add address=172.20.60.1/24 interface=vlan60-corpwifi comment="VLAN60 Corporate WiFi gateway"
/ip address add address=172.20.70.1/24 interface=vlan70-guestwifi comment="VLAN70 Guest WiFi gateway"
/ip address add address=172.20.80.1/24 interface=vlan80-dmz comment="VLAN80 DMZ gateway"
/ip address add address=172.20.90.1/24 interface=vlan90-backup comment="VLAN90 Backup gateway"
/ip address add address=172.20.100.1/24 interface=vlan100-hypervisor comment="VLAN100 Hypervisors gateway"
/interface list member add interface=ether1 list=WAN
/interface list member add interface=vlan10-mgmt list=MGMT
/interface list member add interface=vlan100-hypervisor list=MGMT
/interface list member add interface=vlan20-servers list=SERVERS
/interface list member add interface=vlan30-workstations list=WORKSTATIONS
/interface list member add interface=vlan70-guestwifi list=GUEST
```

Add non-guest internal VLANs to `LAN`:

Run on: `HQ-FW01`

When: after validated VLAN gateway addresses are present.

Expected outcome: approved internal VLANs are members of the `LAN` interface list.

```routeros
/interface list member add interface=vlan10-mgmt list=LAN
/interface list member add interface=vlan20-servers list=LAN
/interface list member add interface=vlan30-workstations list=LAN
/interface list member add interface=vlan40-printers list=LAN
/interface list member add interface=vlan50-voice list=LAN
/interface list member add interface=vlan60-corpwifi list=LAN
/interface list member add interface=vlan80-dmz list=LAN
/interface list member add interface=vlan90-backup list=LAN
/interface list member add interface=vlan100-hypervisor list=LAN
/ip address print
/interface list member print
```

#### Expected outcome

- `ether1` has `172.31.255.2/30`.
- VLAN gateways match [VLAN and Subnet Plan](../vlan-and-subnet-plan.md).
- Guest VLAN is not in `LAN`.
- `vlan10-mgmt` and `vlan100-hypervisor` are in `MGMT`.

### Phase 6: DHCP relay

#### Purpose

Relay DHCP requests from selected VLANs to `HQ-DC01` while keeping VLAN70 Guest WiFi independent from AD DHCP.

#### Configuration

Run on: `HQ-FW01`

When: after VLAN gateway addresses exist and `HQ-DC01` DHCP scopes are ready.

Expected outcome: DHCP relay exists for validated pilot VLANs.

```routeros
/ip dhcp-relay add name=relay-vlan10 interface=vlan10-mgmt dhcp-server=172.20.20.11 local-address=172.20.10.1
/ip dhcp-relay add name=relay-vlan30 interface=vlan30-workstations dhcp-server=172.20.20.11 local-address=172.20.30.1
/ip dhcp-relay add name=relay-vlan40 interface=vlan40-printers dhcp-server=172.20.20.11
/ip dhcp-relay add name=relay-vlan60 interface=vlan60-corpwifi dhcp-server=172.20.20.11
/ip dhcp-relay print detail
```

#### Expected outcome

Relays exist for VLAN10, VLAN30, VLAN40, and VLAN60. Do not add a relay for VLAN70 Guest WiFi.

### Phase 7: DNS

#### Purpose

Enable RouterOS DNS forwarding for lab segments that use the router as a resolver or need router-side DNS during bootstrap.

#### Configuration

Run on: `HQ-FW01`

When: after WAN route planning is complete and before client validation.

Expected outcome: remote DNS requests are allowed and upstream resolvers are configured.

```routeros
/ip dns set allow-remote-requests=yes servers=1.1.1.1,1.0.0.1
/ip dns print
```

#### Expected outcome

DNS shows `allow-remote-requests: yes` and upstream servers `1.1.1.1,1.0.0.1`.

### Phase 8: Container bridge

#### Purpose

Create the RouterOS container network used by Cloudflared.

#### Configuration

Run on: `HQ-FW01`

When: before creating the Cloudflared container.

Expected outcome: bridge `containers`, VETH `veth-cloudflared`, and gateway `172.17.0.1/24` exist.

```routeros
/interface bridge add name=containers comment="Container bridge"
/interface veth add name=veth-cloudflared address=172.17.0.2/24 gateway=172.17.0.1
/interface bridge port add bridge=containers interface=veth-cloudflared
/ip address add address=172.17.0.1/24 interface=containers comment="Gateway for containers"
/interface bridge print
/interface veth print detail
```

#### Expected outcome

- `containers` bridge exists.
- `veth-cloudflared` has `172.17.0.2/24` and gateway `172.17.0.1`.
- `containers` has `172.17.0.1/24`.

### Phase 9: Cloudflared container

#### Purpose

Deploy the Cloudflared RouterOS container used for the current private access pilot.

#### Configuration

Run on: `HQ-FW01`

When: after container bridge, VETH, DNS, route, and outbound NAT are ready.

Expected outcome: Cloudflared container exists, starts on boot, and uses a protected tunnel token.

```routeros
/container config set registry-url=https://registry-1.docker.io tmpdir=/pcie1-part1/pull
/container envs add list=ENV_CLOUDFLARED key=TUNNEL_TOKEN value="REPLACE_WITH_APPROVED_TUNNEL_TOKEN"
/container add name=cloudflared remote-image=cloudflare/cloudflared:latest interface=veth-cloudflared root-dir=/pcie1-part1/cloudflared envlists=ENV_CLOUDFLARED cmd="tunnel --no-autoupdate run" hostname=cloudflared dns=1.1.1.1 start-on-boot=yes workdir=/home/nonroot logging=yes
/container print detail
```

#### Expected outcome

- Container `cloudflared` exists.
- Token is not documented or committed.
- `start-on-boot` is enabled.
- Container interface is `veth-cloudflared`.

### Phase 10: Firewall INPUT

#### Purpose

Protect the router itself while allowing required management, DHCP relay, and Cloudflared-to-router access.

#### Configuration

Run on: `HQ-FW01`

When: after interface lists exist and before enabling service restrictions. Keep Safe Mode active.

Expected outcome: input rules allow only validated router access before default deny.

Use [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md) for authoritative rule order and comments. The input policy must include these groups in order:

1. Accept established/related to router.
2. Drop invalid to router.
3. Allow Management VLAN and `HQ-MGMT01` to router services.
4. Allow Cloudflared container SSH to CHR where required by the pilot.
5. Allow DHCP client requests and DHCP server replies for relay operation.
6. Drop unapproved traffic to router.

Validation commands:

Run on: `HQ-FW01`

When: after input rules are applied.

Expected outcome: input rules appear in the expected order and default deny is last.

```routeros
/ip firewall filter print where chain=input
/ip firewall filter print stats where chain=input
```

### Phase 11: Firewall FORWARD

#### Purpose

Control inter-VLAN and internet forwarding with explicit allow rules and final default deny.

#### Configuration

Run on: `HQ-FW01`

When: after addressing, interface lists, and NAT planning are complete. Keep Safe Mode active.

Expected outcome: forwarding allows validated service paths and denies unapproved inter-VLAN traffic.

Use [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md) for authoritative forwarding rule order. The forward policy must include:

- Established/related accept and invalid drop.
- Guest-to-internal block and guest-to-WAN allow.
- `HQ-MGMT01` access to Proxmox and `HQ-DC01` management prep.
- Approved LAN-to-WAN internet access.
- Container outbound access and Cloudflared internal access.
- VLAN30-to-`HQ-DC01` admin-port drop before the temporary broad VLAN30-to-`HQ-DC01` pilot allow.
- Management VLAN to Workstations WinRM TCP `5985`.
- Management VLAN and Workstations VLAN to `HQ-WEC01` TCP `5985` for WEF.
- Final default deny.

Validation commands:

Run on: `HQ-FW01`

When: after forward rules are applied.

Expected outcome: forward rules appear in the validated order and counters increment during traffic tests.

```routeros
/ip firewall filter print where chain=forward
/ip firewall filter print stats where chain=forward
/ip firewall filter print where comment~"TEMP|HQ-WEC01|WinRM|Default deny|VLAN30"
```

### Phase 12: NAT

#### Purpose

Enable GEIL internal networks and RouterOS containers to reach GEILWAN.

#### Configuration

Run on: `HQ-FW01`

When: after WAN interface list membership exists.

Expected outcome: outbound masquerade exists for GEILWAN and RouterOS containers.

```routeros
/ip firewall nat add chain=srcnat action=masquerade out-interface-list=WAN comment="GEIL outbound masquerade to GEILWAN"
/ip firewall nat add chain=srcnat action=masquerade out-interface-list=WAN src-address=172.17.0.0/24 comment="NAT for RouterOS containers"
/ip firewall nat print
```

#### Expected outcome

NAT contains one general GEIL outbound masquerade rule and one container subnet masquerade rule.

### Phase 13: Routes

#### Purpose

Route default outbound traffic to the GEILWAN Proxmox peer.

#### Configuration

Run on: `HQ-FW01`

When: after `ether1` has `172.31.255.2/30`.

Expected outcome: default route points to `172.31.255.1`.

```routeros
/ip route add dst-address=0.0.0.0/0 gateway=172.31.255.1 comment="Default route via GEILWAN Proxmox peer"
/ip route print
/ping 172.31.255.1 count=4
```

#### Expected outcome

- Default route exists.
- `HQ-FW01` can ping `172.31.255.1`.

### Phase 14: Router services

#### Purpose

Restrict RouterOS management services to approved management networks and disable unused services.

#### Configuration

Run on: `HQ-FW01`

When: after firewall input rules are validated and Safe Mode/recovery path is confirmed.

Expected outcome: unused services are disabled and allowed service source ranges match the validated pilot.

```routeros
/ip service set ftp disabled=yes
/ip service set telnet disabled=yes
/ip service set www disabled=yes
/ip service set api disabled=yes
/ip service set api-ssl disabled=yes
/ip service set ssh address=172.20.10.0/24,172.17.0.2/32
/ip service set winbox address=172.20.10.0/24
/ip neighbor discovery-settings set discover-interface-list=MGMT
/tool mac-server set allowed-interface-list=MGMT
/tool mac-server mac-winbox set allowed-interface-list=MGMT
/ip service print
/ip neighbor discovery-settings print
/tool mac-server print
/tool mac-server mac-winbox print
```

#### Expected outcome

- FTP, Telnet, HTTP, API, and API-SSL are disabled.
- SSH is limited to `172.20.10.0/24` and `172.17.0.2/32`.
- WinBox is limited to `172.20.10.0/24`.
- Neighbor discovery and MAC services use `MGMT`.

### Phase 15: Validation

#### Purpose

Prove the new `HQ-FW01` deployment behaves like the validated pilot configuration.

#### RouterOS verification

Run on: `HQ-FW01`

When: after all deployment phases are complete.

Expected outcome: output matches the design values in [HQ-FW01 RouterOS Baseline](hq-fw01-routeros-baseline.md) and the sanitized snapshot.

```routeros
/system identity print
/interface vlan print
/interface list print
/interface list member print
/ip address print
/ip dhcp-relay print detail
/ip dns print
/container print detail
/ip firewall filter print stats
/ip firewall nat print
/ip route print
/ip service print
/tool mac-server print
/tool mac-server mac-winbox print
```

#### Export comparison

Run on: `HQ-FW01`

When: after validation commands pass.

Expected outcome: new export matches the validated configuration intent. Secrets must be sanitized before committing any export-derived documentation.

```routeros
/export show-sensitive
```

Do not commit raw `show-sensitive` output.

## Validation workflow

### GEILWAN validation

Run on: `HQ-FW01`

When: after IP addressing and route configuration.

Expected outcome: WAN peer and upstream reachability work.

```routeros
/ping 172.31.255.1 count=4
/ping 1.1.1.1 count=4
/ip route print
```

### VLAN gateway validation

Run on: `HQ-FW01`

When: after VLAN interfaces and IP addresses are configured.

Expected outcome: all VLAN gateway interfaces are present and running.

```routeros
/interface vlan print
/ip address print where address~"172.20"
```

### DHCP relay validation

Run on: `HQ-FW01`

When: while a client on VLAN10 or VLAN30 renews DHCP.

Expected outcome: relay entries exist and counters/logs show DHCP relay traffic.

```routeros
/ip dhcp-relay print detail
/log print where message~"dhcp"
```

Run on: `HQ-MGMT01`

When: validating Management VLAN DHCP client behavior.

Expected outcome: the client receives a VLAN10 address, gateway, and DNS configuration.

```powershell
ipconfig /renew
ipconfig /all
```

Run on: `HQ-W11-001`

When: validating Workstations VLAN DHCP client behavior.

Expected outcome: the client receives a VLAN30 address, gateway, and DNS configuration.

```powershell
ipconfig /renew
ipconfig /all
```

### DNS validation

Run on: `HQ-MGMT01`

When: after DNS forwarding and AD DNS are operational.

Expected outcome: AD DNS name resolution succeeds.

```powershell
Resolve-DnsName HQ-DC01
Resolve-DnsName HQ-WEC01
Resolve-DnsName cloudflare.com
```

### WinRM validation

Run on: `HQ-MGMT01`

When: after firewall and Windows WinRM policies are applied.

Expected outcome: Management VLAN can reach approved WinRM paths.

```powershell
Test-NetConnection HQ-W11-001 -Port 5985
Test-WSMan HQ-W11-001
Invoke-Command -ComputerName HQ-W11-001 -ScriptBlock { hostname }
```

Run on: `HQ-W11-001`

When: validating workstation isolation.

Expected outcome: workstation-to-domain-controller admin ports are blocked.

```powershell
Test-NetConnection HQ-DC01 -Port 3389
Test-NetConnection HQ-DC01 -Port 5985
```

### WEF validation

Run on: `HQ-W11-001`

When: after WEF GPO is applied.

Expected outcome: source-initiated forwarding can reach `HQ-WEC01` on TCP `5985`.

```powershell
Test-NetConnection HQ-WEC01 -Port 5985
wecutil gr GEIL-Workstation-Baseline
```

Run on: `HQ-MGMT01`

When: validating management access to the WEF collector.

Expected outcome: Management VLAN can administer `HQ-WEC01` through approved ports.

```powershell
Test-NetConnection HQ-WEC01 -Port 3389
Test-NetConnection HQ-WEC01 -Port 5985
```

### Cloudflared validation

Run on: `HQ-FW01`

When: after the container is created and outbound NAT/firewall rules are active.

Expected outcome: Cloudflared container is running and has outbound access.

```routeros
/container print detail
/container logs cloudflared
/ip firewall connection print where src-address~"172.17.0.2"
```

### Firewall validation

Run on: `HQ-FW01`

When: during WinRM, WEF, RDP, Cloudflared, and client internet tests.

Expected outcome: expected allow/drop counters increment and default deny remains last.

```routeros
/ip firewall filter print stats
/ip firewall filter print where comment~"TEMP|Default deny|HQ-WEC01|WinRM|VLAN30|cloudflared"
/ip firewall connection print where dst-address~"172.20.20."
```

## Pilot findings

The validated pilot export contains temporary rules that must remain documented until replaced by production-ready firewall design:

| Temporary rule | Why it exists | Production-ready requirement |
|---|---|---|
| `TEMP ALLOW VLAN30 clients to HQ-DC01` | Preserves AD DS, DNS, Kerberos, LDAP, SMB, and domain client functionality during pilot. | Replace with specific AD DS service rules and remove broad VLAN30-to-`HQ-DC01` access. |
| `TEMP allow HQ-DC01 to RDP HQ-MGMT01` | Supports pilot reverse RDP validation from `HQ-DC01` to `HQ-MGMT01`. | Remove before Production Ready unless a formally approved break-glass or support path replaces it. |

Critical ordering finding:

- The VLAN30-to-`HQ-DC01` admin-port drop must remain before the temporary VLAN30-to-`HQ-DC01` allow.
- The temporary VLAN30 rule is acceptable only in the pilot because RDP TCP `3389` and WinRM TCP `5985` are denied first.
- Do not move temporary allow rules above deny rules.

## Operations

### Update RouterOS

Run on: `HQ-FW01`

When: during an approved maintenance window after exporting and backing up configuration.

Expected outcome: RouterOS packages update and the router returns with identity, interfaces, firewall, containers, and services intact.

```routeros
/system package update check-for-updates
/system package update print
/export file=hq-fw01-before-update
```

After update, rerun the Phase 15 validation commands.

### Update Cloudflared

Run on: `HQ-FW01`

When: during an approved maintenance window.

Expected outcome: container image is refreshed and the tunnel returns healthy.

```routeros
/container print detail
/container stop cloudflared
/container remove cloudflared
```

Recreate the container using Phase 9 with the approved tunnel token. Do not expose the token in documentation or commits.

### Add VLANs

Run on: `HQ-FW01`

When: a new VLAN is approved in [VLAN and Subnet Plan](../vlan-and-subnet-plan.md).

Expected outcome: VLAN interface, gateway address, interface-list membership, DHCP relay, and firewall policy are updated together.

```routeros
/interface vlan print
/ip address print
/interface list member print
/ip firewall filter print
```

Do not add a VLAN interface without also updating the network plan and firewall intent.

### Update DHCP relay

Run on: `HQ-FW01`

When: a VLAN receives an approved DHCP scope on `HQ-DC01`.

Expected outcome: relay exists only for approved VLANs and does not include Guest WiFi.

```routeros
/ip dhcp-relay print detail
/ip dhcp-relay add name=relay-vlanXX interface=vlanXX-name dhcp-server=172.20.20.11 local-address=172.20.XX.1
```

### Manage firewall rules

Run on: `HQ-FW01`

When: adding or changing inter-VLAN policy.

Expected outcome: rules remain aligned to [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md) and default deny remains in place.

```routeros
/ip firewall filter print stats
/ip firewall filter export
```

Document intent before adding rules. Avoid broad source-to-destination allows unless explicitly marked as temporary pilot policy.

### Back up configuration

Run on: `HQ-FW01`

When: before any RouterOS upgrade, firewall change, or container change.

Expected outcome: binary backup and text export exist for recovery and review.

```routeros
/system backup save name=hq-fw01-pre-change
/export file=hq-fw01-pre-change
/file print where name~"hq-fw01-pre-change"
```

### Generate new export snapshot

Run on: `HQ-FW01`

When: after a validated configuration change is approved as the new pilot or production snapshot.

Expected outcome: export is generated, sanitized, reviewed, and used to update the export snapshot document.

```routeros
/export show-sensitive
```

Never commit raw `show-sensitive` output. Sanitize system IDs, tunnel tokens, credentials, and other secrets before updating documentation.

## Troubleshooting

| Issue | Symptoms | Validation | Resolution |
|---|---|---|---|
| DHCP relay failure | Clients on VLAN10 or VLAN30 do not receive DHCP leases. | `/ip dhcp-relay print detail`; `/log print where message~"dhcp"`; `ipconfig /renew` on client. | Confirm relay exists, VLAN gateway IP is correct, `HQ-DC01` DHCP scope exists, and firewall permits DHCP relay request/reply paths. |
| Cloudflared unreachable | Private tunnel path fails or container logs show connection errors. | `/container print detail`; `/container logs cloudflared`; `/ip firewall connection print where src-address~"172.17.0.2"`. | Validate token, container DNS, NAT for `172.17.0.0/24`, outbound WAN access, and Cloudflared allow rules to internal destinations. |
| WinRM blocked | `Test-WSMan` or `Invoke-Command` fails from `HQ-MGMT01`. | `Test-NetConnection <target> -Port 5985`; `/ip firewall filter print where comment~"WinRM"`. | Confirm Management VLAN source, target Windows Firewall scope, RouterOS WinRM allow rule, and no earlier drop rule blocks the flow. |
| WEF blocked | WEF clients do not report to `HQ-WEC01`. | `Test-NetConnection HQ-WEC01 -Port 5985`; `/ip firewall filter print where comment~"HQ-WEC01"`. | Confirm Workstations and Management VLAN to `HQ-WEC01` TCP `5985` rules exist and collector Windows Firewall allows source-initiated WEF. |
| RDP blocked unexpectedly | Approved management RDP path fails. | `Test-NetConnection <target> -Port 3389`; `/ip firewall filter print where dst-port~"3389"`. | Confirm source is Management VLAN, Windows Firewall allows RDP from approved sources, and no RouterOS drop precedes the allow. |
| RDP reachable from Workstations VLAN | Non-management workstation reaches DC or server RDP. | `Test-NetConnection HQ-DC01 -Port 3389` from `HQ-W11-001`; firewall rule counter review. | Ensure workstation-to-DC admin-port drop is above temporary broad allows; remove broad pilot rules before Production Ready. |
| DNS failures | Clients cannot resolve AD or internet names. | `Resolve-DnsName HQ-DC01`; `/ip dns print`; client `ipconfig /all`. | Confirm client DNS settings, AD DNS availability on `HQ-DC01`, RouterOS DNS forwarding state, and firewall path to DNS. |
| Inter-VLAN routing issue | Expected VLAN-to-VLAN path fails or unexpected path succeeds. | `/ip firewall filter print stats`; `/ip firewall connection print`; `Test-NetConnection` from source client. | Compare the flow to [Network and AD Services Matrix](../network-and-ad-services-matrix.md) and [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md); fix rule order before adding new broad allows. |

## Acceptance criteria

Deployment is complete when:

- [ ] Router identity configured as `HQ-FW01`.
- [ ] VLAN gateways operational.
- [ ] DHCP relay functional for approved VLANs.
- [ ] DNS operational.
- [ ] Cloudflared running.
- [ ] Firewall validated against [HQ-FW01 Firewall Policy](hq-fw01-firewall-policy.md).
- [ ] WinRM validated from Management VLAN.
- [ ] WEF validated to `HQ-WEC01`.
- [ ] Export matches validated snapshot intent after sanitization review.

## Production readiness gate

Before declaring the router Production Ready:

- Remove or replace `TEMP ALLOW VLAN30 clients to HQ-DC01` with specific AD DS service rules.
- Remove or replace `TEMP allow HQ-DC01 to RDP HQ-MGMT01` with an approved support or break-glass model.
- Re-run the full validation workflow.
- Generate a new sanitized export snapshot.
- Update [HQ-FW01 RouterOS Export - Current Validated Snapshot](hq-fw01-routeros-export-current.md) if the validated configuration changes.
