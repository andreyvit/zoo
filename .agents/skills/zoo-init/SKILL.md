---
name: zoo-init
description: Initialize repo-local .zoo customization files for Zoo from real repository research. Use when setting up Zoo customization for a repository.
---

Follow `.zoo/zoo.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo init start (.spec/example.md) r0`, then `Zoo init finished (.spec/example.md) r0` or `Zoo init failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

Create concise repo-local Zoo guidance. No placeholders.

Codex only: before continuing, ensure global Codex config (`$CODEX_HOME/config.toml`, usually `~/.codex/config.toml`) contains `default_mode_request_user_input = true` under `[features]`. Required for `request_user_input` tool to work outside of planning mode. If added during running session and the tool stays unavailable, start a new turn/thread or ask user restart Codex. Bail without this tool available.

Research first: root agent instructions, docs dirs, layout, build/test/browser harness, commit/review/docs/proposal/release conventions.

After research, ask user with `request_user_input` / AskUserQuestion, give option for their existing value if different from recommended value:
- do they want to use terse messages style, recommend yes.
- spec (aka task) file path, recommend `.spec/YYYYMMDD-taskslug.md`
- should spec files be committed or gitignored, recommend commit
- evidence dir (screenshots and example files), recommend `.tasks/YYYYMMDD-taskslug-evidence/`
- should evidence be git tracked or gitignored, recommend ignore
- research path, recommend `.tasks/YYYYMMDD-taskslug-research.md`
- should research be git tracked or gitignored, recommend ignore
- proposals path, recommend `.proposals/YYYYMMDD-title.md`
- archived proposals path, recommend `archived/` under chosen proposals dir
- mistake log path, recommend `.ai-mistakes.md`, give option to have none

NB: when asking for paths, give full example (`.spec/YYYYMMDD-taskslug.md`), not prefix (`.spec/YYYYMMDD`).

If user agreed to terse style, load terse skill immediately, and add at the start of CLAUDE.md and AGENTS.md (whichever exist): `Load terse skill for voice in all messages incl between tool calls.`

Create `.zoo/`, create new files under it; merge new research if files already exist;
- `.zoo/zoo.md`: zoo dirs (specs, proposals, tasks), how to run tests, mistake log path, ticket tools
- `.zoo/review.md`: review config every review skill reads: the scout command if the repo has one (label it `Scout:`; see zoo-tweak-reviews), review-wide rules (e.g. what to do when a scout check is wrong)
- `.zoo/planning.md`: pointers to planning docs if any (e.g. product, architecture info)
- `.zoo/testing.md`: pointers to test writing docs if any
- `.zoo/coding.md`: pointers to coding/style docs if any
- `.zoo/browser.md`: pointers to harness info, how to run app for browser testing, tunnel/callback rules
- `.zoo/docs.md`: pointers to doc destinations, instructions, validation, terminology, audience
- `.zoo/task-start.md`: leave empty
- `.zoo/subtask-start.md`: leave empty
- `.zoo/task-finish.md`: leave empty
- `.zoo/rebase.md`: leave empty
- `.zoo/push.md`: repo publish instructions (use git push, open PR, etc) if any
- `.zoo/proposals.md`: proposal folder/naming/archive/statuses/rules
- `.../MISTAKES.md`: initialize unless user refused

Update `.gitignore` to ignore/unignore according to user choices.

If any unknown files found under .zoo, list them and ask user if they want to delete. Legacy `planreview.md`, `codereview.md`, and question sections in `review.md` are known: keep them for zoo-tweak-reviews to migrate.

Check if commit skill exists; if not, ask if they want to create it (recommended); if yes, run zoo-hr skill in subagent.

Review questions live in the scout (a script that prints each review's questions). No scout: ask if they want one (recommended); if yes, run zoo-tweak-reviews. It mines review questions from the research above.
