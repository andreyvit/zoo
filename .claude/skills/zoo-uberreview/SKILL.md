---
name: zoo-uberreview
description: Run a super-comprehensive multi-agent review based on the repository instructions. Use after normal review; for code changes, enforce a single orchestrator-owned final-state validation gate and keep reviewer subagents focused on review instead of rerunning the same suites.
---

Read and follow `.zoo/zoo.md` if it exists.

Launch separate reviewer subagents for every file under .zoo/review/, provide those instructions to the reviewers. Ask for a VERY thorough review. Want: refactorings, fixes, improvements, omissions, changes. Respect the spirit and hard constraints of the user's request, but ok to question specific decisions if problematic. Categorize by P1 critical blockers (nothing else matters until fixed), P2 important/foundational changes (do first), P3 normal (do last). You're the final line of defense, do not miss anything.

Uber Review's job is to catch gaps from all angles; it is not permission to expand the current task until every possible security, debuggability, modularity, or simplicity gap is fixed inline. Require reviewers to separate findings that should be fixed in the current task from findings that should become proposals or separate subtasks.

Before or while launching reviewers, establish whether this is plan uberreview or code uberreview. For code uberreview, inspect the latest test, implementation, fixes, browser, and normal code-review reports for a `Final-state validation` entry. Accept it only when it says the relevant commands passed against the exact current code state with no later file changes. If that proof is missing or stale, run the needed validation once from the orchestrator; this may run in parallel with reviewer subagents. If validation fails, treat it as a blocking code-uberreview failure and route to fixes, even if reviewer subagents find nothing. For plan uberreview, record that runtime validation is not applicable unless the plan review explicitly required a concrete command.

Tell every reviewer the validation status in the prompt. For code uberreview, list the test or validation commands that already passed, or say that final-state validation is being handled once by the orchestrator. Explicitly tell reviewers not to rerun test suites or broad validation. Reviewer subagents may inspect tests, identify missing or weak coverage, and request specific extra validation, but they should not spend time running the same commands independently. If execution is needed to prove a finding, the reviewer reports the exact command or repro for the orchestrator to run once after the review batch.

Tell every reviewer to read and follow `.zoo/zoo.md` if it exists.

When reviewing code, ask agents to also read and follow `.zoo/coding.md`, `.zoo/testing.md` and `.zoo/codereview.md` if exists.

When reviewing plans, ask agents to also read and follow `.zoo/planning.md` and `.zoo/planreview.md` if exists.

Ask reviewers to use `zoo-refactoring` for findings that affect pre-existing code outside the current task or would materially expand scope: consequential cross-cutting gaps should become proposals, broad mundane refactors should become separate subtasks/commits, and small low-pollution fixes may stay in the current task.

Tell reviewers that findings in newly written task code should usually be fixed inline when the fix is small and natural. If the task adds a genuinely novel side of the system, a general foundation may be an appropriate separate subtask. If the task is using an existing common framework and closing the gap would require dropping that framework, replacing shared plumbing, or making a much larger project-wide change, prefer a proposal that improves the shared codebase over a local one-off.

Tell reviewers not to treat "only touches this file" as proof that a refactor belongs in the current task. If the cleaner local shape would make this code inconsistent with similar code that still uses the shared pattern, keep the current-task code simple and consistent, then propose the global refactor.

Reviewer subagents should write proposal files for proposal-worthy findings when their role permits proposal artifacts, mention the proposal path in their report, and put separate-subtask outcomes in a `Refactoring request` section; the orchestrator records proposals in `Refactorings` and handles workflow state.

Uberreview is part of the same task as the work being reviewed. Review report suffixes should be descriptive `review-*` labels based on the review instruction, such as `review-simplicity`, `review-tests`, or `review-correctness`.

After reviewers complete, analyze, combine and prioritize the findings into a single report. Treat a non-blocking proposal as a valid resolution path for the current task, but record why the proposal is needed, what it improves, and what alternatives exist.
