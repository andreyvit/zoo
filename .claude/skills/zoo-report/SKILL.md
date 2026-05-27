---
name: zoo-report
description: Produce the final user-facing report for completed Zoo workflow runs. Use at the end of Zoo Heavy, Zoo Lite, Zoo Zero, or another top-level Zoo workflow after required implementation, review, validation, docs, and commits are complete, just before the agent exits or sends its final response to the user.
---

# Zoo Report

Read and follow `.zoo/zoo.md` if it exists.

Use this to close a completed top-level Zoo workflow with a useful final report to the current user.

Do not use this for delegated single-step agents, mid-task status updates, or review reports. Delegated agents write their assigned Bureau report and stop.

Read and follow `.zoo/report.md` if it exists.

Before writing the final report, verify `.zoo/task-finish.md` was read at the start of final closeout if it exists. Instructions in that file take priority over this skill and may skip or replace `zoo-rebase`. If task-finish did not override rebase, verify `zoo-rebase` completed cleanly. Do not report completion while required rebase is not clean, task-finish validation is failing, incoming changes require rerunning tests, or trackable Zoo workflow changes outside ignored task roots remain uncommitted.

Ignored task-root files are workspace-only artifacts, not commit material. If a task root such as `.tasks/`, `_tasks/`, or a repo-specific alternate is ignored by git, do not report files under it as uncommitted workflow changes, and never ask for them to be staged, force-added, committed, or pushed.

## Report Method

1. Gather the completion context:
   - the current user request and any ticket/PR/spec that shaped the task
   - the preserved original requested scope from spec `User Input` or the Zoo Zero `user-request` report
   - the active Zoo spec, Bureau reports, evidence directory, and final planner/closeout report when present
   - dependency change callouts from spec `Dependency Changes`, implementation/fixes reports, direct dependency diffs, and commits
   - the current git status, relevant diff, and commits made during the workflow
   - `zoo-rebase` result and `.zoo/task-finish.md` results when that file exists
   - validation commands, browser checks, generated artifacts, proposals, and deferred refactorings recorded during the task
2. Identify the user-visible result first. Describe the features, behavior changes, docs, generated files, or operational changes the user now gets.
3. Identify extras added on top of the user's original request or original plan: user-visible requirements, features, limitations, safeguards, operational behavior, or other deliberate scope choices. Include the rationale for each. If there were no extras, say so.
4. Identify dependency changes: changes to dependency sets or versions, and changes made inside modifiable dependency checkouts. Include the rationale for each. If there were no dependency changes, say so.
5. Group touched files by package or meaningful repo area. Sort areas from most significant to least significant change. For each area, give one short summary of what changed there.
6. List commits made during the workflow. Use the short hash and subject when available. If no commits were made, say so.
7. List outstanding remaining work, deferred refactorings, proposal files, known limitations, failed/skipped validation, or follow-up decisions. If there is nothing known, say there is no known remaining work.
8. For UI or browser-visible changes, show focused screenshots:
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
2. Extras
3. Dependency changes
4. Areas touched
5. Validation and evidence
6. Commits
7. Remaining work
8. Screenshots, when applicable

Do not paste raw reports, long diffs, or full test logs. Do not invent commits, validation, screenshots, or remaining work. If the source of truth is unclear, state the uncertainty plainly.
