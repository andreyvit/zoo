---
name: zoo-lite
description: "Spec-based Zoo 2.1 workflow with subagent for research, review and browsing. Use only when explicitly requested."
---

# Zoo Lite

Read and follow `.zoo/zoo.md` if it exists.

Canonical artifact: `.tasks/<task>/spec.md` or `_tasks/<task>/spec.md`, unless the user explicitly asks to use a spec file under `.spec/`.

If a task root such as `.tasks/`, `_tasks/`, or a repo-specific alternate is ignored by git, every file under that root is workspace-only Zoo state. Never stage, force-add, commit, or push those files, including additions, modifications, or deletions of paths that were already tracked. Do not count ignored task-root files as uncommitted workflow changes.

## Modes

Decide which mode you are in before doing anything else.

### Top-level orchestrator mode

Use the full workflow below only when you are the main agent running the task end to end.

### Delegated single-step mode

If the prompt says you are a delegated researcher/reviewer/browser verifier, gives you one specific research, review, or browser-verification step, or tells you to write one report, then you are not the orchestrator. In that case:

- execute only the assigned research/review/browser-verification step
- make no functional code changes
- do not run the full Zoo Lite workflow
- do not spawn subagents
- do not wait for subagents
- do not do top-level closeout
- write exactly one report for your step, then stop

When there is any ambiguity, prefer delegated single-step mode over full-workflow mode.

## Spec Format

    # Title

    ## User Input

    <summary of changes to be made, 1-3 paragraphs>

    Why: <rationale for the changes if provided>

    Original requested scope: <exact scope of what the user explicitly asked for, including original plan boundaries and non-goals when the user started with a plan; do not include agent-added extras>

    Hard constraints: <anything that user said MUST be done or said is a HARD constraint>

    Soft preferences: <anything user said about the shape of the solution>

    Unknowns: <preferences about the solution that user is unsure about>

    Draft ideas to adapt with common sense: <anything that user specified about implementation that was not explicitly mentioned with MUST nor as a HARD constraint -- these are soft implementation preferences and soft ideas>


    ## Spec

    <a detailed top-to-bottom spec on how the solution looks and is implemented, as an itemized list grouped into subheadings, order these MOST CONSEQUENTIAL/VISIBLE to LEAST CONSEQUENTIAL/VISIBLE, group into subheadings by subfeature/subarea, sort those subheadings too from MOST CONSEQUENTIAL/VISIBLE to LEAST CONSEQUENTIAL/VISIBLE, mention everything that must be done as part of implementation>


    ## Decision log

    <when considering multiple alternatives, mention the decision, the other alternatives rejected, and a very brief why>


    ## Dependency Changes

    <changes to dependency sets, dependency versions, and code in modifiable dependency checkouts, with rationale and source report/commit when known. Write `None` when there are no dependency changes.>


    ## Open product and strategic questions

    <list only the most consequential unclear questions that user should decide -- important product decisions, strategy-level decisions, and super consequential tactical decisions. Ask these during initial planning whenever possible. After implementation starts, research the uncertainty first: inspect code, history, docs, production configuration, and production data when appropriate; then prefer documenting a reasonable evidence-backed decision in Decision log and proceeding unless the uncertainty is truly unsafe to resolve without the user. Explain the dilemma and include technical and product consequences of each choice.>


    ## Execution memory

    <orchestrator updates this section with compact learnings from each report, preserving key implementation path details for future runs>


    ## Refactorings

    <Proposals and refactorings from this task.>

    - Proposal: `.proposals/YYYYMMDD-example.md` - <finding>
    - Done: <subtask/commit/report> - <what changed>


    ## Subtasks

    <detailed plan for one next task, plus lightweight current-best-guess outlines or draft plans for future tasks. This is not a waterfall: future task details are drafts and must be re-planned before that task starts.>

    - (next) <title>
      - Acceptance: <outcome>
      - Browser impact: possible, <flow list>
      - Plan: <NNN-plan.md|TBD>
      - Evidence: TBD

    - (future) <title>

    - (future) <title>

## Workflow

