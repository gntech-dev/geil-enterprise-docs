---
title: ADR-0001 MkDocs Material Documentation Platform
document_id: GEIL-ADR-0001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# ADR-0001 MkDocs Material Documentation Platform

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-ADR-0001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Status

Accepted.

## Context

GEIL requires private internal engineering documentation with strong navigation, search, code blocks, Mermaid diagrams, and static hosting compatibility.

## Decision

Use MkDocs Material, hosted from a private GitHub repository and deployed to Cloudflare Pages.

## Consequences

Positive:

- Fast static publishing.
- Markdown-first authoring.
- Mermaid diagrams supported.
- Strict build validation can run in CI.

Negative:

- Fine-grained page authorization is not native to static hosting.
- Secrets must never be committed.
- Private access control depends on GitHub and Cloudflare Access configuration.

## Implementation requirements

- Run `mkdocs build --strict` before merge.
- Protect `main` with pull request review.
- Use Cloudflare Access for private site access.
- Store no credentials in repository.

## Review trigger

Review this ADR if GEIL requires page-level authorization, regulated document retention, or integration with a formal document management system.
