# Coding Conventions

**Analysis Date:** 2026-03-25

## Naming Patterns

**Files:**
- Use kebab-case asset filenames for JavaScript modules under `assets/`, such as `assets/product-form.js`, `assets/component-cart-items.js`, and `assets/section-renderer.js`.
- Use `.liquid` filenames that mirror section, block, or snippet responsibility, such as `sections/main-cart.liquid`, `blocks/product-card.liquid`, and `snippets/quantity-selector.liquid`.

**Functions:**
- Use camelCase for functions and methods, including helpers like `buildSectionSelector()` in `assets/section-renderer.js`, `normalizeString()` in `assets/utilities.js`, and methods like `updateFilters()` in `assets/facets.js`.
- Prefix internal/private methods with `#` when they are class-private, such as `#updateRefs()` in `assets/component.js`, `#handleCartError()` in `assets/component-cart-items.js`, and `#onVariantUpdate()` in `assets/product-form.js`.
- Prefix event handlers with `handle` or `on` for public handlers and `#on` for private handlers, such as `handleClick()` in `assets/product-form.js`, `handleDiscountUpdate()` in `assets/component-cart-items.js`, and `#onKeyDown()` in `assets/facets.js`.

**Variables:**
- Use camelCase for locals, constants, and properties, including descriptive names like `sectionHTML` in `assets/section-renderer.js`, `cartItemRowToRemove` in `assets/component-cart-items.js`, and `ERROR_MESSAGE_DISPLAY_DURATION` in `assets/product-form.js`.
- Use UPPER_SNAKE_CASE for module-level constants, such as `SECTION_ID_PREFIX` in `assets/section-renderer.js`, `SEARCH_QUERY` in `assets/facets.js`, and timing constants in `assets/product-form.js`.

**Types:**
- Define structural types with JSDoc `@typedef` blocks in the same file that consumes them, such as `Refs` in `assets/component.js`, `FetchConfig` in `assets/utilities.js`, `ProductFormRefs` in `assets/product-form.js`, and `SlideshowSelectEventData` in `assets/events.js`.
- Extend global browser and Shopify types in `assets/global.d.ts` instead of introducing TypeScript source files.

## Code Style

**Formatting:**
- Use standard ES module JavaScript with no repository-level formatter config detected. No `.prettierrc*`, `eslint.config.*`, or `.eslintrc*` files are present in the project root.
- Omit semicolons in regular module code, matching `assets/component.js`, `assets/utilities.js`, and `assets/facets.js`.
- Favor multi-line object literals and guard clauses for readability, as seen in `assets/component-cart-items.js` and `assets/product-form.js`.
- Use class fields for instance state, including private fields like `#cache` in `assets/section-renderer.js` and `#abortController` in `assets/product-form.js`.

**Linting:**
- No lint config is detected in the repository root.
- Inline lint suppressions are used sparingly and locally where needed, such as `// eslint-disable-next-line no-async-promise-executor` in `assets/utilities.js`, `// eslint-disable-next-line no-self-assign` in `assets/localization.js`, and `/* eslint-disable no-redeclare */` in `assets/qr-code-generator.js`.
- `assets/jsconfig.json` acts as the main static quality gate by enabling `checkJs`, `noImplicitAny`, `noUncheckedIndexedAccess`, and `strictNullChecks`.

## Import Organization

**Order:**
1. Import aliased internal modules from `@theme/*`, as in `assets/product-form.js` and `assets/component-cart-items.js`.
2. Import sibling type references only when needed through JSDoc import typedefs, such as `/** @typedef {import('./utilities').TextComponent} TextComponent */` in `assets/component-cart-items.js`.
3. Define local constants, typedefs, classes, helpers, and bottom-of-file custom element registration in the same module.

**Path Aliases:**
- Use the `@theme/*` alias configured in `assets/jsconfig.json` with `baseUrl: "./"` and `"@theme/*": ["./*"]`.
- Prefer aliased imports over relative traversal, such as `import { Component } from '@theme/component'` in `assets/product-form.js` and `import { morph } from '@theme/morph'` in `assets/section-renderer.js`.

## Error Handling

