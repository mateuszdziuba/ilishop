# Phase 1: Protected Runtime Smoke Checklist

**Purpose:** Manual regression surface for Horizon's shared runtime and editor-facing behavior.
Run this checklist before and after any Phase 1 change that touches the protected files, and before every `/gsd:verify-work` sign-off.

**Scope:** Header behavior, generic section wrapper rendering, collection runtime (filtering/sorting/pagination), blog archive rendering, and minimal theme editor checks.
This is a smoke checklist, not a full QA matrix. Pass = no visible regression. Fail = stop and diagnose.

**Protected files this checklist covers:**
- `layout/theme.liquid`
- `assets/utilities.js`
- `sections/main-collection.liquid`
- `sections/main-blog.liquid`
- `sections/section.liquid`
- `snippets/section.liquid`

---

## Surface 1: Header

**File risk:** `layout/theme.liquid`, `assets/utilities.js`
Header height and transparent-header offset logic is duplicated between these two files; both must stay in sync.

### H-01 Standard header renders at correct height on desktop and mobile

| Field     | Value |
|-----------|-------|
| Page      | Any storefront page (e.g., homepage) |
| Action    | Load the page on desktop (>= 768 px) and a mobile viewport (< 768 px) |
| Selector  | `header-component` |
| Expected  | Header is fully visible, has the correct height, and does not overlap main content |
| File risk | `layout/theme.liquid` inline `setHeaderHeighCustomProperties()`, `assets/utilities.js` `calculateHeaderGroupHeight()` |

### H-02 Transparent header offset is applied when the first section has a transparent background

| Field     | Value |
|-----------|-------|
| Page      | Homepage or any page using a hero section with a transparent header |
| Action    | Enable transparent header in theme editor; load page |
| Selector  | `document.body` CSS variable `--transparent-header-offset-boolean` |
| Expected  | First section content does not hide under the header; offset is applied |
| File risk | `assets/utilities.js` `updateTransparentHeaderOffset()`, `layout/theme.liquid` sync comment |

### H-03 Header group height CSS variable is set before first paint

| Field     | Value |
|-----------|-------|
| Page      | Any page with a sticky or transparent header |
| Action    | Load the page; inspect `document.body` CSS custom properties in DevTools before scrolling |
| Selector  | `--header-height`, `--header-group-height` on `document.body` |
| Expected  | Both CSS variables have numeric pixel values set on `document.body` before interaction |
| File risk | `layout/theme.liquid` inline script, `assets/utilities.js` `calculateHeaderGroupHeight()` |

### H-04 Sticky header remains usable at all scroll positions

| Field     | Value |
|-----------|-------|
| Page      | Any long content page |
| Action    | Scroll down and back up |
| Expected  | Header stays fixed at top, does not flash or jump, correct height is maintained |
| File risk | `layout/theme.liquid`, `sections/header.liquid`, `assets/utilities.js` |

---

## Surface 2: Section Wrapper

**File risk:** `sections/section.liquid`, `snippets/section.liquid`
The generic section wrapper is the shared rendering path for alignment, positioning, mobile stacking, and background media across sections.

### SW-01 Generic section renders in all color schemes without visible bleed

| Field     | Value |
|-----------|-------|
| Page      | Any page using a section that renders through `snippets/section.liquid` |
| Action    | Navigate to the page and inspect sections in their default color scheme |
| Selector  | `.section-background.color-*`, `.section` |
| Expected  | Section background and content are properly contained; no color bleed between adjacent sections |
| File risk | `sections/section.liquid`, `snippets/section.liquid` |

### SW-02 Section wrapper passes alignment and position settings to rendered output

| Field     | Value |
|-----------|-------|
| Page      | A page using `sections/section.liquid` with non-default alignment or position |
| Action    | Open a section in the theme editor and change content alignment (e.g., center, end) |
| Selector  | `.section` alignment/position classes |
| Expected  | Rendered section visually reflects the selected alignment; change takes effect without page reload |
| File risk | `snippets/section.liquid`, `sections/section.liquid` schema settings |

### SW-03 Mobile stacking toggle applies correctly on narrow viewports

| Field     | Value |
|-----------|-------|
| Page      | Any page using a section with horizontal layout and the `vertical_on_mobile` setting |
| Action    | Enable `vertical_on_mobile` in theme editor; resize to mobile viewport |
| Selector  | `.section` layout classes, `snippets/section.liquid` |
| Expected  | Content stacks vertically on mobile; does not break side-by-side layout on desktop |
| File risk | `snippets/section.liquid` mobile stacking logic, `sections/section.liquid` schema |

---

## Surface 3: Collection Runtime

