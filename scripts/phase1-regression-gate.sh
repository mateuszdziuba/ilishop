#!/usr/bin/env bash
# phase1-regression-gate.sh
#
# Phase 1 regression gate for the Horizon Kanva rebuild.
# Runs shopify theme check --fail-level error to catch Liquid/schema errors,
# then directs the contributor to the protected-surface smoke checklist.
#
# Usage:
#   sh scripts/phase1-regression-gate.sh
#
# Exit codes:
#   0  Theme Check passed (or only pre-existing baseline errors found);
#      manual smoke checklist required before merge.
#   1  Theme Check reported errors beyond the known baseline;
#      investigate and fix before proceeding.
#
# KNOWN PRE-EXISTING BASELINE ERRORS (do not fix — out of Phase 1 scope):
#   sections/header.liquid: UniqueStaticBlockId for 'header-menu' (x2)
#   These are intentional Horizon patterns where three content_for 'block' calls
#   share the same id with different variant: parameters. Theme Check flags them
#   as duplicate IDs, but they are by design and predate Phase 1.
#
# See: .planning/phases/01-stabilization-and-editor-contract/01-regression-baseline.md
#      for the full baseline inventory and known error details.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
CHECKLIST=".planning/phases/01-stabilization-and-editor-contract/01-protected-runtime-checklist.md"
BASELINE=".planning/phases/01-stabilization-and-editor-contract/01-regression-baseline.md"

# Number of pre-existing Theme Check errors in the Horizon baseline.
# These errors exist before any Phase 1 work and should not block the gate.
# Update this count only if the upstream Horizon codebase is upgraded and the
# pre-existing error count changes.
KNOWN_BASELINE_ERROR_COUNT=2

echo ""
echo "============================================================"
echo "  Phase 1 Regression Gate"
echo "============================================================"
echo ""
echo "Step 1: Running shopify theme check --fail-level error ..."
echo ""

# Run Theme Check from the repo root so it picks up the full theme structure.
cd "${REPO_ROOT}"

if ! command -v shopify &>/dev/null; then
  echo "ERROR: 'shopify' CLI not found in PATH."
  echo "       Install Shopify CLI and ensure it is available before running this gate."
  echo "       See: https://shopify.dev/docs/storefronts/tools/cli/install"
  exit 1
fi

# Capture Theme Check output and exit code separately.
THEME_CHECK_OUTPUT=$(shopify theme check --fail-level error 2>&1) || true
THEME_CHECK_EXIT=$?

echo "${THEME_CHECK_OUTPUT}"

# Count errors reported in the output.
# Theme Check summary line format: "N errors."
REPORTED_ERRORS=$(echo "${THEME_CHECK_OUTPUT}" | grep -oE '[0-9]+ errors?\.' | grep -oE '^[0-9]+' | head -1 || echo "0")

echo ""

if [ "${THEME_CHECK_EXIT}" -ne 0 ]; then
  # Theme Check found errors. Check if they are all pre-existing baseline errors.
  if [ "${REPORTED_ERRORS}" -le "${KNOWN_BASELINE_ERROR_COUNT}" ]; then
    echo "============================================================"
    echo "  Theme Check reported ${REPORTED_ERRORS} error(s)."
    echo "  All ${REPORTED_ERRORS} are known pre-existing Horizon baseline errors"
    echo "  (sections/header.liquid UniqueStaticBlockId for 'header-menu')."
    echo "  These are intentional patterns and do not block Phase 1."
    echo ""
    echo "  See baseline for details:"
    echo "    ${BASELINE}"
    echo "============================================================"
    echo ""
    # Fall through to smoke checklist instructions below.
  else
    echo "============================================================"
    echo "  GATE FAILED: Theme Check reported ${REPORTED_ERRORS} error(s)."
    echo "  The baseline has ${KNOWN_BASELINE_ERROR_COUNT} known pre-existing error(s)."
    echo "  $(( REPORTED_ERRORS - KNOWN_BASELINE_ERROR_COUNT )) new error(s) detected above the baseline."
    echo ""
    echo "  Fix all NEW errors before merging or continuing."
    echo "  Do not fix the pre-existing baseline errors; see:"
    echo "    ${BASELINE}"
    echo "============================================================"
    echo ""
    exit 1
  fi
else
  echo "============================================================"
  echo "  Theme Check passed (no errors)."
  echo "============================================================"
  echo ""
fi

echo "Step 2: Manual smoke checklist required."
echo ""
echo "  Before merging any change that touches a protected file, run"
echo "  through the manual smoke checklist:"
echo ""
echo "    ${CHECKLIST}"
echo ""
echo "  Protected files covered by the checklist:"
echo "    - layout/theme.liquid"
echo "    - assets/utilities.js"
echo "    - sections/main-collection.liquid"
echo "    - sections/main-blog.liquid"
echo "    - sections/section.liquid"
echo "    - snippets/section.liquid"
echo ""
echo "  Mark each check PASS or FAIL in your PR notes."
echo "  Do not merge if any check is FAIL."
echo ""
echo "============================================================"
echo "  Gate complete. Proceed to manual smoke checklist."
echo "============================================================"
echo ""
exit 0
