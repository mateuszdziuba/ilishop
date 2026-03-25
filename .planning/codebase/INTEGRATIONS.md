# External Integrations

**Analysis Date:** 2026-03-25

## APIs & External Services

**Commerce platform:**
- Shopify Storefront runtime - Core rendering, routing, cart, search, product recommendations, localization, customer accounts, and editor context.
  - SDK/Client: Native Shopify Liquid objects and browser globals exposed through `layout/theme.liquid`, `snippets/scripts.liquid`, and `assets/global.d.ts`
  - Auth: Managed by Shopify storefront session/cookies; no custom auth client is present

**Shopify storefront endpoints:**
- Cart endpoints - Used to add, update, and change cart contents in `assets/product-form.js`, `assets/cart-discount.js`, `assets/cart-note.js`, `assets/component-cart-items.js`, and `assets/quick-order-list.js`.
  - SDK/Client: `fetch` with route values from `Theme.routes` in `snippets/scripts.liquid`
  - Auth: Implicit Shopify storefront session
- Predictive search - Queried in `assets/predictive-search.js`.
  - SDK/Client: `fetch` against `Theme.routes.predictive_search_url`
  - Auth: Implicit Shopify storefront session
- Search results pages - Used in `assets/predictive-search.js` and `assets/search-page-input.js`.
  - SDK/Client: `URL` construction with `Theme.routes.search_url`
  - Auth: Public storefront route
- Product recommendations - Configured in `sections/product-recommendations.liquid` and fetched in `assets/product-recommendations.js`.
  - SDK/Client: `fetch` against `routes.product_recommendations_url`
  - Auth: Public storefront route
- Section rendering and product HTML refresh - Used for partial-page updates in `assets/section-renderer.js`, `assets/local-pickup.js`, `assets/quick-add.js`, `assets/variant-picker.js`, and `assets/facets.js`.
  - SDK/Client: `fetch` of storefront URLs with `section_id` and query parameters
  - Auth: Public storefront route

**Media providers:**
- Shopify model viewer feature loader - Used for 3D model UI in `assets/media.js`.
  - SDK/Client: `Shopify.loadFeatures([{ name: 'model-viewer-ui', version: '1.0' }])`
  - Auth: Managed by Shopify
- Embedded video providers - `assets/media.js` sends `postMessage` commands to iframes with `data-video-type` for YouTube/Vimeo-style playback control.
  - SDK/Client: iframe `postMessage`
  - Auth: Not handled in theme code

## Data Storage

**Databases:**
- Shopify platform data only
  - Connection: Not configured in this repository
  - Client: Liquid objects and storefront routes in files such as `sections/header.liquid`, `sections/product-recommendations.liquid`, and `snippets/cart-products.liquid`

**File Storage:**
- Shopify theme asset storage via `asset_url` references in `layout/theme.liquid`, `snippets/scripts.liquid`, and section/block templates

**Caching:**
- In-memory browser caching for product recommendations in `assets/product-recommendations.js`
- No Redis, Memcached, or separate cache service detected

## Authentication & Identity

**Auth Provider:**
- Shopify customer accounts
  - Implementation: Liquid conditionals and account menu rendering in `sections/header.liquid`, `snippets/header-actions.liquid`, `snippets/cart-products.liquid`, and `blocks/follow-on-shop.liquid`

## Monitoring & Observability

**Error Tracking:**
- None detected. No Sentry, Bugsnag, Datadog, Rollbar, or similar integration is imported.

**Logs:**
- Browser console logging only, for example `console.error` in `assets/product-recommendations.js`

## CI/CD & Deployment

**Hosting:**
- Shopify theme hosting/runtime

**CI Pipeline:**
- No workflow files are present under `.github/` in this checkout.
- `README.md` states Theme Check runs via `Shopify/theme-check-action`, but the corresponding workflow file is not present here.

## Environment Configuration

**Required env vars:**
- Not detected in repository files.
- No `.env` files are present at the project root.
- No `process.env`, `import.meta.env`, or dotenv usage was found in tracked source files.

**Secrets location:**
- Not applicable in this repository checkout. Store credentials are expected to be managed externally by Shopify CLI/store configuration rather than embedded in code.

## Webhooks & Callbacks

**Incoming:**
- None detected. No webhook endpoints or server handlers are present in this theme repository.

**Outgoing:**
- Storefront HTTP requests to Shopify-managed routes only:
  - Cart mutations from `assets/product-form.js`, `assets/cart-discount.js`, `assets/cart-note.js`, `assets/component-cart-items.js`, and `assets/quick-order-list.js`
  - Search and predictive search from `assets/predictive-search.js` and `assets/search-page-input.js`
  - Product recommendations from `assets/product-recommendations.js`
  - Section/product HTML refresh from `assets/section-renderer.js`, `assets/local-pickup.js`, `assets/quick-add.js`, and `assets/variant-picker.js`
- App block script re-execution support exists in `assets/morph.js`, and sections such as `sections/product-recommendations.liquid` declare `@app` blocks, but no specific third-party app integration is hard-coded in this checkout.

---

*Integration audit: 2026-03-25*
