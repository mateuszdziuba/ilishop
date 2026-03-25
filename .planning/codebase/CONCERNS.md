# Codebase Concerns

**Analysis Date:** 2026-03-25

## Tech Debt

**Monolithic storefront runtime:**
- Issue: Core storefront behavior is spread across many large browser modules with no visible test harness or build-time isolation. The largest files include `assets/qr-code-generator.js`, `assets/slideshow.js`, `assets/facets.js`, `assets/utilities.js`, and `assets/product-form.js`, while `snippets/scripts.liquid` injects a long list of module scripts on every page.
- Files: `assets/qr-code-generator.js`, `assets/slideshow.js`, `assets/facets.js`, `assets/utilities.js`, `assets/product-form.js`, `snippets/scripts.liquid`
- Impact: Small changes have a wide blast radius, page behavior is hard to reason about end-to-end, and storefront performance tuning becomes manual instead of systematic.
- Fix approach: Split vendor code from first-party code, reduce globally loaded modules in `snippets/scripts.liquid`, and introduce smoke tests for cart, search, collection filtering, and product pages before refactoring.

**Duplicated header layout logic:**
- Issue: Header height and transparent-header offset logic is duplicated inline in `layout/theme.liquid` and in runtime helpers in `assets/utilities.js`, with an explicit note that both copies must stay in sync.
- Files: `layout/theme.liquid`, `assets/utilities.js`
- Impact: Header regressions are likely when one copy changes without the other. This is especially risky for CLS-sensitive behavior and transparent header offsets.
- Fix approach: Keep one source of truth. Either compute everything from a single module or reduce the inline bootstrap to only the minimal data needed before JS hydration.

**Error handling is inconsistent and often silent:**
- Issue: Network-heavy modules mix `.then()` chains, `async/await`, empty `catch` blocks, and bare `console.error` logging. `assets/cart-discount.js` swallows failures, while cart and section rendering code frequently assumes successful JSON or HTML responses.
- Files: `assets/cart-discount.js`, `assets/component-cart-items.js`, `assets/product-form.js`, `assets/section-renderer.js`, `assets/predictive-search.js`
- Impact: Production failures degrade into stale UI, missing updates, or invisible no-ops rather than actionable user feedback or recoverable retries.
- Fix approach: Centralize fetch helpers around `response.ok` checks, typed parse guards, abort-aware retries, and user-visible fallback states.

## Known Bugs

**Section cache initialization exits early and skips later sections:**
- Symptoms: Initial section HTML caching stops as soon as one section is already cached or contains a shadow root, so later sections are never cached during page load.
- Files: `assets/section-renderer.js`
- Trigger: `SectionRenderer.#cachePageSections()` uses `return` instead of `continue` inside the `for ... of` loop at lines corresponding to the guards before `this.#cache.set(...)`.
- Workaround: None in code. Subsequent section updates fall back to network fetches.

**Failed section fetches can poison future renders until reload:**
- Symptoms: Once a section request rejects, the rejected promise remains in `#pendingPromises`, and future calls for the same URL can keep returning the same rejected promise.
- Files: `assets/section-renderer.js`
- Trigger: `getSectionHTML()` stores the fetch promise in `#pendingPromises`, but deletion happens only after `await pendingPromise` succeeds. Rejections skip cleanup.
- Workaround: Full page reload.

**Keyboard removal of discount pills is blocked by the event guard:**
- Symptoms: Pressing Enter on a discount pill does not remove the discount, even though the handler claims to support `MouseEvent | KeyboardEvent`.
- Files: `assets/cart-discount.js`
- Trigger: In `removeDiscount()`, the guard rejects all non-mouse events via `!(event instanceof MouseEvent)`, which still evaluates to `true` for Enter key presses.
- Workaround: Use pointer interaction instead of keyboard activation.