**File risk:** `sections/main-collection.liquid`, `assets/results-list.js`, `assets/facets.js`
Collection filtering, sorting, and pagination are the protected runtime path for later Kanva collection work.

### CR-01 Collection page loads and renders the product grid

| Field     | Value |
|-----------|-------|
| Page      | Any live collection (e.g., `/collections/all`) |
| Action    | Navigate to the collection page |
| Selector  | `results-list`, `.product-grid__item` |
| Expected  | Product grid renders with items visible; `results-list` custom element is present in DOM |
| File risk | `sections/main-collection.liquid` `<results-list>` mount, `assets/results-list.js` |

### CR-02 Filter panel opens and filters apply without full page reload

| Field     | Value |
|-----------|-------|
| Page      | Collection page with at least one facet filter available |
| Action    | Open the filter panel; select a filter option |
| Selector  | `results-list` (updates in place), `.product-grid__item` |
| Expected  | Product list updates without a full page reload; URL updates to reflect filter state; product count changes |
| File risk | `sections/main-collection.liquid` filters block, `assets/facets.js`, `assets/results-list.js` |

### CR-03 Sort-by control changes product order

| Field     | Value |
|-----------|-------|
| Page      | Collection page |
| Action    | Change the sort-by dropdown to a non-default sort order |
| Selector  | `results-list` |
| Expected  | Product order changes to match the selected sort; page does not fully reload |
| File risk | `sections/main-collection.liquid`, `assets/facets.js` sort handling |

### CR-04 Pagination advances to the next page of products

| Field     | Value |
|-----------|-------|
| Page      | Collection with more than one page of products |
| Action    | Click the next-page link or trigger infinite scroll |
| Selector  | `results-list`, `[data-page]` items |
| Expected  | Next page products load correctly; pagination controls update; page number advances |
| File risk | `sections/main-collection.liquid` `infinite-scroll` attribute, `assets/results-list.js` |

### CR-05 Collection page is correct on mobile viewport

| Field     | Value |
|-----------|-------|
| Page      | Collection page |
| Action    | Resize to mobile viewport (< 768 px) |
| Selector  | `.collection-wrapper`, `.product-grid__item` |
| Expected  | Grid layout adapts to mobile columns; filters remain accessible; no horizontal overflow |
| File risk | `sections/main-collection.liquid`, `assets/results-list.js` |

---

## Surface 4: Blog Runtime

**File risk:** `sections/main-blog.liquid`, `assets/blog-posts-list.js`
Blog archive rendering is a protected surface that later Kanva editorial work depends on.

### BR-01 Blog index renders the post archive grid

| Field     | Value |
|-----------|-------|
| Page      | Blog index page (e.g., `/blogs/news`) |
| Action    | Navigate to the blog index page |
| Selector  | `blog-posts-list`, `[data-testid="blog-posts"]`, `[data-testid="blog-post-item"]` |
| Expected  | Blog post grid renders; `blog-posts-list` custom element is present; at least one `blog-post-item` is visible |
| File risk | `sections/main-blog.liquid` `<blog-posts-list>` mount |

### BR-02 Blog archive layout adapts to number of posts (1, 2, 3, 4, 5+ posts)

| Field     | Value |
|-----------|-------|
| Page      | Blog index page |
| Action    | Verify the layout in a browser or theme editor preview for different post counts |
| Selector  | `[data-testid="blog-post-item"]` grid layout |
| Expected  | Single post renders full-width; two posts side-by-side; three posts as hero + two; four posts in 2x2; five or more in compact grid |
| File risk | `sections/main-blog.liquid` `col_span` / `scale` layout logic |

### BR-03 Blog pagination advances to older posts

| Field     | Value |
|-----------|-------|
| Page      | Blog index page with more posts than fit on one page |
| Action    | Click the next-page or older-posts control |
| Selector  | `blog-posts-list`, pagination controls |
| Expected  | Older posts load; page number or URL advances; no full page reload if list uses JS pagination |
| File risk | `sections/main-blog.liquid` pagination block, `assets/blog-posts-list.js` |

### BR-04 Blog index renders correctly on mobile viewport

| Field     | Value |
|-----------|-------|
| Page      | Blog index page |
| Action    | Resize to mobile viewport (< 768 px) |
| Selector  | `[data-testid="blog-posts"]`, `[data-testid="blog-post-item"]` |
| Expected  | Posts stack into a single column or appropriate mobile grid; no horizontal overflow; post images scale correctly |
| File risk | `sections/main-blog.liquid`, responsive grid styles |

---

## Surface 5: Theme Editor (Minimal Checks)

