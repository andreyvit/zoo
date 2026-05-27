---
name: zoo-code-review
description: "Review Zoo implementation changes for correctness, regressions, evidence, simplicity, and missing tests. Use only when explicitly requested."
---

# Zoo Code Review

Read and follow `.zoo/zoo.md` if it exists.

Use this when reviewing implementation changes in a Zoo workflow.

Goal: find correctness, regression, and coverage issues before merge.

Read and follow `.zoo/coding.md`, `.zoo/testing.md` and `.zoo/codereview.md` if exists.

## Review Method

- Review only; do not edit files except proposal files created through `zoo-proposal` for proposal-worthy refactoring findings.
- Use a direct, skeptical, technically unforgiving review posture without theatrics.
- Prioritize concrete bugs, behavior regressions, and missing tests.
- Put findings first, severity-ranked, with file/line references and the smallest safe fix.
- Require evidence for each finding.
- If no findings exist, say that explicitly.
- Check the implementation/fixes reports for `Final-state validation`. If the exact reviewed state is already proven by relevant passing commands and no later changes, do not rerun broad test suites just to duplicate that evidence.
- Run targeted commands only when they are needed to validate a concern, fill a missing final-state validation gap, or prove a suspected regression.

## What To Check

- Verify the original user request or ticket's primary use case is actually satisfied. Do not approve a plan limitation or partial implementation that skips the main point.
- Flag semantic duplication: new enum values, constants, helpers, APIs, or UI mechanisms that do the same job as an existing mechanism under a different name.
- Challenge workarounds around first-party code, including shared code considered first-party, if any. Require concrete evidence that fixing the shared dependency is riskier than carrying a workaround.
- Review for simplicity and maintainability: unnecessary layers, duplicated setup, ignored existing helpers, wrong test file/package placement, and comments that are symptoms of unclear structure.
- When tests are removed or rewritten, verify the live behavior they covered is still tested through the replacement path.
- Use `zoo-refactoring` when a finding needs changes outside the active task or implementation diff. It routes consequential cross-cutting changes to proposals, broad mundane refactors to separate subtasks/commits, and small low-pollution edits into the current task.
- When you write a proposal, mention its path and the finding it handles in the review report. If you cannot create proposal files, include the draft proposal entry for the orchestrator. Put separate-subtask outcomes in a `Refactoring request` section instead of editing specs, subtasks, or code.
- For browser-impact work, verify browser evidence covers the declared/requested flows, uses Browser Use or Computer Use as needed, and includes screenshot/video proof.
- Verify completion evidence matches the change type: screenshots for browser-visible behavior, generated files for exports, input files plus screenshots for imports, and representative test names for tested behavior.
- Flag new ad-hoc dropdown/popover/disclosure/select mechanics when an established local primitive should be used by default.
- If findings expose concerns not addressed in the original plan, request plan revision so planning can respond.

## Report Handoff

Include `Final-state validation` in the review report:

- whether prior reports prove relevant commands passed on the exact state reviewed
- any commands you ran yourself, their result, and whether they ran after all file changes
- if final-state validation is missing, stale, failed, or incomplete, say that explicitly and name the exact command the orchestrator should run once before or during code uberreview
