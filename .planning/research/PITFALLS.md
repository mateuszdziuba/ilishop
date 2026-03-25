# Domain Pitfalls

**Domain:** Custom Shopify theme rebuild on Horizon for a Kanva-style storefront
**Researched:** 2026-03-25
**Overall confidence:** MEDIUM-HIGH

## Critical Pitfalls

### Pitfall 1: Static Clone Implementation Instead of Horizon-Native Composition
**What goes wrong:** The team ports `theme-to-clone/` page HTML/CSS too literally into page-specific sections or templates, producing one-off markup that visually matches initially but bypasses Horizon's block/section composition model.
**Why it happens:** Visual fidelity pressure is high, the reference has heavy layout differences, and direct copying feels faster than mapping the design into reusable section and block primitives.
**Consequences:** Repeated markup across home/about/blog/collection surfaces, poor editor reusability, expensive change propagation, and a second design system living beside Horizon instead of on top of it.
**Warning signs:**
- New page sections contain large copied HTML fragments from `theme-to-clone/`.
- Similar cards, headings, media rows, or CTA patterns are reimplemented separately per page.
- Templates solve layout differences with page-specific CSS selectors instead of shared primitives.
- Merchant-requested changes require edits in multiple sections/snippets.
**Prevention:** Create a design-token and component-mapping phase first. Start by inventorying repeated Kanva patterns and decide which become sections, theme blocks, and snippets. Prefer extending existing Horizon composition points like `content_for 'blocks'` and existing block patterns over adding page-only markup.
**Detection:** If two planned page phases need the same visual pattern and the implementation plan does not mention a shared primitive, the roadmap is already drifting.
**Phase should address it:** Phase 1 foundation architecture and design-system mapping, before any page rebuild phase.

### Pitfall 2: Theme Editor Control Explosion for Mobile/Desktop Art Direction
**What goes wrong:** Separate desktop/mobile image, alignment, spacing, and positioning controls get added ad hoc to each section until schema becomes large, inconsistent, and hard for merchants to reason about.
**Why it happens:** Shopify settings are easy to add, and the brief explicitly asks for mobile/desktop-specific controls. Without a control taxonomy, every section invents its own settings names and behavior.
**Consequences:** Merchant confusion, inconsistent editor UX, bloated schema, duplicated Liquid branching, and more states to test. This is especially dangerous because Shopify section settings are the long-term maintenance interface.
**Warning signs:**
- Similar concepts use different setting IDs or scales across sections.
- Sections expose many low-level numeric controls rather than a small set of art-direction options.
- Desktop/mobile behavior is implemented with multiple booleans instead of a defined pattern.
- Block titles in the editor are generic because schemas omit good `heading`/`title`/`text` identifiers.
**Prevention:** Standardize a responsive control contract up front: naming, defaults, acceptable ranges, fallback behavior, and when a separate mobile setting is allowed. Use presets and predictable setting IDs so blocks remain understandable in the editor. Only expose controls merchants can actually use safely; derive the rest from CSS tokens.
**Detection:** Review schemas before implementation for settings count, naming consistency, and whether the editor UI would still be understandable to a merchant after six months.
**Phase should address it:** Phase 1 editor-model design, then enforced in every section/block implementation phase.

### Pitfall 3: Overusing Per-Breakpoint Markup Instead of Shared Content With Style Variants
**What goes wrong:** Desktop and mobile variants are rendered as separate markup trees or duplicated blocks to achieve different art direction.
**Why it happens:** It is tempting to solve visual divergence by duplicating DOM and hiding one version with CSS, especially for hero and editorial sections.
**Consequences:** Content drift between breakpoints, duplicate accessibility/SEO surfaces, larger DOM, harder QA, and more bug-prone editor state because merchants may edit only one branch.
**Warning signs:**
- Sections render two copies of the same heading/body/button content.
- Mobile and desktop each get their own blocks for the same conceptual content.
- QA defects appear where only one breakpoint reflects a content update.
**Prevention:** Keep content singular and separate art direction from content whenever possible. Use separate image pickers only when imagery truly differs by breakpoint; keep text, CTA, and semantic structure shared. Reserve duplicated markup for cases where layout cannot be achieved accessibly with CSS.
**Detection:** During PR review, ask whether the same merchant content exists in more than one schema field or rendered node tree.
**Phase should address it:** Phase 1 responsive architecture rules and Phase 2 implementation of the first art-directed sections.

