# Roadmap: Horizon Kanva Theme Rebuild

## Overview

This roadmap follows the dependency chain surfaced in research: stabilize shared runtime and the editor contract first, build the reusable Kanva primitives on Horizon second, then deliver the requested page work in order across landing, collections, about, and blog. The result is a Kanva-style storefront that stays merchant-editable, avoids hardcoded page clones, and preserves Horizon's stronger collection and blog runtime behavior.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: Stabilization and Editor Contract** - Lock down shared runtime safety, Kanva token rules, and the responsive editor settings contract.
- [ ] **Phase 2: Shared Kanva Primitives** - Build the reusable editorial sections, snippets, and shared styling layer on Horizon.
- [ ] **Phase 3: Landing Page Composition** - Assemble the Kanva homepage from reusable sections and real Shopify content links.
- [ ] **Phase 4: Collection Experience** - Restyle and frame Horizon's native collection runtime for Kanva browsing.
- [ ] **Phase 5: About Page System** - Deliver a modular Kanva about page from reusable storytelling sections.
- [ ] **Phase 6: Blog Curation and Responsive Hardening** - Add the Kanva blog layer and finish cross-page responsive stability for the rebuilt surfaces.

## Phase Details

### Phase 1: Stabilization and Editor Contract
**Goal**: Shared Horizon runtime stays stable while the Kanva rebuild establishes a consistent responsive settings contract for editorial sections.
**Depends on**: Nothing (first phase)
**Requirements**: EDIT-02, EDIT-03, EDIT-05, QUAL-01, QUAL-03
**Success Criteria** (what must be TRUE):
  1. Merchant can configure separate desktop and mobile media on the foundational Kanva editorial surfaces without duplicating the section's content entries.
  2. Merchant can control supported desktop and mobile content positioning through a consistent editor contract with predictable fallback behavior.
  3. Merchant can preview and save the new responsive section settings in the theme editor without broken states or duplicate breakpoint content appearing.
  4. Shopper can continue using existing Horizon header, shared storefront, and high-risk collection or blog runtime flows without regressions after the foundation changes land.
**Plans**: 2 plans
Plans:
- [x] 01-01-PLAN.md - Freeze the responsive editor contract and prove it through a minimal shared media helper in `hero`.
- [x] 01-02-PLAN.md - Add the protected runtime smoke checklist and the lightest executable Theme Check gate.

### Phase 2: Shared Kanva Primitives
**Goal**: Merchants have a reusable Kanva component layer built on Horizon sections, blocks, snippets, and shared styling instead of page-specific clones.
**Depends on**: Phase 1
**Requirements**: EDIT-01, EDIT-04, COMP-01, COMP-02, COMP-03
**Success Criteria** (what must be TRUE):
  1. Merchant can assemble Kanva-style page content from reusable Horizon-based sections and blocks instead of hardcoded page-only templates.
  2. Merchant can reorder, duplicate, and remove the new Kanva sections in the Shopify theme editor without code changes or broken layout behavior.
  3. Shopper sees consistent Kanva heading, spacing, badge, card, and media treatments across the shared editorial modules used by multiple page types.
  4. Shared feature strips, split media or text rows, testimonials, newsletter modules, and social or image grids render through reusable snippets and sections rather than duplicated markup.
**Plans**: 3 plans
Plans:
- [x] 02-01-PLAN.md — Add Kanva design tokens to global stylesheet and create shared heading, badge, and card snippets.
- [x] 02-02-PLAN.md — Create feature strip and testimonial standalone sections.
- [ ] 02-03-PLAN.md — Create newsletter and image grid sections, adapt media-with-content for Kanva story rows.

### Phase 3: Landing Page Composition
**Goal**: Shoppers land on a Kanva-style homepage assembled from reusable Horizon-aligned components and real Shopify content links.
**Depends on**: Phase 2
**Requirements**: HOME-01, HOME-02, HOME-03, HOME-04
**Success Criteria** (what must be TRUE):
  1. Shopper can land on a Kanva-style homepage hero with merchant-managed hero content, slides, and CTA links.
  2. Shopper can see a reusable trust or value strip directly below the hero as part of the homepage composition.
  3. Shopper can discover featured product groups or collections from the homepage through real Shopify collection or product-list sections.
  4. Shopper can see homepage testimonial, newsletter, and social-proof sections that match the Kanva editorial direction.
**Plans**: TBD

### Phase 4: Collection Experience
**Goal**: Collection browsing keeps Horizon's native runtime behavior while gaining Kanva-aligned merchandising and editorial framing.
**Depends on**: Phase 3
**Requirements**: COLL-01, COLL-02, COLL-03
**Success Criteria** (what must be TRUE):
  1. Shopper can browse collection pages with native Horizon filtering, sorting, and pagination behavior still working end to end.
  2. Shopper can see Kanva-aligned collection framing and updated merchandising or card presentation on collection pages.
  3. Merchant can configure collection intro imagery and supporting copy for the Kanva presentation without forking the core collection runtime.
**Plans**: TBD

### Phase 5: About Page System
**Goal**: Merchants can tell the brand story through a modular Kanva about page built from reusable editorial sections.
**Depends on**: Phase 4
**Requirements**: ABOU-01, ABOU-02, ABOU-03
**Success Criteria** (what must be TRUE):
  1. Shopper can view a modular Kanva-style about page built from reusable editorial sections rather than one hardcoded content blob.
  2. Shopper can see the about hero, proof or stats row, story or journey sections, and mission content with consistent Kanva styling.
  3. Merchant can edit the about page's storytelling content, metrics, media, and CTA content directly from the Shopify theme editor.
**Plans**: TBD

### Phase 6: Blog Curation and Responsive Hardening
**Goal**: The Kanva blog experience ships on Horizon's native blog runtime and the rebuilt page set is stable across desktop and mobile.
**Depends on**: Phase 5
**Requirements**: BLOG-01, BLOG-02, BLOG-03, QUAL-02
**Success Criteria** (what must be TRUE):
  1. Shopper can browse a Kanva-style blog index with a featured story surface and a styled article archive below it.
  2. Shopper can use Shopify-native blog or article navigation and tag-based discovery without a custom CMS or taxonomy system.
  3. Merchant can manage featured blog content and supporting editorial copy through theme sections or blog content settings without code changes.
  4. Shopper can use the rebuilt landing, collection, about, and blog pages on desktop and mobile breakpoints with stable layout behavior.
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 -> 2 -> 3 -> 4 -> 5 -> 6

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Stabilization and Editor Contract | 2/2 | Complete |  |
| 2. Shared Kanva Primitives | 0/3 | Not started | - |
| 3. Landing Page Composition | 0/TBD | Not started | - |
| 4. Collection Experience | 0/TBD | Not started | - |
| 5. About Page System | 0/TBD | Not started | - |
| 6. Blog Curation and Responsive Hardening | 0/TBD | Not started | - |
