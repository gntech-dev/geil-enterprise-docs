---
title: Visual Documentation Standard
document_id: GEIL-GOV-VISUAL-001
owner: Infrastructure Engineering
status: Approved
version: 2.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Visual Documentation Standard

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-GOV-VISUAL-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 2.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This standard defines how GEIL uses visual architecture diagrams. Mermaid remains approved for simple workflows and dependency graphs, but complex architecture diagrams must be treated as first-class visual assets with source files, exported images, readability requirements, ownership, and maintenance expectations.

The objective is to keep GEIL diagrams readable at normal MkDocs page width as the library grows beyond 1,000 pages.

## Scope

This standard applies to all new and materially updated GEIL diagrams, including:

- Architecture diagrams.
- HLD and LLD topology diagrams.
- Security zone diagrams.
- PKI hierarchy diagrams.
- Identity and trust boundary diagrams.
- Network, VLAN, routing, and management flow diagrams.
- Future regional and disaster recovery diagrams.

## Diagram selection policy

| Diagram Type | Preferred Format | Use Mermaid? | Use Dedicated Asset? |
|---|---|---:|---:|
| Simple sequence or workflow | Mermaid | Yes | Optional |
| Simple dependency graph | Mermaid | Yes | Optional |
| Small component relationship | Mermaid | Yes | Optional |
| Wide hierarchy | SVG/PNG/WebP asset | Simplified only | Yes |
| Security zone model | SVG/PNG/WebP asset | Simplified only | Yes |
| PKI hierarchy | SVG/PNG/WebP asset | Simplified only | Yes |
| Multilayer reference architecture | SVG/PNG/WebP asset | Simplified only | Yes |
| Physical or logical topology | SVG/PNG/WebP asset | Simplified only | Yes |
| Large network/VLAN map | SVG/PNG/WebP asset | Simplified only | Yes |

Mermaid must not be the only representation for complex architecture diagrams when the rendered output becomes crowded, tiny, or difficult to read in MkDocs.

## Asset storage standard

All generated diagram assets must be stored under:

```text
docs/assets/diagrams/
```

Required asset pattern:

```text
docs/assets/diagrams/<document-slug>/<diagram-name>.svg
docs/assets/diagrams/<document-slug>/<diagram-name>.png
docs/assets/diagrams/<document-slug>/<diagram-name>.webp
```

Source files should be preserved wherever practical. Approved source formats include:

- `.svg`
- `.drawio`
- `.excalidraw`
- `.html` containing inline SVG
- `.mmd` for simplified Mermaid source

Exported images should prefer `.webp` for web performance or `.png` when WebP is not available. SVG is preferred when text remains readable and the asset is self-contained.

## Visual design requirements

Complex architecture visuals must use the GEIL visual style:

| Requirement | Standard |
|---|---|
| Aspect ratio | 16:9 unless a different layout is approved |
| Background | Dark background, typically near `#020617` / slate-950 |
| Accent style | GNTECH blue/cyan accents |
| Text | High contrast, large labels, readable at normal MkDocs page width |
| Layout | Minimal clutter, no excessive branching, grouped layers or zones |
| Typography | Prefer clear sans-serif or mono labels; avoid tiny annotations |
| Contrast | Must remain readable on the MkDocs Material dark theme |
| Density | Prefer multiple focused diagrams over one unreadable master diagram |

## Complex diagram page requirements

Every page containing a complex diagram must include:

1. A short text explanation of what the visual communicates.
2. The image asset using Markdown image syntax.
3. A simplified Mermaid diagram only when it improves accessibility or explains flow.
4. An Adaptation Note when canonical GNTECH values are shown.
5. A source-file reference or asset location note where appropriate.

Required pattern:

```markdown
## Security Zone Architecture

This visual shows the Phase 1 HQ trust boundaries and gateway ownership. `HQ-FW01` owns all VLAN gateways; `PVE-HQ01` does not route between enterprise VLANs.

Image asset path: `../assets/diagrams/enterprise-lab-network-hld/security-zone-architecture.webp`

!!! note "Adaptation"

    This diagram uses GNTECH VLAN IDs and `172.20.0.0/16` addressing from the Environment Specification. Other organizations must update their environment specification first and then regenerate the diagram asset.
```

## Mermaid usage rules

Use Mermaid for:

- Short workflows.
- Small dependency graphs.
- Deployment sequences.
- Rollback paths.
- Decision flows.
- Simple one-screen relationship diagrams.

Avoid Mermaid as the only diagram format for:

- PKI hierarchy with multiple certificate classes.
- Security zones with many VLANs.
- Multilayer enterprise reference architecture.
- Full physical plus logical topology on one canvas.
- Large document dependency graphs.

When Mermaid is retained for complex content, simplify it to the core flow and pair it with a dedicated visual asset.


## Naming convention

Generated diagram files must use the following pattern:

```text
geil-<topic>-<diagram-type>.<extension>
```

Examples:

- `geil-pki-hierarchy-architecture.webp`
- `geil-security-zone-model.webp`
- `geil-opnsense-vlan-topology.webp`
- `geil-proxmox-bridge-topology.webp`

