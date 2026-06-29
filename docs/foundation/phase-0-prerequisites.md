---
title: Phase 0 Prerequisites
document_id: GEIL-FND-P0-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Phase 0 Prerequisites

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-FND-P0-001 |
| Owner | Infrastructure Engineering |
| Status | Draft |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

Complete required planning before any production infrastructure is built.

## Required inputs

- Business name and tenant placeholder: `<TENANT_NAME>`.
- Public DNS zones and registrar access.
- Static public IP addresses: `<PUBLIC_IP>`.
- Site codes, subnet plan, VLAN plan.
- Hardware inventory and warranty status.
- Licensing plan for Windows Server, Windows 11 Enterprise, Microsoft 365, Intune, and Defender.
- Break-glass account owners.

## Implementation checklist

1. Approve naming and addressing standard.
2. Create private GitHub repository.
3. Configure branch protection.
4. Configure Cloudflare DNS and Access plan.
5. Record OPNsense, Proxmox, Microsoft 365, and domain registrar emergency access procedures in a secure password manager, not in GEIL.

## Validation

```powershell
Resolve-DnsName <PUBLIC_DOMAIN>
```

Expected result: authoritative public DNS resolves from an external resolver.

## Rollback

Do not proceed to implementation if ownership of public DNS, Microsoft 365 tenant, or firewall administration is unclear. Escalate to governance.
