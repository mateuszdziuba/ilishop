# Project Research Summary

**Project:** Horizon Kanva Theme Rebuild
**Domain:** Custom Shopify OS 2.0 theme rebuild for a premium editorial storefront
**Researched:** 2026-03-25
**Confidence:** HIGH

## Executive Summary

This is a Shopify theme rebuild, not an app project. The research is consistent that the correct implementation model is Horizon-native Online Store 2.0 composition: Liquid, JSON templates, sections, theme blocks, snippets, CSS, and small progressive-enhancement JavaScript. The Kanva reference should drive visual and content decisions, but Horizon remains the technical baseline because it already owns the reusable page primitives, editor patterns, card pipelines, and collection/blog runtime behavior that this milestone needs.

The recommended approach is to build a thin Kanva design layer on top of Horizon rather than cloning static HTML into page-specific sections. Start by defining shared tokens, responsive editor rules, and a small set of reusable editorial primitives. Then adapt existing Horizon card, collection, and blog surfaces before composing the requested pages in delivery order: landing, collections, about, then blog. This keeps the implementation merchant-editable and prevents a second mini-theme from emerging inside the repo.

The main risks are not visual; they are structural. If the team skips schema design, shared primitives, or runtime stabilization, the roadmap will drift into copied markup, bloated mobile/desktop controls, CSS specificity debt, and regressions in fragile shared JavaScript surfaces such as collection filtering and section rendering. The roadmap should therefore front-load stabilization, token/schema contracts, and shared component work before page-specific builds.

## Key Findings

### Recommended Stack

The stack decision is clear: stay inside Shopify OS 2.0 and extend Horizon. Use JSON templates to compose Kanva page variants, sections for merchant-facing page regions, theme blocks for reusable repeatable content, and snippets for render-only helpers. Styling should be incremental and Horizon-aligned; JavaScript should stay section-scoped and limited to interactions Horizon already expects.

Do not introduce React, Vite, a parallel design-token system, client-rendered page composition, or a hardcoded import of `theme-to-clone/` markup/CSS. Those options add complexity while directly conflicting with Shopify editor ergonomics and Horizon's existing architecture.

**Core technologies:**
- Shopify Online Store 2.0 theme architecture: base runtime for page composition and theme editor behavior.
- Horizon theme: implementation baseline with reusable sections, blocks, snippets, import-map JS, and collection/blog primitives already in place.
- Liquid plus JSON templates: server-rendered composition that matches Shopify's native content and editor model.
- Theme blocks and snippets: reusable editorial units for Kanva patterns without page-specific duplication.
- CSS assets plus small ES modules: styling and lightweight enhancement without shifting rendering into JS.
- Shopify CLI, `shopify.theme.toml`, and Theme Check: standard local workflow, environment targeting, and linting discipline.

### Expected Features

V1 table stakes are the reusable sections and page flows required to make the storefront feel like the Kanva target while remaining merchant-editable. The research is explicit that premium polish comes from composition, art direction, and curation more than from heavy interactivity.

**Must have (table stakes):**
- Editorial homepage foundation: modular hero, value strip, collection discovery, testimonial, newsletter, and social sections.
- Collection browsing foundation: editorial intro, native filtering and sorting, responsive grid, and Kanva-aligned product cards.
- About storytelling system: hero, stats, split media/text sections, mission content, and reusable supporting editorial sections.
- Blog index curation: featured article treatment, article list or grid, tag-based navigation, and newsletter follow-up.
- Merchant-configurable desktop/mobile media controls where composition materially changes by breakpoint.
- Strong theme editor ergonomics with reorderable sections, reusable blocks, and restrained settings.

**Should have (competitive):**
- Advanced hero carousel behavior after a strong configurable hero ships.
- Narrative collection landing compositions once the shared editorial system is stable.
- Richer blog enhancements such as related content or author metadata.
- Selective motion or deeper testimonials/UGC only after static composition is proven.

**Defer (v2+):**
- Dynamic Instagram integration.
- Wishlist or favorites.
- Lookbook or shoppable story systems.
- Custom content taxonomy or headless-style blog modeling.
- Heavy quick-add or routine-builder interactions.

### Architecture Approach

