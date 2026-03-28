# Responsive Editor Contract — Phase 1

**Status:** Locked
**Version:** 1.0
**Effective from:** Phase 1 onwards
**Enforces decisions:** D-01, D-02, D-03, D-04, D-05, D-06, D-07, D-08, D-13, D-14, D-15

---

## 1. Core Rule: Desktop Default + Optional Mobile Override

> **No duplicate content trees. Desktop media is the source of truth. Mobile is an optional override only.**

All Kanva editorial sections follow a single responsive model:

- **Desktop settings** are canonical and required. A section must render on desktop with only the desktop settings configured.
- **Mobile settings** are optional overrides. They apply only for layout and media concerns that genuinely differ by breakpoint. They must not require duplicate text, CTA, or semantic content to be re-entered.
- When a mobile override is not configured, the section falls back cleanly to the desktop values — never blank space, never duplicate markup.

This is encoded in `sections/hero.liquid` as the reference pattern and must be replicated, not reinvented, in all future Kanva sections.

---

## 2. Allowed Override Categories

The following categories are the **only** cases where a separate mobile setting is permitted:

| Category | Allowed | Rationale |
|---|---|---|
| Mobile media (image/video) | Yes | Art direction — the visual may need to be reframed or cropped differently for portrait viewports |
| Mobile stack behavior | Yes | Layout — two side-by-side media slots may need to stack vertically on narrow screens |
| Mobile position overrides | Yes | Layout — background image/video position and fit may need tuning for portrait viewports |
| Text content | No | Text is shared across breakpoints; copy changes are not a responsive concern |
| CTA / link content | No | CTAs are shared; breakpoint-specific CTAs are not supported |
| Color scheme | No | Color is shared; per-breakpoint color schemes add schema complexity without editorial value |
| Heading level / semantic structure | No | Semantic structure must be consistent for accessibility |

---

## 3. Canonical Setting-ID Matrix

Downstream sections must reuse these IDs exactly, taken from the existing Horizon implementation. Do not invent new IDs for the same concepts.

### Media Slot Settings (per slot, e.g. slot 1 and slot 2)

| Setting ID | Type | Purpose | Visible When |
|---|---|---|---|
| `media_type_1` | select: `image` / `video` | Desktop media type for slot 1 | Always |
| `image_1` | image_picker | Desktop image for slot 1 | `media_type_1 == 'image'` |
| `video_1` | video | Desktop video for slot 1 | `media_type_1 == 'video'` |
| `media_type_2` | select: `image` / `video` | Desktop media type for slot 2 | Always (optional second slot) |
| `image_2` | image_picker | Desktop image for slot 2 | `media_type_2 == 'image'` |
| `video_2` | video | Desktop video for slot 2 | `media_type_2 == 'video'` |

### Mobile Override Settings

| Setting ID | Type | Purpose | Visible When |
|---|---|---|---|
| `custom_mobile_media` | checkbox | Enable gate for mobile media overrides | Always |
| `stack_media_on_mobile` | checkbox | Stack multiple media slots vertically on mobile | Always |
| `media_type_1_mobile` | select: `image` / `video` | Mobile media type for slot 1 | `custom_mobile_media` |
| `image_1_mobile` | image_picker | Mobile image for slot 1 | `custom_mobile_media and media_type_1_mobile == 'image'` |
| `video_1_mobile` | video | Mobile video for slot 1 | `custom_mobile_media and media_type_1_mobile == 'video'` |
| `media_type_2_mobile` | select: `image` / `video` | Mobile media type for slot 2 | `custom_mobile_media` |
| `image_2_mobile` | image_picker | Mobile image for slot 2 | `custom_mobile_media and media_type_2_mobile == 'image'` |
| `video_2_mobile` | video | Mobile video for slot 2 | `custom_mobile_media and media_type_2_mobile == 'video'` |

### Layout / Position Settings (from `sections/section.liquid` and `snippets/section.liquid`)

| Setting ID | Type | Purpose | Visible When |
|---|---|---|---|
| `vertical_on_mobile` | checkbox | Force vertical stacking on mobile | `content_direction == 'row'` |
| `horizontal_alignment` | select | Horizontal content alignment | `content_direction == 'row'` |
| `vertical_alignment` | select | Vertical content alignment | `content_direction == 'row'` |
| `background_media` | select: `none` / `image` / `video` | Background media type | Always |
| `background_image` | image_picker | Background image | `background_media == 'image'` |
| `background_image_position` | select: `cover` / `fit` | Background image sizing | `background_media == 'image'` |
| `video` | video | Background video | `background_media == 'video'` |
| `video_position` | select: `cover` / `contain` | Background video sizing | `background_media == 'video'` |

