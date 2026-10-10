---
name: zoo-summarize-code
description: "Present Git changes commit by commit as an outline for quick code review, especially by voice. Invoke only when requested manually or by Zoo workflow."
---

Follow `.zoo/zoo.md` and file at `$ZOO_LOCAL_MD` if exists

Use terse. Describe actual Git diffs, not plans or commit messages alone. Read surrounding code where needed. Explain changes; do not review, implement, commit, or rewrite history.

Scope/output:
- Resolve commits from user request or active Zoo task. Exclude unrelated commits; ask if scope is ambiguous.
- Read each commit's diff against its parent, oldest first. One subsection per commit: short hash and subject. If commit has body, show as intro paragraph, but only higher-level things that do not repeat what is in your outline.
- Zoo: after all task commits and closeout rebase, replace `Code Summary` in task file. Update from current commits on later closeout.
- Manual: show outline in chat; write to report only when requested. Identify covered commits and any requested changes still uncommitted; never present those as committed.

Per commit, use this order; omit empty categories:

1. **Packages**: list packages/directories first, each with add/change/remove and one sentence describing changes.
2. **Production code**: code used by actual production system. Describe each change. Group related changes into an outline:
   - 1–7 items per list, at most 3 bullet levels. Group further to fit; retain meaningful differences.
   - High-level before low-level; uses before declarations.
   - Explain repeated patterns once; use “same for” / “similar but” with exact differences.
   - Skip mundane details only when unsurprising and matching prevailing precedents.
   - Name exact symbols, types, defaults, conditions, and behavior needed to review the change. Include removals.
3. **Tests**: tests, helpers, and other test-only code. List added/changed/removed tests by name, one sentence each: key scenario for additions, delta for changes. Describe helper changes too.
4. **Tooling**: code executed outside tests and unused by production. List added/changed/removed files, one sentence per file.
5. **Docs**: instructions, skills, AI and human docs. List added/changed/removed files, one sentence per file.

Prefix SURPRISE to items that stand out as unobvious, non-standard for the codebase, controversial or significant new pieces/abstractions NOT already covered by the spec.

Classify by actual use, not directory names; split mixed files across categories. Keep prose easy to hear: plain langauge, short clauses, explicit relationships, no tables or long code dumps.

See references/example.md for grouping and repetition style; adapt to the diff.
