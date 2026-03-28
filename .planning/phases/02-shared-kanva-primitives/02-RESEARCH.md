# Phase 2: Shared Kanva Primitives - Research

**Researched:** 2026-03-28
**Domain:** Shopify OS 2.0 section/snippet authoring, Kanva design system mapping to Horizon primitives
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

#### Kanva styling integration
- **D-01:** Extend Horizon's existing theme settings and CSS custom properties with Kanva-specific values rather than creating a parallel design system. Use `config/settings_schema.json` color schemes and `snippets/theme-styles-variables.liquid` as the extension point.
- **D-02:** Kanva design tokens (colors `#F5F3EF`, `#8B9E6E`, `#E8E4DF`; typography weights; spacing `80–120px` section padding; border-radius `8–12px` cards) are added as new CSS custom properties that Kanva sections consume, not as overrides of Horizon's existing tokens.
- **D-03:** Typography follows the Kanva spec (geometric sans-serif, weight 400–500, specific size scale) but integrates through Horizon's existing font-loading and theme settings infrastructure rather than importing fonts independently.

#### Section inventory and granularity
- **D-04:** Each distinct Kanva editorial pattern becomes a standalone section file. New sections needed:
  - Feature strip / trust-value bar (4 icon-label columns, cream background)
  - Testimonial block (centered quote, rating, attribution)
  - Newsletter section (email capture with editorial styling)
  - Social / image grid (square image grid for Instagram-style content)
- **D-05:** Patterns with close Horizon equivalents are implemented by adapting the existing section, not duplicating it:
  - Split media/text rows → adapt `sections/media-with-content.liquid`
  - Product category rows → reuse `sections/product-list.liquid` with Kanva card styling
  - Collection links → reuse `sections/collection-links.liquid`
- **D-06:** Each new section must use the Phase 1 responsive editor contract (D-01 through D-08 from Phase 1 CONTEXT.md) and the `kanva-responsive-media.liquid` helper where media is involved.

#### Horizon adaptation vs new creation
- **D-07:** Adapt existing Horizon sections where the layout model matches. Create new sections only where Kanva patterns have no Horizon equivalent.
  - `sections/media-with-content.liquid` → Can serve Kanva "story" and "journey" split rows. Adapt with Kanva heading and spacing treatments; do not fork.
  - Feature strip → No Horizon equivalent. New section.
  - Testimonial → No Horizon equivalent. New section.
  - Newsletter capture → Footer has a newsletter pattern, but locked to footer. New standalone section.
  - Social/image grid → No Horizon equivalent. New section. (v1 uses static images.)
- **D-08:** When adapting an existing Horizon section, do NOT rename or reorganize its existing schema IDs. Add Kanva-specific styling through CSS classes and new optional settings, preserving backward compatibility.

#### Shared snippet and heading system
- **D-09:** Create Kanva-prefixed snippets for shared heading, badge, and card treatments that consume existing Horizon spacing/style helpers as the base.
- **D-10:** Consistent Kanva heading treatment: section label (12–13px uppercase tracking), main heading (40–52px weight 400–500), optional subtext (15–16px weight 400) rendered by a shared heading snippet, not duplicated per section.
- **D-11:** Kanva card treatments (8–12px border-radius, hover zoom on image, category pill badge, structured layout) should be a shared snippet reusable across product cards, blog cards, and editorial card surfaces.
- **D-12:** Badge/tag pill styling (pill radius, `#F0EDE8` background, 12px uppercase) should be a standalone snippet.

### Claude's Discretion
- Exact internal structure and Liquid implementation of each new snippet
- Whether Kanva CSS custom properties live in a new `kanva-styles.liquid` snippet or are appended to the existing `theme-styles-variables.liquid`
- Block composition inside adapted sections
- Whether the social/image grid uses a generic image block approach or a dedicated grid structure

### Deferred Ideas (OUT OF SCOPE)
- Homepage assembly from these primitives → Phase 3
- Collection page framing and card restyling → Phase 4
- About page storytelling composition → Phase 5
- Blog curation and featured story surface → Phase 6
- Live Instagram API integration → v2 (POLI-02), out of scope
- Custom animated carousel with preview rail → v2 (POLI-01), out of scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| EDIT-01 | Merchant can build the requested Kanva storefront pages from reusable Horizon-based sections and blocks instead of page-specific hardcoded templates | New standalone sections for feature strip, testimonial, newsletter, social grid; adapted sections for split rows and product grids — all reusable across any JSON template |
| EDIT-04 | Merchant can reorder, duplicate, and remove the new Kanva sections in the Shopify theme editor without code changes | Each editorial pattern is a standalone section file (not a page-scoped template or hardcoded block); sections registered with `disabled_on` groups correctly |
| COMP-01 | Merchant can reuse shared Kanva editorial sections for feature strips, split media/text rows, testimonials, newsletter, and social/image grids across multiple page types | Section inventory maps one-to-one with each Kanva pattern; all sections go in `sections/` and will be available in any JSON template |
| COMP-02 | Shopper sees Kanva-aligned shared heading, spacing, badge, and card treatments applied consistently across landing, collections, about, and blog pages | Shared `kanva-heading.liquid`, `kanva-badge.liquid`, `kanva-card.liquid` snippets used by all new sections; CSS tokens in `snippets/kanva-styles.liquid` |
| COMP-03 | Shopper sees the rebuilt pages implemented on Horizon primitives and reusable snippets rather than duplicated page-only markup | Adaptation strategy for `media-with-content.liquid`, `product-list.liquid`, `collection-links.liquid`; new sections only where no equivalent exists |
</phase_requirements>

