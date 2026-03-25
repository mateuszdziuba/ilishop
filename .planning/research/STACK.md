# Technology Stack

**Project:** Horizon Kanva Theme Rebuild
**Researched:** 2026-03-25
**Scope:** Stack and workflow for adding Kanva-style landing, collections, about, and blog experiences to an existing Shopify OS 2.0 theme
**Overall confidence:** HIGH

## Recommended Stack

This should stay a Shopify-native OS 2.0 theme build on top of Horizon. The standard 2026 stack for this job is not a new app stack. It is `Liquid + JSON templates + sections + theme blocks + snippets + CSS + small ES module enhancements`, developed with Shopify CLI and validated with Theme Check.

`theme-to-clone/` should be treated as a visual reference only. Horizon is the implementation baseline because it already provides the section wrapper pattern, theme block acceptance via `@theme`, app block compatibility via `@app`, import-map-based JS loading, and responsive media/editor patterns that this rebuild needs.

### Core Framework
| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Shopify Online Store 2.0 theme architecture | Current Shopify platform | Base runtime | This work is page and theme-editor customization, not custom application logic. OS 2.0 gives the correct primitives: JSON templates, sections, blocks, snippets, schema settings, and merchant-managed composition. |
| Horizon theme | Existing repo baseline | Implementation foundation | Horizon already includes reusable section/block composition, `_blocks.liquid`, collection/blog primitives, and a modern progressive-enhancement model. Extending it is materially faster and safer than creating a parallel design system inside the same repo. |
| Liquid | Current Shopify runtime | Server-rendered markup and composition | Shopify-native, editor-aware, and already used everywhere in Horizon. It keeps content, merchandising, and page composition in the right layer. |
| JSON templates and section groups | Current Shopify runtime | Page assembly and defaults | Required for reusable page composition and merchant-controlled ordering on home, collection, blog, article, and page templates. |

### Theme Architecture
| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Reusable sections in `sections/` | Current | Page-level composition | Use dedicated Kanva-oriented sections for hero, feature strip, editorial split, testimonial, newsletter, featured articles, and editorial grids. This matches Shopify’s editor model and Horizon’s existing structure. |
| Theme blocks in `blocks/` | Current | Reusable merchant-editable content units | Use blocks for repeated content atoms and layout children that should be insertable inside multiple sections. Horizon already embraces `@theme` blocks and `_blocks.liquid`, which makes this the right abstraction for Kanva-style reusable editorial building blocks. |
| Snippets in `snippets/` | Current | Shared render helpers | Use snippets for pure rendering helpers and shared style logic. Keep snippets non-editor-facing; if the merchant needs to add/reorder/configure it in the editor, it should be a block or section instead. |
| Section schema settings | Current | Merchant-editable controls | Use schema for image/video pickers, desktop/mobile variants, alignment, spacing, aspect ratio, card count, copy, CTA, and decorative toggles. This is the correct OS 2.0 mechanism for responsive editor controls. |
| Existing Horizon helper snippets | Existing repo baseline | Styling and wrapper consistency | Reuse Horizon’s section wrapper and style helper patterns instead of inventing one-off inline styles per page. This keeps Kanva sections consistent with the rest of the theme. |

### Frontend Runtime
| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| CSS in `assets/` | Existing theme approach | Styling and responsive layout | Keep styling in theme assets and reuse Horizon tokens/helpers where possible. Add Kanva-specific section styles incrementally rather than importing the reference site CSS wholesale. |
| Native ES modules with import maps | Existing Horizon approach | Small interactive enhancements | Horizon already uses `<script type="module">` plus import maps in `snippets/scripts.liquid`. Keep that model for sliders, accordions, sticky filters, or progressive blog interactions. |
| Web components / progressive enhancement | Existing Horizon approach | Behavior on top of server HTML | Use only where interaction is needed. Horizon’s JS is designed to enhance server-rendered HTML, not replace it. That matches Shopify theme best practice and avoids editor/runtime drift. |
| Shopify Section Rendering API | Current Shopify platform | Partial refreshes on collection/blog interactions | Reuse Horizon’s collection/blog update patterns for filters, sorting, pagination, and list refreshes instead of adding client-side rendering. |

