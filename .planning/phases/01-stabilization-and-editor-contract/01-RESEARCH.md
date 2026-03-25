# Phase 1: Stabilization and Editor Contract - Research

**Researched:** 2026-03-25
**Domain:** Shopify OS 2.0 theme stabilization and responsive editor contract design
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
## Implementation Decisions

### Responsive editor contract
- **D-01:** New Kanva sections use a shared pattern of `desktop default + optional mobile override`, not two fully separate content trees.
- **D-02:** Separate mobile settings are allowed only for media and layout-position concerns that materially change by breakpoint; text content, CTA content, and semantic structure stay shared.
- **D-03:** Setting names and behavior should follow existing Horizon patterns where possible, especially the `custom_mobile_media` approach already present in [`sections/hero.liquid`](/Users/mati/Mine/horizon/sections/hero.liquid).
- **D-04:** Phase 1 should define predictable fallback behavior for all responsive settings before any new Kanva section ships.

### Media fallback rules
- **D-05:** Desktop media is the default source of truth; mobile media is an override, not a required duplicate.
- **D-06:** When mobile-specific media is not populated, the section must fall back cleanly to desktop media rather than rendering empty space or duplicate markup.
- **D-07:** Phase 1 must define the allowed media-control surface for later sections: separate desktop/mobile media, supported position controls, and any mobile stack toggle only where layout genuinely changes.
- **D-08:** The project should prefer shared media-rendering helpers over section-by-section bespoke fallback logic.

### Runtime safety and verification
- **D-09:** Phase 1 includes a minimal but explicit regression checklist for Horizon's fragile shared surfaces before page-level Kanva work expands.
- **D-10:** The regression surface must include header behavior, section rendering, collection filtering/sorting/pagination, and blog/archive behavior because later phases depend on those paths.
- **D-11:** The first goal is the lightest viable verification harness that catches regressions early; this phase should not turn into a large testing-program rewrite.
- **D-12:** Changes to fragile shared runtime files should be minimized in Phase 1 unless they are directly required to support the responsive editor contract or to stabilize a known blocker.

### Horizon reuse boundary
- **D-13:** Horizon remains the implementation baseline for responsive media, section wrappers, collection runtime, and blog runtime.
- **D-14:** Phase 1 should inventory and document which Horizon primitives later Kanva phases must reuse first, rather than allowing page phases to choose ad hoc.
- **D-15:** The foundation contract should block page-specific clone markup and prevent per-section schema drift before any Kanva page composition begins.

### the agent's Discretion
- Exact file layout for the Phase 1 artifacts, as long as the shared contract is clear and downstream phases can consume it
- Whether the regression harness is documented as scripts, checklist artifacts, lightweight automated checks, or a hybrid
- The minimum set of helper snippets or schema abstractions needed to make the contract enforceable

### Deferred Ideas (OUT OF SCOPE)
## Deferred Ideas

- Exact Kanva section inventory belongs to Phase 2, once the editor contract is frozen
- Landing-page composition work belongs to Phase 3
- Collection framing and card restyling belong to Phase 4
- About-page storytelling assembly belongs to Phase 5
- Featured blog curation and final responsive hardening belong to Phase 6
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| EDIT-02 | Merchant can configure separate desktop and mobile media for art-directed sections without duplicating section content | Shared `desktop default + optional mobile override` contract, shared fallback helper, blank-check rules, and mobile media naming guidance |
| EDIT-03 | Merchant can control desktop/mobile content positioning for supported editorial sections from the theme editor | Reuse Horizon position/alignment vocabulary from `sections/section.liquid`; scope mobile overrides to layout-position only |
| EDIT-05 | Merchant sees a consistent responsive-settings contract across the new Kanva sections, using predictable setting names and fallback behavior | Prescriptive contract table, artifact boundary for shared schema/helper, and anti-drift rules for later sections |
| QUAL-01 | Shopper can use existing Horizon header, collection, blog, and shared storefront behavior without regression after the Kanva rebuild is introduced | Protected runtime inventory, minimal smoke harness, and recommendation to avoid deep runtime edits in Phase 1 |
| QUAL-03 | Merchant can preview and edit the rebuilt sections inside the Shopify theme editor without broken settings states or duplicated breakpoint content | Use `visible_if` only where Shopify supports it, preserve single-content-tree model, account for theme-editor re-render behavior |
</phase_requirements>

## Summary

