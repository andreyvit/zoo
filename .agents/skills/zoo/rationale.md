# Zoo design rationale

For humans and AIs *modifying* this skill. Not workflow instructions — the executing agent must not load this file. Record the why behind every non-obvious rule here so changes don't silently break the reasoning.

## Why Zoo 3 Exists

- (USER) Zoo 3 replaces the old Zoo workflows rather than living beside them.
- Old Zoo Heavy runs ~22 cold subagents and writes ~20 Bureau reports per subtask. The dominant cost is context reconstruction: each subagent re-reads the spec, plan report, and all later reports. The reports exist mostly to feed the next cold agent — that is the file sprawl and the wall-clock.
- Old Zoo runs 16 broad agentic reviewers per subtask (8 plan uberreview + 8 code uberreview), each free to explore the codebase.
- Zoo 3 attacks both: one shared research file + one scripted reviewer per gate + no step reports. Skipping specs and reviews was explicitly rejected — they trade machine time for human time in the wrong direction. The goal is keeping their value while deleting the reconstruction overhead.

## File layout

- Task file lives in `.spec/` (tracked): it is the collaboration artifact and the cold-resume point. `status:` frontmatter lets humans and tooling see task state at a glance.
- Research and evidence live in `.tasks/` (gitignored): machine-scale content with no review value in git history.
- Spec-review questions are a temp markdown file outside the repo. They are per-round prompt scaffolding, not research or evidence. The template is `zoo-spec-review/references/questions-file.md`. Name the skill in that path; "this skill's `references/`" is ambiguous when zoo and zoo-spec-review are both loaded. Create the file with `mktemp "${TMPDIR:-/tmp}/zoo-spec-questions.XXXXXX"`: BSD `mktemp` only replaces trailing X's, so `.XXXXXX.md` writes the template name literally.
- The research file is the substitute for context forking, which Claude Code does not have (subagents start cold; SendMessage continuation is serial, so it can't power parallel fan-out). File + inline diff replace re-research.

## Task file is never auto-committed

- (USER) The workflow never commits the task file; the user commits it manually if and when they want.
- History: the first design auto-committed every task-file change as its own separate commit — never mixed with code — so code commits could be rebased/merged/moved without spec-file conflicts, with the intent to squash before push. That collided with "log every event" (several spec-only commits per subtask) and dragged in squash mechanics nobody needed. Never-auto-commit keeps the conflict-freedom and deletes the machinery.
- Consequence: the task file sits modified in the working tree for the task's whole life. Code commits must exclude it, and Log lines are written to it the moment events happen — there is no commit checkpoint to batch for.

## Rebase preserves dirty work

- (USER) zoo-rebase stashes tracked and untracked edits before pulling, then restores only its own stash. Zoo itself dirties the tracked task file before rebase, and users may have unrelated work; dirty state must not block closeout.
- If rebase cannot finish, abort it before restoring the stash. If restoration fails, keep recovery data and report unsafe so no user work is discarded.
- Validate before restoring the stash so unrelated edits cannot cause failures attributed to incoming commits.
- Restored changes intended for upstream may still make push unsafe, but they never block rebase.

## Code Summary

- (USER) Review Git diffs by voice, commit by commit: package layout, then production, tests, tooling, docs. Group repeated production changes; keep exact differences.
- Keep summary directly after Report in the task file. Fill after all commits and closeout rebase so hashes and diffs match reviewed history. Reopened execution makes it stale until next closeout.
- zoo-summarize-code is manual or Zoo-invoked only. Template owns placement; skill owns outline format. Existing spec upgrades inherit the section from the template.

## Log section

- One line per event, everything that happens. Replaces old Zoo's Execution memory and all step reports: it is the memory a cold session resumes from, and the record for debugging the workflow itself.
- (USER) zoo-squash, rebase, and push are closeout mechanics, not task
  history. Logging them dirties a finished spec immediately before publication
  without helping cold resume. Skip them. Likewise, skip routine mistake-log
  entries during closeout; if a serious reusable mistake warrants preservation,
  fold the entry into a relevant task commit before push.

## Zoo Squash prepares the push history

- (USER) zoo-squash is manual only. Closeout does not invoke it. User chooses
  flatten, format a patchset, or rewrite messages. Ask unless the prompt
  already named the approach. `squash` names flatten; `presquash` names
  format patchset.
- During ordinary execution, later discoveries get later commits. Zoo does not
  amend or rewrite completed subtask commits unless the user explicitly asks.
  This keeps hashes stable while the user reviews or lands work.
- (USER) Review findings and manual revisions create follow-up subtasks and
  commits. Format patchset folds that correction chronology into the commits
  whose behavior it finalizes, then wraps the group as WIP commits plus a
  final commit that describes the whole changeset. Preserve independently
  reviewable design steps, not Zoo's implementation scaffolding.
- No recovery branch; reflog is enough. Same as other closeout mechanics: do
  not log to the spec.

## Scripted review

- (USER) Every question-driven review is a scripted review: one reviewer answers one numbered list. The old term "broad review" is gone.
- (USER) Final name: scout. Earlier names: review question generator, then spotter.
- (USER) The scout (named in `.zoo/review.md`) generates ALL review questions. Mode flags: none (implementation), `-highlevel-plan` or `-plan` (spec review), plus `-uber` (cross-agent; alone for the final uber review). Plain questions per mode, gated ones only when matching code changed. It prints numbered questions, many with `path:line` (rule violations as `Violation? <message>`), or `NO QUESTIONS`; it never runs agents and never prints diffs. It replaced a separate "scripted check" step with tiered check agents (zoo-check-fast/smart/smartest, deleted).
- (USER) Scout findings merged into questions as `Violation? <message>` items: the reviewer got them anyway; one list, one concept.
- (USER) No suppression comments in code. False positives get fixed in check code; meanwhile the reviewer answers OK with why.
- (USER) Skill question lists are fallbacks for repos without a scout, kept in each review skill's `references/fallback-questions.md` (rarely needed). Question sections in `.zoo/review.md` (and older `planreview.md`/`codereview.md`) are legacy: zoo-tweak-reviews moves them into the scout.
- (USER) Uber reviews run the scout with `-uber`; the scout decides what, if anything, cross-agent review asks. Spec review adds its own 5-10 spec-specific questions after the scout's list.
- (USER) zoo-tweak-reviews updates the review setup and creates a scout if missing, per its reference design. While working on the scout, skills, or review system: never call the scout, never run broad project tests, no Zoo workflow; reviewer subagent and commit after each change.
- (USER) Pushed-codebase rule: unpushed code can change freely; judge deletions and edits against the pushed codebase, not the diff's prior state. It lives in the zoo-reviewer role files, the spec-review reviewer rules, and zoo-ensure-safe-deploy's baseline, not in scout questions: it applies to every review question. Replaced the scout's pushedPointRubric.
- Mechanical rules migrated into the scout are enforced on every gate with no reviewer needing reminding. That is the long-term destination for mechanically checkable AGENTS.md rules.
- (USER) Protect two boundaries. First, keep each subtask and commit cohesive and
  reviewable: work can fit the overall task yet still need a separate subtask.
  Second, let the user judge changes or extensions to the overall task before
  implementation. This avoids both bloated commits and work the user later
  needs to undo.
- Use judgment rather than literal rules or examples. Size, reach, risk,
  alternatives, and review/deployment value inform routing; none decides alone.
  A problem caused by active work can still need a separate subtask.

Code review still classifies silently because mid-execution interruptions are
expensive. The orchestrator records task-internal subtask splits, unrelated bugs,
and task extensions immediately, continues independent remaining work, then
presents all open Pending suggestions in one round.

Zoo preserves useful progress. Finish the active subtask or a
meaningful subset and record known limitations, even when security, performance,
rollback, or similar issues make it non-deployable. Skip the active subtask and
its dependents only when no meaningful, useful result fits current scope
without significantly changing it. Continue independent remaining subtasks.

## No per-subtask approval field

- (USER) Undecided work lives in `Pending suggestions`, not as a pending
  subtask. A subtask in `## Subtasks` is ready to run. Accepting a Code change
  adds that subtask and execution may start; no second approval.
- Later means write a proposal file. Do not keep a Later parking lot separate
  from proposals.
- Spec status reports exact execution position. Example:
  `completed subtask 5; awaiting decision on Pending suggestions`.
- (USER) Record pending suggestions when discovered, while evidence is fresh.
  Use the short Code changes form. Present each item and ask what to do.
  After a decision, move it out. Do not keep decided items in the section.
- Defer suggestion interruptions. Finish independent remaining subtasks, then
  ask once no subtask can proceed. Do not enlarge the active subtask merely
  because a finding fits the overall task or active work caused it.
- Unrelated bugs found in tests or review also enter this queue. The user decides
  whether to accept (new subtask), reject, or write a proposal.
- The checkpoint performs partial closeout: finish completed work,
  update How it works, Scope, Report, High-level plan, and Low-level plan,
  present them with open Pending suggestions, and never claim the task is done.
- `references/change-or-suggestion.md` owns immediate classification, recording, and
  continuation. `references/reapproval.md` runs only after remaining subtasks run
  out; it owns partial closeout and suggestion decisions. Combining them made
  discovery-time guidance arrive too late.
- Scope handling belongs inside Zoo, not a standalone skill.
  It depends on the active task, subtask, and commit boundary;
  the standalone skill duplicated policy and obscured timing.

## Model doctrine

- Strong models where trust concentrates.
- The research file is trusted downstream *without verification* — errors propagate into the implementation and every reviewer prompt, and nobody is positioned to catch them (catching them would mean redoing the research). This sets a floor on researcher model quality, not a mandate for the top tier.
- (USER) Researchers run on `smarter` (opus), not `smartest`: research is traversal and distillation of *existing* code, not novel design, so the second tier is judged sufficient. The trust-concentration argument means never go below `smarter`. If research-quality problems show up in practice (wrong pointers, misread patterns), bumping researchers to `smartest` is the first knob to try.

## Predefined agents

- Three agent definitions (`.claude/agents/zoo-researcher.md`, `zoo-reviewer.md`, `zoo-browser-verifier.md`) instead of narrating roles in the skill: standing instructions move out of the skill and out of every per-call prompt, models are pinned in frontmatter, and role behavior stops varying between runs.
- Anti-drift rule: each role's instructions live ONLY in its agent file; SKILL.md names roles and never restates their rules. Old Zoo described each role in three places (agent file, `zoo-*` skill, orchestrator skill), and they drifted — that is the failure mode to avoid.
- Three, not nine: old Zoo's agents exist largely to relay workflow state through Bureau reports; these exist to deduplicate standing instructions and pin models. Thin or one-off roles don't get a definition — a deep follow-up investigation is zoo-reviewer with a pointed question.
- Browser verification uses zoo-browser-verifier plus zoo-browser-verification.
- (USER) Researchers return findings as output instead of writing files; orchestrator is sole research-file writer. This kills the parallel write-race (earlier design used per-researcher part-files merged with `cat`) and forces orchestrator to read research, useful for spec writing. Cost: research content passes through orchestrator context once.
- Agent definitions live in `.claude/agents/` but are not Claude-only in practice: they are plain readable instructions, so other harnesses use them via general subagents told to follow the role file.
- The skill has no Subagent rules section. Audit verdict: model doctrine is maintainer knowledge (this file + agent frontmatter — the harness applies pinned models, the orchestrator does nothing with them); no-broad-suites lives in the agent files of the agents that could violate it; old Zoo's no-recursive-spawn rule guards a hazard Zoo 3 lacks (agents get tiny role prompts, not orchestration skills). The single orchestrator-side duty that survived — prompts carry only specifics, never restate agent-file instructions — is one line in the skill intro.

## Just-in-time skill loading

- (USER) The review gate lives in zoo-code-review, invoked from the inline
  subtask loop in SKILL.md, so gate text re-enters context fresh each pass.
  The main skill, loaded at the start of a long run, is the first thing
  summarization degrades.
- Closeout is `references/closeout.md`, not a skill. The subtask loop is
  inline in SKILL.md and unnumbered. There is no zoo-subtask or zoo-closeout
  skill.
- (USER) Runtime skill brevity is a requirement: every added sentence must change behavior, remove ambiguity, or earn deletion elsewhere.
- (USER) Extracted skills are independently invokable (e.g. zoo-code-review on any diff, no task file needed). Each carries a one-paragraph guard — you are not the orchestrator, execute only this step, never start the full Zoo workflow. Because standalone runs don't load the main skill, the guard paragraph also carries a one-line voice note; that duplication is deliberate.

## Project independence

- (USER) Core Zoo skills carry no project specifics; `.zoo/` is the project customization folder. The skills state generic defaults and read `.zoo` files when they exist:
  - all Zoo skills: `.zoo/zoo.md` — general overrides: file locations, ticket tooling, `MISTAKES.md` path
  - review skills (code, spec, uber, safe-deploy): `.zoo/review.md` — the scout command, review-wide rules
  - spec writing (main skill): `.zoo/planning.md`; intake runs `.zoo/task-start.md`
  - (USER) Ticket-in-progress lives in both `task-start.md` (planning start) and `subtask-start.md` (subtask start / resume). Long breaks are on subtask boundaries, so resume starts a subtask.
  - zoo-spec-review: `.zoo/planning.md`
  - subtask loop (in SKILL.md): `.zoo/subtask-start.md`, `.zoo/coding.md`, `.zoo/testing.md`, `.zoo/browser.md`
  - closeout (`references/closeout.md`): `.zoo/testing.md` for validation; `.zoo/task-finish.md` may skip/replace zoo-rebase; `.zoo/closeout.md` adds final report/chat rules if it exists
- (USER) Repo review questions live in the scout, not `.zoo/` files. `.zoo/review.md` condition-headed question sections (which replaced `.zoo/planreview.md` + `.zoo/codereview.md`) were folded into the scout's mode conditions.
- (USER) `.zoo/review.md` holds review config, not questions. The `Scout:` line moved there from `.zoo/zoo.md`.
- (USER) Core Zoo skills say `MISTAKES.md` only; repo-specific path belongs in `.zoo/zoo.md`.
- (USER) Follow `.zoo/zoo.md` and file at `$ZOO_LOCAL_MD` if exists

## Review questions

- (USER) Reviewers emit suggestions, not routing. All findings go through
  `references/change-or-suggestion.md`, including scripted and visual review.
- Converted this repo's scout Tier 5 lenses into code-review
  questions, merged into fewer high-level items. Taste review is the Zoo
  scripted review; all its questions now come from the scout.
- (USER) A plain scout question must not restate a gated one: the gated
  one joins the same list when its code changes.
- (USER) Spec/plan questions only ask things a spec would record (How it
  works, Responsibilities, UI, settings, tests, performance). Drop code-only
  conventions such as `bonav.Define()` / `ta.Invoke`; those stay in
  `.zoo/coding.md`, `.zoo/testing.md`, and gated scout checks.
- Last question asks for other significant improvements after a careful
  read of all modified code (or the whole spec).

## Spec review

- (USER) zoo-spec-review runs twice: after the high-level plan, then after the low-level plan including subtasks. Analyze the current stage from all angles, fix obvious uncontroversial problems directly, punt product decisions plus important or controversial/unclear technical decisions to the user, loop (update spec → re-review) until a clean pass.
- This is old Zoo's planner → plan_reviewer → plan-uberreview chain collapsed into one fix-or-punt pass; the key inversion is that real decisions go to the user instead of being review-round-tripped between agents.
- High-level review must not demand Low-level plan or Subtasks. Low-level review checks split, coverage, and match to the approved high-level plan. Material ideas go in `Pending suggestions` (Scope expansion, Spec improvements, Code changes). Present each item and ask. After a decision, move it out. Scope expansion and Spec improvements must be empty before execution.
- (USER) Subtask splitting protects reviewability: split unrelated features and clean incremental steps unless task file records a good reason to keep them together. Avoid fake progress micro-subtasks; each subtask adds a meaningful functionality step.
- (USER) Every change belongs to a subtask. Drive-by edits hide work from approval and review. Add a subtask before changing code. Tiny user-requested updates may share one subtask; otherwise keep each subtask focused.
- (USER) zoo-revision handles revision requests after spec approval, implicitly or explicitly. The request authorizes the work: add/amend future subtasks, default to the end, queue behind active work, otherwise start Zoo execution. Preserve validation/reviews/commits; never implement revisions outside the workflow.
- (USER) Refactorings and global/cross-cutting mechanism changes get separate
  subtasks and commits. Planning identifies prerequisites early. Late
  discoveries do not automatically interrupt execution: finish a desirable
  simpler path and defer the wider change when possible; otherwise
  pause dependent work and continue independent remaining subtasks.
- The rename zoo-review → zoo-code-review exists for naming symmetry with this skill.
- (USER) The review itself runs in a subagent, not the orchestrator: fresh eyes, no anchoring on its own draft. The orchestrator keeps the fix-or-punt role and verifies findings against code before acting.
- (USER) Questions go to a temp markdown file outside the repo. The prompt names task file, research file, stage, and that questions path. The same prompt and file feed a subagent or external CLIs (zoo-spec-uberreview), so the two skills cannot drift.
- The old `Check:` list (omissions, contradictions, reality, scope extensions, subtask split) became scout planning questions (fallback list 7–11) so the reviewer answers them `OK`/finding like the rest; the split question asks only with `-plan` (with or without `-uber`) (fallback: `(low-level stage only)`).

## Two-stage planning

- (USER) Jumping from research to a full spec and subtask split wastes the user's
  attention on low-level detail before the direction is settled. Stage 1 fills
  How it works, Scope, and High-level plan only. Chat shows the full How it works
  plus a short summary of scope and high-level plan. Iterate until explicit
  high-level approval. Stage 2 then fills Low-level plan and Subtasks.
- Sequence: high-level → spec review → (if marked) spec uber-review once → low-level including subtasks → spec review → (if marked) spec uber-review once.
  Investigate asks run `references/investigate.md` after research and only then
  enter high-level if the cause is a code bug.
  Old sequence (settle whole spec → review → split) hid split problems from spec
  review and asked the user to approve a wall of detail.
- Status must say the stage: `building high-level plan` or
  `high-level plan approved, building low-level plan`. A high-level draft is not
  approval.
- Significant How it works / Scope / High-level plan changes need user approval.
  During execution they go in `Pending suggestions` → `Code changes` and wait for reapproval. Filling
  in more detail or recording what was actually built is an update, not a
  direction change.

## Spec format upgrade

- (USER) `zoo-upgrade-spec` brings old task files to the current
  `references/task-file-template.md` shape: missing sections, order, heading
  names. It is format-only. It must not weaken status: `done` stays done;
  approved high-level stays approved; checked subtasks stay checked. Old
  `Approval: pending` was never approved, so that item may move to Pending
  suggestions. Independently invokable; not part of the execute loop.

## Living spec sections

- (USER) Spec and Report used to duplicate subsections. Things the user wanted
  before implementation lived only in Report. There is no single Report dump
  anymore. How it works, Scope, Report, High-level plan, and Low-level plan stay
  current in both planning and execution.
- Report is now status, screenshots, remaining work, and the ticket guide.
  How it works is the durable dev-facing explanation from the first high-level
  draft through closeout.

## Inline subtask technical specs

- (USER) A separate Subtask Technical Specs section split the work from its
  spec. Keep that subtask's technical spec under the subtask.

## False positive or rejected review findings

- (USER) Reviewers re-raised findings the user or task had already rejected.
  Recording those in source pollutes production code with task-local review
  opinions. List them in the task file. Skip them on later review rounds.

## Collaborative spec

- Moves human steering from "wait 90 minutes, then request revisions" to batched
  approval rounds. First the high-level plan, then the subtasks after the
  low-level review. Later rounds cover discoveries implementation could not
  reasonably predict.
- AskUserQuestion with concrete options, recommendation first, consequences spelled out.
- `What happened` exists for bugs and investigations because product/technical specs are not enough to understand why the work matters. It forces the investigation narrative into the task file: bad behavior, mechanism, impact, regression status, and attribution/timing when knowable. It is explicitly skipped for tasks where that narrative would be noise.
- (USER) An investigate ask (bug, client problem) is not a request to plan a fix first.
  Deep investigation and a filled What happened are the work. Classify code bug
  vs configuration/human/usage. Only a code bug continues into high-level
  planning. A usage or config finding stops at `investigation complete`; do not
  invent a code plan. `references/investigate.md` owns that branch.

## Voice

- Linus Torvalds in nasty cynical mood + Don Melton's "Is it right?" focus. Applies to chat and the final report only; specs, commits, code, docs, and subagent prompts stay dry.
- The "every insult must carry specifics" rule is load-bearing: it is what prevents the voice from degrading into substance-free theatrics.

## Harness notes

- (USER) Skills are dual-harness: every gate step is a plain subagent or a shell command, so both harnesses run the same gate.
- The agent role files under `.claude/agents/zoo-*.md` are the cross-harness source of truth: harnesses without registered agent types launch general subagents that follow the role file first. AskUserQuestion degrades to plain chat questions where unavailable.
- (USER) Codex has registered functional copies: `.codex/agents/zoo-*.toml` with the same instruction bodies. Skills live once, in `.agents/skills/`, shared by both harnesses. Model-tier mapping in Codex terms: researcher `smarter` → `model_reasoning_effort = "high"`, reviewer (session-strongest) → `"xhigh"`. When editing a Claude agent, update its `.codex/agents` copy in the same change.
- zoo-init initializes `.zoo/zoo.md` alongside the Zoo files (step 8 + Files list), so new repos get Zoo customization from the same init pass.

## Open items

- Grow the scout whenever a review question can be gated on matching code.

## Cross-agent uber-review

- (USER) "Uber-review" means cross-agent review. Spec uber-review: zoo-spec-review plus the same questions in other harness CLIs. Final uber-review: zoo-ensure-safe-deploy in every agent after the whole task is done. The old word meant the question-list pass; that pass is now the scripted review in zoo-code-review and zoo-spec-review. Uber reviews add scout items from a `-uber` run.
- (USER) Spec frontmatter `uberreviews: true` when the user asks for uber-review or the prompt says so. Automatic uber-review is once per stage: one HL spec uber-review, one LL spec uber-review, one final when the whole task is done. After, not instead of, spec review. Do not re-run after addressing findings. Extra reruns only if the user asks (`/zoo-spec-uberreview`, `/zoo-final-uberreview`, or an approval-option rerun). Asking those also sets the mark.
- zoo-spec-uberreview does not duplicate zoo-spec-review: it loads it and adds other-harness CLIs beside the subagent. Questions, prompt, acting on findings stay in zoo-spec-review.
- (USER) Other-harness CLI invoke is not a skill: it is not independently invokable. It lives in `zoo-spec-uberreview/references/invoke-uberreview.md`. zoo-final-uberreview reads that file. Do not copy command lines into the two review skills.
- (USER) The agent list is per-user, not per-repo: explicit ask > `$ZOO_LOCAL_MD` > per-user instructions > PATH autodetect (`claude`, `codex`, `grok`). OpenCode is opt-in: installation alone must not enlarge the review fan-out. Own harness uses a local subagent only if included in the selected reviewer list; exclude it from CLI calls. Never add self as a fallback.
- (USER) One-shot prompt mode, yolo permissions, no stored sessions where supported, so reviews do not stop on permission prompts or needlessly litter session lists; the prompt forbids changes. Verified 2026-09-03: `claude -p --no-session-persistence --dangerously-skip-permissions` (2.1.197); `codex exec --ephemeral --dangerously-bypass-approvals-and-sandbox` (0.148, bundled in ChatGPT.app on macOS — the `codex` PATH symlink dangled after the Codex.app → ChatGPT.app move, hence the fallback path); grok 1.0.5 and OpenCode 1.18.27 have no no-persist flag, so their sessions stay.
- `code_mode_host` is the bundled Codex tool runner (stable, on). The host binary lives next to `codex` in ChatGPT.app. A PATH symlink of `codex` alone makes tools look for `codex-code-mode-host` beside the symlink and fail closed; chat still works. Symlink the host next to PATH `codex`. `--disable code_mode_host` does not fall back to a normal shell.
- (USER) CLI findings come from command stdout. The harness already captures it. Claude, Codex, and Grok were all redirected to `.tasks/…-spec-review-<agent>.md`; Codex also used `-o` and discarded stdout. Read stdout. Codex's last `codex` block and OpenCode's final assistant response are the findings. Omit OpenCode `--thinking` and `--print-logs` to keep its stream clean.
- Not the built-in review modes (`codex exec review`, `claude ultrareview`): they review diffs, not specs, and drop the question list.
- (USER) Uber-review pins: Claude `claude-opus-5-5`, Grok `grok-4.7`, and Codex `gpt-6-astra`, all at `xhigh` (USER, 2026-09). OpenCode stays at Gemini 3.8 Flash / `max`. Pins rot; `invoke-uberreview.md` says where to look up replacements.
- (USER) OpenCode is an explicit exception to strongest-model selection: pin `google/gemini-3.8-flash` with `--variant max`. Include it only when named by the user, `$ZOO_LOCAL_MD`, or per-user instructions.
- (USER) Final uber-review findings all become Pending suggestions. Uncontroversial problems should already have been found in spec review, subtask review, and tests. Fixes after the whole task is done meet a higher bar and may need a higher-level response (spec, redo, restart), not a silent local patch. Orchestrator does not auto-fix. User approves each. Each accepted fix is a Zoo subtask. Do not auto-rerun final uber-review after those subtasks.
- (USER) Final uber-review lists and explains every finding in chat, with recommendations, before asking about any item. Item-by-item asks without the whole picture hide shared spec/approach flaws.
- (USER) zoo-ensure-safe-deploy, after the finding set is stable, considers whether findings show a deeper spec or approach flaw. Only if that flaw is confirmed: optional deeper remedy (improve spec, redo part, restart with a modified approach) plus a narrower alternative (one narrow, or narrowest plus narrower). User chooses width. Do not invent wider rewrites for ordinary local bugs.

## Monitoring

- (USER) Keep metadata rules in the main Zoo skill and receipts beside the steps that emit them. No separate monitoring contract. Preserve existing spec prose; keep instructions short.
- Specs describe stage; receipts describe events; runtime observations describe activity/questions. Git-operation receipts keep finished specs clean. Legacy migration belongs in zoo-upgrade-spec; missing revision rounds start at zero.