---

## 4. Fallback Matrix

This matrix defines the required fallback behavior for every combination of mobile override state. All Kanva sections implementing this contract must replicate these fallback rules.

| `custom_mobile_media` | Mobile media populated | Desktop media populated | Rendered result |
|---|---|---|---|
| `false` | N/A (hidden) | Yes | Desktop media shown on all breakpoints |
| `false` | N/A (hidden) | No | Placeholder shown on all breakpoints |
| `true` | Yes | Yes | Desktop media on desktop; mobile media on mobile |
| `true` | Yes | No | Mobile media on mobile; placeholder on desktop |
| `true` | No | Yes | Desktop media shown on **all** breakpoints (fallback) |
| `true` | No | No | Placeholder shown on all breakpoints |

**Key rule:** When `custom_mobile_media == true` but no mobile media is configured, the section must silently fall back to desktop media. It must never render blank space on mobile.

This is implemented in `sections/hero.liquid` as:

```liquid
if section.settings.custom_mobile_media == false or media_count_mobile == 0 or media_count == 0
  assign media_count_mobile = media_count
  assign fallback_to_desktop = true
endif
```

The `fallback_to_desktop` variable is the authoritative flag for this fallback path. Reuse it verbatim or pass it into the shared helper.

### CSS Visibility Classes

Desktop and mobile visibility is controlled with CSS classes, not conditional markup duplication:

| Class | Visible on desktop | Visible on mobile |
|---|---|---|
| `hero__media-wrapper--desktop` | Yes | No (default) |
| `hero__media-wrapper--mobile` | No | Yes |
| Both classes on same element | Yes | Yes |

The `--mobile` class is added to the desktop wrapper when `fallback_to_desktop == true`, ensuring the desktop media is visible on both breakpoints without duplicating markup.

---

## 5. Anti-Drift Rules

The following patterns are **prohibited** in all Kanva sections. Phase reviewers must reject PRs that introduce them.

### Prohibited: Duplicate content trees

```liquid
{%- comment -%} WRONG — separate text for mobile and desktop {%- endcomment -%}
{% if request.device.phone %}
  <h1>{{ section.settings.mobile_heading }}</h1>
{% else %}
  <h1>{{ section.settings.desktop_heading }}</h1>
{% endif %}
```

Use a single heading setting. Text is breakpoint-agnostic.

### Prohibited: Ad hoc mobile breakpoint IDs

```liquid
{%- comment -%} WRONG — inventing a new ID not in the contract {%- endcomment -%}
"id": "mobile_background_image"
```

Use `image_1_mobile` with `custom_mobile_media` gate. Do not invent parallel naming conventions.

### Prohibited: Parallel image pickers without the `custom_mobile_media` gate

Every mobile image picker must be guarded by `visible_if: custom_mobile_media`. Exposing mobile image pickers unconditionally pollutes the editor and creates inconsistent UX.

### Prohibited: Section-specific fallback logic

Each section must not write its own media fallback logic. The fallback rules defined in this contract must be implemented through `snippets/kanva-responsive-media.liquid` (see Section 7). Do not copy-paste equivalent logic into individual section files.

---

## 6. Horizon Primitives — Reuse-First Inventory

The following Horizon files contain the canonical implementations that Kanva phases must reuse before introducing any new abstractions. Downstream phases must read these before implementing responsive settings.

| Primitive | File | What it provides |
|---|---|---|
| Hero media pattern | `sections/hero.liquid` | The reference implementation of `custom_mobile_media` + desktop fallback + `stack_media_on_mobile` |
| Section wrapper | `sections/section.liquid` / `snippets/section.liquid` | `vertical_on_mobile`, `horizontal_alignment`, `vertical_alignment`, background media settings, CSS class composition |
| Background media renderer | `snippets/background-media.liquid` | Background image and video rendering with position and sizing variants |
| Overlay renderer | `snippets/overlay.liquid` | Reusable overlay rendering for content legibility |
| Layout panel styles | `snippets/layout-panel-style.liquid` | CSS variable output for flex layout settings |
| Spacing styles | `snippets/spacing-style.liquid` | CSS variable output for padding and margin settings |

**Rule:** If a new Kanva section needs a capability already present in this inventory, it must use the existing primitive. Opening a new abstraction requires a documented rationale and explicit sign-off in the plan that introduces it.

---

## 7. Shared Helper: `snippets/kanva-responsive-media.liquid`