**Patterns:**
- Fail fast on missing required DOM structure with explicit runtime errors, such as `throw new Error('Section ID is required')` in `assets/facets.js`, `throw new Error('Product form element missing')` in `assets/product-form.js`, and `throw new Error('Missing shadow root')` in `assets/overflow-list.js`.
- Use guard clauses for non-error early exits when user input or DOM state is optional, such as `if (!form?.checkValidity()) return` in `assets/product-form.js` and `if (!(event.target instanceof Node) || !this.contains(event.target)) return` in `assets/component-cart-items.js`.
- Wrap asynchronous network work in `try/catch` or promise `.catch()` and log failures with `console.error`, as seen in `assets/cart-discount.js`, `assets/cart-note.js`, `assets/quick-add.js`, `assets/product-recommendations.js`, and `assets/component-cart-items.js`.
- Use `AbortController` to cancel stale async work when components disconnect or rerender, such as `#abortController` in `assets/product-form.js` and `#abortControllersBySectionId` in `assets/section-renderer.js`.

## Logging

**Framework:** `console`

**Patterns:**
- Use `console.error` for fetch/render failures that should surface during debugging, such as in `assets/product-form.js`, `assets/component-cart-items.js`, and `assets/product-recommendations.js`.
- Use `console.warn` for non-fatal unsupported states, such as `console.warn(\`Unknown delivery mode: \${mode}\`)` in `assets/gift-card-recipient-form.js` and `console.warn('Fetch aborted by user')` in `assets/variant-picker.js`.
- Keep logging minimal; most branches prefer silent guard returns or thrown errors over verbose instrumentation.

## Comments

**When to Comment:**
- Use JSDoc comments extensively for classes, methods, params, returns, and typedefs. This is the dominant documentation style in `assets/component.js`, `assets/events.js`, `assets/utilities.js`, and `assets/product-form.js`.
- Add short intent comments only where behavior is non-obvious, such as animation timing notes in `assets/product-form.js` and feature-detection comments in `assets/utilities.js`.
- Avoid narrative inline comments for straightforward DOM or state updates.

**JSDoc/TSDoc:**
- Use JSDoc instead of TypeScript source types. `assets/jsconfig.json` enables type-checking over JSDoc-annotated JavaScript.
- Annotate custom element refs and event payloads with `@typedef`, `@property`, `@param`, `@returns`, `@template`, and `@extends`, as shown in `assets/component.js`, `assets/events.js`, and `assets/facets.js`.
- Use `@ts-ignore` only for known platform typing gaps, such as scheduler support in `assets/utilities.js` and theme editor APIs in `assets/theme-editor.js`.

## Function Design

**Size:** Keep small helpers as standalone functions and put longer workflows inside component classes. Examples include compact helpers like `normalizeSectionId()` in `assets/section-renderer.js` versus multi-step interaction methods like `updateQuantity()` in `assets/component-cart-items.js`.

**Parameters:** Pass structured objects when a method has multiple related inputs, such as `updateQuantity({ line, quantity, action })` in `assets/component-cart-items.js` and `renderSection(sectionId, options)` in `assets/section-renderer.js`.

**Return Values:** Return early for no-op conditions, return primitives from helpers, and return promises for async DOM/network work. Examples include `createURLParameters()` in `assets/facets.js`, `fetchConfig()` in `assets/utilities.js`, and `renderSection()` in `assets/section-renderer.js`.

## Module Design

**Exports:**
- Prefer named exports for reusable primitives and framework-like modules, such as `Component` in `assets/component.js`, `ThemeEvents` in `assets/events.js`, and `sectionRenderer` in `assets/section-renderer.js`.
- Use default exports for base classes reused by a small number of modules, such as `PaginatedList` in `assets/paginated-list.js`, `VariantPicker` in `assets/variant-picker.js`, `BlogPostsList` in `assets/blog-posts-list.js`, and `ResultsList` in `assets/results-list.js`.
- Keep many custom-element implementation classes file-local when they are only registered in the same file, such as `CartItemsComponent` in `assets/component-cart-items.js` and `FacetsFormComponent` in `assets/facets.js`.

**Barrel Files:** No barrel files are used. Import modules directly from their concrete asset path alias, such as `@theme/component`, `@theme/events`, and `@theme/utilities`.

## Runtime Patterns

**Custom Elements:**
- Build interactive features as Web Components extending `Component` or `HTMLElement`, then register them at the bottom of the file behind a `customElements.get()` guard, as in `assets/product-form.js`, `assets/dialog.js`, and `assets/facets.js`.
- Use `requiredRefs` plus `ref` attributes for DOM wiring instead of repeated `querySelector()` lookups, following `assets/component.js` and consumers like `assets/product-form.js`.

**DOM and Event Flow:**
- Coordinate modules with custom events defined in `assets/events.js` rather than direct cross-component calls.
- Prefer event delegation and document-level listeners for shared cart and variant state, as shown in `assets/component.js`, `assets/component-cart-items.js`, and `assets/product-form.js`.

---

*Convention analysis: 2026-03-25*