---

## Summary

Phase 2 is a component-layer build, not a page-composition phase. Every deliverable is a reusable section, snippet, or shared CSS token that page phases (3–6) can assemble from. The research confirms all four new sections have no existing Horizon equivalent and must be created; three existing Horizon sections can be adapted in place without forking. The shared snippet system (heading, badge, card) is the DRY mechanism that prevents the per-section drift that Phase 1 contracts guard against.

The Kanva design system has two parallel color/typography palettes in the reference files: `kanva-theme.css` uses a navy+beige scheme (with serif+sans mixed headings) while `kanva-docs.md` describes a simpler cream/sage green scheme. The implementation should follow `kanva-docs.md` as the spec and use `kanva-theme.css` only for structural HTML/CSS patterns — the color integration goes through Horizon's color scheme system, not the reference CSS variables directly.

The newsletter, testimonial, and social grid sections have no interactive runtime requirements in v1 — they are purely Liquid + CSS. The feature strip needs no JavaScript. Only the adapted `media-with-content.liquid` section has an existing runtime dependency (its grid CSS), which should not be touched. The only new JavaScript risk is the newsletter email form, which Shopify handles natively through the `{% form 'customer' %}` tag pattern already used in Horizon's footer.

**Primary recommendation:** Build the four new sections and three shared snippets in a single sequential wave, starting with the CSS token layer and the shared heading snippet, so every section that follows has its shared treatments available at write time rather than being patched afterward.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Shopify OS 2.0 — Liquid sections | Platform | Section file with embedded `{% schema %}` and `{% stylesheet %}` | Only mechanism for merchant-reorderable, editor-visible page components |
| Shopify OS 2.0 — snippets | Platform | Shared rendering logic via `{% render %}` | No variable leak, safe for re-use; pattern established by Phase 1 with `kanva-responsive-media.liquid` |
| Shopify `{% form 'customer' %}` | Platform | Email capture / newsletter subscription | Native Shopify customer form tag handles submission and error states without custom JS |
| CSS custom properties inside `{% stylesheet %}` | Platform | Section-scoped or global Kanva tokens | Compiled by Shopify into a single merged stylesheet; co-location keeps section styles auditable |
| Shopify CLI 3.91.0 `shopify theme check` | 3.91.0 (confirmed locally) | Lint new sections after creation | Same gate used in Phase 1 regression script |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `snippets/spacing-style.liquid` (Horizon) | Existing | CSS variable output for padding/margin with `--spacing-scale` | All new sections that expose padding-block settings |
| `snippets/typography-style.liquid` (Horizon) | Existing | Inline CSS variables for font size, weight, family, line-height | `kanva-heading.liquid` uses this as its base |
| `snippets/background-media.liquid` (Horizon) | Existing | Background image/video rendering with position/sizing | Adapted sections that need background media |
| `snippets/kanva-responsive-media.liquid` | Phase 1 output | Desktop-first media slot rendering with mobile override fallback | All new Kanva sections that expose a hero-style media slot |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Standalone section per editorial pattern | Block variants inside `sections/section.liquid` | Blocks cannot be reordered across page positions — sections are required for editor reorder/duplicate/remove (EDIT-04) |
| Adapting `media-with-content.liquid` | Forking into `kanva-media-with-content.liquid` | Fork creates maintenance debt and contradicts D-15 from Phase 1 (no page-specific clones) |
| `kanva-styles.liquid` new snippet | Appending to `theme-styles-variables.liquid` | Either is valid; new snippet is cleaner separation, easier to audit, and does not risk introducing Liquid errors in the shared root styles file |
| `{% form 'customer' %}` for newsletter | Custom JS fetch | Native tag handles CSRF, error states, and success redirect; no JS risk |

**Installation:**
```bash
# No new dependencies — all tooling from Phase 1 is already in place
shopify theme check  # runs against new sections after creation
```

---

## Architecture Patterns

### Recommended Project Structure

