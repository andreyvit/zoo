---
name: zoo-zero
description: "Direct execution followed by review+fix iterations. Use only when explicitly requested."
---

# Zoo Zero

Zoo Zero is the smallest Zoo workflow. It uses no spec file, no planner, no plan review, and no subtask file. The top-level agent owns research, planning, implementation, tests, browser checks, docs, evidence, fixes, and final closeout.

## Modes

### Top-Level Mode

Use this workflow only when you are the main agent running the task end to end.

### Delegated Code-Review Mode

If the prompt says you are a delegated `code_reviewer`, execute exactly that review step, write the required `code-review` report, and stop. The prompt must explicitly say this is Zoo Zero and no spec file exists. Do not run Zoo Zero, spawn subagents, wait on subagents, or edit files.

## Workflow

- Do not create, update, or require a spec file. If one already exists, leave it untouched unless the user explicitly asks to edit it.
- Do not use `zoo-plan`, `planner`, or `plan_reviewer`.
- Do not create subtasks or planning-only reports.
- At Zoo Zero start, write a `user-request` Bureau report before implementation. It captures the user request/ticket context, initial research, direct plan, expected validation, browser-testing need, and known risks. This report replaces the spec/plan handoff.
- If the user request references a ticket, issue, PR, or similar work item, read it and treat its contents as part of the user request; direct user chat overrides ticket text when they conflict.
- Research and plan in the top-level context. Read relevant code, tests, docs, recent reports, tickets, production configuration, and production data when appropriate.
- Prefer direct, inspectable plans in your working context over formal artifacts.
- Split implementation mentally into small standalone functional slices, but do not write subtask files.
- Implement the smallest correct change that satisfies the user request.
- Write/update tests with production-quality code standards.
- Run relevant validation. Read and follow `.zoo/testing.md` if it exists.
- For browser-visible work, use the repo's browser/app harness mode when it exists and covers the flow. Read and follow `.zoo/browser.md` if it exists.
- Use Codex Browser Use for browser navigation, interaction, inspection, screenshots, and evidence capture. Use Codex Computer Use only when Browser Use cannot exercise the required browser-visible behavior.
- Update durable docs when the change creates behavior or learnings that should persist.

## Code Review Loop

1. Top-level agent writes the initial `user-request` report, then researches, plans, implements, tests, runs browser checks when needed, and updates docs.
2. Before the first code-review pass, write a compact `impl` report with Bureau MCP:
   - user request/ticket summary
   - changed files and behavior
   - tests/commands run
   - browser evidence or why browser testing was not needed
   - docs updates
   - known tradeoffs or risks
3. Run `code_reviewer`. The invocation prompt must explicitly say this is Zoo Zero, no spec file exists, and reviewer should use the `user-request`, `impl`, and later `fixes` reports plus the actual diff.
4. If `code_reviewer` reports findings, implement all findings.
5. Rerun relevant tests/browser checks after fixes.
6. Before each re-review after findings, write a compact `fixes` report with Bureau MCP:
   - code-review report addressed
   - fixes made or evidence that a finding was wrong
   - tests/commands rerun
   - browser evidence updates when relevant
   - remaining risks
7. If a finding appears wrong, record the concrete evidence in the next `fixes` report and rerun `code_reviewer`; the finding remains unresolved until `code_reviewer` accepts the evidence or the code is changed.
8. Repeat steps 3-7 until `code_reviewer` is happy and has no unresolved findings.
9. For repo changes, use the `commit` skill after review is happy unless the user explicitly asked not to commit.

Do not stop while code-review findings remain unresolved. Do not stop before rerunning `code_reviewer` after fixes.

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
- `user-request` report contents: user request/ticket context, initial research summary, direct plan, expected validation, browser-testing need, and known risks.
- `impl` report is written by the top-level agent before the first code-review pass.
- `fixes` reports are written by the top-level agent before each re-review after code-review findings.
- `code-review` reports are written by `code_reviewer`; every Zoo Zero reviewer invocation must explicitly say no spec file exists.

## Stop Conditions

Stop only when one of these is true:

- `code_reviewer` has no unresolved findings, required validation/evidence is complete, docs are updated when needed, and commit is complete or explicitly not applicable.
- A blocker prevents progress and cannot be resolved by research, implementation, validation, or code-review iteration.
- The user explicitly asks to pause or stop.
