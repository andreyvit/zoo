<div align="center">

# Zoo 3.1

Reliable Codex, Claude & Grok workflows for complex projects.

_Specs • Uber-reviews • Staged planning • Browser use • Subtasks_

[![License: 0BSD](https://img.shields.io/badge/License-0BSD-blue.svg)](LICENSE)

</div>

Let agents review and fix their shit before you have to deal with it.

Workflow:

1. High-level spec (+ review)
2. Low-level spec (+ review)
3. Implementation (per-subtask commits, screenshots and tiered reviews)
4. User requests revisions and decides on pending suggestions

Features:

1. Spec format optimized for quick human review.
2. Cross-agent spec uber-reviews — use diverse intelligence at a low token cost.
3. Explicit subtasks result in reviewable commits with clear justifications.
4. Tiered code reviews: tests, scripted checks, broad review, visual review.
5. Screenshots for any UI changes.
6. Parks extra discoveries as Pending suggestions (for later user approval) instead of hijacking the current commit; writes proposals for later/out-of-scope work.
7. Presents a readable report at the end.
8. Uses a research file to save tokens on re-researching the codebase.
9. Follows pragmatic values of Linus Torvalds and Don Melton.

Zoo 3.1 is the current version of Zoo 3, the lightweight successor to Zoo 2 targeting the smarter models of mid-2026. See my posts for way more context on the idea:

* [Zoo 3.1 fights scope creep and runs on Grok](https://tarantsov.com/zoo-3-1/)
* [Zoo 3, lean and mean](https://tarantsov.com/zoo-3/)
* [Meet Zoo 2](https://tarantsov.com/meet-zoo-2/)
* [All Star Zoo](https://tarantsov.com/all-star-zoo/)

Zoo skills are project-independent, customization is via `.zoo/*.md`:

- shared Zoo paths and scripted check commands go into `.zoo/zoo.md`
- planning and spec-review instructions go into `.zoo/planning.md` and `.zoo/planreview.md`
- project-specific browser testing instructions go into `.zoo/browser.md`
- project-specific testing instructions go into `.zoo/testing.md`
- project-specific code-review risks go into `.zoo/codereview.md`
- and more; see [example .zoo files](.zoo/)

These will be generated for your project during the Zoo Init phase of installation.


## If you're picking an agent for Zoo workflows...

1. Hot take: Grok produces the best results by far. Reasonable, down to earth specs, no-drama implementation, just as good at browser use, and SuperGrok Heavy lasts for an entire week of heavy usage (whereas I had to previously juggle three max Codex accounts).
2. Claude Code + Fable 5 writes decent specs (probably best at actually planning, with slight edge over Grok, but the resulting spec is a bit less readable than Grok's and more overengineered). Good at implementation too, but if you do everything with Fable, those weekly limits on the highest plan barely last a day.
3. Codex + GPT 5.6 Sol is great at implementation, but outputs specs written in lunacy English. Codex rate limits last *much* longer than Claude's. (But you know what lasts even longer? Grok.)
4. I haven't tried Opus 5 or 4.8 much. Opus 4.6 was much worse than Codex in my experience.


## Quick start

### Installation

1. Run `./install.sh /path/to/your/project` from this repository.
2. Run Zoo Init skill from that project.
3. Review and customize the generated content under `.zoo/`.

I've published our real-world [`.zoo/*.md`](.zoo/) files, but you definitely should not just blindly copy them.

Skills live in `.agents/skills`. Installation links `.claude/skills` to it when the Claude directory is absent or the two trees match. If only a Claude skill directory exists, installation moves it to `.agents/skills` first. Different existing trees stay separate and both receive Zoo skills; unrelated project skills are preserved.

To import changes from a project, run `./update.sh /path/to/project codex claude` (add `zoo` to import project guidance). Either `codex` or `claude` imports shared skills from `.agents/skills`, plus that harness's agents and other configuration. The Zoo repository does not keep a `.claude/skills` copy.

### Running a task

1. **You:** Say `<task> with /zoo` or `<task>, do with Zoo`, or just `/zoo <task>`. For a bug fix, say `Investigate <problem> with Zoo`; “investigate” makes Zoo explore the problem deeply and not assume that a code fix is necessarily the right solution.
2. Agent records user request and researches the codebase first.
3. Agent writes a high-level spec, asking user where necessary.
4. **You:** For a complex or high-stakes feature, if you have multiple agents configured, run `/zoo-spec-uberreview` to get every agent to chime in.
5. **You:** Review and approve the high-level spec.
6. Agent expands spec with lower-level details like naming, error handling, per-package change summaries, subtask split, letting you review the small details.
7. **You:** Review and approve the full spec — say `Go` or `Approved`, or even `/loop Go. Execute until done or approval needed. Use zoo skill.`
8. Agent executes each subtask and commits changes after.
9. Agent collects mid-task extras (scope expansions, extra code changes, unrelated bugs) under **Pending suggestions**.
10. After task is complete, agent presents a report. If pending suggestions exist, asks user to approve or reject them.
11. **You:** Review the resulting code, approve/reject/clarify suggestions, request revisions.
12. Agent executes revisions as separate subtasks, and presents a report again.
13. **You:** When satisfied, run `/zoo-squash` to prepare the patchset for pushing. This gives you options to squash all, only squash rework commits, or just tidy up the commit messages.
14. **You:** Run `/zoo-push` to rebase and push, or just `/zoo-rebase` if in doubt.


### Tips for reviewing the work

When the task ends, you get a report with screenshots of UI changes. Start from the spec file: **What happened** (bugs), then **How it works**, then **Report**.

Zoo 3.1 produces small, separate commits for subtasks when practical. You probably want to squash those before or after the review (depending on the size of the patchset) via Zoo Squash skill.


### Asking for revisions

To request a revision, run a Zoo skill again (`/zoo <revision request>`). It should recognize that it's a revision and continue working with the same spec and same task directory.

To add work while a task is running without derailing it, use Zoo Add (`/zoo-add <revision request>`). It records the ask and adds a ready subtask; it does not drop the current one unless the current work is actually harmful.


## Advanced use

* Zoo HR: update skills and customize Zoo workflows (instructions under `.zoo`)
* Zoo Spec Uberreview: call other installed agents to chime in on the current spec (choose specific agents via prompt, environment variable or instruction files).
* Zoo Docs: invoke manually to beat some new knowledge into the stupid machine's brain
* Zoo Cleanup Finished Specs: archive completed `.spec/*.md` files and resolved proposal files without deleting them
* Zoo Squash: squash and/or tidy up the unpushed commits.
* Zoo Rebase: `git pull --rebase`, resolve conflicts, retest; runs automatically at the end of each task
* Zoo Push: do Zoo Rebase then `git push` if safe
* Zoo Ensure Safe Deploy: waste some extra tokens finding potential deployment problems
* Zoo Upgrade Spec: bring old `.spec/*.md` files to the current task-file format without changing meaning
* Zoo Code Review: can invoke manually and specify the changes to review (“since v1.2.3”)
* Zoo Spec Review: can invoke manually on a task file
* Zoo Proposal: ask to write a proposal. “Later” on a Pending suggestion also writes one.

### Proposals

When Zoo reviewers want work way outside the current task, or you say “later” on a Pending suggestion, they write a proposal file under `.proposals/` for future consideration.

This is a way to keep security/modularity/etc reviews satisfied without blowing up the scope of simple tasks, but also without ignoring their findings.

Review these proposals occasionally, and see if you wanna execute them.


## Changelog

* Zoo 3.1 splits planning into high-level and low-level, adds cross-agent spec uberreviews, investigates bugs before planning a fix, queues mid-task discoveries/refactorings/bugs to put a stop to uncontrolled scope expansion, and adds Zoo Squash and Zoo Upgrade Spec skills
* Zoo 3 replaces Zoo Heavy/Lite/Zero with a single lighter workflow, introduces tiered reviews, drop bureau reports (for big token savings), and all steps share a single research file
* Zoo 2.3 adds Claude Code, proposals, final reports (Zoo Report skill invoked automatically when finishing tasks), Zoo Rebase, Zoo Push, and Zoo Ensure Safe Deploy skill (for manual invocation under `/goal` or `/loop`)
* Zoo 2.2 adds Uber Review to all Zoo flows.
* Zoo 2.1 refines Codex setup for GPT 5.5-xhigh, adds Zoo Lite and Zoo Zero workflows to reflect the preferred speed/accuracy balance of the smarter models, and is the first public release of Zoo 2.
* Zoo 2.0 is a reimagining of Zoo for Codex and the smarter GPT 5.4+ models. Introduces a spec file.
* Zoo 1.1 adds Bureau MCP for more consistent reporting.
* Zoo 1.0 is a Claude Code setup described in my blog post.


## License

Most of this is AI-generated and should be considered uncopywritable. But just in case, whatever is copywritable is © 2025-2026, Andrey Tarantsov, and is distributed under the [Zero Clause BSD](https://opensource.org/license/0bsd) license, which has no attribution requirements:

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
