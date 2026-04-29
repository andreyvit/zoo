---
name: zoo-hr
description: Use when updating, tuning, debugging, or aligning Zoo workflow guidance from operational feedback. Prefer updating repo-local .zoo/*.md files; edit main skills or subagents only when explicitly instructed.
---

# Zoo HR

Improve Zoo behavior by fixing the underlying guidance problem, not by piling on prompt band-aids.

## Workflow

1. Identify the behavior to change from the user's feedback, reports, diffs, or examples.
2. Read the relevant context before editing:
   - `.zoo/*.md` files for the affected Zoo role
   - `.codex/skills/zoo-*/SKILL.md`
   - `.codex/skills/zoo-*/agents/openai.yaml`
   - `.codex/agents/*.toml`
   - workflow references under `.codex/skills/zoo-*/references/` when the issue is procedural
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
6. Validate touched skills with the skill-creator validator and check `agents/openai.yaml` when skill metadata changes. `.zoo/*.md`-only edits do not need skill validation.
7. Report the observed failure, root cause, files changed, and why the fix belongs where it was placed.

## Editing Rules

- Prefer surgical edits. Do not copy long project rules into every `.zoo` file.
- Preserve compact personality values when they steer judgment: skepticism, simplicity, research before claims, and ownership of the role.
- Remove or rewrite stale/contradictory instructions instead of only adding new ones.
- Keep main Zoo skills generic. Put repo-specific conventions in `.zoo/*.md` wherever possible.
- Treat main Zoo skills and subagents as read-only context unless the user explicitly asks to change them.
- Keep `.zoo/*.md` role-specific and concise; avoid duplicating the same rule across files unless each role needs it at decision time.
- Use concrete imperatives. Avoid biographies, theatrics, praise, insults, and motivational filler.
- When explicitly updating Codex skills, follow `skill-creator` conventions: valid frontmatter, concise body, and `agents/openai.yaml` with a short default prompt that explicitly mentions `$skill-name`.

## Common Fix Patterns

- Planner misses repo architecture: update `.zoo/planning.md` or `.zoo/planreview.md`.
- Implementer invents local mechanisms: update `.zoo/coding.md`, and `.zoo/codereview.md` if reviewers should catch it.
- Tests drift from repo style: update `.zoo/testing.md`.
- Browser verifier uses the wrong app harness: update `.zoo/browser.md`.
- Docs writer uses the wrong docs location or audience: update `.zoo/docs.md`.
- Delegated agents ignore `.zoo`: read the relevant Zoo skill and agent definition; only edit those files if the user explicitly asked to change core skills/subagents.

Do not treat every failure as an instruction shortage. Some failures are caused by too much prompt text, conflicting rules, or rules living too far from the decision they are meant to affect.
