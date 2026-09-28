<div align="center">

# Zoo 3.2

Reliable AI engineering workflow for complex projects
for Codex, Claude & Grok.

Specs • Scripted reviews • Uber-reviews • Staged planning • Browser use • Subtasks

[![License: 0BSD](https://img.shields.io/badge/License-0BSD-blue.svg)](LICENSE)

</div>

Zoo writes high-quality code while taking up as little of your focus as possible.

Principle 1: **Agents review and fix their shit before you have to deal with it.**

* Automated reviews at every stage of coding: spec, code, screenshots, task completion.
* Reliable project-specific checks via a review question generator script.
* Cross-agent uber-reviews for specs and final results.

Principle 2: **Designed for easy reviews.**

* A readable spec focused on reviewability, built in two stages.
* Builds a series of small commits designed for easy reviews, each explaining what it does, why that was needed, and why the prior state wasn't sufficient. (There's a squash skill to then reformat those into a pushable patchset with coarser-grained commits.)
* Final report analyzes the change set from multiple angles, including surprises (compared to the initial request) and deployment risks.
* Final report includes a screenshot of every UI change.

Principle 3: **Collaborative with a high level of autonomy.**

* User ultimately makes or confirms all important decisions.
* Review system designed to exhaust automatic research, planning and investigation capabilities before asking the user.
* Suggestion system: During review, and after a plan is finalized, larger or controversial automated review findings do not interrupt autonomous work, but also aren't automatically accepted, and are presented to you as a batch.

Principle 4: **High quality at a reasonable cost.**

* Targets high quality; designed for complex projects and reasonably large AI budgets.
* A carefully balanced amount of reviews and ceremony to spend budget where it makes the most difference.
* Saves tokens where possible by tweaking reasoning efforts in specialized subagents.

Workflow:

1. High-level spec (+ review and optional uber-review)
2. Low-level spec (+ review)
3. Implementation (per-subtask commits, screenshots, tests and scripted reviews)
4. Optional final uber-review.
5. User requests revisions and decides on pending suggestions

Features:

1. Spec format optimized for quick human review.
2. Cross-agent uber-reviews — use diverse intelligence at a low token cost.
3. Explicit subtasks result in reviewable commits with clear justifications.
4. Scripted reviews: a scout script generates relevant questions for the reviewer to answer.
5. Screenshots for any UI changes.
6. Parks extra discoveries as Pending suggestions (for later user approval) instead of hijacking the current commit; writes proposals for later/out-of-scope work.
7. Presents a readable report at the end.
8. Uses a research file to save tokens on re-researching the codebase.
9. Infused with pragmatic values of Linus Torvalds and Don Melton.

Zoo 3.2 is the current version of Zoo 3, the lightweight successor to Zoo 2 targeting the smarter models of mid-2026. See my posts for way more context on the idea:

* [Zoo 3.2 asks better questions](https://tarantsov.com/zoo-3-2/)
* [Zoo 3.1 fights scope creep and runs on Grok](https://tarantsov.com/zoo-3-1/)
* [Zoo 3, lean and mean](https://tarantsov.com/zoo-3/)
* [Meet Zoo 2](https://tarantsov.com/meet-zoo-2/)
* [All Star Zoo](https://tarantsov.com/all-star-zoo/)

Zoo skills are project-independent, customization is via `.zoo/*.md`:

- shared Zoo paths and general instructions go into `.zoo/zoo.md`
- scout script cli and review rules go into `.zoo/review.md`
- review questions are defined by your scout script
- planning instructions go into `.zoo/planning.md`
- project-specific browser testing instructions go into `.zoo/browser.md`
- project-specific testing instructions go into `.zoo/testing.md`
- and more; see [example .zoo files](.zoo/)

These will be generated for your project during Zoo Init.

You can also point `$ZOO_LOCAL_MD` at a Markdown file with your personal local instructions.


## If you're picking an agent for Zoo workflows...

1. Hot take: Grok produces the best day-to-day results by far. Reasonable, down to earth specs, no-drama implementation, just as good at browser use, and SuperGrok Heavy lasts for an entire week of heavy usage (whereas I had to previously juggle three max Codex accounts).
2. Claude Code + Opus 5.5 is likely second in quality here, especially if you use Codex for uber-reviews.
3. Codex + GPT 6 Astra is great at implementation and computer use, but its specs still leave much to be desired in terms of readability. It is wickedly smart, though, and best at reviews.
4. I plan to try DeepSeek and GLM models soon too.


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
4. **You:** For a complex or high-stakes feature, ask for uber-review in the initial prompt or at approval, or run `/zoo-spec-uberreview`.
5. **You:** Review and approve the high-level spec.
6. Agent expands spec with lower-level details like naming, error handling, per-package change summaries, subtask split, letting you review the small details.
7. **You:** Review and approve the full spec — say `Go` or `Approved`, or even `/loop Go. Execute until done or approval needed. Use zoo skill.`
8. Agent executes each subtask, captures UI evidence, runs tests and reviews, then commits.
9. Agent collects mid-task extras (scope expansions, extra code changes, unrelated bugs) under **Pending suggestions**.
10. When implementation is complete, agent runs final uber-review if enabled. It explains all findings and recommendations before asking you to decide on each. Approved fixes become subtasks. Closeout follows once subtasks and pending suggestions are resolved.
11. **You:** Review the resulting code, approve/reject/clarify suggestions, request revisions.
12. Agent executes revisions as separate subtasks, and presents a report again.
13. **You:** When satisfied, run `/zoo-squash` to prepare the patchset for pushing. This gives you options to squash all, only squash rework commits, or just tidy up the commit messages.
14. **You:** Run `/zoo-push` to rebase and push, or just `/zoo-rebase` if in doubt.


### Tips for reviewing the work

When the task ends, you get a report with screenshots of UI changes. Start from the spec file: **What happened** (bugs), then **How it works**, then **Report**.

Zoo produces small, separate commits for subtasks when practical. You probably want to squash those before or after the review (depending on the size of the patchset) via Zoo Squash skill.


### Asking for revisions

To request a revision, run a Zoo skill again (`/zoo <revision request>`). It should recognize that it's a revision and continue working with the same spec and same task directory.

To add work while a task is running without derailing it, use Zoo Add (`/zoo-add <revision request>`). It records the ask and adds a ready subtask; it does not drop the current one unless the current work is actually harmful.


## Advanced use

* Zoo HR: update skills and customize Zoo workflows (instructions under `.zoo`)
* Zoo Spec Uber-Review: call other installed agents to chime in on the current spec (choose specific agents via prompt or instruction files like `.zoo/review.md` or `$ZOO_LOCAL_MD`; for Spec Uber-Review; I recommend running it in all the agents you have access to — Claude, Codex, Grok, Gemini, GLM, Deep).
* Zoo Ensure Safe Deploy: final task review that considers the entire changeset focusing on regressions and deployment safety; these days, proven to be the perfect final review approach;
* Zoo Final Uber-Review: runs `Zoo Ensure Safe Deploy` in uber-review agents (when running outside Codex, I recommend running this in Codex only; when running inside Codex, I recommend using Codex and one other agent); findings become suggestions for your approval.
* Zoo Tweak Reviews: create or improve the project's scout script — add/migrate/tweak review questions, fix recurring false positives.
* Zoo Undo Change: undo a completed change back to the exact prior code, preserving desirable remaining changes.
* Zoo Docs: invoke manually to beat some new knowledge into the stupid machine's brain
* Zoo Cleanup Finished Specs: archive completed `.spec/*.md` files and resolved proposal files without deleting them
* Zoo Squash: squash and/or tidy up the unpushed commits.
* Zoo Rebase: `git pull --rebase`, resolve conflicts, retest; runs automatically at the end of each task
* Zoo Push: do Zoo Rebase then `git push` if safe
* Zoo Upgrade Spec: bring old `.spec/*.md` files to the current task-file format without changing meaning
* Zoo Code Review: can invoke manually and specify the changes to review (“since v1.2.3”)
* Zoo Spec Review: can invoke manually on a task file
* Zoo Proposal: ask to write a proposal. “Later” on a Pending suggestion also writes one.

### Scripted reviews

The scout is a project script configured by the `Scout:` line in `.zoo/review.md`. It generates a numbered question list, including potential rule violations and questions tied to relevant changed code.

Scout is optional; if missing, Zoo will use a built-in list of generic review questions. It is highly recommended, though. We supply `/zoo-tweak-reviews` skill to create and update the scout script and the questions it contains.

Scout checks can be as simple as:

```go
if sc.IsPlanning() {
	sc.Ask("Is there a simpler end-to-end design that still meets the need?")
	sc.Ask("Is a business rule spread across many planned pieces as an emergent property? Can it be concentrated?")
	...
}
```

a bit more elaborate:

```go
if sc.IsModified(permissionDefFiles) {
	sc.Ask("Holds? A new permission is placed in the lowest semantically-correct macro per the placement decision tree (e.g. customer view -> MacroCustomerView) and belongs to at least one macro, not over-escalated into a broader macro than the capability warrants.")
}
```

or insanely specific like:


```go
sc.AskGo("no-debug-print", prodGoFiles,
	"Production code should not gain stray debug prints or stdout log spam. OK: user-visible CLI output, structured logging.",
	spotNodes(func(pass *analysis.Pass, file *ast.File, n ast.Node) bool {
		call, ok := n.(*ast.CallExpr)
		if !ok {
			return false
		}
		full := calleeFullName(pass, call)
		return full == "fmt.Print" || full == "fmt.Printf" || full == "fmt.Println"
	}),
	`<example input and expected output goes here>`,
)
````

Scout only prints the questions; Zoo skills run a reviewer subagent (or external agent) to answer them.


### Uber-reviews

Uber-reviews run across agents, allowing you to bring a diverse set of perspectives for your planning, and to use the smartest models for one final review pass.

Zoo has two kinds of uber-reviews:

* Spec Uber-Review optionally asks other agents to review the spec before presenting it to you.
* Final Uber-Review executes a very different “ensure deploy safety” prompt that has proven itself as a great way to review final changes. This focuses on the entire changeset, unlike normal code reviews which run per subtask.

Uber-reviews are sticky: ask for it once, and the task is marked as `uberreviews: true` and will run the final uber-review as well.

Uber-reviews are _not_ run in a loop; there is only one round at each point. You can rerun `/zoo-spec-uberreview` or `/zoo-final-uberreview` manually if you want.

Zoo does not blindly accept all reviewer suggestions. Only uncontroversial small spec changes are autoaccepted; everything else is presented for you to decide.


### Proposals

You can ask Zoo to delay certain desirable suggestions by writing a proposal file under `.proposals/`. Review these proposals occasionally, and see if you wanna execute them.


## Changelog

### Zoo 3.2

* Replaces old tiered check agents with scout-driven scripted reviews, and adds Zoo Tweak Reviews to modify the scouts.
* Adds Zoo Final Uberreview.
* Adds personal overrides through `$ZOO_LOCAL_MD`, including uber-review agent selection.
* Uber-review tweaks: sticky task option; adds OpenCode/Gemini support, updates models, allows retrying failed agents.
* Improves review recommendations with broader and narrower fixes when a deeper design flaw is confirmed. Compatibility reviews compare against pushed or deployed code rather than intermediate unpushed edits.
* Centralizes review configuration in `.zoo/review.md` and moves all questions into the scout.
* Adds Zoo Undo Change for restoring the exact code before an unwanted change.
* Symlinks `.claude/skills` to `.agents/skills` where possible.
* Improves terse writing and the “How it works” walkthrough, embeds screenshot references in reports, and preserves extra spec metadata during upgrades.


### Earlier versions

* Zoo 3.1 splits planning into high-level and low-level, adds cross-agent spec uberreviews, investigates bugs before planning a fix, queues mid-task discoveries/refactorings/bugs to put a stop to uncontrolled scope expansion, and adds Zoo Squash and Zoo Upgrade Spec skills
* Zoo 3 replaces Zoo Heavy/Lite/Zero with a single lighter workflow, introduces tiered reviews, drops bureau reports (for big token savings), and all steps share a single research file
* Zoo 2.3 adds Claude Code, proposals, final reports (Zoo Report skill invoked automatically when finishing tasks), Zoo Rebase, Zoo Push, and Zoo Ensure Safe Deploy skill (for manual invocation under `/goal` or `/loop`)
* Zoo 2.2 adds Uber Review to all Zoo flows.
* Zoo 2.1 refines Codex setup for GPT 5.5-xhigh, adds Zoo Lite and Zoo Zero workflows to reflect the preferred speed/accuracy balance of the smarter models, and is the first public release of Zoo 2.
* Zoo 2.0 is a reimagining of Zoo for Codex and the smarter GPT 5.4+ models. Introduces a spec file.
* Zoo 1.1 adds Bureau MCP for more consistent reporting.
* Zoo 1.0 is a Claude Code setup described in my blog post.


## License

Most of this is AI-generated and should be considered uncopyrightable. But just in case, whatever is copyrightable is © 2025-2026, Andrey Tarantsov, and is distributed under the [Zero Clause BSD](https://opensource.org/license/0bsd) license, which has no attribution requirements:

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
