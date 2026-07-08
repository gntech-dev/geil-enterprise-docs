---
title: ADR-0002 Use MikroTik CHR for Phase 1 HQ Firewall
document_id: GEIL-ADR-0002
owner: Architecture Review Board
status: Approved
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# ADR-0002 Use MikroTik CHR for Phase 1 HQ Firewall

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-ADR-0002 |
| Owner | Architecture Review Board |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Status

Accepted

## Context

GEIL Phase 1 previously documented `HQ-FW01` as an MikroTik CHR firewall VM. The enterprise capability did not change: GEIL still requires Enterprise Edge Security and Enterprise Networking for routing, segmentation, NAT, management access, guest isolation, and DHCP relay preparation.

The implementation owner has operational experience with MikroTik RouterOS. Using MikroTik CHR reduces deployment friction, improves operator confidence during initial buildout, and aligns the Phase 1 firewall with available skills.

## Decision

Use **MikroTik CHR / RouterOS** as the Phase 1 HQ firewall implementation for `HQ-FW01`.

Canonical firewall identity remains:

| Item | Value |
|---|---|
| Firewall hostname | `HQ-FW01` |
| Platform | MikroTik CHR / RouterOS |
| WAN bridge | `GEILWAN` |
| LAN trunk bridge | `GEILLAN` |
| GEILWAN Proxmox side | `172.31.255.1/30` |
| CHR WAN | `172.31.255.2/30` |
| CHR default route | `172.31.255.1` |

MikroTik CHR remains a valid alternative implementation for the same capability and is preserved in the Technology Selection Matrix, but it is no longer the active Phase 1 implementation.

## Consequences

Positive:

- The implementation owner can operate and troubleshoot RouterOS with less ramp-up time.
- RouterOS CLI configuration can be captured as repeatable implementation evidence.
- The capability model remains stable because only the firewall implementation changed.

Tradeoffs:

- Existing MikroTik CHR-specific runbooks must be superseded or rewritten.
- Firewall validation commands and evidence requirements must change from RouterOS CLI / WinBox/config export to RouterOS CLI/export evidence.
- Future operators must understand RouterOS interface lists, firewall chains, NAT, services, and export behavior.

## Implementation requirements

- `HQ-FW01` runs MikroTik CHR.
- `ether1` connects to `GEILWAN`.
- `ether2` connects to `GEILLAN` as the VLAN trunk parent.
- VLAN gateways are created on `ether2` using canonical GNTECH values.
- Baseline firewall rules must allow management from approved networks and block Guest WiFi from `172.20.0.0/16`.
- DHCP relay is prepared for VLANs 30, 40, and 60 but not enabled until `HQ-DC01` DHCP scopes exist.

## Superseded implementation

- `docs/legacy/platform/opnsense-hq-foundation-lld.md` is superseded by `docs/legacy/platform/mikrotik-chr-hq-foundation-lld.md`.
- `docs/legacy/platform/opnsense-hq-foundation-implementation.md` is superseded by `docs/legacy/platform/mikrotik-chr-hq-foundation-implementation.md`.

## Related documents

- [Technology Selection Matrix](../../legacy/architecture/technology-selection-matrix.md)
- [Enterprise Lab Network HLD](../../legacy/architecture/enterprise-lab-network-hld.md)
- [MikroTik CHR HQ Foundation LLD](../../legacy/platform/mikrotik-chr-hq-foundation-lld.md)
- [MikroTik CHR HQ Foundation Implementation](../../legacy/platform/mikrotik-chr-hq-foundation-implementation.md)