### Pitfall 4: JS Regression Blast Radius From Touching Fragile Horizon Surfaces
**What goes wrong:** Rebuild work accidentally breaks cart, predictive search, section rendering, header behavior, or collection filtering because the theme's runtime is already broad and fragile.
**Why it happens:** Horizon ships many globally loaded modules, large custom-element surfaces, duplicated header logic, and known defects in `assets/section-renderer.js`; the repo also has no automated tests.
**Consequences:** Revenue-impacting regressions outside the rebuilt pages, hard-to-reproduce failures in the editor or storefront, and slower implementation because every UI change requires broad manual verification.
**Warning signs:**
- New sections depend on existing global JS without explicit regression checks.
- Page work requires edits in `snippets/scripts.liquid`, `assets/utilities.js`, `assets/section-renderer.js`, or header runtime code.
- Fixes rely on trial-and-error in the browser because no smoke coverage exists.
- Section fetch/caching issues appear while building collection/blog interactions.
**Prevention:** Before major rebuild work, add a minimal regression harness for high-risk flows: cart add/update, collection filters, predictive search, header states, and section rendering failure recovery. Isolate new page behavior so it does not require broad modifications to global scripts unless necessary.
**Detection:** Any phase touching shared runtime files should be blocked until its regression surface and manual/automated verification steps are written down.
**Phase should address it:** Phase 0 or Phase 1 test harness and stabilization, before collection/blog work and before any refactor of global runtime code.

### Pitfall 5: CSS Token Drift and Specificity Wars
**What goes wrong:** Kanva styling is layered on top of Horizon with one-off selectors, page-specific overrides, and arbitrary spacing/color values until the theme becomes difficult to reason about.
**Why it happens:** Heavy visual differences create pressure to override existing Horizon styles quickly rather than defining a coherent token layer and component variants.
**Consequences:** Fragile styling, inconsistent spacing and typography, hard-to-maintain responsive behavior, and regressions when shared components are reused on another page.
**Warning signs:**
- CSS additions reference page/template selectors more than shared component classes.
- Similar colors, radii, and spacing values are repeated with slight variations.
- Desktop/mobile overrides accumulate in multiple files for the same component.
- Matching the reference requires repeated `!important`, deep selectors, or layout hacks.
**Prevention:** Define a Kanva token layer first: typography scale, spacing, colors, radii, container widths, and responsive rules. Then adapt Horizon components to consume those tokens. Treat CSS architecture as a prerequisite, not cleanup.
**Detection:** If new UI work cannot describe which token or component variant it uses, styling is likely drifting.
**Phase should address it:** Phase 1 design-token and CSS architecture work, before page builds.

### Pitfall 6: Collection and Blog Rebuilds Coupled Too Early to Dynamic Data Behavior
**What goes wrong:** The team tries to fully reproduce target layouts and interactions for shop/blog while simultaneously changing filtering, pagination, featured article logic, and section-rendered updates.
**Why it happens:** Collection and blog pages look straightforward visually, but in Shopify they sit on top of dynamic data, pagination, filters, and progressive enhancement already wired into Horizon.
**Consequences:** Scope creep, regressions in search/filter behavior, and rebuild phases that stall because visual work and behavioral work are mixed together.
**Warning signs:**
- Collection UI changes require concurrent edits to `assets/facets.js`, `assets/results-list.js`, and section markup.
- Blog layout work introduces custom pagination or AJAX behavior before static composition is stable.
- The roadmap treats collection/blog as pure template styling work.
**Prevention:** Split visual composition from interactive behavior. First reproduce static layout using existing Horizon data/rendering flow. Only then adapt filters, pagination, and featured-content behavior. Keep home/about phases ahead of collection/blog only if shared primitives are already extracted.
**Detection:** If a collection/blog phase plan mixes schema design, markup rebuild, filtering refactor, and JS behavior changes together, it is too large.
**Phase should address it:** Separate collection/blog into two phases each if needed: layout first, dynamic behavior second.

