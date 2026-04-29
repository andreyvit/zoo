---
name: zoo-lite
description: "Spec-based Zoo 2.1 workflow with subagent for research, review and browsing. Use only when explicitly requested."
---

# Zoo Lite

Canonical artifact: `.tasks/<task>/spec.md` or `_tasks/<task>/spec.md`, unless the user explicitly asks to use a spec file under `.spec/`.

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

    Hard constraints: <anything that user said MUST be done or said is a HARD constraint>

    Soft preferences: <anything user said about the shape of the solution>

    Unknowns: <preferences about the solution that user is unsure about>

    Draft ideas to adapt with common sense: <anything that user specified about implementation that was not explicitly mentioned with MUST nor as a HARD constraint -- these are soft implementation preferences and soft ideas>


    ## Spec

    <a detailed top-to-bottom spec on how the solution looks and is implemented, as an itemized list grouped into subheadings, order these MOST CONSEQUENTIAL/VISIBLE to LEAST CONSEQUENTIAL/VISIBLE, group into subheadings by subfeature/subarea, sort those subheadings too from MOST CONSEQUENTIAL/VISIBLE to LEAST CONSEQUENTIAL/VISIBLE, mention everything that must be done as part of implementation>


    ## Decision log

    <when considering multiple alternatives, mention the decision, the other alternatives rejected, and a very brief why>


    ## Open product and strategic questions

    <list only the most consequential unclear questions that user should decide -- important product decisions, strategy-level decisions, and super consequential tactical decisions. Ask these during initial planning whenever possible. After implementation starts, research the uncertainty first: inspect code, history, docs, production configuration, and production data when appropriate; then prefer documenting a reasonable evidence-backed decision in Decision log and proceeding unless the uncertainty is truly unsafe to resolve without the user. Explain the dilemma and include technical and product consequences of each choice.>


    ## Execution memory

    <orchestrator updates this section with compact learnings from each report, preserving key implementation path details for future runs>


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
- `User Input` records what the user asked for and must be updated when the user clarifies, corrects, or overrides direction.
- If the user request references a ticket, issue, PR, or similar work item, its contents are part of the user request. Read it before planning and capture its hard constraints, soft preferences, unknowns, and draft ideas in `User Input`; direct user chat overrides ticket text when they conflict.
- If the user asks for revisions or follow-up changes to a prior Zoo Lite run, continue in the same Bureau task and same spec file. Do not start a new task/spec file unless the user explicitly asks. Update `User Input`, reopen planning by adding or promoting a real `(next)` revision subtask, and preserve prior completed subtasks/evidence.
- Only delegate review, research, and browser verification work. The top-level orchestrator does final planning synthesis, tests, implementation, docs, status updates, and commits directly.

If the spec file has no active `(next)` subtask because planning has not started, run `zoo-plan` to define the first real `(next)` implementation subtask, draft future subtasks, and write the active-subtask plan for that real work. If all known subtasks are `(done)` and no `(future)` remains, run `zoo-plan` as the final task-completion check instead. Do not create a planning-only subtask.

Planning principles:

