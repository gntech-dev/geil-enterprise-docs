---
title: Code Block Quality Standard
document_id: GEIL-GOV-CODE-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-07-01
review_cycle: Quarterly
classification: Internal Confidential
---

# Code Block Quality Standard

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-GOV-CODE-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-07-01 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This standard makes execution correctness a mandatory documentation control for GEIL.

MkDocs build success proves that documentation renders. It does not prove that an engineer can deploy infrastructure from the guide. Every implementation guide must therefore pass both documentation validation and engineering validation before publication.

## Scope

This standard applies to every implementation guide, deployment guide, runbook, validation guide, rollback guide, and executable code example in GEIL, including PowerShell, RouterOS, Bash/Linux, Proxmox, Windows, DNS, DHCP, Active Directory, Group Policy, PKI, NPS, cloud, endpoint, and operations content.

## Mandatory code-block quality gates

Every executable code block must pass these gates before commit:

| Gate | Requirement | Evidence |
|---|---|---|
| Syntax validation | Command syntax, quoting, line continuation, parameter names, and language constructs must be valid for the target shell/platform. | Static review, tool audit, or execution evidence. |
| Dependency validation | Required modules, roles, services, interfaces, OUs, groups, zones, scopes, bridges, VLANs, and paths must be validated before use. | Prerequisite commands and STOP conditions. |
| Execution-order validation | Parent objects must be created before child objects and referenced objects must exist before configuration uses them. | Dependency graph or step sequence review. |
| Prerequisite validation | The guide must validate host, domain, role, module, privilege, network, DNS, and platform prerequisites before mutation. | Prerequisite section and command output. |
| Clean-environment validation | Commands must work from a brand-new documented starting state with no undocumented manual fixes. | Mental deployment simulation and field validation when available. |
| Idempotency review | Object creation should be safe to rerun where practical and should emit `Created`, `Existing`, `Updated`, or `Failed` status. | Structured output and summary counts. |
| Rollback validation | Every mutating step must document safe rollback or state why rollback is not appropriate. | Rollback section after the step. |
| End-state validation | The guide must prove the expected state before the next guide consumes it. | Deployment Validation section. |
| Evidence validation | The guide must state what command output, screenshot, export, or log proves successful implementation. | Evidence section. |

## Mandatory implementation guide execution model

Every implementation guide must use this structure, either as top-level sections or as step-level subsections:

1. Goal
2. Why this step matters
3. Prerequisites
4. Starting state
5. Commands
6. Validation
7. Expected output
8. Rollback or safe recovery
9. Evidence
10. Next step

The sequence is mandatory. Do not place dependent commands before prerequisites or validation.

## Clean-environment simulation requirement

Before publishing or modifying an implementation guide, the author must mentally deploy the guide from a clean environment matching the documented starting state.

For current GEIL Phase 1 content, assume:

- Brand-new Proxmox VE 9 host.
- Brand-new MikroTik CHR RouterOS v7 instance.
- Brand-new Windows Server 2025 server.
- Brand-new Active Directory forest/domain.
- No AD objects, DNS changes, DHCP scopes, GPOs, VLANs, interface lists, firewall rules, service accounts, or groups exist unless explicitly created earlier in the guide.

For every command ask:

- Does the object already exist?
- If not, was it created earlier?
- Is the parent/container validated before the child object is created?
- Is the command safe to paste exactly as published?
- Is the command safe to rerun?
- Is the expected output realistic?
- Does the rollback work from the documented state?

If the answer is uncertain, the guide must be corrected or marked for engineering review before commit.

## PowerShell quality requirements

PowerShell examples must:

- Use complete executable blocks rather than fragmented interactive `if` / `else` examples.
- Validate required modules before mutation.
- Validate domain or server context before mutation.
- Validate permissions before mutation.
- Validate parent containers before child objects.
- Use `-LDAPFilter`, scoped `-SearchBase`, and `-SearchScope OneLevel` for AD existence checks where missing objects are expected.
- Avoid `Get-AD* -Identity` as an existence check for objects that may not exist.
- Avoid invalid AD `-Filter` expressions such as PowerShell-style `-in` lists.
- Prompt secrets with `Read-Host -AsSecureString` or equivalent secure handling.
- Return structured output where practical.
- Print summary counts for batch creation.
- Collect failures and fail at the end when safe.
- Support `-Verbose` for reusable helper-function patterns.
- Add `SupportsShouldProcess` and `ShouldProcess()` when promoted to reusable module or advanced-function automation.

