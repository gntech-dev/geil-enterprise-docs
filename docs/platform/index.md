---
title: Platform
document_id: GEIL-PLT-INDEX
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Platform

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-PLT-INDEX |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This section documents the platforms used to publish, protect, and operate GEIL documentation.

## Platform components

| Component | Purpose |
|---|---|
| GitHub private repository | Version control, pull requests, branch protection |
| MkDocs Material | Static documentation build system |
| Cloudflare Pages | Static site hosting |
| Cloudflare Access | Private access control for the published documentation site |

## Required controls

- Repository must remain private.
- `main` must be branch-protected.
- Cloudflare Pages must deploy from the protected repository.
- Cloudflare Access must protect the production documentation hostname before user rollout.
- Build validation must run with `mkdocs build --strict`.

## Documents

- [Cloudflare Pages Deployment Runbook](cloudflare-pages-deployment.md)
