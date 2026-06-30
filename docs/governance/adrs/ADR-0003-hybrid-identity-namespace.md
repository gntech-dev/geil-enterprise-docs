---
title: ADR-0003 Hybrid Identity Namespace
document_id: GEIL-ADR-0003
owner: Architecture Review Board
status: Accepted
version: 1.0
last_reviewed: 2026-06-30
review_cycle: Quarterly
classification: Internal Confidential
---

# ADR-0003 Hybrid Identity Namespace

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-ADR-0003 |
| Owner | Architecture Review Board |
| Status | Accepted |
| Version | 1.0 |
| Last Reviewed | 2026-06-30 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Status

Accepted

## Context

GEIL must support a Microsoft 365-first user identity experience while still using an internal Active Directory forest for Windows infrastructure, DNS, Group Policy, Kerberos, LDAP-integrated workloads, certificate services, and hybrid identity.

The Active Directory forest is intentionally named `corp.gntech.me`. That namespace is the internal AD DS and DNS boundary. The Microsoft 365 verified public domain is `gntech.me`, and users must authenticate everywhere with `username@gntech.me`.

Using `username@corp.gntech.me` as the production sign-in name would create a different cloud and user-facing namespace than Microsoft 365, Entra ID, Intune, Windows Hello for Business, and future cloud services expect.

## Decision

Use separate namespaces for Active Directory DNS and user authentication:

| Identity Layer | Decision |
|---|---|
| Forest DNS namespace | `corp.gntech.me` |
| AD DNS namespace | `corp.gntech.me` |
| NetBIOS domain | `GNTECH` |
| User authentication namespace | `gntech.me` |
| Primary UPN suffix | `gntech.me` |
| Microsoft 365 verified domain | `gntech.me` |
| Default user sign-in | `username@gntech.me` |
| Legacy logon | `GNTECH\username` |

Production user accounts must use `username@gntech.me`. The pattern `username@corp.gntech.me` is allowed only when explaining the default Active Directory state before the hybrid UPN suffix is added.

## Rationale

Microsoft 365 and Microsoft Entra ID work best when user sign-in names use a verified, routable public domain. `gntech.me` is the public Microsoft 365 tenant domain and is the user-facing identity namespace.

`corp.gntech.me` remains valuable as the AD DS forest namespace because it separates internal directory DNS from public-facing identity and internet DNS. This reduces naming ambiguity, keeps infrastructure records in the AD DNS zone, and avoids exposing internal AD naming as the normal user sign-in pattern.

## Scalability

This model supports:

- Additional domain controllers inside `corp.gntech.me`.
- Future Entra ID hybrid identity synchronization.
- Microsoft 365, Intune, Windows Hello for Business, Conditional Access, and Defender integration.
- Future cloud services that expect `username@gntech.me`.
- Legacy Windows compatibility through `GNTECH\username`.

## Microsoft 365 integration

The `gntech.me` UPN suffix aligns on-premises user identities with Microsoft 365 and Entra ID. This reduces user confusion, avoids alternate cloud sign-in names, and supports a seamless hybrid identity experience.

## Consequences

Positive:

- Users have one sign-in name across Windows, Microsoft 365, Entra ID, Intune, and future services.
- The AD DNS namespace remains cleanly separated from the public authentication namespace.
- Hybrid identity deployment can proceed without renaming the AD forest.

Tradeoffs:

- AD DS must be configured with the alternative UPN suffix immediately after forest creation.
- User creation procedures must set UPNs to `gntech.me`.
- Documentation must distinguish server FQDNs in `corp.gntech.me` from user sign-ins in `gntech.me`.

## Implementation requirements

- Add `gntech.me` as an alternative UPN suffix immediately after the `corp.gntech.me` forest is created.
- Update the built-in Administrator account to `Administrator@gntech.me`.
- Create future users with `username@gntech.me`.
- Preserve `GNTECH\username` as the legacy logon format.
- Keep server FQDNs and AD DNS records in `corp.gntech.me`.

## Validation

After promoting `HQ-DC01`, validate:

```powershell
Get-ADDomain | Select-Object DNSRoot,NetBIOSName
```

Expected:

```text
DNSRoot      : corp.gntech.me
NetBIOSName  : GNTECH
```

```powershell
Get-ADForest | Select-Object Name,UPNSuffixes
```

Expected:

```text
Name        : corp.gntech.me
UPNSuffixes : {gntech.me}
```

```powershell
Get-ADUser -Identity Administrator -Properties UserPrincipalName | Select-Object SamAccountName,UserPrincipalName
```

Expected:

```text
Administrator  Administrator@gntech.me
```

## Related documents

- [Environment Specification](../../project/environment-specification.md)
- [Enterprise Lab Identity HLD](../../architecture/enterprise-lab-identity-hld.md)
- [Identity Architecture](../../architecture/identity-architecture.md)
- [Active Directory Implementation](../../microsoft-core/active-directory-implementation.md)
- [Entra ID Hybrid Identity](../../cloud-endpoint/entra-id-hybrid-identity.md)