**Predictive search can throw on browsers without native `requestIdleCallback`:**
- Symptoms: Opening predictive search with recently viewed products available can fail with a `ReferenceError` before empty-state content loads.
- Files: `assets/predictive-search.js`, `assets/utilities.js`
- Trigger: `assets/predictive-search.js` calls the global `requestIdleCallback(...)` directly, while the fallback wrapper lives in `assets/utilities.js` and is not imported here.
- Workaround: None in this module. Behavior depends on browser support.

## Security Considerations

**Trusted HTML boundary is wide and unsanitized:**
- Risk: Multiple features parse and inject HTML returned from same-origin endpoints directly into the DOM via `innerHTML`, `DOMParser`, and morphing helpers. If a compromised app block, unsafe Liquid output, or unexpected HTML response reaches these endpoints, the client accepts it as trusted markup.
- Files: `assets/product-recommendations.js`, `assets/predictive-search.js`, `assets/component-cart-items.js`, `assets/cart-discount.js`, `assets/section-renderer.js`
- Current mitigation: Responses are expected to come from Shopify storefront routes and section rendering endpoints rather than arbitrary third-party origins.
- Recommendations: Treat section/cart/search HTML as an explicit trust boundary, limit injected surfaces where possible, and validate any merchant-controlled HTML sources that can flow into these responses.

**Client storage reads are not uniformly guarded:**
- Risk: Corrupted or blocked `localStorage` / `sessionStorage` values can throw during parse or set operations and break unrelated UI flows such as predictive search, editor state restore, or recently viewed products.
- Files: `assets/recently-viewed-products.js`, `assets/theme-editor.js`, `assets/cart-icon.js`
- Current mitigation: `assets/cart-icon.js` wraps one `JSON.parse` in a `try/catch`.
- Recommendations: Add defensive storage wrappers with `try/catch`, schema validation, and safe defaults before using stored values.

## Performance Bottlenecks

**Large JavaScript payload is broadly loaded:**
- Problem: `snippets/scripts.liquid` preloads and injects a long list of modules globally, including large files such as `assets/product-form.js`, `assets/slideshow.js`, `assets/layered-slideshow.js`, `assets/localization.js`, and `assets/overflow-list.js`.
- Files: `snippets/scripts.liquid`, `assets/product-form.js`, `assets/slideshow.js`, `assets/layered-slideshow.js`, `assets/localization.js`, `assets/overflow-list.js`
- Cause: Script loading is mostly page-global with only limited template gating, so non-critical features still contribute parse/compile cost.
- Improvement path: Audit which modules are needed per template, defer non-critical features behind interaction or visibility, and avoid loading product-only behavior on non-product pages.

**Section rendering performance is undermined by cache defects:**
- Problem: Section updates can refetch more often than intended and cannot recover cleanly from failures.
- Files: `assets/section-renderer.js`, `assets/facets.js`, `assets/predictive-search.js`, `assets/component-cart-items.js`
- Cause: Early loop termination in `#cachePageSections()` reduces cache population, while rejected pending promises remain stuck in memory.
- Improvement path: Fix cache loop control, clear pending entries on both success and failure, and add instrumentation around section fetch hit rate.

**Vendored QR code generator is oversized for a niche feature:**
- Problem: `assets/qr-code-generator.js` is one of the largest assets in the repo and appears to be a vendored library embedded directly in the theme.
- Files: `assets/qr-code-generator.js`
- Cause: Full library source is committed as first-party storefront code rather than isolated or lazy-loaded.
- Improvement path: Load it only on gift-card paths, keep the vendored source isolated from application code, or replace it with a smaller maintained dependency if Shopify theme constraints allow.

## Fragile Areas

**Search and recently viewed behavior depends on brittle storage state:**
- Files: `assets/predictive-search.js`, `assets/recently-viewed-products.js`
- Why fragile: Predictive search startup calls into recently viewed storage immediately. `RecentlyViewed.getProducts()` uses raw `JSON.parse(localStorage.getItem(...) || '[]')` with no guard, so malformed storage can break search UI initialization.
- Safe modification: Any changes to predictive search should include corrupted-storage scenarios and browsers where storage access is restricted.
- Test coverage: No automated tests detected for predictive search, recently viewed storage, or storage-failure fallback behavior.

