---
title: Windows Server 2025 Template Certification
document_id: GEIL-PILOT-PVE-WS2025-CERT-001
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-07-08
review_cycle: Per pilot milestone
classification: Internal Confidential
---

# Windows Server 2025 Template Certification

## Certification status

**Certified for Pilot Deployments with Manual Remediation**

## Certification boundary

- The original working template is approved for continued M02 pilot use.
- Certification is conditional.
- Time zone requires manual first-boot correction.
- Cloudbase-Init behavior is operationally observed but not fully certified.
- Secure Boot validation remains open under CR-0003.
- Cloudbase-Init validation remains open under CR-0004.
- Proxmox Cloud-Init drive OOBE failure remains open under CR-0005.

## Template identity

| Field | Value |
|---|---|
| Template | Windows Server 2025 Golden Template |
| Pilot milestone | M02 |
| M02 status | Draft / Pending Pilot Validation |
| Certification version | 1.0 |
| Approved candidate | Original working template (Cloud-Init-drive-removed candidate is **not** certified) |

## Open corrective requests

| CR ID | Title | Status | Priority |
|---|---|---|---|
| CR-0001 | Template certification baseline | Open | High |
| CR-0003 | Secure Boot validation | Open | High |
| CR-0004 | Cloudbase-Init validation | Open | High |
| CR-0005 | Proxmox Cloud-Init drive OOBE failure | Open | High |

CR-0001 remains Open while certification findings are resolved. No CR has been closed.

## Certification results

| Control | Result | Evidence | Notes |
|---|---|---|---|
| Template builds from ISO | Observed | Pending Evidence | Operationally observed during M02; committed evidence remains pending. |
| VirtIO drivers installed | Observed | Pending Evidence | Operationally observed for clone creation; committed evidence remains pending. |
| QEMU Guest Agent installed | Observed | Pending Evidence | Operationally observed during clone creation; committed evidence remains pending. |
| Sysprep completes | Observed | Pending Evidence | Operationally observed during M02; committed evidence remains pending. |
| Clone boots after deployment | Observed | Pending Evidence | Operationally observed during M02; committed evidence remains pending. |
| Time zone set correctly | Not Certified | Pilot finding | Requires manual first-boot correction. Run `Set-TimeZone -Id "SA Western Standard Time"` on first boot. |
| Cloudbase-Init | Open CR | CR-0004 | Behavior observed but not fully certified. Validation remains open under CR-0004. |
| Secure Boot enabled | Open CR | CR-0003 | Not validated. Requires Secure Boot support confirmations per CR-0003. |
| Event Log Health | Out of Scope | N/A | Event log configuration is defined in the M02 baseline, not in this certification. |
| Windows Update compliance | Out of Scope | N/A | Update baseline and servicing are tracked separately from template certification. |
| Proxmox Cloud-Init drive handling | Open CR | CR-0005 | OOBE failure observed when Cloud-Init drive is present; Cloud-Init-drive-removed candidate is not certified. |

## Manual remediation

The following manual step is required on every clone created from the template before infrastructure role deployment: `Set-TimeZone -Id "SA Western Standard Time"`

This step must be performed during first-boot initial setup. It is the only approved manual remediation for M02 pilot deployments.

## Not certified

The modified Cloud-Init-drive-removed template candidate is not certified for M02 pilot use. Only the original working template is approved for continued M02 deployment.

## Certification validity

This certification is valid only for M02 pilot deployments. Certification must be re-evaluated for:

- M03 production candidate.
- Any template rebuild or major component replacement.
- Closure of any open CR.