Phase 1 should not invent a new responsive system. Horizon already has the two ingredients the Kanva rebuild needs: a reusable mobile-override pattern in [`sections/hero.liquid`](/Users/mati/Mine/horizon/sections/hero.liquid#L1) and a reusable layout vocabulary in [`sections/section.liquid`](/Users/mati/Mine/horizon/sections/section.liquid#L25). The planning target is to extract those into a single contract that later editorial sections must consume, not reinterpret.

The contract should be narrow. Desktop stays canonical; mobile is an opt-in override for media and layout-position only. Text, CTA copy, semantic structure, and block trees remain shared. In the current code, the hero already proves the key fallback behavior: mobile settings can exist, but if mobile media is disabled or blank, desktop media is still rendered on mobile instead of leaving an empty slot ([`sections/hero.liquid`](/Users/mati/Mine/horizon/sections/hero.liquid#L88)). That is the pattern to standardize.

For safety, the repo is not ready for broad refactoring. There is no existing test framework in the theme, but `shopify theme check` is available locally and the codebase already exposes stable selectors such as `data-testid`, `results-list`, and `blog-posts-list`. The right Phase 1 verification target is a hybrid: keep automated checking minimal, then add a short manual smoke checklist for header offsets, generic section rendering, collection runtime, and blog runtime.

**Primary recommendation:** Plan Phase 1 around one shared responsive schema/render contract, one artifact that inventories mandatory Horizon primitives to reuse, and one lightweight regression harness built from `shopify theme check` plus a protected-surface smoke checklist.

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Shopify Online Store 2.0 theme architecture | Platform | Sections, blocks, snippets, JSON-template composition | Native merchant-editable model for this theme and required by Horizon reuse |
| Shopify section schema settings | Current docs checked 2026-03-25 | Define editor settings, `visible_if`, block support, presets, template availability | Official contract for editor ergonomics and section reuse |
| Shopify CLI | 3.91.0 detected locally on 2026-03-25 | Local linting, theme workflow, `shopify theme check` | Already available in the environment; lowest-friction verification entry point |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Theme Check via `shopify theme check` | Bundled with local Shopify CLI 3.91.0 | Static analysis for Liquid/theme issues | Per task commit and before phase completion |
| Theme editor `visible_if` support | Available in current Shopify docs; conditional settings shipped 2025-05 | Hide irrelevant controls while preserving values | For the shared responsive contract, but only on supported setting types |
| Liquid `image_picker` + `image_tag` focal-point behavior | Current docs checked 2026-03-25 | Merchant-managed art direction with focal point preservation | For desktop/mobile image settings in editorial sections |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Shared mobile-override contract | Per-section bespoke responsive schemas | Faster per section, but guarantees schema drift and inconsistent fallback behavior |
| `shopify theme check` + smoke checklist | Full browser test harness in Phase 1 | More coverage, but too much setup for a stabilization-only phase |
| Shared helper/snippet boundary | Inline fallback logic in each new section | Simpler short-term, but later phases will duplicate bug-prone media logic |

**Installation:**
```bash
shopify version
shopify theme check
```

**Version verification:** Local environment check on 2026-03-25 detected `shopify version` = `3.91.0`. `theme-check` is not installed as a standalone binary in this workspace; use `shopify theme check`.

## Architecture Patterns

### Recommended Project Structure
```text
sections/
├── hero.liquid                     # Canonical responsive media override reference
├── section.liquid                  # Canonical layout/alignment vocabulary
├── main-collection.liquid          # Protected collection runtime
└── main-blog.liquid                # Protected blog runtime
snippets/
├── section.liquid                  # Shared wrapper render path
├── background-media.liquid         # Shared background media render path
└── <phase-1 responsive helper>     # Shared contract/fallback authority for later Kanva sections
.planning/phases/01-stabilization-and-editor-contract/
├── 01-CONTEXT.md
├── 01-RESEARCH.md
└── <phase-1 contract + smoke artifacts>
```

### Pattern 1: Desktop Canonical, Mobile Optional Override
**What:** Model responsive editorial settings as `desktop default + optional mobile override`. Mobile fields exist only when a section materially changes by breakpoint.
**When to use:** Any Kanva editorial section with art-directed imagery, breakpoint-specific media positioning, or mobile stacking differences.
**Example:**
```liquid
{% liquid
  assign fallback_to_desktop = false
  if section.settings.custom_mobile_media == false or media_count_mobile == 0 or media_count == 0
    assign media_count_mobile = media_count
    assign fallback_to_desktop = true
  endif
%}
```
Source: [`sections/hero.liquid`](/Users/mati/Mine/horizon/sections/hero.liquid#L88)

### Pattern 2: Shared Layout Vocabulary, Not New Per-Section Names
**What:** Reuse Horizon’s existing layout language for direction, alignment, position, width, and mobile stacking.
**When to use:** Any editorial section that needs merchant-facing positioning controls.
**Example:**
```json
{
  "type": "checkbox",
  "id": "vertical_on_mobile",
  "visible_if": "{{ section.settings.content_direction == 'row' }}"
}
```
Source: [`sections/section.liquid`](/Users/mati/Mine/horizon/sections/section.liquid#L46)

### Pattern 3: Render Through Shared Wrappers
**What:** Keep layout wrapper concerns in shared snippets and pass section settings through them.
**When to use:** All new editorial sections unless there is a proven need to bypass the wrapper.
**Example:**
```liquid
{% render 'section', section: section, children: children %}
```
Source: [`sections/section.liquid`](/Users/mati/Mine/horizon/sections/section.liquid#L1)

### Pattern 4: Preserve Protected Runtime Engines
**What:** Treat collection and blog sections as engines to wrap and style, not replace.
**When to use:** Any later phase that touches collection/blog presentation.
**Example:**
```liquid
<results-list section-id="{{ section.id }}" infinite-scroll="{{ section.settings.enable_infinite_scroll }}">
```
Source: [`sections/main-collection.liquid`](/Users/mati/Mine/horizon/sections/main-collection.liquid#L25)

### Anti-Patterns to Avoid
- **Separate desktop/mobile content trees:** Violates locked decisions and creates duplicate editorial content states.
- **Page-specific setting names for the same responsive concept:** Makes `EDIT-05` fail before Phase 2 starts.
- **Direct edits to header, section renderer, collection JS, or blog runtime without a regression gate:** The repo already documents those areas as fragile.
- **Using unsupported `visible_if` assumptions:** Shopify supports conditional settings only for all basic/sidebar settings and a defined subset of specialized settings; conditions also cannot inspect resolved dynamic-source data.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Responsive media fallback | Section-specific `if mobile else desktop` branches everywhere | One shared helper/snippet or schema contract authority based on the current hero logic | Prevents inconsistent blank handling and markup duplication |
| Editorial layout control vocabulary | New ad hoc controls like `mobile_text_side`, `desktop_media_anchor`, `phone_layout_mode` per section | Reuse `content_direction`, alignment, position, and mobile stacking language from `sections/section.liquid` | Keeps editor ergonomics coherent across sections |
| Collection/blog reimplementation | New Kanva-specific collection/blog engines | Existing `main-collection` and `main-blog` sections plus surrounding styling/composition | Those files already own filtering, pagination, and archive behavior |
| Full test suite setup in Phase 1 | Playwright/Vitest/Jest rollout | `shopify theme check` plus short manual smoke checklist | Meets Phase 1 safety goal with lower setup cost |

**Key insight:** The expensive failure mode here is not missing one helper. It is allowing every later section to encode its own responsive rules and verification assumptions.

## Common Pitfalls

### Pitfall 1: Hidden Setting Values Still Exist
**What goes wrong:** Merchants switch a media type or disable mobile overrides, but old values remain stored and can accidentally affect rendering if Liquid only checks picker presence.
**Why it happens:** Shopify hides fields with `visible_if`, but hidden values are preserved.
**How to avoid:** Copy Horizon hero’s two-part checks: confirm both the picker value and the active media-type selector before rendering.
**Warning signs:** Sections render the wrong media after toggling image/video modes in the editor.

### Pitfall 2: Contract Drift Through “Small” Naming Differences
**What goes wrong:** Later sections implement the same concept with different IDs or opposite defaults.
**Why it happens:** The repo has no enforced shared contract yet, so teams optimize locally.
**How to avoid:** Phase 1 should produce a canonical naming table and require later phases to reuse it.
**Warning signs:** Similar sections expose `mobile_media`, `custom_mobile_media`, and `override_mobile_image` for the same behavior.

### Pitfall 3: Theme Editor Re-Renders Don’t Replay Page-Load JS
**What goes wrong:** A section looks correct on full page load but breaks after add/remove/select operations in the theme editor.
**Why it happens:** Shopify re-renders section HTML into the existing DOM without rerunning unrelated page-load scripts.
**How to avoid:** Keep Phase 1 helpers Liquid-first where possible, and include theme-editor preview/edit smoke steps in the regression harness.
**Warning signs:** Controls work on first load but fail after section reorder, duplicate, or setting toggle in editor preview.

### Pitfall 4: Header Offset Regressions From Shared Runtime Drift
**What goes wrong:** Transparent header offsets or first-section spacing break after touching shared wrappers.
**Why it happens:** Header height logic is duplicated between [`layout/theme.liquid`](/Users/mati/Mine/horizon/layout/theme.liquid#L64) and [`assets/utilities.js`](/Users/mati/Mine/horizon/assets/utilities.js#L744).
**How to avoid:** Treat header smoke coverage as mandatory whenever Phase 1 modifies wrapper or first-section behavior.
**Warning signs:** First section jumps under the header, preview mode spacing differs, or transparent header behavior changes by template.

## Code Examples

Verified patterns from official sources and current Horizon code:

### Conditional Settings on Supported Inputs
```json
{
  "type": "select",
  "id": "content_direction",
  "default": "column",
  "visible_if": "{{ block.settings.layout_style == 'flex' }}"
}
```
Source: Shopify settings docs, conditional settings section: https://shopify.dev/docs/storefronts/themes/architecture/settings

### Blank-Check Before Using Resource-Based Settings
```liquid
{% if settings.page != blank %}
  {{ settings.page.title }}
{% endif %}
```
Source: Shopify settings docs, usage section: https://shopify.dev/docs/storefronts/themes/architecture/settings

### Shared Wrapper Rendering Path
```liquid
{% capture children %}
  {% content_for 'blocks' %}
{% endcapture %}

{% render 'section', section: section, children: children %}
```
Source: [`sections/section.liquid`](/Users/mati/Mine/horizon/sections/section.liquid#L1)

### Shared Background Media Boundary
```liquid
{% render 'background-media',
  background_media: section.settings.background_media,
  background_video: section.settings.video,
  background_video_position: section.settings.video_position,
  background_image: section.settings.background_image,
  background_image_position: section.settings.background_image_position
%}
```
Source: [`snippets/section.liquid`](/Users/mati/Mine/horizon/snippets/section.liquid#L31)

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Large static Liquid templates or hardcoded clones | JSON-template-driven sections and blocks with editor-managed settings | OS 2.0 era; current docs checked 2026-03-25 | Supports merchant reordering and reuse |
| Always-visible settings panels with dead controls | `visible_if` conditional settings on supported setting types | Shopify changelog 2025-05; docs checked 2026-03-25 | Cleaner editor UX without discarding saved values |
| Separate mobile/desktop content copies for art direction | Shared content with mobile media/layout overrides only | Current Horizon hero pattern | Lower duplication and more stable editor state |

**Deprecated/outdated:**
- Hardcoded page clones from `theme-to-clone/`: conflicts with Shopify editor composition and the project’s locked Horizon-first boundary.
- Standalone `theme-check` dependency assumption: not valid in this workspace; use `shopify theme check`.

## Open Questions

1. **Should the shared contract land as a snippet helper, a schema fragment convention, or both?**
   - What we know: Shared render boundaries already exist in [`snippets/section.liquid`](/Users/mati/Mine/horizon/snippets/section.liquid#L1) and [`snippets/background-media.liquid`](/Users/mati/Mine/horizon/snippets/background-media.liquid#L1).
   - What's unclear: Whether later sections need executable shared Liquid for media fallback, or whether a documented schema contract is enough for Phase 1.
   - Recommendation: Plan for both a written contract artifact and one minimal shared helper if implementation reveals repeated fallback branching.

2. **How much of the protected runtime smoke checklist can be automated in Phase 1 without stalling delivery?**
   - What we know: `shopify theme check` runs locally today; no browser test framework exists.
   - What's unclear: Whether the planner should add a tiny script wrapper or keep the smoke harness entirely documented/manual.
   - Recommendation: Keep automation to lint/static checks in Phase 1 and treat storefront-path verification as a manual checklist artifact.

3. **Which later-phase sections genuinely need mobile position overrides instead of CSS-only adaptation?**
   - What we know: Locked decisions allow mobile overrides only where layout materially changes.
   - What's unclear: The exact section set is deferred to Phase 2.
   - Recommendation: Use Phase 1 to define the allowed override categories, not to prebuild every future variant.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Shopify CLI Theme Check via `shopify theme check` |
| Config file | none - existing default config |
| Quick run command | `shopify theme check --fail-level error` |
| Full suite command | `shopify theme check` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| EDIT-02 | Mobile media overrides fall back cleanly to desktop media when blank/disabled | manual smoke + static lint | `shopify theme check --fail-level error` | ✅ command / ❌ dedicated test |
| EDIT-03 | Editorial sections expose consistent desktop/mobile position controls without duplicate content trees | manual editor smoke + static lint | `shopify theme check --fail-level error` | ✅ command / ❌ dedicated test |
| EDIT-05 | New sections reuse one responsive settings vocabulary | review checklist + static lint | `shopify theme check --fail-level error` | ✅ command / ❌ dedicated test |
| QUAL-01 | Header, collection, blog, and shared storefront surfaces remain stable | manual smoke | `shopify theme check` | ✅ command / ❌ dedicated test |
| QUAL-03 | Theme editor preview/edit flows remain stable across setting toggles and section operations | manual editor smoke | `shopify theme check --fail-level error` | ✅ command / ❌ dedicated test |

### Sampling Rate
- **Per task commit:** `shopify theme check --fail-level error`
- **Per wave merge:** `shopify theme check`
- **Phase gate:** `shopify theme check` plus protected-surface manual smoke checklist green before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] Add a Phase 1 protected-surface smoke checklist artifact covering header, generic section wrapper, collection filtering/sorting/pagination, and blog archive rendering
- [ ] Add a short contract artifact that maps canonical responsive setting IDs, defaults, and fallback rules for later sections
- [ ] Decide whether to add a tiny wrapper command/script for the smoke checklist; no browser runner exists today
- [ ] Baseline current `shopify theme check` offenses so Phase 1 work can avoid hiding new issues inside existing noise

## Sources

### Primary (HIGH confidence)
- Shopify settings docs - conditional settings support, blank/resource checks, dynamic source constraints: https://shopify.dev/docs/storefronts/themes/architecture/settings
- Shopify sections docs - section/block limits, JSON-template preference, theme editor re-render behavior: https://shopify.dev/docs/storefronts/themes/architecture/sections
- Shopify input settings docs - `image_picker` behavior and focal-point guidance: https://shopify.dev/docs/storefronts/themes/architecture/settings/input-settings

### Secondary (MEDIUM confidence)
- [`sections/hero.liquid`](/Users/mati/Mine/horizon/sections/hero.liquid) - current responsive media override and desktop fallback implementation
- [`sections/section.liquid`](/Users/mati/Mine/horizon/sections/section.liquid) - current shared layout/alignment vocabulary and conditional settings usage
- [`snippets/section.liquid`](/Users/mati/Mine/horizon/snippets/section.liquid) - current wrapper render path and visual preview handling
- [`snippets/background-media.liquid`](/Users/mati/Mine/horizon/snippets/background-media.liquid) - current shared background media rendering path
- [`sections/main-collection.liquid`](/Users/mati/Mine/horizon/sections/main-collection.liquid) - protected collection runtime surface
- [`sections/main-blog.liquid`](/Users/mati/Mine/horizon/sections/main-blog.liquid) - protected blog runtime surface
- [`layout/theme.liquid`](/Users/mati/Mine/horizon/layout/theme.liquid) and [`assets/utilities.js`](/Users/mati/Mine/horizon/assets/utilities.js) - duplicated header offset logic that raises regression risk
- [`/Users/mati/Mine/horizon/.planning/codebase/CONCERNS.md`](/Users/mati/Mine/horizon/.planning/codebase/CONCERNS.md) - shared runtime fragility and test coverage gaps
- [`/Users/mati/Mine/horizon/.planning/research/SUMMARY.md`](/Users/mati/Mine/horizon/.planning/research/SUMMARY.md) - project-level architecture and phase-ordering rationale

### Tertiary (LOW confidence)
- Shopify changelog discussion for `visible_if` launch timing (useful for dating the feature, not for normative behavior): https://community.shopify.dev/t/conditional-settings-in-the-theme-editor/15775

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - official Shopify docs align with the repo’s existing Horizon architecture and local CLI state
- Architecture: HIGH - recommendations map directly to current `hero`, `section`, `background-media`, `main-collection`, and `main-blog` boundaries
- Pitfalls: MEDIUM-HIGH - grounded in local code and official editor/runtime behavior, but exact implementation choices still affect blast radius

**Research date:** 2026-03-25
**Valid until:** 2026-04-24
