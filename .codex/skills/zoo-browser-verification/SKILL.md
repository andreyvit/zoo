---
name: zoo-browser-verification
description: "Verify browser-visible Zoo behavior and capture focused UI evidence. Use only when explicitly requested."
---

# Zoo Browser Verification

Read and follow `.zoo/zoo.md` if it exists.

Use this when verifying browser-impact Zoo subtasks.

Goal: prove browser-visible behavior works and collect actionable UI evidence.

Read and follow `.zoo/browser.md` if it exists.

## Browser Method

- Run after implementation for browser-impact subtasks.
- Use the repo's browser/app harness mode when it exists and covers the needed flow.
- Record the actual mode, scenario, port, URL, viewport, and user/auth state.
- Use the harness in-page browser tool for navigation, interaction, inspection, screenshots, and evidence capture. In Codex this is Codex Browser Use; in Claude Code this is the Chrome extension MCP (`mcp__Claude_in_Chrome__*`, see `_ai/browser-testing.md`).
- Use the OS-level automation fallback only when the in-page browser tool cannot exercise the required browser-visible behavior, e.g. native browser alerts, print dialogs, permission prompts, or other OS-level UI that blocks the in-page tool. To an agent, these might look like the browser session freezing. In Codex the fallback is Codex Computer Use; in Claude Code use whatever OS-level automation is available to the harness.
- Avoid broad global keystrokes that could affect the harness conversation instead of the browser. Prefer visible dialog actions or the safest specific dismissal sequence. Codex only: sending Esc to Codex will stop yourself.
- Codex only: if using the macOS-level fallback, verify Codex has Screen & System Audio Recording plus Accessibility permissions before relying on screenshots or keyboard events.
- Codex only: in the Codex desktop app, the in-app browser and conversation share one app window; avoid global Escape because it can abort the Codex turn.
- For dropdown/popover/disclosure/select changes, prove open/dismiss/select/submit parity with screenshots per impacted flow.
- Save screenshot evidence for each impacted flow or acceptance checkpoint, including before/after states when the transition matters.
- Record video evidence when screenshots cannot prove behavior, such as animation, transient states, or timing-sensitive interactions.
- Record important browser-testing learnings immediately in the relevant durable notes before continuing; browser sessions can be interrupted or compacted, and exact recovery steps are easy to lose.
- Keep artifacts focused and named clearly.
- If verification cannot be completed, stop, mark the result failed, and explain exactly what blocked the flow and what you tried.

## Report Handoff

Include `Final-state validation` in the browser-verification report:

- browser checks run against the current implemented state
- result on that exact state: `passed`, `failed`, or `not run`
- whether any repo file changed after those checks
- if browser validation did not pass, the exact flow or command the orchestrator should rerun after fixes
