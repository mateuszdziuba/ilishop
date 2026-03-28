# Phase 1: Regression Baseline

**Established:** 2026-03-28
**Purpose:** Records the protected-file inventory and expected Theme Check quality state at Phase 1 start.
Downstream contributors use this baseline to confirm Phase 1 changes do not introduce new errors or silent regressions in the shared runtime.

---

## Protected File Inventory

These files represent the shared runtime surfaces that later Kanva phases depend on.
Changes to them require a full smoke pass using `01-protected-runtime-checklist.md` before merge.

### layout/theme.liquid

**Why protected:**
Owns the inline `setHeaderHeighCustomProperties()` bootstrap script that sets `--header-height` and `--header-group-height` CSS variables before first paint. The code comment explicitly notes that any changes to this function must be kept in sync with `calculateHeaderGroupHeight()`, `updateTransparentHeaderOffset()`, and `setHeaderMenuStyle()` in `assets/utilities.js`.

**Fragility notes:**
- Header height/transparent-offset logic is duplicated between this file and `assets/utilities.js`. Both copies must stay in sync.
- Transparent header behavior is timing-sensitive; inline calculations run before JS hydration.
- Checked with `shopify theme check` at Phase 1 start: no errors detected in this file.

### assets/utilities.js

**Why protected:**
Contains `calculateHeaderGroupHeight()`, `updateTransparentHeaderOffset()`, and `setHeaderMenuStyle()` — the JS-side implementations of the same header sizing logic bootstrapped in `layout/theme.liquid`. Also provides the `requestIdleCallback` fallback export used in `assets/predictive-search.js`.

**Fragility notes:**
- Must stay synchronized with `layout/theme.liquid` inline script.
- `requestIdleCallback` export addresses a known cross-browser fragility (Pitfall: predictive search throws on browsers without native `requestIdleCallback`).
- Not a Liquid file; not checked by `shopify theme check`. Regression risk is runtime-only.

### sections/main-collection.liquid

**Why protected:**
Owns the `<results-list>` custom element mount, collection filter block wiring, infinite-scroll attribute, and product grid markup. Later Kanva collection phases must style and compose around this section, not replace it.

**Fragility notes:**
- Collection filtering and pagination are runtime-JS-dependent (`assets/results-list.js`, `assets/facets.js`).
- The `infinite-scroll` attribute on `<results-list>` is a public API consumed by JS; changing it breaks client behavior silently.
- `shopify theme check` at Phase 1 start: no errors detected in this file.

### sections/main-blog.liquid

**Why protected:**
Owns the `<blog-posts-list>` custom element mount, blog archive grid layout logic (col_span, scale per post count), and `data-testid` attributes used in smoke checks.

**Fragility notes:**
- Layout branching logic (1/2/3/4/5+ posts) is handled in Liquid inside this file. Changes to the branching logic can break the grid layout silently for specific post counts.
- `blog-posts-list` is a stable selector for smoke testing; do not remove or rename it.
- `shopify theme check` at Phase 1 start: no errors detected in this file.

### sections/section.liquid

**Why protected:**
The canonical shared layout vocabulary for Kanva editorial sections. Exposes content_direction, alignment, position, vertical_on_mobile, background media, and spacing controls that all later Kanva sections must reuse.

**Fragility notes:**
- Changing schema setting IDs here will silently break existing saved theme data for any section that inherits them.
- `visible_if` conditions in this file depend on supported setting types; do not extend to setting types that do not support conditional display.
- `shopify theme check` at Phase 1 start: no errors detected in this file.

### snippets/section.liquid

**Why protected:**
The shared rendering path for the section wrapper. Background image and video positioning, mobile column behavior, and spacing-style CSS variables all flow through this snippet.

**Fragility notes:**
- Background media rendering calls `{% render 'background-media' ... %}` — any upstream change to `snippets/background-media.liquid` can have blast radius here.
- Mobile column behavior (`vertical_on_mobile`) is rendered in this file; CSS must remain consistent.
- `shopify theme check` at Phase 1 start: no errors detected in this file.