- This section is for top-level orchestrator mode only.
- This workflow is opt-in. Do not create/use Zoo Lite for routine small tasks unless the user asks.
- Start or switch tasks with Bureau MCP tools.
- Use the spec file as the source of truth.
- If the user explicitly asks to use a spec file under `.spec/`, that file overrides the default Bureau spec path and becomes the spec source of truth. Keep Bureau for task/report/evidence operations.
- If the spec file does not exist, create it from the user request during the first `zoo-plan` pass.
- `User Input` records what the user asked for and must be updated when the user clarifies, corrects, or overrides direction. It preserves the exact original scope for closeout; do not backfill agent-added extras into it.
- If the user request references a ticket, issue, PR, or similar work item, its contents are part of the user request. Read it before planning and capture its hard constraints, soft preferences, unknowns, and draft ideas in `User Input`; direct user chat overrides ticket text when they conflict.
- If the user asks for revisions or follow-up changes to a prior Zoo Lite run, continue in the same Bureau task and same spec file. Do not start a new task/spec file unless the user explicitly asks. Update `User Input`, reopen planning by adding or promoting a real `(next)` revision subtask, and preserve prior completed subtasks/evidence.
- Only delegate review, research, and browser verification work. The top-level orchestrator does final planning synthesis, tests, implementation, docs, status updates, and commits directly.
- The `zoo-uberreview` gates are top-level orchestrator work, not delegated single-step reviews, because the skill launches multiple reviewer subagents itself.

If the spec file has no active `(next)` subtask because planning has not started, run `zoo-plan` to define the first real `(next)` implementation subtask, draft future subtasks, and write the active-subtask plan for that real work. If all known subtasks are `(done)` and no `(future)` remains, run `zoo-plan` as the final task-completion check instead. Do not create a planning-only subtask.

Planning principles:

- Keep exactly one active execution target while the task is in progress: `(next)`.
- Each completed subtask must keep the system shippable and tested; browser-impact work must include browser verification.
- Prefer smaller subtasks. Split a standalone functional slice into its own subtask when it either provides independent user value or has complex implementation that can be tested on its own; avoid splitting purely by file/layer when the slice cannot be validated independently.
- Zoo Lite is not a waterfall. Plan the active `(next)` subtask deeply; future subtasks may include lightweight draft plans or current-best-guess notes, but avoid spending much time on details before promotion.
- Use what was learned in completed subtasks, reports, tests, browser verification, and code review to re-plan the next subtask and adjust future subtask drafts before promoting them.
- Future subtasks are scope boundaries and hypotheses; any tactical notes on them are provisional drafts.
- When planning, implementation, or review finds work affecting pre-existing code outside the active subtask, use `zoo-refactoring`: consequential cross-cutting changes become proposals requiring human approval, broad mundane refactors become separate subtasks/commits before or after the current subtask depending on whether they technically block it, and small low-pollution edits stay in the current subtask.
- Delegated researchers, browser verifiers, and reviewers that classify a finding as proposal-worthy or separate-subtask work must write the proposal path or a `Refactoring request` in their report; the orchestrator owns recording proposals in `Refactorings`, editing the spec file, ordering subtasks, stashing, routing, and commit separation.
- Before coding each subtask, the orchestrator uses the `zoo-plan` skill to update the whole spec and write the detailed tactical HOW for the active `(next)` subtask.
- As part of each non-trivial planning step, run one or more read-only researcher agents for bounded codebase questions. Fold their findings into the spec updates and `plan` report before sending the plan to `plan_reviewer`.
- After each `zoo-plan` pass, run `plan_reviewer`; when it reports `Verdict: approved`, run plan uberreview with `zoo-uberreview`. Repeat planning, plan review, and plan uberreview until both review layers have no unresolved findings.
- During the initial planning pass, collect all consequential unclear user questions and run one user interview before implementation starts.
- After implementation starts, research uncertainty before blocking: inspect code, history, docs, production configuration, and production data when appropriate to collect enough evidence for the safest decision. Then use common sense, document the decision in `Decision log`, and proceed unless the choice is a high-impact product/strategy decision or super consequential tactical decision with no safe default.
- `[blocker]` questions in `Open product and strategic questions` or new reports are a hard gate only when that high bar is met: the orchestrator must run user interview immediately and must not continue implementation until blockers are resolved.
- Default execution mode is continuous: after a subtask is completed, update docs when needed, commit, then continue into the next routed step automatically. Do not stop between subtasks unless blocked, a mandatory step fails, the user asks to pause, or a final `zoo-plan` report explicitly declares `Full task status: complete`, `Reviewed: yes`, and `Closed out: yes`. When the final `zoo-plan` report closes the full task, start final closeout by reading `.zoo/task-finish.md` if it exists; those instructions take priority over this skill, including whether to run `zoo-rebase`. Unless task-finish overrides it, run `zoo-rebase`, then use `zoo-report` before sending the final response.

