---
title: Educational Documentation Standard
document_id: GEIL-GOV-EDU-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Educational Documentation Standard

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-GOV-EDU-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This standard evolves GEIL from implementation documentation into an enterprise learning and deployment platform. It defines the educational requirements that every implementation guide must meet in addition to the [Implementation Guide Standard](implementation-guide-standard.md).

!!! success "Mandatory standard"

    This standard is mandatory for every new and materially updated implementation guide. A guide is not production-ready until it teaches the enterprise concept, explains the GEIL design choice, instructs the operator, validates the outcome, and documents recovery.

## Educational principles

Every guide must teach before it instructs. Every major section should answer:

1. What are we doing?
2. Why are we doing it?
3. What happens internally?
4. What could go wrong?
5. How do we know it worked?

Never assume prior enterprise infrastructure knowledge. Explain concepts concisely before using them in commands, GUI instructions, validation checks, or troubleshooting.

## Required educational sections

Every implementation guide must include these educational sections, either as standalone sections or as clearly labeled subsections:

- What you are building
- Why this component exists
- How this component interacts with the rest of the enterprise
- Internal workflow
- Real-world enterprise usage
- Design decisions specific to GEIL
- Alternatives considered
- Security considerations
- Performance considerations
- Scalability considerations
- Operational considerations
- Common deployment mistakes
- Frequently Asked Questions
- Key takeaways

## Required step format

Every deployment step should follow this structure:

1. Step title
2. Goal
3. Why this step matters
4. Background knowledge, if required
5. Procedure
6. Commands
7. GUI navigation
8. Expected result
9. Validation
10. Evidence
11. Troubleshooting
12. Rollback
13. Next step

If a step does not require a GUI or command, state `Not applicable` instead of omitting the field.

## Visual learning requirements

Before every major configuration section, include a simplified architecture diagram. Show only the components relevant to that section.

Use Mermaid for small local diagrams. Split complex diagrams into multiple smaller diagrams. Use dedicated assets under `docs/assets/diagrams/` when the visual would be too wide or too dense for normal MkDocs rendering.

## Explanation depth for configuration values

For every important configuration value, explain:

- What it is
- Why GEIL uses this value
- What happens if it changes
- Whether it can be customized

Examples of important values include hostnames, forest names, VLAN IDs, IP addresses, DNS zones, bridge names, firewall rule order, DHCP options, certificate names, and service account names.

## Enterprise admonition

Use `!!! enterprise` to explain how the same concept is implemented in medium and large enterprises.

Example:

```markdown
!!! enterprise "Enterprise pattern"

    Large enterprises typically deploy two issuing CAs behind an offline root CA and publish certificate health into monitoring.
```

Use this block for enterprise operating model context, not for GEIL-specific deployment lessons.

## Implementation admonition

Use `!!! implementation` to document lessons learned during actual GEIL deployment.

Example:

```markdown
!!! implementation "GEIL deployment note"

    During the GEIL deployment, bridges defined only under `/etc/network/interfaces.d/` were not visible in the Proxmox GUI. GEIL bridge definitions are therefore placed directly in `/etc/network/interfaces`.
```

This documentation should evolve as infrastructure is deployed. Implementation notes may include discovered platform behavior, operational caveats, validation lessons, or recovery improvements.

## Frequently Asked Questions standard

Each implementation guide must include an FAQ section with practical operator questions. Good FAQ entries answer why the design exists, when to customize it, and what failure modes to expect.

## Key takeaways standard

Each guide must end its educational content with key takeaways. These should summarize the enterprise lesson, not merely repeat the commands.

## Related standards

- [Documentation Standard](documentation-standard.md)
- [Implementation Guide Standard](implementation-guide-standard.md)
- [Visual Documentation Standard](visual-documentation-standard.md)
- [Environment Specification](../project/environment-specification.md)