This snippet is the single implementation of the desktop-first mobile override fallback pattern. All Kanva editorial sections that render a hero-style media slot must delegate to this helper.

### Interface

The helper accepts the following inputs:

| Parameter | Type | Required | Description |
|---|---|---|---|
| `media_1` | string: `image` / `video` / `none` | Yes | Resolved desktop media type for slot 1 |
| `media_2` | string: `image` / `video` / `none` | No | Resolved desktop media type for slot 2 |
| `media_1_mobile` | string: `image` / `video` / `none` | No | Resolved mobile media type for slot 1 |
| `media_2_mobile` | string: `image` / `video` / `none` | No | Resolved mobile media type for slot 2 |
| `fallback_to_desktop` | boolean | Yes | Whether mobile falls back to desktop media |
| `image_1` | image object | No | Desktop image for slot 1 |
| `image_2` | image object | No | Desktop image for slot 2 |
| `image_1_mobile` | image object | No | Mobile image for slot 1 |
| `image_2_mobile` | image object | No | Mobile image for slot 2 |
| `video_1` | video object | No | Desktop video for slot 1 |
| `video_2` | video object | No | Desktop video for slot 2 |
| `video_1_mobile` | video object | No | Mobile video for slot 1 |
| `video_2_mobile` | video object | No | Mobile video for slot 2 |
| `media_wrapper_desktop_class` | string | Yes | CSS class string for the desktop wrapper |
| `media_wrapper_mobile_class` | string | Yes | CSS class string for the mobile wrapper |
| `sizes` | string | Yes | `sizes` attribute for desktop images |
| `sizes_mobile` | string | Yes | `sizes` attribute for mobile images |
| `widths` | string | Yes | Comma-separated width breakpoints for desktop images |
| `mobile_widths` | string | Yes | Comma-separated width breakpoints for mobile images |
| `fetch_priority` | string | No | `fetchpriority` value for the first image (default: `auto`) |
| `media_count` | number | Yes | Total desktop media slot count |
| `media_count_mobile` | number | Yes | Total mobile media slot count |

### Usage in a section

```liquid
{%- comment -%} Resolve media types and counts first, then delegate to the shared helper {%- endcomment -%}
{% render 'kanva-responsive-media',
  media_1: media_1,
  media_2: media_2,
  media_1_mobile: media_1_mobile,
  media_2_mobile: media_2_mobile,
  fallback_to_desktop: fallback_to_desktop,
  image_1: section.settings.image_1,
  image_1_mobile: section.settings.image_1_mobile,
  video_1: section.settings.video_1,
  video_1_mobile: section.settings.video_1_mobile,
  image_2: section.settings.image_2,
  image_2_mobile: section.settings.image_2_mobile,
  video_2: section.settings.video_2,
  video_2_mobile: section.settings.video_2_mobile,
  media_wrapper_desktop_class: media_wrapper_desktop_class,
  media_wrapper_mobile_class: media_wrapper_mobile_class,
  sizes: sizes,
  sizes_mobile: sizes_mobile,
  widths: widths,
  mobile_widths: mobile_widths,
  fetch_priority: fetch_priority,
  media_count: media_count,
  media_count_mobile: media_count_mobile
%}
```

The calling section is responsible for resolving `media_1`, `media_2`, `media_1_mobile`, `media_2_mobile`, `fallback_to_desktop`, and size/width values before the render call. The helper handles only the HTML output.

---

## 8. Breakpoints

All responsive media behavior in Kanva sections follows the single Horizon breakpoint:

| Breakpoint | CSS query | Applies |
|---|---|---|
| Mobile | `max-width: 749px` | Mobile overrides, mobile visibility |
| Desktop | `min-width: 750px` | Desktop defaults |

Do not introduce additional breakpoints (tablet-specific, etc.) without a documented rationale approved at the phase planning stage.

---

## 9. What This Contract Does Not Cover

The following topics are **deferred** to later phases and must not be resolved ad hoc inside section files:

- Mobile text size scaling — this is a typography concern, not a responsive media concern
- Mobile navigation patterns — out of scope for editorial sections
- Collection card responsive behavior — deferred to Phase 4
- Blog article responsive layout — deferred to Phase 6
- Full-bleed background media mobile overrides (no mobile-specific background_image or background_video setting is defined in this contract; the desktop background applies to both breakpoints)

---

*Phase: 01-stabilization-and-editor-contract*
*Locked: 2026-03-28*
*Consumed by: all Kanva editorial sections starting Phase 2*
