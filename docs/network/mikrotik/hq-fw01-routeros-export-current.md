---
title: HQ-FW01 RouterOS Export - Current Validated Snapshot
document_id: GEIL-NET-MTK-HQFW01-EXPORT-001
owner: Infrastructure Engineering
status: Pilot Validated
version: 1.0
last_reviewed: 2026-07-08
review_cycle: Per validated export
classification: Internal Confidential
---

# HQ-FW01 RouterOS Export - Current Validated Snapshot

## Purpose

This document records the sanitized current validated `HQ-FW01` RouterOS export from the pilot snapshot at `/home/gntech/geil/mikrotik-export.txt`.

This export is the primary source for current MikroTik documentation. Sensitive values from the `show-sensitive` export are replaced with placeholders.

## Snapshot metadata

| Field | Value |
|---|---|
| RouterOS version | `7.21.4` |
| Export timestamp | `2026-07-08 04:05:11` |
| Router identity | `HQ-FW01` |
| Source file | `/home/gntech/geil/mikrotik-export.txt` |
| Sanitization | System ID and Cloudflared tunnel token redacted |

## Sanitized export

Run on: documentation workstation

When: reviewing current validated `HQ-FW01` state.

Expected outcome: this sanitized export matches the validated pilot snapshot, with secrets redacted.

