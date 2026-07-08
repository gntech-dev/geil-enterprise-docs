---
title: Active Documentation Scope
document_id: GEIL-PRJ-ACTIVE-SCOPE-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-08
review_cycle: Quarterly
classification: Internal Confidential
---

# Active Documentation Scope

## Purpose

This document defines the active documentation scope for the GEIL Enterprise Lab pilot-validated documentation model.

The active documentation set represents the current pilot-validated Windows Infrastructure Lab and the documents directly required to operate, validate, or extend that pilot. Historical organization is not preserved in active navigation unless it helps a new engineer find current implementation truth.

## Active documentation scope

Active documentation lives under:

- `docs/project/`
- `docs/governance/`
- `docs/network/`
- `docs/microsoft-core/`

Active documents must support at least one of these needs:

- Understand current project roadmap, implementation status, release tracking, or documentation rules.
- Operate validated network, VLAN, firewall, DNS, DHCP, Cloudflared, or service-path configuration.
- Deploy or validate current Microsoft Core services used by the pilot.
- Preserve a validated pilot finding, command sequence, or acceptance criterion.

Current active pilot scope includes:

- Network authority and source-of-truth policy.
- VLAN and subnet plan.
- Network and Active Directory services matrix.
- Firewall rule matrix.
- MikroTik `HQ-FW01` validated configuration.
- Cloudflared networking boundaries.
- Active Directory, DNS/DHCP, Group Policy, and Authentication Standards.
- `HQ-MGMT01` and `HQ-W11-001` lifecycle documents.
- WinRM / PowerShell Remoting.
- Windows Firewall.
- Windows LAPS.
- Microsoft Defender Antivirus by Active Directory Group Policy.
- Windows Event Forwarding / `HQ-WEC01`.

## Legacy scope

Legacy documentation lives under:

- `docs/legacy/`

Legacy content is retained for reference, auditability, or future reuse, but it is not the current pilot source of truth.

Legacy content includes:

- OPNsense material.
- Proxmox foundation design and build documents.
- Microsoft 365, Intune, and cloud endpoint planning.
- Future-only architecture documents.
- Broad enterprise theory not used by the current pilot.
- Duplicate HLD or architecture documents.
- Old audit reports and historical review packages.
- Former Platform, Foundation, Future, Operations, Cloud Endpoint, standalone Security, and non-current Architecture content.

## Out-of-current-pilot scope

A document is out of current pilot scope when it is primarily about:

- A technology not deployed or validated in the current lab.
- A future design that has not reached pilot implementation.
- A superseded platform or alternative architecture.
- Historical audit or planning evidence that is no longer part of daily implementation.
- Duplicate explanation of network, firewall, or service-path rules owned by an active source-of-truth document.

Out-of-current-pilot content must not appear as active top-level navigation.

## Criteria for returning a legacy document to active docs

A legacy document may move back into active documentation only when all criteria are met:

1. The capability is actively being implemented or has entered pilot validation.
2. The document is updated to the Pilot Validated documentation model where applicable.
3. Source-of-truth ownership is clear and does not conflict with existing active documents.
4. Validation commands and expected results are present.
5. Pilot findings are recorded after implementation evidence exists.
6. MkDocs strict build and repository validation pass.
7. Project roadmap and document index references are updated.

## Source-of-truth rules

- `docs/network/` is the authority for VLANs, subnets, routing, firewall flows, MikroTik, Cloudflared networking, and AD service reachability.
- `docs/network/mikrotik/hq-fw01-firewall-policy.md` is the authoritative operational firewall policy.
- `docs/microsoft-core/` is the authority for Microsoft services and Windows implementation.
- `docs/project/` is for roadmap, status, release tracking, active scope, and governance context.
- `docs/governance/` is for documentation, deployment, naming, visual, and implementation standards.
- `docs/legacy/` is for historical, superseded, future-only, or non-current content.

Active documents must link to the appropriate authority instead of duplicating source-of-truth tables.

## Pilot validation requirement

A document may be marked `Pilot Validated` only when implementation evidence exists in the GEIL laboratory.

Pilot validated documents must include:

- The deployment workflow used from an empty or known-good starting state.
- Validation commands.
- Expected healthy outputs.
- Pilot findings and corrections made after validation.
- Operational checks.
- Troubleshooting based on observed or likely failures.
- Acceptance criteria.

Future intent alone is not sufficient to promote a document to `Pilot Validated`.
