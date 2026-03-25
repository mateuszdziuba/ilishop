# Architecture Patterns

**Domain:** Custom Shopify theme architecture for Kanva-style landing, collections, about, and blog pages on Horizon
**Researched:** 2026-03-25

## Recommended Architecture

Integrate the Kanva experiences as a thin page-system on top of Horizon's existing OS 2.0 composition model, not as a parallel theme inside the theme. The right boundary is:

- JSON templates decide page composition and default section order.
- Sections own page regions and merchant-facing settings.
- Theme blocks stay responsible for configurable content units inside those sections.
- Snippets hold shared rendering fragments and style helpers reused across page types.

The maintainable move is to reuse Horizon's existing structural sections first:

- `sections/slideshow.liquid` and `sections/hero.liquid` for landing hero variants with desktop/mobile art direction already supported.
- `sections/product-list.liquid` for repeatable category rows on the landing page.
- `sections/collection-list.liquid` for collection/category navigation surfaces.
- `sections/main-collection.liquid` plus `blocks/filters.liquid` and `snippets/product-grid.liquid` for shop and category pages.
- `sections/main-blog.liquid` for blog index pagination and article listing.
- `sections/section.liquid` and `sections/main-page.liquid` for flexible editorial page assembly on about and any static landing subregions.

Add new code only where Kanva needs a reusable content pattern Horizon does not already express well. That means a small set of Kanva-specific editorial sections and snippets, not page-specific hardcoded templates.

### Recommended Shape

```text
templates/
  index.kanva.json                # Home composition
  collection.kanva.json           # Shop/category composition
  page.about.kanva.json           # About composition
  blog.kanva.json                 # Blog composition

sections/
  kanva-feature-strip.liquid      # 4-up trust/features row
  kanva-editorial-split.liquid    # Story/journey two-column image-text pattern
  kanva-testimonial.liquid        # Quote/stat attribution block
  kanva-newsletter.liquid         # Newsletter with art direction controls
  kanva-social-grid.liquid        # Instagram/editorial image grid
  kanva-blog-hero.liquid          # Optional featured article section above main-blog
  kanva-page-heading.liquid       # Optional reusable heading/intro section for about/collection/blog

snippets/
  kanva-section-header.liquid     # Heading + kicker + CTA row
  kanva-metric-list.liquid        # Stats row renderer
  kanva-editorial-media.liquid    # Shared image/mobile image/media rendering helper
  kanva-card-badge.liquid         # Pills/badges used by product/article cards
```

The first implementation pass should prefer configuring existing blocks inside existing sections over creating these new files. Only promote a pattern to a new section when it appears on at least two page types or when it needs a clear merchant-editing boundary.

## Component Boundaries

### Page Templates

| Template | Responsibility | Reuse First | Additions |
|----------|----------------|-------------|-----------|
| `templates/index.kanva.json` | Compose landing page sections in Kanva order | `slideshow` or `hero`, `product-list`, `section` | `kanva-feature-strip`, `kanva-testimonial`, `kanva-newsletter`, `kanva-social-grid` |
| `templates/collection.kanva.json` | Compose collection header and product browsing | `section`, `main-collection` | optional `kanva-page-heading` only if header treatment must differ materially |
| `templates/page.about.kanva.json` | Compose about editorial experience | `hero`, `main-page`, `section` | `kanva-editorial-split`, `kanva-feature-strip`, `kanva-social-grid` |
| `templates/blog.kanva.json` | Compose featured story plus article feed | `main-blog`, `section` | `kanva-blog-hero` if featured article layout cannot be expressed cleanly in `main-blog` |

### Section Boundaries

| Section | Responsibility | Communicates With |
|---------|----------------|-------------------|
| `slideshow` | Home hero carousel with media art direction and CTA content | slide blocks, existing slideshow snippets/assets |
| `hero` | Single editorial hero for about or landing fallback | text/button/image blocks, existing hero media logic |
| `product-list` | Landing category rows like Cleansers, Lotions, Moisturizers | `_product-list-content`, `_product-card`, `snippets/resource-list.liquid` |
| `collection-list` | Collection/category navigation grids or editorial list | `_collection-card`, `snippets/resource-list.liquid` |
| `main-collection` | Filters, sort, grid density, pagination/infinite scroll | `filters` block, `_product-card`, `snippets/product-grid.liquid`, `assets/facets.js`, `assets/results-list.js` |
| `main-blog` | Blog article list/grid and core listing logic | `_blog-post-card` block family, `assets/blog-posts-list.js` |
| `main-page` | Generic static page shell for body-content-like blocks | text/media/button/group blocks |
| `kanva-feature-strip` | Structured 3-4 item trust/features row | icon/text/button/group blocks or small purpose-built metric snippet |
| `kanva-editorial-split` | Reusable two-column story/journey section with mobile overrides | shared media snippet, text/button/group blocks |
| `kanva-testimonial` | Centered quote, rating meta, attribution | text blocks or dedicated snippet |
| `kanva-newsletter` | Kanva newsletter callout with optional decorative art | form snippet, shared section header snippet |
| `kanva-social-grid` | Reusable Instagram/editorial image grid used on home and about | image/link blocks, shared grid snippet |
| `kanva-blog-hero` | Featured article surface above `main-blog` | article setting or first article from current blog, shared article-card snippet |

