---
phase: 02
slug: shared-kanva-primitives
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-28
---

# Phase 02 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Shopify Theme Check (via `shopify theme check`) |
| **Config file** | `.theme-check.yml` (if exists) or default |
| **Quick run command** | `shopify theme check --fail-level error` |
| **Full suite command** | `sh scripts/phase1-regression-gate.sh` |
| **Estimated runtime** | ~15 seconds |

---

## Sampling Rate

- **After every task commit:** Run `shopify theme check --fail-level error`
- **After every plan wave:** Run `sh scripts/phase1-regression-gate.sh`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 02-01-01 | 01 | 0 | COMP-02 | lint | `shopify theme check --fail-level error` | ✅ | ⬜ pending |
| 02-01-02 | 01 | 0 | COMP-02 | lint | `shopify theme check --fail-level error` | ✅ | ⬜ pending |
| 02-02-01 | 02 | 1 | COMP-01 | lint + grep | `shopify theme check --fail-level error` | ✅ | ⬜ pending |
| 02-02-02 | 02 | 1 | COMP-01 | lint + grep | `shopify theme check --fail-level error` | ✅ | ⬜ pending |
| 02-03-01 | 03 | 1 | EDIT-01, EDIT-04 | lint + grep | `shopify theme check --fail-level error` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] Kanva CSS custom properties added to `snippets/theme-styles-variables.liquid`
- [ ] Shared snippets `kanva-heading.liquid`, `kanva-badge.liquid`, `kanva-card.liquid` created

*These are prerequisites for all subsequent section work.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Section reorder/duplicate/remove in editor | EDIT-04 | Requires live Shopify theme editor | Open editor, add new Kanva section, reorder, duplicate, remove — verify no broken state |
| Consistent Kanva heading/spacing across sections | COMP-02 | Visual consistency check | Compare heading treatments across feature strip, testimonial, newsletter sections |
| Mobile responsive behavior | COMP-02 | Requires live browser viewport testing | Resize browser through breakpoints, verify Kanva sections adapt correctly |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
