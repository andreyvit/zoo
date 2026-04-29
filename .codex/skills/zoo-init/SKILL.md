---
name: zoo-init
description: Research a repository and initialize real project-specific Zoo customization files under .zoo, then verify Bureau MCP access. Use when setting up Zoo workflow customization for a repository.
---

# Zoo Init

Initialize repo-local Zoo customization files from actual project research, similar in spirit to `codex /init` or `claude /init`.

## Workflow

1. Research the repository before writing files:
   - root agent instructions: `AGENTS.md`, `CLAUDE.md`, or equivalents
   - existing docs such as `_ai/`, `docs/`, `_readme/`, or `README*`
   - package/module layout and build/test commands
   - existing app/browser harness docs or scripts
   - existing commit, review, and documentation conventions
2. Create `.zoo/` if needed.
3. Create only missing `.zoo/*.md` files. Do not overwrite or edit existing files unless the user explicitly asks.
4. Populate each new file with concise, real project-specific instructions discovered from the repository. Do not use placeholder boilerplate. Format: concise bullet point list, short and actionable, no fluff.
5. If a role has little explicit guidance, infer the repo's spirit from its structure, docs, commands, and examples, then write 1-2 suitable low-risk instructions for that role.
6. Keep each file short: include only guidance that a generic Zoo workflow would not already know.
7. After file setup, call `mcp__bureau__current_task` to verify Bureau MCP is accessible. Do not create or switch Bureau tasks for this check.  If Bureau tools are not exposed, use tool discovery to find the Bureau current-task tool, then call it. A normal empty/no-current-task response still counts as Bureau being accessible; a missing tool or failed MCP call does not. If you're sure Bureau is not accessible, recommend ways to install `https://github.com/andreyvit/bureau-mcp` in the current agent.
8. Report research sources, created files, skipped existing files, and whether Bureau MCP was accessible.


## Files

- `.zoo/planning.md`: product context, source-of-truth docs, architecture boundaries, project-specific planning risks.
- `.zoo/planreview.md`: local architecture, planning, migration, risk, and validation expectations reviewers should enforce.
- `.zoo/testing.md`: test placement, commands, fixtures, helpers, deterministic data, and project-specific assertion patterns.
- `.zoo/coding.md`: package boundaries, data/model conventions, settings/config patterns, code generation, migrations, and local helper preferences.
- `.zoo/codereview.md`: local correctness risks, data ownership checks, testing expectations, and project-specific review smells.
- `.zoo/browser.md`: local app/browser harness commands, scenarios, credentials docs, tunnel/callback rules, and UI primitives.
- `.zoo/docs.md`: local documentation destinations, agent instruction destinations, public-doc validation commands, terminology, and audience boundaries.