## Subtask Loop

Execute this loop for the active `(next)` subtask:

Before planning a newly active `(next)` subtask, read and follow `.zoo/subtask-start.md` if it exists.

1. Top-level orchestrator: use the `zoo-plan` skill, run one or more read-only researcher agents for bounded codebase questions, update the whole spec from user input/codebase context/execution memory, keep future subtasks as lightweight current-best-guess drafts, and write the detailed tactical HOW for the active `(next)` subtask in a `plan` report.
2. `plan_reviewer`: review both the overall spec and the active-subtask plan, then issue `approved` or `revise`.
3. Top-level orchestrator: after `plan_reviewer` approves, use `zoo-uberreview` to run an uberreview of the approved plan. If uberreview reports findings, repeat steps 1-3 until normal plan review and plan uberreview both have no unresolved findings.
4. Top-level orchestrator: write/update tests, define Browser test intent, execute the implementation, run non-browser validation, update docs, and record evidence. Write a compact `impl` report when there are repo or behavior changes so review has a concrete implementation trail.
5. `browser_verifier`: when browser testing is required, run browser checks with the harness in-page browser tool (Codex: Codex Browser Use; Claude Code: Chrome extension MCP), use the OS-level automation fallback (Codex: Codex Computer Use) only when needed, and produce screenshot/video evidence in a `browser-verify` report.
6. `code_reviewer`: review for bugs, regressions, and missing tests.
7. Top-level orchestrator: after `code_reviewer` approves, check the latest `Final-state validation` entries from implementation, browser verification, code review, and any fixes reports. If relevant passing validation is missing or stale for the current code state, run it once yourself before or in parallel with code uberreview. Use `zoo-uberreview` to review the code written for the subtask, telling reviewers that validation has passed or is orchestrator-owned and that they must not rerun broad suites. If validation fails or uberreview reports findings, fix them, rerun relevant validation, rerun `code_reviewer`, then rerun code uberreview. Do not complete the subtask until final-state validation, normal code review, and code uberreview all have no unresolved findings.
8. Top-level orchestrator, no report required after this: follow `references/end-of-step.md`, enforce blocker gate, then choose next step.

If blocked, the top-level orchestrator investigates and records the outcome in the spec file or an implementation report. Besides researcher agents, `browser_verifier`, `plan_reviewer`, and `code_reviewer`, do not introduce delegated implementation/test/docs/problem-solving agents.

Browser-impact rule:

- Any subtask that touches or could potentially affect a user in-browser flow is browser-impact work.
- Browser-impact work MUST be tested in browser before the subtask is marked `(done)`.
- In Zoo Lite, browser testing is delegated to `browser_verifier` when required so browser state, screenshots, and exploratory details stay out of the main context.
- Browser verification should use the repo's browser/app harness mode when it exists and covers the needed flow. Read and follow `.zoo/browser.md` if it exists.
- Browser verification should use the harness in-page browser tool (Codex: Codex Browser Use; Claude Code: Chrome extension MCP) for navigation, interaction, inspection, screenshots, and evidence capture. Use the OS-level automation fallback (Codex: Codex Computer Use) only when the in-page tool cannot exercise the required browser-visible behavior.
- Browser-impact work MUST include screenshot evidence under `.tasks/<task>/evidence/`.
- Video evidence is required when screenshots are insufficient (animation, transient states, timing-sensitive behavior).

Quality bar:

- `zoo-plan`: near-perfect User Input capture, top-to-bottom `Spec`, future-subtask current-best-guess drafts, active-subtask acceptance, and tactical HOW in the `plan` report before coding.
- `plan_reviewer`/`browser_verifier`/`code_reviewer`: if a concern is not addressed by the current contract/plan, request revision so the planning or implementation step can respond; only allow proceeding when the review explicitly states why that concern can be ignored.
- Plan uberreview findings reopen `zoo-plan`, then `plan_reviewer`, then plan uberreview again.
- Code uberreview findings and final-state validation failures reopen implementation/fixes and validation, then `code_reviewer`, then code uberreview again.
- The top-level orchestrator owns the implementation and must not defer omissions that can be resolved now.
- For repo-specific architecture, UI, testing, review, and docs guidance, read the applicable `.zoo/*.md` file if it exists.
- A subtask is not fully complete if trackable workflow changes outside ignored task roots are still uncommitted. The full task is not fully complete while any trackable Zoo workflow changes outside ignored task roots remain uncommitted; only changes that were already present before the workflow started and are unrelated may remain uncommitted, and they must be identified in the final report.
- Final task closeout starts by reading `.zoo/task-finish.md` if it exists, immediately after all workflow commits are complete. Instructions in that file take priority over this skill's closeout instructions, including skipping or replacing `zoo-rebase`. Unless task-finish overrides it, run `zoo-rebase`, then run `zoo-report`.

