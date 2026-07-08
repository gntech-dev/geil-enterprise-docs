---
title: Deployment Style Guide
document_id: GEIL-GOV-DEPLOY-001
owner: Infrastructure Engineering
status: Approved
version: 1.1
last_reviewed: 2026-07-07
review_cycle: Quarterly
classification: Internal Confidential
---

# Deployment Style Guide

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-GOV-DEPLOY-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.1 |
| Last Reviewed | 2026-07-07 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This standard is the canonical writing standard for all GEIL deployment documentation. It supersedes any previous objective to increase document count. The primary objective is now quality, usability, reproducibility, educational value, and operator experience.

## Scope

This standard applies to implementation guides, deployment guides, validation plans, acceptance packages, security operations procedures, operations runbooks, and any page that instructs an operator to change infrastructure state.

## Quality Philosophy

Assume the reader has never deployed the infrastructure before. A reader must be able to deploy the complete enterprise infrastructure by following GEIL without needing external tutorials except for downloading software.

Every guide must:

- Teach before it instructs.
- Explain why before how.
- Validate after each action.
- Recover from failure.
- Avoid hidden assumptions.
- Use canonical values from the [Environment Specification](../project/environment-specification.md).

!!! enterprise "Quality target"

    GEIL deployment documentation must be comparable to Microsoft Learn, Microsoft Operations Guides, VMware vSphere documentation, Cisco Enterprise Design Guides, Red Hat Enterprise Linux documentation, and HashiCorp Learn.


## Deployment Guide Principle

GEIL is a pilot-first project. Deployment documentation must let another engineer reproduce the validated pilot from scratch, not merely understand the environment that already exists.

Every Deployment Guide must allow an engineer to deploy a brand new component from factory defaults or from a clean operating system installation to the validated pilot configuration using only documentation in this repository.

A Deployment Guide must not assume:

- Previous undocumented manual configuration.
- Operator memory from the pilot.
- Hidden inherited lab state.
- Unrecorded firewall, identity, DNS, GPO, or service changes.

A Deployment Guide must begin with one of these states:

- Factory defaults.
- Clean operating system installation.

A Deployment Guide must end with this state:

- Pilot Validated configuration.

The Deployment Workflow must answer:

> Could a new engineer rebuild this component from scratch using only this document?

If the answer is no, the Deployment Guide is incomplete.

## Pilot Validated documentation model

Microsoft Core implementation documentation is transitioning to a Pilot Validated model. Do not refactor the entire repository to match this model at once. Apply it gradually when an EPIC is actively implemented or when a validated pilot correction updates an existing EPIC.

Rules:

- Update the existing authoritative document for the EPIC.
- Preserve existing content whenever possible.
- Avoid unnecessary rewrites and architecture churn.
- Do not update documents for EPICs that have not yet been implemented.
- Do not create duplicate roadmap or architecture documents.
- Record corrections learned during lab validation in the existing implementation guide.

Every newly validated implementation must use this top-level structure where applicable:

1. **Purpose** - what the component or EPIC implements and what is explicitly out of scope.
2. **Architecture** - the operating model, participating systems, and dependencies.
3. **Prerequisites** - required infrastructure, identity, GPOs, permissions, files, approvals, and access.
4. **Deployment Workflow** - reproducible deployment sequence from factory defaults, a clean operating system installation, or a documented prerequisite baseline to the validated pilot configuration.
5. **Validation Workflow** - every validation step with expected results.
6. **Pilot Findings** - lessons learned, corrections made, temporary rules, known pilot exceptions, and final validated state from the lab.
7. **Operations** - routine administration, periodic checks, backup/export, update, and lifecycle guidance.
8. **Troubleshooting** - symptoms, validation commands or GUI checks, expected output, and resolution.
9. **Acceptance Criteria** - conditions required before the component or EPIC is considered complete.

Add optional sections such as PowerShell Automation, RouterOS Configuration, GUI / GPMC Implementation, or Current Configuration Snapshot only when they improve implementation clarity. Do not use optional sections to avoid the required reproducible Deployment Workflow.

Definitions:

| Section | Definition |
|---|---|
| Deployment Workflow | Documents the complete deployment sequence from factory defaults, a clean operating system installation, or a documented prerequisite baseline to the validated pilot configuration. |
| Validation Workflow | Documents every validation step together with the expected result. |
| Pilot Findings | Documents everything learned during laboratory implementation, including corrections made after validation. |
| Acceptance Criteria | Defines the conditions required before an EPIC can be considered complete. |

This model does not replace the step-level requirements below. It defines the document-level structure for implemented and pilot-validated EPICs; individual deployment actions must still follow the step contract, command execution context standard, validation, rollback, and troubleshooting requirements.


## Pilot Validation Completion Rule

A component is not complete until all of the following are true:

1. It has been deployed in the GEIL lab.
2. It has been validated with documented commands or GUI checks.
3. Pilot findings have been incorporated into the authoritative documentation.
4. Documentation has been updated to reflect the validated state.
5. Validation commands succeed.
6. Changes have been committed and pushed.

Do not mark a component as Pilot Validated based on design intent alone. Pilot Validated means the lab implementation happened, evidence-producing validation succeeded, and the documentation now reflects what was learned.

## Infrastructure Component Documentation Model

Each major infrastructure component should eventually have the following documentation coverage:

| Document type | Purpose |
|---|---|
| Design | Intended architecture, dependencies, service ownership, and decisions. |
| Deployment Guide | Reproducible build from factory defaults or clean OS to validated pilot configuration. |
| Pilot Findings | Lessons learned, temporary rules, deviations, corrections, and readiness gaps discovered during validation. |
| Current Configuration Snapshot | Sanitized current validated configuration state, export, or evidence snapshot when applicable. |

This model applies as components mature. Examples include `HQ-FW01`, `HQ-DC01`, `HQ-WEC01`, `HQ-MGMT01`, `HQ-W11-001`, DNS, DHCP, Windows LAPS, Microsoft Defender, Windows Event Forwarding, WinRM, and Active Directory.

## Mandatory Step Contract

Every deployment step must start with the following fields in this order:

1. **Goal** - one objective only.
2. **Why this matters** - business, technical, security, and operational reason.
3. **Estimated time** - realistic time for the step.
4. **Risk level** - Low, Medium, or High with explanation.
5. **Prerequisites** - exact objects, access, files, and previous steps required.
6. **Starting state** - what must already be true.
7. **Expected ending state** - what will be true after the step.

A step that cannot satisfy this contract is too broad and must be split.

## One Objective Per Step

Never combine independent actions into one step.

Wrong:

```text
Install AD DS, create the forest, configure DNS, and reboot.
```

Correct:

```text
Step 1: Install AD DS role.
Validate.
Step 2: Create the forest.
Validate.
Step 3: Reboot.
Validate.
```

## One Action At A Time

A guide should feel like this:

1. Read one section.
2. Execute one action.
3. Validate.
4. Continue.

Do not force the operator to scroll to another section to find validation, rollback, or explanation.



## Credential Identity Format Standard

Whenever credentials or sign-in examples are shown, explicitly document the required identity format. Do not assume the reader knows whether to use NetBIOS, SAM, UPN, or cloud sign-in format.

Use examples such as:

```text
Run as: GNTECH\admin.gnolasco
```

```text
Sign in using: GNTECH\admin.gnolasco
```

```text
Cloud sign-in: admin.gnolasco@gntech.me
```

Remote Desktop examples must use `GNTECH\username` unless that specific RDP client has been explicitly validated for UPN sign-in. Microsoft 365, Entra ID, and cloud application examples use `username@gntech.me`.

## Command Execution Context Standard

Every operator-facing command block must identify the execution context immediately before the block. Do not assume the reader knows where the command runs.

Use this format before every command block that changes, validates, or queries infrastructure state:

```markdown
Run on: `HQ-MGMT01`

When: after the prerequisite step is complete and before continuing to the next step.

Expected outcome: the command completes successfully and the following expected result or validation section confirms success.
```

Approved execution contexts include, but are not limited to:

- `HQ-MGMT01`
- `HQ-DC01`
- `PVE-HQ01`
- `HQ-FW01`
- `Windows Client`
- `Management Workstation`

Routine administration must originate from `HQ-MGMT01` whenever possible. Commands should execute directly on domain controllers only for initial deployment, bootstrap, disaster recovery, break-glass procedures, or when Microsoft explicitly requires local execution.

