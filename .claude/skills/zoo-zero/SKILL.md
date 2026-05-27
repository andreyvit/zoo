---
name: zoo-zero
description: "Direct execution followed by review+fix iterations. Use only when explicitly requested."
---

# Zoo Zero

Read and follow `.zoo/zoo.md` if it exists.

Zoo Zero is the smallest Zoo workflow. It uses no spec file, no planner, no plan review, and no spec subtask file. The top-level agent owns research, planning, implementation, tests, browser checks, docs, evidence, fixes, and final closeout.

## Modes

### Top-Level Mode

Use this workflow only when you are the main agent running the task end to end.

### Delegated Code-Review Mode

If the prompt says you are a delegated `code_reviewer`, execute exactly that review step, write the required `code-review` report, and stop. The prompt must explicitly say this is Zoo Zero and no spec file exists. Do not run Zoo Zero, spawn subagents, wait on subagents, or edit files.

Delegated `code_reviewer` never runs `zoo-uberreview`. The top-level agent runs uberreview after normal code review approves, because `zoo-uberreview` launches multiple reviewer subagents itself.

## Workflow

- Do not create, update, or require a spec file. If one already exists, leave it untouched unless the user explicitly asks to edit it.
- Do not use `zoo-plan`, `planner`, or `plan_reviewer`; Zoo Zero has no plan-review or plan-uberreview phase.
- Do not create spec subtasks or planning-only reports.
- At Zoo Zero start, write a `user-request` Bureau report before implementation. It captures the user request/ticket context, exact original requested scope, initial research, direct plan, expected validation, browser-testing need, and known risks. This report replaces the spec/plan handoff and gives `zoo-report` the baseline for later Extras.
- If the user request references a ticket, issue, PR, or similar work item, read it and treat its contents as part of the user request; direct user chat overrides ticket text when they conflict.
- Research and plan in the top-level context. Read relevant code, tests, docs, recent reports, tickets, production configuration, and production data when appropriate.
- Prefer direct, inspectable plans in your working context over formal artifacts.
- Remember dependency changes throughout implementation: added/removed/updated dependencies, version or dependency-set changes, and code changes in modifiable dependency checkouts. Preserve rationale so `zoo-report` can populate Dependency changes.
- Split implementation mentally into small standalone functional slices, but do not write subtask files.
- When planning, implementation, or review finds work affecting pre-existing code outside the current task, use `zoo-refactoring`: consequential cross-cutting changes become proposals requiring human approval, broad mundane refactors become separate commits before or after the current task depending on whether they technically block it, and small low-pollution edits stay in the current task.
- Zoo Zero has no spec `Subtasks`, so separate refactoring work is tracked with the agent's native task list instead. Use one task item for the current user task and one task item for each separate refactoring, ordered before or after the current task according to `zoo-refactoring`.
- Delegated reviewers that classify a finding as proposal-worthy or separate-commit work must write a `Refactoring request` in their report; the top-level agent owns creating proposal files, updating the native task list, deciding before-vs-after routing, stashing, implementation, and commit separation.
- Implement the smallest correct change that satisfies the user request.
- Write/update tests with production-quality code standards.
- Run relevant validation. Read and follow `.zoo/testing.md` if it exists.
- For browser-visible work, use the repo's browser/app harness mode when it exists and covers the flow. Read and follow `.zoo/browser.md` if it exists.
- Use the harness in-page browser tool (Codex: Codex Browser Use; Claude Code: Chrome extension MCP) for browser navigation, interaction, inspection, screenshots, and evidence capture. Use the OS-level automation fallback (Codex: Codex Computer Use) only when the in-page tool cannot exercise the required browser-visible behavior.
- Update durable docs when the change creates behavior or learnings that should persist.
- End with every trackable Zoo workflow change outside ignored task roots committed unless the user explicitly asked not to commit. Only changes that were already present before Zoo Zero started and are unrelated may remain uncommitted.
- If a task root such as `.tasks/`, `_tasks/`, or a repo-specific alternate is ignored by git, every file under that root is workspace-only Zoo state. Never stage, force-add, commit, or push those files, including additions, modifications, or deletions of paths that were already tracked. Do not count ignored task-root files as uncommitted workflow changes.

## Code Review Loop

1. Top-level agent writes the initial `user-request` report, then researches, plans, implements, tests, runs browser checks when needed, and updates docs.
2. Before the first code-review pass, write a compact `impl` report with Bureau MCP:
   - user request/ticket summary
   - changed files and behavior
   - `Dependency changes`: added/removed/updated dependencies, version or dependency-set changes, code changes in modifiable dependency checkouts, or `none`, with rationale
   - tests/commands run
   - `Final-state validation`: commands run after the last file change, result on the exact state left, whether any file changed afterward, and the command still needed when validation is missing or stale
   - browser evidence or why browser testing was not needed
   - docs updates
   - known tradeoffs or risks
