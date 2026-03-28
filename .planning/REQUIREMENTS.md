# Requirements: Horizon Kanva Theme Rebuild

**Defined:** 2026-03-25
**Core Value:** Merchants can recreate and maintain the Kanva-inspired storefront inside Shopify's theme editor without hardcoded page layouts or mobile compromises.

## v1 Requirements

### Theme Editor

- [ ] **EDIT-01**: Merchant can build the requested Kanva storefront pages from reusable Horizon-based sections and blocks instead of page-specific hardcoded templates
- [ ] **EDIT-02**: Merchant can configure separate desktop and mobile media for art-directed sections without duplicating section content
- [ ] **EDIT-03**: Merchant can control desktop/mobile content positioning for supported editorial sections from the theme editor
- [ ] **EDIT-04**: Merchant can reorder, duplicate, and remove the new Kanva sections in the Shopify theme editor without code changes
- [ ] **EDIT-05**: Merchant sees a consistent responsive-settings contract across the new Kanva sections, using predictable setting names and fallback behavior

### Shared Components

- [ ] **COMP-01**: Merchant can reuse shared Kanva editorial sections for feature strips, split media/text rows, testimonials, newsletter, and social/image grids across multiple page types
- [ ] **COMP-02**: Shopper sees Kanva-aligned shared heading, spacing, badge, and card treatments applied consistently across landing, collections, about, and blog pages
- [ ] **COMP-03**: Shopper sees the rebuilt pages implemented on Horizon primitives and reusable snippets rather than duplicated page-only markup

### Landing Page

- [ ] **HOME-01**: Shopper can land on a Kanva-style homepage with an editorial hero that supports merchant-managed slides or hero content and CTA links
- [ ] **HOME-02**: Shopper can see a reusable trust/value strip below the homepage hero
- [ ] **HOME-03**: Shopper can discover featured product groups or collections from the homepage through real Shopify collection links or product-list sections
- [ ] **HOME-04**: Shopper can see homepage testimonial, newsletter, and social-proof sections that match the Kanva editorial direction

### Collection Experience

- [ ] **COLL-01**: Shopper can browse collection pages with Horizon-native filtering, sorting, and pagination behavior preserved
- [ ] **COLL-02**: Shopper can see Kanva-aligned collection merchandising, including updated card styling and editorial page framing
- [ ] **COLL-03**: Merchant can configure collection intro imagery and supporting copy for Kanva-style collection presentation without forking collection runtime

### About Page

- [ ] **ABOU-01**: Shopper can view a modular Kanva-style about page built from reusable editorial sections instead of a single hardcoded content blob
- [ ] **ABOU-02**: Shopper can see an about-page hero, proof/stats row, story/journey sections, and mission content with consistent Kanva styling
- [ ] **ABOU-03**: Merchant can edit about-page storytelling content, metrics, media, and CTA content directly from the theme editor

### Blog Experience

- [ ] **BLOG-01**: Shopper can browse a Kanva-style blog index with a featured story area and a styled article archive below it
- [ ] **BLOG-02**: Shopper can use Shopify-native blog/article navigation and tag-based discovery without a custom CMS or custom taxonomy system
- [ ] **BLOG-03**: Merchant can manage featured blog content and supporting editorial copy through theme sections or blog content settings without code changes

### Quality and Safety

- [x] **QUAL-01**: Shopper can use existing Horizon header, collection, blog, and shared storefront behavior without regression after the Kanva rebuild is introduced
- [ ] **QUAL-02**: Shopper can use the rebuilt landing, collection, about, and blog pages on desktop and mobile breakpoints with stable layout behavior
- [ ] **QUAL-03**: Merchant can preview and edit the rebuilt sections inside the Shopify theme editor without broken settings states or duplicated breakpoint content

## v2 Requirements

### Editorial Polish

- **POLI-01**: Shopper can interact with a fully custom animated homepage carousel with preview rail and synchronized transitions
- **POLI-02**: Shopper can browse dynamic Instagram or social-feed content sourced from an approved integration
- **POLI-03**: Shopper can see richer editorial blog enhancements such as related articles, author modules, and expanded metadata

### Extended Commerce

- **COMM-01**: Shopper can use wishlist or favorites features integrated into the Kanva experience
- **COMM-02**: Shopper can use enhanced collection quick-add or routine-builder behavior on collection cards
- **COMM-03**: Merchant can build bespoke collection campaign pages that go beyond the shared Kanva section system

## Out of Scope

| Feature | Reason |
|---------|--------|
| Checkout customization | Outside normal Shopify theme scope and not part of the requested storefront rebuild |
| Rebuilding product, cart, account, search, FAQ, contact, favorites, and legal pages in this milestone | The requested delivery order is landing, collections, about, and blog first |
| React, Vite, or SPA rendering for the requested pages | Conflicts with Horizon's OS 2.0 architecture and Shopify editor ergonomics |
| Hardcoded page clones copied directly from `theme-to-clone/*.html` | Would create maintenance debt and bypass reusable Horizon sections/blocks |
| Custom collection filtering system outside Shopify primitives | Horizon already has native collection filtering/sorting behavior that should be preserved |
| Custom blog taxonomy or headless CMS modeling | Shopify blog and tags cover the requested blog scope |
| Live Instagram API dependency in v1 | Adds external dependency and failure modes unrelated to the first milestone |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| EDIT-01 | Phase 2 | Pending |
| EDIT-02 | Phase 1 | Pending |
| EDIT-03 | Phase 1 | Pending |
| EDIT-04 | Phase 2 | Pending |
| EDIT-05 | Phase 1 | Pending |
| COMP-01 | Phase 2 | Pending |
| COMP-02 | Phase 2 | Pending |
| COMP-03 | Phase 2 | Pending |
| HOME-01 | Phase 3 | Pending |
| HOME-02 | Phase 3 | Pending |
| HOME-03 | Phase 3 | Pending |
| HOME-04 | Phase 3 | Pending |
| COLL-01 | Phase 4 | Pending |
| COLL-02 | Phase 4 | Pending |
| COLL-03 | Phase 4 | Pending |
| ABOU-01 | Phase 5 | Pending |
| ABOU-02 | Phase 5 | Pending |
| ABOU-03 | Phase 5 | Pending |
| BLOG-01 | Phase 6 | Pending |
| BLOG-02 | Phase 6 | Pending |
| BLOG-03 | Phase 6 | Pending |
| QUAL-01 | Phase 1 | Complete |
| QUAL-02 | Phase 6 | Pending |
| QUAL-03 | Phase 1 | Pending |

**Coverage:**
- v1 requirements: 24 total
- Mapped to phases: 24
- Unmapped: 0

---
*Requirements defined: 2026-03-25*
*Last updated: 2026-03-25 after roadmap creation*
