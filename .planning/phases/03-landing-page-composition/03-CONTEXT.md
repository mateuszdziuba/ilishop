# Phase 3: Landing Page Composition - Context

**Gathered:** 2026-03-29
**Status:** Ready for planning

<domain>
## Phase Boundary

Assemble the Kanva homepage from reusable sections and real Shopify content links. Shoppers land on a fully composed Kanva-style homepage with hero, trust strip, product showcasing, editorial content, testimonials, newsletter, and social proof — all wired into `templates/index.json` with sensible defaults. This phase creates new sections where no Horizon equivalent exists and composes the full homepage template from Phase 2 primitives plus new and adapted Horizon sections.

</domain>

<decisions>
## Implementation Decisions

### Hero carousel
- **D-01:** Create a new `kanva-hero` section with multi-slide carousel support, dot navigation, and CSS-driven auto-advance. Do NOT adapt Horizon's existing hero section — the carousel behavior is fundamentally different.
- **D-02:** Each slide is a block with its own image, heading, subtitle, and CTA link. Merchant can add, reorder, duplicate, and remove slides (up to 5) in the theme editor.
- **D-03:** Include a product preview rail at the bottom of the hero — small thumbnail images linking to a merchant-selected collection, with a "View Collection" link. The rail is an optional feature controlled by section settings.
- **D-04:** The hero follows Phase 1's responsive editor contract: desktop-first with optional mobile media overrides per slide.

### Product showcasing
- **D-05:** Use multiple Horizon `product-list` sections stacked vertically — one per collection (e.g., Cleansers, Lotions). No custom tabbed UI or category-filtering JS.
- **D-06:** Each product-list section gets a Kanva-styled header with collection title and "View all" link. Product cards use existing Horizon card rendering with Kanva token overrides where applicable.
- **D-07:** The default template pre-wires two product-list sections; the merchant can add more via the theme editor.

### Bento grid
- **D-08:** Create a new `kanva-bento-grid` section with block types for each card variant: title card, image card, stat/rating card, text card, and accent (navy) card.
- **D-09:** The grid uses CSS Grid with a fixed 3-column asymmetric layout matching the Kanva reference. The bottom row spans the full width for the "Proven Effectiveness" card.
- **D-10:** Merchant can customize text, images, ratings, and bullet lists per card block via the theme editor.

### Marquee
- **D-11:** Create a new `kanva-marquee` section with CSS animation for continuous scrolling text. Merchant can edit the text phrases and separator character/emoji via section settings.
- **D-12:** The marquee is a lightweight section with no JS dependency — pure CSS `@keyframes` animation with duplicated track for seamless loop.

### Eco / story section
- **D-13:** Use the existing `media-with-content.liquid` section with the Kanva Story Row preset for the eco content row. Checklist items render as text blocks within the section's block-based content area.
- **D-14:** No new section needed for eco content — Phase 2's media-with-content adaptation handles this pattern.

### Template composition
- **D-15:** Write a complete `templates/index.json` with all sections pre-wired and populated with sensible Kanva defaults. The merchant gets the full homepage flow on first load.
- **D-16:** Section order in the default template: kanva-hero → kanva-feature-strip → kanva-marquee → product-list (×2) → media-with-content (eco) → kanva-bento-grid → kanva-testimonial → kanva-newsletter → kanva-image-grid.
- **D-17:** All sections use Kanva color schemes (scheme-3 warm cream, scheme-6 dark) and Kanva design tokens from Phase 2 where applicable.

### Claude's Discretion
- Exact carousel animation timing and easing curves
- Product preview rail thumbnail count and sizing
- Bento grid responsive breakpoint behavior (stacking strategy on mobile)
- Marquee scroll speed and text sizing
- Default placeholder content for all sections (product names, hero copy, etc.)
- Whether the kanva-hero uses vanilla JS or a CSS-only carousel approach

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase 1 outputs (contract and helpers)
- `.planning/phases/01-stabilization-and-editor-contract/01-responsive-editor-contract.md` — Canonical responsive settings contract and Horizon primitive inventory
- `snippets/kanva-responsive-media.liquid` — Shared media-rendering helper (new sections MUST use this)

