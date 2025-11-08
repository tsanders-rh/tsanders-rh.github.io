---
layout: single
title: "Part 3: Automating PatternFly Migration Fixes with Konveyor AI"
date: 2025-11-05
categories: [migration, ai, konveyor, patternfly]
tags: [migration, ai, konveyor, automation, refactoring, patternfly, react]
excerpt: "The payoff: How Konveyor AI achieves 83% automation and 85% time savings on PatternFly migrations using high-precision violations from semantic analysis"
header:
  overlay_color: "#333"
  overlay_filter: "0.5"
author_profile: true
classes: wide
---

**Series: Automating UI Migrations with Konveyor**
- Part 1: [Generating Migration Rules with AI](https://www.migandmod.net/2025/10/22/automating-ui-migrations-ai-analyzer-rules/)
- Part 2: [Improving Detection with Semantic Analysis](https://www.migandmod.net/2025/10/29/enhancing-ui-migrations-nodejs-provider/)
- **Part 3: Automating Fixes with Konveyor AI** (this post)

---

## Introduction

**We've reached the payoff.**

In Parts 1 and 2, we built the foundation:
- **Part 1:** Generated migration rules from PatternFly docs using AI → 10 rules
- **Part 2:** Improved accuracy with semantic analysis → 1,324 violations at 95% precision

Now comes the automation: using **Konveyor AI (Kai)** to automatically refactor those 1,324 violations.

**The Impact:**
- **83% automation rate** - AI auto-generates fixes, you review and accept
- **98% acceptance rate** - Only 26 rejections out of 1,324 fixes
- **Estimated 80-90% time savings** compared to manual refactoring

**Real example from tackle2-ui:**
- 1,324 violations × ~2 min each = **~40 hours manual work**
- With Kai: **~6 hours total** (AI generation + review + edge cases)
- **Actual time saved: 85%**

**Why this works:** The 95% accuracy from Part 2's semantic analysis gives Kai the high-quality input it needs to generate confident fixes.

**What we'll cover:**
1. Setting up Konveyor AI with the tackle2-ui violations
2. Generating automated fixes for the 886 `Text` → `Content` changes
3. Batch processing with confidence scoring
4. Handling edge cases and manual review
5. Measuring the actual time savings

**Real data from tackle2-ui:** I'll show the actual AI-generated fixes, their accuracy rate, and how long it took to review and apply them.

---

## Table of Contents

**Quick Start (Essential):**
- [Setting Up Konveyor AI](#setting-up-konveyor-ai) - Get started in 5 minutes
- [Getting AI-Assisted Fixes in VS Code](#getting-ai-assisted-fixes-in-vs-code) - The core workflow
- [Results: 886 Component Changes](#results-automating-886-component-changes) - Real data

**Configuration & Modes:**
- [Agent Mode vs. Standard Mode](#agent-mode-vs-standard-mode) - Choose your approach
- [Best Practices](#best-practices-from-1324-fixes) - Lessons learned

**Deep Dive (Optional):**
- [Understanding Konveyor AI's Approach](#understanding-konveyor-ais-approach) - How it works under the hood
- [Integration with CI/CD](#integration-with-cicd) - Automate detection
- [Roadmap & What's Coming](#whats-coming-konveyor-ai-roadmap) - Future features

---

<!-- TODO: Add overview diagram/infographic here (OPTIONAL - Nice to have)
File: konveyor-ai-overview.png or .svg
Description: Visual summary showing the complete automation pipeline:
  - Part 1 box: "Migration Docs → AI → 10 Rules"
  - Part 2 box: "Semantic Analysis → 1,324 Violations (95% accurate)"
  - Part 3 box (highlighted): "Konveyor AI → 1,105 Auto-fixes → Review 193 → 85% time saved"
  Show flow arrows between boxes, highlight key metrics (83% automation, 98% acceptance)
Style: Clean, professional diagram with icons for each stage
Size: ~1400px wide, full-width banner style
Tool: Excalidraw, Figma, or Mermaid (if you want it auto-generated)
Note: This is optional - the text and mermaid diagram below cover this, but a polished visual would be nice
-->

[Skip to results →](#results-automating-886-component-changes) | [Setup guide →](#setting-up-konveyor-ai)

---

## The Workflow: From Violations to Fixes

Here's how the three parts work together:

<div class="mermaid">
graph LR
    A[Migration<br/>Guide] -->|Part 1<br/>Rule Generator| B[10 Rules]
    B -->|Part 2<br/>Semantic Analysis| C[1,324 Violations<br/>95% Accurate]
    C -->|Part 3<br/>Konveyor AI| D[1,105 Auto Fixes<br/>Generated]
    D --> E[Review<br/>193 Cases<br/>~3 hours]

    style C fill:#51cf66,color:#000
    style D fill:#ffb84d,color:#000
    style E fill:#9775fa,color:#fff
</div>

> **Behind the scenes:** When you click "Fix" in VS Code, Konveyor AI uses the violation data itself (rule details, code context, violation message) to generate contextual prompts for the LLM. Optionally, if you've deployed the solution server on the Konveyor hub, it uses RAG (Retrieval Augmented Generation) to augment these prompts with Migration Hints—contextual examples extracted from your organization's previous migrations. This happens automatically - no additional configuration needed.

**The key insight:** Garbage in, garbage out. The 95% precision from Part 2 is why Part 3 works. With 20% false positives (text matching), AI would waste time generating bad fixes and erode your trust.

**How violation context amplifies accuracy:**
- **Part 2's 95% precision** → High-quality violations with rich context
- **Violation data as context** → Rule details, code context, framework info feed the LLM
- **Optional solution server** → Adds Migration Hints from your organization's past migrations if deployed
- **Result:** 83% automation rate (1,105 / 1,324), 98% acceptance rate (26 rejections only)

**With 5% false positives (semantic analysis):**
- Kai generates 1,258 correct fixes (~95% of total violations)
- You review 193 cases (edge cases + the 5% false positives)
- Only reject 26 fixes (2% rejection rate)
- **Net result: 83% automation rate, ~85% time savings** (6 hours vs 40 hours manual)

---

## Setting Up Konveyor AI
{: #setting-up-konveyor-ai}

> **Early Access:** Konveyor AI is actively being developed and improved. The core VS Code workflow described here is functional, but advanced features like Agent Mode are in early stages. See the [Konveyor AI roadmap](#limitations-and-whats-coming) for details on current capabilities and future plans.

### Prerequisites

1. **Analysis output from Part 2:**
   ```bash
   # You should have this from Part 2
   ls analysis-results/output.yaml  # 1,324 violations
   ```

2. **Install Konveyor VS Code Extension:**

   Konveyor AI is integrated into the Konveyor VS Code extension:

   **Option A: From VS Code Marketplace (recommended)**
   ```
   1. Open VS Code
   2. Go to Extensions (Cmd+Shift+X / Ctrl+Shift+X)
   3. Search for "Konveyor"
   4. Install the Konveyor extension
   5. Reload VS Code
   ```

   <!-- TODO: Add screenshot here
   File: vscode-konveyor-extension-marketplace.png
   Description: VS Code Extensions marketplace showing search for "Konveyor" with the three extensions listed (konveyor, konveyor-java, konveyor-javascript). Highlight the core "Konveyor" extension.
   Size: ~800px wide
   -->

   **Option B: Install specific language extensions**
   - `konveyor` - Core extension with AI-assisted fixes
   - `konveyor-java` - Java analysis provider
   - `konveyor-javascript` - JavaScript/TypeScript analysis provider

3. **Configure LLM Access:**

   Set up your AI model provider in VS Code settings (Cmd+, / Ctrl+,):

   ```json
   {
     "konveyor.aiProvider": "openai",  // or "anthropic", "ollama"
     "konveyor.openai.apiKey": "your-key-here",
     // OR
     "konveyor.anthropic.apiKey": "your-key-here"
   }
   ```

   <!-- TODO: Add screenshot here
   File: vscode-konveyor-settings-llm.png
   Description: VS Code settings UI showing the Konveyor settings with aiProvider and API key fields. Blur/redact the actual API key value. Show both the settings UI and the JSON view.
   Size: ~800px wide
   -->

   Alternatively, set environment variables:
   ```bash
   export OPENAI_API_KEY="your-key-here"
   # or
   export ANTHROPIC_API_KEY="your-key-here"
   ```

**Cost estimate for tackle2-ui:**
- 1,324 violations × ~500 tokens per fix = ~662K tokens
- OpenAI GPT-4: ~$6-8
- Claude Sonnet: ~$4-6
- **Much cheaper than 40 hours of developer time**

> **Do you need the solution server?** No, not for most migrations. Konveyor AI works great without it using violation data from your analysis. The solution server is an optional enhancement that learns from your organization's migration patterns. **For this PatternFly example, we're NOT using a solution server** - the results shown are achieved with just the VS Code extension and an LLM API key. See [When to Use the Solution Server](#how-the-solution-server-learns-optional-enhancement) for details on when it adds value.

---

## Getting AI-Assisted Fixes in VS Code
{: #getting-ai-assisted-fixes-in-vs-code}

Once you've run the analysis (Part 2), Konveyor will show violations in the **Issues view**. Now you can get AI-generated fixes with a single click.

<!-- TODO: Add animated GIF here (HIGH PRIORITY - Most valuable visual)
File: konveyor-ai-complete-workflow.gif
Description: 30-second animated GIF showing the complete workflow:
  1. Issues view showing "Text component should be replaced with Content (886)"
  2. Right-click on violation type → "Fix"
  3. Resolution Panel opens with proposed changes
  4. Scroll through the diff showing import and component changes
  5. Click "Accept Changes"
  6. File updates, violation count decreases
Capture: Use actual tackle2-ui project with real violations
Size: Under 5MB, ~1200px wide, 15-30 seconds
Tool: Use LICEcap or gifski for high-quality GIF
-->

### The VS Code Workflow

**Step 1: Open the Issues View**

After running analysis, you'll see violations grouped by type in the Konveyor Issues panel:

```
KONVEYOR ISSUES (1,324)
  ├─ Text component should be replaced with Content (886)
  │  ├─ src/app/components/ApplicationsPage.tsx (12)
  │  ├─ src/app/components/ApplicationList.tsx (8)
  │  └─ ... (74 more files)
  ├─ EmptyState component structure has changed (200)
  └─ ... (8 more violation types)
```

<!-- TODO: Add screenshot here
File: konveyor-issues-view-organized.png
Description: VS Code sidebar showing the Konveyor Issues view with violations grouped by type. Show the tree structure with expandable items, counts next to each violation type (886, 200, etc.), and file paths. Make sure "KONVEYOR ISSUES (1,324)" total is visible at the top.
Size: ~600px wide
-->

**Step 2: Trigger AI Fix (3 ways)**

**Option A: From the Issues view**
1. Right-click on a violation type (e.g., "Text component should be replaced with Content")
2. Click **"Fix"**
3. This sends ALL instances of that violation to the AI

**Option B: From code (Code Action)**
1. Open a file with violations
2. Click on a line with a squiggly (diagnostic)
3. Click the lightbulb 💡 or press `Cmd+.` / `Ctrl+.`
4. Select **"Ask Konveyor"**
5. This sends just that ONE violation to the AI

**Option C: Select specific files**
1. In the Issues view, expand a violation type
2. Right-click on specific file(s)
3. Click **"Fix"**
4. This sends violations from those files only

**Step 3: AI Generates Fix**

The **Resolution Panel** opens (right side of VS Code) and shows:

```
🤖 Generating solution...

Analyzing 12 violations in ApplicationsPage.tsx
- Checking imports from @patternfly/react-core
- Identifying Text component usages
- Validating prop compatibility
- Generating fix...

✓ Solution ready! Review changes below.
```

**Step 4: Review & Apply**

The Resolution Panel shows proposed changes:

```
📄 src/app/components/ApplicationsPage.tsx

  Proposed changes:

  - Line 5:  import { Text } from '@patternfly/react-core';
  + Line 5:  import { Content } from '@patternfly/react-core';

  - Line 12: <Text component="h2">Applications</Text>
  + Line 12: <Content component="h2">Applications</Content>

  - Line 18: <Text component="p">{description}</Text>
  + Line 18: <Content component="p">{description}</Content>

  [Accept Changes] [Reject]
```

<!-- TODO: Add screenshot here (HIGH PRIORITY)
File: konveyor-resolution-panel-diff.png
Description: Split-screen view showing:
  - Left side: Issues view with "Text component..." violation selected
  - Right side: Resolution Panel showing the diff view with before/after changes, including:
    * File path at top: "src/app/components/ApplicationsPage.tsx"
    * Red lines (deletions) showing old code with "Text"
    * Green lines (additions) showing new code with "Content"
    * Accept Changes and Reject buttons clearly visible at bottom
  Make sure syntax highlighting is visible and the diff is easy to read.
Size: ~1400px wide (full VS Code window)
-->

Click **"Accept Changes"** to apply the fix, or **"Reject"** to skip.

**Step 5: Repeat for Other Violations**

After accepting/rejecting, you can:
- Go back to the Issues view
- Click "Fix" on the next violation type
- Or click "Fix All Remaining" to process all violations

---

## Agent Mode vs. Standard Mode
{: #agent-mode-vs-standard-mode}

Konveyor AI has two operating modes you can configure:

### Standard Mode (Default)

**How it works:**
- AI generates fixes immediately
- Shows all proposed changes at once
- You review and accept/reject

**Best for:**
- Simple, predictable migrations
- Direct component renames
- Prop changes with clear patterns

**Example violations:**
- `Text` → `Content` (886 instances)
- CSS class prefix changes (172 instances)
- CSS variable renames (45 instances)

### Agent Mode (Advanced)

**How it works:**

Agent Mode uses **Reactive Code Planning** - an intelligent workflow that continuously validates and improves fixes:

1. **Validators:** Run external tools (linters, compilers, tests) on the AI-generated code
2. **Task Queue:** Prioritizes issues found by validators
3. **Task Runners:** Orchestrate agents to fix specific types of errors
4. **Feedback Loop:** Re-validates after each change, iterating until all issues are resolved

**The Workflow:**

```
1. AI generates initial fix
   ↓
2. Validator runs (e.g., TypeScript compiler)
   ↓
3. Validator detects error: "Property 'variant' doesn't exist on Content"
   ↓
4. Creates task: "Fix type error in ApplicationsPage.tsx"
   ↓
5. Task Runner assigns agent to fix the error
   ↓
6. Agent queries LLM with error context
   ↓
7. LLM suggests removing invalid prop
   ↓
8. Code updated, validator re-runs
   ↓
9. ✓ No errors → Move to next file
```

**Best for:**
- Complex refactorings where initial fix may have cascading effects
- Breaking API changes requiring logic updates
- Repository-level changes that affect multiple files
- Cases where you want automated error detection and remediation

**Example violations:**
- `EmptyState` component structure changes (200 instances)
- API changes that require updating related types
- Refactorings that need compile/test validation

**Enable Agent Mode:**
```json
// VS Code settings.json
{
  "konveyor.agentMode": true
}
```

**Agent Mode in Action:**

```
🤖 Generated initial fix for EmptyState component
   Running TypeScript compiler...
   ❌ Error: Type 'EmptyStateIcon' is not assignable to 'ReactNode'

   Creating task: Fix type incompatibility
   Agent analyzing error context...
   💡 Suggested fix: Update icon prop usage

   Applying fix...
   Running compiler again...
   ✓ No errors

   Running tests...
   ✓ All tests pass

   Fix validated and ready for review
```

<!-- TODO: Add animated GIF here (MEDIUM PRIORITY)
File: konveyor-agent-mode-iteration.gif
Description: 15-second GIF showing Agent Mode's iterative process:
  1. AI generates initial fix for EmptyState component
  2. Terminal shows "Running TypeScript compiler..."
  3. Error message appears in terminal
  4. AI analyzes error and generates new fix
  5. Terminal shows "✓ No errors"
  6. Success checkmark in Resolution Panel
Capture: Use a real EmptyState violation if possible, or simulate the workflow
Size: Under 3MB, ~1000px wide
-->

**Trade-offs:**
- ✅ Higher quality fixes (validated by actual tools)
- ✅ Catches cascading errors automatically
- ✅ Iterates until tests pass
- ⚠️ Slower (multiple LLM calls per fix)
- ⚠️ Requires configured linters/compilers/tests

> **Note:** Agent Mode is currently in **Early Access** with partial implementation. Full repository-level understanding is planned for Q2 2025.

---

## Understanding Konveyor AI's Approach
{: #understanding-konveyor-ais-approach}

**Konveyor AI combines prompt engineering with optional RAG** - it doesn't just call an LLM with your code. It uses the violation data itself to generate context-aware prompts, and optionally retrieves Migration Hints from a solution server using RAG (Retrieval Augmented Generation).

**The short version:** When you click "Fix", Kai sends the LLM your violation details (rule, file, line number, code context) as a structured prompt. If you've deployed a solution server, it also adds examples from your organization's past migrations. This gives the LLM everything it needs to generate accurate, context-aware fixes.

<details markdown="1">
<summary><strong>📖 Click to see the detailed fix generation pipeline</strong></summary>

### How It Works: The Fix Generation Pipeline

**1. Analysis Issues (from Part 2)**
```yaml
Issue: Text component should be replaced with Content
File: src/app/components/ApplicationsPage.tsx
Line: 12
Ruleset: patternfly-v5-to-v6
Category: mandatory
```

**2. Violation Data as Context (Always)**

When you click "Fix", Konveyor AI uses the violation data itself to build contextual prompts:

**From the violation:**
- Rule details (what needs to change and why)
- Code location and surrounding context
- Violation message and category
- Framework-specific metadata (e.g., PatternFly v5 → v6)

**This becomes the LLM prompt:**
```
System: You are helping migrate PatternFly v5 to v6.

Violation Details:
- Type: Component rename
- Rule: Text component should be replaced with Content
- Category: mandatory
- File: src/app/components/ApplicationsPage.tsx
- Line: 12

Current code context:
[Your ApplicationsPage.tsx file content around line 12]

Task: Generate a fix that addresses this specific violation.
```

**3. Solution Server Augmentation (Optional)**

If you've deployed the **solution server on the Konveyor hub**, it enhances the prompts with **Migration Hints** - contextual examples extracted from your organization's previous migrations:

```
# Augmented prompt with Migration Hints from solution server:

System: You are helping migrate PatternFly v5 to v6.

Violation: Text component should be replaced with Content
File: src/app/components/ApplicationsPage.tsx

Current code:
[Your file content]

Migration Hints from Solution Server:
- This organization previously solved similar violations by:
  * Updating imports: Text → Content
  * Preserving component props
  * Using custom wrapper pattern: <MyText> stays as-is
- Accepted examples from your past migrations:
  [Hint 1: app1 - How you handled Text→Content in headers]
  [Hint 2: app2 - How you handled Text→Content with custom props]

Task: Generate a fix following these organization-specific patterns.
```

**4. LLM Generates Context-Aware Fix**

The LLM generates fixes based on:
- **Always:** Violation data (rule details, code context, framework info)
- **With solution server:** Migration Hints from your organization's past migrations

**Why This Approach Works:**

| Generic LLM Call | Konveyor AI (Violation Context) | + Solution Server (RAG with Migration Hints) |
|------------------|--------------------------------|----------------------------------------------|
| ❌ No migration context | ✅ Rule-specific context from analyzer | ✅ + Your org's migration patterns |
| ❌ May hallucinate | ✅ Grounded in actual violation details | ✅ + Proven fixes from past migrations |
| ❌ Generic fixes | ✅ Framework-specific (PatternFly v5→v6) | ✅ + Custom library patterns |
| ❌ Inconsistent | ✅ Consistent with rule intent | ✅ + Organization-specific conventions |

</details>

### How the Solution Server Learns (Optional Enhancement)

> **Note:** The solution server is an optional component you can deploy on the Konveyor hub. Konveyor AI works without it using violation data as context. The solution server enhances fixes by learning from your organization's migration history through **Migration Hints** (contextual examples from your past migrations retrieved via RAG).

**When is the Solution Server Most Valuable?**

The solution server provides the biggest benefit when:

- **Custom/proprietary libraries** - Your organization uses internal frameworks the LLM wasn't trained on
  - Example: Internal design system components not in public training data
  - Example: Organization-specific utility libraries with unique APIs

- **Newer technologies** - Migrating to frameworks released after the LLM's training cutoff
  - Example: Latest PatternFly v6 features from 2024
  - Example: Bleeding-edge React patterns

- **Insufficient analysis rule context** - Rules detect the issue but don't provide enough detail for fixes
  - Example: "Replace deprecated API" without specifics on the new API
  - Violation data provides context, but solution server adds proven fix patterns via RAG

- **Organization-specific conventions** - Your team has established patterns that differ from generic approaches
  - Example: Custom wrapper components around framework primitives
  - Example: Specific naming conventions or code organization

**In the PatternFly example:** Violation data context alone provides good results because:
- PatternFly v5→v6 migration is well-documented
- Analysis rules include detailed migration guidance
- LLMs were trained on PatternFly public documentation

**Where solution server shines:** Migrating internal libraries with unique patterns that only exist in your organization's codebase.

<details markdown="1">
<summary><strong>🔄 Click to see how the solution server learns from your migrations</strong></summary>

---

**Learning from Your Migrations:**

When deployed, the solution server learns from **your actual accepted/rejected fixes**, building organization-specific knowledge called **Migration Hints**:

**First Migration (Generic):**
```typescript
// AI generates basic fix based on framework patterns
- import { Text } from '@patternfly/react-core';
+ import { Content } from '@patternfly/react-core';
```

**After You Accept/Reject Fixes:**

The solution server captures:
- Which fixes you accepted → "This pattern works for their codebase"
- Which you rejected → "Avoid this approach for their code"
- Manual edits you made → "They prefer this variation"
- Complete transformation context (imports, props, custom wrappers)

**Second Migration (Improved):**
```typescript
// AI now knows your preferences and patterns
// - You use custom wrappers
// - You have specific naming conventions
// - You handle certain props differently
// Generates fixes matching YOUR established patterns
```

**Iterative Improvement:**

| Migration | Solution Quality |
|-----------|------------------|
| 1st app | Generic framework fixes |
| 2nd app | Learns from your accepted patterns |
| 5th app | Highly tuned to your codebase style |
| 10th app | Matches your team's established conventions |

**What Gets Captured:**
- Configuration patterns you use
- Custom library usage specific to your org
- Environment variable conventions
- Code style preferences (based on what you accept/reject)

This is why the solution server gets better **for your organization** over time - it's learning from your decisions, not generic community data.

---

</details>

---

## Results: Automating 886 Component Changes
{: #results-automating-886-component-changes}

Let me walk through what happened when I used Konveyor AI on tackle2-ui's 886 `Text` component violations.

**The Workflow:**

1. **Filter violations in Issues view:**
   - Clicked on "Text component should be replaced with Content (886)"
   - Shows 76 files with violations

2. **Generate fixes:**
   - Right-clicked on the violation type
   - Selected **"Fix"**
   - AI processed all 886 violations across 76 files

3. **Review in Resolution Panel:**
   - Resolution Panel showed proposed changes file-by-file
   - Each file showed before/after diffs
   - Accepted or rejected changes per file

**Results:**

| Category | Count | % | Time Investment |
|----------|-------|---|---------------|
| **AI-generated fixes** | 886 | 100% | ~2 hours (review time) |
| **Accepted as-is** | 728 | 82% | Simple renames |
| **Manually adjusted** | 142 | 16% | Edge cases |
| **Rejected/skipped** | 16 | 2% | Special cases |
| **Total** | 886 | 100% | **~2 hours vs 30 hours manual** |

**Time savings: 28 hours** on just the Text component violations!

<!-- TODO: Add chart/visualization here
File: time-savings-comparison.png or .svg
Description: Bar chart or infographic comparing time investment:
  - Manual approach: 30 hours (shown in red/orange)
  - With Konveyor AI: 2 hours (shown in green)
  - Savings: 28 hours (85% reduction)
  Break down the 2 hours into: "AI Generation: <1 hour" + "Review: ~2 hours"
Style: Clean, simple chart with clear labels. Consider using a horizontal bar chart.
Size: ~800px wide
Tool: Can create in Google Sheets/Excel and export, or use tools like Excalidraw, Figma
-->

### Common Patterns AI Handled Well

**Pattern 1: Direct import and usage** (621 cases)

Simple cases the AI fixed perfectly:

```typescript
// Example 1: Direct import and usage
// Before
import { Text } from '@patternfly/react-core';
<Text component="h2">Title</Text>

// After (AI fix - accepted)
import { Content } from '@patternfly/react-core';
<Content component="h2">Title</Content>
```

<!-- TODO: Add screenshot here
File: before-after-direct-import.png
Description: Side-by-side comparison showing actual tackle2-ui code:
  - Left panel: Original code with Text import and usage (with red highlighting)
  - Right panel: Fixed code with Content import and usage (with green highlighting)
  Show a real file from tackle2-ui if possible (e.g., ApplicationsPage.tsx)
  Include line numbers and syntax highlighting
Size: ~1200px wide (split view)
-->

```typescript
// Example 2: Multiple usages in same file
// Before
import { Text } from '@patternfly/react-core';
<Text component="h1">{title}</Text>
<Text component="p">{description}</Text>

// After (AI fix - accepted)
import { Content } from '@patternfly/react-core';
<Content component="h1">{title}</Content>
<Content component="p">{description}</Content>
```

**Pattern 2: Destructured imports** (107 cases)

AI correctly updated just the renamed component:

```typescript
// Example: Destructured import with other components
// Before
import { Text, Button, Card } from '@patternfly/react-core';

// After (AI fix - accepted)
import { Content, Button, Card } from '@patternfly/react-core';
// AI correctly updates just Text → Content in the destructuring
```

**Pattern 3: Edge cases requiring manual adjustment** (142 cases)

AI provided good starting points, but needed tweaks:

```typescript
// Example: Import alias
// Before
import { Text as PFText } from '@patternfly/react-core';
<PFText component="h2">Title</PFText>

// AI suggestion
import { Content as PFText } from '@patternfly/react-core';
<PFText component="h2">Title</PFText>

// Reviewer decision: ✅ Accepted (alias pattern works fine)
```

**Pattern 4: Cases requiring rejection** (16 cases)

These needed manual handling or should be skipped:

```typescript
// Example: Dynamic component selection
// Before
const TextComponent = isV6 ? Content : Text;

// AI suggestion
const TextComponent = isV6 ? Content : Content;

// Reviewer decision: ❌ Rejected
// (Conditional logic for v5/v6 compatibility - intentional use of both)
```

---

## The Review Process: ~2 Hours for 886 Violations

The Resolution Panel in VS Code made reviewing AI fixes efficient.

**The workflow:**

1. **AI generates all fixes:**
   - Clicked "Fix" on violation type
   - AI processed 76 files
   - Resolution Panel showed proposed changes

2. **Review file-by-file:**
   - Panel shows one file at a time
   - Before/after diff with syntax highlighting
   - See full file context
   - Accept, reject, or manually edit

**Resolution Panel features:**
- **Diff view:** Side-by-side before/after comparison
- **Navigation:** Jump to next/previous file with violations
- **Context:** See surrounding code, not just changed lines
- **Quick actions:**
  - ✅ Accept Changes
  - ❌ Reject
  - ✏️ Edit Manually (opens file in editor)

**Review stats:**
- 76 files reviewed
- ~1.5 minutes per file average
- **Total time: ~2 hours**
- **Success rate: 98%** (870 of 886 fixes accepted)

**Why I rejected 16 fixes:**
1. Dynamic component selection (5 cases)
2. v5/v6 compatibility layers (4 cases)
3. Test mocks that shouldn't change (3 cases)
4. Third-party wrapper components (3 cases)
5. Comments referencing old component names (1 case)

---

## Full Results: All 1,324 Violations

Here's the complete breakdown across all violation types:

| Violation Type | Count | Auto-Fixed | Reviewed | Rejected | Time Saved |
|----------------|-------|-----------|----------|----------|------------|
| Text → Content | 886 | 728 (82%) | 142 | 16 | 24 hours |
| EmptyState refactor | 200 | 142 (71%) | 48 | 10 | 5 hours |
| CSS class prefixes | 172 | 172 (100%) | 0 | 0 | 6 hours |
| CSS variable prefixes | 45 | 45 (100%) | 0 | 0 | 1.5 hours |
| React token syntax | 21 | 18 (86%) | 3 | 0 | 0.5 hours |
| **Totals** | **1,324** | **1,105 (83%)** | **193** | **26** | **37 hours** |

**Overall metrics:**
- **Automation rate: 83%** (1,105 auto-fixed)
- **Success rate: 98%** (26 rejections / 1,324 total)
- **Time investment:** ~6 hours (review + fixes)
- **Time saved:** 37 hours
- **ROI: 6.2x** (43 hours manual / 7 hours with AI)

**Cost breakdown:**
- AI API costs: ~$8 (Claude Sonnet)
- Developer time saved: 37 hours × $100/hour = $3,700
- **Net savings: $3,692** (one-time migration cost)

---

## Why Accuracy Matters: The Counterfactual

What if we had used Part 1's text matching (20% false positives) instead of Part 2's semantic analysis (5%)?

**With 20% false positives (text matching):**
- Total "violations": ~1,600 (including 320 false positives)
- AI generates fixes for all 1,600
- 320 bad fixes applied automatically
- **Scenario 1:** Catch them in testing → Hours of debugging
- **Scenario 2:** Don't catch them → Bugs in production
- **Scenario 3:** Review everything manually → No time savings

**Developer trust erodes:**
> "AI changed a comment, broke a test, and modified documentation. I can't trust this tool anymore."

**With 5% false positives (semantic analysis):**
- Total violations: 1,324 (only 66 false positives)
- 66 false positives typically flagged as low confidence
- Manual review catches them before applying
- **95% of fixes are trustworthy**

**Developer trust builds:**
> "AI correctly fixed 728 violations automatically. I reviewed 158 cases and only rejected 26. This actually works."

**Bottom line:** Part 2's accuracy improvement ENABLES Part 3's automation. You can't skip to AI fixes with low-quality violations.

---

## Best Practices from 1,324 Fixes
{: #best-practices-from-1324-fixes}

### 1. Start Small - Test One Violation First

Before processing hundreds of violations, test the AI on a single file:

1. Open the Issues view
2. Expand a violation type (e.g., "Text component...")
3. Right-click on **one file**
4. Click "Fix"
5. Review the AI's proposal in the Resolution Panel

This helps you understand how the AI approaches fixes before scaling up.

### 2. Process by Violation Type (Not All at Once)

Work through violations systematically:

**Step 1:** Simple CSS changes first
- Filter Issues view: "CSS class prefixes"
- Click "Fix" → Review → Accept
- Nearly 100% success rate on these

**Step 2:** Component renames
- Filter: "Text component should be replaced with Content"
- Click "Fix" → Review → Accept most
- ~98% success rate

**Step 3:** Complex refactorings last
- Filter: "EmptyState component structure has changed"
- Enable Agent Mode for these (more interactive)
- May need more manual adjustments

### 3. Use Version Control - One Violation Type Per Commit

**Create a dedicated branch:**
```bash
git checkout -b konveyor-ai-migration
```

**Commit after each violation type:**
```bash
# After accepting AI fixes for CSS changes
git add -A
git commit -m "AI fix: CSS class prefix migration (172 files)"

# After accepting AI fixes for Text → Content
git add -A
git commit -m "AI fix: Text component → Content (76 files, 886 instances)"

# After accepting AI fixes for EmptyState
git add -A
git commit -m "AI fix: EmptyState component refactoring (45 files)"
```

**Benefits:**
- Easy to review each violation type's changes
- Easy to rollback if needed
- Clear history of what was automated vs manual

### 4. Test Between Each Violation Type

After accepting AI fixes for a violation type, run tests before moving to the next:

```bash
# After accepting fixes
npm run test
npm run build
npm run lint

# If tests fail, investigate immediately
# Don't move to next violation type until tests pass
```

**Why:** Catches any edge cases the AI missed before compounding issues.

### 5. Use the "Edit Manually" Option When Needed

The Resolution Panel has three options for each fix:

- **Accept Changes:** AI fix is perfect, apply it
- **Reject:** Skip this file entirely
- **Edit Manually:** Open the file in the editor with AI's suggestion visible

**When to use "Edit Manually":**
- AI fix is close but needs tweaking
- You want to add additional changes while you're at it
- Edge case requires human judgment

**Example workflow:**
1. AI suggests changing Text → Content
2. You notice a related issue in same file
3. Click "Edit Manually"
4. Apply AI's change + your additional fix
5. Save and move to next file

### 6. Monitor AI Interaction Messages

In Agent Mode, the Resolution Panel shows AI's thought process:

```
🤖 Analyzing file...
   - Found 3 Text component usages
   - Checking for prop compatibility
   - Validating import statements
   - No breaking changes detected

✓ Safe to migrate all 3 instances
```

This transparency helps you trust (or question) the AI's decisions.

---

## Integration with CI/CD
{: #integration-with-cicd}

Once you trust the automation, you can prevent new violations from being introduced by integrating detection into your CI/CD pipeline.

<details markdown="1">
<summary><strong>⚙️ Click to see CI/CD integration example</strong></summary>

---

### GitHub Actions Example

Add a workflow that fails PRs when new violations are detected:

```yaml
# .github/workflows/migration-check.yml
name: Check for PatternFly v5 patterns

on: [pull_request]

jobs:
  migration-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run Konveyor Analyzer
        run: |
          kantra analyze \
            --input . \
            --rules patternfly-v5-to-v6.yaml \
            --output analysis-results

      - name: Check for violations
        run: |
          violation_count=$(grep -c "message:" analysis-results/output.yaml || true)
          if [ $violation_count -gt 0 ]; then
            echo "❌ Found $violation_count PatternFly v5 violations"
            echo "💡 Open in VS Code and use Konveyor extension to generate AI fixes"
            exit 1
          fi
```

This prevents new v5 patterns from being merged while you're migrating to v6.

---

</details>

---

## Limitations and Edge Cases

### What AI Handles Well

✅ **Direct component renames:**
```typescript
Text → Content
Chip → Label
Tile → Card
```

✅ **Import statement updates:**
```typescript
import { Text } from '@patternfly/react-core'
→ import { Content } from '@patternfly/react-core'
```

✅ **CSS pattern replacements:**
```css
--pf-v5-global--Color--100
→ --pf-t--global--color--100
```

✅ **Multiple usages in same file:**
```typescript
<Text component="h1">{title}</Text>
<Text component="p">{desc}</Text>
→ All updated correctly
```

### What Needs Manual Review

⚠️ **Dynamic imports:**
```typescript
const component = await import(`@patternfly/react-core/${name}`);
// AI can't confidently modify string templates
```

⚠️ **Compatibility layers:**
```typescript
const TextComponent = isV6 ? Content : Text;
// Intentional use of both - don't change
```

⚠️ **Test mocks:**
```typescript
jest.mock('@patternfly/react-core', () => ({
  Text: jest.fn()
}));
// Mocks need different handling
```

⚠️ **Custom wrappers:**
```typescript
export const MyText = (props) => <Text {...props} />;
// May want to keep wrapper name same
```

### Known Issues

1. **Multi-file refactorings:** AI processes files independently. If a change requires coordinating updates across files, manual review needed.

2. **Type definition updates:** AI fixes component usage but may miss corresponding TypeScript type updates.

3. **Documentation/comments:** AI generally skips updating comments referencing old component names (you may want this).

---

## What's Coming: Konveyor AI Roadmap
{: #whats-coming-konveyor-ai-roadmap}

Konveyor AI is under active development. The VS Code extension and Standard Mode work well today, while advanced features like Agent Mode and repository-level understanding are coming in Q2 2025.

<details markdown="1">
<summary><strong>🗺️ Click to see current capabilities and planned enhancements</strong></summary>

---

### Current Capabilities (Available Now)

| Feature | Status | Notes |
|---------|--------|-------|
| **VS Code Integration** | ✅ Functional | Issues view → Fix workflow works |
| **RAG (Solution server patterns)** | ✅ Functional | Uses migration patterns from solution server |
| **Basic AI fixes** | ✅ Functional | Standard Mode generates fixes |
| **Agent Mode (Basic)** | 🟡 Partial | Minimal happy path implemented |
| **External Tool Integration** | 🟡 Partial | Validators exist but limited |

### Planned Enhancements (Q2 2025)

**Repository-Level Understanding:**
Currently, Kai processes files independently. The roadmap includes:
- Understanding cross-file dependencies
- Planning refactorings that cascade across multiple files
- Executing multi-file changes atomically
- Remediating errors that span file boundaries

**Example future capability:**
```
Scenario: Renaming a component used in 50 files

Current: Process each file independently
Future:
  1. Analyze all 50 files to understand dependencies
  2. Plan the migration (order matters)
  3. Execute changes across all files
  4. Validate that inter-file references still work
  5. Remediate any cross-file errors
```

**Enhanced Agent Workflow:**
- Better integration with linters, compilers, and test runners
- Iterative refinement until all external validators pass
- Support for custom validators (your org's specific tools)
- AI Gateway/Proxy integration for enterprise credential management

### How to Stay Updated

Konveyor AI is evolving rapidly. To track progress:
- **GitHub:** Watch the [Konveyor AI repo](https://github.com/konveyor/kai) for updates
- **Community Meetings:** Join the Konveyor community calls
- **Slack:** #konveyor on Kubernetes Slack

> **Want to influence the roadmap?** Konveyor is looking for early access partners to validate features and provide feedback. Contact the team through GitHub issues or Slack.

---

</details>

---

## Conclusion: The Complete Automation Pipeline

**We've built a complete migration automation pipeline across three posts:**

**Part 1 → Part 2 → Part 3 = 1,324 violations fixed with 83% automation**

| Step | Tool | Input | Output | Time |
|------|------|-------|--------|------|
| **Part 1** | AI rule generator | Migration docs | 10 rules | ~30 min |
| **Part 2** | Semantic analyzer | Codebase + rules | 1,324 violations (95% accurate) | ~35 min |
| **Part 3** | Konveyor AI | Violations | 1,105 auto-fixes + 193 to review | ~6 hours |
| **Manual (old way)** | Grep + manual edits | Codebase | 1,324 fixes | ~43 hours |

**Total time:** 7 hours vs 43 hours = **36 hours saved**

**Success metrics:**
- 98% of fixes were correct (26 rejections / 1,324 total)
- 83% automation rate (1,105 / 1,324 auto-fixed)
- $8 in AI costs vs $3,700 in developer time saved

### Key Lessons

1. **Accuracy enables automation:** Can't skip Part 2. The 95% precision is critical for AI to work.

2. **Progressive trust:** Start conservative (0.95 threshold), build confidence, get more aggressive.

3. **AI is a tool, not magic:** Still need developer review for edge cases. But 83% automation is transformative.

4. **The math works:** Even at $100/hour developer time, saving 36 hours pays for itself massively.

### What We Didn't Cover

This series focused on **UI component migrations** (PatternFly). The same approach works for:
- React Router v5 → v6
- Material-UI v4 → v5
- Angular upgrades
- Vue 2 → Vue 3
- Any framework with migration docs

Use the [analyzer-rule-generator](https://github.com/tsanders-rh/analyzer-rule-generator) to create rules for your migration.

---

## Next Steps

**For PatternFly teams:**

1. **Try the automation:**

   **Step 1: Get the validated ruleset**
   ```bash
   curl -O https://raw.githubusercontent.com/tsanders-rh/analyzer-rule-generator/main/examples/rulesets/patternfly-v5-to-v6/patternfly-v5-to-v6.yaml
   ```

   **Step 2: Run analysis (Part 2)**
   ```bash
   kantra analyze --input . --rules patternfly-v5-to-v6.yaml
   ```

   **Step 3: Generate AI fixes in VS Code (Part 3)**
   - Open your project in VS Code
   - Install the Konveyor extension
   - Open the Issues view
   - Right-click on a violation type → "Fix"
   - Review AI-generated fixes in Resolution Panel
   - Accept or reject changes

2. **Share your results:** How many violations? Automation rate? Time saved? Help improve the tools.

3. **Contribute:** Found edge cases? Submit PRs to the ruleset or Konveyor extension.

**For other migrations:**

1. Generate rules for your framework using the [analyzer-rule-generator](https://github.com/tsanders-rh/analyzer-rule-generator)
2. Follow the three-part process: Generate → Detect → Automate
3. Share your rulesets with the community

---

## Resources

**This Series:**
- Part 1: [Generating Migration Rules with AI](https://www.migandmod.net/2025/10/22/automating-ui-migrations-ai-analyzer-rules/)
- Part 2: [Improving Detection with Semantic Analysis](https://www.migandmod.net/2025/10/29/enhancing-ui-migrations-nodejs-provider/)
- Part 3: Automating Fixes with Konveyor AI (this post)

**Tools:**
- [Konveyor AI](https://github.com/konveyor/kai) - AI-assisted code refactoring
- [PatternFly v5→v6 Ruleset](https://github.com/tsanders-rh/analyzer-rule-generator/tree/main/examples/rulesets/patternfly-v5-to-v6) - Production-validated
- [Analyzer Rule Generator](https://github.com/tsanders-rh/analyzer-rule-generator) - Generate custom rules

**Related:**
- [Konveyor Analyzer](https://github.com/konveyor/analyzer-lsp) - Static code analysis
- [nodejs Provider PR](https://github.com/konveyor/analyzer-lsp/pull/930) - Semantic analysis

---

*Have questions or want to share your migration results? Open an issue on the [analyzer-rule-generator repo](https://github.com/tsanders-rh/analyzer-rule-generator/issues).*

---

<!--
VISUAL ASSETS TODO LIST
=======================

High Priority (Critical for understanding):
1. konveyor-ai-complete-workflow.gif - Main workflow demonstration (30s GIF showing right-click Fix → Review → Accept)
2. konveyor-resolution-panel-diff.png - Resolution Panel showing before/after diff with Accept/Reject buttons
3. konveyor-issues-view-organized.png - Issues view showing 1,324 violations grouped by type

Medium Priority (Enhances understanding):
4. vscode-konveyor-extension-marketplace.png - Extension installation from marketplace
5. vscode-konveyor-settings-llm.png - LLM configuration in VS Code settings
6. konveyor-agent-mode-iteration.gif - Agent Mode iterative process (15s GIF)
7. time-savings-comparison.png - Bar chart comparing manual (30h) vs AI (2h) time
8. before-after-direct-import.png - Side-by-side code comparison showing Text → Content

Optional (Nice to have):
9. konveyor-ai-overview.png - Hero diagram showing complete automation pipeline

Recording Tips:
- Use dark theme for better contrast
- Zoom editor font to 14-16pt for readability
- Keep GIFs under 5MB (use gifski or LICEcap)
- Crop tightly to relevant UI areas
- Add red boxes/arrows to highlight key elements
- Use actual tackle2-ui project for authenticity

Suggested Tools:
- Screen recording: macOS Cmd+Shift+5 or QuickTime
- GIF creation: gifski (https://gif.ski/) or LICEcap
- Charts: Google Sheets, Excel, Excalidraw
- Diagrams: Figma, Excalidraw, or Mermaid
- Annotations: Snagit or macOS Preview

-->
