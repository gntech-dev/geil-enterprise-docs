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


## HQ Foundation Low-Level Design

Release `E02.R03` translates the Enterprise Lab Blueprint HLD into deployable Phase 1 specifications:

- [Proxmox HQ Foundation LLD](proxmox-hq-foundation-lld.md)
- [MikroTik CHR HQ Foundation LLD](mikrotik-chr-hq-foundation-lld.md)
- [Phase 1 Build Plan](phase-1-build-plan.md)
- [Phase 1 Validation Plan](phase-1-validation-plan.md)


## HQ Foundation Implementation Runbooks

Release `E02.R04` provides implementation-ready runbooks for deploying the initial HQ foundation from the approved HLD and LLD:

- [Proxmox HQ Foundation Implementation Runbook](proxmox-hq-foundation-implementation.md)
- [MikroTik CHR HQ Foundation Implementation Guide](mikrotik-chr-hq-foundation-implementation.md)


## HQ Foundation Acceptance

Release `E02.R05` defines the formal evidence and sign-off gate before Microsoft identity services begin:

- [Phase 1 Acceptance Package](phase-1-acceptance-package.md)
