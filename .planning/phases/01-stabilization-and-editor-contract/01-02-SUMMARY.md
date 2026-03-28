---
phase: 01-stabilization-and-editor-contract
plan: 02
subsystem: testing
tags: [shopify-theme-check, smoke-testing, regression-gate, theme-liquid, liquid]

# Dependency graph
requires: []
provides:
  - Executable Theme Check gate (scripts/phase1-regression-gate.sh) that fails on new errors above a documented baseline
  - Manual protected-surface smoke checklist (21 checks) covering header, section wrapper, collection runtime, blog runtime, and theme editor operations
  - Regression baseline documenting all 6 protected files, 2 known pre-existing Horizon errors, and responsive editor contract rules
affects:
  - 01-stabilization-and-editor-contract
  - All future Kanva phase plans that touch protected runtime files

# Tech tracking
tech-stack:
  added: []
  patterns:
    - Phase gate: shopify theme check --fail-level error with documented baseline error count
    - Smoke checklist: selector-anchored manual checks per runtime surface

key-files:
  created:
    - .planning/phases/01-stabilization-and-editor-contract/01-protected-runtime-checklist.md
    - .planning/phases/01-stabilization-and-editor-contract/01-regression-baseline.md
    - scripts/phase1-regression-gate.sh
  modified: []

key-decisions:
  - "Regression gate uses shopify theme check --fail-level error rather than a full browser test framework — meets Phase 1 D-11 (lightest viable harness)"
  - "Gate accounts for 2 pre-existing Horizon UniqueStaticBlockId errors in sections/header.liquid — gate exits 0 when only baseline errors are present"
  - "Smoke checklist uses 21 selector-anchored manual checks across 5 surfaces (H, SW, CR, BR, TE) to make regressions detectable without a browser runner"

patterns-established:
  - "Gate pattern: wrap shopify theme check with baseline-aware exit logic so pre-existing upstream errors do not block Phase 1 contributors"
  - "Smoke pattern: per-surface check table with Page, Action, Selector, Expected, File-risk columns for consistent regression coverage"

requirements-completed: [QUAL-01]

# Metrics
duration: 7min
completed: 2026-03-28
---

# Phase 01 Plan 02: Regression Gate and Protected Surface Checklist Summary

**Phase 1 has a 21-check smoke checklist and an executable `shopify theme check` gate that protects header, section wrapper, collection, and blog runtime surfaces before Kanva page work begins**

## Performance

- **Duration:** 7 min
- **Started:** 2026-03-28T11:59:26Z
- **Completed:** 2026-03-28T12:06:26Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments

- Protected-surface smoke checklist with 21 selector-anchored checks across Header (H-01–H-04), Section wrapper (SW-01–SW-03), Collection runtime (CR-01–CR-05), Blog runtime (BR-01–BR-04), and Theme editor (TE-01–TE-05)
- Executable regression gate (`scripts/phase1-regression-gate.sh`) that runs `shopify theme check --fail-level error`, accounts for the 2 known pre-existing Horizon baseline errors, and directs contributors to the smoke checklist on success
- Baseline note inventorying all 6 protected files, their fragility characteristics, the 2 pre-existing Theme Check errors, and the 5 responsive editor contract rules locked in Phase 1

## Task Commits

Each task was committed atomically:

1. **Task 1: Write the protected runtime and editor smoke checklist** - `59cb5cd` (feat)
2. **Task 2: Add the executable Theme Check gate and baseline note** - `44083b1` (feat)

**Plan metadata:** TBD (docs: complete plan)

## Files Created/Modified

- `.planning/phases/01-stabilization-and-editor-contract/01-protected-runtime-checklist.md` — 21-check manual smoke source of truth covering all 4 protected runtime surfaces plus minimal theme editor checks; each check has Page, Action, Selector, Expected, and File-risk fields
- `.planning/phases/01-stabilization-and-editor-contract/01-regression-baseline.md` — Protected file inventory, baseline Theme Check state (2 pre-existing errors documented), and responsive editor contract baseline rules
- `scripts/phase1-regression-gate.sh` — Executable gate: runs `shopify theme check --fail-level error`, recognizes 2 known pre-existing errors as non-blocking, fails on any new errors, and prints smoke checklist path on exit 0

## Decisions Made

- Used `shopify theme check --fail-level error` as the automated signal because it is already available locally (Shopify CLI 3.91.0) and aligns with D-11 (lightest viable harness). No new test framework was added.
- Gate script is baseline-aware: the 2 pre-existing `UniqueStaticBlockId` errors in `sections/header.liquid` are an intentional Horizon pattern (same `id` with different `variant:` parameters) and must not block Phase 1 contributors.
- Smoke checklist uses explicit selectors (`results-list`, `blog-posts-list`, `data-testid="blog-posts"`, `--transparent-header-offset-boolean`, `--header-group-height`) from the actual Horizon code so checks remain anchored to real implementation contracts.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Gate script updated to account for pre-existing Horizon baseline errors**
- **Found during:** Task 2 verification (running `sh scripts/phase1-regression-gate.sh`)
- **Issue:** Initial gate script exited 1 due to 2 pre-existing `UniqueStaticBlockId` errors in `sections/header.liquid` (upstream Horizon pattern, not introduced by Phase 1). This would incorrectly block all Phase 1 contributors despite no new errors.
- **Fix:** Added baseline error count (`KNOWN_BASELINE_ERROR_COUNT=2`) to the gate script. Gate now exits 0 when reported errors are at or below the baseline count, and exits 1 only when new errors exceed the baseline. Updated baseline note to document the known errors explicitly.
- **Files modified:** `scripts/phase1-regression-gate.sh`, `01-regression-baseline.md`
- **Verification:** `sh scripts/phase1-regression-gate.sh` exits 0 with the 2 pre-existing errors present
- **Committed in:** `44083b1` (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (1 bug — pre-existing error handling)
**Impact on plan:** Fix was necessary for the gate to be usable at all. No scope creep.

## Issues Encountered

- `scripts/phase1-regression-gate.sh` was initially created in the git worktree directory (`/Users/mati/Mine/horizon/.claude/worktrees/agent-ae56359e/scripts/`) instead of the main repo. Copied to `/Users/mati/Mine/horizon/scripts/` and committed to `main` as intended.

## User Setup Required

None — no external service configuration required. The gate uses `shopify theme check` which is bundled with Shopify CLI 3.91.0 already in the environment.

## Next Phase Readiness

- Phase 1 now has a repeatable regression command contributors can run before merge: `sh scripts/phase1-regression-gate.sh`
- The protected-surface smoke checklist is the manual follow-up after the gate passes
- Phase 2 (Shared Kanva Primitives) can proceed knowing that header, collection, and blog runtime regressions will be caught early
- Open from Phase 1 blockers list: responsive media fallback rules and editor contract are established in plan 01; this plan (02) adds the verification harness that enforces those rules

---
*Phase: 01-stabilization-and-editor-contract*
*Completed: 2026-03-28*

## Self-Check: PASSED

- FOUND: `.planning/phases/01-stabilization-and-editor-contract/01-protected-runtime-checklist.md`
- FOUND: `.planning/phases/01-stabilization-and-editor-contract/01-regression-baseline.md`
- FOUND: `scripts/phase1-regression-gate.sh`
- FOUND: `.planning/phases/01-stabilization-and-editor-contract/01-02-SUMMARY.md`
- FOUND: commit `59cb5cd` (Task 1)
- FOUND: commit `44083b1` (Task 2)
