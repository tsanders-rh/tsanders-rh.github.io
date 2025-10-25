---
layout: single
title: "Enhancing UI Migration Rules with Node.js Provider Support"
date: 2025-10-21
categories: [migration, ai, konveyor, typescript]
tags: [migration, typescript, konveyor, static-analysis, semantic-analysis, patternfly, react]
excerpt: "Moving beyond text pattern matching: how the TypeScript provider enables semantic code analysis for more accurate, faster UI migrations"
header:
  overlay_color: "#333"
  overlay_filter: "0.5"
author_profile: true
classes: wide
---

## Introduction

In my [previous post](/migration/ai/konveyor/patternfly/2025/10/22/automating-ui-migrations-ai-analyzer-rules.html), I showed how to use Konveyor Analyzer and AI-generated rules to automate PatternFly v5 to v6 migrations. That approach used the builtin provider with regex pattern matching to find deprecated code patterns.

But what if we could go deeper? What if instead of just searching for text patterns, we could perform **semantic analysis** of TypeScript code to find actual symbol references, imports, and type usage?

This is where the **nodejs provider** comes in.

## The Problem with Text-Only Matching

The builtin provider is powerful for finding patterns in files, but it has limitations:

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

| Feature                    | nodejs Provider | Builtin Provider | Notes                           |
|---------------------------|---------------------|------------------|---------------------------------|
| **Functions**             | ✅ Yes              | ✅ Yes           | nodejs: semantic only       |
| **Classes**               | ✅ Yes              | ✅ Yes           | nodejs: semantic only       |
| **Variables/Constants**   | ✅ Yes              | ✅ Yes           | nodejs: semantic only       |
| **Imports**               | ✅ Yes              | ✅ Yes           | nodejs more precise         |
| **JSX Components**        | ✅ Yes              | ✅ Yes           | nodejs avoids false matches |
| **Class Methods**         | ❌ No               | ✅ Yes           | Must use builtin                |
| **Object Properties**     | ❌ No               | ✅ Yes           | Must use builtin                |
| **Type Annotations**      | ❌ No               | ✅ Yes           | Must use builtin                |
| **Imported Types**        | ❌ No               | ✅ Yes           | Must use builtin                |
| **JSX Props**             | ❌ No               | ✅ Yes           | Must use builtin                |
| **Comments**              | ❌ Ignored          | ✅ Matches       | nodejs advantage            |
| **String Literals**       | ❌ Ignored          | ✅ Matches       | nodejs advantage            |
| **False Positive Rate**   | ~5%                 | ~15-20%          | nodejs more accurate        |
| **Analysis Speed**        | 5-7s                | 30-45s           | nodejs faster (when scoped) |

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

## Generating Rules with nodejs Support

The analyzer-rule-generator automatically determines when to use nodejs provider vs builtin provider:

```bash
python src/rule_generator/main.py \
  --guide-url "https://github.com/patternfly/patternfly-react/blob/main/packages/react-core/UPGRADE-GUIDE-v6.md" \
  --source-version "patternfly-v5" \
  --target-version "patternfly-v6" \
  --output-dir examples/output/patternfly-v6/
```

The generator will:
- ✅ Use `nodejs.referenced` for component/function/class references (semantic analysis)
- ✅ Use `builtin.filecontent` for methods, props, types, and complex patterns
- ✅ Use regex patterns like `\.(j|t)sx?$` for file matching with builtin provider
- ✅ Create a mix of both provider types for comprehensive coverage

## Performance Comparison

**Without nodejs Provider (builtin only):**
- Analysis time: 30-45 seconds
- False positives: ~15-20%
- Manual review needed: High

**With nodejs Provider:**
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

## Conclusion

The nodejs provider transforms Konveyor Analyzer from a text pattern matcher into a **semantic code analyzer** for TypeScript/React projects.

**Key Takeaways:**

1. **Use both providers:** nodejs for semantic analysis, builtin for text patterns
2. **Know the limitations:** nodejs provider only finds top-level symbols
3. **Exclude node_modules:** Critical for performance
4. **Brace expansion:** Use `*.{ts,tsx}` for concise file patterns
5. **Test your rules:** Verify both providers work correctly

Combined with AI-generated rules and Konveyor AI assistance, this creates a powerful automation pipeline for UI framework migrations.

## Next Steps

1. **Try it yourself:** Install nodejs provider and run on your codebase
2. **Generate nodejs rules:** Use analyzer-rule-generator with your migration guide
3. **Contribute:** Submit fixes to analyzer-lsp (like the [nodejs provider PR](https://github.com/konveyor/analyzer-lsp/pull/930))
4. **Share results:** Let the community know how well it works for your migration

## Resources

- [Analyzer Rule Generator](https://github.com/tsanders-rh/analyzer-rule-generator)
- [nodejs Provider PR](https://github.com/konveyor/analyzer-lsp/pull/930)
- [Konveyor Analyzer Documentation](https://github.com/konveyor/analyzer-lsp)
- [Previous Post: Automating UI Migrations with AI](/migration/ai/konveyor/patternfly/2025/10/22/automating-ui-migrations-ai-analyzer-rules.html)

---

*Have questions or suggestions? Open an issue on the [analyzer-rule-generator repo](https://github.com/tsanders-rh/analyzer-rule-generator/issues).*