### Tooling
| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Shopify CLI | Current official CLI | Local development, preview, push, pull, check | This is the official and standard theme workflow. Use `shopify theme dev` for local preview and `shopify theme check` for linting. |
| `shopify.theme.toml` environments | Current official CLI | Multi-store and staged workflow | Standardize dev/staging/prod theme targets in-repo instead of passing flags ad hoc. This matters once Horizon-based work starts moving between development and client stores. |
| Theme Check | Current official linter | Liquid/JSON linting and best-practice enforcement | Required for maintaining a large section/block codebase safely. Run locally and in CI. |
| Shopify Liquid VS Code extension + LiquidDoc | Current official tooling | Editor intelligence and safer snippet/block APIs | LiquidDoc improves completions, hover docs, and parameter validation for snippets and static blocks. This is especially valuable when a theme grows a reusable editorial component system. |
| Git + optional Shopify GitHub integration | Current | Change tracking and deployment discipline | Use normal Git branching in the repo. If store sync to GitHub is used, keep the Shopify-compatible theme folder structure on the connected branch. |

## Prescriptive Implementation Choices

### 1. Build on Horizon, not beside it

Use Horizon’s existing primitives as the substrate:

- `sections/section.liquid` and `sections/_blocks.liquid` already establish the generic wrapper pattern and accept `@theme` blocks.
- `snippets/scripts.liquid` already defines the import-map and module-loading strategy.
- Existing collection and blog sections already show how Horizon handles section rendering, pagination, and progressive enhancement.
- `sections/hero.liquid` already demonstrates the right pattern for separate desktop/mobile media and art-directed responsive controls.

The Kanva rebuild should be a Horizon-flavored component expansion, not a second mini-theme inside the same theme.

### 2. Prefer a reusable section/block system over page-specific markup

Recommended decomposition for this milestone:

| Need | Recommended abstraction | Why |
|------|-------------------------|-----|
| Shared page wrappers, split layouts, stacked editorial content | Section using Horizon wrapper/snippets | Merchant controls belong at section level. |
| Repeated content units like pill labels, stat items, CTA groups, testimonial items, article cards | Theme block | Reusable across landing/about/blog sections and compatible with Shopify’s block model. |
| Pure markup helpers like image rendering variants, card shells, heading treatments, spacing/style emitters | Snippet | Keeps Liquid DRY without over-exposing internal implementation in the editor. |
| Collection grid/filter/sort behavior | Extend Horizon collection primitives | Avoid rebuilding logic that Horizon already solves. |

### 3. Use responsive editor controls sparingly but explicitly

For Kanva-style art direction, add desktop/mobile controls only where the layout truly diverges:

- Separate desktop/mobile image or video pickers
- Separate focal point or content position controls
- Optional mobile stack toggle for split layouts
- Per-breakpoint card count only when layout meaningfully changes

Do not create duplicate settings for every property. The right pattern is “shared default + mobile override when needed”, which is already how Horizon’s hero treats media.

### 4. Keep JS enhancement small and section-scoped

Use JavaScript only for behavior that cannot be expressed cleanly in Liquid/CSS:

- Hero or testimonial sliders
- Sticky collection sidebar/filter drawers
- Accordions
- Lightweight hover or quick-add interactions

Do not move layout composition or content rendering into JavaScript. Shopify themes should remain server-rendered and editor-friendly.

## Standard 2026 Development Workflow

### Day-to-day workflow

1. Start from the existing Horizon repo branch.
2. Connect the repo to a development store with Shopify CLI.
3. Define store/theme targets in `shopify.theme.toml`.
4. Run local preview with `shopify theme dev`.
5. Build new reusable sections/blocks/snippets directly in Shopify theme structure.
6. Validate continuously with `shopify theme check`.
7. Preview pages through JSON templates and real Shopify data objects, not static HTML mocks.
8. Push changes to a non-production theme for merchant QA.
9. Merge into the main theme branch only after editor validation on desktop and mobile breakpoints.

### Recommended repository workflow

