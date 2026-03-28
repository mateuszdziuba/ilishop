# Phase 2: Shared Kanva Primitives - Context

**Gathered:** 2026-03-28
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 2 delivers the reusable Kanva component layer that page phases (3–6) will assemble from. It builds standalone editorial sections, shared rendering snippets, and consistent Kanva styling treatments on top of the Horizon architecture stabilized in Phase 1. It does NOT compose full pages — that begins in Phase 3.

</domain>

<decisions>
## Implementation Decisions

### Kanva styling integration
- **D-01:** Extend Horizon's existing theme settings and CSS custom properties with Kanva-specific values rather than creating a parallel design system. Use `config/settings_schema.json` color schemes and `snippets/theme-styles-variables.liquid` as the extension point.
- **D-02:** Kanva design tokens (colors `#F5F3EF`, `#8B9E6E`, `#E8E4DF`; typography weights; spacing `80–120px` section padding; border-radius `8–12px` cards) are added as new CSS custom properties that Kanva sections consume, not as overrides of Horizon's existing tokens.
- **D-03:** Typography follows the Kanva spec (geometric sans-serif, weight 400–500, specific size scale) but integrates through Horizon's existing font-loading and theme settings infrastructure rather than importing fonts independently.

### Section inventory and granularity
- **D-04:** Each distinct Kanva editorial pattern becomes a standalone section file, because Shopify sections are the editor's primary reordering and reuse unit. New sections needed:
  - Feature strip / trust-value bar (4 icon-label columns, cream background)
  - Testimonial block (centered quote, rating, attribution)
  - Newsletter section (email capture with editorial styling)
  - Social / image grid (square image grid for Instagram-style content)
- **D-05:** Patterns that already have a close Horizon equivalent are implemented by adapting the existing section rather than duplicating it:
  - Split media/text rows → adapt `sections/media-with-content.liquid` (432 lines, already has media-width controls and block-based content)
  - Product category rows → reuse `sections/product-list.liquid` with Kanva card styling
  - Collection links → reuse `sections/collection-links.liquid`
- **D-06:** Each new section must use the Phase 1 responsive editor contract (D-01 through D-08 from Phase 1 CONTEXT.md) and the `kanva-responsive-media.liquid` helper where media is involved.

### Horizon adaptation vs new creation
- **D-07:** Adapt existing Horizon sections where the layout model matches the Kanva pattern. Create new sections only where Kanva patterns have no Horizon equivalent. Specifically:
  - `sections/media-with-content.liquid` → Can serve Kanva "story" and "journey" split rows. Adapt with Kanva heading and spacing treatments; do not fork into a new section.
  - Feature strip (4-column icon + label) → No Horizon equivalent. New section.
  - Testimonial (large centered quote) → No Horizon equivalent. New section.
  - Newsletter capture → Footer has a newsletter pattern, but it's locked to the footer. New standalone section for page-body use.
  - Social/image grid → No Horizon equivalent. New section. (v1 uses static images, not live Instagram API — per Out of Scope.)
- **D-08:** When adapting an existing Horizon section, do NOT rename or reorganize its existing schema IDs. Add Kanva-specific styling through CSS classes and new optional settings, preserving backward compatibility with existing template configurations.

### Shared snippet and heading system
- **D-09:** Create Kanva-prefixed snippets for shared heading, badge, and card treatments that consume existing Horizon spacing/style helpers (`snippets/spacing-style.liquid`, `snippets/typography-style.liquid`) as the base.
- **D-10:** Consistent Kanva heading treatment: section label (12–13px uppercase tracking), main heading (40–52px weight 400–500), and optional subtext (15–16px weight 400) should be rendered by a shared heading snippet, not duplicated per section.
- **D-11:** Kanva card treatments (8–12px border-radius, hover zoom on image, category pill badge, structured layout) should be a shared snippet reusable across product cards, blog cards, and any editorial card surface.
- **D-12:** Badge/tag pill styling (pill radius, `#F0EDE8` background, 12px uppercase) should be a standalone snippet since it appears in cards, blog articles, and collection framing.

### Claude's Discretion
- Exact internal structure and Liquid implementation of each new snippet, as long as the shared heading/badge/card treatments are consistent
- Whether Kanva CSS custom properties live in a new `kanva-styles.liquid` snippet or are appended to the existing `theme-styles-variables.liquid`
- Block composition inside adapted sections — how many blocks and which block types each adapted section supports
- Whether the social/image grid uses a generic image block approach or a dedicated grid structure

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase 1 outputs (contract and helpers)
- `.planning/phases/01-stabilization-and-editor-contract/01-responsive-editor-contract.md` — Canonical responsive settings contract, fallback matrix, and Horizon primitive inventory
- `.planning/phases/01-stabilization-and-editor-contract/01-CONTEXT.md` — Phase 1 decisions D-01 through D-15 that constrain Phase 2
- `snippets/kanva-responsive-media.liquid` — Shared media-rendering helper for desktop-first mobile override behavior (Phase 2 sections MUST use this)

