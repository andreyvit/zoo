---
name: zoo-browser-verification
description: "Verify browser-visible Zoo behavior and capture focused UI evidence. Use only when explicitly requested."
---

# Zoo Browser Verification

Use this when verifying browser-impact Zoo subtasks.

Goal: prove browser-visible behavior works and collect actionable UI evidence.

Read and follow `.zoo/browser.md` if it exists.

## Browser Method

- Run after implementation for browser-impact subtasks.
- Use the repo's browser/app harness mode when it exists and covers the needed flow.
- Record the actual mode, scenario, port, URL, viewport, and user/auth state.
- Use Codex Browser Use for navigation, interaction, inspection, screenshots, and evidence capture.
- Use Codex Computer Use only when Codex Browser Use cannot exercise the required browser-visible behavior.
- Use Codex Computer Use, when available, to recover from native browser alerts, print dialogs, permission prompts, or other OS-level UI that blocks Browser Use. To an agent, these might look like the browser session freezing.
- Avoid broad global keystrokes that could affect the Codex conversation instead of the browser. (Sending Esc to Codex will stop yourself!) Prefer visible dialog actions or the safest specific dismissal sequence.
- If using macOS-level fallback, verify Codex has Screen & System Audio Recording plus Accessibility permissions before relying on screenshots or keyboard events.
- In the Codex desktop app, the in-app browser and conversation share one app window; avoid global Escape because it can abort the Codex turn.
- For dropdown/popover/disclosure/select changes, prove open/dismiss/select/submit parity with screenshots per impacted flow.
- Save screenshot evidence for each impacted flow or acceptance checkpoint, including before/after states when the transition matters.
- Record video evidence when screenshots cannot prove behavior, such as animation, transient states, or timing-sensitive interactions.
- Record important browser-testing learnings immediately in the relevant durable notes before continuing; browser sessions can be interrupted or compacted, and exact recovery steps are easy to lose.
- Keep artifacts focused and named clearly.
- If verification cannot be completed, stop, mark the result failed, and explain exactly what blocked the flow and what you tried.
