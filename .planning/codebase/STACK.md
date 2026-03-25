# Technology Stack

**Analysis Date:** 2026-03-25

## Languages

**Primary:**
- Liquid - Primary templating language for storefront rendering across `layout/theme.liquid`, `sections/*.liquid`, `blocks/*.liquid`, `snippets/*.liquid`, and `templates/*.liquid`.
- JavaScript (ES modules) - Client-side behavior in `assets/*.js`, loaded with `<script type="module">` and an import map in `snippets/scripts.liquid`.
- CSS - Theme styling in `assets/base.css`, `assets/overflow-list.css`, and `assets/template-giftcard.css`.

**Secondary:**
- JSON - Theme configuration and localization data in `config/settings_schema.json`, `config/settings_data.json`, `sections/*.json`, and `locales/*.json`.
- TypeScript declarations - JSDoc/JS typing support via `assets/global.d.ts`.
- SVG - Static icon assets in `assets/*.svg`.

## Runtime

**Environment:**
- Shopify Liquid storefront runtime - Server-rendered by Shopify, stated in `README.md` and implemented through `layout/theme.liquid`.
- Browser runtime targeting modern web APIs - `assets/jsconfig.json` sets `target` to `ES2020`, and the code uses `customElements`, `IntersectionObserver`, `AbortController`, `ResizeObserver`, `URL`, `importmap`, `localStorage`, and `sessionStorage` in files such as `assets/product-recommendations.js`, `assets/component-cart-items.js`, `assets/morph.js`, and `assets/view-transitions.js`.

**Package Manager:**
- Not detected. No `package.json`, `pnpm-lock.yaml`, `package-lock.json`, `yarn.lock`, `bun.lockb`, `pyproject.toml`, `Cargo.toml`, or `go.mod` is present at the project root.
- Lockfile: missing

## Frameworks

**Core:**
- Shopify theme architecture - Liquid templates, sections, blocks, snippets, and config drive the application structure in `layout/theme.liquid`, `sections/product-recommendations.liquid`, `blocks/*.liquid`, and `config/settings_schema.json`.
- Web Components / Custom Elements - UI behavior is implemented as custom elements in files such as `assets/component.js`, `assets/product-form.js`, `assets/predictive-search.js`, and `assets/header.js`.
- Import maps for module resolution - `snippets/scripts.liquid` maps `@theme/*` module specifiers to asset URLs.

**Testing:**
- Not detected in-repo. No `vitest.config.*`, `jest.config.*`, Playwright config, or test files are present.
- Theme Check is recommended operationally in `README.md`, but no local config file or workflow file is present in this checkout.

**Build/Dev:**
- Shopify CLI - Recommended in `README.md` for local theme development, preview, and theme operations.
- JS static checking via editor tooling - `assets/jsconfig.json` enables `checkJs`, `noImplicitAny`, `noUncheckedIndexedAccess`, and `strictNullChecks`.

## Key Dependencies

**Critical:**
- Shopify platform primitives - `layout/theme.liquid` injects `{{ content_for_header }}` and `snippets/scripts.liquid` exposes Shopify route data to the client.
- Shopify Section Rendering API - Used by `assets/section-renderer.js`, `assets/component-cart-items.js`, `assets/facets.js`, and `assets/local-pickup.js` to refresh partial HTML from Shopify.
- Shopify product recommendations endpoint - Wired by `sections/product-recommendations.liquid` and consumed in `assets/product-recommendations.js`.
- Shopify predictive search endpoint - Injected in `snippets/scripts.liquid` and used in `assets/predictive-search.js`.

**Infrastructure:**
- Shopify custom element features - `assets/media.js` calls `Shopify.loadFeatures` to load `model-viewer-ui`.
- Internal QR code generator - `assets/qr-code-generator.js` provides QR code rendering for `assets/qr-code-image.js`.
- Theme aliasing - `assets/jsconfig.json` maps `@theme/*` to local asset modules.

## Configuration

**Environment:**
- No `.env` or other environment-variable file was detected at the project root.
- Runtime configuration is provided by Shopify Liquid globals and theme settings, not process env vars.
- Storefront routes and translations are serialized into the `Theme` global in `snippets/scripts.liquid`.
- Merchant-editable theme settings live in `config/settings_schema.json` and persisted values live in `config/settings_data.json`.

**Build:**
- `assets/jsconfig.json` configures editor/static-analysis behavior for JavaScript assets.
- `layout/theme.liquid` composes the runtime by rendering `snippets/scripts.liquid`, `snippets/stylesheets.liquid`, and other shared snippets.
- `snippets/scripts.liquid` is the effective module-loading and preload manifest for the front end.

## Platform Requirements

**Development:**
- Shopify store access plus Shopify CLI, per `README.md`.
- A modern browser environment that supports ES modules and current DOM APIs used in `assets/*.js`.
- Theme-aware editor support is expected; `README.md` references Theme Check and the VS Code extension list, although `.vscode/` is not present in this checkout.

**Production:**
- Deployment target is Shopify Online Store theme infrastructure.
- Server-side rendering, cart routes, search routes, product recommendation routes, customer account rendering, and dynamic app blocks all rely on Shopify runtime services in `layout/theme.liquid`, `sections/header.liquid`, `sections/product-recommendations.liquid`, and `assets/morph.js`.

---

*Stack analysis: 2026-03-25*