3. Run `code_reviewer`. The invocation prompt must explicitly say this is Zoo Zero, no spec file exists, and reviewer should use the `user-request`, `impl`, and later `fixes` reports plus the actual diff.
4. If `code_reviewer` reports a `Refactoring request` or findings that affect pre-existing code outside the current task, use `zoo-refactoring` before implementing them. If it routes to a proposal, create the proposal with `zoo-proposal` from the reviewer draft, record the proposal path in the next report, and treat the finding as satisfied unless the refactoring is technically blocking. If it routes to separate work, add native task-list items for the refactoring and current task, decide whether the refactoring runs before or after the current task, stash only when necessary, and keep the commit separate.
5. If `code_reviewer` reports remaining in-scope findings, implement all findings.
6. Rerun relevant tests/browser checks after fixes.
7. Before each re-review after findings, write a compact `fixes` report with Bureau MCP:
   - code-review report addressed
   - fixes made or evidence that a finding was wrong
   - dependency changes made by fixes, or `none`, with rationale
   - tests/commands rerun
   - `Final-state validation`: commands run after the last fix, result on the exact state left, whether any file changed afterward, and the command still needed when validation is missing or stale
   - browser evidence updates when relevant
   - remaining risks
8. If a finding appears wrong, record the concrete evidence in the next `fixes` report and rerun `code_reviewer`; the finding remains unresolved until `code_reviewer` accepts the evidence or the code is changed.
9. Repeat steps 3-8 until `code_reviewer` is happy and has no unresolved findings.
10. After `code_reviewer` approves, the top-level agent checks the latest `Final-state validation` entries from `impl`, `fixes`, browser, and code-review reports. If relevant passing validation is missing or stale for the current code state, run it once before or in parallel with code uberreview. Use `zoo-uberreview` to review the code written for the task, telling reviewers that validation has passed or is orchestrator-owned and that they must not rerun broad suites. If validation fails or uberreview reports findings, classify report `Refactoring request`s or findings outside the current task with `zoo-refactoring`; add native task-list items for separate refactoring work, implement in-scope findings, rerun relevant tests/browser checks, write a `fixes` report, rerun `code_reviewer`, then rerun code uberreview. Repeat until final-state validation, normal code review, and code uberreview all have no unresolved findings.
11. For repo changes, use the `commit` skill after both review layers are happy unless the user explicitly asked not to commit.
12. Inspect git status after committing. If any trackable Zoo workflow changes outside ignored task roots remain uncommitted, commit them or treat that as blocking. Only pre-existing unrelated changes may remain uncommitted, and the final report must identify them. If the task root is ignored by git, never stage, force-add, commit, or push files under it.
13. Read `.zoo/task-finish.md` if it exists immediately after all workflow commits are complete. Its instructions take priority over this skill's closeout instructions, including whether to run `zoo-rebase`.
14. Unless `.zoo/task-finish.md` overrides it, run `zoo-rebase`. If it is not clean, follow the rebase routing before reporting completion.
15. When the stop condition is satisfied, use `zoo-report` before sending the final response.

Do not stop while code-review or code-uberreview findings remain unresolved. Do not stop before rerunning `code_reviewer` and code uberreview after fixes.

## Evidence

- Browser-visible behavior: screenshot evidence under `.tasks/<task>/evidence/` when a Bureau task is active; use video only when screenshots cannot prove behavior.
- CSV/file generation: include example generated files.
- CSV/file importing: include an example input file; add browser screenshots when there is a browser UI.
- Tested behavior: mention the 1-2 most representative test names in the `impl` report or final response.
- No repo or behavior changes: no evidence required.

## Bureau

- Use Bureau MCP for task/report/evidence operations.
- Do not create `spec.md`.
- Do not invent report filenames manually; Bureau MCP handles report names.
- On task start, the top-level agent writes exactly one `user-request` report before implementation begins.
- `user-request` report contents: user request/ticket context, exact original requested scope including original plan boundaries and non-goals, initial research summary, direct plan, expected validation, browser-testing need, and known risks.
- `impl` report is written by the top-level agent before the first code-review pass.
- `fixes` reports are written by the top-level agent before each re-review after code-review findings.
- `code-review` reports are written by `code_reviewer`; every Zoo Zero reviewer invocation must explicitly say no spec file exists.
- Code uberreview is run by the top-level agent with `zoo-uberreview` after normal code review approves and final-state validation has been checked or started by the top-level agent. Its per-instruction reviewer reports and combined report use descriptive `review-*` suffixes such as `review-simplicity`, `review-tests`, or `review-code`, and the combined report identifies the reviewed code and unresolved findings.
- Separate refactoring work is tracked in the native task list while active, and recorded durably in `impl` or `fixes` reports with the proposal path, refactoring commit, or reason it was placed before/after the current task.

## Stop Conditions

Stop only when one of these is true:

- final-state validation, `code_reviewer`, and code uberreview have no unresolved findings, no native refactoring task-list items remain open, required evidence is complete, docs are updated when needed, commit is complete or explicitly not applicable, `.zoo/task-finish.md` has been read and followed when present, `zoo-rebase` is clean unless task-finish skipped or replaced it, and no trackable Zoo workflow changes outside ignored task roots remain uncommitted. Only pre-existing unrelated changes may remain uncommitted. Before sending the final response for this completion condition, use `zoo-report`.
- A blocker prevents progress and cannot be resolved by research, implementation, validation, or code-review iteration.
- The user explicitly asks to pause or stop.
