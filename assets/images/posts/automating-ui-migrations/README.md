# Screenshots for "Automating UI Migrations with AI-Generated Analyzer Rules"

## Required Screenshots

### 1. rule-generation-output.png
**What to capture:**
- Terminal window showing the `generate_rules.py` command execution
- Success messages displaying:
  - "Extracted 15 patterns from migration guide"
  - "Generated 15 rules across 8 concern areas"
  - "Time: 2 minutes 14 seconds"

**Tips:**
- Use a clean terminal with good contrast (dark theme recommended)
- Make sure the command is visible at the top
- Capture the complete output showing the progression
- Use syntax highlighting if your terminal supports it

**Command to run:**
```bash
python scripts/generate_rules.py \
    --guide https://www.patternfly.org/get-started/upgrade/ \
    --source patternfly5 \
    --target patternfly6 \
    --output ./examples/output \
    --provider anthropic \
    --model claude-3-7-sonnet-latest
```

---

### 2. kantra-analysis-report.png
**What to capture:**
- HTML violation report opened in a web browser
- File listing with violation counts visible
- 2-3 expanded violations showing:
  - Rule ID and description
  - File path with line numbers
  - Code snippet highlighting the issue
  - Helpful message with before/after examples
  - Link to documentation

**Tips:**
- Open the report in a clean browser window (no unrelated tabs visible)
- Zoom to a readable level (120-150%)
- Consider annotating with arrows or boxes to highlight key sections
- Choose violations that demonstrate clear, understandable issues

**Report location:**
```
./analysis-results/output.html
```

---

### 3. konveyor-ai-suggestion.png
**What to capture:**
- Konveyor AI interface showing:
  - A violation being analyzed
  - Before/after code comparison
  - AI-generated explanation
  - Accept/Modify/Reject action buttons

**Tips:**
- Choose a simple, clear example (component rename is ideal)
- Make sure both before and after code are clearly visible
- Show the AI's reasoning/explanation
- Highlight the action buttons (Accept/Modify/Reject)
- Use an example that demonstrates clear value

**Suggested violation to showcase:**
- Component rename (e.g., Text → Content)
- Import statement update
- Simple prop change

---

## Image Guidelines

- **Resolution**: Minimum 1920x1080, prefer 2x DPI (3840x2160) and scale down
- **Format**: PNG for screenshots (better quality, no artifacts)
- **Compression**: Use tools like `optipng` or `pngquant` to reduce file size
- **Privacy**: Remove any sensitive information (API keys, internal URLs, usernames)
- **Annotations**: Use red boxes/arrows to highlight important areas
- **Consistency**: Same terminal/editor theme across all screenshots

## Tools for Screenshots

- **macOS**: Cmd+Shift+4 (select area) or Cmd+Shift+5 (advanced options)
- **Linux**: `gnome-screenshot`, `flameshot`, or `spectacle`
- **Windows**: Windows+Shift+S or Snipping Tool

## Tools for Annotations

- **macOS**: Preview (built-in), Skitch
- **Linux**: GIMP, Inkscape
- **Windows**: Paint, Paint 3D
- **Cross-platform**: Krita, GIMP, Figma (web)