**File risk:** `layout/theme.liquid` (design-mode class), `assets/theme-editor.js`
The theme editor re-renders sections without replaying page-load JS. These checks confirm the protected surfaces remain stable after standard editor operations.

### TE-01 Section can be duplicated without visual breakage

| Field     | Value |
|-----------|-------|
| Page      | Any page with at least one non-core section open in theme editor |
| Action    | Duplicate a section using the theme editor |
| Expected  | Duplicated section renders with correct content; no broken layout, missing images, or JS errors in the editor preview console |
| File risk | `layout/theme.liquid` design-mode behavior, `assets/theme-editor.js` |

### TE-02 Section can be reordered (drag) without header or spacing regression

| Field     | Value |
|-----------|-------|
| Page      | Any page with two or more sections |
| Action    | Drag a section to a new position in the editor sidebar |
| Expected  | Reordered sections maintain correct vertical spacing; header offset does not shift unexpectedly; no CLS visible in editor preview |
| File risk | `assets/utilities.js` header offset recalculation on editor events, `layout/theme.liquid` |

### TE-03 Section settings save and re-render without stale state

| Field     | Value |
|-----------|-------|
| Page      | Any section with visible settings (e.g., color scheme, media, alignment) |
| Action    | Change a setting; observe the editor preview; save |
| Expected  | Preview updates to reflect the new setting; saved state persists after navigating away and returning to the section |
| File risk | `assets/theme-editor.js`, `snippets/section.liquid` conditional renders |

### TE-04 Collection section remains functional after editor save and reload

| Field     | Value |
|-----------|-------|
| Page      | Collection template open in theme editor |
| Action    | Make a minor change (e.g., toggle a setting); save; reload the preview |
| Selector  | `results-list` |
| Expected  | Collection grid and filters continue working after save/reload; no JS errors in editor console |
| File risk | `sections/main-collection.liquid`, `assets/results-list.js`, `assets/theme-editor.js` |

### TE-05 Blog section remains functional after editor save and reload

| Field     | Value |
|-----------|-------|
| Page      | Blog template open in theme editor |
| Action    | Make a minor change; save; reload the preview |
| Selector  | `blog-posts-list`, `[data-testid="blog-posts"]` |
| Expected  | Blog post list continues rendering correctly after save/reload; no JS errors in editor console |
| File risk | `sections/main-blog.liquid`, `assets/blog-posts-list.js`, `assets/theme-editor.js` |

---

## Checklist Summary

| ID    | Surface                  | Action                                     | Pass Criteria |
|-------|--------------------------|--------------------------------------------|---------------|
| H-01  | Header                   | Load page desktop + mobile                 | No overlap, correct height |
| H-02  | Header                   | Transparent header offset                  | First section not hidden under header |
| H-03  | Header                   | CSS variables before first paint           | `--header-height`, `--header-group-height` set |
| H-04  | Header                   | Scroll sticky header                       | No flash or jump |
| SW-01 | Section wrapper          | Load page                                  | No color bleed between sections |
| SW-02 | Section wrapper          | Change alignment in editor                 | Rendered alignment matches selection |
| SW-03 | Section wrapper          | Mobile stacking toggle                     | Vertical on mobile, horizontal on desktop |
| CR-01 | Collection runtime       | Load collection page                       | `results-list` + product grid present |
| CR-02 | Collection runtime       | Apply filter                               | List updates in-place, URL reflects filter |
| CR-03 | Collection runtime       | Change sort order                          | Order changes, no full reload |
| CR-04 | Collection runtime       | Paginate to next page                      | More products load correctly |
| CR-05 | Collection runtime       | Mobile viewport                            | No overflow, filters accessible |
| BR-01 | Blog runtime             | Load blog index                            | `blog-posts-list` + posts visible |
| BR-02 | Blog runtime             | Post count layout variants                 | Correct grid layout per count |
| BR-03 | Blog runtime             | Paginate blog                              | Older posts load |
| BR-04 | Blog runtime             | Mobile viewport                            | No overflow, images scale |
| TE-01 | Theme editor             | Duplicate section                          | No broken layout or JS errors |
| TE-02 | Theme editor             | Reorder section                            | No header or spacing regression |
| TE-03 | Theme editor             | Change and save settings                   | Preview updates, state persists |
| TE-04 | Theme editor             | Collection after save/reload               | Filters and grid functional |
| TE-05 | Theme editor             | Blog after save/reload                     | Post list functional |

---

*Phase: 01-stabilization-and-editor-contract*
*Last updated: 2026-03-28*
*This checklist is the manual smoke source of truth for Phase 1. Run it before merging changes to any protected file listed above.*