### Block Boundaries

Use blocks for merchant-authored content inside a section, not for page routing. The existing Horizon split is correct:

- Use `text`, `button`, `image`, `group` where the content is generic and editor-driven.
- Keep `_product-card`, `_collection-card`, `_blog-post-card`, `_product-list-content`, `_product-list-text`, `_product-list-button` as the canonical commerce/editorial card composition primitives.
- Introduce new internal `_kanva-*` blocks only when a section needs nested, repeatable children that merchants should reorder within that section. Example: `_kanva-feature-item` if the feature strip needs icon, heading, copy, and badge settings repeated four times.

Avoid creating separate `landing-*`, `about-*`, or `blog-*` blocks that duplicate the same rendering logic with different names.

### Snippet Boundaries

Snippets should absorb shared markup and style logic that would otherwise duplicate across Kanva sections:

- Shared section headers: heading, eyebrow, supporting copy, optional CTA row.
- Shared editorial media rendering with desktop/mobile asset fallback.
- Shared metric rows and badge pills.
- Shared decorative background or botanical asset wrappers.

Do not move page-level business logic into snippets. Snippets stay render-only.

## Data Flow

### Template Composition Flow

1. Shopify routes page type to a Kanva JSON template variant.
2. The template instantiates ordered sections with defaults tuned to the Kanva layout.
3. Each section renders its schema-backed settings and block tree.
4. Shared snippets normalize repeated markup and style output.
5. Existing Horizon JS enhances only the sections that already need interactivity, primarily `main-collection`, `main-blog`, and `slideshow`.

### Collection Browsing Flow

1. `collection.kanva.json` renders an optional editorial heading section, then `main-collection`.
2. `main-collection` passes `collection` into the `filters` block and `_product-card` static block tree.
3. `snippets/product-grid.liquid` renders the card grid using section settings for density, width, and gaps.
4. `assets/facets.js` and `assets/results-list.js` update filtering, sorting, and pagination through section re-rendering.

This existing flow should remain the source of truth. Do not build a second collection grid section just to match Kanva cosmetics.

### Blog Flow

1. `blog.kanva.json` renders an optional featured article section first.
2. `main-blog` renders the rest of the article archive using Horizon's `_blog-post-card` pattern.
3. Article card visual treatment is adjusted at the block/snippet level so featured and standard cards remain related.

If the first article is featured automatically, that logic belongs in `kanva-blog-hero`, not scattered across both template JSON and `main-blog`.

## Settings Flow

Settings need three scopes, and they should stay separate:

| Scope | Where | Use |
|-------|------|-----|
| Global theme settings | `config/settings_schema.json` | Kanva-wide tokens only: optional color scheme aliases, shared social handle, default newsletter copy if truly global |
| Section settings | section schema | Layout, spacing, backgrounds, desktop/mobile media, CTA labels, section-level toggles |
| Block settings | block schema | Individual feature items, text fragments, card content, links, per-item imagery |

Recommended settings discipline:

- Keep Kanva visual tokens mapped to Horizon color schemes instead of adding many one-off color pickers.
- Prefer existing Horizon desktop/mobile media settings patterns from `hero` over inventing separate duplicated mobile controls in every section.
- Put page-specific content in the section or block that renders it, not in global settings.
- Use template defaults to express Kanva's initial composition. Do not overload schema with settings that exist only to compensate for a poor default template.

## Existing Horizon Abstractions To Reuse First

Use these in this order before creating new abstractions:

1. `sections/main-collection.liquid`
   Reason: it already owns the highest-risk interactive path: filters, sorting, grid state, pagination, and section rendering.

2. `blocks/filters.liquid` and `snippets/product-grid.liquid`
   Reason: Kanva's shop/category experience is a styling and layout adaptation, not a new browsing system.

3. `sections/product-list.liquid`
   Reason: it already expresses landing-page category rows with a header and product cards.

