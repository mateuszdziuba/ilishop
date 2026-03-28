# Horizon Kanva Theme Rebuild

## What This Is

This project extends the existing Horizon Shopify theme in this repository into a custom Kanva-style storefront. The first milestone is a reusable, section-driven implementation for the landing page, collections page, about page, and blog pages that uses Horizon as the primary architectural and component baseline, while using `theme-to-clone/` only as the visual and page-structure target, with merchant-friendly theme editor controls and separate desktop/mobile presentation settings where layout art direction needs to diverge.

## Core Value

Merchants can recreate and maintain the Kanva-inspired storefront inside Shopify's theme editor without hardcoded page layouts or mobile compromises.

## Requirements

### Validated

- ✓ Existing Shopify OS 2.0 theme foundation with Liquid layouts, JSON templates, sections, blocks, snippets, and theme settings is already present — existing
- ✓ Existing storefront supports core page routing for home, collection, blog, article, product, cart, search, and static pages through `templates/*.json` and `layout/theme.liquid` — existing
- ✓ Existing theme editor customization model already exists through `config/settings_schema.json`, section schema, and JSON template composition — existing
- ✓ Expose section settings that let merchants configure separate mobile and desktop assets and positioning where needed — Validated in Phase 1: Stabilization and Editor Contract (EDIT-02, EDIT-03, EDIT-05)
- ✓ Preserve Shopify theme-editor usability so page sections can be reordered, reused, and extended without editing code — Validated in Phase 1: Stabilization and Editor Contract (QUAL-03)

### Active

- [ ] Recreate the Kanva-inspired landing page from `theme-to-clone/index.html` using Horizon-native sections, blocks, and snippets
- [ ] Recreate the collections browsing experience in Shopify for collection/list-collections flows by adapting or extending Horizon's more modern collection architecture and reusable primitives
- [ ] Recreate the about page from `theme-to-clone/about.html` using modular Horizon-aligned sections instead of one-off page markup
- [ ] Recreate the blog experience from `theme-to-clone/blog.html` and related reference files using reusable editorial components built on Horizon patterns
- [ ] Convert repeated reference patterns into maintainable Shopify components, preferring existing Horizon abstractions first, then adding theme blocks in `blocks/` where merchant customization is required and snippets for shared rendering logic
- [ ] Expose section settings that let merchants configure separate mobile and desktop assets and positioning where needed, including custom background images and layout positioning controls (partially validated in Phase 1 — responsive contract and hero proof; full validation pending across all Kanva sections)
- [ ] Preserve Shopify theme-editor usability so page sections can be reordered, reused, and extended without editing code (partially validated in Phase 1 — contract and regression gate in place; full validation pending across all new sections)

### Out of Scope

- Checkout customization — Shopify checkout is outside normal theme scope and not required for this storefront rebuild
- Full redesign of product, cart, account, search, FAQ, contact, favorites, and legal pages in the first milestone — requested priority is landing, collections, about, and blogs first
- Theme Store packaging/compliance work — this project is focused on a client-quality custom theme build, not Theme Store submission

## Context

The repository is an existing Horizon Shopify theme with a modern OS 2.0 structure and a large reusable section/block/snippet system already in place. That Horizon implementation is the primary reference for architecture, editor patterns, and reusable storefront primitives. The `theme-to-clone/` directory contains the visual and structural target for the Kanva storefront, including page-level HTML, a shared CSS file, and `kanva-docs.md` describing the intended site map and design system. The work needs to be executed as a senior Shopify theme build: keep Horizon's stronger architecture where possible, map Kanva's layout language into reusable Shopify components, and avoid copying static HTML into hardcoded templates when an existing Horizon abstraction or a new reusable section/block is the right answer.

## Constraints

- **Tech stack**: Shopify Online Store 2.0 theme architecture — implementation must stay within Liquid, JSON templates, sections, blocks, snippets, assets, and theme settings because this repository is a Shopify theme
- **Implementation baseline**: Horizon is the primary technical reference — prefer adapting its more modern architecture, editor patterns, and reusable storefront primitives over importing static reference markup directly
- **Reference fidelity**: `theme-to-clone/` is the visual and content structure reference — the implemented pages should closely match the intended Kanva experience while still being maintainable inside Horizon
- **Theme editor**: Merchant customization must remain first-class — settings need to support desktop/mobile variants for imagery and positioning where art direction differs by breakpoint
- **Reuse**: Shared UI patterns should become reusable theme components — repeated page patterns should not be duplicated across page-specific files
- **Delivery order**: Landing page, collections pages, about page, then blog pages — planning and execution should respect this order unless dependencies force shared foundational work first

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Build on Horizon as the primary implementation baseline | Horizon already contains a modern OS 2.0 architecture, theme editor wiring, and reusable primitives that should be reused before inventing parallel systems | — Pending |
| Treat `theme-to-clone/` as the visual and page reference source, not the implementation baseline | The provided reference files define target layouts and Kanva patterns, but Horizon should drive the technical implementation | — Pending |
| Prefer theme blocks for merchant-configurable reusable pieces and snippets for pure rendering helpers | Shopify theme blocks surface settings in the editor, while snippets keep repeated Liquid logic maintainable | — Pending |
| Add explicit mobile and desktop controls where art direction differs | The requested pages need different images and positioning per breakpoint, which should be editable without code changes | — Pending |
| Keep first milestone scope focused on home, collections, about, and blog | The user explicitly prioritized these pages in order, so roadmap phases should follow that sequence | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `$gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `$gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-03-28 after Phase 1 completion — responsive editor contract locked, regression gate in place*