## Moderate Pitfalls

### Pitfall 7: Merchant-Unfriendly Nested Block Structures
**What goes wrong:** Components are technically reusable but deeply nested, hard to locate in the theme editor, and difficult for merchants to reorder safely.
**Why it happens:** Horizon supports nested block composition, and developers may optimize for implementation purity over editor ergonomics.
**Consequences:** Merchant confusion, increased training/support burden, and reluctance to reuse components because editing them feels risky.
**Warning signs:**
- Common tasks require drilling through several nested blocks to change simple content.
- Block titles in the editor are generic or repeated.
- App block placement becomes awkward inside nested structures.
**Prevention:** Design for editor navigation, not only render composition. Use meaningful block titles, keep nesting shallow where merchants interact often, and reserve deeper structures for purely internal layout helpers.
**Detection:** Test critical editing tasks in the Shopify editor before merging a new section family.
**Phase should address it:** Phase 1 editor UX rules, plus every component implementation phase.

### Pitfall 8: Section Schema and Preset Instability
**What goes wrong:** Setting IDs, block types, or presets change repeatedly during implementation, breaking existing JSON templates or forcing reconfiguration.
**Why it happens:** Teams iterate quickly on section APIs without treating schema as a stable contract.
**Consequences:** Template churn, migration pain, broken merchant content, and avoidable rework late in the milestone.
**Warning signs:**
- Planned sections do not define a stable schema contract before coding.
- Developers rename setting IDs casually after content has been entered.
- JSON templates become volatile across phases.
**Prevention:** Version section APIs mentally like public interfaces. Freeze core IDs early, use additive changes where possible, and introduce presets only after the primitive is stable enough to persist.
**Detection:** If schema diffs frequently rename existing IDs instead of adding new settings, stability is low.
**Phase should address it:** Phase 1 schema design and Phase 2 first-page implementation review.

### Pitfall 9: Asset Strategy That Ignores Shopify Media Constraints
**What goes wrong:** Large desktop/mobile imagery and decorative assets are added without considering crop behavior, focal points, file size, and how merchants will replace them later.
**Why it happens:** The reference design depends heavily on editorial imagery and art direction.
**Consequences:** Poor mobile performance, inconsistent crops, and merchant frustration when replacement assets do not behave like the originals.
**Warning signs:**
- Sections assume fixed aspect ratios that merchant uploads will not match.
- Mobile assets are optional in schema but there is no documented fallback behavior.
- Decorative imagery is baked into code rather than editor-manageable.
**Prevention:** Define media rules per component: expected aspect ratios, fallback logic, focal-point handling, and whether desktop/mobile images are required or optional. Validate the first real merchant asset set, not only reference images.
**Detection:** Test each media-heavy section with mismatched aspect ratios and only-one-breakpoint image populated.
**Phase should address it:** Phase 1 media contract definition and Phase 2 hero/editorial component implementation.

## Minor Pitfalls

### Pitfall 10: Reference-Only Fidelity Reviews With No Merchant Workflow Review
**What goes wrong:** Work is approved because it matches screenshots, but the merchant cannot efficiently build or maintain pages in the editor.
**Why it happens:** Visual comparison is easier than editor workflow testing.
**Consequences:** Late rework when content operations start, especially around reusable sections and breakpoint-specific controls.
**Warning signs:**
- Acceptance criteria mention visual parity but not editor tasks.
- No one tests section duplication, reordering, preset usage, or breakpoint-specific content changes.
**Prevention:** Add editor workflow acceptance criteria to every page phase.
**Detection:** A review checklist that does not include merchant editing tasks is incomplete.
**Phase should address it:** Every delivery phase, starting with the first reusable section.