New files Phase 2 will create:
```
sections/
├── kanva-feature-strip.liquid       # 4-column icon+label trust bar (NEW)
├── kanva-testimonial.liquid         # Centered quote, rating, attribution (NEW)
├── kanva-newsletter.liquid          # Email capture, editorial styling (NEW)
├── kanva-image-grid.liquid          # Square image grid, static images v1 (NEW)
├── media-with-content.liquid        # ADAPT (not fork) — Kanva heading/spacing treatment added

snippets/
├── kanva-styles.liquid              # CSS custom properties: --kanva-cream, --kanva-sage, etc. (NEW)
├── kanva-heading.liquid             # Shared label + heading + subtext renderer (NEW)
├── kanva-badge.liquid               # Pill badge / tag renderer (NEW)
├── kanva-card.liquid                # Shared card wrapper with hover-zoom and badge slot (NEW)
├── kanva-responsive-media.liquid    # Phase 1 output — unchanged

assets/
├── (no new assets required in Phase 2 — CSS goes in {% stylesheet %} blocks)
```

### Pattern 1: New Section Anatomy

Each new Kanva standalone section follows this structure:

**What:** A section file with an inline `{% stylesheet %}` block for scoped CSS, a Liquid body that renders `{% render 'kanva-heading' %}` and its specific content, and a `{% schema %}` that exposes settings following the Phase 1 contract.

**When to use:** Feature strip, testimonial, newsletter, image grid.

**Example (feature strip skeleton):**
```liquid
{%- comment -%} sections/kanva-feature-strip.liquid {%- endcomment -%}

{% render 'kanva-styles' %}

<div class="section-background color-{{ section.settings.color_scheme }}"></div>
<div
  class="section section--{{ section.settings.section_width }} color-{{ section.settings.color_scheme }} spacing-style kanva-feature-strip"
  style="{% render 'spacing-style', settings: section.settings %}"
  data-testid="kanva-feature-strip"
>
  {%- content_for 'blocks' -%}
</div>

{% stylesheet %}
  .kanva-feature-strip {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
    gap: 24px;
    text-align: center;
    background: var(--kanva-cream);
  }
{% endstylesheet %}

{% schema %}
{
  "name": "Feature Strip",
  "disabled_on": { "groups": ["header"] },
  "settings": [
    {
      "type": "color_scheme",
      "id": "color_scheme",
      "label": "Color scheme",
      "default": "scheme-3"
    },
    {
      "type": "header",
      "content": "Padding"
    },
    {
      "type": "range",
      "id": "padding-block-start",
      "label": "Top",
      "min": 0, "max": 120, "step": 4, "unit": "px", "default": 80
    },
    {
      "type": "range",
      "id": "padding-block-end",
      "label": "Bottom",
      "min": 0, "max": 120, "step": 4, "unit": "px", "default": 80
    }
  ],
  "blocks": [
    { "type": "_feature-strip-item", "name": "Feature item" }
  ],
  "presets": [
    {
      "name": "Kanva Feature Strip",
      "category": "Kanva Editorial"
    }
  ]
}
{% endschema %}
```

### Pattern 2: Shared Heading Snippet

**What:** `snippets/kanva-heading.liquid` accepts `label`, `heading`, `subtext`, and an optional `heading_level` parameter. It renders the three-tier Kanva heading system without duplicating markup in each section.

**When to use:** Called at the top of each new section's content area, and potentially inside adapted section block content.

**Example:**
```liquid
{%- comment -%} snippets/kanva-heading.liquid {%- endcomment -%}
{%- doc -%}
  Renders the Kanva three-tier heading: label, heading, subtext.

  @param {string} [label]         - Small uppercase label (12–13px)
  @param {string} [heading]       - Section heading (40–52px weight 400–500)
  @param {string} [subtext]       - Supporting body text (15–16px)
  @param {string} [heading_level] - HTML heading tag: 'h2' (default), 'h3', etc.
  @param {string} [alignment]     - 'left' (default), 'center', 'right'
{%- enddoc -%}

{%- liquid
  assign heading_tag = heading_level | default: 'h2'
  assign text_align = alignment | default: 'left'
-%}

<div class="kanva-heading" style="--kanva-heading-align: {{ text_align }};">
  {%- if label != blank -%}
    <p class="kanva-heading__label">{{ label }}</p>
  {%- endif -%}
  {%- if heading != blank -%}
    <{{ heading_tag }} class="kanva-heading__title">{{ heading }}</{{ heading_tag }}>
  {%- endif -%}
  {%- if subtext != blank -%}
    <p class="kanva-heading__subtext">{{ subtext }}</p>
  {%- endif -%}
</div>
```

### Pattern 3: Kanva CSS Tokens Snippet

