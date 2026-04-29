# Zoo 2.1

Codex/Claude workflows based on personality-infused skills.

This is the set of agents and skills I use in day-to-day production work as a CTO of [Bubblehouse](https://bubblehouse.com/).

See my [All Star Zoo](https://tarantsov.com/all-star-zoo/) post for way more context on the idea.


## Zoo 2.1 for Codex

New Zoo 2 is under `.codex`. (I will make a Claude version soon, too.) 

1. Copy `.codex/agents` and `.codex/skills` into your project's `.codex` dir.
2. Install [Bureau MCP](https://github.com/andreyvit/bureau-mcp) -- basically command `npx`, args `-y` and `bureau-mcp` if configuring via Codex app settings UI.
3. Run `zoo-init` skill to verify setup and initialize files under `.zoo/`.

These skills are intended to be universal, so all customization is via `.zoo/*.md`, for example:

- project-specific browser testing instructions go into `.zoo/browser.md`
- project-specific testing instructions go into `.zoo/testing.md`, etc.

Zoo Init skill will research the repo and create an initial set of project-specific instruction files under `.zoo`. I've also published our real-world `.zoo/*.md` in this repository, but you definitely should not just blindly copy them.

### Using Zoo 2

Invoke one of the three top-level skills:

* `zoo-heavy` for a full spec-based Zoo workflow, with all work done in subagents, and separate steps for: planning, plan review, test writing, implementation, code review, doc writing.

* `zoo-lite` for a spec-based Zoo workflow; subagents are only used for research, reviews and browser use; all planning and implementation work happens in the top-level agent.

* `zoo-zero` to directly execute your instructions without writing a spec, but follow up with review/fix iterations until the reviewer is happy.

Zoo workflows use Bureau, so will create `.tasks` or `_tasks` folder (will use whichever one you have if any) and put per-step reports inside.

Zoo 2 workflows create and maintain a spec file, `spec.md` under the task folder by default, although you can point it to a spec file elsewhere to override.

Zoo 2 workflows split the task into subtasks -- iterations that are fully tested and valuable on their own; and the agent commits after each subtask. If your repo needs special commit instructions, be sure to create a commit skill; agents are good at invoking it. After the work is done, you are free to squash the commits.

To request a revision, simply invoke Zoo skill again with a revision request. It will continue working in the same task folder and same spec file.


## Zoo 1 for Claude

Under `.claude`, I still have Zoo 1 subagents and commands, basically the exact workflow described in [All Star Zoo](https://tarantsov.com/all-star-zoo/).

1. Copy `.claude/agents` and `.claude/commands` into your project's `.claude` dir.
2. Global search & replace `_ai` with whatever directory you'd like to accumulate AI knowledge base in.
3. Global search & replace `CLAUDE.md` with the file you use as primary source of instructions.
4. Ask HR agent to adapt agent definitions to your tech stack.


## Changelog

* Zoo 1.0 is a Claude Code setup described in my blog post.
* Zoo 1.1 adds Bureau MCP for more consistent reporting.
* Zoo 2.0 is a reimagining of Zoo for Codex and the smarter GPT 5.4+ models. Introduces a spec file.
* Zoo 2.1 refines Codex setup for GPT 5.5-xhigh, adds Zoo Lite and Zoo Zero workflows to reflect the preferred speed/accuracy balance of the smarter models, and is the first public release of Zoo 2.


## License

Most of this is AI-generated and should be considered uncopywritable. But just in case, whatever is copywritable is © 2025-2026, Andrey Tarantsov, and is distributed under [Zero Clause BSD](https://opensource.org/license/0bsd) license which has no attribution requirements:

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
