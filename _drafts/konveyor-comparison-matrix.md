# Konveyor vs AI Assistants vs Refactoring Tools

## Comprehensive Comparison Matrix

| Feature | GitHub Copilot | Claude Code/Cursor | IBM Project Bob | OpenRewrite | Konveyor |
|---------|---------------|-------------------|----------------|-------------|----------|
| **Primary goal** | Code completion | Agentic coding assistant | AI-powered dev assistant + modernization | Deterministic refactoring | AI-assisted modernization |
| **Detection method** | N/A (suggests as you type) | Text-based search | AI-based (context-aware) | AST-based (deterministic) | Semantic analysis (deterministic) |
| **Detection accuracy** | N/A | ~80% (false positives) | Unknown (AI-based) | ~100% (rule-defined) | 95%+ (semantic) |
| **Scope** | Current file focus | Full codebase | Repository context | Full codebase | Full codebase |
| **Migration knowledge** | Generic (training data) | Generic (training data) | Java modernization focus | Community recipes | Production-validated rulesets + solution server |
| **Fix suggestions** | AI-generated | AI-generated | AI-generated (context-aware) | Deterministic transforms | AI-generated (from verified violations) |
| **Automation level** | Inline suggestions | Interactive prompts | Proactive flagging + suggestions | Fully automated | Semi-automated (review recommended) |
| **Consistency** | Varies by context | Varies by prompt | Varies by AI model | 100% deterministic | Deterministic detection + AI suggestions |
| **Reproducibility** | Low (AI-based) | Low (AI-based) | Low (AI-based) | High (rule-based) | High detection, contextual suggestions |
| **False positive rate** | N/A | 15-20% | Unknown | ~0% (by design) | ~5% |
| **Handles edge cases** | Via prompting | Via prompting | AI review + feedback | Via recipe customization | Via developer review + AI |
| **Integration** | IDE plugins | IDE/CLI | IDE-native | Maven/Gradle/CLI | KAI IDE extension, MCP (coming), standalone |
| **Language support** | Multi-language | Multi-language | Java focus (8→17) | Java, Kotlin, Groovy | Java, TypeScript (via providers) |
| **Best for** | Daily development | Complex refactoring | Enterprise Java modernization + security | Consistent code transforms | Application modernization at scale |
| **Hallucination risk** | Medium | Medium | Medium (AI-based) | None (deterministic) | Low (AI only suggests fixes) |
| **Cost consideration** | Per-seat subscription | Per-seat subscription | Enterprise (waitlist) | Free (open source) | Free (open source) |
| **Requires AI/LLM** | Yes | Yes | Yes | No | Optional (for fix suggestions) |
| **Works offline** | No | No | Likely no | Yes | Partial (analysis yes, AI suggestions no) |
| **Learning curve** | Low | Low | Low | Medium (recipe writing) | Low (use existing rulesets) |
| **Community rulesets** | N/A | N/A | N/A | OpenRewrite recipes | Konveyor rulesets + analyzer rules |
| **Security focus** | Basic | Basic | High (vulnerability detection) | Low | Medium |
| **Availability** | GA | GA | Waitlist | GA | GA |

## When to Use Each

### GitHub Copilot
**Use for:**
- Daily coding tasks
- Writing new code from natural language
- Inline code completion
- Learning new APIs

**Not ideal for:**
- Systematic code migrations
- Full codebase analysis
- Deterministic transformations

### Claude Code / Cursor
**Use for:**
- Understanding unfamiliar codebases
- Complex multi-file refactoring
- Interactive code exploration
- Debugging across files

**Not ideal for:**
- Migrations requiring 100% accuracy
- Systematic detection of violations
- Reproducible transformations

### IBM Project Bob
**Use for:**
- Enterprise Java modernization (Java 8→17)
- Security-focused development
- Organizations already in IBM ecosystem
- Code review with AI assistance
- Compliance-heavy environments

**Not ideal for:**
- Non-Java languages (currently Java-focused)
- Open source preference (proprietary/enterprise)
- Currently unavailable (waitlist only)
- Projects needing multi-language support

**Decision criteria:** Choose IBM Project Bob if you're in the IBM ecosystem, need enterprise support, and focus on Java modernization with integrated security scanning.

