---
name: zoo-rebase
description: Rebase completed changes onto upstream while preserving dirty work, resolve conflicts, rerun validation when incoming changes could affect tests, and decide push safety. Use during Zoo closeout and before Zoo Push.
---

Follow `.zoo/zoo.md`, `.zoo/rebase.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo rebase start (.spec/example.md) r0`, then `Zoo rebase finished (.spec/example.md) r0` or `Zoo rebase failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

Use parent-qualified receipts when called from closeout or push; standalone calls use `rebase`. Emit finished only after rebase, required validation, and work-tree restoration succeed; include any remaining push-safety restriction in prose. Push rebase displays PUSH; closeout rebase finishes as FIN. Preserve finished spec metadata.

Follow commit skill if any when creating or rewriting commits during rebase.

Use before final reporting/zoo-push. Uncommitted changes intended for upstream affect only final push safety, never whether rebase runs. For final closeout, read `.zoo/task-finish.md` first; it may skip/replace zoo-rebase.

Ignored task roots (`.tasks/`, `_tasks/`, alternates) are workspace artifacts. Never stage, force-add, commit, or push them.

Do not add rebase activity, hashes, conflicts, or outcomes to the Zoo task/spec
history. Do not add routine rebase corrections to `MISTAKES.md`. If an unusually
serious, reusable mistake warrants an entry, add it to a relevant commit before
push; never leave it as closeout dirt.

1. Require upstream. If missing, bail with `Unsafe - No upstream`.
2. Inspect branch, upstream, HEAD, upstream commit, and git status. Dirty work never blocks rebase.
3. If dirty, snapshot existing stash OIDs, run `git stash push --include-untracked -m "zoo-rebase"`, and record any new OID. Stash failure => do not rebase; keep and report any created entry, then stop with `Unsafe - Cannot stash work tree`. No new OID => restore none. Never apply or drop a pre-existing stash.
4. Run `git pull --rebase`. If it fails with a rebase active, resolve and continue; preserve incoming and task intent. If unclear or impossible, abort. Abort failure => keep the stash, stop with `Unsafe - Cannot abort rebase`, and report its OID. Record any failure left after no rebase is active; do not return before step 6.
5. After successful rebase, rerun validation on the clean rebased tree if incoming changes/conflict resolutions may affect tests, ie all except non-executable docs and instructions, changelogs, skills, etc. When uncertain, validate. Record failures; do not return before step 6.
6. Once no rebase is active, resolve Zoo's OID to its current stash ref, then run `git stash pop --index <resolved-ref>`. Any nonzero exit or missing ref => keep any remaining entry and stop with `Unsafe - Cannot restore work tree`; explain and report the OID. Never return OK or continue while Zoo's stash remains unapplied.
7. Report: pull failed => `Unsafe - Cannot rebase`; unclear conflict after successful abort => `Unsafe - Cannot merge`; broken incoming commits => `Unsafe - Incoming commits broken`; breakage from our changes/merge => `Unsafe - Extra fixes required` and route into active workflow as subtask; restored changes intended for upstream remain uncommitted => `Unsafe - Uncommitted changes`; otherwise 'OK, <no conflicts / conflicts resolved>, <no need to revalidate / validation passed>'.
