---
title: Security
document_id: GEIL-SEC-INDEX
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Security

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-SEC-INDEX |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This section defines GEIL security architecture and operational controls that cut across Active Directory, Microsoft Entra ID, Windows Server, Windows 11 Enterprise, Microsoft 365, Intune, Defender, OPNsense, Proxmox VE, and the documentation platform.

## Security principles

- Privileged access is separated by tier and by administrative function.
- No daily-use account receives standing administrative privilege.
- Emergency access is documented, tested, monitored, and limited.
- Administrative work is performed only from approved management endpoints.
- Privilege assignments require owner, business justification, review date, and rollback path.

## Documents

- [Privileged Access Model](privileged-access-model.md)