---

## Theme Check Baseline

**Command used:** `shopify theme check --fail-level error`
**Shopify CLI version:** 3.91.0 (detected locally 2026-03-25)

**Baseline state at Phase 1 start (2026-03-28):**

Theme Check reports 297 files inspected, 2 errors and 23 warnings in the Horizon codebase before any Phase 1 modifications. Both errors are in `sections/header.liquid` and are pre-existing Horizon patterns, not Phase 1 regressions.

**Known pre-existing errors (do not fix in Phase 1 — out of scope):**

| File | Check | Description | Notes |
|------|-------|-------------|-------|
| `sections/header.liquid` line 53 | `UniqueStaticBlockId` | `id: 'header-menu'` used for mobile `_header-menu` block | Intentional Horizon pattern: three `content_for 'block'` calls share the same `id` with different `variant:` parameters. Theme Check flags this as duplicate, but the variant disambiguation is by design. |
| `sections/header.liquid` line 57 | `UniqueStaticBlockId` | `id: 'header-menu'` used for `navigation_bar` variant | Same as above — intentional variant reuse. |

These errors exist in the upstream Horizon codebase and predate all Phase 1 work. Phase 1 contributors should not attempt to fix them; doing so could break the header's multi-variant menu structure.

**Known pre-existing warnings (selected):**
- `blocks/_card.liquid`: `UnrecognizedRenderSnippetArguments` — `background_video_loop` argument passed to `background-media` snippet. Pre-existing Horizon pattern.
- `layout/theme.liquid`, `layout/password.liquid`: `RemoteAsset` warning for `href="#MainContent"` (fragment link). False positive; not a remote asset.
- Various snippets: `UndefinedObject` warnings for `block`, `section` — snippets called from `content_for 'block'` contexts where Theme Check cannot resolve the parent scope.
- The `{% # theme-check-disable %}` comment in `sections/main-collection.liquid` suppresses a known false-positive for the `content_for 'block'` call at the product card loop. This is intentional and predates Phase 1.

**Phase 1 gate policy:**
The gate uses `--fail-level error` to catch new errors introduced by Phase 1 changes. The two pre-existing header errors will cause `shopify theme check --fail-level error` to exit non-zero. This is an expected false positive at the gate level. Contributors must verify that any gate failure is caused by the known pre-existing errors (listed above) and not by new errors they introduced.

See `scripts/phase1-regression-gate.sh` — the script documents this behavior and prints the baseline reference on failure so contributors can distinguish new from pre-existing issues.

**Phase gate command:**
```bash
sh scripts/phase1-regression-gate.sh
```

This command runs `shopify theme check --fail-level error` and prints the smoke checklist path on success. Contributors should run it before submitting any PR that touches a protected file.

---

## Responsive Editor Contract Baseline

Phase 1 locks the following rules for later Kanva sections. This baseline records them so deviations are detectable:

| Rule | Description | Source |
|------|-------------|--------|
| D-01 | Desktop default + optional mobile override; no dual content trees | `01-CONTEXT.md` |
| D-05 | Desktop media is source of truth; mobile is an opt-in override | `01-CONTEXT.md` |
| D-06 | Blank/disabled mobile media falls back to desktop media, not empty slot | `sections/hero.liquid` pattern |
| D-07 | Allowed mobile overrides: separate media pickers and layout-position controls only | `01-CONTEXT.md` |
| D-08 | Shared media-rendering helper preferred over per-section fallback branches | `snippets/background-media.liquid` |

**Canonical reference for later phases:**
Before building a new Kanva section, a downstream agent must read:
- `sections/hero.liquid` — desktop/mobile override pattern with blank-check logic
- `sections/section.liquid` — shared layout vocabulary
- `snippets/section.liquid` — shared wrapper render path
- `snippets/background-media.liquid` — shared background media render path

Sections that deviate from these patterns without documenting the reason should be treated as regressions against Phase 1.

---

*Phase: 01-stabilization-and-editor-contract*
*Last updated: 2026-03-28*
