# Architecture

**Analysis Date:** 2026-03-25

## Pattern Overview

**Overall:** Shopify Online Store 2.0 theme architecture with server-rendered Liquid, JSON template composition, and progressive enhancement through native web components.

**Key Characteristics:**
- Primary rendering happens on Shopify servers through Liquid layouts, sections, blocks, snippets, and template JSON files such as `layout/theme.liquid`, `sections/product-information.liquid`, and `templates/product.json`.
- Page composition is configuration-driven: JSON templates such as `templates/index.json`, `templates/collection.json`, and section group files such as `sections/header-group.json` select which sections and blocks appear.
- Client-side code in `assets/*.js` enhances server-rendered markup with custom elements, event-driven updates, and Shopify Section Rendering API hydration instead of taking over full page rendering.

## Layers

**Layout Layer:**
- Purpose: Define the HTML document shell, include global assets, and place shared header/footer/search UI around page content.
- Location: `layout/`
- Contains: `layout/theme.liquid`, `layout/password.liquid`
- Depends on: global snippets such as `snippets/meta-tags.liquid`, `snippets/stylesheets.liquid`, `snippets/scripts.liquid`, `snippets/theme-styles-variables.liquid`, `snippets/color-schemes.liquid`
- Used by: all JSON and Liquid templates via Shopify theme runtime

**Template Configuration Layer:**
- Purpose: Map page types to sections and default block trees.
- Location: `templates/` and section group JSON files in `sections/`
- Contains: JSON templates such as `templates/index.json`, `templates/product.json`, `templates/collection.json`, plus group configs `sections/header-group.json` and `sections/footer-group.json`
- Depends on: section types named in each JSON object, for example `hero`, `product-information`, `main-collection`, `footer`
- Used by: Shopify page routing for home, product, collection, search, cart, blog, and password pages

**Section Layer:**
- Purpose: Own page-level or region-level rendering, schema, and section-specific composition.
- Location: `sections/`
- Contains: top-level sections such as `sections/header.liquid`, `sections/footer.liquid`, `sections/main-collection.liquid`, `sections/product-information.liquid`, `sections/hero.liquid`
- Depends on: `content_for 'blocks'`, block types, and reusable snippets such as `snippets/section.liquid`, `snippets/product-information-content.liquid`, `snippets/product-grid.liquid`
- Used by: templates and section groups

**Block Layer:**
- Purpose: Define configurable units that sections can render statically or dynamically through Shopify theme blocks.
- Location: `blocks/`
- Contains: generic blocks such as `blocks/text.liquid`, `blocks/button.liquid`, `blocks/group.liquid`; structural/internal blocks prefixed with `_` such as `blocks/_product-card.liquid`, `blocks/_product-details.liquid`, `blocks/_header-menu.liquid`
- Depends on: block settings, `closest.*` context, and lower-level snippets
- Used by: sections through `content_for 'block'` and `content_for 'blocks'`, plus JSON template block trees

**Snippet Layer:**
- Purpose: Hold reusable render primitives and style helpers that sections and blocks delegate to.
- Location: `snippets/`
- Contains: structural snippets such as `snippets/section.liquid`, `snippets/group.liquid`, `snippets/product-card.liquid`, `snippets/product-grid.liquid`, `snippets/product-information-content.liquid`; helper snippets such as `snippets/spacing-style.liquid`, `snippets/layout-panel-style.liquid`, `snippets/border-override.liquid`
- Depends on: data passed in from layouts, sections, and blocks
- Used by: nearly every Liquid layer through `{% render %}`

**Client Enhancement Layer:**
- Purpose: Upgrade server-rendered HTML with behavior for menus, carts, filters, product forms, slideshows, quick add, predictive search, and section morphing.
- Location: `assets/*.js`
- Contains: foundational modules `assets/component.js`, `assets/utilities.js`, `assets/events.js`, `assets/section-renderer.js`, `assets/section-hydration.js`; feature modules such as `assets/product-form.js`, `assets/facets.js`, `assets/header.js`, `assets/cart-drawer.js`
- Depends on: import map in `snippets/scripts.liquid`, custom elements API, fetch, DOM events, Shopify global context
- Used by: markup emitted by Liquid templates and snippets

