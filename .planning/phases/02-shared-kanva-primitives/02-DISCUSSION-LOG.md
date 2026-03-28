# Phase 2: Shared Kanva Primitives - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-03-28
**Phase:** 02-shared-kanva-primitives
**Areas discussed:** Kanva styling integration, Section inventory and granularity, Horizon adaptation vs new creation, Shared snippet and heading system
**Mode:** Auto (--auto flag)

---

## Kanva Styling Integration

| Option | Description | Selected |
|--------|-------------|----------|
| Extend Horizon theme settings/CSS variables | Add Kanva tokens as new CSS custom properties alongside existing Horizon tokens | ✓ |
| Create parallel Kanva CSS layer | Separate stylesheet with independent design tokens | |
| Override Horizon tokens globally | Replace Horizon defaults with Kanva values | |

**User's choice:** [auto] Extend Horizon theme settings/CSS variables (recommended default)
**Notes:** Avoids parallel design system. Horizon already has `config/settings_schema.json` color schemes and `snippets/theme-styles-variables.liquid` as extension points.

---

## Section Inventory and Granularity

| Option | Description | Selected |
|--------|-------------|----------|
| One standalone section per editorial pattern | Feature strip, testimonial, newsletter, social grid each get own section file | ✓ |
| Blocks inside generic section wrapper | Use existing `sections/section.liquid` with configurable blocks | |
| Hybrid — some standalone, some blocks | Split based on editor reuse needs | |

**User's choice:** [auto] One standalone section per editorial pattern (recommended default)
**Notes:** Shopify sections are the editor's primary reordering/reuse unit. Blocks alone can't be reordered across page positions. Patterns with Horizon equivalents (split media/text, product grid) adapt existing sections instead.

---

## Horizon Adaptation vs New Creation

| Option | Description | Selected |
|--------|-------------|----------|
| Adapt existing where layout matches, new where no equivalent | Use `media-with-content.liquid` for split rows; new for feature strip, testimonial, newsletter, social grid | ✓ |
| All new Kanva sections | Create fresh section files for every Kanva pattern | |
| Fork and modify Horizon sections | Copy existing sections and customize | |

**User's choice:** [auto] Adapt existing where layout matches, create new where no equivalent (recommended default)
**Notes:** `media-with-content.liquid` (432 lines) already handles split media/text layout. Feature strip, testimonial, newsletter, social grid have no Horizon equivalent. Forking is explicitly against project constraints (D-15 from Phase 1).

---

## Shared Snippet and Heading System

| Option | Description | Selected |
|--------|-------------|----------|
| Kanva-prefixed snippets consuming Horizon helpers | New `kanva-heading.liquid`, `kanva-badge.liquid`, `kanva-card.liquid` that use existing `spacing-style.liquid`, `typography-style.liquid` | ✓ |
| Extend existing Horizon snippets directly | Add Kanva variants inside existing snippet files | |
| Section-scoped inline styles | Each section handles its own heading/badge/card treatment | |

**User's choice:** [auto] Kanva-prefixed snippets consuming Horizon helpers (recommended default)
**Notes:** Keeps Horizon base intact, provides DRY shared treatments, `kanva-` prefix makes ownership clear.

---

## Claude's Discretion

- Exact internal Liquid implementation of each new snippet
- Whether Kanva CSS properties go in a new snippet or extend existing `theme-styles-variables.liquid`
- Block composition inside adapted sections
- Social/image grid internal structure

## Deferred Ideas

- Homepage assembly → Phase 3
- Collection framing → Phase 4
- About page composition → Phase 5
- Blog curation → Phase 6
- Live Instagram API → v2 (out of scope)
