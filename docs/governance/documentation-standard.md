---
title: Documentation Standard
document_id: GEIL-GOV-DOC-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Documentation Standard

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-GOV-DOC-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This standard defines how GEIL documentation is authored, reviewed, published, and maintained.

## Required document structure

Every production document must include:

1. YAML front matter with `title`, `document_id`, `owner`, `status`, `version`, `last_reviewed`, `review_cycle`, and `classification`.
2. Document Control table.
3. Purpose and scope.
4. Prerequisites.
5. Implementation procedure or operational procedure.
6. Validation steps and expected results.
7. Rollback or recovery guidance.
8. Security considerations.
9. Related documents.

## Document ID standard

Use this format:

`GEIL-{AREA}-{TOPIC}-{NNN}`

Examples:

- `GEIL-MSC-AD-001` for Active Directory implementation.
- `GEIL-CLD-INTUNE-001` for Intune Windows enrollment.
- `GEIL-OPS-BACKUP-001` for backup and recovery.

## Placeholder rules

Known GNTECH values must come from the [Environment Specification](../project/environment-specification.md). Do not use placeholders for canonical values such as `gntech.me`, `corp.gntech.me`, `CORP`, `HQ-DC01`, VLAN IDs, or `172.20.0.0/16` network ranges.

Allowed placeholders are limited to values that cannot be known before deployment or must not be committed:

- `<PUBLIC_IP>`
- `<AZURE_TENANT_ID>`
- `<SUBSCRIPTION_ID>`
- `<CLIENT_SECRET>`
- `<PASSWORD>`
- `<CERTIFICATE_THUMBPRINT>`
- `<SERIAL_NUMBER>`
- `<API_KEY>`

Whenever a placeholder is used, the document must explain exactly what replaces it and where the real value must be stored. Never use vague placeholders such as undocumented server aliases, non-canonical domain names, or informal example settings.

## Review workflow

1. Author drafts on a feature branch.
2. Run `mkdocs build --strict`.
3. Peer review for technical accuracy.
4. Security review for secrets exposure and unsafe defaults.
5. Merge to `main` only after validation succeeds.

## Validation command

```powershell
# From a Windows workstation with Git and Python installed, or use Bash equivalent on Linux.
python -m pip install -r requirements.txt
mkdocs build --strict
```

Expected result: build completes with zero warnings.

## Rollback

If a published document introduces incorrect production guidance:

1. Revert the merge commit.
2. Open a corrective PR.
3. Add an ADR if the error came from an architectural ambiguity.
4. Notify Infrastructure Engineering and Service Desk if runbooks were affected.