**Theme Configuration Layer:**
- Purpose: Define theme settings, editor-managed defaults, and translations.
- Location: `config/` and `locales/`
- Contains: `config/settings_schema.json`, `config/settings_data.json`, locale files such as `locales/en.default.json`
- Depends on: Shopify theme settings and translation runtime
- Used by: Liquid files via `settings.*` and translation keys such as `'products.product.add_to_cart' | t`

## Data Flow

**Full Page Render:**

1. Shopify resolves a page type to a template such as `templates/index.json`, `templates/product.json`, or `templates/collection.json`.
2. `layout/theme.liquid` or `layout/password.liquid` builds the document shell, injects global snippets, and renders `{{ content_for_layout }}`.
3. The template-selected section files in `sections/` render markup and schema, often delegating structure to snippets such as `snippets/section.liquid` or `snippets/product-information-content.liquid`.
4. Sections collect block markup with `content_for 'blocks'` or targeted block captures such as `content_for 'block', type: '_product-details'`.
5. Blocks render finer-grained snippets and helper snippets, producing final HTML, inline CSS blocks, and occasional inline JS blocks.

**Header/Footer Group Composition:**

1. `layout/theme.liquid` renders `{% sections 'header-group' %}` and `{% sections 'footer-group' %}`.
2. `sections/header-group.json` and `sections/footer-group.json` define which sections appear in those regions and their default block trees.
3. Region sections such as `sections/header.liquid` and `sections/footer.liquid` capture specific internal blocks like `_header-logo`, `_header-menu`, `footer-copyright`, and `social-links`.
4. Snippets such as `snippets/header-actions.liquid`, `snippets/header-row.liquid`, and `snippets/localization-form.liquid` assemble the final region UI.

**Product Page Composition:**

1. `templates/product.json` places the `product-information` section as the main section for product pages.
2. `sections/product-information.liquid` captures `_product-media-gallery` and `_product-details` blocks and any additional blocks from `content_for 'blocks'`.
3. `snippets/product-information-content.liquid` decides media/details ordering, width, and grid behavior from section settings.
4. Blocks under `_product-details` render feature blocks such as `price`, `variant-picker`, `buy-buttons`, `sku`, and `product-description`.
5. Client modules such as `assets/product-form.js`, `assets/variant-picker.js`, `assets/product-price.js`, `assets/product-sku.js`, and `assets/sticky-add-to-cart.js` attach behavior to the rendered DOM.

**Collection/Search Progressive Updates:**

1. `sections/main-collection.liquid` and `sections/search-results.liquid` render a `<results-list>` container and product grid using `snippets/product-grid.liquid`.
2. Filter UI is rendered via the `filters` block in `blocks/filters.liquid`.
3. Client modules such as `assets/facets.js`, `assets/results-list.js`, and `assets/paginated-list.js` handle filtering, sorting, pagination, and infinite scroll.
4. When a section needs refreshed HTML, `assets/section-renderer.js` requests `?section_id=...` from Shopify and morphs the existing section DOM instead of reloading the full page.

**State Management:**
- Server state comes from Shopify objects exposed to Liquid such as `product`, `collection`, `settings`, `request`, and `localization`.
- Editor-managed persistent configuration lives in `config/settings_data.json` and the JSON templates/section group files.
- Client state is local and ephemeral, stored in component instances, DOM attributes, session storage, and custom events defined in `assets/events.js`.

## Key Abstractions

**Section Wrapper Pattern:**
- Purpose: Standardize spacing, width, background media, borders, and overlay behavior for generic sections.
- Examples: `sections/section.liquid`, `sections/_blocks.liquid`, `snippets/section.liquid`
- Pattern: sections capture block children, then delegate layout rendering to a single wrapper snippet

