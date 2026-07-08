---
title: Enterprise Reference Architecture
document_id: GEIL-ARCH-ERA-001
owner: Infrastructure Engineering
status: Approved
version: 1.0
last_reviewed: 2026-06-29
review_cycle: Quarterly
classification: Internal Confidential
---

# Enterprise Reference Architecture

## Document Control

| Field | Value |
|---|---|
| Document ID | GEIL-ARCH-ERA-001 |
| Owner | Infrastructure Engineering |
| Status | Approved |
| Version | 1.0 |
| Last Reviewed | 2026-06-29 |
| Review Cycle | Quarterly |
| Classification | Internal Confidential |

## Purpose

This document defines the strategic target architecture for the final GEIL multinational environment. It is intentionally technology-neutral at the capability layer while acknowledging current GNTECH implementation choices documented in the [Environment Specification](../../project/environment-specification.md).

This is not an implementation guide. It is the architectural frame that future implementation guides must support.

## Architecture context

GEIL's final architecture is a layered enterprise platform. Each layer exposes capabilities to the layers above and consumes capabilities from the layers below.

## Business Layer

```mermaid
flowchart LR
    Strategy[Business Strategy]
    Risk[Risk Management]
    Workforce[Workforce Productivity]
    Growth[Regional and Multinational Growth]
    Continuity[Business Continuity]
    Strategy --> Growth
    Risk --> Continuity
    Workforce --> Growth
```

Purpose: define why infrastructure exists. The business layer drives requirements for security, availability, compliance, collaboration, and scale.

## Application Layer

```mermaid
flowchart LR
    SaaS[Enterprise SaaS]
    Internal[Internal Services]
    Docs[Engineering Documentation]
    Admin[Administration Portals]
    Collaboration[Collaboration Workloads]
    SaaS --> Collaboration
    Internal --> Admin
    Docs --> Admin
```

Purpose: provide applications and services consumed by GNTECH users and administrators.

## Identity Layer

```mermaid
flowchart TD
    HR[Authoritative Personnel Process]
    AD[Enterprise Directory Capability]
    CloudID[Cloud Identity Capability]
    Priv[Privileged Access Capability]
    DeviceID[Device Identity]
    ServiceID[Service Identity]
    HR --> AD
    AD --> CloudID
    AD --> Priv
    CloudID --> DeviceID
    AD --> ServiceID
```

Purpose: establish the authoritative identity, authentication, authorization, and administrative boundary model.

## Network Layer

```mermaid
flowchart TD
    WAN[WAN and Internet Edge]
    Segmentation[VLAN and Security Segmentation]
    Routing[Routing and Firewall Policy]
    DNS[Name Resolution]
    Remote[Remote and Partner Access]
    WAN --> Routing
    Routing --> Segmentation
    Segmentation --> DNS
    Remote --> Routing
```

Purpose: connect users, services, sites, and cloud platforms with segmentation and controlled access.

## Security Layer

```mermaid
flowchart TD
    ZeroTrust[Zero Trust Policy]
    LeastPrivilege[Least Privilege]
    Detection[Detection and Response]
    Trust[PKI and Device Trust]
    DataProtection[Data Protection]
    ZeroTrust --> LeastPrivilege
    Trust --> ZeroTrust
    LeastPrivilege --> Detection
    DataProtection --> Detection
```

Purpose: enforce protection across identity, device, network, workload, data, and operations.

## Platform Layer

```mermaid
flowchart TD
    Compute[Compute Platform]
    Storage[Storage Platform]
    Virtualization[Virtualization Capability]
    ServerOS[Server Operating Environment]
    Management[Management Plane]
    Compute --> Virtualization
    Virtualization --> ServerOS
    Storage --> Virtualization
    Management --> Compute
```

Purpose: provide stable compute and storage capacity for enterprise services.

## Cloud Layer