When local tooling cannot export WebP, commit the editable `.svg` source and a prompt file under `docs/assets/diagram-prompts/`, then track WebP generation as a follow-up task.

## Readability requirements

| Requirement | Minimum Standard |
|---|---|
| Canvas | 16:9, recommended 1600x900 or larger |
| Minimum readable font size | Equivalent to 18px or larger at 1600x900 |
| Heading font size | Equivalent to 34px or larger at 1600x900 |
| Maximum text per node | 3 short lines, 28 characters per line where practical |
| Maximum nodes per visual | Prefer fewer than 12 primary nodes |
| Branching | Split diagrams when a node needs more than 5 outgoing branches |
| Dark mode | Must remain readable on MkDocs Material slate theme |

## Alt text requirements

Every image reference must include meaningful alt text. The alt text must describe the architecture purpose, not merely repeat the filename.

Good:

```markdown
![GNTECH security zone model showing HQ-FW01 as the policy boundary between management, infrastructure, user, guest, DMZ, backup, and hypervisor zones](../assets/diagrams/geil-security-zone-model.svg)
```

Bad:

```markdown
![diagram](../assets/diagrams/geil-security-zone-model.svg)
```

## Source and export requirements

Where possible, complex diagrams must have both a source file and an exported image.

| Asset | Purpose |
|---|---|
| Source file | Maintained by authors for future edits |
| PNG/WebP export | Embedded in MkDocs pages |
| SVG export | Used when crisp text and scaling are required |

Do not commit generated screenshots from local desktops unless they are sanitized, intentional architecture visuals.

## Accessibility and readability checks

Before publishing a complex diagram:

1. View the page at normal MkDocs content width.
2. Confirm labels are readable without browser zoom.
3. Confirm the diagram is understandable in dark mode.
4. Confirm no secrets, tenant IDs, API keys, passwords, serial numbers, or private addressing outside the approved environment specification are exposed.
5. Confirm canonical values match [Environment Specification](../project/environment-specification.md).
6. Confirm the asset path is stable and relative links pass `mkdocs build --strict`.

## Existing diagram replacement candidates

The following existing Mermaid diagrams should be prioritized for replacement with dedicated visual assets because they are likely to become crowded or unreadable at normal page width.

| Priority | Document | Diagram / Section | Recommended Asset |
|---:|---|---|---|
| P0 | `docs/architecture/enterprise-lab-network-hld.md` | Security zone model | `docs/assets/diagrams/enterprise-lab-network-hld/security-zone-model.webp` |
| P0 | `docs/architecture/enterprise-lab-identity-hld.md` | PKI hierarchy | `docs/assets/diagrams/enterprise-lab-identity-hld/pki-hierarchy.webp` |
| P0 | `docs/project/epic-release-architecture.md` | Document dependency graph | `docs/assets/diagrams/epic-release-architecture/document-dependency-graph.webp` |
| P1 | `docs/architecture/enterprise-reference-architecture.md` | Integrated target architecture and layer diagrams | `docs/assets/diagrams/enterprise-reference-architecture/integrated-target-architecture.webp` |
| P1 | `docs/architecture/enterprise-capability-model.md` | Capability dependency overview | `docs/assets/diagrams/enterprise-capability-model/capability-dependency-map.webp` |
| P1 | `docs/architecture/enterprise-lab-blueprint.md` | Target enterprise overview and physical topology | `docs/assets/diagrams/enterprise-lab-blueprint/target-enterprise-overview.webp` |
| P1 | `docs/platform/opnsense-hq-foundation-lld.md` | OPNsense interface and VLAN topology | `docs/assets/diagrams/opnsense-hq-foundation-lld/interface-vlan-topology.webp` |
| P1 | `docs/platform/proxmox-hq-foundation-lld.md` | Proxmox bridge topology | `docs/assets/diagrams/proxmox-hq-foundation-lld/proxmox-bridge-topology.webp` |
| P2 | `docs/architecture/implementation-philosophy.md` | Stage evolution diagrams | Dedicated stage-by-stage visual set |
| P2 | `docs/architecture/enterprise-lab-operations-hld.md` | Monitoring and disaster recovery architecture | Focused operations visual assets |

## Migration approach for existing diagrams

1. Keep the existing Mermaid diagram until the replacement visual is committed.
2. Create the dedicated asset under `docs/assets/diagrams/<document-slug>/`.
3. Add the image asset above the simplified Mermaid diagram.
4. Reduce the Mermaid diagram to a simple workflow or dependency view.
5. Add an Adaptation Note if the visual includes GNTECH canonical values.
6. Run `mkdocs build --strict`.
7. Update the changelog and document index if a new visual standard or visual asset page is created.

## Related documents

- [Documentation Standard](documentation-standard.md)
- [Environment Specification](../project/environment-specification.md)
- [Enterprise Lab Blueprint HLD](../architecture/enterprise-lab-blueprint.md)
- [Enterprise Lab Network HLD](../architecture/enterprise-lab-network-hld.md)
- [Enterprise Lab Identity HLD](../architecture/enterprise-lab-identity-hld.md)
- [Epic and Release Architecture](../project/epic-release-architecture.md)