The architecture recommendation is to compose Kanva-specific JSON templates from existing Horizon sections first, then add only a small set of `kanva-*` sections when a pattern clearly repeats across pages. `main-collection` and `main-blog` should remain the engines for collection and blog behavior; the Kanva work should wrap and restyle them, not fork them. The dependency chain is shared styling/snippets first, then card and filter presentation, then landing composition, then collections, then about, then blog.

**Major components:**
1. JSON templates: define Kanva page composition and default section order for home, collections, about, and blog.
2. Reused Horizon sections: provide hero, product lists, collection lists, collection runtime, blog runtime, and general editorial wrappers.
3. Small Kanva-specific editorial sections: cover repeated layouts such as feature strips, split media/text, testimonials, newsletter, social grid, and featured blog hero.
4. Shared snippets: normalize section headers, editorial media rendering, metric rows, and badge styling.
5. Existing Horizon card and runtime pipelines: keep product, collection, article, filter, pagination, and section-rendering behavior centralized.

### Critical Pitfalls

1. **Static clone implementation** — Avoid copying `theme-to-clone/` HTML/CSS into page-specific sections. Map repeated patterns into reusable sections, blocks, and snippets first.
2. **Editor control explosion** — Define one responsive settings contract up front. Only add mobile overrides where layout actually diverges.
3. **Duplicated desktop/mobile markup** — Keep content singular and vary media or layout through settings/CSS unless duplication is unavoidable for accessibility.
4. **Shared JS regression blast radius** — Stabilize and verify fragile Horizon runtime surfaces before changing collection, blog, or global scripts.
5. **CSS token drift and specificity wars** — Create a Kanva token layer and component styling rules before page-level overrides accumulate.

## Implications for Roadmap

Based on research, suggested phase structure:

### Phase 1: Stabilization, Tokens, and Editor Contract
**Rationale:** Shared runtime fragility and schema drift are the highest-risk blockers. The roadmap should not start with page cloning.
**Delivers:** Regression checklist or smoke harness for high-risk shared flows, Kanva token mapping, CSS strategy, responsive settings contract, and stable section/schema naming rules.
**Addresses:** Merchant-editable desktop/mobile art direction, design consistency, and safer execution for every later page phase.
**Avoids:** JS regression blast radius, control explosion, CSS drift, and section API churn.

### Phase 2: Shared Commerce and Editorial Primitives
**Rationale:** Home, collections, about, and blog all depend on the same cards, headers, media handling, and repeated editorial patterns.
**Delivers:** Adapted `_product-card`, `_collection-card`, `_blog-post-card`, shared snippets such as section headers and editorial media, plus the minimum reusable `kanva-*` sections needed for feature strips, split rows, testimonial/newsletter/social modules.
**Uses:** Horizon sections, theme blocks, snippets, CSS assets, and progressive enhancement only where needed.
**Implements:** The reusable component layer that prevents page-specific duplication.

### Phase 3: Landing Page Composition
**Rationale:** The homepage is the first requested deliverable and depends directly on the shared primitives created earlier.
**Delivers:** `index.kanva.json`, modular hero, value strip, collection discovery, testimonial, newsletter, and social proof composition.
**Addresses:** Core v1 brand expression and navigation into real Shopify collections.
**Avoids:** Hardcoded home-only markup and fake JS-only collection tabs.

### Phase 4: Collection Experience
**Rationale:** Collections are a high-value page type but should follow card/filter adaptation so the team does not refactor runtime and layout simultaneously.
**Delivers:** `collection.kanva.json`, optional editorial heading treatment, Kanva-styled `main-collection`, and polished native filters/sorting/grid behavior.
**Addresses:** Premium browsing expectations and Shopify-native discovery flows.
**Avoids:** Forking collection logic, custom filtering systems, and unbounded runtime changes.

### Phase 5: About Page System
**Rationale:** About depends on the shared editorial primitives but not on new commerce runtime.
**Delivers:** `page.about.kanva.json`, story/journey split sections, stats/proof rows, mission content, and reused social/features modules.
**Addresses:** Modular brand storytelling with strong editor ergonomics.
**Avoids:** One-off `main-page` blobs and repeated editorial markup.

