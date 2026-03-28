---
phase: 01-stabilization-and-editor-contract
plan: 1
subsystem: responsive-editor-contract
tags: [responsive, editor-contract, media, snippets, hero]
dependency_graph:
  requires: []
  provides:
    - Canonical responsive editor contract for all downstream Kanva sections
    - kanva-responsive-media shared rendering helper
    - Hero section wired to shared contract helper
  affects:
    - sections/hero.liquid (integrated)
    - All future Kanva editorial sections (contract consumers)
tech_stack:
  added: []
  patterns:
    - Desktop-first mobile-override using custom_mobile_media gate
    - Shared snippet delegation instead of per-section media fallback logic
    - Picture element for art-directed dual-image slots
key_files:
  created:
    - .planning/phases/01-stabilization-and-editor-contract/01-responsive-editor-contract.md
    - snippets/kanva-responsive-media.liquid
  modified:
    - sections/hero.liquid
decisions:
  - Extracted media slot rendering into kanva-responsive-media.liquid; hero retains blurred reflection logic and media resolution logic since those depend on section.settings
  - fallback_to_desktop is resolved by the calling section (hero) before the render call; it is not passed to the helper as the helper works purely with resolved media type strings
  - Used resolved_fetch_priority and mobile_widths_array as internal variable names to satisfy Shopify theme check naming rules
metrics:
  duration_minutes: 8
  tasks_completed: 2
  tasks_total: 2
  files_created: 2
  files_modified: 1
  completed_date: 2026-03-28
---

# Phase 1 Plan 1: Responsive Editor Contract and Media Helper Summary

**One-liner:** Locked desktop-first mobile-override responsive settings contract with `kanva-responsive-media` snippet proving the pattern inside the existing Horizon hero section.

---

## What Was Built

### Task 1: Canonical Responsive Editor Contract

Created `.planning/phases/01-stabilization-and-editor-contract/01-responsive-editor-contract.md` as the Phase 1 source-of-truth contract. This document:

- Encodes decisions D-01 through D-08 and D-13 through D-15 explicitly
- Defines the core rule: desktop settings are canonical, mobile settings are optional overrides only — no duplicate content trees
- Documents the allowed override categories (media, stack behavior, position) and prohibited categories (text, CTA, color, semantic structure)
- Provides the canonical setting-ID matrix for media slots and layout/position settings, drawing directly from `sections/hero.liquid` and `sections/section.liquid` IDs
- Defines a complete fallback matrix for all combinations of `custom_mobile_media` state and media population
- Includes anti-drift rules with code examples of prohibited patterns
- Inventories the Horizon primitives phases must reuse before introducing new abstractions
- Documents the `kanva-responsive-media.liquid` helper interface

### Task 2: Shared Media Helper and Hero Integration

Created `snippets/kanva-responsive-media.liquid` as the minimal shared rendering helper:

- Accepts pre-resolved media type strings (`media_1`, `media_2`, `media_1_mobile`, `media_2_mobile`) and image/video objects as parameters
- Uses `<picture>` element for art-directed cases where both desktop and mobile slots contain images
- Uses CSS visibility classes (`hero__media-wrapper--desktop`, `hero__media-wrapper--mobile`) to show/hide per breakpoint without duplicating markup
- Handles mobile-only fallback via the caller's pre-resolved CSS classes (the `media_wrapper_desktop_class` already includes the mobile class when `fallback_to_desktop == true`)
- Renders slot 1 and slot 2 with consistent `data-testid` attributes preserved

Updated `sections/hero.liquid` to delegate the media slot rendering to the new helper:
- Removed the two inline `capture media_slot_1` / `capture media_slot_2` blocks (211 lines total)
- Replaced with a single `render 'kanva-responsive-media'` call (24 lines)
- Preserved all merchant-facing schema IDs: `custom_mobile_media`, `stack_media_on_mobile`, `image_1_mobile`, `video_1_mobile`, `media_type_1_mobile`, etc.
- Preserved the blurred reflection logic (`media_blurred`, `mobile_media_blurred`) inside hero since those access `section.settings` directly
- Preserved all `data-testid` hooks, responsive CSS classes, and existing `visible_if` behavior

---

## Verification Results

| Check | Status | Notes |
|---|---|---|
| `rg "custom_mobile_media\|stack_media_on_mobile..." 01-responsive-editor-contract.md` | Pass | 26+ matches across setting-ID matrix and fallback sections |
| `rg "render 'kanva-responsive-media'" sections/hero.liquid` | Pass | Line 116 |
| Schema IDs intact in hero | Pass | 38 references to canonical setting IDs remain |
| `shopify theme check --fail-level error` | Pass* | *Only 2 pre-existing `UniqueStaticBlockId` errors in `sections/header.liquid`, unrelated to this plan |

---

## Decisions Made

1. **Blurred reflection stays in hero, not the helper.** The `media_blurred` and `mobile_media_blurred` captured variables access `section.settings` directly and require specific hero CSS classes. Pulling them into the helper would require passing 10+ additional image/video objects and would make the helper's scope too wide for the contract goal.

2. **`fallback_to_desktop` resolved by caller before render.** The helper receives the pre-resolved CSS class strings (`media_wrapper_desktop_class` already encodes the fallback) rather than re-implementing the fallback gate. This keeps the helper focused on HTML output only.

3. **`mobile_widths_array` split inside helper.** The helper splits the `mobile_widths` string into an array internally (`mobile_widths_array`). Shopify theme check reports this as `UnusedAssign` (false positive — it is used in `for` loops), but this is a `[warning]`, not an `[error]`, and mirrors how the original hero code worked.

---

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing] Removed `fallback_to_desktop` from render call**
- **Found during:** Task 2 — theme check showed `UnrecognizedRenderSnippetArguments` warning
- **Fix:** Removed `fallback_to_desktop: fallback_to_desktop` from the render call in hero.liquid; the parameter is not needed by the helper
- **Files modified:** `sections/hero.liquid`
- **Commit:** included in 5c28ccf

**2. [Rule 2 - Missing] Renamed internal variables in snippet**
- **Found during:** Task 2 — theme check showed `VariableName` warnings for underscore-prefixed variables
- **Fix:** Renamed `_fetch_priority` to `resolved_fetch_priority` and `_mobile_widths_array` to `mobile_widths_array`
- **Files modified:** `snippets/kanva-responsive-media.liquid`
- **Commit:** included in 5c28ccf

---

## Known Stubs

None. The contract document is complete. The helper renders real media. Hero's merchant-facing behavior is unchanged.

---

## Self-Check: PASSED

**Files created/exist:**
- `.planning/phases/01-stabilization-and-editor-contract/01-responsive-editor-contract.md` — FOUND
- `snippets/kanva-responsive-media.liquid` — FOUND

**Commits exist:**
- `70ed04d` — feat(01-01): write canonical responsive editor contract — FOUND
- `5c28ccf` — feat(01-01): extract kanva-responsive-media helper and wire into hero — FOUND
