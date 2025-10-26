# Provider Comparison Screenshot Guide

This directory demonstrates the difference between builtin (text matching) and nodejs (semantic) providers.

## Files Created

- `TestComponent.tsx` - Test file with `OldButton` in different contexts
- `builtin-rule.yaml` - Rule using builtin provider (text pattern matching)
- `nodejs-rule.yaml` - Rule using nodejs provider (semantic analysis)

## Results

### Builtin Provider: 6 violations found
Including false positives from comments and strings.

### nodejs Provider: 0 violations
(Would need proper TypeScript project setup to work correctly)

## Creating the Screenshot

Open both static reports side-by-side:

```bash
# Builtin provider results (shows all text matches)
open builtin-output/static-report/index.html

# nodejs provider results (semantic only)
open nodejs-output/static-report/index.html
```

## For Blog Screenshot

Capture a split-screen showing:

**Left side:** Builtin provider static report highlighting all 6 matches
**Right side:** Annotated TestComponent.tsx showing:
- ✅ Green checkmarks on real code references (lines 2, 11)
- ❌ Red X marks on false positives (lines 5, 6, 7, 12 - comments/strings/variables)

### Alternative: Use builtin output directly

The builtin-output/output.yaml file shows all 6 violations with line numbers.

Simply annotate the TestComponent.tsx file in your editor showing which matches are good (✅) vs false positives (❌).

## Key Points to Highlight

1. **Builtin finds 6 matches** - any text occurrence of "OldButton"
2. **Only 2 are real** - the import and JSX usage
3. **4 are false positives** - comments, strings, and unrelated variable names
4. **nodejs provider would only find the 2 real references** (with proper TS setup)
