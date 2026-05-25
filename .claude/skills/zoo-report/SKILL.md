---
name: zoo-report
description: Produce the final user-facing report for completed Zoo workflow runs. Use at the end of Zoo Heavy, Zoo Lite, Zoo Zero, or another top-level Zoo workflow after required implementation, review, validation, docs, and commits are complete, just before the agent exits or sends its final response to the user.
---

# Zoo Report

Use this to close a completed top-level Zoo workflow with a useful final report to the current user.

Do not use this for delegated single-step agents, mid-task status updates, or review reports. Delegated agents write their assigned Bureau report and stop.

Read and follow `.zoo/report.md` if it exists.

## Report Method

1. Gather the completion context:
   - the current user request and any ticket/PR/spec that shaped the task
   - the active Zoo spec, Bureau reports, evidence directory, and final planner/closeout report when present
   - the current git status, relevant diff, and commits made during the workflow
   - validation commands, browser checks, generated artifacts, proposals, and deferred refactorings recorded during the task
2. Identify the user-visible result first. Describe the features, behavior changes, docs, generated files, or operational changes the user now gets.
3. Group touched files by package or meaningful repo area. Sort areas from most significant to least significant change. For each area, give one short summary of what changed there.
4. List commits made during the workflow. Use the short hash and subject when available. If no commits were made, say so.
5. List outstanding remaining work, deferred refactorings, proposal files, known limitations, failed/skipped validation, or follow-up decisions. If there is nothing known, say there is no known remaining work.
6. For UI or browser-visible changes, show focused screenshots:
   - Prefer existing evidence screenshots from the Zoo evidence directory when they cover the changed behavior.
   - Capture new screenshots when existing evidence is missing, stale, too broad, or does not demonstrate the final state.
   - Show every relevant UI state when the UI varies by setting, checkbox, dropdown, data state, permission, viewport, or configuration.
   - Use reasonable settings or fixtures to demonstrate states that default settings cannot show.
   - Focus screenshots on the changed UI, not unrelated page chrome.
   - In Codex, embed local screenshots with absolute-path Markdown image tags. In Claude Code, use its supported image/file presentation; if inline display is unavailable, include the evidence paths and what each screenshot proves.
   - If screenshots cannot be produced, explain why and what evidence is available instead.

## Output Shape

Keep the report brief but comprehensive. Prefer this order:

1. Completed result
2. Areas touched
3. Validation and evidence
4. Commits
5. Remaining work
6. Screenshots, when applicable

Do not paste raw reports, long diffs, or full test logs. Do not invent commits, validation, screenshots, or remaining work. If the source of truth is unclear, state the uncertainty plainly.
