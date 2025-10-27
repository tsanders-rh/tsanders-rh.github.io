---
layout: single
title: "Why Your AI Coding Assistant Isn't Enough for Application Modernization (And What Is)"
date: 2025-10-27
categories: [migration, ai, konveyor, modernization]
tags: [migration, ai, konveyor, static-analysis, modernization, developer-tools, application-modernization]
excerpt: "Konveyor provides production-validated rulesets for common modernization patterns (Java EE→Quarkus, Spring Boot upgrades, framework migrations) plus AI-powered rule generation. Combined with semantic static analysis (95%+ accuracy), it complements your existing AI coding assistant."
header:
  overlay_color: "#333"
  overlay_filter: "0.5"
author_profile: true
classes: wide
---

## The Migration Problem Every Developer Faces

You just got the task: **"Migrate our app to Spring Boot 3."**

Your first thought: *Where do I even start?*

You open the [migration guide](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Migration-Guide). It's 47 pages. You ctrl+F through your codebase for `javax.persistence` and find 847 matches:

- Some are actual imports that need changing
- Some are in comments
- Some are in string literals
- Some are in test fixtures
- Some are in documentation

**Which ones are real violations?** You have to manually review all 847.

You try your AI assistant:

**With GitHub Copilot:**
*"Help me migrate to Spring Boot 3."*

You get helpful autocomplete suggestions as you work file-by-file. But Copilot works primarily in the current file - it can't systematically scan your entire codebase to find all violations or distinguish real code references from comments.

**With Claude Code or Cursor:**
*"Find all javax.persistence imports and suggest fixes."*

Much better! Claude Code understands your entire codebase and can work across multiple files. It reads your code, finds patterns, and suggests changes.

But even Claude Code faces challenges:
- **Text-based search** - It finds `javax.persistence` in comments, strings, and docs (15-20% false positives)
- **No semantic analysis** - It can't distinguish between actual symbol references and text that happens to match
- **Generic knowledge** - Training data from 6-12 months ago, no framework-specific migration patterns
- **Inconsistent** - Different prompts can produce different results

**This is the gap that Konveyor fills - even for advanced AI assistants like Claude Code.**

Plus, for common modernization scenarios, **you don't need to generate rules at all** - Konveyor provides production-validated rulesets that are ready to use immediately.

## Try It: 5-Minute Demo

Before we dive deeper, **let me show you the concrete difference** between approaches.

**Scenario:** Find all uses of PatternFly's deprecated `Text` component in a 66K line codebase.

### Approach 1: Advanced AI Assistant (Claude Code)

```
You: "Find all imports and usages of the Text component from @patternfly/react-core"

Claude Code:
- Searches through files using text patterns
- Finds ~200 matches
- Includes: actual imports, comments mentioning "Text",
  string literals, docs, unrelated variables
- You manually review each match to filter false positives
- Time: 2-4 hours
- Accuracy: ~80% (15-20% false positives)
```

**Claude Code is excellent** at understanding context and working across files - but it's still doing text-based search, not semantic analysis.

### Approach 2: Konveyor (Semantic Analysis)

```bash
# Run semantic analysis
kantra analyze \
  --input /path/to/your-app \
  --rules patternfly-v5-to-v6.yaml \
  --output ./analysis-results
```

**Results:**
- 1,324 violations with 95%+ accuracy
- Time: **8 seconds**
- Only actual symbol references (comments/strings automatically ignored)
- False positive rate: ~5%

**What you get:**
- Exact file locations with line numbers
- Only genuine code references (semantic, not text matching)
- Before/after examples from migration guides
- Effort estimates for each violation
- Links to relevant documentation

**The key difference:** Konveyor analyzes code semantically (understanding the actual symbol references) rather than just searching for text patterns, similar to how your IDE understands code for autocomplete. It knows the difference between:
- `import { Text }` ← **Real violation**
- `// Update Text component` ← **Just a comment**
- `const myText = 'hello'` ← **Different symbol**

**The math on false positives:**
- Text matching: 320 false positives × 2 min review = **10.6 hours wasted**
- Semantic analysis: 66 false positives × 2 min = **2.2 hours**
- **Time saved: 8.4 hours** per migration

