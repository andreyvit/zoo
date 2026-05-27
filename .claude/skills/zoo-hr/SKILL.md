---
name: zoo-hr
description: Use when updating, tuning, debugging, or aligning Zoo workflow guidance from operational feedback. Prefer updating repo-local .zoo/*.md files; edit main skills or subagents only when explicitly instructed.
---

# Zoo HR

Read and follow `.zoo/zoo.md` if it exists.

Improve Zoo behavior by fixing the underlying guidance problem, not by piling on prompt band-aids.

## Workflow

1. Identify the behavior to change from the user's feedback, reports, diffs, or examples.
2. Read the relevant context before editing. We maintain Zoo for both Claude Code and Codex in this repo, and both must stay in sync — read both whenever the same role or behavior is configured on both sides:
   - `.zoo/*.md` files for the affected Zoo role (shared, single source of truth for both harnesses)
   - Codex: `.codex/skills/zoo-*/SKILL.md`, `.codex/skills/zoo-*/agents/openai.yaml`, `.codex/agents/*.toml`, and workflow references under `.codex/skills/zoo-*/references/` when the issue is procedural
   - Claude Code: `.claude/skills/zoo-*/SKILL.md`, `.claude/agents/*.md` (the Zoo subagent definitions), and workflow references under `.claude/skills/zoo-*/references/` when the issue is procedural
3. Diagnose the root cause:
   - missing trigger or wrong trigger scope
   - unclear top-level vs delegated-agent boundary
   - wrong role priority or incentive
   - stale repo convention
   - missing context-loading step
   - rule placed in the wrong artifact
   - too much prompt weight obscuring the important rule
4. Decide where the fix belongs:
   - `.zoo/planning.md` for repo-specific planning, architecture, product context, and source-of-truth guidance
   - `.zoo/planreview.md` for repo-specific plan-review expectations
   - `.zoo/testing.md` for repo-specific test commands, placement, helpers, fixtures, and assertions
   - `.zoo/coding.md` for repo-specific implementation, package, data, settings, and migration conventions
   - `.zoo/codereview.md` for repo-specific code-review risks and smells
   - `.zoo/browser.md` for repo-specific app/browser harness and UI behavior
   - `.zoo/docs.md` for repo-specific docs destinations, terminology, and validation
   - main Zoo skills, subagents, or commands only when the user explicitly instructs you to edit them
5. Make the smallest effective edit that prevents the failure while preserving successful behavior.
6. Cross-harness rules. The goal is byte-identical skill trees under `.codex/skills/<name>/` and `.claude/skills/<name>/`. When editing main Zoo skills (not `.zoo/*.md`):
   - Edit the currently running harness first: Codex edits `.codex/skills/<name>/`, and Claude Code edits `.claude/skills/<name>/`.
   - Clone the edited skill tree to the other harness verbatim with `make skills-clone-codex-to-claude` from Codex or `make skills-clone-claude-to-codex` from Claude Code. Do not hand-merge equivalent `SKILL.md` changes in both copies.
   - Skill bodies refer to subagents by their Codex names (underscored: `plan_reviewer`, `test_writer`, `code_reviewer`, `browser_verifier`, `docs_writer`, `problem_solver`). Do NOT introduce hyphenated variants in skill text. Claude Code maps these to its hyphenated agent IDs separately.
   - When something genuinely differs between harnesses, write conditional text inline (e.g. "in Codex use X; in Claude Code use Y") or prefix a whole bullet/paragraph with `Codex only:` or `Claude Code only:`. Do not fork the file.
   - Subagent definitions are NOT shared: `.codex/agents/*.toml` and `.claude/agents/*.md` use different formats. Edit each in its own format when adjusting subagent prompts.
   - `agents/openai.yaml` is required by Codex skill metadata. Mirror the same file on the Claude side too so byte-clones work in both directions; Claude Code ignores it.
   - `.zoo/*.md` is shared and only needs to be edited once.
7. Validate touched skills with the skill-creator validator and check `agents/openai.yaml` when skill metadata changes. `.zoo/*.md`-only edits do not need skill validation.
8. After editing skills, run the clone command that matches the edited side to sync the other harness and confirm both trees are byte-identical.
9. Report the observed failure, root cause, files changed (on both Codex and Claude sides when applicable), and why the fix belongs where it was placed.

## Editing Rules

- Prefer surgical edits. Do not copy long project rules into every `.zoo` file.
- Preserve compact personality values when they steer judgment: skepticism, simplicity, research before claims, and ownership of the role.
- Remove or rewrite stale/contradictory instructions instead of only adding new ones.
- Keep main Zoo skills generic. Put repo-specific conventions in `.zoo/*.md` wherever possible.
- Treat main Zoo skills and subagents as read-only context unless the user explicitly asks to change them.
- Keep `.zoo/*.md` role-specific and concise; avoid duplicating the same rule across files unless each role needs it at decision time.
- Use concrete imperatives. Avoid biographies, theatrics, praise, insults, and motivational filler.
- When explicitly updating a skill, follow `skill-creator` conventions: valid frontmatter, concise body. For Codex, also keep `agents/openai.yaml` with a short default prompt that explicitly mentions `$skill-name`; mirror the same `agents/openai.yaml` on the Claude side so both harness trees remain byte-identical.

## Common Fix Patterns

- Planner misses repo architecture: update `.zoo/planning.md` or `.zoo/planreview.md`.
- Implementer invents local mechanisms: update `.zoo/coding.md`, and `.zoo/codereview.md` if reviewers should catch it.
- Tests drift from repo style: update `.zoo/testing.md`.
- Browser verifier uses the wrong app harness: update `.zoo/browser.md`.
- Docs writer uses the wrong docs location or audience: update `.zoo/docs.md`.
- Delegated agents ignore `.zoo`: read the relevant Zoo skill and agent definition; only edit those files if the user explicitly asked to change core skills/subagents.

Do not treat every failure as an instruction shortage. Some failures are caused by too much prompt text, conflicting rules, or rules living too far from the decision they are meant to affect.