```mermaid
flowchart TD
    Tenant[Cloud Tenant]
    CloudIdentity[Cloud Identity]
    DeviceMgmt[Cloud Device Management]
    SaaS[Cloud Productivity Services]
    CloudSecurity[Cloud Security Services]
    Tenant --> CloudIdentity
    CloudIdentity --> DeviceMgmt
    CloudIdentity --> SaaS
    CloudSecurity --> CloudIdentity
    CloudSecurity --> DeviceMgmt
```

Purpose: integrate Microsoft 365, cloud identity, endpoint management, and cloud security into the enterprise architecture.

## Operations Layer

```mermaid
flowchart TD
    Monitoring[Monitoring and Alerting]
    Backup[Backup Operations]
    Change[Change Control]
    Incident[Incident Response]
    Problem[Problem Management]
    Monitoring --> Incident
    Change --> Monitoring
    Backup --> Incident
    Incident --> Problem
```

Purpose: operate the environment predictably with evidence, response paths, and continuous improvement.

## Automation Layer

```mermaid
flowchart TD
    Source[Source Control]
    Scripts[Automation Scripts]
    Templates[Configuration Templates]
    Validation[Validation Automation]
    Pipeline[Future CI/CD]
    Source --> Scripts
    Source --> Templates
    Scripts --> Validation
    Templates --> Validation
    Validation --> Pipeline
```

Purpose: make infrastructure changes repeatable, reviewable, and testable.

## Recovery Layer

```mermaid
flowchart TD
    BackupData[Protected Data]
    Config[Configuration Backups]
    IdentityRecovery[Identity Recovery]
    SiteRecovery[Site Recovery]
    Exercises[Recovery Exercises]
    BackupData --> IdentityRecovery
    Config --> SiteRecovery
    IdentityRecovery --> Exercises
    SiteRecovery --> Exercises
```

Purpose: restore enterprise capabilities after outage, corruption, operator error, or compromise.

## Readable visual asset: Enterprise Reference Architecture

This visual provides a readable architecture-layer view for normal MkDocs page width. It groups business, identity, network/security, platform/cloud, and operations/recovery capabilities without compressing every layer into a single complex Mermaid hierarchy.

![GEIL enterprise reference architecture showing business and application, identity and access, network and security, platform and cloud, and operations and recovery capability layers](../../assets/diagrams/geil-enterprise-reference-architecture.svg)

!!! note "Adaptation"

    This visual includes GNTECH identity anchors `corp.gntech.me` and `gntech.me`. Organizations adapting this model should preserve the capability layering while replacing canonical environment values in the Environment Specification.


## Integrated target architecture

```mermaid
flowchart TD
    B[Business Layer]
    A[Application Layer]
    I[Identity Layer]
    N[Network Layer]
    S[Security Layer]
    P[Platform Layer]
    C[Cloud Layer]
    O[Operations Layer]
    AU[Automation Layer]
    R[Recovery Layer]

    B --> A
    A --> I
    I --> S
    N --> S
    S --> P
    S --> C
    P --> A
    C --> A
    O --> B
    O --> S
    AU --> P
    AU --> C
    AU --> O
    R --> B
    R --> I
    R --> P
```

## Multinational target characteristics

| Characteristic | Target State |
|---|---|
| Identity | Central governance with regional delegation and emergency recovery paths. |
| Network | Regional segmentation, controlled WAN/cloud connectivity, and explicit trust boundaries. |
| Security | Zero Trust controls, privileged access isolation, monitoring, and evidence-backed exceptions. |
| Operations | Regional operations with central standards, shared telemetry, and defined escalation. |
| Recovery | Tested recovery for identity, network, cloud administration, documentation, and core services. |
| Automation | Source-controlled automation and validation for repeatable regional deployments. |

## Cross-references

- [GEIL Master Plan](../../project/master-plan.md)
- [Enterprise Capability Model](enterprise-capability-model.md)
- [Architecture Principles](architecture-principles.md)
- [Implementation Philosophy](implementation-philosophy.md)
- [Technology Selection Matrix](technology-selection-matrix.md)
