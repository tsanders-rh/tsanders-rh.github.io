# Konveyor AI Screen Recording Scripts

This document provides detailed step-by-step scripts for recording the animated GIFs for the Part 3 blog post.

## Pre-Recording Setup

**Before starting any recordings:**

1. **Prepare the tackle2-ui project:**
   ```bash
   cd ~/path/to/tackle2-ui
   # Make sure you have the analysis results from Part 2
   ls -la analysis-results/output.yaml
   ```

2. **VS Code configuration:**
   - Set theme to Dark+ (better contrast)
   - Set editor font size to 16pt: `"editor.fontSize": 16`
   - Set zoom level to 1.2: `Cmd+Plus` a few times
   - Hide minimap: `View → Toggle Minimap`
   - Hide breadcrumbs: `View → Toggle Breadcrumbs`
   - Ensure Konveyor extension is installed and configured

3. **Screen recording settings:**
   - Close all unnecessary applications
   - Hide desktop icons (Cmd+Shift+H on macOS)
   - Set display resolution to 1920x1080 if possible
   - Disable notifications: System Preferences → Notifications → Do Not Disturb

4. **Recording tools:**
   - **For macOS:** Use QuickTime Player (File → New Screen Recording) or Cmd+Shift+5
   - **For GIF conversion:** Download [gifski](https://gif.ski/) or [LICEcap](https://www.cockos.com/licecap/)

---

## Recording 1: Complete Workflow (HIGH PRIORITY)

**File:** `konveyor-ai-complete-workflow.gif`
**Duration:** 30 seconds
**Location:** Right after "Getting AI-Assisted Fixes in VS Code" heading
**Goal:** Show the complete workflow from violation to fix in one smooth sequence

### Pre-Recording Checklist
- [ ] VS Code is open with tackle2-ui project
- [ ] Analysis has been run (violations visible in Issues view)
- [ ] No other panels are open (close terminal, debug, etc.)
- [ ] Font size is 16pt
- [ ] Theme is Dark+

### Recording Script

**Frame 1-3 seconds: Show the Issues View**
- Action: Open the Konveyor Issues view (if not already open)
- Show: Full VS Code window with Issues view in left sidebar
- Highlight: The "Text component should be replaced with Content (886)" violation
- Wait: 2 seconds (let viewers see the count)

**Frame 4-6 seconds: Expand the violation**
- Action: Click the arrow to expand "Text component should be replaced with Content"
- Show: Tree expands to show affected files
- Highlight: Multiple file paths visible (ApplicationsPage.tsx, ApplicationList.tsx, etc.)
- Wait: 1 second

**Frame 7-10 seconds: Right-click and select Fix**
- Action: Right-click on "Text component should be replaced with Content (886)"
- Show: Context menu appears
- Highlight: "Fix" option in the menu
- Action: Click "Fix"
- Wait: 1 second for menu to close

**Frame 11-16 seconds: Show AI processing**
- Action: Wait for Resolution Panel to open
- Show: Resolution Panel opens on right side
- Show: "🤖 Generating solution..." message (if visible)
- Wait: Let the AI finish generating (this might be quick, so you may need to slow down the GIF here)
- Show: "✓ Solution ready!" message

**Frame 17-23 seconds: Review the diff**
- Action: Scroll through the diff view in Resolution Panel
- Show: Before/after changes clearly visible:
  - Red line: `import { Text } from '@patternfly/react-core';`
  - Green line: `import { Content } from '@patternfly/react-core';`
- Show: Component usage changes below
- Action: Scroll down slightly to show a few more changes
- Wait: 2 seconds

**Frame 24-28 seconds: Accept the changes**
- Action: Scroll to bottom to show "Accept Changes" button
- Show: Button is clearly visible
- Action: Hover over "Accept Changes" button
- Action: Click "Accept Changes"
- Wait: 1 second

**Frame 29-30 seconds: Show success**
- Show: Resolution Panel updates or closes
- Show: Issues view count decreases (from 886 to 874 or similar)
- Wait: 1 second for final frame

### Post-Recording Processing
1. **Convert to GIF:**
   ```bash
   # Using gifski (recommended for quality)
   gifski --fps 15 --quality 90 --width 1200 recording.mov -o konveyor-ai-complete-workflow.gif

   # Check file size
   ls -lh konveyor-ai-complete-workflow.gif
   # Should be under 5MB. If over, reduce quality to 80 or fps to 12
   ```

2. **Optimize size if needed:**
   ```bash
   # If GIF is too large, reduce fps or dimensions
   gifski --fps 12 --quality 80 --width 1000 recording.mov -o konveyor-ai-complete-workflow.gif
   ```

### Tips for This Recording
- **Go slowly** - Give viewers time to read the text
- **Pause at key moments** - After expanding, before clicking Fix, while viewing diff
- **Keep mouse movements smooth** - Avoid jerky motions
- **If you mess up** - Just re-record! It's digital, no cost to try again
- **Add annotations** - Consider adding arrows/highlights in post-production with a tool like Snagit

---

## Recording 2: Agent Mode Iteration (MEDIUM PRIORITY)

**File:** `konveyor-agent-mode-iteration.gif`
**Duration:** 15 seconds
**Location:** Agent Mode section
**Goal:** Show Agent Mode's iterative validation process

### Pre-Recording Checklist
- [ ] VS Code is open with tackle2-ui project
- [ ] Agent Mode is enabled in settings: `"konveyor.agentMode": true`
- [ ] Terminal is visible at bottom of VS Code
- [ ] Have an EmptyState violation ready (or similar complex violation)

### Recording Script

**Frame 1-3 seconds: Show initial state**
- Show: VS Code with Issues view and Terminal visible
- Show: EmptyState violation selected
- Wait: 1 second

**Frame 4-6 seconds: Trigger AI fix**
- Action: Right-click on violation → "Fix"
- Show: Resolution Panel opens
- Show: Terminal shows "Running TypeScript compiler..." (if visible)
- Wait: 1 second

**Frame 7-10 seconds: Show validation error**
- Show: Terminal output with error:
  ```
  ❌ Error: Type 'EmptyStateIcon' is not assignable to 'ReactNode'
  ```
- Show: Resolution Panel shows "Creating task: Fix type incompatibility"
- Wait: 2 seconds

**Frame 11-13 seconds: Show AI iteration**
- Show: Terminal shows "Agent analyzing error context..."
- Show: Terminal shows "💡 Suggested fix: Update icon prop usage"
- Show: "Applying fix..." message
- Wait: 1 second

**Frame 14-15 seconds: Show success**
- Show: Terminal shows "✓ No errors"
- Show: Resolution Panel shows updated fix ready for review
- Wait: 1 second

### Post-Recording Processing
```bash
gifski --fps 15 --quality 85 --width 1000 recording.mov -o konveyor-agent-mode-iteration.gif
```

### Tips for This Recording
- **Split screen** - Show both terminal and Resolution Panel
- **If real validation is too fast** - You may need to simulate the output in a text file and scroll through it
- **Alternative approach** - Record the actual workflow, then add text overlays in post to simulate the messages

---

## Alternative: Creating Screencasts with Asciinema

If you want terminal-only recordings (for the Agent Mode example), consider using [Asciinema](https://asciinema.org/):

```bash
# Install
brew install asciinema

# Record terminal session
asciinema rec agent-mode-demo.cast

# Convert to GIF
agg agent-mode-demo.cast agent-mode-demo.gif
```

---

## Screenshot Scripts

For static screenshots, here are the exact captures needed:

### Screenshot 1: Extension Marketplace
1. Open VS Code
2. Press Cmd+Shift+X (Extensions)
3. Search for "Konveyor"
4. Wait for results to load
5. Take screenshot (Cmd+Shift+4 on macOS, select area)
6. Crop to just the Extensions sidebar and search results

### Screenshot 2: Resolution Panel Diff
1. Trigger a fix for Text → Content violation
2. Wait for Resolution Panel to show diff
3. Arrange windows: Issues view on left, Resolution Panel on right
4. Take screenshot of full VS Code window
5. Ensure Accept/Reject buttons are visible at bottom

### Screenshot 3: Issues View Organized
1. Collapse all violation types in Issues view
2. Show the full count (1,324) at top
3. Show first 3-4 violation types with their counts
4. Take screenshot of just the Issues sidebar
5. Crop tightly around the Issues panel

---

## Recording Workflow Tips

### Optimal Recording Flow
1. **Practice first** - Do a dry run without recording
2. **Record in segments** - Record each section separately if needed
3. **Use a script** - Write down exactly what you'll click/type
4. **Record at higher resolution** - Then scale down for GIF
5. **Record at normal speed** - Can slow down in post if needed

### Common Issues and Solutions

**Issue: GIF is too large (>5MB)**
- Solution: Reduce fps from 15 to 10-12
- Solution: Reduce quality from 90 to 80
- Solution: Reduce dimensions from 1200px to 1000px
- Solution: Trim unnecessary frames at start/end

**Issue: Text is blurry in GIF**
- Solution: Increase font size to 18pt before recording
- Solution: Increase quality setting in gifski
- Solution: Use fewer colors (add `--colors 256` to gifski)

**Issue: Recording is too fast to follow**
- Solution: Slow down playback using gifski `--fps 10`
- Solution: Add pauses between steps (record yourself waiting)
- Solution: Consider adding text overlays in post-production

**Issue: Can't reproduce Agent Mode behavior**
- Solution: Simulate it - create a shell script that echoes the messages
- Solution: Use a real violation that triggers TypeScript errors
- Solution: Create a mock scenario for demonstration

---

## Post-Production Checklist

After creating each GIF:
- [ ] File size is under 5MB
- [ ] Dimensions are ~1000-1200px wide
- [ ] Text is readable at normal viewing size
- [ ] GIF loops smoothly (doesn't have jarring jump at end)
- [ ] Frame rate is smooth (12-15 fps minimum)
- [ ] Colors are accurate (not over-dithered)

---

## Quick Reference: gifski Commands

```bash
# High quality, large file
gifski --fps 15 --quality 95 --width 1200 input.mov -o output.gif

# Balanced quality, medium file
gifski --fps 12 --quality 85 --width 1000 input.mov -o output.gif

# Smaller file size
gifski --fps 10 --quality 75 --width 800 input.mov -o output.gif

# With color optimization
gifski --fps 12 --quality 85 --width 1000 --colors 256 input.mov -o output.gif

# Check file size
ls -lh output.gif
```

---

## Need Help?

If you encounter issues:
1. Check the [gifski documentation](https://gif.ski/)
2. Try LICEcap as an alternative (simpler, records directly to GIF)
3. Consider using [Kap](https://getkap.co/) - excellent macOS screen recorder with GIF export
4. For simple edits, use [ezgif.com](https://ezgif.com/) to crop, resize, or optimize GIFs in browser

Good luck with the recordings! Remember: perfection isn't the goal, clarity is. As long as viewers can follow along, you're good to go.
