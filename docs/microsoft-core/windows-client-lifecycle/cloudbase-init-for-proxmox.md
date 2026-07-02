---
title: Cloudbase-Init for Proxmox
document_id: GEIL-MSC-WCL-CLOUDBASE-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# Cloudbase-Init for Proxmox

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-WCL-CLOUDBASE-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Define the Cloudbase-Init portion of the Windows 11 Enterprise golden-template lifecycle for Proxmox clones.

## Scope

Cloudbase-Init belongs to the template phase. It prepares each clone to receive Proxmox Cloud-Init metadata without baking host identity, domain membership, OU placement, GPO state, or user credentials into the template.

## Architecture rules

- Install Cloudbase-Init only inside the workgroup-only Windows 11 Enterprise golden template.
- Do not domain-join the template.
- Do not place the template in an OU.
- Do not validate GPO from the template.
- Validate Cloudbase-Init logs before Sysprep.
- Domain join and OU placement happen only after cloning.

## Implementation source

The copy/paste installation and validation steps remain in the authoritative template guide:

[Windows 11 Enterprise Golden Template](windows-11-enterprise-golden-template.md)

## Validation evidence

Capture:

- Cloudbase-Init service status.
- `cloudbase-init.log` tail.
- Proxmox clone metadata test result when available.
- Confirmation that the source image remains workgroup-only.

## Related documents

- [Windows 11 Enterprise Golden Template](windows-11-enterprise-golden-template.md)
- [Windows Management Workstation - HQ-MGMT01](windows-11-management-workstation.md)
- [Windows Domain Join and GPO Validation](windows-11-domain-join-gpo-validation.md)