| Step | Recommendation | Why |
|------|----------------|-----|
| Baseline sync | Keep an `upstream` remote to Horizon | Horizon is evolving and this repo is explicitly built on it. |
| Feature work | Use small branches per reusable component set | Easier to validate editor behavior and avoid JSON/template conflicts. |
| Store targets | Use CLI environments for dev/staging/prod | Reduces operator error when pushing or previewing. |
| Quality gate | Require Theme Check before merge | Large Liquid systems regress easily without linting. |
| Preview | Validate in an unpublished theme | Safer for merchant/editor QA. |

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| Theme baseline | Extend Horizon | Rebuild from scratch from reference HTML | Slower, throws away existing primitives, and creates unnecessary maintenance debt. |
| Rendering model | Liquid + server rendering | React/Vue/SPA inside theme pages | Wrong abstraction for OS 2.0 page composition, worse editor fit, and unnecessary for the requested experiences. |
| Reuse model | Sections + theme blocks + snippets | One-off page templates with copied markup | Fast initially, expensive immediately after, and hostile to merchant editing. |
| Styling strategy | Incremental Horizon-aligned CSS | Import all `theme-to-clone` CSS as-is | The reference CSS reflects a static site, not Horizon’s architecture or Shopify editor needs. |
| Build pipeline | Buildless/default Shopify theme structure | Introduce Vite/Webpack/PostCSS before needed | Adds complexity and complicates GitHub/store sync. Only justified later if asset authoring requirements outgrow Horizon’s native approach. |
| Interactivity | Progressive enhancement with ES modules | Client-rendered page sections | Breaks Shopify-native composition and duplicates server responsibilities. |
| Product scope | Theme-only rebuild | Custom app for landing/blog/about/collections | Unnecessary. The requested pages are within normal theme scope. |

## What Not To Use

- Do not use `theme-to-clone/` as a source code baseline. It is a visual/content reference only.
- Do not add a generic React/Vite app shell for landing, blog, about, or collections. These pages belong in the Shopify theme.
- Do not copy static HTML into template files and stop there. Convert recurring patterns into sections, theme blocks, and snippets.
- Do not create a second design-token or asset-loading system if Horizon’s existing wrappers, helpers, and import maps can handle it.
- Do not over-model responsive settings. Too many per-breakpoint knobs will make the editor unusable.
- Do not reach for app embeds or theme app extensions unless a feature genuinely requires external application logic. This milestone does not.

## Installation

```bash
# Authenticate Shopify CLI and work against the theme directly
shopify auth login

# Start local theme development
shopify theme dev

# Run theme linting
shopify theme check
```

Optional project config:

```toml
# shopify.theme.toml
[environments.development]
store = "your-dev-store.myshopify.com"
theme = "development"

[environments.staging]
store = "your-staging-store.myshopify.com"
theme = "staging"
```

## Sources

- Shopify CLI: https://shopify.dev/docs/storefronts/themes/tools/cli
- Theme environments for Shopify CLI: https://shopify.dev/docs/storefronts/themes/tools/cli/environments
- Shopify theme sections architecture: https://shopify.dev/docs/storefronts/themes/architecture/sections
- Theme blocks quick start: https://shopify.dev/docs/storefronts/themes/architecture/blocks/theme-blocks/quick-start?framework=liquid
- AI-generated theme blocks and `_blocks.liquid` wrapper behavior: https://shopify.dev/docs/storefronts/themes/architecture/blocks/ai-generated-theme-blocks
- Theme Check: https://shopify.dev/docs/storefronts/themes/tools/theme-check
- Theme Check checks reference: https://shopify.dev/docs/storefronts/themes/tools/theme-check/checks/index
- LiquidDoc: https://shopify.dev/docs/storefronts/themes/tools/liquid-doc
- Version control for Shopify themes: https://shopify.dev/docs/storefronts/themes/best-practices/version-control
- Local project context: `/Users/mati/Mine/horizon/.planning/PROJECT.md`
- Local codebase stack: `/Users/mati/Mine/horizon/.planning/codebase/STACK.md`
- Local codebase architecture: `/Users/mati/Mine/horizon/.planning/codebase/ARCHITECTURE.md`
- Horizon repo guidance: `/Users/mati/Mine/horizon/README.md`
- Visual reference only: `/Users/mati/Mine/horizon/theme-to-clone/kanva-docs.md`