### OpenRewrite
**Use for:**
- JVM languages only (Java, Kotlin, Groovy)
- Migrations where recipes already exist (e.g., Spring Boot upgrades with official recipes)
- 100% automated transforms (no human review desired)
- CI/CD pipeline integration for consistent refactoring
- Pure deterministic approach (no AI involved)

**Not ideal for:**
- TypeScript, JavaScript, or other non-JVM languages
- Novel migration patterns (no existing recipe available)
- Migrations requiring contextual judgment
- Projects where you want AI-assisted suggestions

**Decision criteria:** Choose OpenRewrite if you need fully automated, deterministic transforms for JVM languages and a recipe already exists for your exact use case.

### Konveyor
**Use for:**
- Multi-language modernizations (Java AND TypeScript/JavaScript via providers)
- Migrations without existing OpenRewrite recipes
- Projects needing production-validated rulesets (0 setup time)
- Situations requiring AI assistance for complex refactors
- Platform migrations with custom patterns (Java EE → Quarkus, legacy frameworks)
- Projects where you want semantic analysis + AI suggestions

**Not ideal for:**
- Daily development tasks (use Copilot/Claude Code)
- Simple find-and-replace operations
- Pure JVM migrations where OpenRewrite recipes exist and provide 100% automation

**Decision criteria:** Choose Konveyor if you need multi-language support, production-validated rulesets, AI-assisted suggestions, or are tackling novel migration patterns not covered by OpenRewrite recipes.

## OpenRewrite vs Konveyor: Decision Tree

**Start here:**