### Phase 2 outputs (shared primitives)
- `.planning/phases/02-shared-kanva-primitives/02-CONTEXT.md` — Decisions D-01 through D-12 on Kanva tokens, section patterns, and snippet architecture
- `snippets/kanva-heading.liquid` — Shared heading snippet for consistent Kanva headings
- `snippets/kanva-badge.liquid` — Shared badge/pill snippet
- `snippets/kanva-card.liquid` — Shared card rendering snippet
- `snippets/theme-styles-variables.liquid` — Kanva design tokens (--kanva-* custom properties)
- `sections/kanva-feature-strip.liquid` — 4-column trust bar (reuse directly)
- `sections/kanva-testimonial.liquid` — Quote testimonial section (reuse directly)
- `sections/kanva-newsletter.liquid` — Email capture section (reuse directly)
- `sections/kanva-image-grid.liquid` — Image grid section (reuse directly)
- `sections/media-with-content.liquid` — Split media/text with Kanva Story Row preset (reuse for eco row)

### Kanva visual reference
- `theme-to-clone/index.html` — Full homepage reference with all section patterns, carousel JS, and layout structure
- `theme-to-clone/kanva-theme.css` — CSS variables, hero carousel styles, bento grid CSS, marquee animation
- `theme-to-clone/kanva-docs.md` — Design system documentation and page breakdown
- `theme-to-clone/kanva-components.html` — Component HTML structure reference

### Horizon sections to reuse
- `sections/hero.liquid` — Reference for Horizon hero patterns (NOT to adapt, but to understand editor conventions)
- `sections/product-list.liquid` — Reuse directly for homepage product showcasing
- `templates/index.json` — Current homepage template (will be replaced with Kanva composition)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `kanva-feature-strip.liquid`: Ready to wire directly into index.json
- `kanva-testimonial.liquid`: Ready to wire directly
- `kanva-newsletter.liquid`: Ready to wire directly
- `kanva-image-grid.liquid`: Ready to wire directly
- `media-with-content.liquid` with Kanva Story Row preset: Ready for eco section
- `product-list.liquid`: Horizon's native featured collection grid — reuse for product showcasing
- `kanva-heading.liquid`, `kanva-badge.liquid`, `kanva-card.liquid`: Available for new sections
- Kanva design tokens (`--kanva-*`): Available in `theme-styles-variables.liquid`

### Established Patterns
- All Kanva sections use `render 'kanva-heading'` for consistent heading treatment
- All sections use `render 'spacing-style'` for configurable padding
- Block-based composition with `for` loops and type guards is the standard pattern
- Sections are placed in "Kanva Editorial" preset category for editor discoverability

### Integration Points
- `templates/index.json`: The primary integration point — all sections wire into this template
- Kanva hero carousel JS needs to live in `assets/` following Horizon's script loading patterns
- Product-list sections connect to real Shopify collections via the `collection` setting

</code_context>

<specifics>
## Specific Ideas

- The hero carousel should closely match the Kanva reference (3 slides, product preview rail with small thumbnails, dot navigation, auto-advance)
- Product showcasing uses stacked Horizon product-list sections rather than a custom tabbed UI — keeps things Shopify-native
- The bento grid asymmetric layout matches the Kanva reference exactly: 3×3 grid with title, images, rating, eco, navy, and wide proven cards
- The marquee uses pure CSS animation — no JS library needed
- The full template is pre-wired so the merchant sees the complete homepage on first load

</specifics>

<deferred>
## Deferred Ideas

- Custom animated homepage carousel with preview rail and synchronized transitions beyond basic CSS (POLI-01, v2)
- Live Instagram/social feed integration (POLI-02, v2)
- Category tab filtering UI for products — replaced with stacked product-lists for v1

</deferred>

---

*Phase: 03-landing-page-composition*
*Context gathered: 2026-03-29*