**What:** `snippets/kanva-styles.liquid` renders a `<style>` block containing Kanva-specific CSS custom properties. Sections call `{% render 'kanva-styles' %}` once, Shopify's snippet deduplication ensures it renders only once per page.

**When to use:** All new Kanva sections should call this at their top. Horizon's snippet rendering does NOT deduplicate automatically — sections must guard against double-rendering with a Liquid `unless` on a global assign, or the CSS tokens can be added directly to `theme-styles-variables.liquid` instead (Claude's Discretion per D-01/D-02).

**Recommended approach:** Add directly to `snippets/theme-styles-variables.liquid` in the `:root` block. This guarantees the properties are available globally without any per-section render call. The addition is additive (no existing rules change):

```liquid
{%- comment -%} Inside snippets/theme-styles-variables.liquid, within the :root { } block {%- endcomment -%}
/* ── Kanva design tokens (Phase 2) ─────────────────────────── */
--kanva-cream:         #F5F3EF;
--kanva-sage:          #8B9E6E;
--kanva-border:        #E8E4DF;
--kanva-badge-bg:      #F0EDE8;
--kanva-text-primary:  #1A1A1A;
--kanva-text-muted:    #6B6B6B;
--kanva-card-radius:   10px;   /* midpoint of 8–12px spec */
--kanva-btn-radius:    4px;
--kanva-pill-radius:   9999px;
--kanva-section-pad:   80px;
```

**Decision note:** Adding to `theme-styles-variables.liquid` (not a separate snippet) avoids the snippet-deduplication edge case and is consistent with how Horizon handles all other global tokens. Recommend this over a separate `kanva-styles.liquid` snippet.

### Pattern 4: Adapting media-with-content.liquid

**What:** The existing `sections/media-with-content.liquid` handles split media/text layouts through a `content_for 'block'` pattern with `_media-without-appearance` and `_content-without-appearance` block types. It already provides `media_position`, `media_width`, `media_height`, `section_width`, `extend_media`, and `color_scheme` settings.

**When to use:** When Kanva "story" or "journey" split rows are composed in Phase 5 (about page). Phase 2 prepares the section by verifying that its existing block composition is sufficient and that Kanva heading/spacing treatments can be applied via CSS classes added to the content block, without touching the section schema.

**Critical constraint (D-08):** Do NOT rename any existing schema IDs. CSS class additions to `_content-without-appearance` block content, or padding adjustments via the existing `padding-block-start`/`padding-block-end` range settings, are the only acceptable changes.

**What Phase 2 actually does to this section:** Adds a `kanva-split` CSS class to the section wrapper and/or its inner grid to apply Kanva border-radius and heading treatment via the shared heading snippet in the block content. The section schema is NOT modified.

### Pattern 5: Newsletter Section with Native Shopify Form

**What:** `sections/kanva-newsletter.liquid` uses Shopify's `{% form 'customer' %}` tag targeting the customer `contact` form action to capture email. This is the same mechanism Horizon's footer newsletter uses, extracted into a standalone page-body section.

**When to use:** Any page template where the editorial newsletter module should appear. v1 is static — headline, subtext, email input, decorative image.

**Example form structure:**
```liquid
{% form 'customer', id: 'newsletter-form-' | append: section.id %}
  <input type="hidden" name="contact[tags]" value="newsletter">
  <input
    type="email"
    name="contact[email]"
    id="newsletter-email-{{ section.id }}"
    placeholder="{{ section.settings.email_placeholder | default: 'Your email address' }}"
    required
    class="kanva-newsletter__input"
  >
  <button type="submit" class="btn btn--primary kanva-newsletter__btn">
    {{ section.settings.button_label | default: 'Subscribe' }}
  </button>
{% endform %}
```

### Pattern 6: Image Grid with Static Image Blocks

**What:** `sections/kanva-image-grid.liquid` renders a CSS grid of square images, each defined as a block with an `image_picker` setting and an optional `url` link setting. No JavaScript. No Instagram API.

**Block composition:**
- Block type: `kanva-image-grid-item`
- Settings: `image` (image_picker), `url` (url), `alt` (text, optional)
- CSS: `display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 4px;` — simple, no framework needed.

### Anti-Patterns to Avoid

