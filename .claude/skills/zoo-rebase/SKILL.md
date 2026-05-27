---
name: zoo-rebase
description: Rebase completed trackable Zoo workflow changes onto the upstream branch, resolve conflicts, rerun validation when incoming changes could affect tests, write a Bureau rebase report, and decide whether the repo is safe to push. Use automatically during Zoo Heavy, Zoo Lite, Zoo Zero, and other Zoo workflow closeout after all docs updates and commits are finished but before the final report; also use when Zoo Push needs a pre-push rebase gate.
---

# Zoo Rebase

Read and follow `.zoo/zoo.md` if it exists.
Read and follow `.zoo/rebase.md` if it exists.

Use this after all trackable Zoo workflow changes outside ignored task roots are committed and before `zoo-report` or `zoo-push`.

When invoked from final Zoo workflow closeout, `.zoo/task-finish.md` must be read first. Its instructions take priority over this skill, including instructions to skip or replace `zoo-rebase`.

If a task root such as `.tasks/`, `_tasks/`, or a repo-specific alternate is ignored by git, files under that root are not Zoo workflow changes for rebase or push-safety gates. Never stage, force-add, commit, or push them to satisfy cleanliness checks, including additions, modifications, or deletions of paths that were already tracked.

## Workflow

1. Verify closeout prerequisites:
   - All trackable changes from the Zoo workflow outside ignored task roots are committed.
   - Any remaining uncommitted changes are fully pre-existing and unrelated. Do not stash, edit, or discard unrelated work.
   - There is an upstream branch. If not, write a `rebase` report that says push safety is unknown and stop.
2. Open a Bureau report with suffix `rebase`. Record:
   - starting branch, upstream, `HEAD`, upstream commit, and git status
   - commands run
   - incoming commits and changed files, if any
   - conflicts encountered and resolutions made
   - validation decision and commands run
   - final git status
   - `Rebase result: clean|not clean`
   - `Safe to push: yes|no|unknown`
3. Run `git pull --rebase`.
4. If conflicts occur:
   - Inspect every conflicted file and resolve conflicts directly when the correct integration is clear.
   - Preserve both incoming intent and this workflow's intent; do not blindly prefer either side.
   - Continue the rebase after resolving conflicts.
   - If the correct resolution is unclear, write the report, mark `Rebase result: not clean`, and stop.
5. Decide whether validation is required:
   - Validation is required when incoming changes exist and may affect tests.
   - Validation is required when conflicts were resolved in files that may affect tests.
   - Treat everything as test-affecting except clearly non-executable docs, README files, changelogs, `.zoo/`, `.codex/skills/`, `.claude/skills/`, `_ai/`, or other AI instruction-only updates.
   - When uncertain, rerun validation.
6. If validation is required, rerun the tests and validation that prove the completed Zoo task. Use the workflow's latest final-state validation reports and `.zoo/testing.md` to choose commands. If no narrower command is defensible, use the repo's broad quick validation.
7. If validation fails, investigate before deciding ownership:
   - If recent incoming commits are definitely broken independently of this workflow, record diagnostics and propose a fix approach. Do not fix incoming commits.
   - If this workflow's changes are broken because of incoming commits, route the fix back into the current workflow: in Zoo Heavy or Zoo Lite, add a real subtask for fixing the broken tests and continue the workflow; outside Heavy/Lite, use Zoo Zero to fix this workflow's changes.
   - Mark `Rebase result: not clean` until the routed fix and validation complete.
8. If no validation was required, or required validation passed, mark `Rebase result: clean`.
9. Report whether the repo is safe to push:
   - `yes` when rebase is clean and git status has no trackable Zoo workflow changes outside ignored task roots left uncommitted
   - `no` when validation failed, conflicts remain unresolved, or trackable workflow changes outside ignored task roots are uncommitted
   - `unknown` when upstream is missing or unrelated dirty work prevents a reliable rebase

## Clean Definition

The rebase is clean when no validation run was necessary, or all required validation passed after the rebase. A clean rebase is required before `zoo-push` may publish changes.
