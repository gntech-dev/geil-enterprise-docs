---
title: AGDLP Access Model
document_id: GEIL-MSC-FILE-AGDLP-001
owner: Infrastructure Engineering
status: Future
version: 1.0
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# AGDLP Access Model

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-MSC-FILE-AGDLP-001 |
| Owner | Infrastructure Engineering |
| Status | Future |
| Version | 1.0 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Reserve the file-services application of AGDLP for future implementation.

## Status

Future. This page references the identity/access concept but does not replace the future Identity and Access Standard.

## Planned model

- Accounts go into global groups.
- Global groups go into domain local resource groups.
- Domain local groups receive NTFS permissions.
- Access reviews validate membership and resource permissions.

## Related documents

- [File Server](file-server.md)
- [SMB Shares and Permissions](smb-shares-permissions.md)
- [Enterprise Group Strategy](../group-strategy.md)