## RouterOS quality requirements

RouterOS examples must:

- Create bridges before bridge ports.
- Create VLAN interfaces before IP addressing, DHCP relay, firewall rules, or service restrictions reference them.
- Create interface lists before interface-list members reference them.
- Validate interface-list membership before firewall, neighbor discovery, MAC server, or WinBox restrictions consume the lists.
- Enter Safe Mode before lockout-sensitive management restrictions.
- Add explicit allow rules before default deny rules.
- Keep VLAN 70 Guest WiFi isolated and never relay it to AD DHCP.
- Include `print` or equivalent validation after configuration changes.
- Include rollback or Safe Mode recovery guidance.

## DNS and DHCP quality requirements

DNS and DHCP examples must:

- Validate AD DNS health before DHCP configuration.
- Validate DNS zones before changing dynamic update or forwarder settings.
- Install and authorize DHCP before creating scopes or enabling relays.
- Create scopes before configuring relays.
- Use canonical scope names consistently, including `WORKSTATIONS-HQ` for VLAN 30 workstations.
- Validate DHCP authorization, scope options, and lease behavior before enabling dependent network relay.

## Canonical GEIL values

Code blocks must use canonical values unless explicitly marked as historical or superseded:

| Category | Canonical value |
|---|---|
| AD DNS domain | `corp.gntech.me` |
| Primary UPN suffix | `gntech.me` |
| NetBIOS | `GNTECH` |
| Domain controller | `HQ-DC01` |
| Firewall | `HQ-FW01` |
| GEIL address space | `172.20.0.0/16` |
| GEIL WAN transit | `172.31.255.0/30` |
| Proxmox bridge names | `GEILWAN`, `GEILLAN` |
| VLAN 30 DHCP scope | `WORKSTATIONS-HQ` |

Legacy `10.10.x.x` references must be explicitly documented as existing non-GEIL networks or historical context. Active Phase 1 firewall implementation must reference MikroTik CHR / RouterOS, not OPNsense, unless the document is explicitly superseded or historical.

## Deployment Verified section

Every implementation guide must include:

```text
## Deployment Verified

| Field | Value |
|---|---|
| Validated on | Not yet field validated / Windows Server 2025 / RouterOS v7 / Proxmox VE 9 |
| Windows Server version | Not applicable / Windows Server 2025 build <build> |
| RouterOS version | Not applicable / RouterOS v7.x |
| Proxmox version | Not applicable / Proxmox VE 9.x |
| Deployment date | YYYY-MM-DD or Not yet field validated |
| Deployment notes | What was proven during deployment |
| Known caveats | Limitations, assumptions, or follow-up validation |
```

If a guide has not yet been field validated, it must say so clearly. Do not imply production execution evidence that does not exist.

## Automated audit tools

The repository includes two audit entry points:

```bash
./tools/audit-doc-codeblocks.sh
```

```powershell
.\tools\audit-doc-codeblocks.ps1
```

The audit must fail on known execution-correctness failure patterns, including:

- invalid PowerShell regex
- invalid AD `-Filter` syntax
- fragmented interactive PowerShell `if` / `else` examples
- commands referencing objects before creation
- inconsistent object names
- duplicate headings/object names that produce ambiguous instructions
- invalid OU-path patterns
- hardcoded non-canonical environment values
- obsolete active OPNsense deployment references
- legacy `10.10.x.x` enterprise references without historical/non-GEIL context
- broken RouterOS command ordering
- missing validation after configuration changes
- missing rollback or safe-recovery procedures
- missing Deployment Verified sections

## Publishing gate

A documentation change may be committed only after all of the following pass:

```bash
./tools/audit-doc-codeblocks.sh
mkdocs build --strict
```

On Windows, the PowerShell audit may be run instead of the shell wrapper:

```powershell
.\tools\audit-doc-codeblocks.ps1
```

If either audit or MkDocs fails, correct the documentation before committing. If confidence remains low after review, create an open engineering review item and do not publish the affected implementation content.
