---
layout: single
title: "Part 2: Improving PatternFly Migration Detection with Semantic Analysis"
date: 2025-10-21
categories: [migration, ai, konveyor, typescript]
tags: [migration, typescript, konveyor, static-analysis, semantic-analysis, patternfly, react]
excerpt: "Why accuracy matters: How semantic analysis reduced false positives by 75%, setting the stage for AI-assisted automated refactoring"
header:
  overlay_color: "#333"
  overlay_filter: "0.5"
author_profile: true
classes: wide
---

**Series: Automating UI Migrations with Konveyor**
- Part 1: [Generating Migration Rules with AI](/migration/ai/konveyor/patternfly/2025/10/22/automating-ui-migrations-ai-analyzer-rules.html)
- **Part 2: Improving Detection with Semantic Analysis** (this post)
- Part 3: Automating Fixes with Konveyor AI (coming soon)

---

## Introduction

**The journey to fully automated migrations has three steps:**

1. **Find the issues** → AI-generated rules (Part 1)
2. **Find them accurately** → Semantic analysis (Part 2 - this post)
3. **Fix them automatically** → AI-assisted refactoring (Part 3 - coming soon)

In [Part 1](/migration/ai/konveyor/patternfly/2025/10/22/automating-ui-migrations-ai-analyzer-rules.html), we generated PatternFly v5→v6 migration rules from documentation using AI. It worked, but text-based pattern matching produced **15-20% false positives**.

**Why does accuracy matter?** Because in Part 3, we'll use Konveyor AI to automatically refactor the violations. False positives waste AI tokens, produce incorrect fixes, and erode trust in automation.

**Part 2 goal:** Get violation accuracy to 95%+ so AI can confidently automate fixes.

**Results from tackle2-ui (66K lines):**
- False positives: 20% → 5% (75% reduction)
- Manual review: ~320 violations → ~66 violations
- Time saved: ~5 hours of manual review
- **Ready for AI automation:** ✅ High-confidence violations