Language rule:

- Use straightforward, down-to-earth language.
- Avoid vague high-level wording and buzzwords.
- Prefer concrete statements with behavior, file paths, commands, and measurable outcomes.
- If a sentence sounds like strategy-speak, rewrite it in plain language.
- Write so a teammate can understand it on first read without translation.

Be explicit about transitions, e.g. `Starting zoo-plan on <subtask>`, `Starting researcher on <question>`, `Starting plan uberreview on <subtask>`, `Starting browser_verifier on <subtask>`, `Starting code_reviewer on <subtask>`, or `Starting code uberreview on <subtask>`.

Only the top-level orchestrator may delegate. A delegated researcher, browser verifier, or reviewer must never delegate again.

When the top-level orchestrator launches a delegated research, browser-verification, or review step, the prompt must explicitly state that the recipient is a delegated single-step agent and must execute exactly one assigned step itself. The prompt must also explicitly forbid running the full Zoo Lite workflow, spawning subagents, waiting on subagents, and making functional code changes.

Thread hygiene:

- Close completed researcher/browser-verifier/reviewer threads immediately after their report is written and results are consumed.
- Keep only currently active researcher/browser-verifier/reviewer threads open to avoid agent thread-limit stalls.

Reference checklists:

- `references/end-of-step.md`: mandatory for the orchestrator at end of every step loop.
- `references/user-interview.md`: mandatory during initial planning when consequential user questions exist, and later only when a `[blocker]` question meets the high bar in `Open product and strategic questions` or new reports.

## Bureau

- Task root: `.tasks/`
- Default spec path: `.tasks/<task>/spec.md`
- Explicit user-requested `.spec/...` files override the default spec path for spec reads/writes only.
- Evidence dir: `.tasks/<task>/evidence/`
- If the task root is ignored by git, it is not commit material. Use Bureau reports and evidence there, but never stage, force-add, commit, or push files under that root.
- Use Bureau MCP for all task and report operations; do not use shell commands for these.
- Do not list task/report directories or invent sequential report filenames manually; Bureau MCP handles that.
- Before each planning, implementation, browser-verification, or review phase, call `mcp__bureau__current_task` to get the current task slug, report directory, and report filenames.
- When launching a delegated subagent, include the report suffix it must use.

Switching:

- Start a new task with `mcp__bureau__start_new_task({task_slug})`.
- Switch tasks with `mcp__bureau__switch_task({task_slug})`.
- Use `mcp__bureau__list_recent_tasks()` when you need to find the exact recent task slug.
- Use `mcp__bureau__current_task()` to inspect the active task.

Report conventions:

- After a `zoo-plan` pass, the orchestrator calls `mcp__bureau__start_new_report_file({suffix: "plan"})` if the skill did not already create a plan report, then writes or confirms a `plan` report.
- `plan` report includes `Subtask: <exact active subtask title>`, a brief note on spec changes or "none", and detailed tactical HOW for the active `(next)` subtask.
- `research` reports may be written by planning researcher agents; each report should answer one bounded codebase question with concrete files/functions/tests and note remaining uncertainty. Researcher reports are planning inputs, not separate subtask-loop steps, and should collect facts rather than propose implementation plans unless explicitly asked.
- `plan-review` report is written by `plan_reviewer` and includes `Plan: <plan-report-file>` and `Verdict: approved|revise`.
- `impl` report is written by the orchestrator when implementation changes repo behavior or files; it includes changed files, tests/commands run, Browser test intent, docs updates, `Dependency changes` with added/removed/updated dependencies, version or dependency-set changes, code changes in modifiable dependency checkouts or `none` plus rationale, `Evidence produced`, and `Final-state validation` with commands run after the last file change, result on the exact state left, whether any file changed afterward, and the command still needed when validation is missing or stale.
- `browser-verify` report is written by `browser_verifier` when browser testing is required; it includes browser run results, screenshot/video artifacts, Browser Use/Computer Use notes, `Evidence produced`, and `Final-state validation` for the checked browser state.
- `code-review` report is written by `code_reviewer` and includes `Evidence produced` with pointers/artifact paths and one line per item saying what it proves, plus `Final-state validation` saying whether prior reports prove the exact reviewed state, which commands the reviewer ran if any, and what command remains for the orchestrator when validation is missing or stale.
- Uberreview is run by the orchestrator with `zoo-uberreview` after approved plan review and approved code review. Its per-instruction reviewer reports and combined reports use descriptive `review-*` suffixes such as `review-simplicity`, `review-tests`, or `review-plan`, and the combined reports identify whether they reviewed the plan or code plus any unresolved findings.