4. `sections/slideshow.liquid` and `sections/hero.liquid`
   Reason: Kanva hero requirements match Horizon's existing media and mobile art-direction support better than a bespoke section would.

5. `sections/section.liquid` and `snippets/section.liquid`
   Reason: these are the generic wrapper system for spacing, width, background media, overlay, and block composition.

6. `sections/main-blog.liquid`
   Reason: it gives a stable editorial archive baseline and reduces blog-specific surface area to featured treatment and card styling.

7. `sections/main-page.liquid`
   Reason: it is the safest wrapper for freeform editorial pages before introducing new Kanva-specific sections.

Only after these are exhausted should you add `kanva-*` sections.

## Page Integration Recommendations

### Landing

Use a dedicated `index.kanva.json` template composed mostly from existing sections:

1. `slideshow` for the 3-slide hero.
2. `kanva-feature-strip` for the 4-up trust row.
3. Three `product-list` instances for Cleansers, Lotions, Moisturizers.
4. `kanva-testimonial`.
5. `kanva-newsletter`.
6. `kanva-social-grid`.

Why this is maintainable:

- Repeated product rows stay one section type with different collection bindings.
- The only truly new landing-specific sections are the feature strip, testimonial, newsletter treatment, and social grid.
- Hero stays on Horizon's battle-tested media/carousel stack.

### Collections

Use `collection.kanva.json` with:

1. Optional `section` or `kanva-page-heading` for title, intro copy, and collection imagery.
2. `main-collection` unchanged in responsibility.

Maintainability rule: do not fork filtering, sorting, or grid logic. If Kanva needs a left sticky sidebar, adapt `blocks/filters.liquid` settings and CSS to use Horizon's existing vertical mode instead of introducing a new collection section.

### About

Use `page.about.kanva.json` as a modular editorial page:

1. `hero`.
2. `section` or `kanva-feature-strip` for stats row.
3. Two `kanva-editorial-split` instances for Story and Journey.
4. `section` or dedicated centered editorial section for Mission.
5. Reuse `kanva-feature-strip` for the features grid if the content model matches.
6. `kanva-social-grid`.

Maintainability rule: about should be section-driven, not implemented inside `main-page` as one large blob of custom liquid.

### Blog

Use `blog.kanva.json` with:

1. `kanva-blog-hero` for the featured article card.
2. `main-blog` for the archive/list below.

Maintainability rule: keep archive logic in `main-blog`. The Kanva-specific requirement is the featured presentation, not a separate article listing engine.

## Patterns To Follow

### Pattern 1: Template Variant, Not Section Fork

**What:** Create Kanva-specific JSON templates that assemble existing sections differently before modifying section logic.

**When:** When page composition differs but the underlying section responsibilities already match.

**Use for:** Home, collection, about, and blog rollout.

### Pattern 2: One Reusable Editorial Section Per Repeated Layout Family

**What:** Promote repeated editorial layouts into a small number of reusable `kanva-*` sections.

**When:** When the same structure appears across at least two pages or repeats within one page with different content.

**Use for:** Feature strip, editorial split, newsletter, social grid.

### Pattern 3: Style the Existing Card Pipelines

**What:** Restyle `_product-card`, `_collection-card`, and `_blog-post-card` instead of replacing them.

**When:** When Kanva requires different spacing, badges, aspect ratios, or metadata order.

**Use for:** Collection grid cards, landing rows, featured blog cards.

## Anti-Patterns To Avoid

### Anti-Pattern 1: Page-Specific Monolith Sections

**What:** `landing-page.liquid`, `about-page.liquid`, or `kanva-blog-page.liquid` sections that hardcode a full page.

**Why bad:** They destroy reordering, create giant schemas, and make future edits page-coupled.

**Instead:** Compose templates from reusable sections.

### Anti-Pattern 2: Duplicating Horizon Commerce Logic

**What:** New collection or blog listing sections that reimplement filtering, pagination, or card loops only to match the reference design.

**Why bad:** It forks the most fragile runtime in the theme and increases regression risk in already sensitive areas called out in `.planning/codebase/CONCERNS.md`.

**Instead:** Keep `main-collection` and `main-blog` as the core engines; adapt presentation around them.

### Anti-Pattern 3: Overusing Global Settings

**What:** Pushing per-page art direction, copy, or CTA controls into `settings_schema.json`.

**Why bad:** It breaks locality and makes template reuse harder.

**Instead:** Keep content and art direction on the sections that render them.

## Suggested Build Order And Dependency Chain

Build in dependency order, not page order alone.

