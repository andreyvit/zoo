---
name: zoo-hr
description: Update, trim, or align Zoo workflow guidance from operational feedback. Use when fixing workflow behavior, skill wording, repo-local .zoo guidance, or agent instructions.
---

Follow `.zoo/zoo.md` and file at `$ZOO_LOCAL_MD` if exists

Update skills/instructions. Fix root cause, not prompt band-aids.

Read affected:
- `.zoo/*.md`
- skill `SKILL.md`, `references/*`, `agents/openai.yaml`, `rationale.md`
- agents: `.codex/agents/*.toml`, `.claude/agents/*.md`

Put fixes where they belong:
- repo guidance: docs linked from AGENTS.md/CLAUDE.md
- repo Zoo customization: `.zoo/*.md`
- workflow: `SKILL.md`
- large templates/subprocesses: `references/*`
- role behavior: agent files
- maintainer why: `rationale.md`

Instruction design:
- State intent, desired outcome, and judgment boundary. Give agents enough context to make good calls.
- Prefer general direction plus representative examples over strict algorithms for judgment calls. Examples guide; they do not define a closed list.
- Use exact rules only for truly mechanical or non-negotiable requirements.
- Name the desired path or action. Do not list places or choices to avoid.

Style:
- terse to max (zoo-* skills are examples)
- Zoo skills start with `Follow <file1>, <file2>... if exists`
- compact workflow/router text in `SKILL.md`
- templates, non-universally-applicable long details in `references/`
- delete stale/contradictory text

Sync: change `.claude/agents` and `.codex/agents` together.

Validate `agents/openai.yaml`, stale names, deleted workflows, obsolete instructions. Report root cause, files, sync, validation.
