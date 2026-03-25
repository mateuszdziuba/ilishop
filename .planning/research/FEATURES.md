# Feature Landscape

**Domain:** Premium editorial Shopify storefront rebuild for a custom Horizon-based Kanva theme
**Researched:** 2026-03-25

## Table Stakes

Features the merchant should treat as required for this milestone. Missing these would make the rebuild feel incomplete relative to the requested Kanva target and current premium Shopify expectations.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Modular editorial homepage hero with merchant-editable slides, copy, CTA, and desktop/mobile media controls | The clone target opens with a multi-slide editorial hero, and Horizon already supports split desktop/mobile hero media patterns. | Med | Must be section-driven, not hardcoded. Include image focal/position controls where art direction differs by breakpoint. |
| Homepage brand-value strip / features row | Premium wellness storefronts routinely surface trust/value props high on the page. The Kanva target uses a four-item proof strip immediately below hero. | Low | Best implemented as a reusable icon/text repeater section that can also serve About page features. |
| Editorial collection discovery on homepage | The requested landing page needs to direct shoppers into collections quickly, not just act as a brand page. | Med | Use Shopify collections, not fake category tabs. Can visually resemble tabs/cards while linking into real collection pages. |
| Reusable product-card merchandising aligned to the Kanva aesthetic | Collection and homepage merchandising depends on cards feeling premium and consistent. | Med | Adapt Horizon product-card primitives instead of creating parallel markup. Support badge, hover state, quick add only if it can reuse existing theme behavior cleanly. |
| Collection page with native filtering, sorting, and responsive grid | Faceted browsing and sort controls are baseline for premium collection templates. Horizon already includes `main-collection` and filters infrastructure. | Low | Keep Shopify-native filtering and sorting. Prefer styling/reframing existing facets over replacing them. |
| Collection editorial header / intro area | The Kanva target expects more than a raw grid; collections need branded framing and optional supporting copy. | Low | Reuse Horizon `section` heading plus configurable supporting content/image treatment where needed. |
| Merchant-configurable desktop/mobile imagery and positioning in editorial sections | This is explicitly requested by the merchant and is central to the rebuild’s value. | Med | Restrict to sections where composition changes materially by breakpoint: hero, split-image content, featured editorial cards, banners. |
| About page modular story layout | The About page in the target is a sequence of branded storytelling modules, not a single rich-text blob. | Med | Needs reusable sections for hero, stats, split media/text, centered mission copy, features grid, and optional social/gallery follow-up. |
| Stats / proof row on About page | Editorial brand pages commonly turn trust signals into structured metrics. The clone does this prominently. | Low | Use blocks for each metric so merchants can reorder/remove entries. |
| Reusable split media-and-copy editorial section | Both About and future landing content depend on alternating story modules. | Med | Needs per-breakpoint image handling and flexible media-left/media-right layout. |
| Blog index with featured article plus article list/grid | Shopify blog landing pages are expected to feel curated, especially for editorial-first brands. The Kanva target explicitly highlights one featured story above the list. | Med | Horizon already has `main-blog`; extend it into a more curated layout rather than replacing blog primitives. |
| Blog category/tag filtering via article tags | Editorial storefront blogs need lightweight topic navigation. Shopify natively supports tag-filtered blog URLs. | Low | Treat this as tag-based filtering/navigation, not a custom CMS taxonomy system. |
| Shared newsletter signup section | The clone repeats newsletter capture and premium themes commonly include it on home and blog pages. | Low | Should be a reusable section with image/text variants, not page-specific markup. |
| Shared Instagram / social proof gallery section | The Kanva target uses this on home, About, and Blog, and it reinforces the editorial brand layer. | Low | If direct API integration is not already available, ship as merchant-managed image/link cards in v1. |
| Strong section-level theme editor ergonomics | For a custom client theme, editor usability is part of the product. | Med | Sections should support reorderability, reusable blocks, sane defaults, and avoid page-specific one-off settings explosions. |

## Differentiators