### Pitfall 11: Underestimating Manual QA Matrix
**What goes wrong:** The team assumes "page complete" means desktop and mobile storefront views only.
**Why it happens:** Shopify theme work spans storefront, theme editor, dynamic section rendering, and cross-template shared components.
**Consequences:** Bugs survive until merchant testing, especially in design mode, empty states, and content combinations.
**Warning signs:**
- QA steps do not distinguish storefront vs theme editor.
- Testing ignores empty/partial content, unpublished images, and long text.
- Collection/blog verification omits filters, pagination, and no-results states.
**Prevention:** Define a repeatable QA matrix per phase: desktop, mobile, theme editor, empty state, long-content state, and shared-component regression checks.
**Detection:** If QA evidence is a few screenshots rather than a scenario list, coverage is insufficient.
**Phase should address it:** Phase 0/1 verification framework, then all execution phases.

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|---------------|------------|
| Foundation / stabilization | Skipping tests and runtime audit because "this is mostly front-end" | Add smoke coverage and manual regression scripts for cart, header, filters, predictive search, and section rendering before broad theme changes |
| Design system / primitives | Building page sections before tokens and shared components are defined | Freeze a Kanva token layer and primitive inventory first |
| Editor model | Adding mobile/desktop controls opportunistically per section | Define one responsive settings contract and naming convention before schema work |
| Home page | Solving hero/carousel fidelity with duplicated desktop/mobile markup | Keep content singular; use separate media only where art direction truly differs |
| Collections | Mixing layout rebuild with filter/runtime refactor in one phase | Implement static layout on current behavior first, then adapt dynamic behavior in a later phase |
| About / editorial sections | Recreating each storytelling row as one-off markup | Extract alternating media-text, stats, quote, and feature-strip primitives first |
| Blog | Rebuilding cards/list/featured article independently | Create a single editorial card/content system reused across blog surfaces |
| Final hardening | Accepting screenshot parity without merchant workflow validation | Run theme-editor usability review and regression matrix before milestone close |

## Roadmap Implications

Recommended mitigation order:

1. **Stabilization and verification**
   - Add minimal smoke coverage and manual regression scripts around existing fragile JS surfaces.
   - Fix or at least document known shared-runtime defects that page work will lean on.

2. **Design system and editor contract**
   - Define Kanva tokens, reusable primitives, schema naming, and responsive art-direction rules.
   - Decide when to use sections, theme blocks, and snippets before page implementation begins.

3. **Shared editorial and commerce primitives**
   - Build hero, card, media-text, feature-strip, quote, newsletter, and editorial-list primitives first.
   - Validate editor ergonomics with merchants or proxy QA early.

4. **Page implementation in priority order**
   - Home first, then collections, then about, then blog.
   - For collections/blog, split visual composition from dynamic behavior if the phase scope grows.

5. **Hardening**
   - Run storefront plus theme-editor regression passes.
   - Confirm reusable sections survive duplication, reordering, and partial content states.

## Sources

- Local project requirements: `/Users/mati/Mine/horizon/.planning/PROJECT.md` (HIGH confidence)
- Local codebase concerns: `/Users/mati/Mine/horizon/.planning/codebase/CONCERNS.md` (HIGH confidence)
- Local testing analysis: `/Users/mati/Mine/horizon/.planning/codebase/TESTING.md` (HIGH confidence)
- Local conventions: `/Users/mati/Mine/horizon/.planning/codebase/CONVENTIONS.md` (HIGH confidence)
- Visual target notes: `/Users/mati/Mine/horizon/theme-to-clone/kanva-docs.md` (HIGH confidence)
- Shopify section schema docs: https://shopify.dev/docs/storefronts/themes/architecture/sections/section-schema (MEDIUM-HIGH confidence)
- Shopify input settings docs: https://shopify.dev/docs/storefronts/themes/architecture/settings/input-settings (MEDIUM confidence)
- Shopify theme blocks schema docs: https://shopify.dev/docs/storefronts/themes/architecture/blocks/theme-blocks/schema (MEDIUM confidence)
- Shopify editor integration best practices: https://shopify.dev/docs/storefronts/themes/best-practices/editor/integrate-sections-and-blocks (MEDIUM-HIGH confidence)
