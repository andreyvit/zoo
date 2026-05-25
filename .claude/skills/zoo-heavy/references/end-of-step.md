# Orchestrator End-of-Step Checklist

1. Verify every delegated subagent run produced its own report.
2. Treat all new reports since the last orchestrator pass as inputs.
3. Apply mechanical `spec.md` updates as single writer:
   - update `Execution memory` with compact implementation learnings from new reports
   - append `Decision log` entries from new reports when they record real alternatives or user overrides
   - append `Refactorings` entries for proposal paths reported by subagents and completed separate refactoring subtasks
   - if closing a subtask with repo or behavior changes, update that subtask's indented `Evidence:` lines by selecting the most relevant evidence pointers/artifacts from step reports and mapping each acceptance check to those pointers/artifacts
   - if closing a browser-impact subtask (`Browser impact: possible|direct`), require `browser_verifier` evidence and reject closeout when browser evidence is missing
   - when plan-review verdict is `approved` and the follow-up plan uberreview has no unresolved findings, update the active `(next)` subtask's indented `Plan:` pointer
   - when active subtask is complete, its `Evidence:` lines are sufficient or no evidence is required, and normal code review plus code uberreview have no unresolved findings, mark it `(done)`, choose one `(future)` as new `(next)` if one exists, and set indented `Plan: TBD` until next approved plan; leave substantive future-subtask revision to `planner`
4. If reports imply material changes to `User Input`, `Spec`, `Decision log`, `Open product and strategic questions`, `Refactorings`, or `Subtasks`, invoke `planner`, then `plan_reviewer`, then plan uberreview.
5. For any report `Refactoring request` or finding that affects pre-existing code outside the active subtask, use `zoo-refactoring` before routing it to fixes. If it routes to a proposal, record the proposal path in `Refactorings`; create the proposal with `zoo-proposal` only when the originating report supplied draft proposal content but no proposal file. Treat the finding as satisfied for the current task unless the refactoring is technically blocking. If it routes to a separate subtask, copy the originating report's subtask write-up into `spec.md`, choose before-vs-after placement, stash active work only when necessary, keep the refactoring commit separate, and record the completed refactoring in `Refactorings`.
6. If plan uberreview reports findings, route to `planner`, then `plan_reviewer`, then plan uberreview again.
7. If `code_reviewer` or code uberreview reports findings, route to fixes and validation when the fix is inside the approved plan and spec; otherwise invoke `planner`, then `plan_reviewer`, then plan uberreview before fixing.
8. If a subtask was marked `(done)` in this pass, run `docs_writer` to capture durable learnings before proceeding.
9. If `docs_writer` fails, stop and treat it as blocking; do not proceed to other steps.
10. If a subtask was marked `(done)` in this pass, you MUST then run `commit` before choosing/starting any next step.
11. If `commit` fails, stop and treat it as blocking; do not proceed to other steps.
12. Hard blocker gate: if any `[blocker]` question exists in `Open product and strategic questions` or new step reports, verify the agent researched the uncertainty first, using code, history, docs, production configuration, and production data when appropriate to identify the safest choice.
13. Verify the question still meets the high bar for mid-task blocking: no safe default and high-impact product, strategy, data, security, or compatibility consequences.
14. If it meets that bar, run `references/user-interview.md` immediately and do not choose or execute any other next step while any `[blocker]` remains unresolved.
15. If it does not meet that bar, invoke `planner` to document the best evidence-backed decision in `Decision log`, remove the blocker tag, and proceed.
16. After interview + spec updates, restart this checklist from step 1.
17. If active `(next)` has `Plan: TBD`, route immediately to `planner` (do not pause); `planner` must refresh the whole spec and future-subtask drafts from `Execution memory` before writing the next detailed plan.
18. If no active `(next)` exists and no `(future)` remains, route immediately to `planner` for a final task-completion check. Do not stop until a `plan` report declares `Full task status: complete`, `Reviewed: yes`, and `Closed out: yes`; if planner finds missing work, it must add a real `(next)` and plan it.
19. Decide next step only when no `[blocker]` remains:
    - spec or plan flawed -> loop back to `planner`/`plan_reviewer`/plan uberreview
    - implementation incomplete or review findings unresolved -> loop back to `test_writer`/`implementer`/`code_reviewer`/code uberreview
    - browser-impact checks/evidence incomplete -> route to `browser_verifier`
    - blocked or uncertain -> `problem_solver`
20. Continuous mode: once next step is chosen, start it immediately. Do not stop with a status summary unless blocked, a final planner report explicitly closed the full task, or the user explicitly asks to pause. When the final planner report closes the full task, use `zoo-report` before the final response.
