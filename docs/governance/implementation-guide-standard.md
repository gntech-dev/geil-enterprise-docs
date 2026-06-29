---
title: Implementation Guide Standard
document_id: GEIL-GOV-IMPL-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Implementation Guide Standard

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-GOV-IMPL-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This standard defines the required structure and teaching style for all GEIL implementation guides. GEIL implementation guides must teach, guide, validate, and explain. They must be usable by an engineer deploying the GNTECH enterprise environment for the first time without relying on external tutorials, except where the reader must download vendor software or consult vendor licensing terms.

!!! success "Mandatory standard"

    This standard is mandatory for all new and materially updated implementation guides. If an implementation guide cannot meet this standard yet, mark the gap in the documentation backlog and do not present the guide as production-ready.

## Scope

This standard applies to documents that install, configure, integrate, validate, or roll back infrastructure components. Examples include Proxmox, OPNsense, Active Directory, DNS, DHCP, PKI, NPS, Microsoft 365, Entra ID, Intune, monitoring, backup, and security tooling implementation guides.

It does not replace HLD, LLD, architecture, policy, ADR, evidence, or acceptance package formats. Those documents may reference this standard when they contain procedural implementation sections.

## Required guide sections

Every implementation guide must contain the following sections in this order unless a documented exception is approved:

1. Purpose
2. Learning Objectives
3. What You Will Build
4. Estimated Time
5. Difficulty
6. Risk Level
7. Service Impact
8. Prerequisites
9. Architecture Overview
10. Background Knowledge
11. Step-by-Step Procedure
12. Validation
13. Common Mistakes
14. Troubleshooting
15. Rollback
16. Evidence Collection
17. Knowledge Check
18. Next Guide

!!! tip "Write like Microsoft Learn"

    Use a professional, educational voice. Explain why a step matters before showing how to perform it. Use active voice, avoid unnecessary jargon, and define required concepts before using them.

## Section requirements

### Purpose

Explain what the guide deploys and what problem it solves. The purpose must be specific enough that a reader knows whether this is the correct guide to use.

### Learning Objectives

Start with this phrase:

```text
After completing this guide you will understand:
```

Then list 4-7 outcomes such as why the component exists, how it integrates with the enterprise, how to deploy it, how to validate it, and how to troubleshoot it.

### What You Will Build

Provide a concise visual summary of the end state using checkmarks:

```markdown
By the end of this guide you will have:

- ✓ Component installed
- ✓ Required network path configured
- ✓ Validation evidence captured
- ✓ Rollback checkpoint created
```

### Estimated Time

Use realistic time ranges such as `15-30 minutes`, `1-2 hours`, or `Half day`. Include a note when install media download time is excluded.

### Difficulty

Choose exactly one:

- Beginner
- Intermediate
- Advanced

Explain the reason in one or two sentences.

### Risk Level

Choose exactly one:

- Low
- Medium
- High

Explain why. High-risk guides must include a rollback checkpoint before the first risky change.

### Service Impact

Choose exactly one:

- No impact
- Maintenance window recommended
- Service interruption expected

Explain the expected user or infrastructure impact.

### Prerequisites

List all prerequisites. Include links to previous GEIL documents, required approvals, required access, required files/ISOs, expected starting state, and any dependency that blocks the guide.

### Architecture Overview

Explain where the component fits in the enterprise. Reference the relevant HLD, LLD, and environment documents. Include a simplified diagram showing only the components involved in the guide.

### Background Knowledge

Never assume prior knowledge. Briefly explain concepts before using them. Keep explanations concise and focused on the guide.

Examples:

- What is a VLAN?
- What is a Linux bridge?
- What is DHCP Relay?
- What is RADIUS?
- What is a domain controller?
- What is AD-integrated DNS?

### Step-by-Step Procedure

Every major step must include:

- Goal
- Why this step matters
- Navigation path
- GUI location where applicable
- Commands where applicable
- Expected values
- Notes
- Warnings
- Validation
- Rollback if the step is risky