**Cart flows depend on optimistic DOM replacement without robust recovery:**
- Files: `assets/product-form.js`, `assets/component-cart-items.js`, `assets/cart-discount.js`, `sections/main-cart.liquid`
- Why fragile: Add-to-cart, quantity changes, and discount changes all rely on parsing returned HTML/JSON and morphing live DOM. Several branches assume response shape correctness and use minimal recovery when parsing or fetches fail.
- Safe modification: Change one cart surface at a time and verify product page add, cart drawer add, quantity change, remove line, discount apply, and discount remove as a single regression set.
- Test coverage: No automated tests detected for cart drawer, cart page, or discount behavior.

**Header rendering is sensitive to synchronization drift:**
- Files: `layout/theme.liquid`, `assets/utilities.js`, `assets/theme-editor.js`, `sections/header.liquid`
- Why fragile: Header sizing and transparency behavior are computed inline before render and recomputed later in JS and theme editor hooks. The code already documents the need to keep multiple implementations synchronized.
- Safe modification: Treat header measurements, transparent offsets, and menu-style selection as one unit and verify desktop, mobile, sticky, transparent, and theme-editor states together.
- Test coverage: No automated tests detected for header sizing or transparent header behavior.

## Scaling Limits

**Storefront interactivity scales linearly with theme surface area:**
- Current capacity: The codebase ships roughly 20k lines of JavaScript under `assets/`, with several individual files above 500 lines and many custom elements active across templates.
- Limit: As more features are added, parse/compile time, event listener count, and DOM observer usage increase without any bundling or test harness to keep regressions contained.
- Scaling path: Reduce always-on modules, isolate feature bundles by template, and add browser-level smoke tests for the highest-traffic flows before expanding theme behavior further.

## Dependencies at Risk

**Vendored third-party browser libraries:**
- Risk: `assets/qr-code-generator.js` and `assets/popover-polyfill.js` are large, effectively external dependencies embedded directly in the theme, which makes patching and provenance tracking harder.
- Impact: Security fixes, compatibility updates, and bug triage require manual audits inside committed source rather than normal package management workflows.
- Migration plan: Document vendored versions, isolate them clearly, and prefer smaller or upstream-maintained replacements where theme constraints permit.

## Missing Critical Features

**Automated regression coverage for critical commerce flows:**
- Problem: No test files or test runner configuration were detected, despite complex runtime behavior across cart, search, filtering, recommendations, and header state.
- Blocks: Safe refactoring of `assets/product-form.js`, `assets/component-cart-items.js`, `assets/predictive-search.js`, `assets/facets.js`, and `assets/section-renderer.js`.

## Test Coverage Gaps

**Section rendering and caching:**
- What's not tested: Cache initialization, pending-request cleanup, fetch failure recovery, and DOM morph behavior for section updates.
- Files: `assets/section-renderer.js`, `assets/facets.js`, `assets/predictive-search.js`
- Risk: Regressions in filtering, predictive search, and any section-based refresh can ship unnoticed.
- Priority: High

**Cart interaction flows:**
- What's not tested: Add-to-cart success/error branches, quantity updates, optimistic row removal, cart drawer synchronization, and discount apply/remove behavior.
- Files: `assets/product-form.js`, `assets/component-cart-items.js`, `assets/cart-discount.js`
- Risk: Revenue-impacting regressions can reach production without detection.
- Priority: High

**Storage-backed UX behavior:**
- What's not tested: Recently viewed product persistence, cart badge session sync, theme editor state restore, and corrupted storage handling.
- Files: `assets/recently-viewed-products.js`, `assets/cart-icon.js`, `assets/theme-editor.js`, `assets/predictive-search.js`
- Risk: Hard-to-reproduce browser-specific failures remain invisible until merchants or shoppers report them.
- Priority: Medium

---

*Concerns audit: 2026-03-25*
