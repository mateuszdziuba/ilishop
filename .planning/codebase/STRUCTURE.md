# Codebase Structure

**Analysis Date:** 2026-03-25

## Directory Layout

```text
horizon/
├── assets/               # Client JavaScript, global CSS, SVG icons, and type hints
├── blocks/               # Shopify theme block implementations, including internal `_` blocks
├── config/               # Theme schema and editor-managed settings data
├── layout/               # Global document shells for normal and password pages
├── locales/              # Translation dictionaries and schema locale files
├── sections/             # Section implementations and section-group JSON configs
├── snippets/             # Reusable Liquid render primitives and style helpers
├── templates/            # Page-type template JSON files plus gift card Liquid template
├── .planning/codebase/   # Generated architecture mapping documents
├── README.md             # Project-level theme overview and developer guidance
└── release-notes.md      # Theme release summary
```

## Directory Purposes

**`assets/`:**
- Purpose: Hold all frontend runtime code and static assets loaded by the theme.
- Contains: ES modules such as `assets/component.js`, `assets/product-form.js`, `assets/facets.js`; stylesheets such as `assets/base.css`; icons such as `assets/icon-cart.svg`
- Key files: `assets/component.js`, `assets/section-renderer.js`, `assets/section-hydration.js`, `assets/utilities.js`, `assets/events.js`, `assets/base.css`, `assets/jsconfig.json`

**`layout/`:**
- Purpose: Define the page shell around Shopify-rendered page content.
- Contains: `layout/theme.liquid` and `layout/password.liquid`
- Key files: `layout/theme.liquid`, `layout/password.liquid`

**`templates/`:**
- Purpose: Bind Shopify page types to section trees and default instances.
- Contains: JSON templates such as `templates/index.json`, `templates/product.json`, `templates/collection.json`, plus `templates/gift_card.liquid`
- Key files: `templates/index.json`, `templates/product.json`, `templates/collection.json`, `templates/search.json`, `templates/cart.json`, `templates/gift_card.liquid`

**`sections/`:**
- Purpose: Hold page sections and region sections with schema and section-specific rendering logic.
- Contains: standalone sections such as `sections/hero.liquid`, `sections/main-collection.liquid`, `sections/product-information.liquid`; region/group configs `sections/header-group.json`, `sections/footer-group.json`
- Key files: `sections/header.liquid`, `sections/footer.liquid`, `sections/section.liquid`, `sections/main-collection.liquid`, `sections/product-information.liquid`, `sections/header-group.json`, `sections/footer-group.json`

**`blocks/`:**
- Purpose: Define reusable theme blocks that sections can embed through Shopify block APIs.
- Contains: public blocks such as `blocks/text.liquid`, `blocks/button.liquid`, `blocks/price.liquid`; internal structural blocks prefixed with `_` such as `blocks/_product-card.liquid`, `blocks/_product-details.liquid`, `blocks/_header-menu.liquid`
- Key files: `blocks/group.liquid`, `blocks/text.liquid`, `blocks/price.liquid`, `blocks/variant-picker.liquid`, `blocks/_product-card.liquid`, `blocks/_product-details.liquid`, `blocks/_header-menu.liquid`

**`snippets/`:**
- Purpose: Centralize shared rendering fragments and style helper utilities.
- Contains: view snippets such as `snippets/product-card.liquid`, `snippets/product-grid.liquid`, `snippets/product-information-content.liquid`; utility snippets such as `snippets/spacing-style.liquid`, `snippets/layout-panel-style.liquid`
- Key files: `snippets/section.liquid`, `snippets/group.liquid`, `snippets/product-card.liquid`, `snippets/product-grid.liquid`, `snippets/product-information-content.liquid`, `snippets/scripts.liquid`, `snippets/stylesheets.liquid`

**`config/`:**
- Purpose: Store global theme schema and store-specific theme settings.
- Contains: `config/settings_schema.json`, `config/settings_data.json`
- Key files: `config/settings_schema.json`, `config/settings_data.json`

**`locales/`:**
- Purpose: Store translatable storefront strings and theme schema locale files.
- Contains: locale JSON files such as `locales/en.default.json`, `locales/pl.json`, `locales/de.json`, plus schema locale files such as `locales/en.default.schema.json`
- Key files: `locales/en.default.json`, `locales/en.default.schema.json`

## Key File Locations

**Entry Points:**
- `layout/theme.liquid`: Main storefront document shell
- `layout/password.liquid`: Password storefront shell
- `templates/index.json`: Home page composition
- `templates/product.json`: Product page composition
- `templates/collection.json`: Collection page composition
- `sections/header-group.json`: Shared header region config
- `sections/footer-group.json`: Shared footer region config

**Configuration:**
- `config/settings_schema.json`: Theme settings definitions exposed in the Shopify editor
- `config/settings_data.json`: Editor-managed current settings and preset data
- `assets/jsconfig.json`: JavaScript path alias/editor config for asset modules
- `locales/en.default.json`: Default storefront translation set