### Kanva visual reference
- `theme-to-clone/kanva-docs.md` — Full Kanva design system, page-by-page breakdown, and reusable component reference
- `theme-to-clone/kanva-components.html` — HTML structure reference for each Kanva component
- `theme-to-clone/kanva-theme.css` — CSS variables and base styles for the Kanva design system
- `theme-to-clone/index.html` — Homepage reference (feature strip, testimonials, newsletter, social grid patterns)
- `theme-to-clone/about.html` — About page reference (stats row, story/journey split sections, mission block)

### Horizon sections to adapt
- `sections/media-with-content.liquid` — Split media/text layout section (432 lines); adapt for Kanva story/journey rows
- `sections/product-list.liquid` — Product grid section; adapt card styling for Kanva
- `sections/collection-links.liquid` — Collection navigation section; adapt for Kanva framing
- `sections/section.liquid` — Generic section wrapper with alignment, stacking, and background controls

### Horizon styling infrastructure
- `snippets/theme-styles-variables.liquid` — CSS custom property definitions
- `snippets/spacing-style.liquid` — Spacing utility helpers
- `snippets/typography-style.liquid` — Typography utility helpers
- `config/settings_schema.json` — Global theme settings and color scheme definitions

### Project scope
- `.planning/PROJECT.md` — Project framing, Horizon-first baseline, constraints
- `.planning/REQUIREMENTS.md` — EDIT-01, EDIT-04, COMP-01, COMP-02, COMP-03 requirements for this phase
- `.planning/ROADMAP.md` — Phase 2 success criteria and scope boundary

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `sections/media-with-content.liquid` (432 lines): Split media/text layout with media-width controls, extend-media option, block-based content area. Direct Kanva story/journey row candidate.
- `sections/product-list.liquid`: Product grid section with collection-based or manual product selection. Card styling can be adapted for Kanva.
- `sections/collection-links.liquid`: Collection navigation section. Can be adapted for Kanva collection framing.
- `sections/section.liquid`: Generic wrapper with alignment, stacking, background media, and responsive controls.
- `snippets/kanva-responsive-media.liquid`: Phase 1 shared media helper. All new Kanva sections with media must use this.
- `snippets/section.liquid`: Central rendering path for background image/video positioning and mobile layout.
- `blocks/_card.liquid`, `blocks/text.liquid`, `blocks/image.liquid`: Generic content blocks available for composition.
- `blocks/_blog-post-card.liquid`, `blocks/_collection-card.liquid`: Existing card blocks that may inform Kanva card patterns.
- 94 blocks, 94 snippets, 41 sections already in Horizon — rich reuse surface.

### Established Patterns
- Sections use schema-driven layout controls, not hardcoded markup
- Blocks provide editor-facing reusable pieces; snippets provide shared rendering logic
- CSS custom properties defined in `snippets/theme-styles-variables.liquid` and consumed throughout
- Spacing managed through `snippets/spacing-style.liquid` with consistent padding/margin patterns
- No existing "feature strip" or "testimonial" section — these are genuinely new patterns

### Integration Points
- New Kanva sections go in `sections/` and will be available for any JSON template
- New shared snippets go in `snippets/` with `kanva-` prefix to distinguish from Horizon base snippets
- Kanva CSS custom properties integrate through the existing theme styles infrastructure
- New sections must work with Horizon's header/footer groups and existing template structure

</code_context>

<specifics>
## Specific Ideas

- The Kanva feature strip is a 4-column icon + label pattern with cream background (`#F5F3EF`) that appears on the homepage and about page. It should be a single reusable section, not two page-specific copies.
- Kanva testimonials use a single large centered quote with star rating and attribution — simpler than typical carousel testimonials. One section, one block type for each quote.
- The newsletter section needs to work as a standalone page-body section (not just in the footer) with the Kanva warm cream background and editorial styling.
- The social/image grid uses static images in v1 (no live Instagram API) — simpler to implement as a generic image grid section that can later be connected to an API.
- Kanva card treatments (product cards, blog cards) share the same border-radius, hover-zoom, and badge-pill pattern — this is the primary shared snippet.
- The Kanva heading system (label + heading + subtext) repeats across every section type and should be DRY from the start.

</specifics>

<deferred>
## Deferred Ideas

- Homepage assembly from these primitives → Phase 3
- Collection page framing and card restyling → Phase 4
- About page storytelling composition → Phase 5
- Blog curation and featured story surface → Phase 6
- Live Instagram API integration → v2 (POLI-02), out of scope for this milestone
- Custom animated carousel with preview rail → v2 (POLI-01), out of scope

</deferred>

---

*Phase: 02-shared-kanva-primitives*
*Context gathered: 2026-03-28*