- **Forking `media-with-content.liquid` into a Kanva copy:** Creates schema ID drift and maintenance debt. D-08 explicitly prohibits it.
- **Hardcoding Kanva tokens inline in section CSS:** Colors and spacing values should come from the CSS custom properties defined in `theme-styles-variables.liquid`, not raw hex values in each section's `{% stylesheet %}`.
- **Using `request.device.phone` for responsive behavior:** Prohibited by Phase 1 anti-drift rules. Use CSS classes and the `kanva-responsive-media.liquid` helper instead.
- **Duplicate text settings for mobile:** Phase 1 contract forbids this. Heading, subtext, and CTA text are always shared across breakpoints.
- **New mobile-specific setting IDs that are not in the Phase 1 contract:** All responsive settings must use the canonical IDs from `01-responsive-editor-contract.md`.
- **Rendering `kanva-styles.liquid` as a deduplicated snippet:** Liquid `render` does NOT deduplicate across sections on the same page in OS 2.0. Use `theme-styles-variables.liquid` for global tokens.
- **Putting newsletter form outside `{% form 'customer' %}`:** Custom JS fetch bypasses CSRF protection and Shopify's native success/error handling.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Email capture form | Custom JS `fetch()` to a serverless endpoint | `{% form 'customer' %}` with `contact[tags]=newsletter` | Shopify handles CSRF, validation, success/error redirect, and customer tag assignment natively |
| Responsive image with mobile art direction | Two separate `<img>` tags with CSS visibility | `<picture>` with `<source media="(max-width: 749px)">` or `kanva-responsive-media.liquid` | Already implemented in Phase 1 helper; avoids duplicate markup |
| CSS grid for section layout | Custom JS layout engine | CSS `grid-template-columns: repeat(auto-fill, ...)` | Shopify themes are server-rendered; CSS grid is sufficient and already used by Horizon |
| Font loading | Importing Google Fonts directly in section files | Horizon's `settings.type_body_font` + `snippets/theme-styles-variables.liquid` font-face output | D-03 explicitly: integrate through Horizon's font infrastructure, not independent imports |
| Mobile breakpoint detection | JavaScript breakpoint watchers | CSS `@media screen and (max-width: 749px)` in `{% stylesheet %}` blocks | Horizon's single breakpoint (749px) is the only contract; no JS needed for layout |

**Key insight:** Every hand-rolled solution in this domain (email forms, responsive images, font loading) has a battle-tested Shopify-native equivalent that handles edge cases Kanva references cannot anticipate — particularly around Shopify storefront CSRF, CDN image resizing, and the theme editor's live-reload behavior.

---

## Common Pitfalls

### Pitfall 1: Snippet Rendered Multiple Times Per Page Injects Duplicate CSS
**What goes wrong:** A new `kanva-styles.liquid` snippet rendered by each section will inject the CSS token block once per section instance — if three Kanva sections are on the same page, the token block appears three times.
**Why it happens:** Shopify OS 2.0 `render` tags are not deduplicated for snippets that output CSS. Only `{% stylesheet %}` blocks inside sections are merged at compile time.
**How to avoid:** Add Kanva tokens directly to the `:root` block in `snippets/theme-styles-variables.liquid`. That file is rendered once per page load from `layout/theme.liquid`.
**Warning signs:** Viewing page source and seeing the same `--kanva-cream` custom property defined three or more times.

### Pitfall 2: Section Blocks Registered With `"type": "@theme"` Allow Wrong Block Types
**What goes wrong:** If the new sections declare `"blocks": [{"type": "@theme"}]` in their schema, merchants can add any Horizon block (including blocks that expect product context, article context, etc.), causing broken renders in a standalone editorial section.
**Why it happens:** `@theme` is a catch-all — it includes all block types, including context-sensitive ones.
**How to avoid:** New Kanva sections should enumerate only the block types they support explicitly (e.g., `_feature-strip-item`, `_testimonial-quote`). The generic `sections/section.liquid` correctly uses `@theme`, but that is a generic container; specialized editorial sections should not.
**Warning signs:** Merchant adds a "Product card" block to a testimonial section and sees a broken render or empty state in the editor.

### Pitfall 3: `media-with-content.liquid` Adaptation Breaks Existing Presets
**What goes wrong:** Adding CSS classes or modifying `presets` in `sections/media-with-content.liquid` schema changes the preset behavior for merchants who have already used the "Editorial" or "Editorial Jumbo Text" presets.
**Why it happens:** Shopify stores preset choices in JSON templates, which reference preset `name` values. Renaming or reordering presets can break saved template configurations.
**How to avoid:** Only add new presets (e.g., `"name": "Kanva Story Row"`) — never rename or remove existing ones. Existing schema IDs must remain untouched (D-08).
**Warning signs:** Running `shopify theme check` after the adaptation and seeing schema warnings; or opening the editor and seeing a section with no recognized preset.

### Pitfall 4: Kanva CSS Tokens Named to Conflict with Horizon Token Names
**What goes wrong:** A token named `--color-border` or `--color-background` in Kanva styles overrides Horizon's own color scheme properties that are used by existing sections.
**Why it happens:** Horizon's color scheme system uses `--color-*` prefixed properties injected via the `color-{{ section.settings.color_scheme }}` class. If a Kanva global token uses the same name, it silently overrides the color scheme.
**How to avoid:** Always prefix Kanva tokens with `--kanva-` (e.g., `--kanva-cream`, `--kanva-sage`). Never use `--color-*` for new Kanva values.
**Warning signs:** Existing Horizon sections on the same page (product list, collection links) appear with wrong colors after adding Kanva token CSS.