**Core Logic:**
- `sections/product-information.liquid`: Product detail page composition
- `sections/main-collection.liquid`: Collection results page composition
- `sections/header.liquid`: Header orchestration and row ordering logic
- `snippets/product-information-content.liquid`: Shared product page media/details layout
- `snippets/product-grid.liquid`: Shared collection/search grid layout
- `assets/component.js`: Custom element base class and declarative event system
- `assets/section-renderer.js`: Section Rendering API adapter and DOM morphing
- `assets/section-hydration.js`: Deferred section hydration entry point
- `assets/events.js`: Shared custom event definitions

**Testing:**
- Not detected. No test directory or test files were found in the project root during this architecture pass.

## Naming Conventions

**Files:**
- Liquid sections use kebab-case file names such as `sections/main-collection.liquid` and `sections/product-information.liquid`.
- Liquid snippets use kebab-case file names such as `snippets/product-grid.liquid` and `snippets/layout-panel-style.liquid`.
- Theme blocks use kebab-case names; internal or structural blocks are prefixed with `_`, for example `blocks/_product-card.liquid` and `blocks/_header-logo.liquid`.
- Asset modules use kebab-case file names such as `assets/product-form.js`, `assets/cart-drawer.js`, and `assets/view-transitions.js`.
- Template files are mostly page-type JSON names such as `templates/page.contact.json`, `templates/list-collections.json`, and `templates/search.json`.

**Directories:**
- Top-level theme directories follow Shopify theme conventions: `layout/`, `templates/`, `sections/`, `blocks/`, `snippets/`, `assets/`, `config/`, `locales/`.

## Where to Add New Code

**New Feature:**
- Primary code: add a section in `sections/` if the feature needs its own page region, or add a block in `blocks/` if the feature should be inserted into existing sections.
- Tests: Not applicable in-repo. No existing automated test location was detected.

**New Component/Module:**
- Implementation: add reusable Liquid presentation in `snippets/` and behavior in `assets/` if the feature needs client-side enhancement.
- If the feature is a new interactive custom element, follow the pattern of `assets/component.js` and place the module in `assets/` with a kebab-case name such as `assets/your-feature.js`.

**Utilities:**
- Shared Liquid helpers: place in `snippets/`, following existing helper naming such as `snippets/spacing-style.liquid` or `snippets/util-product-grid-card-size.liquid`.
- Shared JavaScript helpers: extend `assets/utilities.js` only for broadly reusable browser/runtime helpers; feature-specific helpers should stay near the feature module in `assets/`.

## Placement Guidance

**Add a new full-page or major region section when:**
- The Shopify editor should let merchants add, remove, or reorder the unit at page level.
- Place the implementation in `sections/`.
- Add or update template wiring in the appropriate `templates/*.json` file if the section should appear by default.

**Add a new reusable block when:**
- The UI should be insertable inside existing sections through block configuration.
- Place the implementation in `blocks/`.
- Use a leading `_` for internal structural blocks that are intended to be captured by sections or other blocks, matching files such as `blocks/_product-details.liquid` and `blocks/_product-card-gallery.liquid`.

**Add a new snippet when:**
- Multiple sections or blocks would otherwise duplicate the same markup or inline style generation.
- Place the implementation in `snippets/`.
- Prefer passing explicit parameters and rendering it from callers, matching `snippets/product-information-content.liquid` and `snippets/section.liquid`.

**Add a new asset module when:**
- The feature needs browser behavior, custom elements, or Shopify section re-render support.
- Place the module in `assets/`.
- Register the asset in `snippets/scripts.liquid` if it must be globally loaded or import-mapped.

## Structural Patterns

**Template-to-section mapping:**
- JSON templates in `templates/` declare section instances and block trees.
- Use `templates/product.json` and `templates/collection.json` as the reference pattern for adding default section instances.

**Section-to-block composition:**
- Sections frequently capture block output using `content_for 'blocks'` or targeted `content_for 'block'`.
- Use `sections/section.liquid`, `sections/product-information.liquid`, and `sections/header.liquid` as composition references.

**Block-to-snippet delegation:**
- Many blocks are thin wrappers over reusable snippets.
- Use `blocks/button.liquid`, `blocks/group.liquid`, and `blocks/product-card.liquid` as the reference pattern.

**Asset behavior attachment:**
- JavaScript behavior is attached to server-rendered HTML through custom elements and `ref`/`on:event` attributes.
- Use `assets/component.js`, `assets/header.js`, `assets/product-form.js`, and `assets/facets.js` as the reference pattern.

## Special Directories

**`sections/header-group.json` and `sections/footer-group.json`:**
- Purpose: Store section-group configuration used by the main layout.
- Generated: Yes
- Committed: Yes

**`templates/*.json`:**
- Purpose: Store page template composition and defaults.
- Generated: Often editor-managed after creation
- Committed: Yes

**`config/settings_data.json`:**
- Purpose: Store current theme configuration and preset selections.
- Generated: Yes
- Committed: Yes

**`.planning/codebase/`:**
- Purpose: Store generated codebase mapping documents for the GSD workflow.
- Generated: Yes
- Committed: Typically yes if the workflow tracks planning artifacts

---

*Structure analysis: 2026-03-25*