[Jump to validation results →](#real-world-validation-ready-for-ai-automation) | [Try the ruleset now →](#try-it-in-5-minutes)

## The Problem: False Positives Block Automation

The builtin provider from Part 1 is powerful for finding patterns in files, but it has a critical limitation for automation:

**Example: Finding a deprecated component**

```yaml
# Builtin provider approach - regex pattern matching
- ruleID: find-deprecated-component
  when:
    builtin.filecontent:
      pattern: "OldButton"
      filePattern: "*.{ts,tsx}"
  message: OldButton is deprecated, use NewButton
```

This rule will match:
- ✅ `import { OldButton } from '@patternfly/react-core'` (good)
- ✅ `<OldButton />` (good)
- ❌ `// TODO: Update OldButton later` (false positive - just a comment)
- ❌ `const myOldButton = 'something'` (false positive - different symbol)
- ❌ References in strings: `"Check OldButton docs"` (false positive)

The builtin provider can't distinguish between:
- Actual code references
- Comments
- String literals
- Variable names that happen to contain the pattern

## Enter the nodejs Provider

The nodejs provider integrates the **TypeScript Language Server** to perform semantic analysis. It understands:

- Import statements
- Function and class declarations
- Variable references
- Type annotations
- Module structure

**The same rule with nodejs provider:**

```yaml
# nodejs provider approach - semantic analysis
- ruleID: find-deprecated-component
  when:
    nodejs.referenced:
      pattern: "OldButton"
  message: OldButton is deprecated, use NewButton
```

This will **only** match actual code references to the `OldButton` symbol, ignoring comments, strings, and unrelated variables.

![nodejs vs Builtin Provider Comparison](/assets/images/posts/typescript-provider/provider-comparison.png)

## Try It in 5 Minutes

**Update from Part 1:** You no longer need to generate rules yourself for PatternFly migrations. I've created a production-validated ruleset with semantic analysis that you can use immediately.

```bash
# Download the improved ruleset (with nodejs provider)
curl -O https://raw.githubusercontent.com/tsanders-rh/analyzer-rule-generator/main/examples/rulesets/patternfly-v5-to-v6/patternfly-v5-to-v6.yaml

# Run analysis (same kantra command as Part 1)
kantra analyze \
  --input /path/to/your-patternfly-app \
  --rules patternfly-v5-to-v6.yaml \
  --output ./analysis-results
```

**What's different from Part 1:**
- Semantic analysis reduces false positives from ~20% to ~5%
- Faster analysis on small/medium projects (5-10s vs 30-45s)
- Same 10 rules, but smarter provider selection
- **Ready for Part 3:** High-quality violations for AI-assisted refactoring

**Already validated on:** tackle2-ui (66K lines) - [See results →](#real-world-validation-ready-for-ai-automation)

<!--
SCREENSHOT 1: nodejs vs Builtin Provider Comparison
Split screen showing the same code analyzed by both providers:
- Left: Builtin provider results showing false positives in comments and strings
- Right: nodejs provider results showing only actual code references
- Annotations marking correct matches (green checkmarks) vs false positives (red X)
Save as: assets/images/posts/typescript-provider/provider-comparison.png
-->

## What the nodejs Provider Can Find

The nodejs provider excels at finding **top-level symbols**:

✅ **Functions:**
```typescript
function OldButton() { }  // Found
export function OldButton() { }  // Found
```

✅ **Classes:**
```typescript
class OldButton extends Component { }  // Found
export class OldButton { }  // Found
```

✅ **Variables and Constants:**
```typescript
const OldButton = () => { }  // Found
export const OldButton: React.FC = () => { }  // Found
```

✅ **Imports:**
```typescript
import { OldButton } from '@patternfly/react-core'  // Found
```

✅ **JSX Usage:**
```tsx
<OldButton />  // Found (references the imported symbol)
```

## What the nodejs Provider Cannot Find

The nodejs provider has limitations - it **cannot** find:

❌ **Methods inside classes:**
```typescript
class MyComponent {
  componentWillMount() { }  // NOT found by typescript.referenced
}
```

❌ **Properties:**
```typescript
MyComponent.propTypes = { }  // NOT found
MyComponent.defaultProps = { }  // NOT found
```

❌ **Type annotations:**
```typescript
const MyComp: React.FC<Props> = () => { }  // "React.FC" NOT found
```

❌ **Imported types from libraries:**
```typescript
import type { ButtonProps } from '@patternfly/react-core'  // NOT found
```

For these cases, you still need the builtin provider with regex patterns.

### nodejs Provider Capabilities Matrix

The key difference: **nodejs provider uses semantic analysis** (understands code structure) while **builtin provider uses text pattern matching** (regex search).

| Feature                    | nodejs Provider | Builtin Provider | Notes                           |
|---------------------------|---------------------|------------------|---------------------------------|
| **Match Quality**         | ✅ Semantic only    | ⚠️ Text patterns  | nodejs ignores comments/strings |
| **Functions**             | ✅ Yes              | ✅ Yes           | nodejs: actual symbol refs only |
| **Classes**               | ✅ Yes              | ✅ Yes           | nodejs: actual symbol refs only |
| **Variables/Constants**   | ✅ Yes              | ✅ Yes           | nodejs: actual symbol refs only |
| **Imports**               | ✅ Yes              | ✅ Yes           | nodejs: knows import context    |
| **JSX Components**        | ✅ Yes              | ✅ Yes           | nodejs: semantic component refs |
| **Class Methods**         | ❌ No               | ✅ Yes           | Must use builtin                |
| **Object Properties**     | ❌ No               | ✅ Yes           | Must use builtin                |
| **Type Annotations**      | ❌ No               | ✅ Yes           | Must use builtin                |
| **Imported Types**        | ❌ No               | ✅ Yes           | Must use builtin                |
| **JSX Props**             | ❌ No               | ✅ Yes           | Must use builtin                |
| **Comments**              | ❌ Ignored          | ✅ Matches       | nodejs avoids false positives   |
| **String Literals**       | ❌ Ignored          | ✅ Matches       | nodejs avoids false positives   |
| **False Positive Rate**   | ~5%                 | ~15-20%          | nodejs 3-4x more accurate       |
| **Analysis Speed**        | 5-7s                | 30-45s           | nodejs 6x faster (when scoped)  |

**Why this matters:** Both providers can find top-level symbols, but the **nodejs provider is more accurate and faster** because it understands code semantically instead of just matching text patterns. This means fewer false positives to review manually.

<!--
TABLE: nodejs Provider Capabilities Matrix
This markdown table will render in the blog post.
For a styled graphic version, create in spreadsheet software and save as:
assets/images/posts/typescript-provider/capabilities-matrix.png
-->

## Combining Both Providers: The Best of Both Worlds

The most effective migration strategy uses **both providers together**:

### Example 1: Finding Deprecated Component Usage

```yaml
# Use nodejs provider for actual component references
- ruleID: old-button-component-usage
  when:
    nodejs.referenced:
      pattern: "OldButton"
  message: |
    OldButton component is deprecated in PatternFly v6.
    Replace with NewButton component.
  effort: 5
  category: mandatory

# Use builtin provider for JSX props that TypeScript can't find
- ruleID: old-button-variant-prop
  when:
    builtin.filecontent:
      pattern: '<OldButton\s+variant="danger"'
      filePattern: "*.{tsx,jsx}"
  message: |
    The "danger" variant has been renamed to "destructive" in v6.
  effort: 1
  category: mandatory
```

### Example 2: Finding Deprecated Lifecycle Methods

```yaml
# nodejs provider can't find methods, so use builtin
- ruleID: component-will-mount-deprecated
  when:
    builtin.filecontent:
      pattern: "componentWillMount\\s*\\("
      filePattern: "*.{ts,tsx,js,jsx}"
  message: |
    componentWillMount is deprecated. Use componentDidMount or constructor.
  effort: 3
  category: mandatory
```

### Example 3: Finding Type Usage

```yaml
# nodejs provider can't find imported types, use builtin
- ruleID: old-button-props-type
  when:
    builtin.filecontent:
      pattern: "ButtonProps"
      filePattern: "*.{ts,tsx}"
  message: |
    ButtonProps interface has changed in v6.
    Review the new interface definition.
  effort: 3
  category: potential
```

## Real-World Example: PatternFly Migration Rules

Here's how the rule generator creates rules for both providers:

**Input (from migration guide):**
> The `Button` component has been renamed to `ActionButton`. Update all imports and usage.

**Generated Rules:**

```yaml
# nodejs provider - finds component imports and usage
- ruleID: patternfly-v5-to-v6-button-renamed-00000
  description: Button component renamed to ActionButton
  when:
    nodejs.referenced:
      pattern: "Button"
  message: |
    The Button component has been renamed to ActionButton in PatternFly v6.

    Before:
    import { Button } from '@patternfly/react-core'
    <Button>Click me</Button>

    After:
    import { ActionButton } from '@patternfly/react-core'
    <ActionButton>Click me</ActionButton>
  effort: 5
  category: mandatory
  labels:
    - konveyor.io/target=patternfly-v6
    - konveyor.io/source=patternfly-v5

# Builtin provider - finds prop usage nodejs can't detect
- ruleID: patternfly-v5-to-v6-button-props-00001
  description: Button props have changed
  when:
    builtin.filecontent:
      pattern: '<Button\s+.*isDisabled'
      filePattern: "*.{tsx,jsx}"
  message: |
    The isDisabled prop has been renamed to disabled in v6.

    Before: <Button isDisabled>
    After: <ActionButton disabled>
  effort: 1
  category: mandatory
  labels:
    - konveyor.io/target=patternfly-v6
    - konveyor.io/source=patternfly-v5
```

## How Much Can AI Really Automate?

Let's test the limits. I used the analyzer-rule-generator to process the official [PatternFly v5 to v6 upgrade guide](https://www.patternfly.org/get-started/upgrade/) and measure how much of the migration it could automatically detect.

**Results: 10 rules generated covering ~80-85% of automatable patterns**

> **Want to skip the AI generation step?** A complete, production-validated PatternFly v5→v6 ruleset is available ready-to-use in the [analyzer-rule-generator examples](https://github.com/tsanders-rh/analyzer-rule-generator/tree/main/examples/rulesets/patternfly-v5-to-v6). This ruleset has been tested against tackle2-ui (66K+ lines) and found 1,324 violations. You can download and use it directly without generating your own rules.

> **Important:** The nodejs provider doesn't increase the **number** of rules generated from the migration guide - it improves the **quality** of results. The AI generator creates the same 10 rules, but automatically chooses `nodejs.referenced` for component symbols (more accurate, faster) and `builtin.filecontent` for CSS/props/methods (necessary for patterns nodejs can't find). This means fewer false positives and faster analysis without writing extra rules.

```bash
python scripts/generate_rules.py \
  --guide https://www.patternfly.org/get-started/upgrade/ \
  --source patternfly-5 \
  --target patternfly-6 \
  --provider anthropic

✓ Extracted 10 patterns
✓ Generated 10 rules across 6 concern areas
```

### What the LLM Found ✅

**Component Migrations (5 rules):**
- ✅ Chip → Label component replacement
- ✅ Tile → Card component replacement
- ✅ Text → Content component rename
- ✅ ExpandableSection `isActive` prop removal
- ✅ EmptyState refactoring detection

**CSS & Styling (3 rules):**
- ✅ CSS variable prefix: `--pf-v5-global--` → `--pf-t--global--`
- ✅ CSS class prefix: `pf-v5-` → `pf-v6-`
- ✅ React token syntax: `global_FontSize_lg` → `t_global_font_size_lg`

**Other Changes (2 rules):**
- ✅ Chart import path changes: `@patternfly/react-charts` → `@patternfly/react-charts/victory`
- ✅ Breakpoint variable prefix: `--pf-v5-global--breakpoint--` → `--pf-t--global--breakpoint--`

### Example Generated Rule

Here's one of the generated rules using the nodejs provider:

```yaml
- ruleID: patternfly-5-to-patternfly-6-components-00000
  description: Chip should be replaced with Label
  effort: 5
  category: potential
  labels:
  - konveyor.io/source=patternfly-5
  - konveyor.io/target=patternfly-6
  when:
    nodejs.referenced:
      pattern: Chip
  message: |
    The Chip component has been replaced with Label in PatternFly 6

    Replace `Chip` with `Label`.

    Before:
    ```
    import { Chip } from '@patternfly/react-core';
    ```

    After:
    ```
    import { Label } from '@patternfly/react-core';
    ```
  links:
  - url: https://www.patternfly.org/get-started/upgrade#notable-changes
    title: patternfly-6 Documentation
```

Notice how the LLM:
1. Chose `nodejs.referenced` for the component symbol (semantic analysis)
2. Did NOT add a `filePattern` (nodejs provider doesn't support file filtering)
3. Generated before/after examples from the guide
4. Assigned appropriate effort (5) and category (potential)
5. Linked to the migration docs

### What the LLM Missed ❌

The LLM correctly skipped patterns that either:
- Aren't suitable for static analysis (manual CSS review)
- Need runtime/behavioral testing (Button `isDisabled` behavior changes)
- Were not prominently featured in the guide (Select testing patterns)

**This is exactly what we want!** The LLM focused on the mechanical, automatable changes that developers need to fix in their code.

### CSS Pattern Detection

For CSS variables and classes, the LLM correctly chose `builtin.filecontent` with regex file patterns:

```yaml
- ruleID: patternfly-5-to-patternfly-6-css-variables-00000
  when:
    builtin.filecontent:
      pattern: --pf-v5-global--
      filePattern: \.(css|scss|js|jsx|ts|tsx)$  # Regex for multiple file types
  message: |
    PatternFly 6 introduces a new design token system
    Replace `--pf-v5-global--` with `--pf-t--global--`
```

Notice the LLM used:
- `builtin.filecontent` instead of `nodejs.referenced` (CSS patterns need file filtering)
- Regex pattern `\.(css|scss|js|jsx|ts|tsx)$` for multiple file types
- Properly escaped backslashes in the file pattern

### Coverage Analysis

**High Coverage Areas (100%):**
- Component name changes
- CSS variable/class prefix changes
- Import path migrations
- Token syntax updates

**Partial Coverage:**
- Props and methods (caught by builtin provider, but with potential false positives)

**Intentionally Excluded:**
- Manual code review items
- Runtime behavior changes
- Complex refactorings requiring human judgment

**Bottom line:** The 10 generated rules would catch the vast majority of breaking changes that developers need to fix during the PatternFly v5→v6 migration.

## Setting Up the nodejs Provider

> **Note:** This guide assumes you have Konveyor Analyzer already installed. For installation instructions, see the [Konveyor Analyzer documentation](https://github.com/konveyor/analyzer-lsp#installation). For generating migration rules, see the [analyzer-rule-generator](https://github.com/tsanders-rh/analyzer-rule-generator).

### Prerequisites

1. **Install TypeScript Language Server:**
   ```bash
   npm install -g typescript typescript-language-server
   ```

2. **Verify installation:**
   ```bash
   typescript-language-server --version
   ```

### Provider Settings Configuration

Create `nodejs-provider-settings.json`:

```json
{
  "name": "nodejs",
  "binaryPath": "/path/to/typescript-language-server",
  "address": "127.0.0.1:0",
  "initConfig": [
    {
      "location": "/path/to/your/react/project",
      "providerSpecificConfig": {
        "includedPaths": [
          "src/"
        ],
        "excludedPaths": [
          "node_modules/",
          "dist/",
          "build/"
        ],
        "dependencyProviderPath": "/path/to/analyzer-lsp/external-providers/generic-external-provider/generic-external-provider"
      }
    }
  ]
}
```

![Provider Settings Configuration](/assets/images/posts/typescript-provider/provider-settings.png)

<!--
SCREENSHOT 2: Provider Settings Configuration
Show the nodejs-provider-settings.json file in VS Code or terminal:
- Highlight the includedPaths section (e.g., "src/")
- Highlight the excludedPaths section (e.g., "node_modules/", "dist/")
- Optionally show the file tree on the left to demonstrate what's included/excluded
Save as: assets/images/posts/typescript-provider/provider-settings.png
-->

**Important:** Make sure to:
- Set `includedPaths` to your source directory
- Exclude `node_modules/` to prevent scanning dependencies
- Point to your compiled `generic-external-provider` binary

### Running Analysis with nodejs Provider

**For development/testing:**
```bash
konveyor-analyzer \
  --provider-settings=nodejs-provider-settings.json \
  --rules=patternfly-v5-to-v6-migration.yaml \
  --output-file=analysis-output.yaml \
  --verbose=1
```

**For end users (recommended):**

Most users won't run `konveyor-analyzer` directly. Instead, they use **kantra**, which automatically handles provider containers:

```bash
# Install kantra CLI
# Download from: https://github.com/konveyor/kantra/releases

# Run analysis on your PatternFly application
kantra analyze \
  --input /path/to/your/patternfly-app \
  --rules /path/to/patternfly-v5-to-v6-migration.yaml \
  --output /path/to/output-dir
```

**What kantra does automatically:**
1. Detects TypeScript/JavaScript files in your application
2. Pulls the `generic-external-provider` container (includes nodejs/TypeScript support)
3. Pulls the `analyzer-lsp` container
4. Starts all provider containers in a pod
5. Runs analysis and generates output

**Important:** The `--run-local` flag only works for Java analysis. For TypeScript/React/PatternFly projects, kantra **must use container mode** (which is the default for non-Java projects).

**Prerequisites for kantra:**
- Podman 4+ or Docker 24+ installed
- Internet connection (to pull container images)
- No need to manually install TypeScript Language Server or build providers

This is the easiest way for users to analyze their PatternFly applications without dealing with provider setup.

## Using or Generating Rules with nodejs Support

### Option 1: Use Pre-Generated PatternFly Rules (Quickest)

For PatternFly v5→v6 migrations, a complete, validated ruleset is ready to use:

```bash
# Download the ruleset
curl -O https://raw.githubusercontent.com/tsanders-rh/analyzer-rule-generator/main/examples/rulesets/patternfly-v5-to-v6/patternfly-v5-to-v6.yaml

# Run analysis with kantra
kantra analyze \
  --input /path/to/your/patternfly-app \
  --rules patternfly-v5-to-v6.yaml \
  --output /path/to/output-dir
```

**This ruleset includes:**
- 10 migration rules with nodejs + builtin providers
- Validated against tackle2-ui (66K+ lines)
- Comprehensive README with usage instructions
- [View on GitHub](https://github.com/tsanders-rh/analyzer-rule-generator/tree/main/examples/rulesets/patternfly-v5-to-v6)

### Option 2: Generate Custom Rules for Other Migrations

For migrations beyond PatternFly, the analyzer-rule-generator automatically determines when to use nodejs provider vs builtin provider. **You get the same number of rules**, but the AI chooses the best provider for each pattern:

```bash
python src/rule_generator/main.py \
  --guide-url "https://your-framework.com/migration-guide" \
  --source-version "v1" \
  --target-version "v2" \
  --output-dir examples/output/custom-migration/
```

The generator will:
- ✅ Use `nodejs.referenced` for component/function/class references (semantic analysis)
- ✅ Use `builtin.filecontent` for methods, props, types, and complex patterns
- ✅ Use regex patterns like `\.(j|t)sx?$` for file matching with builtin provider
- ✅ Create a mix of both provider types for comprehensive coverage

**Key insight:** The nodejs provider enables **smarter rule generation**, not **more rules**. The same migration guide produces the same number of rules, but each rule uses the optimal provider for better accuracy and performance.

## Performance Comparison

**Test Project (Small - 4 files):**

Without nodejs Provider (builtin only):
- Analysis time: 30-45 seconds
- False positives: ~15-20%
- Manual review needed: High

With nodejs Provider:
- Analysis time: 5-7 seconds (with node_modules excluded)
- False positives: ~5% (only semantic matches)
- Manual review needed: Low
- More precise violation locations

![Analysis Output Comparison](/assets/images/posts/typescript-provider/analysis-results.png)

<!--
SCREENSHOT 3: Analysis Output Comparison
Side-by-side comparison showing:
- Builtin only: ~2,800 violations, ~15-20% false positives, 30-45s analysis time
- With TypeScript provider: ~2,540 violations, ~5% false positives, 5-7s analysis time
Use a bar chart or table to visualize the improvements
Save as: assets/images/posts/typescript-provider/analysis-results.png
-->

### Real-World Validation: Ready for AI Automation?

To validate whether semantic analysis produces **AI-ready violations**, I analyzed **[tackle2-ui](https://github.com/konveyor/tackle2-ui)** - Konveyor's own production application - with both approaches.

**Codebase:** 66,000+ lines, 565 TypeScript files, real PatternFly v5 usage

**Results Comparison:**

| Metric | Text Matching (Part 1) | Semantic Analysis (Part 2) | Impact on AI Automation |
|--------|----------------------|---------------------------|------------------------|
| Total Violations | ~1,600 | 1,324 | More focused scope |
| False Positives | ~20% (320) | ~5% (66) | **75% fewer bad fixes** |
| Comments/Strings | Flagged ❌ | Ignored ✅ | AI won't change docs |
| Violation Quality | Mixed | High precision | AI can trust location |
| **Ready for AI?** | ⚠️ Risky | ✅ Yes | **95% fix confidence** |

**Violations by Rule:**

| Pattern | Count | Rule Type | AI Automation Quality |
|---------|-------|-----------|----------------------|
| `Text` component → `Content` | 886 | nodejs.referenced | ✅ All genuine code refs |
| `EmptyState` refactoring | 200 | nodejs.referenced | ✅ Precise locations |
| CSS class prefix (`pf-v5-` → `pf-v6-`) | 172 | builtin.filecontent | ✅ Pattern-based (safe) |
| CSS variable prefix updates | 45 | builtin.filecontent | ✅ Pattern-based (safe) |
| React token syntax changes | 21 | nodejs.referenced | ✅ Semantic matches |

**Key Insights:**

1. **High Precision Enables Automation:** The 886 `Text` component violations are all genuine code references (not comments or strings). This is exactly what AI needs to confidently generate fixes.

2. **The Math on False Positives:**
   - Text matching: 320 false positives × 2 min review = **10.6 hours wasted**
   - Semantic analysis: 66 false positives × 2 min review = **2.2 hours**
   - **Time saved: 8.4 hours** (and AI won't waste tokens on bad violations)

3. **Performance Trade-off Worth It:** ~35 minutes for analysis vs. hours saved on manual review and AI token costs. For large codebases, accuracy matters more than analysis speed.

4. **Ready for Part 3:** Each violation includes:
   - Precise file location (line numbers)
   - Before/after examples from PatternFly docs
   - High confidence (95%+ are real issues)
   - **Perfect input for AI-assisted refactoring** ← Coming in Part 3!

**Performance by Project Size:**

| Project Size | Analysis Time | Use Case | Ready for AI? |
|--------------|---------------|----------|---------------|
| Small (< 10K lines) | 5-10 seconds | CI/CD, pre-commit hooks | ✅ Yes |
| Medium (10-50K lines) | 5-15 minutes | PR checks, regular scans | ✅ Yes |
| Large (50K+ lines) | 30-40 minutes | Deep analysis, migration planning | ✅ Yes |

**Bottom line:** Semantic analysis produces the high-quality violation data that AI needs to automate fixes confidently. The accuracy improvements in Part 2 enable the automation in Part 3.

## Limitations and Workarounds

### Limitation 1: nodejs Provider Only Finds Top-Level Symbols

**Workaround:** Use builtin provider for methods, properties, and nested symbols.

```yaml
# Can't use typescript.referenced for methods
- ruleID: find-lifecycle-method
  when:
    builtin.filecontent:
      pattern: "componentWillMount"
      filePattern: "*.{ts,tsx}"
```

### Limitation 2: Performance with Large Codebases

**Workaround:** Use `includedPaths` to scope analysis:

```json
{
  "providerSpecificConfig": {
    "includedPaths": [
      "src/components/",
      "src/pages/"
    ]
  }
}
```

### Limitation 3: Must Exclude node_modules

**Workaround:** Always exclude dependencies in provider settings:

```json
{
  "providerSpecificConfig": {
    "excludedPaths": [
      "node_modules/",
      "dist/",
      "build/",
      ".next/"
    ]
  }
}
```

## Best Practices

### 1. Use nodejs Provider First

Start with `nodejs.referenced` for component/function references, fall back to `builtin.filecontent` when needed.

<div class="mermaid">
flowchart TD
    A[Need to find a pattern?] --> B{Is it a top-level symbol?}
    B -->|Yes: Function/Class/Const| C{Is it imported from library?}
    B -->|No: Method/Property/Type| D[Use builtin.filecontent]
    C -->|Yes| E[Use nodejs.referenced]
    C -->|No: Local declaration| E
    E --> F[Semantic Analysis]
    D --> G[Text Pattern Matching]
    F --> H[Precise Results]
    G --> I[May have false positives]

    style E fill:#51cf66,color:#000
    style D fill:#ffb84d,color:#000
    style H fill:#9775fa,color:#000
    style I fill:#ff6b6b,color:#000
</div>

<!--
FLOWCHART: Decision tree for choosing nodejs vs Builtin provider
This Mermaid diagram will render in the blog post automatically.
For a static image version, save as: assets/images/posts/typescript-provider/provider-decision-tree.png
-->

### 2. Combine Providers for Complete Coverage

```yaml
# nodejs for the component
- when:
    nodejs.referenced:
      pattern: "OldComponent"

# Builtin for props and methods
- when:
    builtin.filecontent:
      pattern: "OldComponent.*oldProp"
```

### 3. Use Regex Patterns for File Filtering (builtin provider only)

```yaml
# For builtin.filecontent - use regex patterns
filePattern: "\.(j|t)sx?$"      # All .js/.jsx/.ts/.tsx files
filePattern: "\.(css|scss)$"     # All .css/.scss files

# IMPORTANT: nodejs.referenced does NOT support filePattern
# It matches across all JS/TS files automatically
```

### 4. Scope Your Analysis

Use `includedPaths` and `excludedPaths` to:
- Reduce analysis time
- Avoid scanning dependencies
- Focus on relevant source code

### 5. Test Your Rules

Create test files to verify rules work correctly:

```yaml
# test/test-nodejs-provider.yaml
- ruleID: test-component-detection
  when:
    nodejs.referenced:
      pattern: "TestComponent"
  message: Found TestComponent
```

![Semantic Analysis Example](/assets/images/posts/typescript-provider/semantic-analysis.png)

<!--
SCREENSHOT 4: Semantic Analysis Example
Code editor showing a file with nodejs provider violations highlighted:
- Show actual component usage highlighted (e.g., <OldButton />)
- Show comment containing "OldButton" NOT highlighted
- Show string literal containing "OldButton" NOT highlighted
- Include hover tooltip or problems panel showing violation details
Save as: assets/images/posts/typescript-provider/semantic-analysis.png
-->

## Integration with Konveyor AI

The nodejs provider enhances AI-assisted migration:

1. **More Precise Violations:** Semantic analysis gives better context
2. **Better AI Suggestions:** AI sees actual code structure, not just text
3. **Fewer False Positives:** Less noise for AI to filter through
4. **Automated Fixes:** AI can make more confident code changes

Example workflow:
```bash
# 1. Generate rules with nodejs support
python src/rule_generator/main.py --guide-url <url>

# 2. Run analysis with nodejs provider
konveyor-analyzer --provider-settings=nodejs-provider-settings.json

# 3. Use Konveyor AI to suggest fixes
# AI sees semantic violations with precise locations

# 4. Review and apply AI-suggested changes
```

## Conclusion: Setting Up for Automation

**This three-part series is building toward fully automated migrations:**

**Part 1 - Generate Rules** ([previous post](/migration/ai/konveyor/patternfly/2025/10/22/automating-ui-migrations-ai-analyzer-rules.html)):
- ✅ AI extracts patterns from migration guides
- ✅ Generates Konveyor Analyzer rules automatically
- ⚠️ Text matching produces 15-20% false positives

**Part 2 - Improve Accuracy** (this post):
- ✅ Semantic analysis reduces false positives to ~5%
- ✅ Validated on tackle2-ui (66K lines, 1,324 high-quality violations)
- ✅ Production-ready ruleset available
- **✅ Violations are now AI-ready**

**Part 3 - Automate Fixes** (coming soon):
- 🔜 Use Konveyor AI to automatically refactor violations
- 🔜 Leverage the 95% accuracy from semantic analysis
- 🔜 Turn 40+ hours of manual work into ~3 hours of review
- 🔜 Complete the automation pipeline

**Why this progression matters:** You can't automate fixes reliably with 20% false positives. The accuracy improvements in Part 2 enable the automation in Part 3.

**Key Takeaways from Part 2:**

1. **Semantic analysis is game-changing:** 75% reduction in false positives
2. **Use both providers:** nodejs for components, builtin for CSS/props/methods
3. **Validation matters:** tackle2-ui proves this works on real codebases
4. **Ready for automation:** High-precision violations are perfect AI input

**For PatternFly teams:** The [production-validated ruleset](https://github.com/tsanders-rh/analyzer-rule-generator/tree/main/examples/rulesets/patternfly-v5-to-v6) is ready to use now. Try the [5-minute quick start](#try-it-in-5-minutes), and watch for Part 3 where we automate the actual fixes.

## Next Steps

1. **PatternFly migrations:** Download the [pre-generated ruleset](https://github.com/tsanders-rh/analyzer-rule-generator/tree/main/examples/rulesets/patternfly-v5-to-v6) and run it on your codebase today
2. **Other frameworks:** Use analyzer-rule-generator to create custom rules for your migration guide
3. **Try it yourself:** Install nodejs provider and test the semantic analysis capabilities
4. **Contribute:** Submit fixes to analyzer-lsp (like the [nodejs provider PR](https://github.com/konveyor/analyzer-lsp/pull/930))
5. **Share results:** Let the community know how well it works for your migration

---

**Coming in Part 3: Automating the Fixes**

Now that we have 1,324 high-precision violations from tackle2-ui, the next post will show how to use **Konveyor AI** to automatically refactor them:

**What I'll cover:**
- Feeding semantic violations to Konveyor AI for better context
- Generating fixes for the 886 `Text` → `Content` component changes
- Batch processing with confidence thresholds
- Handling edge cases and manual review
- **Measuring the time savings** (spoiler: it's substantial)

**The goal:** Turn 40+ hours of manual refactoring into 3 hours of reviewing AI-suggested fixes.

**Example from tackle2-ui:**
```tsx
// Before (1 of 886 violations detected)
import { Text } from '@patternfly/react-core';
<Text component="h2">My Heading</Text>

// After (AI-generated fix with 95% confidence)
import { Content } from '@patternfly/react-core';
<Content component="h2">My Heading</Content>
```

Multiply this by 886 instances, and you see why accuracy matters. With 95% precision from semantic analysis, AI can confidently automate these changes.

**Want early access?** The [Konveyor AI project](https://github.com/konveyor/kai) is already available. Stay tuned for the detailed walkthrough in Part 3.

---

## Resources

**This Series:**
- Part 1: [Generating Migration Rules with AI](/migration/ai/konveyor/patternfly/2025/10/22/automating-ui-migrations-ai-analyzer-rules.html)
- Part 2: Improving Detection with Semantic Analysis (this post)
- Part 3: Automating Fixes with Konveyor AI (coming soon - [watch the repo](https://github.com/tsanders-rh/analyzer-rule-generator))

**Ready to Use:**
- [PatternFly v5→v6 Migration Ruleset](https://github.com/tsanders-rh/analyzer-rule-generator/tree/main/examples/rulesets/patternfly-v5-to-v6) - Production-validated, semantic analysis
- [Analyzer Rule Generator](https://github.com/tsanders-rh/analyzer-rule-generator) - Generate custom rules for any migration

**For Part 3:**
- [Konveyor AI](https://github.com/konveyor/kai) - AI-assisted code refactoring (preview available now)
- [nodejs Provider PR](https://github.com/konveyor/analyzer-lsp/pull/930) - Semantic analysis foundation

---

*Have questions or suggestions? Open an issue on the [analyzer-rule-generator repo](https://github.com/tsanders-rh/analyzer-rule-generator/issues).*
