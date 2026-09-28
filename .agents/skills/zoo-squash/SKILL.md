---
name: zoo-squash
description: Prepare unpushed commits for pushing by squashing, formatting a patchset, or rewriting messages. Use only when explicitly asked to zoo-squash, squash, presquash, prepare unpushed commits for pushing, or squash/rewrite the unpushed set. Never invoke implicitly.
---

Follow `.zoo/zoo.md` and file at `$ZOO_LOCAL_MD` if exists

Only when user explicitly asks. Load commit skill if exists.

Prepare unpushed commit set for pushing:

1. List unpushed commit IDs and subjects explicitly, just in case.
2. Ask user to choose squash/rewrite approach (Ask User tool) unless specified in prompt.
3. Do the rewrite/commit if applicable. No backup branch; reflog exists. Never rewrite pushed or shared commits.

Approaches:

- Squash: squash into a single commit. Include existing in-scope spec and `MISTAKES.md` changes when present, and other relevant uncommitted/dirty files.
- Format patchset: squash rework and bug fixes into the primary commit introducing that code, so the patchset builds up the functionality without false takes. Exception: bug fixes in pre-existing code stay separate. Exception: when rework cannot be squashed into the original commit because it depends on later changes, consider squashing those later changes together with the original commit; but if squash is undesirable (would put very different functionality/changes into a single commit), leave the rework separate too. Add a final commit if relevant changes exist (including spec).
- Update messages: do not squash, but rewrite commit messages according to the rule below. Add a final commit if relevant changes exist (including spec).

WIP + final commit: the group's final closure commit contains just the spec and maybe other relevant files that did not fit elsewhere, but describes the entire changeset as if it was all squashed into this single commit; if a ticket is linked and entirely fixed, that commit Resolves/Fixes the ticket if the patchset indeed does. All other commits in the group are WIP; if a ticket is attached, they progress toward it, not resolve it. Single-commit feature: no extra final commit; fold leftovers into that commit. Nothing belongs in a final closure commit: ask.

Do not add Squash activity or outcomes to the Zoo task/spec history or similar logs. If an unusually serious, reusable mistake warrants an entry, include it in the final commit so closeout stays clean.

If user asked to push, run zoo-push skill next; otherwise do NOT push.