Use the heading pattern:

```markdown
### Step N: Verb phrase

#### Goal

#### Why this step matters

#### Navigation path

#### Procedure

#### Expected results

#### Validate this step

#### Rollback
```

### Copy/Paste Blocks

Commands must be complete and immediately usable. Avoid incomplete snippets, unexplained variables, and commands that require hidden context.

If a value is not known before deployment, explain how to discover it and where to record it.

### Expected Results

After every major step include:

```markdown
You should now see:

- ...
```

### Validation

Validation must use the most appropriate method:

- GUI checks
- PowerShell
- Linux commands
- Network tests
- Firewall logs
- DNS queries
- Service health checks

Every validation command must include expected output or expected behavior.

### Common Mistakes

List the most likely mistakes. Include symptoms and fixes.

### Troubleshooting

Explain how to diagnose and recover from common failures. Troubleshooting should be procedural, not only descriptive.

### Rollback

Explain how to safely undo the change. Include exact commands where possible. For irreversible changes, state the restore or rebuild path.

### Evidence Collection

List screenshots and command outputs that must be captured. Evidence must not include secrets, private keys, password material, or full sensitive configuration exports committed to Git.

### Knowledge Check

End every guide with 3-5 questions that reinforce why the design works. Questions must test understanding, not memorization only.

### Next Guide

Always finish with:

```text
Continue to:

- Next Guide Title: relative/path-to-next-guide.md
```

If there is no next guide, link to the relevant validation or operations page.

## MkDocs Material admonitions

Use Material for MkDocs admonitions extensively:

- `!!! note` for neutral context.
- `!!! info` for architecture context.
- `!!! tip` for operational shortcuts.
- `!!! warning` for risky or easy-to-miss conditions.
- `!!! danger` for destructive or outage-causing actions.
- `!!! success` for completion criteria.
- `!!! example` for command/output examples.

Admonitions must add value. Do not use them as decoration.

## Screenshot placeholder standard

If screenshots do not yet exist, create screenshot requirements directly in the guide and create a placeholder directory under:

```text
docs/assets/images/<guide-slug>/
```

Use this page pattern:

```markdown
!!! example "Screenshot Required"

    Path: `Interfaces -> Assignments`

    Expected result:

    - WAN = `vtnet0`
    - LAN = `vtnet1`

    Store the final image under `docs/assets/images/<guide-slug>/` after deployment.
```

Do not reference a screenshot file until the file exists. Broken image links are not allowed.

## Diagram requirements

Every implementation guide must begin with a simplified architecture diagram showing only the components involved in that guide. Use Mermaid for simple guide-level diagrams. Use dedicated assets under `docs/assets/diagrams/` when the diagram is complex.

Guide diagrams must be intentionally small. Avoid full enterprise diagrams in implementation guides; link to the HLD or LLD instead.

## Style requirements

Implementation guides must:

- Explain why before how.
- Use active voice.
- Teach the reader the concept before requiring action.
- Use canonical GNTECH values from the Environment Specification.
- Link to the relevant HLD/LLD documents.
- Provide validation after every major change.
- Provide rollback before destructive or high-risk changes.
- Identify evidence that proves success.
- Avoid unnecessary jargon.
- Avoid placeholders when values are known.

## Quality gate

Before an implementation guide is published:

1. Confirm every required section is present.
2. Confirm every command has expected output or expected behavior.
3. Confirm risky steps include rollback.
4. Confirm screenshot requirements are listed.
5. Confirm the guide includes a knowledge check and next guide.
6. Confirm links pass `mkdocs build --strict`.
7. Confirm `site/` is not tracked in Git.

## Related documents

- [Documentation Standard](documentation-standard.md)
- [Visual Documentation Standard](visual-documentation-standard.md)
- [Environment Specification](../project/environment-specification.md)
- [Epic and Release Architecture](../project/epic-release-architecture.md)