1. **Foundation styling and shared snippets**
   - Create Kanva token mapping against existing Horizon color schemes and typography knobs.
   - Add shared snippets such as `kanva-section-header` and `kanva-editorial-media` only if repeated markup is already visible.
   - Dependency: none.

2. **Card and collection presentation adaptation**
   - Adjust `_product-card`, `_collection-card`, `_blog-post-card` presentation as needed.
   - Tune `main-collection` and `filters` styling to support Kanva's sidebar collection layout.
   - Dependency: foundation styling.

3. **Landing page composition**
   - Create `index.kanva.json`.
   - Reuse `slideshow` and `product-list`.
   - Add `kanva-feature-strip`, `kanva-testimonial`, `kanva-newsletter`, `kanva-social-grid` only where Horizon lacks a fit.
   - Dependency: shared snippets and card styling.

4. **Collections templates**
   - Create `collection.kanva.json` and, if needed, `list-collections.kanva.json`.
   - Keep `main-collection` intact, add only a thin heading/editorial companion section if needed.
   - Dependency: card and filter adaptation.

5. **About page system**
   - Create `page.about.kanva.json`.
   - Add `kanva-editorial-split` after confirming `section` and existing blocks are insufficient.
   - Dependency: landing editorial sections and shared media/header snippets.

6. **Blog featured experience**
   - Create `blog.kanva.json`.
   - Add `kanva-blog-hero` only for the featured article treatment above `main-blog`.
   - Dependency: article card styling and shared editorial snippets.

Dependency chain:

```text
Shared styling/snippets
  -> card styling + filters presentation
  -> landing sections
  -> collections template
  -> about editorial sections
  -> blog featured section
```

This ordering respects the user's requested delivery sequence while still front-loading the shared pieces that prevent rework.

## Scalability Considerations

| Concern | At 100 users | At 10K users | At 1M users |
|---------|--------------|--------------|-------------|
| Merchant maintainability | Section-driven templates stay manageable | Duplication becomes costly if page-specific sections proliferate | A small reusable section library is mandatory |
| Collection interactions | Existing `main-collection` is sufficient | Keep all filter/pagination work on existing Horizon runtime | Forking collection logic becomes operationally expensive |
| Editorial consistency | Shared snippets keep home/about/blog aligned | Card/header drift appears if each page customizes separately | A single Kanva design layer over Horizon primitives is required |
| Performance | Existing global JS load is acceptable but not ideal | Avoid adding new always-on JS for static editorial sections | New Kanva sections should stay mostly Liquid/CSS-only |

## Confidence

**Overall confidence:** HIGH

Reasoning:

- High confidence in the section/template/block boundary recommendation because it is directly grounded in the current Horizon codebase.
- High confidence that `main-collection` and `main-blog` should be reused, because they already encapsulate the interactive behaviors with the highest regression risk.
- Medium confidence only on the exact number of new `kanva-*` sections needed, because that should be validated against the final visual fidelity pass; the principle remains to add the minimum set.

## Sources

- Internal project brief: `/Users/mati/Mine/horizon/.planning/PROJECT.md`
- Codebase architecture map: `/Users/mati/Mine/horizon/.planning/codebase/ARCHITECTURE.md`
- Codebase structure map: `/Users/mati/Mine/horizon/.planning/codebase/STRUCTURE.md`
- Codebase concern map: `/Users/mati/Mine/horizon/.planning/codebase/CONCERNS.md`
- Kanva reference notes: `/Users/mati/Mine/horizon/theme-to-clone/kanva-docs.md`
- Horizon implementation references:
  - `/Users/mati/Mine/horizon/sections/section.liquid`
  - `/Users/mati/Mine/horizon/snippets/section.liquid`
  - `/Users/mati/Mine/horizon/sections/slideshow.liquid`
  - `/Users/mati/Mine/horizon/sections/hero.liquid`
  - `/Users/mati/Mine/horizon/sections/product-list.liquid`
  - `/Users/mati/Mine/horizon/sections/collection-list.liquid`
  - `/Users/mati/Mine/horizon/sections/main-collection.liquid`
  - `/Users/mati/Mine/horizon/sections/main-blog.liquid`
  - `/Users/mati/Mine/horizon/sections/main-page.liquid`
  - `/Users/mati/Mine/horizon/blocks/filters.liquid`
  - `/Users/mati/Mine/horizon/blocks/product-card.liquid`
  - `/Users/mati/Mine/horizon/snippets/product-grid.liquid`
  - `/Users/mati/Mine/horizon/templates/index.json`
  - `/Users/mati/Mine/horizon/templates/collection.json`
  - `/Users/mati/Mine/horizon/templates/blog.json`
  - `/Users/mati/Mine/horizon/templates/page.json`