```text
 /export show-sensitive
# 2026-07-08 04:05:11 by RouterOS 7.21.4
# system id = [REDACTED]
#
/disk
add parent=pcie1 partition-number=1 partition-offset=512 partition-size=1073741312 type=partition
/interface bridge
add comment="Container bridge" name=containers
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
/interface veth
add address=172.17.0.2/24 container-mac-address=0E:E7:F0:EA:27:52 dhcp=no gateway=172.17.0.1 gateway6="" mac-address=\
    0E:E7:F0:EA:27:51 name=veth-cloudflared
/interface vlan
add interface=ether2 name=vlan10-mgmt vlan-id=10
add interface=ether2 name=vlan20-servers vlan-id=20
add interface=ether2 name=vlan30-workstations vlan-id=30
add interface=ether2 name=vlan40-printers vlan-id=40
add interface=ether2 name=vlan50-voice vlan-id=50
add interface=ether2 name=vlan60-corpwifi vlan-id=60
add interface=ether2 name=vlan70-guestwifi vlan-id=70
add interface=ether2 name=vlan80-dmz vlan-id=80
add interface=ether2 name=vlan90-backup vlan-id=90
add interface=ether2 name=vlan100-hypervisor vlan-id=100
/interface list
add comment="External/transit interfaces" name=WAN
add comment="Internal non-guest interfaces" name=LAN
add comment="Approved firewall management interfaces" name=MGMT
add comment="Server VLAN interfaces" name=SERVERS
add comment="Workstation VLAN interfaces" name=WORKSTATIONS
add comment="Guest-only VLAN interfaces" name=GUEST
/container
add cmd="tunnel --no-autoupdate run" dns=1.1.1.1 envlists=ENV_CLOUDFLARED hostname=cloudflared interface=\
    veth-cloudflared layer-dir="" logging=yes name=cloudflared remote-image=cloudflare/cloudflared:latest root-dir=\
    /pcie1-part1/cloudflared start-on-boot=yes workdir=/home/nonroot
/container config
set registry-url=https://registry-1.docker.io tmpdir=/pcie1-part1/pull
/container envs
add key=TUNNEL_TOKEN list=ENV_CLOUDFLARED value="[REDACTED_TUNNEL_TOKEN]"
/interface bridge port
add bridge=containers interface=veth-cloudflared
/ip neighbor discovery-settings
set discover-interface-list=MGMT
/ip settings
set max-neighbor-entries=8192
/ipv6 settings
set max-neighbor-entries=4096 min-neighbor-entries=1024 soft-max-neighbor-entries=2048
/interface list member
add interface=ether1 list=WAN
add interface=vlan100-hypervisor list=LAN
add interface=vlan10-mgmt list=MGMT
add interface=vlan20-servers list=SERVERS
add interface=vlan30-workstations list=WORKSTATIONS
add interface=vlan70-guestwifi list=GUEST
add interface=vlan10-mgmt list=LAN
add interface=vlan20-servers list=LAN
add interface=vlan30-workstations list=LAN
add interface=vlan40-printers list=LAN
add interface=vlan50-voice list=LAN
add interface=vlan60-corpwifi list=LAN
add interface=vlan80-dmz list=LAN
add interface=vlan90-backup list=LAN
add interface=vlan100-hypervisor list=MGMT
/ip address
add address=172.31.255.2/30 comment="GEILWAN CHR WAN" interface=ether1 network=172.31.255.0
add address=172.20.10.1/24 comment="VLAN10 Management gateway" interface=vlan10-mgmt network=172.20.10.0
add address=172.20.100.1/24 comment="VLAN100 Hypervisors gateway" interface=vlan100-hypervisor network=172.20.100.0
add address=172.20.90.1/24 comment="VLAN90 Backup gateway" interface=vlan90-backup network=172.20.90.0
add address=172.20.20.1/24 comment="VLAN20 Servers gateway" interface=vlan20-servers network=172.20.20.0
add address=172.20.30.1/24 comment="VLAN30 Workstations gateway" interface=vlan30-workstations network=172.20.30.0
add address=172.20.40.1/24 comment="VLAN40 Printers gateway" interface=vlan40-printers network=172.20.40.0
add address=172.20.50.1/24 comment="VLAN50 Voice gateway" interface=vlan50-voice network=172.20.50.0
add address=172.20.60.1/24 comment="VLAN60 Corporate WiFi gateway" interface=vlan60-corpwifi network=172.20.60.0
add address=172.20.70.1/24 comment="VLAN70 Guest WiFi gateway" interface=vlan70-guestwifi network=172.20.70.0
add address=172.20.80.1/24 comment="VLAN80 DMZ gateway" interface=vlan80-dmz network=172.20.80.0
add address=172.17.0.1/24 comment="Gateway for containers" interface=containers network=172.17.0.0
/ip dhcp-client
add disabled=yes interface=ether1
/ip dhcp-relay
add dhcp-server=172.20.20.11 interface=vlan40-printers name=relay-vlan40
add dhcp-server=172.20.20.11 interface=vlan60-corpwifi name=relay-vlan60
add dhcp-server=172.20.20.11 disabled=no interface=vlan30-workstations local-address=172.20.30.1 name=relay-vlan30
add dhcp-server=172.20.20.11 disabled=no interface=vlan10-mgmt local-address=172.20.10.1 name=relay-vlan10
/ip dns
set allow-remote-requests=yes servers=1.1.1.1,1.0.0.1
/ip firewall filter
add action=accept chain=input comment="Accept established/related to router" connection-state=established,related
add action=drop chain=input comment="Drop invalid to router" connection-state=invalid
add action=accept chain=input comment="Allow management VLAN to router" src-address=172.20.10.0/24
add action=accept chain=input comment="Allow HQ-MGMT01 to router" src-address=172.20.10.10
add action=accept chain=forward comment="Accept established/related forwarding" connection-state=established,related
add action=drop chain=forward comment="Drop invalid forwarding" connection-state=invalid
add action=drop chain=forward comment="Block guest to internal GEIL" dst-address=172.20.0.0/16 src-address=\
    172.20.70.0/24
add action=accept chain=forward comment="Allow guest to internet only" out-interface-list=WAN src-address=\
    172.20.70.0/24
add action=accept chain=forward comment="Allow HQ-MGMT01 to Proxmox" dst-address=172.20.100.11 dst-port=8006 \
    protocol=tcp src-address=172.20.10.10
add action=accept chain=forward comment="Allow HQ-MGMT01 to HQ-DC01 management prep" dst-address=172.20.20.11 \
    src-address=172.20.10.10
add action=accept chain=forward comment="Allow approved internal VLANs to Internet" connection-state=new \
    in-interface-list=LAN out-interface-list=WAN
add action=accept chain=forward comment="Allow containers outbound to Internet" out-interface-list=WAN src-address=\
    172.17.0.0/24
add action=accept chain=forward comment="Allow cloudflared to VLAN20 Servers" dst-address=172.20.20.0/24 src-address=\
    172.17.0.2
add action=accept chain=forward comment="Allow cloudflared to VLAN80 DMZ" dst-address=172.20.80.0/24 src-address=\
    172.17.0.2
add action=drop chain=forward comment="Block VLAN30 Workstations to HQ-DC01 admin ports" dst-address=172.20.20.11 \
    dst-port=3389,5985 protocol=tcp src-address=172.20.30.0/24
add action=accept chain=forward comment="TEMP ALLOW VLAN30 clients to HQ-DC01" dst-address=172.20.20.11 src-address=\
    172.20.30.0/24
add action=accept chain=forward comment="Allow cloudflared to VLAN10 Management" dst-address=172.20.10.0/24 \
    src-address=172.17.0.2
add action=accept chain=forward comment="TEMP allow HQ-DC01 to RDP HQ-MGMT01" dst-address=172.20.10.10 dst-port=3389 \
    protocol=tcp src-address=172.20.20.11
add action=accept chain=forward comment="Allow Management VLAN to WinRM Workstations" dst-address=172.20.30.0/24 \
    dst-port=5985 protocol=tcp src-address=172.20.10.0/24
add action=accept chain=forward comment="Allow Management VLAN to HQ-WEC01 admin ports" dst-address=172.20.20.21 \
    dst-port=3389,5985 protocol=tcp src-address=172.20.10.0/24
add action=accept chain=forward comment="Allow Workstations VLAN to WEF collector HQ-WEC01" dst-address=172.20.20.21 \
    dst-port=5985 protocol=tcp src-address=172.20.30.0/24
add action=accept chain=forward comment="Allow Management VLAN to WEF collector HQ-WEC01" dst-address=172.20.20.21 \
    dst-port=5985 protocol=tcp src-address=172.20.10.0/24
add action=drop chain=forward comment="Default deny unapproved forwarding"
add action=accept chain=input comment="Allow cloudflared container to SSH CHR" dst-port=22 protocol=tcp src-address=\
    172.17.0.2
add action=accept chain=input comment="ALLOW DHCP client requests VLAN30 to CHR relay" dst-address=255.255.255.255 \
    dst-port=67 in-interface=vlan30-workstations protocol=udp src-address=0.0.0.0
add action=accept chain=input comment="ALLOW DHCP server replies to CHR relay" dst-address=172.20.30.1 dst-port=67 \
    protocol=udp src-address=172.20.20.11 src-port=67
add action=accept chain=input comment="ALLOW DHCP client requests VLAN10 to CHR relay" dst-address=255.255.255.255 \
    dst-port=67 in-interface=vlan10-mgmt protocol=udp src-address=0.0.0.0 src-port=68
add action=accept chain=input comment="ALLOW DHCP server replies to CHR relay VLAN10" dst-address=172.20.10.1 \
    dst-port=67 protocol=udp src-address=172.20.20.11 src-port=67
add action=drop chain=input comment="Default deny unapproved traffic to router"
/ip firewall nat
add action=masquerade chain=srcnat comment="GEIL outbound masquerade to GEILWAN" out-interface-list=WAN
add action=masquerade chain=srcnat comment="NAT for RouterOS containers" out-interface-list=WAN src-address=\
    172.17.0.0/24
/ip route
add comment="Default route via GEILWAN Proxmox peer" dst-address=0.0.0.0/0 gateway=172.31.255.1
/ip service
set ftp disabled=yes
set ssh address=172.20.10.0/24,172.17.0.2/32
set telnet disabled=yes
set www disabled=yes
set winbox address=172.20.10.0/24
set api disabled=yes
set api-ssl disabled=yes
/system identity
set name=HQ-FW01
/tool mac-server
set allowed-interface-list=MGMT
/tool mac-server mac-winbox
set allowed-interface-list=MGMT
```