**Theme Block Composition Pattern:**
- Purpose: Build nested configurable UI from Shopify block definitions rather than hardcoded page markup.
- Examples: `templates/index.json`, `templates/product.json`, `blocks/group.liquid`, `blocks/_product-card.liquid`
- Pattern: JSON declares block trees, sections capture block output, internal `_` blocks provide reusable structural building blocks

**Progressive Enhancement Component Base:**
- Purpose: Provide a shared base for custom elements with ref management and declarative event binding.
- Examples: `assets/component.js`, `assets/header.js`, `assets/product-form.js`, `assets/facets.js`
- Pattern: feature modules extend `Component`, define refs via `ref` attributes in markup, and bind actions with `on:event="selector/method"`

**Section Rendering API Adapter:**
- Purpose: Re-render sections from Shopify without full-page refreshes.
- Examples: `assets/section-renderer.js`, `assets/section-hydration.js`
- Pattern: fetch `?section_id=...`, parse returned HTML, morph target section, optionally hydrate only `data-hydration-key` nodes

**Shared Style Helper Snippets:**
- Purpose: Keep section and block appearance configurable without duplicating inline style logic.
- Examples: `snippets/spacing-style.liquid`, `snippets/layout-panel-style.liquid`, `snippets/border-override.liquid`, `snippets/typography-style.liquid`
- Pattern: snippets emit CSS custom properties or inline style fragments consumed by section/block wrappers

## Entry Points

**Main Theme Layout:**
- Location: `layout/theme.liquid`
- Triggers: all non-password storefront pages
- Responsibilities: load global assets, render header/footer section groups, expose `content_for_header`, render `content_for_layout`, and include global modals like `snippets/search-modal.liquid` and `snippets/quick-add-modal.liquid`

**Password Layout:**
- Location: `layout/password.liquid`
- Triggers: password-protected storefront mode
- Responsibilities: load a reduced shell, render `content_for_layout`, attach `password-footer`, and render the storefront password dialog

**Home Template:**
- Location: `templates/index.json`
- Triggers: storefront home page
- Responsibilities: define default home composition through sections such as `hero` and `product-list`

**Product Template:**
- Location: `templates/product.json`
- Triggers: product detail pages
- Responsibilities: define the `product-information` section and its default block hierarchy

**Collection Template:**
- Location: `templates/collection.json`
- Triggers: collection pages
- Responsibilities: define an introductory generic `section` plus `main-collection` for filters and product grid rendering

**Header Group Configuration:**
- Location: `sections/header-group.json`
- Triggers: rendered by `layout/theme.liquid`
- Responsibilities: define the header announcement and header section instances used across the theme

**Footer Group Configuration:**
- Location: `sections/footer-group.json`
- Triggers: rendered by `layout/theme.liquid`
- Responsibilities: define footer content and utility sections used across the theme

## Error Handling

**Strategy:** Lean toward resilient rendering on the server, then guard client behavior with DOM existence checks and event-driven fallbacks instead of centralized exception handling.

**Patterns:**
- Liquid templates prefer conditional rendering based on object availability, for example checking `settings.*`, `product_has_media`, or `current_variant.available` in `sections/product-information.liquid`.
- JavaScript modules frequently return early when required DOM nodes are absent, as seen in `assets/section-hydration.js`, `assets/section-renderer.js`, `assets/component.js`, and inline scripts in `layout/theme.liquid`.
- Component infrastructure throws only for explicit contract violations such as missing required refs in `assets/component.js`.
- Section morphing throws targeted errors when the target section is missing from either the live DOM or the fetched response in `assets/section-renderer.js`.

## Cross-Cutting Concerns

**Logging:** Not a formal subsystem. Client scripts rely primarily on control flow and exceptions; no centralized logger was detected in `assets/`.

**Validation:** Shopify schema definitions in `sections/*.liquid`, `blocks/*.liquid`, and `config/settings_schema.json` enforce editor-facing configuration. Runtime guards in Liquid and JS handle missing data.

**Authentication:** Storefront authentication is platform-provided by Shopify. The theme only renders authentication-related UI hooks such as password access in `layout/password.liquid` and account-related header actions in `sections/header.liquid`.

---

*Architecture analysis: 2026-03-25*
