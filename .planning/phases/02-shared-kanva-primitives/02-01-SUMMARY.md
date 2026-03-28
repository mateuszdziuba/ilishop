---
phase: 02-shared-kanva-primitives
plan: "01"
subsystem: snippets
tags: [kanva, design-tokens, css-custom-properties, snippets, primitives]
dependency_graph:
  requires: []
  provides:
    - snippets/theme-styles-variables.liquid (Kanva :root tokens)
    - snippets/kanva-heading.liquid
    - snippets/kanva-badge.liquid
    - snippets/kanva-card.liquid
  affects:
    - All downstream Kanva sections in Plans 02 and 03
tech_stack:
  added: []
  patterns:
    - CSS custom properties via --kanva-* prefix for token isolation
    - Liquid {%- doc -%} blocks for parameter documentation
    - render tag (not include) for snippet composition
key_files:
  created:
    - snippets/kanva-heading.liquid
    - snippets/kanva-badge.liquid
    - snippets/kanva-card.liquid
  modified:
    - snippets/theme-styles-variables.liquid
decisions:
  - "Kanva tokens placed in existing :root block in theme-styles-variables.liquid (not a new snippet) to avoid Shopify deduplication issues"
  - "All token names use --kanva- prefix to isolate from Horizon's --color-* scheme system"
  - "kanva-card scope limited to editorial cards; product/blog card restyling deferred to Phases 4/6"
metrics:
  duration_minutes: 12
  completed_date: "2026-03-28"
  tasks_completed: 2
  files_modified: 4
---

# Phase 02 Plan 01: Shared Kanva Primitives Summary

10 Kanva CSS design tokens added to global `:root` block and three shared rendering snippets created (kanva-heading, kanva-badge, kanva-card) that all downstream Kanva sections consume via `var(--kanva-*)` references.

## Tasks Completed

| Task | Description | Commit | Files |
|------|-------------|--------|-------|
| 1 | Add Kanva design tokens to theme-styles-variables.liquid | 471f10c | snippets/theme-styles-variables.liquid |
| 2 | Create kanva-heading, kanva-badge, kanva-card snippets | a0320cb | snippets/kanva-heading.liquid, snippets/kanva-badge.liquid, snippets/kanva-card.liquid |

## What Was Built

### Task 1: Kanva Design Tokens

Added 10 CSS custom properties to the existing `:root` block in `snippets/theme-styles-variables.liquid` immediately before the closing `}`:

- Color tokens: `--kanva-cream`, `--kanva-sage`, `--kanva-border`, `--kanva-badge-bg`, `--kanva-text-primary`, `--kanva-text-muted`
- Spacing/radius tokens: `--kanva-card-radius`, `--kanva-btn-radius`, `--kanva-pill-radius`, `--kanva-section-pad`

### Task 2: Three Shared Snippets

**kanva-heading.liquid** — Three-tier heading block (label + heading + subtext) with configurable `alignment` and `heading_level` parameters. Uses `clamp(32px, 4vw, 52px)` fluid type for the title.

**kanva-badge.liquid** — Pill-shaped tag rendering a `<span>` or `<a>` depending on whether `url` is provided. Uses `--kanva-badge-bg` and `--kanva-pill-radius` tokens.

**kanva-card.liquid** — Editorial card wrapper with hover-zoom image (`transform scale(1.05)`), absolute-positioned badge slot, and body text area. Renders `kanva-badge` via `{% render %}` composition. Uses `--kanva-card-radius` and `--kanva-cream` tokens.

## Verification

- `grep -c "\-\-kanva-" snippets/theme-styles-variables.liquid` returns 10
- All three snippet files exist with correct HTML structure and CSS
- All CSS in snippets uses `var(--kanva-*)` — zero hardcoded hex colors in snippet CSS rules
- `sh scripts/phase1-regression-gate.sh` exits 0 (298 files, only pre-existing 2 baseline errors)

## Deviations from Plan

None — plan executed exactly as written.

## Known Stubs

None — all tokens are real values, all snippets render actual HTML structure with real CSS. No placeholder data or TODO markers.

## Self-Check: PASSED

- snippets/theme-styles-variables.liquid: contains 10 --kanva-* tokens
- snippets/kanva-heading.liquid: created, contains kanva-heading__label, kanva-heading__title, kanva-heading__subtext
- snippets/kanva-badge.liquid: created, contains kanva-badge, var(--kanva-badge-bg), var(--kanva-pill-radius)
- snippets/kanva-card.liquid: created, contains kanva-card__media, kanva-card__img, kanva-card__badge, transform scale(1.05)
- Commit 471f10c: feat(02-01): add Kanva design tokens to global :root block
- Commit a0320cb: feat(02-01): create shared kanva-heading, kanva-badge, kanva-card snippets
