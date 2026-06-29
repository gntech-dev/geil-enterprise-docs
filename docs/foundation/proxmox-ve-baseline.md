---
title: Proxmox VE Baseline
document_id: GEIL-FND-PVE-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Proxmox VE Baseline

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-FND-PVE-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Build a hardened Proxmox VE virtualization foundation for Windows infrastructure workloads.

## Host baseline

- Enable UEFI, virtualization extensions, TPM, and secure boot where supported.
- Use redundant storage for production workloads.
- Separate management, storage, and VM traffic when hardware permits.
- Use named Linux bridges mapped to documented VLAN trunks.
- Disable password SSH for root after key-based administration is configured.

## Implementation steps

1. Install Proxmox VE on each host.
2. Patch immediately from approved repositories.
3. Configure management IP in VLAN 10.
4. Configure DNS to point to bootstrap resolver until AD DNS exists.
5. Create VM storage pools.
6. Create scheduled backups to dedicated backup storage.
7. Create Windows Server 2025 VM templates with VirtIO drivers.

## Validation commands

```bash
pveversion
pvesh get /nodes
qm list
```

Expected result: all hosts show current versions, expected nodes, and no unknown VM states.

## Windows VM defaults

- Firmware: OVMF UEFI.
- Machine: q35.
- Disk: SCSI with VirtIO SCSI controller.
- NIC: VirtIO, tagged VLAN if needed.
- Guest agent: enabled and installed.

## Rollback

Before major host changes, export VM definitions and confirm backups. If networking changes fail, restore `/etc/network/interfaces` from console access and reboot during an approved outage.
