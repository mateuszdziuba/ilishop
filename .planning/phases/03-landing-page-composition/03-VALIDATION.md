---
phase: 03
slug: landing-page-composition
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-29
---

# Phase 03 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | `shopify theme check` (Shopify CLI built-in linter) |
| **Config file** | None — uses default Shopify theme check rules |
| **Quick run command** | `shopify theme check --fail-level error` |
| **Full suite command** | `sh scripts/phase1-regression-gate.sh` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `shopify theme check --fail-level error`
- **After every plan wave:** Run `sh scripts/phase1-regression-gate.sh`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 10 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 03-01-01 | 01 | 1 | HOME-01 | smoke | `shopify theme check --fail-level error` | ❌ W0 | ⬜ pending |
| 03-01-02 | 01 | 1 | HOME-01 | smoke | `shopify theme check --fail-level error` | ❌ W0 | ⬜ pending |
| 03-02-01 | 02 | 1 | HOME-04 | smoke | `shopify theme check --fail-level error` | ❌ W0 | ⬜ pending |
| 03-02-02 | 02 | 1 | HOME-04 | smoke | `shopify theme check --fail-level error` | ❌ W0 | ⬜ pending |
| 03-03-01 | 03 | 2 | HOME-02, HOME-03, HOME-04 | smoke | `shopify theme check --fail-level error` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `sections/kanva-hero.liquid` — covers HOME-01 (new file, created in Wave 1)
- [ ] `sections/kanva-bento-grid.liquid` — covers HOME-04 (new file, created in Wave 1)
- [ ] `sections/kanva-marquee.liquid` — covers HOME-04 (new file, created in Wave 1)
- [ ] `assets/kanva-hero.js` — carousel JS dependency for kanva-hero

*Existing infrastructure (Phase 1 regression gate + shopify theme check) covers all phase requirements.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Hero carousel slides advance | HOME-01 | Visual + interaction behavior | Open homepage, verify slides auto-advance and dot nav works |
| Product preview rail links | HOME-01 | Requires Shopify collection data | Click thumbnails, verify they link to collection |
| Feature strip visible below hero | HOME-02 | Visual positioning | Scroll past hero, feature strip immediately below |
| Product-list shows real products | HOME-03 | Requires Shopify product data | Verify cards render from assigned collection |
| Bento grid layout is asymmetric | HOME-04 | CSS layout visual check | Verify 4-column grid with spanning cards on desktop |
| Marquee scrolls continuously | HOME-04 | CSS animation visual check | Verify text scrolls left-to-right in a loop |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 10s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