Evidence flow:

- Reports are provenance. They are not completion evidence by themselves.
- Completion evidence lives on the relevant `Subtasks` item as indented `Evidence:` lines.
- The orchestrator closes a subtask and updates that subtask's `Evidence:` lines when evidence is required.
- The orchestrator pulls candidate evidence pointers/artifacts from reports and direct outputs:
  - representative test names and test file pointers when useful
  - implementation pointers and validation outputs
  - `browser_verifier` browser run results, screenshot/video artifacts, and Browser Use/Computer Use notes
  - docs updates that preserve useful learnings for future work
  - code review findings and regression checks
  - code uberreview combined report and any blocking findings or accepted non-actionable notes
- The orchestrator picks the best, most relevant evidence pieces and maps each acceptance check to those artifacts.
- If evidence is missing for any acceptance check, the orchestrator must produce it before marking the subtask done.
- Before marking a code subtask done, the orchestrator must have a non-stale passing `Final-state validation` entry for the current code state or must run that validation once itself. Missing, stale, or failing final-state validation routes back to fixes/validation.

Evidence type rules:

- If a subtask affects anything visible in the browser, completion evidence is browser screenshots. Use video only when screenshots cannot prove the behavior.
- If a subtask affects CSV or file generation/export, completion evidence includes example generated files under `.tasks/<task>/evidence/`.
- If a subtask affects CSV or file importing/uploading, completion evidence includes an example file to import under `.tasks/<task>/evidence/`; add browser screenshots of the import process when there is a browser UI.
- If a subtask is covered by tests, completion evidence lists the 1-2 most representative test names directly under the subtask's `Evidence:` lines; do not create a separate evidence file just to store test names.
- If a subtask has no repo changes and no behavior changes, no completion evidence is required.

Backlog routing:

- Mundane cross-cutting refactoring we can do immediately after the current subtask -> add future subtask to spec.
- Mundane cross-cutting refactoring we discover we must do before the current subtask -> add subtask to spec and make it next, make current task future.
- Significant cross-cutting change needing human approval -> use `zoo-proposal` and record the proposal path in `Refactorings`.
- Follow-up product ideas -> `.docs/TODO-ideas.md`.

## Spec Maintenance

Use exactly the sections from `Spec Format`, in that order.

Section guidance:

- `User Input`: preserve the user's request separately from agent interpretation. Update it whenever the user clarifies, corrects, or overrides direction.
  - `Original requested scope`: preserve the exact requested outcomes, boundaries, non-goals, and original user-supplied plan. Keep agent-added extras out so `zoo-report` can compare final work against requested scope.
  - If the user references a ticket, issue, PR, or similar work item, treat its contents as part of the user request and preserve the relevant details here.
  - Direct user chat overrides ticket text when they conflict.
  - `Hard constraints`: only user-stated MUST/HARD constraints.
  - `Soft preferences`: user-stated preferences about solution shape.
  - `Unknowns`: preferences or decisions the user is unsure about.
  - `Draft ideas to adapt with common sense`: user-suggested implementation ideas that were not stated as MUST/HARD constraints.
  - Mark completed itemized lines with `(done)` immediately after the bullet marker.
- `Spec`: the working contract for the solution.
  - Write an itemized, top-to-bottom description of what the implemented solution will look like.
  - Group by subfeature/subarea with `###` headings.
  - Order headings and bullets from most consequential/visible to least consequential/visible.
  - Include concrete implementation surface when it matters for review: packages, templates, routes, structs, fields, permissions, jobs, migrations, and integration points.
  - Mark completed itemized lines with `(done)` immediately after the bullet marker, e.g. `- (done) Add Foo feature package`.
  - Avoid filler, background prose, generic risks, and restating the request in longer words.