- Keep exactly one active execution target while the task is in progress: `(next)`.
- Each completed subtask must keep the system shippable and tested; browser-impact work must include browser verification.
- Prefer smaller subtasks. Split a standalone functional slice into its own subtask when it either provides independent user value or has complex implementation that can be tested on its own; avoid splitting purely by file/layer when the slice cannot be validated independently.
- Zoo Lite is not a waterfall. Plan the active `(next)` subtask deeply; future subtasks may include lightweight draft plans or current-best-guess notes, but avoid spending much time on details before promotion.
- Use what was learned in completed subtasks, reports, tests, browser verification, and code review to re-plan the next subtask and adjust future subtask drafts before promoting them.
- Future subtasks are scope boundaries and hypotheses; any tactical notes on them are provisional drafts.
- Before coding each subtask, the orchestrator uses the `zoo-plan` skill to update the whole spec and write the detailed tactical HOW for the active `(next)` subtask.
- As part of each non-trivial planning step, run one or more read-only researcher agents for bounded codebase questions. Fold their findings into the spec updates and `plan` report before sending the plan to `plan_reviewer`.
- After each `zoo-plan` pass, run `plan_reviewer`; repeat planning and review until `plan_reviewer` reports `Verdict: approved`.
- During the initial planning pass, collect all consequential unclear user questions and run one user interview before implementation starts.
- After implementation starts, research uncertainty before blocking: inspect code, history, docs, production configuration, and production data when appropriate to collect enough evidence for the safest decision. Then use common sense, document the decision in `Decision log`, and proceed unless the choice is a high-impact product/strategy decision or super consequential tactical decision with no safe default.
- `[blocker]` questions in `Open product and strategic questions` or new reports are a hard gate only when that high bar is met: the orchestrator must run user interview immediately and must not continue implementation until blockers are resolved.
- Default execution mode is continuous: after a subtask is completed, update docs when needed, commit, then continue into the next routed step automatically. Do not stop between subtasks unless blocked, a mandatory step fails, the user asks to pause, or a final `zoo-plan` report explicitly declares `Full task status: complete`, `Reviewed: yes`, and `Closed out: yes`.

## Subtask Loop

Execute this loop for the active `(next)` subtask:

1. Top-level orchestrator: use the `zoo-plan` skill, run one or more read-only researcher agents for bounded codebase questions, update the whole spec from user input/codebase context/execution memory, keep future subtasks as lightweight current-best-guess drafts, and write the detailed tactical HOW for the active `(next)` subtask in a `plan` report.
2. `plan_reviewer`: review both the overall spec and the active-subtask plan, then issue `approved` or `revise`. Repeat steps 1-2 until approved.
3. Top-level orchestrator: write/update tests, define Browser test intent, execute the implementation, run non-browser validation, update docs, and record evidence. Write a compact `impl` report when there are repo or behavior changes so review has a concrete implementation trail.
4. `browser_verifier`: when browser testing is required, run browser checks with Codex Browser Use, use Codex Computer Use only when needed, and produce screenshot/video evidence in a `browser-verify` report.
5. `code_reviewer`: review for bugs, regressions, and missing tests.
6. Top-level orchestrator, no report required after this: follow `references/end-of-step.md`, enforce blocker gate, then choose next step.

If blocked, the top-level orchestrator investigates and records the outcome in the spec file or an implementation report. Besides researcher agents, `browser_verifier`, `plan_reviewer`, and `code_reviewer`, do not introduce delegated implementation/test/docs/problem-solving agents.

Browser-impact rule:

- Any subtask that touches or could potentially affect a user in-browser flow is browser-impact work.
- Browser-impact work MUST be tested in browser before the subtask is marked `(done)`.
- In Zoo Lite, browser testing is delegated to `browser_verifier` when required so browser state, screenshots, and exploratory details stay out of the main context.
- Browser verification should use the repo's browser/app harness mode when it exists and covers the needed flow. Read and follow `.zoo/browser.md` if it exists.
- Browser verification should use Codex Browser Use for navigation, interaction, inspection, screenshots, and evidence capture. Use Codex Computer Use only when Browser Use cannot exercise the required browser-visible behavior.
- Browser-impact work MUST include screenshot evidence under `.tasks/<task>/evidence/`.
- Video evidence is required when screenshots are insufficient (animation, transient states, timing-sensitive behavior).

Quality bar:

- `zoo-plan`: near-perfect User Input capture, top-to-bottom `Spec`, future-subtask current-best-guess drafts, active-subtask acceptance, and tactical HOW in the `plan` report before coding.
- `plan_reviewer`/`browser_verifier`/`code_reviewer`: if a concern is not addressed by the current contract/plan, request revision so the planning or implementation step can respond; only allow proceeding when the review explicitly states why that concern can be ignored.
- The top-level orchestrator owns the implementation and must not defer omissions that can be resolved now.
- For repo-specific architecture, UI, testing, review, and docs guidance, read the applicable `.zoo/*.md` file if it exists.