### Pitfall 5: `disabled_on` Header Group Not Set on New Sections
**What goes wrong:** A new section appears in the header group's "Add section" picker, allowing merchants to accidentally add an editorial section inside the site header.
**Why it happens:** The default Shopify behavior includes sections in all groups unless `disabled_on` is set.
**How to avoid:** All new Kanva sections must include `"disabled_on": { "groups": ["header"] }` in their schema, matching every other editorial section in Horizon.
**Warning signs:** Running `shopify theme check` may not catch this; manual editor verification is needed.

### Pitfall 6: Newsletter Section Uses `{% form 'contact' %}` Instead of `{% form 'customer' %}`
**What goes wrong:** `{% form 'contact' %}` submits to the contact form endpoint, which does not create a customer record or apply newsletter tags. The merchant sees the submission but cannot use it for email marketing.
**Why it happens:** Both form types look similar. Horizon's footer newsletter uses `{% form 'customer' %}`.
**How to avoid:** Use `{% form 'customer' %}` with a hidden field `contact[tags]=newsletter`. This matches Horizon's own footer newsletter pattern.
**Warning signs:** Form submissions appear in Shopify's contact inbox instead of the customer list.

---

## Code Examples

Verified patterns from Horizon source and Shopify documentation:

### Spacing-Style Usage (from `snippets/spacing-style.liquid` source)
```liquid
{%- comment -%} Source: snippets/spacing-style.liquid (confirmed in repo) {%- endcomment -%}
<div
  class="section spacing-style"
  style="{% render 'spacing-style', settings: section.settings %}"
>
  {# Requires section schema to have padding-block-start and padding-block-end range settings #}
  {# Output: --padding-block-start: max(20px, calc(var(--spacing-scale) * 80px)); #}
</div>
```

### Section-Background Pattern (from `sections/media-with-content.liquid`)
```liquid
{%- comment -%} Source: sections/media-with-content.liquid line 13 {%- endcomment -%}
<div class="section-background color-{{ section.settings.color_scheme }}"></div>
<div class="section section--{{ section.settings.section_width }} color-{{ section.settings.color_scheme }} spacing-style ...">
  {# Section background is a separate element behind the section for color bleed #}
</div>
```

### Color Scheme Setting (standard Horizon pattern)
```json
{
  "type": "color_scheme",
  "id": "color_scheme",
  "label": "t:settings.color_scheme",
  "default": "scheme-3"
}
```
Scheme 3 (`scheme-3`) is the warm/cream scheme in Horizon's default palette, appropriate as the default for Kanva sections. Scheme 1 is typically white background.

### Shopify Customer Form for Newsletter (from Horizon footer pattern)
```liquid
{%- comment -%} Source: Horizon footer newsletter block pattern {%- endcomment -%}
{% form 'customer', id: 'newsletter-' | append: section.id %}
  {%- if form.posted_successfully? -%}
    <p class="kanva-newsletter__success">{{ 'Thank you for subscribing!' }}</p>
  {%- else -%}
    {%- if form.errors -%}
      <p class="kanva-newsletter__error">{{ form.errors.translated_fields }}</p>
    {%- endif -%}
    <input type="hidden" name="contact[tags]" value="newsletter">
    <input type="email" name="contact[email]" required>
    <button type="submit">Subscribe</button>
  {%- endif -%}
{% endform %}
```

### Image Grid Block (image_picker in a block)
```json
{
  "type": "kanva-image-grid-item",
  "name": "Image",
  "settings": [
    { "type": "image_picker", "id": "image", "label": "Image" },
    { "type": "url", "id": "url", "label": "Link" },
    { "type": "text", "id": "alt", "label": "Alt text" }
  ]
}
```

### Feature Strip Block Schema
```json
{
  "type": "kanva-feature-item",
  "name": "Feature item",
  "settings": [
    { "type": "inline_richtext", "id": "icon_svg", "label": "Icon SVG" },
    { "type": "text", "id": "title", "label": "Title", "default": "Natural Formula" },
    { "type": "text", "id": "description", "label": "Description", "default": "100% plant-based ingredients" }
  ]
}
```
Note: `inline_richtext` is used for SVG input since Horizon does not have a native icon picker. An alternative is to use a `select` with predefined icon names and render inline SVG by case in Liquid — this is cleaner from an editor perspective.

