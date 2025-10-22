# Screenshots for "Enhancing UI Migrations with TypeScript Provider"

## Recommended Screenshots

### 1. provider-comparison.png
**What to capture:**
- Split-screen comparison showing the same code analyzed by both providers
- **Left side**: Builtin provider results with false positives marked
  - Show matches in comments (false positive)
  - Show matches in string literals (false positive)
  - Show matches in variable names (false positive)
- **Right side**: TypeScript provider results
  - Only actual code references highlighted
  - No false positives

**Tips:**
- Use side-by-side layout for easy comparison
- Annotate false positives with ❌ red marks
- Annotate correct matches with ✅ green marks
- Use arrows or callouts to explain differences

**Example code to analyze:**
```typescript
// This is about OldButton - TODO update later (false positive)
import { OldButton } from '@patternfly/react-core'; // real match
const myOldButton = 'test'; // false positive variable name
const message = "See OldButton docs"; // false positive in string

function MyComponent() {
  return <OldButton />; // real match
}
```

---

### 2. provider-settings.png
**What to capture:**
- Code editor (VS Code preferred) showing `typescript-provider-settings.json`
- Highlight important sections:
  - `binaryPath` configuration
  - `includedPaths` array (e.g., `"src/"`)
  - `excludedPaths` array (e.g., `"node_modules/"`, `"dist/"`)
  - `dependencyProviderPath`

**Tips:**
- Use syntax highlighting
- Add annotations pointing to critical config options
- Show file tree on the left to give context
- Consider showing the directory structure being included/excluded

**File to show:**
```json
{
  "name": "typescript",
  "initConfig": [{
    "providerSpecificConfig": {
      "includedPaths": ["src/"],
      "excludedPaths": ["node_modules/", "dist/"]
    }
  }]
}
```

---

### 3. analysis-results.png
**What to capture:**
- Comparison table or side-by-side showing:
  - **Builtin provider only**:
    - Total violations: ~2,800
    - False positives: ~15-20%
    - Analysis time: 30-45 seconds
  - **With TypeScript provider**:
    - Total violations: ~2,540
    - False positives: ~5%
    - Analysis time: 5-7 seconds

**Tips:**
- Create a visual table or infographic
- Use bar charts to show the difference
- Highlight the improvements (fewer false positives, faster analysis)
- Use green to show improvements

**Tools:**
- Create in spreadsheet tool (Excel, Google Sheets) and screenshot
- Or use a visualization tool (Chart.js, D3.js)
- Or manually create in presentation software (PowerPoint, Keynote, Google Slides)

---

### 4. semantic-analysis.png
**What to capture:**
- Code editor showing a file with TypeScript provider violation highlighting
- Show:
  - Actual component usage highlighted (e.g., `<OldButton />`)
  - Comment containing "OldButton" NOT highlighted
  - String literal containing "OldButton" NOT highlighted
- Include hover tooltip or problems panel showing the violation details

**Tips:**
- Use VS Code with Konveyor extension (if available) or mock the highlighting
- Show line numbers
- Include the problems panel at the bottom
- Annotate to point out what IS and ISN'T matched

**Example code:**
```typescript
// TODO: Update OldButton component later ← NOT highlighted
import { OldButton } from '@patternfly/react-core'; // ← Highlighted

function MyComponent() {
  // This uses the old button component ← NOT highlighted
  return <OldButton />; // ← Highlighted
}
```

---

## Additional Recommended Assets

### 5. decision-flowchart.png (Optional)
**What to create:**
- Flowchart showing decision tree for choosing TypeScript vs Builtin provider
- Questions like:
  - "Is it a top-level symbol?" → Yes → Use TypeScript provider
  - "Is it a method or property?" → Yes → Use Builtin provider
  - "Is it a type annotation?" → Yes → Use Builtin provider

**Tools:**
- Mermaid (can be rendered in markdown)
- Draw.io (diagrams.net)
- Lucidchart
- Excalidraw

---

### 6. capabilities-table.png (Optional)
**What to create:**
- Table showing what TypeScript provider can/cannot find
- Columns: Feature | TypeScript Provider | Builtin Provider
- Rows: Functions, Classes, Imports, JSX, Methods, Properties, Types, etc.

**Format as markdown table:**
```markdown
| Feature              | TypeScript Provider | Builtin Provider |
|----------------------|---------------------|------------------|
| Functions            | ✅ Yes              | ✅ Yes           |
| Classes              | ✅ Yes              | ✅ Yes           |
| Imports              | ✅ Yes              | ✅ Yes           |
| JSX Components       | ✅ Yes              | ✅ Yes           |
| Class Methods        | ❌ No               | ✅ Yes           |
| Object Properties    | ❌ No               | ✅ Yes           |
| Type Annotations     | ❌ No               | ✅ Yes           |
```

---

## Image Guidelines

- **Resolution**: Minimum 1920x1080, prefer 2x DPI and scale down
- **Format**: PNG for screenshots, SVG for diagrams where possible
- **Compression**: Optimize file sizes without losing quality
- **Privacy**: Redact sensitive information
- **Annotations**: Use consistent color scheme (red for issues, green for correct)
- **Consistency**: Same editor/terminal theme as first blog post

## Screenshot Checklist

- [ ] provider-comparison.png - Shows false positive differences
- [ ] provider-settings.png - Configuration file example
- [ ] analysis-results.png - Performance/accuracy comparison
- [ ] semantic-analysis.png - Real violation highlighting
- [ ] decision-flowchart.png (optional) - When to use which provider
- [ ] capabilities-table.png (optional) - Feature comparison table