1. **What language(s)?**
   - Pure JVM (Java/Kotlin/Groovy) → Continue to question 2
   - Includes TypeScript/JavaScript → **Choose Konveyor** (OpenRewrite doesn't support these)
   - Multiple languages in same modernization → **Choose Konveyor**

2. **Does an OpenRewrite recipe already exist for your exact migration?**
   - Yes, and it works perfectly → **Choose OpenRewrite** (faster, fully automated)
   - No, or recipes need customization → Continue to question 3

3. **Do you want 100% automation with no human review?**
   - Yes, and OpenRewrite recipe exists → **Choose OpenRewrite**
   - No, I want AI assistance for edge cases → **Choose Konveyor**

4. **How custom is your migration?**
   - Standard framework upgrade (Spring Boot 2→3, JUnit 4→5) → **OpenRewrite may be sufficient**
   - Platform migration (Java EE → Quarkus) → **Choose Konveyor** (better for platform-level changes)
   - Internal framework/custom patterns → **Choose Konveyor** (production rulesets + AI flexibility)

5. **What's your priority?**
   - Speed + full automation → **OpenRewrite** (if recipe exists)
   - Accuracy + AI assistance → **Choose Konveyor**
   - Multi-language support → **Choose Konveyor**

**Can I use both?**

**Yes!** Many teams use:
- **OpenRewrite** for well-defined JVM transforms (Spring Boot upgrades, dependency updates)
- **Konveyor** for custom patterns, multi-language, and platform migrations
- They complement each other - not an either/or choice

### Real-World Scenarios

| Scenario | Recommended Tool | Why |
|----------|-----------------|-----|
| Spring Boot 2 → 3 migration (Java only) | **OpenRewrite** | Official recipes exist, fully automated |
| React app with PatternFly 5 → 6 | **Konveyor** | TypeScript/JSX (OpenRewrite doesn't support) |
| Java EE app → Quarkus | **Konveyor** | Platform-level migration, production rulesets available |
| JUnit 4 → 5 upgrade (Java) | **OpenRewrite** | Well-defined recipe, 100% deterministic |
| Java 8 → 17 upgrade (enterprise, IBM shop) | **IBM Project Bob** | Enterprise support, security focus, IBM ecosystem |
| Monorepo with Java + TypeScript | **Konveyor** | Multi-language support needed |
| Custom internal framework upgrade | **Konveyor** | No OpenRewrite recipe exists, AI helps with patterns |
| Dependency version bumps (Maven/Gradle) | **OpenRewrite** | Built for this use case |
| Legacy Java app with custom annotations | **Konveyor** | Semantic analysis + AI for custom patterns |
| Java app with security compliance requirements | **IBM Project Bob** | High security focus, vulnerability detection |
| Angular 15 → 16 upgrade | **Konveyor** | TypeScript (not JVM) |
| Standard library migration (Guava → Java stdlib) | **OpenRewrite** | Recipe exists, deterministic |

## Complementary Use Cases

### Konveyor + AI Coding Assistant
- **Konveyor:** Detect violations with semantic analysis
- **Your AI assistant:** Help with edge cases and custom logic
- **Result:** Verified violations + AI-assisted fixes

### Konveyor + OpenRewrite
- **OpenRewrite:** Handle well-defined deterministic transforms
- **Konveyor:** Handle novel patterns and provide AI assistance
- **Result:** Automated where possible, AI-assisted where needed

### All Three Together
- **Daily development:** Copilot/Claude Code
- **Known refactorings:** OpenRewrite recipes
- **Modernization projects:** Konveyor for semantic analysis + AI
- **Result:** Right tool for each job

## Key Differentiators

### What Makes Konveyor Unique vs OpenRewrite

1. **Multi-Language Support**
   - **Konveyor:** Java, TypeScript, JavaScript (via providers)
   - **OpenRewrite:** JVM languages only (Java, Kotlin, Groovy)
   - **Impact:** Can handle full-stack modernizations (backend + frontend)

2. **Production-Validated Rulesets**
   - **Konveyor:** Pre-built, tested rules for common migrations (0 minutes to start)
   - **OpenRewrite:** Community recipes (excellent for JVM, but requires recipe to exist)
   - **Impact:** Faster time to value for supported migrations

3. **AI-Assisted Suggestions**
   - **Konveyor:** Hybrid approach - deterministic detection + AI suggestions
   - **OpenRewrite:** Pure deterministic (no AI)
   - **Impact:** Better handling of edge cases and novel patterns

4. **Solution Server**
   - **Konveyor:** Curated migration patterns, always current
   - **OpenRewrite:** Recipe-based (must write new recipe for custom patterns)
   - **Impact:** Organization-specific pattern support

5. **Platform-Level Migrations**
   - **Konveyor:** Optimized for Java EE → Quarkus, legacy platform migrations
   - **OpenRewrite:** Better for framework-level (Spring Boot, JUnit)
   - **Impact:** Different sweet spots

### What Makes Konveyor Unique vs AI Assistants (including IBM Project Bob)

1. **Deterministic Detection**
   - **Konveyor:** Semantic analysis (95%+ accuracy)
   - **AI Assistants (Copilot, Claude Code, Project Bob):** Text/AI-based search (~80% accuracy)
   - **Impact:** 75% reduction in false positives

2. **De-risks Generative AI**
   - Static analysis verifies violations first
   - AI only suggests fixes for verified issues
   - Reduces hallucination risk
   - Cost efficient (only process real violations)

3. **Migration-Specific Knowledge**
   - Production-validated rulesets (0 minutes to start)
   - Solution server with curated patterns
   - Not dependent on LLM training data cutoff
   - **vs IBM Project Bob:** Open source, multi-language vs proprietary, Java-focused

4. **Reproducibility**
   - Same code = same violations detected (deterministic)
   - AI suggestions are contextual but violations are consistent
   - **vs IBM Project Bob:** High detection reproducibility vs AI-based variability

5. **Multi-Language Support**
   - **Konveyor:** Java + TypeScript/JavaScript
   - **IBM Project Bob:** Java focus (8→17)
   - **Impact:** Can handle full-stack modernizations

## Positioning Summary

**Konveyor is not trying to replace:**
- GitHub Copilot (daily development)
- Claude Code (general refactoring)
- IBM Project Bob (enterprise Java + security)
- OpenRewrite (deterministic transforms)

**Konveyor is purpose-built for:**
- Application modernization at scale (multi-language)
- Semantic violation detection + AI assistance
- Production migrations requiring high accuracy
- Projects leveraging validated community rulesets
- Open source preference with enterprise capabilities

**Key competitive advantages:**

| vs Tool | Konveyor Advantage |
|---------|-------------------|
| **vs GitHub Copilot** | Systematic migration detection (not just autocomplete) |
| **vs Claude Code** | Deterministic semantic analysis (95% vs 80%) |
| **vs IBM Project Bob** | Open source, multi-language, production rulesets |
| **vs OpenRewrite** | Multi-language support, AI assistance, platform migrations |

## References

- [Konveyor Project](https://konveyor.io)
- [OpenRewrite](https://docs.openrewrite.org)
- [GitHub Copilot](https://github.com/features/copilot)
- [Claude Code](https://claude.ai/code)
- [Cursor](https://cursor.sh)
- [IBM Project Bob](https://www.ibm.com/products/bob)