### Testimonial Block Schema
```json
{
  "type": "kanva-testimonial-quote",
  "name": "Quote",
  "settings": [
    { "type": "textarea", "id": "quote", "label": "Quote text" },
    { "type": "text", "id": "author", "label": "Author name & title" },
    { "type": "range", "id": "stars", "label": "Star rating", "min": 1, "max": 5, "step": 1, "default": 5 },
    { "type": "text", "id": "rating_summary", "label": "Rating summary", "default": "4.7 / 5 · 1,109 reviews" }
  ]
}
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `visible_if` not available in section schema | `visible_if` conditional settings in `{% schema %}` | Shopify 2025 (confirmed in Phase 1 research) | Mobile override settings can be hidden behind `custom_mobile_media` gate — established in Phase 1 contract |
| `{% stylesheet %}` not merged across sections | `{% stylesheet %}` blocks compiled into a single merged CSS file | OS 2.0 architecture | Per-section CSS is safe and does not require a build tool |
| `content_for 'block'` not available | Block composition via `content_for` in OS 2.0 sections | OS 2.0 | `media-with-content.liquid` already uses this pattern for its media and content slots |

**Deprecated/outdated:**
- `{% include %}` tag: Replaced by `{% render %}` in OS 2.0. `render` is required for all new snippets — it does not leak variables and is the standard for all Horizon snippets in this repo.
- `section.blocks` for loops in simple sections: OS 2.0 sections use `content_for 'blocks'` and `content_for 'block', type: '...'` delegation pattern. The older `for block in section.blocks` loop pattern still works but is not how Horizon's newer sections are structured.

---

## Open Questions

1. **Icon approach for the feature strip**
   - What we know: The reference HTML uses inline SVG for each feature icon. Shopify does not have a native icon picker setting type. `inline_richtext` can accept SVG but is fragile in the editor.
   - What's unclear: Whether the planner should prescribe a predefined icon `select` (cleaner editor UX, limited to a set list) or allow free-form SVG via a `text`/`html` setting (more flexible, riskier).
   - Recommendation: Use a `select` setting with 6–8 predefined icon names (Natural, Shield, Checkmark, Shipping, Leaf, Star) and render the corresponding inline SVG in Liquid via a `case` statement. This gives a safe, merchant-friendly picker without requiring SVG literacy. The planner should encode this as a task decision.

2. **`kanva-card.liquid` scope in Phase 2**
   - What we know: D-11 specifies a shared card snippet "reusable across product cards, blog cards, and any editorial card surface." Product cards and blog cards have their own existing Horizon snippets (`snippets/product-card.liquid`, `blocks/_blog-post-card.liquid`).
   - What's unclear: Whether Phase 2 should modify those existing snippets to use `kanva-card.liquid` as a wrapper, or whether `kanva-card.liquid` in Phase 2 is only for new editorial card surfaces (e.g., image grid items), leaving product/blog card restyling to Phases 4 and 6.
   - Recommendation: Phase 2 `kanva-card.liquid` should be an editorial-only card wrapper (used by the image grid section and any Phase 2 surfaces). Restyling product and blog cards is deferred to Phase 4 and Phase 6 respectively, as those phases have the full page composition context. The planner should record this as a scope boundary.

3. **Color scheme for new Kanva sections**
   - What we know: Horizon has a `color_scheme_group` with multiple schemes defined in `config/settings_schema.json`. The Kanva cream color (`#F5F3EF`) does not correspond to a pre-existing scheme value — it needs to be a new scheme or integrated as a token.
   - What's unclear: Whether the plan should include a task to add a "Kanva Cream" color scheme entry to `settings_schema.json`, or whether the `--kanva-cream` CSS variable is sufficient and the cream background is applied via a CSS class rather than a color scheme.
   - Recommendation: A CSS class approach (`kanva-section--cream`) is simpler and does not require merchants to understand the color scheme picker for Kanva sections. The `color_scheme` setting on new sections provides the text and border colors from Horizon's existing scheme system; the cream background is applied additively via the section's own CSS. This avoids adding a new color scheme entry in Phase 2 and keeps the change minimal.

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Shopify CLI (`shopify theme check`) | Phase 1 regression gate + Phase 2 section validation | Yes | 3.91.0 | None needed |
| Liquid renderer (Shopify platform) | All sections and snippets | Yes (via Shopify) | OS 2.0 | — |
| CSS custom properties | Kanva token system | Yes (all modern browsers, Shopify admin preview) | Native CSS | — |
| `{% form 'customer' %}` | Newsletter section | Yes (Shopify platform) | Native | — |