Language rule:

- Use straightforward, down-to-earth language.
- Avoid vague high-level wording and buzzwords.
- Prefer concrete statements with behavior, file paths, commands, and measurable outcomes.
- If a sentence sounds like strategy-speak, rewrite it in plain language.
- Write so a teammate can understand it on first read without translation.

Be explicit about transitions, e.g. `Starting zoo-plan on <subtask>`, `Starting researcher on <question>`, `Starting browser_verifier on <subtask>`, or `Starting code_reviewer on <subtask>`.

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
- `impl` report is written by the orchestrator when implementation changes repo behavior or files; it includes changed files, tests/commands run, Browser test intent, docs updates, and `Evidence produced`.
- `browser-verify` report is written by `browser_verifier` when browser testing is required; it includes browser run results, screenshot/video artifacts, Browser Use/Computer Use notes, and `Evidence produced`.
- `code-review` report is written by `code_reviewer` and includes `Evidence produced` with pointers/artifact paths and one line per item saying what it proves.

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
- The orchestrator picks the best, most relevant evidence pieces and maps each acceptance check to those artifacts.
- If evidence is missing for any acceptance check, the orchestrator must produce it before marking the subtask done.

Evidence type rules:

- If a subtask affects anything visible in the browser, completion evidence is browser screenshots. Use video only when screenshots cannot prove the behavior.
- If a subtask affects CSV or file generation/export, completion evidence includes example generated files under `.tasks/<task>/evidence/`.
- If a subtask affects CSV or file importing/uploading, completion evidence includes an example file to import under `.tasks/<task>/evidence/`; add browser screenshots of the import process when there is a browser UI.
- If a subtask is covered by tests, completion evidence lists the 1-2 most representative test names directly under the subtask's `Evidence:` lines; do not create a separate evidence file just to store test names.
- If a subtask has no repo changes and no behavior changes, no completion evidence is required.

Backlog routing:

- Refactoring/cleanup we can do immediately -> add future subtask to spec.
- Refactoring/cleanup we discover we should do before current task -> add subtask to spec and make it next, make current task future.
- Follow-up product ideas -> `.docs/TODO-ideas.md`.
- Follow-up larger refactoring/cleanup we should not do immediately or lightly -> `.docs/TODO-refactoring.md`.

## Spec Maintenance

Use exactly the sections from `Spec Format`, in that order.

Section guidance:

- `User Input`: preserve the user's request separately from agent interpretation. Update it whenever the user clarifies, corrects, or overrides direction.
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

- The spec file is durable whole-task planning: user input, product/behavior contract, decisions, execution memory, subtask status, and lightweight future-subtask drafts.
- Detailed tactical HOW for the active `(next)` subtask lives in `plan` / `plan-review` reports.
- Material spec edits go through `zoo-plan` and `plan_reviewer`.
- The orchestrator is the mechanical single writer for status/log updates and may apply review-approved spec corrections directly.

Evidence gate:

- A subtask cannot be marked `(done)` until its `Evidence:` lines contain the required completion evidence, unless the subtask has no repo changes and no behavior changes.
- A subtask with one or more `[blocker]` unresolved cannot be marked `(done)`.
- Reports are provenance; they are not sufficient evidence by themselves.
- Subtask evidence that only links to reports is invalid.
- Minimum subtask evidence coverage:
  - each non-trivial acceptance check maps to the matching evidence type above
  - browser-visible behavior maps to screenshot artifacts captured by `browser_verifier` with Codex Browser Use or Codex Computer Use when necessary
  - CSV/file generation maps to example generated files
  - CSV/file importing maps to an example input file and browser screenshots when the import has a browser UI
  - tested behavior maps to 1-2 representative test names written directly in the evidence list

Clarity gate:

- Vague or abstract wording is a quality failure.
- `plan_reviewer` should request revision when wording is hard to understand on first read.
