<div align="center">

# Zoo 2

Reliable Codex & Claude workflows for complex projects.

_Specs • Uber-reviews • Browser use • Subtasks_

[![License: 0BSD](https://img.shields.io/badge/License-0BSD-blue.svg)](LICENSE)

</div>

Let agents review and fix their own shit before you see it.

1. Uses spec files and per-step report files to avoid forgetting the details.
2. Runs automatic super-comprehensive reviews of the plan and code.
3. Splits work into subtasks when possible, then plans and executes each separately.
4. Verifies UI changes with browser use and screenshots.
5. Maintains comprehensive documentation.
6. Follows pragmatic values of Linus Torvalds and Don Melton.

Zoo 2 is a set of agents and skills I use in day-to-day production work as a CTO of [Bubblehouse](https://bubblehouse.com/).

See my posts for way more context on the idea:

* [Meet Zoo 2](https://tarantsov.com/meet-zoo-2/)
* [All Star Zoo](https://tarantsov.com/all-star-zoo/)

These skills are intended to be project-independent, so all customization is via `.zoo/*.md`, for example:

- project-specific browser testing instructions go into `.zoo/browser.md`
- project-specific testing instructions go into `.zoo/testing.md`
- project-specific uber-review instructions go into `.zoo/review/*.md`
- and more; see [example .zoo files](.zoo/)

These will be generated for your project during the Zoo Init phase of installation.

Tip: if you're choosing between Codex and Claude, choose Codex; it produces *much* better results with Zoo workflows, and the rate limits last *much* longer.


## Quick start

### Installation

To install, point your agent to this repository and ask it to install Zoo 2 for you, then review and customize content under `.zoo/`.

I've published our real-world [`.zoo/*.md`](.zoo/) files, but you definitely should not just blindly copy them.


### Simple tasks: Zoo Zero

Not every task requires a heavy workflow, but almost every task can benefit from the machine reviewing and fixing its own shit before demanding attention from a human. For that, just prefix your instructions with the Zoo Zero skill.

### Most complex tasks: Zoo Heavy

When starting on a big, complex task you care about, run Codex's plan mode asking for a high-level plan, iterate until you're happy with it, then run the Zoo Heavy skill asking it to implement the plan.

If you're feeling lucky or lack human time, simply running Zoo Heavy on a complex task will also produce surprisingly reasonable results. Give it a try, especially overnight.

Often, it's easier to run revision iterations later than to invest in making a plan beforehand. The approach is "I'll know it when I see it", or more like "I'll know it when I see something that's definitely not it".

### Middle ground: Zoo Lite

For a less complex task that Codex would handle okay but not quite right, use Zoo Lite. It will do all planning and implementation work at the top level, just like Codex normally does (and thus at the same speed), but will still benefit from a spec, split into subtasks, and run review loops, which greatly improves the result.


### Tips for reviewing the work

At the end of a task, you should get a comprehensive high-level report, including screenshots of any UI changes.

When using Zoo Heavy and Zoo Lite, you'll find the spec file to be a useful input when reviewing the results or ongoing work. In particular, it has a decision log for all choices made by the LLM, and detailed acceptance criteria for the substeps that you should see materialized as commits in your repository. The file should be under `.tasks/YYYYMMDD-whatever/spec.md`, although you can provide your own location for it.

Zoo Heavy and Zoo Lite will produce a separate commit for each subtask, to make reviewing work easier. You might want to squash those after the review.


### Asking for revisions

To request a revision, run a Zoo skill again. It should recognize that it's a revision and continue working with the same spec and same task directory.


## Advanced use

### Zoo Docs and Zoo HR

You can invoke Zoo Docs separately to beat some new knowledge into its stupid brain.

To update Zoo skills or instructions under `.zoo`, invoke the Zoo HR skill.

This replaces the `/hr` command from Zoo 1.

### Zoo Uber Review

Uber reviews run after a regular review passes, and invoke multiple reviewer subagents, one for each `.zoo/review/*.md` file. This dramatically increases the quality of the review.

You can invoke the Zoo Uber Review skill separately, similar to a native `/review` command. It won't start a review-and-fix loop, however; for that, simply invoke Zoo Zero.

### Zoo Rebase

New in Zoo 2.3, after finishing, Zoo workflows will execute Zoo rebase, which will pull and rebase on top of latest code, resolve conflicts, and rerun tests if anything might have changed.

### Zoo Push

New in Zoo 2.3, you can manually run Zoo Push skill which runs Zoo Rebase and pushes changes after, repeating rebase until successful.

### Zoo Ensure Safe Deploy

New in Zoo 2.3, if you have tokens to spare, run Zoo Ensure Safe Deploy inside `/goal` (Codex) or `/loop` (Claude) to have the model do its very best to find any obstacles to safe deployment.

You can specify the changes to review (e.g. “since v1.2.3”). By default, it will focus on unpushed commits.

### Proposals

When Zoo reviewers want to request a refactoring way outside the scope of the current task, they write up a proposal file under `.proposals/` for future consideration.

This is a way to keep security/modularity/etc reviews satisfied without blowing up the scope of simple tasks, but also without ignoring their findings.

Review these proposals occasionally, and see if you wanna execute them.

There's Zoo Proposal skill if you want to initiate a proposal manually.


## Zoo 2 installation instructions for agents

1. Copy the contents under [`.codex`](.codex) or [`.claude`](.claude) into the corresponding directory in your project.
2. Install [Bureau MCP](https://github.com/andreyvit/bureau-mcp) -- use command `npx` with args `-y` and `bureau-mcp` if configuring via Codex app settings UI.
3. Run Zoo Init skill to verify setup, research the repo and create an initial set of project-specific instruction files under `.zoo/`.


## Handling of Claude and Codex differences

We make sure Claude and Codex skills are byte-by-byte identical; makes customizing them easier.

When installing, we do add separate copies for Claude and for Codex. You can use symlinks if you prefer, but we avoid them to make handling Windows checkouts easier 🤮

Subagent definitions are materially different, though; we keep them short to simplify maintenance.


## Changelog

* Zoo 2.3 adds Claude Code, proposals, final reports (Zoo Report skill invoked automatically when finishing tasks), Zoo Rebase, Zoo Push, and Zoo Ensure Safe Deploy skill (for manual invocation under `/goal` or `/loop`)
* Zoo 2.2 adds Uber Review to all Zoo flows.
* Zoo 2.1 refines Codex setup for GPT 5.5-xhigh, adds Zoo Lite and Zoo Zero workflows to reflect the preferred speed/accuracy balance of the smarter models, and is the first public release of Zoo 2.
* Zoo 2.0 is a reimagining of Zoo for Codex and the smarter GPT 5.4+ models. Introduces a spec file.
* Zoo 1.1 adds Bureau MCP for more consistent reporting.
* Zoo 1.0 is a Claude Code setup described in my blog post.


## Zoo 1 for Claude

Under `.claude-zoo-v1`, I still have Zoo 1 subagents and commands, basically the exact workflow described in [All Star Zoo](https://tarantsov.com/all-star-zoo/).

This is superseded by Zoo v2, but some might still prefer Zoo 1.

To install:

1. Copy `.claude-zoo-v1/agents` and `.claude-zoo-v1/commands` into your project's `.claude` directory.
2. Globally search and replace `_ai` with the directory you'd like to use for the AI knowledge base.
3. Globally search and replace `CLAUDE.md` with the file you use as the primary source of instructions.
4. Ask HR agent to adapt agent definitions to your tech stack.


## License

Most of this is AI-generated and should be considered uncopywritable. But just in case, whatever is copywritable is © 2025-2026, Andrey Tarantsov, and is distributed under the [Zero Clause BSD](https://opensource.org/license/0bsd) license, which has no attribution requirements:

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
