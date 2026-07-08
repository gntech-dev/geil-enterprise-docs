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

## Single-source-of-truth architecture rules

GEIL uses a single-source-of-truth documentation architecture:

1. One concept has one authoritative document.
2. New Markdown documents may be created only for an entirely new platform, a major capability, a required section landing page, or an approved architecture/control-plane record.
3. If information naturally belongs in an existing document, update that document instead of creating another file.
4. Do not duplicate technical explanations across documents. Link to the authoritative document instead.
5. Keep implementation, validation, troubleshooting, rollback, evidence, and pilot findings together whenever practical.
6. Roadmap items must not become operational documentation until implemented or explicitly moved from Future into the active laboratory sequence.
7. Before creating a Markdown document, search for the existing concept owner and update it if one exists.
8. The laboratory is the source of truth. Pilot findings update the existing authoritative document, not a new parallel report.


## Deployment Guide Principle

GEIL is a pilot-first documentation project. Documentation is not limited to describing an existing environment; its primary purpose is to let another engineer reproduce the validated pilot from scratch.

Every Deployment Guide must allow an engineer to deploy a brand new component from factory defaults or from a clean operating system installation to the validated pilot configuration using only documentation in this repository. The guide must not assume previous manual configuration.

A Deployment Guide begins with one of these states:

- Factory defaults.
- Clean operating system installation.

A Deployment Guide ends with this state:

- Pilot Validated configuration.

The Deployment Workflow must answer this question:

> Could a new engineer rebuild this component from scratch using only this document?

If the answer is no, the Deployment Guide is incomplete.

## Pilot validation completion rule

A component is not considered complete until:

1. It has been deployed in the GEIL lab.
2. It has been validated.
3. Pilot findings have been incorporated.
4. Documentation has been updated.
5. Validation commands succeed.
6. Changes have been committed and pushed.

## Infrastructure component documentation model

Each major infrastructure component should eventually contain these document types, either as separate documents or clearly separated sections in the authoritative document set:

| Document type | Purpose |
|---|---|
| Design | Explains the intended architecture, dependencies, and decisions. |
| Deployment Guide | Explains how to build the component from factory defaults or a clean OS to the validated pilot configuration. |
| Pilot Findings | Records lessons learned during implementation and validation. |
| Current Configuration Snapshot | Records the sanitized current validated configuration state when applicable. |

Examples of components that should follow this model as they mature include `HQ-FW01`, `HQ-DC01`, `HQ-WEC01`, `HQ-MGMT01`, `HQ-W11-001`, DNS, DHCP, Windows LAPS, Microsoft Defender, Windows Event Forwarding, WinRM, and Active Directory.

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

When a document is a Pilot Validated Deployment Guide, it should use the structure defined in [Deployment Style Guide](deployment-style-guide.md): Purpose, Architecture, Prerequisites, Deployment Workflow, Validation Workflow, Pilot Findings, Operations, Troubleshooting, and Acceptance Criteria.

## Document ID standard

Use this format:

`GEIL-{AREA}-{TOPIC}-{NNN}`

Examples:

- `GEIL-MSC-AD-001` for Active Directory implementation.
- `GEIL-CLD-INTUNE-001` for Intune Windows enrollment.
- `GEIL-OPS-BACKUP-001` for backup and recovery.

## Placeholder rules

Known GNTECH values must come from the [Environment Specification](../project/environment-specification.md). Do not use placeholders for canonical values such as `gntech.me`, `corp.gntech.me`, `GNTECH`, `HQ-DC01`, VLAN IDs, or `172.20.0.0/16` network ranges.

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


## Visual documentation

Mermaid is approved for simple diagrams, workflows, and dependency graphs. Complex architecture diagrams must follow the [Visual Documentation Standard](visual-documentation-standard.md) and use dedicated visual assets under `docs/assets/diagrams/` when Mermaid output would be too wide, crowded, or unreadable at normal MkDocs page width.

Complex diagram pages must include a short explanation, the image asset, a simplified Mermaid diagram where useful, and an Adaptation Note when canonical GNTECH values are shown.
