---
name: zoo-cleanup-finished-specs
description: Archive completed Zoo spec files and resolved proposal files. Use when cleaning finished `.spec` work, moving completed specs into `archived/`, or moving implemented/rejected proposals into archive while honoring repo-local Zoo path overrides.
---

Follow `.zoo/zoo.md`, `.zoo/proposals.md` and file at `$ZOO_LOCAL_MD` if exists

Move finished specs/proposals out of active folders. Do not delete.

Paths:
- defaults: `.spec/`, `.spec/archived/`, `.proposals/`, `.proposals/archived/`
- override from `.zoo/zoo.md`; proposal paths can also come from `.zoo/proposals.md`
- create archive dirs; ignore files already archived

Archive spec only when all true:
- active spec doc, usually `*.md`
- executed, shown by commits, report, task log, validation, or final chat
- frontmatter status `done` or equivalent completion text
- `## Subtasks` has no `[>]`, `[ ]`, `paused`, `blocked`, `Plan: TBD`; all present statuses are `[x]`
- `## Pending suggestions` is empty

Do not archive draft specs, specs without subtasks, specs with open Pending suggestions, or ambiguous completion. Report candidates left active.

Archive proposal only when active proposal frontmatter status is `done` or `rejected`. Do not infer from code or prose when status is missing/proposed; report as needs status/human decision.

Move:
1. Build explicit spec/proposal move lists.
2. If none qualify, report and stop.
3. Refuse overwrite collisions.
4. Use `git mv` for tracked files, `mv` for untracked.
5. Preserve filenames.
6. Do not move `.tasks/` or `_tasks/` reports.

Validate with `git status --short` and active/archive listings. Skip code tests unless executable files changed.

Report path rules, archived files, skipped/ambiguous candidates, blockers, validation.
