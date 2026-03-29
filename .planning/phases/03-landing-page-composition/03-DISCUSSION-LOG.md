# Phase 3: Landing Page Composition - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-03-29
**Phase:** 03-landing-page-composition
**Areas discussed:** Hero carousel approach, Product showcasing strategy, Bento grid and marquee patterns, Template wiring strategy

---

## Hero carousel approach

| Option | Description | Selected |
|--------|-------------|----------|
| Full carousel | New kanva-hero section with multi-slide support, dot navigation, auto-advance, product preview rail | ✓ |
| Simplified multi-image hero | Adapt Horizon's existing hero with Kanva styling, no carousel JS | |
| Horizon hero + slideshow section | Keep Horizon hero, add separate lightweight slideshow section | |

**User's choice:** Full carousel
**Notes:** None — direct selection of recommended approach

### Follow-up: Slide configuration

| Option | Description | Selected |
|--------|-------------|----------|
| Block-based slides | Each slide is a block with image, heading, subtitle, CTA. Up to 5 slides, reorderable | ✓ |
| Fixed 3-slide settings | Three predefined slide slots in schema | |

**User's choice:** Block-based slides

### Follow-up: Product preview rail

| Option | Description | Selected |
|--------|-------------|----------|
| Include it | Product thumbnail strip below hero, linking to merchant-selected collection | ✓ |
| Skip for v1 | Deliver carousel without preview rail | |

**User's choice:** Include it

---

## Product showcasing strategy

| Option | Description | Selected |
|--------|-------------|----------|
| Multiple product-list sections | One Horizon product-list per collection, stacked vertically with heading + View all | ✓ |
| Single product-list + collection-links | One product-list with collection-links section for browsing | |
| Custom tabbed section | New kanva-product-tabs with JS tab switching | |

**User's choice:** Multiple product-list sections
**Notes:** None — direct selection. Avoids custom JS, stays Shopify-native.

---

## Bento grid

| Option | Description | Selected |
|--------|-------------|----------|
| Build new bento section | New kanva-bento-grid with block types for each card variant | ✓ |
| Replace with simpler sections | Skip bento, use media-with-content + text sections | |
| Defer to v2 | Skip entirely for Phase 3 | |

**User's choice:** Build new bento section

## Marquee

| Option | Description | Selected |
|--------|-------------|----------|
| Build it | New kanva-marquee section with CSS animation | ✓ |
| Skip for v1 | Omit marquee entirely | |

**User's choice:** Build it

---

## Template wiring strategy

| Option | Description | Selected |
|--------|-------------|----------|
| Full default template | Complete index.json with all sections pre-wired and defaults | ✓ |
| Minimal template + editor guide | Wire only essentials, document the rest | |

**User's choice:** Full default template

### Follow-up: Eco section

| Option | Description | Selected |
|--------|-------------|----------|
| Media-with-content preset | Reuse existing section with Kanva Story Row preset | ✓ |
| New kanva-eco section | Dedicated section with built-in checklist | |

**User's choice:** Media-with-content preset

---

## Claude's Discretion

- Carousel animation timing and easing
- Product preview rail thumbnail count and sizing
- Bento grid mobile stacking strategy
- Marquee scroll speed and text sizing
- Default placeholder content for all sections
- Whether kanva-hero uses vanilla JS or CSS-only carousel

## Deferred Ideas

- Custom animated carousel with synchronized transitions (POLI-01, v2)
- Live Instagram/social feed integration (POLI-02, v2)
- Category tab filtering UI for products — replaced with stacked product-lists
