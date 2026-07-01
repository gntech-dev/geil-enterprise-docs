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


## Audit Correction Notes

!!! success "Execution-order audit"

    This guide was audited for command order, object dependencies, canonical GEIL values, rollback coverage, validation gates, and active MikroTik CHR firewall references. Follow dependency order exactly: validate prerequisites, create objects, validate objects, apply dependent settings, then capture evidence.

- Audit focus: Install and establish the base hypervisor before GEIL-specific bridges are created.
- Active Phase 1 firewall implementation: MikroTik CHR / RouterOS on `HQ-FW01`.
- OPNsense is superseded and must not be used for active Phase 1 deployment.

## Learning Objectives

After completing this guide you will understand:

- What the `Proxmox VE baseline` workstream changes.
- Why the sequence matters.
- Which validations prove the change worked.
- How to recover safely if a step fails.

## What You Will Build

By the end of this guide you will have:

- ✓ Completed the `Proxmox VE baseline` workstream.
- ✓ Captured validation evidence.
- ✓ Preserved rollback or recovery options.

## Estimated Time

30-90 minutes depending on prerequisite readiness and evidence capture.

## Difficulty

Intermediate. Follow the documented order and validate after each major stage.

## Risk Level

Medium. The risk is controlled by validating prerequisites, splitting commands into small blocks, and keeping rollback options available.

## Service Impact

Maintenance window recommended when the guide changes network, identity, firewall, or policy behavior. Read-only validation steps have no service impact.

## Prerequisites

- Canonical GEIL values reviewed in [Environment Specification](../project/environment-specification.md).
- Previous dependency completed where applicable.
- Administrative access and console recovery path available.
- Secrets stored in the approved password manager, not Git.

## Expected Starting State

- Required prerequisite guide is complete.
- No command in this guide references an object before it exists.
- Existing public/non-GEIL resources remain unchanged.

## Expected Ending State

- `Proxmox VE baseline` is complete and validated.
- Evidence is captured.
- Rollback or recovery path remains documented.

## Architecture Overview

```mermaid
flowchart LR
    PRE[Prerequisites validated]
    STEP[Proxmox VE baseline]
    VAL[Validation evidence]
    NEXT[Next guide]
    PRE --> STEP --> VAL --> NEXT
```

## Background Knowledge

This guide follows the GEIL educational method: teach the purpose, validate prerequisites, apply changes in dependency order, validate immediately, and preserve recovery paths.

## Step-by-Step Procedure

Follow the procedure sections in this document in order. Do not skip validation gates or combine risky command blocks.

## Validation after each major stage

Validate immediately after each change block. Do not continue when expected output does not match the guide.

## Expected Results

- Commands complete without referencing missing objects.
- Canonical GEIL values are visible in outputs.
- No active OPNsense deployment path remains for Phase 1 firewall work.
- `10.10.x.x` remains limited to existing non-GEIL `PROD`/`TEST` references only.

## Evidence to capture

- Command output proving prerequisite state.
- Command output proving ending state.
- Relevant GUI screenshots where applicable.
- Rollback checkpoint or export evidence where applicable.

## Common Mistakes

| Mistake | Impact | Correction |
|---|---|---|
| Running steps out of order | Commands fail or partial state is created | Return to the last validation gate |
| Referencing missing objects | Invalid commands or unsafe defaults | Create and validate the object first |
| Skipping rollback capture | Recovery is slower | Capture snapshot/export before risky changes |

## Troubleshooting

Start with read-only validation. Confirm prerequisites, object existence, canonical values, and logs before changing configuration.

## Knowledge Check

1. What prerequisite must exist before this guide can run safely?
2. Which validation proves the main change worked?
3. What rollback action is safest if the last command fails?

## Next Guide

Continue to:

- [Proxmox HQ Foundation Implementation](../platform/proxmox-hq-foundation-implementation.md)

## Deployment Verified

| Field | Value |
|---|---|
| Validated on | Not yet field validated. Must pass this guide, the code-block audit, and clean-environment review before production execution. |
| Windows Server version | Not yet field validated |
| RouterOS version | Not applicable unless the guide explicitly configures RouterOS |
| Proxmox version | Proxmox VE 9 target |
| Deployment date | Not yet field validated |
| Deployment notes | Not yet field validated. Must pass this guide, the code-block audit, and clean-environment review before production execution. |
| Known caveats | Treat as documentation-ready but not field-proven until deployment evidence is captured. |