No missing dependencies. Phase 2 is entirely within the Shopify theme file system — no external APIs, no build tools, no npm packages.

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | `shopify theme check` (Shopify CLI 3.91.0) — static linting only; no runtime test framework in this theme |
| Config file | None (uses Shopify CLI defaults; see Phase 1 `scripts/phase1-regression-gate.sh`) |
| Quick run command | `cd /Users/mati/Mine/horizon && sh scripts/phase1-regression-gate.sh` |
| Full suite command | `cd /Users/mati/Mine/horizon && sh scripts/phase1-regression-gate.sh` (same gate) |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| EDIT-01 | New sections appear as section options in JSON template editor | manual-only | — | N/A — requires live editor |
| EDIT-04 | New sections can be reordered/duplicated/removed without code | manual-only | — | N/A — requires live editor |
| COMP-01 | Feature strip, testimonial, newsletter, image grid section files exist and pass theme check | unit (static) | `sh scripts/phase1-regression-gate.sh` | Wave 0 — after section creation |
| COMP-02 | Shared heading, badge, and card snippets are rendered consistently | manual (visual) | Theme check confirms no Liquid errors; visual diff in browser | N/A |
| COMP-03 | Adapted `media-with-content.liquid` passes theme check without schema errors | unit (static) | `sh scripts/phase1-regression-gate.sh` | Phase 1 existing |

### Sampling Rate
- **Per task commit:** `cd /Users/mati/Mine/horizon && sh scripts/phase1-regression-gate.sh`
- **Per wave merge:** `cd /Users/mati/Mine/horizon && sh scripts/phase1-regression-gate.sh`
- **Phase gate:** Full theme check green + manual editor smoke (same pattern as Phase 1 `01-protected-runtime-checklist.md`)

### Wave 0 Gaps
No Wave 0 test files need to be created — Phase 2 has no automated test infrastructure beyond the Phase 1 regression gate, which already exists. All new artifact validation is either `shopify theme check` (covered by the existing gate script) or manual editor verification (covered by the Phase 1 smoke checklist pattern, which Phase 2 will extend with Kanva-specific checks).

None — existing test infrastructure covers all automated requirements for this phase. Manual checks for editor behavior (EDIT-04) will be documented in a Phase 2 smoke checklist following the Phase 1 `01-protected-runtime-checklist.md` pattern.

---

## Sources

### Primary (HIGH confidence)
- Horizon repo source — `sections/media-with-content.liquid` (432 lines, read directly)
- Horizon repo source — `snippets/kanva-responsive-media.liquid` (272 lines, read directly — Phase 1 output)
- Horizon repo source — `snippets/theme-styles-variables.liquid` (280+ lines, read directly)
- Horizon repo source — `snippets/spacing-style.liquid` (read directly)
- Horizon repo source — `snippets/typography-style.liquid` (read directly)
- Horizon repo source — `blocks/_blog-post-card.liquid`, `blocks/_card.liquid`, `snippets/product-card.liquid` (read directly)
- Horizon repo source — `sections/product-list.liquid`, `sections/collection-links.liquid`, `sections/section.liquid` (read directly)
- Horizon repo source — `config/settings_schema.json` (read directly — color scheme structure confirmed)
- Phase 1 outputs — `01-responsive-editor-contract.md` (270 lines, read directly — canonical contract for all Phase 2 sections)
- Kanva reference — `theme-to-clone/kanva-docs.md` (design system, component spec — read directly)
- Kanva reference — `theme-to-clone/kanva-components.html` (HTML structure reference — read directly)
- Kanva reference — `theme-to-clone/kanva-theme.css` (CSS variables — read directly)
- Kanva reference — `theme-to-clone/about.html` (stats row, split section patterns — read directly)
- Context files — `02-CONTEXT.md`, `02-DISCUSSION-LOG.md`, `01-CONTEXT.md` (read directly)

### Secondary (MEDIUM confidence)
- `{% form 'customer' %}` newsletter pattern: confirmed from Horizon footer section schema (`sections/footer.liquid` grep confirms newsletter block at lines 207–247); Shopify form tag behavior documented in Shopify Liquid reference and consistent with existing Horizon usage.
- `visible_if` for conditional section settings: confirmed present in Phase 1 contract and in existing Horizon schemas (`sections/section.liquid` line 51: `visible_if`); documented in Shopify's current schema settings reference.

### Tertiary (LOW confidence)
- Icon picker approach (select vs inline SVG): Based on known Shopify schema limitations (no native icon_picker type). Confirmed by inspection of `config/settings_schema.json` which has no icon_picker type definition. Single source (direct inspection) — low confidence on best UX pattern, flagged as Open Question.

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all tools confirmed present in repo and environment; no new dependencies required
- Architecture patterns: HIGH — sourced directly from Horizon repo files and Phase 1 contract documents
- Pitfalls: HIGH — sourced from direct code inspection of Shopify OS 2.0 patterns and Phase 1 anti-drift rules
- Open questions: LOW — icon approach and `kanva-card.liquid` scope are planning decisions, not research findings

**Research date:** 2026-03-28
**Valid until:** 2026-05-28 (stable Shopify OS 2.0 platform; Phase 1 contract locked; 60-day window)