Every command block must make clear:

1. Where the command runs.
2. When it should be executed.
3. Expected outcome.

## Command Formatting Standard

### RouterOS

- One executable command per line.
- Do not wrap commands unless RouterOS officially supports the syntax.
- Do not mix commands and expected output in the same code block.
- Do not paste broad firewall changes without Safe Mode guidance.

### PowerShell

- One command per line where practical.
- Avoid multiline commands unless PowerShell continuation is necessary and clearly shown.
- Validate module availability before using module cmdlets.
- Do not use AD cmdlets before the forest/domain exists.

### Bash/Linux

- One command per line.
- Do not combine unrelated actions with `&&` in operator-facing deployment blocks.
- Avoid destructive commands without pre-checks and rollback.

## Expected Output Standard

Every command block must be followed by:

- Expected output.
- How to verify.
- Commands to verify.
- GUI validation path when applicable.
- What success looks like.

Expected output must be in a separate block from commands.

## GUI Formatting Standard

Every GUI action must include:

| Field | Requirement |
|---|---|
| Navigation path | Exact click path |
| Window name | Exact window/dialog |
| Tab name | Exact tab |
| Field | Exact field label |
| Value | Exact value to enter/select |
| Expected result | What the operator should see |

## Screenshot Placement Standard

Place screenshot placeholders exactly where the screenshot belongs. Do not move all screenshots to the end of the guide.

Use this format:

```markdown
!!! example "Screenshot Required"

    Path: `Navigation -> Window -> Tab`

    Expected result:

    - Field A = value
    - Status = healthy
```

## Failure Handling Standard

Every step must answer:

- What happens if this fails?
- How do I recover?
- Can I safely continue?

If the answer is unknown, the guide must say **stop and escalate** rather than allow the operator to continue blindly.

## Rollback Standard

Every destructive operation requires rollback guidance. Use the least destructive rollback first:

1. Undo the last setting.
2. Disable rather than delete.
3. Restore an export.
4. Restore a snapshot only when the workload type permits it.
5. Rebuild only before production use or when the state is untrusted.

!!! danger "Snapshot boundary"

    Hypervisor snapshot rollback is acceptable for pre-production infrastructure before dependent systems exist. It is not a casual rollback method for active domain controllers, certificate authorities, or replicated infrastructure.

## Enterprise Explanation Standard

Every major section must explain:

- Why enterprises do it this way.
- Alternatives considered.
- Trade-offs.
- Security implications.
- Operational implications.
- Scaling implications.

Use `!!! enterprise` blocks for enterprise context and `!!! implementation` blocks for lessons learned during real GEIL deployment.

## Troubleshooting Standard

Each major step must include troubleshooting that is close to the action. Troubleshooting must be realistic and must include:

- Symptom.
- Likely cause.
- Validation command or GUI check.
- Corrective action.
- Whether it is safe to continue.

## Knowledge Standard

Every guide must explain:

- What the component does.
- Why it exists.
- How it communicates.
- What depends on it.
- What breaks if it fails.

## Quality Review Rubric

Score each guide from 0 to 100 using this rubric:

| Category | Points |
|---|---:|
| Step clarity and one-objective structure | 15 |
| Copy/paste-safe commands | 15 |
| Immediate validation and expected outputs | 15 |
| Failure handling and rollback | 15 |
| Enterprise explanation and educational value | 15 |
| Screenshot and GUI operator experience | 10 |
| Dependency and prerequisite clarity | 10 |
| Pleasant operator flow | 5 |

Minimum quality gates:

- 90+: Ready for first-time deployment.
- 80-89: Usable but needs targeted refinement.
- 70-79: Internal-runbook quality; must be improved before novice deployment.
- Below 70: Not acceptable as a GEIL deployment guide.

## Publishing Requirement

No deployment documentation change is complete until:

1. Related guides are updated.
2. Pilot findings are incorporated when the change comes from lab validation.
3. Validation commands succeed.
4. Document index, backlog, roadmap, release assignment register, and changelog are synchronized when needed.
5. `./tools/audit-doc-codeblocks.sh .` passes.
6. `mkdocs build --strict` passes.
7. `git diff --check` passes.
8. Generated `site/` remains untracked.
9. The changes are committed and pushed when the task requires publication.