### Phase 6: Blog Curation Layer
**Rationale:** Blog comes last in the requested order and benefits from the editorial card and shared content system already being stable.
**Delivers:** `blog.kanva.json`, featured article surface, curated `main-blog` presentation, tag-based navigation, and supporting newsletter section.
**Addresses:** Editorial credibility without inventing a custom content system.
**Avoids:** Rebuilding archive logic or splitting article-card patterns from the rest of the theme.

### Phase Ordering Rationale

- Shared styling, schema rules, and regression coverage must come before page work because they prevent rework across every requested template.
- Card and editorial primitives come before templates because home, collections, about, and blog all reuse them.
- Collections should follow primitive work but stay after home so the team can separate visual composition from the fragile filter/runtime layer.
- About and blog should land after the reusable editorial system is proven so they become assembly work, not fresh architecture work.

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 1:** Verify the minimal regression approach against the current Horizon runtime and existing codebase concerns; the risk is implementation-specific, not conceptual.
- **Phase 4:** Confirm exactly how far Kanva sidebar/filter styling can go without touching fragile collection runtime files.
- **Phase 6:** Validate whether featured-article behavior should be a thin wrapper section or a controlled extension of `main-blog`.

Phases with standard patterns (skip research-phase):
- **Phase 2:** Reusable sections, snippets, and card styling follow standard Horizon and Shopify OS 2.0 patterns already documented.
- **Phase 3:** Homepage composition is straightforward once primitives and schema contracts are fixed.
- **Phase 5:** About page assembly is standard section-driven editorial composition with no unusual platform constraints.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Grounded in official Shopify theme architecture and reinforced by the current Horizon codebase structure. |
| Features | HIGH | The requested page set and v1 table stakes are explicit in the brief and strongly supported by the Kanva reference. |
| Architecture | HIGH | Recommendations map directly onto existing Horizon sections, templates, and runtime boundaries. |
| Pitfalls | MEDIUM-HIGH | Risks are well-supported by local codebase concerns and Shopify editor/runtime constraints, but exact failure points depend on implementation choices. |

**Overall confidence:** HIGH

### Gaps to Address

- Regression strategy depth: decide during planning whether manual smoke scripts are sufficient or whether minimal automated coverage is necessary for shared runtime surfaces.
- Exact Kanva section count: validate with visual implementation that the team is adding the minimum reusable `kanva-*` sections rather than over-modeling the design.
- Media contract specifics: lock down aspect ratios, focal-point behavior, and fallback rules using real merchant assets before finalizing art-directed sections.
- Blog feature boundary: confirm whether featured article treatment can stay external to `main-blog` or needs a controlled extension inside it.

## Sources

### Primary (HIGH confidence)
- `/Users/mati/Mine/horizon/.planning/PROJECT.md` — project scope, ordering, and constraints.
- `/Users/mati/Mine/horizon/.planning/research/STACK.md` — recommended stack, workflow, and explicit anti-patterns.
- `/Users/mati/Mine/horizon/.planning/research/FEATURES.md` — v1 table stakes, differentiators, anti-features, and dependencies.
- `/Users/mati/Mine/horizon/.planning/research/ARCHITECTURE.md` — template, section, block, snippet boundaries and dependency chain.
- `/Users/mati/Mine/horizon/.planning/research/PITFALLS.md` — risk inventory and mitigation order.
- https://shopify.dev/docs/storefronts/themes/architecture/sections — OS 2.0 section architecture.
- https://shopify.dev/docs/storefronts/themes/architecture/blocks/theme-blocks/quick-start?framework=liquid — theme block model.
- https://shopify.dev/docs/storefronts/themes/tools/cli — official CLI workflow.
- https://shopify.dev/docs/storefronts/themes/tools/theme-check — linting and quality gates.

### Secondary (MEDIUM confidence)
- `/Users/mati/Mine/horizon/.planning/codebase/ARCHITECTURE.md` — local Horizon architectural baseline referenced by research.
- `/Users/mati/Mine/horizon/.planning/codebase/CONCERNS.md` — local shared-runtime and regression risks referenced by pitfalls research.
- `/Users/mati/Mine/horizon/theme-to-clone/kanva-docs.md` — visual target and reference information.

---
*Research completed: 2026-03-25*
*Ready for roadmap: yes*
