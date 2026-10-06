---
name: zoo-browser-verification
description: "Verify browser-visible behavior and capture focused UI evidence. Use after implementation for browser-impact work or when explicitly requested."
---

Follow `.zoo/zoo.md`, `.zoo/browser.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo browser verification start (.spec/example.md) r0`, then `Zoo browser verification finished (.spec/example.md) r0` or `Zoo browser verification failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

Prove browser-visible behavior works and collect actionable UI evidence.

- Read task file, research file, acceptance criteria, current diff/change. Figure out flows to test.
- Use repo browser/app harness mode when it exists and covers the needed flow.
- Use harness in-page browser tool for navigation, interaction, inspection, screenshots, evidence. Codex: Browser Use. Claude Code: Chrome extension MCP (`mcp__Claude_in_Chrome__*`, see `_ai/browser-testing.md`).
- Use OS-level automation only when in-page browser cannot exercise behavior: native alerts, print dialogs, permission prompts, frozen browser sessions. Codex Computer Use or Claude OS automation.
- Save real screenshots under task evidence dir for each impacted flow or acceptance check, with realistic data, config, styling. Include empty/error states and expanded dropdown/popover/disclosure/select content.
- Output acceptance checks with screenshot links proving pass.
- Report pass/fail/blocked and why.