- `Decision log`: record real alternatives considered and the chosen path with a brief reason.
  - Mark user overrides as `(USER INPUT)` and include the user's rationale when provided.
- `Dependency Changes`: record added, removed, or updated dependencies, dependency version/set changes, and code changes in modifiable dependency checkouts.
  - Include the rationale and source report/commit when known.
  - Write `None` when no dependency changes are planned or made.
- `Open product and strategic questions`: only questions the user should decide.
  - Ask only the most consequential unclear questions: important product decisions, strategy-level decisions, and super consequential tactical decisions.
  - During initial planning, identify and ask all of these questions in one batch when possible.
  - Do not punt minor implementation decisions to the user.
  - After implementation starts, research the uncertainty first: inspect code, history, docs, production configuration, and production data when appropriate to identify the safest choice.
  - Prefer documenting a reasonable, evidence-backed decision in `Decision log` and proceeding.
  - Mark a later question `[blocker]` only when there is no safe default and proceeding could cause a high-impact product, strategy, data, security, or compatibility mistake.
  - Explain the dilemma and the product/technical consequences of each choice.
- `Execution memory`: compact notes the orchestrator updates from reports.
  - Preserve key implementation learnings, registration points, tricky areas, tests added, and known follow-up risk.
  - Use this memory to re-plan the next subtask and future subtasks after each completed subtask.
  - Keep this section brief and organized; do not paste report summaries.
- `Refactorings`: proposals and refactorings from this task.
  - Include proposal entries as ``- Proposal: `<proposal path>` - <finding>``
  - Include completed refactoring entries as `- Done: <subtask/commit/report> - <what changed>`
  - Proposal entries are not future subtasks. Do not route back to them during the current task unless marked blocking pending approval.
- `Subtasks`: detailed plan for one active next task plus lightweight current-best-guess outlines or draft plans for future tasks.
  - exactly one `(next)` while the task is still in progress
  - plan only the active `(next)` subtask in detail
  - split standalone functional slices into separate subtasks when they have independent user value or complex independently testable implementation
  - prefer smaller subtasks; avoid broad catch-all subtasks that combine multiple independently valuable or independently testable slices
  - future subtask plans may include brief draft notes, but do not over-invest before promotion
  - primary line contains only status and title
  - `(next)` includes indented `Acceptance:`, `Browser impact:`, `Plan:`, and `Evidence:` lines
  - `(future)` items are outlines or current-best-guess drafts and may be title-only until promoted
  - before promoting a `(future)` item to `(next)`, re-plan it using `Execution memory` and what the previous subtasks learned
  - `Browser impact:` uses `none|possible|direct`; for `possible|direct`, include the flow list on the same line
  - completed items include indented `Evidence:` lines unless no evidence is required
  - keep subtask text outcome-oriented; detailed tactical HOW belongs in plan reports

Spec vs plan boundary:

- The spec file is durable whole-task planning: user input, product/behavior contract, decisions, dependency changes, execution memory, refactorings, subtask status, and lightweight future-subtask drafts.
- Detailed tactical HOW for the active `(next)` subtask lives in `plan` / `plan-review` reports.
- Material spec edits go through `zoo-plan`, `plan_reviewer`, and plan uberreview.
- The orchestrator is the mechanical single writer for status/log updates and may apply review-approved spec corrections directly.

Evidence gate:

- A subtask cannot be marked `(done)` until its `Evidence:` lines contain the required completion evidence, unless the subtask has no repo changes and no behavior changes.
- A subtask with one or more `[blocker]` unresolved cannot be marked `(done)`.
- Reports are provenance; they are not sufficient evidence by themselves.
- Subtask evidence that only links to reports is invalid.
- Minimum subtask evidence coverage:
  - each non-trivial acceptance check maps to the matching evidence type above
  - browser-visible behavior maps to screenshot artifacts captured by `browser_verifier` with the harness in-page browser tool, or with the OS-level automation fallback when necessary
  - CSV/file generation maps to example generated files
  - CSV/file importing maps to an example input file and browser screenshots when the import has a browser UI
  - tested behavior maps to 1-2 representative test names written directly in the evidence list

Clarity gate:

- Vague or abstract wording is a quality failure.
- `plan_reviewer` should request revision when wording is hard to understand on first read.