---

## Production-Validated Ruleset Repository

**Here's the best part:** For common modernization scenarios, you don't need to generate rules at all.

**Konveyor maintains a repository of production-validated, hardened rulesets:**

| Modernization Scenario | Status | Rulesets Available | Repository |
|-------------------|--------|-------------------|------------|
| **Java EE → Quarkus** | ✅ Production-ready | 36+ rule files | [konveyor/rulesets](https://github.com/konveyor/rulesets/tree/main/default/generated/quarkus) |
| **Spring Boot 2 → 3** | ✅ Production-ready | 9+ rule files | [konveyor/rulesets](https://github.com/konveyor/rulesets/tree/main/default/generated/spring-boot) |
| **Java 8/11/17/21** | ✅ Production-ready | Multiple rulesets | [konveyor/rulesets](https://github.com/konveyor/rulesets/tree/main/default/generated) |
| **EAP 6/7/8** | ✅ Production-ready | Multiple rulesets | [konveyor/rulesets](https://github.com/konveyor/rulesets/tree/main/default/generated) |
| **Camel 3/4, Hibernate** | ✅ Production-ready | Multiple rulesets | [konveyor/rulesets](https://github.com/konveyor/rulesets/tree/main/default/generated) |
| **Custom migrations** | ✅ AI-generated | Generate from any guide (2 min) | [Rule generator](https://github.com/tsanders-rh/analyzer-rule-generator) |

**What "hardened" means:**
- ✅ Tested on real production codebases
- ✅ False positive rate verified (95%+ accuracy)
- ✅ Community-reviewed and improved over time
- ✅ Continuously updated as frameworks evolve
- ✅ Include effort estimates and remediation guidance

**Time to value:**
- **Generate your own rules:** 2 minutes (AI extraction from docs)
- **Use validated rulesets:** 0 minutes (download and run)
- **Manual rule creation:** Days to weeks

**This is a huge differentiator.** Other static analysis tools require you to write rules manually or figure out migration patterns yourself. Konveyor gives you battle-tested rules immediately.

[Browse all rulesets →](https://github.com/konveyor/rulesets)

---

## Why Application Modernization Is Different

Your AI coding assistant is excellent at daily development tasks. But application modernization presents unique challenges:

### 1. Scale: Thousands of Systematic Changes

**Real example:** PatternFly 5→6 migration of Konveyor Tackle2-UI:
- 2,540 violations across 125 files
- 886 instances of one component rename (`Text` → `Content`)
- Found and categorized in 8 seconds
- What would have taken weeks of grep → manual review → fix → repeat

**Without Konveyor:** ~100 fixes/day with high error rate
**With Konveyor:** ~800 fixes/day with low error rate

### 2. Precision: Not Every Match Is a Real Violation

Text-based search finds patterns but doesn't understand code semantically.

**Example:** Searching for `Text` component usage:
- ✅ `import { Text } from '@patternfly/react-core'` (actual violation)
- ✅ `<Text component="h2">` (actual violation)
- ❌ `// TODO: Update Text later` (false positive - comment)
- ❌ `const myText = 'something'` (false positive - different variable)
- ❌ `"Check Text component docs"` (false positive - string)

**Why this matters:** If you feed false positives to an AI assistant, you get:
- Wasted AI tokens on incorrect suggestions
- Incorrect refactorings that introduce bugs
- Erosion of developer trust in AI assistance

### 3. Framework-Specific Knowledge That's Always Current

**Konveyor's solution server** has curated, current migration patterns:
- Updated continuously as frameworks evolve
- Community-maintained by people doing migrations daily
- Same pattern always gets same guidance (repeatable)
- You can add your organization's internal patterns

**Think of it like:**
- **AI assistant training data** = Stack Overflow (amazing breadth, sometimes outdated)
- **Konveyor solution server** = The official migration guide (specialized, current, curated)

---

## What Makes Each AI Assistant Different

### GitHub Copilot

**What it's great at:**
- Inline code completion
- Suggesting implementations as you type
- Writing boilerplate

**Migration limitations:**
- Works primarily in the current file
- Can't systematically scan entire codebase
- No semantic code understanding

**Verdict:** Great for day-to-day coding, not designed for systematic migrations.

### Claude Code & Cursor (Advanced Agentic Assistants)

**What they're great at:**
- Understanding entire codebases
- Working across multiple files
- Reading and analyzing code structure
- Generating complex refactors

**Migration limitations even for these advanced tools:**

**1. Text-based search, not semantic analysis**

Claude Code can search for `Text` across your codebase, but it uses text patterns (like grep with AI). It can't distinguish:
- `import { Text }` ← actual violation
- `// TODO: Update Text` ← just a comment
- `const myText = 'foo'` ← different symbol

Result: **15-20% false positives** that you manually review.

**2. No framework-specific migration knowledge base**

Claude Code's training data:
- Has a cutoff date (6-12 months old)
- Doesn't include latest framework migration guides
- No access to community-curated migration patterns
- Different prompts = different answers (inconsistent)

**3. Can't leverage language servers for semantic analysis**

Your IDE uses TypeScript/Java language servers for accurate autocomplete and error detection. Claude Code doesn't integrate with these - it analyzes code as text, not as semantically-understood symbols.

### Think of It This Way

- **GitHub Copilot** = Smart autocomplete (excellent for day-to-day coding)
- **Claude Code/Cursor** = Agentic coding assistant (excellent for complex refactoring)
- **Konveyor** = Migration infrastructure (semantic analysis + curated knowledge)

**The power move:** Use them together:
- **Today:** Use KAI extension for deep integration with Konveyor analysis
- **Coming soon:** MCP integration to use Konveyor directly in Claude Code
- Konveyor provides 95% accurate semantic analysis
- Konveyor's solution server provides current, curated patterns
- Your AI assistant uses both to generate better suggestions

You're not choosing between them - you're using them together.

---

## How Konveyor Works: The Foundation

<div class="mermaid">
flowchart LR
    A[Migration Guide] --> B[LLM Extraction]
    B --> C[Analyzer Rules]
    C --> D[Static Analysis]
    D --> E[Violations Found]
    E --> F[AI Suggestions]
    F --> G{Review}
    G -->|Accept/Modify| H[Fixed Code]
    G -->|Reject| I[Manual Fix]
    I --> H

    style A fill:#4a9eff,stroke:#333,stroke-width:2px,color:#fff
    style C fill:#ffb84d,stroke:#333,stroke-width:2px,color:#000
    style E fill:#ff6b6b,stroke:#333,stroke-width:2px,color:#fff
    style F fill:#51cf66,stroke:#333,stroke-width:2px,color:#000
    style H fill:#9775fa,stroke:#333,stroke-width:2px,color:#fff
</div>

*Complete workflow: AI extracts patterns from docs, generates detection rules, static analysis finds violations, AI suggests fixes, developers review and apply.*

Konveyor provides migration infrastructure in three layers:

**Layer 1: Static Analysis (The Foundation)**
- Semantic code analysis (understands actual symbol references, not just text patterns)
- 95%+ accuracy vs. 80% with text search
- **This is the core differentiator** - why Konveyor isn't just another AI assistant

**Layer 2: Solution Server (Curated Knowledge + Ruleset Repository)**
- **Production-validated rulesets** for common frameworks (ready to use immediately)
- Community-maintained migration patterns (continuously updated)
- AI-generated rules stored and shared across the community
- Always current (not stale training data)

**Layer 3: Integration (Your Choice)**
- **KAI IDE Extension** - Deep integration, recommended (available now)
- **MCP** - Use with Claude Code, Cursor, etc. (coming soon)
- **Standalone** - HTML reports, maximum flexibility (available now)

### Why This Hybrid Approach Matters

**Different tools excel at different tasks:**

| Task | Best Tool | Why |
|------|-----------|-----|
| Extract patterns from docs | **AI (LLM)** | Understands unstructured text, identifies patterns |
| Detect violations in code | **Static Analysis** | Semantic understanding, 95%+ accuracy |
| Generate fix suggestions | **AI** | Context-aware code generation |
| Make final decisions | **Developer** | Domain knowledge, business logic |

**This isn't "AI vs. Static Analysis"** - it's using both where each is strongest.

**More importantly, this approach de-risks generative AI:**

When AI does both detection and fixes, you get:
- ❌ Hallucinated violations (AI "finds" issues that don't exist)
- ❌ Inconsistent results (different runs find different things)
- ❌ False confidence (AI sounds certain about wrong answers)
- ❌ Wasted tokens processing false positives

**Konveyor's static-first approach mitigates these risks:**
- ✅ **Deterministic detection** - Same code = same violations, every time
- ✅ **Verifiable violations** - Exact line numbers, semantic proof
- ✅ **AI only suggests fixes** - Violations are verified before AI touches them
- ✅ **Reduced hallucination** - AI works from precise locations, not vague descriptions
- ✅ **Cost efficient** - Only process real violations (95% accurate)

**Think of it as "trust but verify" - except the static analysis does the verifying before AI gets involved.**

---

## How to Use Konveyor

### Option 1: KAI IDE Extension (Recommended)

**Why this is the best integrated experience:**

With KAI, you run analysis directly from your IDE - no separate command-line steps needed.

```
1. Install KAI extension in your IDE (VS Code, IntelliJ, etc.)
2. Configure your ruleset (e.g., spring-boot-2-to-3.yaml)
3. Run analysis from within the IDE
4. Violations appear inline as you code
```

**What KAI provides:**
- **Run analysis from IDE** - no need to run kantra separately
- **Inline violation display** - violations appear directly in your code
- **Solution server context** - right-click on violation → get curated fix patterns
- **Batch operations** - apply AI-suggested fixes across multiple files
- **Progress tracking** - see which violations are fixed, which remain

**KAI is purpose-built for migrations** by the Konveyor project. It's not trying to be your everyday coding assistant - it's specialized migration tooling. Use KAI when doing migrations, use your preferred AI assistant (Copilot, Claude Code, etc.) for general development.

### Option 2: Standalone Analysis

```bash
# Run analysis, review HTML report, fix manually or with your preferred tools
kantra analyze --input . --rules spring-boot-2-to-3.yaml
```

**The Foundation is the Same: Static Analysis**

Regardless of which approach you choose, **Konveyor's semantic analysis** is what gives you:
- 95%+ accuracy (vs. 80% with text search)
- Only real code references (comments/strings ignored)
- Framework-specific violation detection
- Effort estimates and progress tracking

### Option 3: MCP Integration (Coming Soon)

We're building MCP integration so teams standardized on specific AI assistants can use Konveyor directly in Claude Code, Cursor, etc.

**Status:** Currently in development, public beta planned. [Follow progress on GitHub →](https://github.com/konveyor)

---

## The Bottom Line

**Application modernization needs a different approach than general development.**

### The Core Problem

Even advanced AI assistants like Claude Code face migration-specific challenges when used for systematic migration detection:

| Challenge | AI Assistants (Even Claude Code) | Konveyor |
|-----------|--------------|----------|
| **Detection method** | Text-based search | Semantic code analysis |
| **Accuracy (migration detection)** | ~80% | 95%+ |
| **False positives** | 15-20% | ~5% |
| **Migration rulesets** | None (start from scratch) | Production-validated for common frameworks |
| **Migration knowledge** | Training data (6-12 months old) | Curated, current patterns (solution server) |
| **Consistency** | Varies by prompt | Same pattern = same answer |
| **Language server integration** | No | Yes (TypeScript, Java, etc.) |
| **Progress tracking** | Manual | Built-in with effort estimates |

### The Positioning: Complementary Infrastructure

**Konveyor is not trying to replace GitHub Copilot, Claude Code, or any other AI assistant.**

We provide migration infrastructure:
- **Production-validated ruleset repository** - Hardened rules for common frameworks (instant value)
- **Static analysis** for accurate detection (95%+ precision)
- **Solution server** for curated patterns (always current)
- **KAI extension** for integrated workflow (deep integration, available now)
- **MCP integration** for flexibility with your existing tools (coming soon)

**Your workflow:**
- **Daily development** → Use GitHub Copilot, Claude Code, etc. (they're excellent)
- **Application modernization** → Add Konveyor's static analysis (via KAI extension or standalone)
- **Back to development** → Continue with your preferred AI assistant

**Try Konveyor on your next migration.** For migration violation detection, semantic analysis (95%+ accuracy) vs. text-based search (~80%) means hours saved on false positive review - and better AI suggestions because the input is more precise.

---

## Try It Yourself (5 Minutes)

**Two paths:** Use community rules (fastest) or generate your own (flexible)

### Path 1: Use Community-Generated Rules (Fastest)

**For PatternFly migrations:**

```bash
# 1. Download production-validated rules (AI-generated, community-tested)
curl -O https://raw.githubusercontent.com/tsanders-rh/analyzer-rule-generator/main/examples/rulesets/patternfly-v5-to-v6/patternfly-v5-to-v6.yaml

# 2. Run static analysis (8 seconds for 66K lines)
kantra analyze \
  --input /path/to/your-patternfly-app \
  --rules patternfly-v5-to-v6.yaml \
  --output ./analysis-results

# 3. Open the HTML report
open ./analysis-results/output.html
```

**What you'll see:**
- All violations with 95%+ accuracy (semantic analysis)
- Exact file locations and line numbers
- Before/after code examples (from solution server)
- Effort estimates and prioritization
- Links to migration guides

**Production rulesets available for:**
- Java EE → Quarkus (36+ rules)
- Spring Boot 2 → 3 (9+ rules)
- Java 8/11/17/21 upgrades
- EAP 6/7/8, Camel 3/4, Hibernate
- Jakarta EE, OpenLiberty, Cloud readiness
- [Browse all 29+ rulesets →](https://github.com/konveyor/rulesets/tree/main/default/generated)

### Path 2: Generate Rules for Your Framework (Most Flexible)

**This demonstrates the complete AI + Static Analysis workflow:**

```bash
# Clone the rule generator
git clone https://github.com/tsanders-rh/analyzer-rule-generator
cd analyzer-rule-generator

# Install dependencies
pip install -r requirements.txt

# Use AI to generate rules from migration guide
python scripts/generate_rules.py \
  --guide https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Migration-Guide \
  --source spring-boot-2 \
  --target spring-boot-3 \
  --provider anthropic

# Run static analysis with generated rules
kantra analyze --input ~/your-app --rules ./output/spring-boot-2/
```

**What just happened:**
1. ✅ AI extracted patterns from Spring Boot migration guide
2. ✅ Generated analyzer rules in YAML format
3. ✅ Static analysis detected violations with 95%+ accuracy
4. ⏭️ Next: Use KAI or your preferred tools to apply fixes

**Time investment:**
- AI rule generation: ~2 minutes
- Static analysis: ~8 seconds
- Total: **< 3 minutes** from docs to violations

### Prerequisites

- **Podman 4+** or **Docker 24+** (kantra handles everything else automatically)
- **Optional:** LLM Model API key (for generating your own rules)

**No API key?** Use community-generated rules (Path 1) - they're already available for common frameworks.

---

## Resources & Deep Dives

**Tools & Documentation:**
- [Konveyor Project](https://konveyor.io) - Main project site
- [Analyzer Rule Generator](https://github.com/tsanders-rh/analyzer-rule-generator) - Generate custom rules
- [Konveyor Analyzer](https://github.com/konveyor/analyzer-lsp) - Static analysis engine
- [Community Rulesets](https://github.com/konveyor/rulesets) - Pre-built migration rules
- [KAI IDE Extension](https://github.com/konveyor/kai) - Deep IDE integration

**Community:**
- [GitHub Discussions](https://github.com/konveyor/community/discussions) - Ask questions, share experiences
- [Slack Channel](https://kubernetes.slack.com/archives/CR85S82A2) - Real-time chat with community
- [Monthly Community Meetings](https://konveyor.io/community) - Join the conversation

---

**Doing interesting work with Konveyor?** We'd love to hear about it and help amplify your story.

---

*Application modernization is challenging. Let's make it more efficient—together.*