High-value features worth doing later, after the requested milestone pages are stable. These improve polish or conversion, but they are not the right first-pass investment for this rebuild.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| True homepage hero carousel with animated transitions, preview rail, and synchronized slide navigation | Matches the clone more literally and increases editorial polish. | High | Start v1 with a strong configurable hero; add advanced carousel behavior later if Horizon’s existing behavior cannot be adapted cheaply. |
| Collection landing system with bespoke narrative sections per collection | Lets each collection feel like a campaign page instead of a generic PLP. | Med | Valuable after core collection browsing is complete. Depends on reusable editorial sections built in v1. |
| Editorial lookbook / shoppable story modules | Strong premium differentiator for content-commerce brands. | High | Better suited to a later milestone once shared media/text and product-card patterns are stable. |
| Advanced quick add / mini routine builder on collection cards | Can improve conversion for repeat-purchase skincare. | High | Not needed to validate the storefront rebuild and adds interaction/testing complexity. |
| Dynamic social integration for Instagram feed | Reduces merchant upkeep and keeps the feed fresh. | Med | Defer unless there is already an approved app/data source. Static merchant-managed cards are enough for v1. |
| Rich blog enhancements such as reading time, author modules, related articles, or topic landing pages | Improves editorial depth and discoverability. | Med | Blog index curation is the v1 need; article-level publishing sophistication can follow. |
| Scroll-reactive micro-interactions, reveal motion, and parallax media | Adds premium feel when restrained. | Med | Easy to overbuild early and hurt theme editor predictability or performance. |
| UGC/testimonial system backed by reviews apps or metafields | Strong trust differentiator once integrated with real data. | Med | v1 can use a curated testimonial section with merchant-managed content. |
| Saved favorites / wishlist experience | Common in aspirational premium storefronts and present in the reference site map. | High | Explicitly outside the requested milestone scope. |
| Editorial search / content discovery across articles and collections | Useful once the content footprint grows. | High | Not justified for the requested first release. |

## Anti-Features

Features to explicitly avoid in this milestone because they create maintenance debt, conflict with Shopify primitives, or dilute delivery on the requested scope.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| Hardcoded page-specific HTML replicas of `theme-to-clone/*.html` | Fast initially, but it breaks theme editor reuse and fights Horizon’s architecture. | Rebuild the visual system as reusable sections, blocks, and snippets. |
| Fake collection categories on the homepage with JS-only product swapping and no real collection linkage | Looks similar in a mockup but undermines navigation, SEO, and merchant maintainability. | Use real Shopify collections and link or filter into them cleanly. |
| Custom filtering system outside Shopify’s native collection filters | Reinvents mature platform behavior and adds brittle state handling. | Skin Horizon’s existing filter/sort system to match the Kanva aesthetic. |
| Over-granular settings for every margin, offset, and breakpoint on every block | Creates an unusable editor and slows content operations. | Add desktop/mobile art-direction controls only where composition genuinely changes. |
| Live Instagram API dependency in v1 | Adds app/vendor dependency and failure modes unrelated to the rebuild. | Use merchant-managed image/link blocks first. |
| Heavy motion layer added before content structure is stable | Increases QA surface and often masks weak layout systems. | Ship strong static composition first, then add selective motion later. |
| Building contact, FAQ, favorites, or legal-page systems in this milestone | These are outside the requested delivery order and dilute effort from the main pages. | Keep roadmap focused on landing, collections, About, and Blog. |
| Custom blog taxonomy or headless-style content modeling | Shopify blog/tag primitives already cover the immediate need. | Use blog tags, featured article treatment, and strong card design. |

## Feature Dependencies

```text
Reusable editorial section patterns
  -> Homepage hero
  -> About story/journey/mission modules
  -> Newsletter section
  -> Social gallery section

Adapted Horizon product-card system
  -> Homepage collection discovery rows
  -> Collection page merchandising

Styled Horizon collection filters/sorting
  -> Collection page parity with premium storefront expectations

Blog featured-article layout
  -> Requires article card styling decisions
  -> Benefits from shared section spacing/typography tokens

Desktop/mobile art-direction controls
  -> Hero
  -> Split editorial media sections
  -> Featured blog/story sections
```

## MVP Recommendation

Prioritize:
1. Editorial homepage foundation: hero, value strip, collection discovery rows, testimonial/newsletter/social sections, all built as reusable sections
2. Collection browsing foundation: editorial intro plus Horizon-native filtering, sorting, and premium product-card styling
3. About page storytelling system: hero, stats, split content, mission, and reusable features/social sections
4. Blog index curation: featured article, article grid/list, tag/category navigation, and newsletter follow-up

Defer:
- Advanced hero carousel behavior: strong payoff, but not required to validate the rebuild if a static or simplified editorial hero ships first
- Dynamic Instagram integration: avoid external dependency until the merchant confirms an app/data source
- Wishlist/favorites and deeper editorial commerce features: materially larger scope than the requested milestone

## Sources

- Project brief and scope: `/Users/mati/Mine/horizon/.planning/PROJECT.md`
- Horizon architecture baseline: `/Users/mati/Mine/horizon/.planning/codebase/ARCHITECTURE.md`
- Kanva reference structure: `/Users/mati/Mine/horizon/theme-to-clone/kanva-docs.md`
- Kanva reference pages: `/Users/mati/Mine/horizon/theme-to-clone/index.html`, `/Users/mati/Mine/horizon/theme-to-clone/about.html`, `/Users/mati/Mine/horizon/theme-to-clone/blog.html`
- Shopify blog template docs: https://shopify.dev/docs/storefronts/themes/architecture/templates/blog
- Shopify premium theme ecosystem reference: https://themes.shopify.com/themes/exhibit/presets/curate
