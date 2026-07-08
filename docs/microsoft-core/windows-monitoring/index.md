---
title: Windows Monitoring
document_id: GEIL-MSC-WINMON-INDEX
owner: Infrastructure Engineering
status: Draft
version: 1.0
last_reviewed: 2026-07-08
review_cycle: Quarterly
classification: Internal Confidential
---

# Windows Monitoring

## Purpose

This section contains Microsoft Core Windows monitoring and event collection guidance.

Windows monitoring starts with native Windows Event Forwarding and a dedicated Windows Event Collector before future integrations such as Loki, Grafana, Sentinel, Splunk, Elastic, or SIEM platforms are introduced.

## Documents

| Order | Document | Purpose |
|---:|---|---|
| 1 | [Windows Event Forwarding and Collector Baseline](windows-event-forwarding-baseline.md) | Designs the pilot Windows Event Forwarding architecture using dedicated collector `HQ-WEC01`. |

## Source of truth

Use the [Enterprise Implementation Roadmap](../../project/enterprise-implementation-roadmap.md) for high-level phase navigation and the [Network and Active Directory Services Matrix](../../project/network-and-ad-services-matrix.md) for canonical VLANs, host names, management ports, and firewall expectations.
